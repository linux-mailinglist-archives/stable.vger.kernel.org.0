Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80659509DCA
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 12:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388467AbiDUKlD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 06:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388464AbiDUKk7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 06:40:59 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97216255BA
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 03:38:10 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23L9o2Zn007810;
        Thu, 21 Apr 2022 10:38:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=UnxfAYQGeJIGxk5rl81Y7Uq+xEuC3mu+iGTG/i9Bj4M=;
 b=XDmwdV/86s8QFUVu1pHPVzmER8fEb/2p1B8lSwlfT6sZ+Gq9jP0YztheeNsXMeq6sO75
 Zo2v8ooaXsSmMtdY1NAYc8RXdXMyBMl9VKaUCF7XrUL9Lqi3/ANobBugXyy/177nx2oG
 CB65F0ljrbZQNWk0AvjJnBVeYKEtLwoO8482l0Iq84j+lQcd7BbeuoTOatUSrJbQMuSY
 4Zr7axmzJAQQwBPc+tvJo1cqI+laNr8rQwDtpeJ79we7EDPsX+IQiFApyuW6uSram0s1
 XNJDwI+G631JAY5Sb03/LDjFn1ZHvTLbhFX2o/LJDupue7vDk1d8C/TbXUmegehuQGoR FA== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3ffpqn3qyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 10:38:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YXbLSEWJLHIiM8s84qf5YneSnwDNQiMOaIDKVvtuaDs9sSyQAUp3xJcDKRQOUaWecE9XHrvmaQj1dm2db+DJCWsd7zA6HdqE82VO0/+rXrnbyl2vQZZOzXm6qzkkUpwTy2PIrN2f+GF3XvLirPYYWgqPw9yvXnxY7TosuRZaZjTWQA40OF7Ezd8mCVskEYOLnwiCBcaZFauFK2YCyfJ9gVHgrZoA0X8tY6DVFIfNBIr3H9S9LlBcKprJcUmSPbr/wXdRwbWh72SD4tRf9xZrf4H2XPTZgd520Ugs3fj71a3n1NY8zMuJB+ZsS2bVYj3oH1iyW2F74EmWDDSJMiP6gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UnxfAYQGeJIGxk5rl81Y7Uq+xEuC3mu+iGTG/i9Bj4M=;
 b=KcQsIfUFVDjKAI5q8Wzskht+hkB4sN+kUAbdQ5JAZSyLdFBx1TiB+/F+7Q/9J/kupTf8fxNgDTicsWOGHUmC25bgcTaH88+RbrUKqkpmDJiWJsIMaMDn6R6HE3gx8WBtZfXERC0UhO2wNKOjtmeKqZaPKBsk7G7cBkC5sY0yK7080FRcqVCfxu2l4969/AJvJTUYY9v+shwMIiXj5vPDAjaR5+l3DZVS8JaqP9+G69MlLpiBqAoWwbyduHjYQvbZgCN0z6SkN4EBBWJk0wWvRbb7pLw6QG82DIena26p5o2Jxn75VxF7M94yItzc6GY7Zb+BZY2XAI4htgzIIzQ3uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM4PR11MB5406.namprd11.prod.outlook.com (2603:10b6:5:395::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Thu, 21 Apr
 2022 10:38:07 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.025; Thu, 21 Apr 2022
 10:38:07 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Duoming Zhou <duoming@zju.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.14 6/8] ax25: fix NPD bug in ax25_disconnect
Date:   Thu, 21 Apr 2022 13:37:37 +0300
Message-Id: <20220421103739.1274449-6-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220421103739.1274449-1-ovidiu.panait@windriver.com>
References: <20220421103739.1274449-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0024.eurprd03.prod.outlook.com
 (2603:10a6:802:a0::36) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9fc68a6e-0c10-4c01-5be9-08da2383060f
X-MS-TrafficTypeDiagnostic: DM4PR11MB5406:EE_
X-Microsoft-Antispam-PRVS: <DM4PR11MB5406D2E1F64DCAB0FC03E723FEF49@DM4PR11MB5406.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fZyimTcI95Kuky7/j6B9mO4t5ZOw62vYauS77MKYMPf9Laq9qUVaHgRLhjVog/RcG4x+6C2enE0Sw7Y0KxOBJc65QGailqr4rffDhs2TxUU99cnA+zUcMSD8O4nkxjKmTUQtw/MA0nmPkBZe0b98c3Kfpu/C7LTa9BNPJ4bCTlmwwOjSIIHBiAoTQkY4IW4Zx/qODy3r7smhuqiXZMzWgJ8Qh2UQ3phItkpdxDX6ruvtyiCIaX8thZHUeDzTjNI8bp6Az+kW0k/mPOG5dJ975JtWxFp5HrCMJfOdZJTN+M4w9547GjtPJ4aK+01L3hiZF+DtxqYc11SuuWuXYSY+IIHJj25HFJ1jobmPnv80e+xUWSwdzkMI87i8keED0qLQHg6r0G0Kqnx1tO48h5LycRKgRTW+XuuPeHOJ8GgkoABfbgZM/IF5L4Mqk97/aZffXv5FK/4ewxrki8J0IIjpvEEeq7dQj7+WRGVxgtAmbPBe1kj8/mQLHwHKyzzu5Yl+kwBtHjPrAV/3ABb6ljBkiM/DDxOXeNp9F7Ti5VZzNa7d6ZLDbD4y142SLt7TXx+TimwigOY8jtk+tH9KzaXToIWsQ7r2BEgXUAkdjRh0uhBqsmJkZxYk7gzc84YdsGQkF8uuFO+cmmEzwXfcRV3pg4yQP0N8PyVgafgowoGqPorOz7KnDsqU5aW6TPccwGsDA4N7TK6jOtoGi4zQi3XkJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(38350700002)(38100700002)(26005)(508600001)(8936002)(86362001)(6916009)(316002)(54906003)(52116002)(36756003)(186003)(107886003)(4326008)(44832011)(66556008)(83380400001)(2906002)(6506007)(66946007)(6512007)(5660300002)(1076003)(66476007)(6666004)(2616005)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OjYytouvnkIoDSUGbVBS9PKENWGG6OllopZOdB2rpJokNfwIlQPHNi/8fKMS?=
 =?us-ascii?Q?yv5N/5U1PWFgxk+kXYQxt496Q/XBPIWFC70iB/ib/f4MQ5nv2xYVJKf4QA+u?=
 =?us-ascii?Q?N6PJPqldhPF7RYL041drt5P8wLcIH4aLBi38hhO9Sg9XIQKPvv8kCfP1INV1?=
 =?us-ascii?Q?9EuRVsMhzN+rEA1Ni5xkEVuN2dLxE7tHzv9Bv7qd4vea+FgZU5l80ewR1R66?=
 =?us-ascii?Q?EZNXXztKwQNjsFY6j1s0TUUUumm+dBaw4UTOQua8ucX62KqtnnLieRLGYQuk?=
 =?us-ascii?Q?Zrdyk0lowZXnxDF1YNTWcLpkyjkuDLosUjtaLJrIZJEHQHsjIrpyWMYgb0C5?=
 =?us-ascii?Q?+apiEsDiK/z8QSGHoHGFYZJNRyLfFN5/tM+HTOPVXkXdzwVR5i9qMmoEq1OZ?=
 =?us-ascii?Q?Tb8ch0P66kUY40C/N8JgwiGJh+v5DuWE8Jjq6Ub2K7E1+lIxwj8e7SOe+DH7?=
 =?us-ascii?Q?WtL4diRSW59Dc49FbCf7SdHzcfzoF3fc5dRGzuIgndPuib0IRuq5wQ5+5TSr?=
 =?us-ascii?Q?+qfdqa6/RULjS8g9JCIx16hTErpnxdL1o6rS8sxLQD72OkZ47A4PQ18WOQ1l?=
 =?us-ascii?Q?8KEFsLB42akgsAfWlg1TFc5DKhv9m4XqyC0lGyrmwNG6LIeHw22oDPmPzRTq?=
 =?us-ascii?Q?OqK5bJx09+hEGShLVlagUIWNoA8LSuAEn3+jbE+xw6dU4uZBfCsOoFfYakyL?=
 =?us-ascii?Q?YRqxPQERreu5vuSd2Ii+eGrANhqKAUBQ+bW+cAfJsBqe0m/ziy24TacK0LfN?=
 =?us-ascii?Q?raGD5H3kL+xJ9jsJ6A2qaPbKhqH31GQF+1oRb/a7rnjZISa7ZxmnHPWD6qUS?=
 =?us-ascii?Q?POJWKeYgHMRGL8tF7z6GNFb6OvhIK3qU5hQqqWaQvLVuuwFHTyymLo+flbas?=
 =?us-ascii?Q?UbIr/8X89g00xVqY5jxbNhhYvqRC300uZt7UapLlkRdtxO/ZUhG5OpAmVtT4?=
 =?us-ascii?Q?pZ5f7lRAJWSsqfyJINNMtFq+yZHbo2iz15Mia4zeBMFGjLVh8/R9Dn535b/S?=
 =?us-ascii?Q?Pe+40hB5FkQ6os6KSYjN4A3V6W7BXJmPJkkY1xQJqR/KKB4yRDL2QyhwdhbB?=
 =?us-ascii?Q?/KxOVJ6+t7G4Ex6qSJKwlk40aIFZsv0ls9wYPhrl2xb0tCC74y1VVJ1xJzaG?=
 =?us-ascii?Q?THryreuedEE2KYatMuYnnuB7KxGft5FdWy4RUV4hALoliuhwkw8saIFMsBRG?=
 =?us-ascii?Q?aHa3M3wu4KV3G5X5K7uFsoFL5LtX8m4HMJbms+mp5EQkWaqGNFCRjNZSp8fN?=
 =?us-ascii?Q?T+ndbTrw7Fecjr4BOWvxQwM+RlmeDeqGHm7NK4WO52SWyRKbIC5CQo5VO9Ti?=
 =?us-ascii?Q?Yvd76bLYLGVFerZoKFuE6t1zaRWGpCPUnyXiE0/weui1nn/LqH0AQwPgZO6p?=
 =?us-ascii?Q?pASxpNYlv19SsV0E0FF5ghgG5+EoQGc85USpvMBXuswaGYzzSCxPSV/sFtvR?=
 =?us-ascii?Q?6uaazOHXIyWEnu9iZgG2prRbO9MFzEeoDhkeWLwznQwktcihlk9Jy+Go1ohF?=
 =?us-ascii?Q?pLIe6e5tXIItOpPzSyg0L6u2cUDxhHlwImTk7I+d/R7aQU9ce6d77d4uxmOH?=
 =?us-ascii?Q?4zRGfgJyC1Gg4xatswzhQOy2GZMzMATj8ENmvLTRIG+fMKGFUW0cL/G3cRND?=
 =?us-ascii?Q?D9/if2a5CsD989kNNqrbpycZdn1hU9wc25bxsdulJo3/35G4DQwBQjAcj7MJ?=
 =?us-ascii?Q?bVnMZOfGftru192r8bDmuNajiGlSUSIQSJ4XqUKbqPNvteRWG00Ltx/0CCSn?=
 =?us-ascii?Q?Ub34HKtTGhvasQ45TmbdPST73CSRkfc=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fc68a6e-0c10-4c01-5be9-08da2383060f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2022 10:38:07.6641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GZNn+IBhitmtH06iTOvftrGkljd6VfK2smrmNSrqNQKz+fDd5XpV+8vp100HGQ7klJ0ekwceRNE4OHCobGwlbm8nHqNEN3cCYA8Up1LkKcg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5406
X-Proofpoint-GUID: 4jv20kSnIV4M18mQ19ZdAHJLJJx5SvVc
X-Proofpoint-ORIG-GUID: 4jv20kSnIV4M18mQ19ZdAHJLJJx5SvVc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 impostorscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 clxscore=1015 suspectscore=0 mlxlogscore=885 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210059
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

commit 7ec02f5ac8a5be5a3f20611731243dc5e1d9ba10 upstream.

The ax25_disconnect() in ax25_kill_by_device() is not
protected by any locks, thus there is a race condition
between ax25_disconnect() and ax25_destroy_socket().
when ax25->sk is assigned as NULL by ax25_destroy_socket(),
a NULL pointer dereference bug will occur if site (1) or (2)
dereferences ax25->sk.

ax25_kill_by_device()                | ax25_release()
  ax25_disconnect()                  |   ax25_destroy_socket()
    ...                              |
    if(ax25->sk != NULL)             |     ...
      ...                            |     ax25->sk = NULL;
      bh_lock_sock(ax25->sk); //(1)  |     ...
      ...                            |
      bh_unlock_sock(ax25->sk); //(2)|

This patch moves ax25_disconnect() into lock_sock(), which can
synchronize with ax25_destroy_socket() in ax25_release().

Fail log:
===============================================================
BUG: kernel NULL pointer dereference, address: 0000000000000088
...
RIP: 0010:_raw_spin_lock+0x7e/0xd0
...
Call Trace:
ax25_disconnect+0xf6/0x220
ax25_device_event+0x187/0x250
raw_notifier_call_chain+0x5e/0x70
dev_close_many+0x17d/0x230
rollback_registered_many+0x1f1/0x950
unregister_netdevice_queue+0x133/0x200
unregister_netdev+0x13/0x20
...

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
[OP: backport to 4.14: adjust context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 net/ax25/af_ax25.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index ed40d4e47887..391b17ca1183 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -105,8 +105,8 @@ static void ax25_kill_by_device(struct net_device *dev)
 				dev_put(ax25_dev->dev);
 				ax25_dev_put(ax25_dev);
 			}
-			release_sock(sk);
 			ax25_disconnect(s, ENETUNREACH);
+			release_sock(sk);
 			spin_lock_bh(&ax25_list_lock);
 			sock_put(sk);
 			/* The entry could have been deleted from the
-- 
2.25.1

