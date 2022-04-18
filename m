Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53112504CB7
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 08:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236808AbiDRGgQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 02:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236422AbiDRGgL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 02:36:11 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF4D18E3F
        for <stable@vger.kernel.org>; Sun, 17 Apr 2022 23:33:32 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23I6Ug8Y028999
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 06:33:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=ngsjV3JOFgkTNMvUrKfwv+ageza5yoId+wxGKwQJD0U=;
 b=WOxLUIW3Pfx1FP74Td0SITze5fR8/bezD7FtnUr8sROMwnp7WhjldPEct+10it+pPhiG
 /PqndQv/OVhZi+NKv3cV2KNbgxOfmrbUOdKz0oL9NlP1/VJcDxwmLL1wITAXgP7ylfoG
 1kazVfYg0JUlrXx6cCzID8HZF3A8/BbQrXi1QA5WVCtV+p5Ko3HEM484gw3+tisi4bgE
 oqt1G1+PBbq4ZIm15TOMX68cdpBWmKjXN5Lmu0ZJbqX1KZvUwlIK68xxGEhxPmx2nZEb
 XqKvKjiLkTY2jeGucqc5M8QUx9p05Z7Cfa7X+J6smlYT48LI3w0vMoKRPJ7817eUpaHv iQ== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3ffpj2s45r-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 06:33:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QOvvWnnt7aJEU2tY7isCk8WbKiGNUXiElOA8XFT+7FYPtuyTdEcRZS/+/8XK5opl0MNH9Jiqxygq9rdLvKHyji5T5v38gPgFcTfkfcpsyMriL3zU8l6pEvTDvPN6KG5cdsiYLKwr/B5FRur3HddUd6kC6RWLyWRO7syEbTlyAGV8hYMd9axorAlyllm7mNjELG0oX2v6+oeyPXlMOuGY6gn8zL7f4MT4Tab7ULeswKeZswdXOlcwdJ7PuDgi6igv38SqfFOHVI2fuiOGMsO8BtZeQNmlri0IH+UD8i5fOALgfNcEYwBC2pj8k4g2osboCJ48e6GD3yM+h4GoiOlzKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ngsjV3JOFgkTNMvUrKfwv+ageza5yoId+wxGKwQJD0U=;
 b=N95JTINm821+kZSNAYQPzQAHooNR0Z92S/IsM1CzYogR/8IEOoKePbsx4NhlVeQbrlLHotvmvUdSnqYjWaYeFWiTPxIeAf5pSYeLD9uCzLqguPLiHuJfvVBSDIozHAYPu5sMWDsaZ6o9PBcW+uclYZyaqU0M7Vb3tdWD8TY/CHVkJ887Mf7cNp1wvuqxuHMVvTrXDKjliAmaTFDndzfSQnCBcXgyGlKjfra+k31llLnR3pPETe9K63JtSlWjWGEgm46R2vSwr6ZcVvMJ2YKLqNGJvDtE80GVCETVstfaRzHdmxVVzko/HFhvIlbZ1UsdwqoXSVMfc6iGJDQ2qNTz8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by CY4PR1101MB2135.namprd11.prod.outlook.com (2603:10b6:910:1d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 18 Apr
 2022 06:33:30 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 06:33:30 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.4 3/8] ax25: fix UAF bugs of net_device caused by rebinding operation
Date:   Mon, 18 Apr 2022 09:33:07 +0300
Message-Id: <20220418063312.1628871-3-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220418063312.1628871-1-ovidiu.panait@windriver.com>
References: <20220418063312.1628871-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0042.eurprd01.prod.exchangelabs.com
 (2603:10a6:803::19) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d32d0384-bbe4-4dc9-073a-08da21055a5a
X-MS-TrafficTypeDiagnostic: CY4PR1101MB2135:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1101MB2135AC386079B5BEB33A630EFEF39@CY4PR1101MB2135.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z85MfTEwg03hsbpTefy3RfyKQVQPiM27e/RNKOpBbp5ug7RUE46mPWiIejk37A+K3/848rvEex0GbWKn67EXdQNe4pv54Oi5q45bK4T/wVOhBhvGWL48NMG7pVARaK4kqPptE6x6B5/tnhVW7dfigPgBlSUf12rTpVZ/uD+VRZYXQFqfasCmqw6eXNU7yT/q72s2cgYEXJi/HUIMwHf69brA9lCn+Dn3lszPbDTXm7NXZb3OhAPxfUu450Kf0X1+CPsK3NYfFQ1/K2eIk2g/I8IDinbuhNLTNP/Du9hvepL4QqUyN7ZclOBixOjDqBlXgDKav7mk3qSr7WgwprXiB/C0ueBUcLwKoJPdhxciVkxseIND+gEcV/9VXQmhylV1FpexBU9B35FUdtOr7TWfF0sy/69TerxGqrapdIY7VyCw46kT4S4lkueoWbGAN3KhXqtrnGhyv9NnX4SQN+JDFOeTrqFoxgNBRToS7cSn30GkXW3JUB7yc5ctKLTH1m7But+xt8I2PMsK5Kj99UDh+/Q6u500Db2/+rndnqGvRYe/d34X5YPI89cZRrRcIaxEr1AXTMGzLpiEo0tAN7hHuzlfbSvnyHhR94SUZMl4wSpuNe8E3F4anpqDpUpgAJrGXhMZaVtMRSAs10ADo3y+YKdJLbQsWnWtnPdZpOiY675D+QQ29R3nRDr9Fvql7F1X7i9gMO3NR3cBtcGKa39Cag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(44832011)(5660300002)(316002)(36756003)(66946007)(8676002)(66556008)(86362001)(83380400001)(186003)(26005)(6506007)(2906002)(6666004)(1076003)(2616005)(52116002)(38100700002)(38350700002)(6512007)(6916009)(66476007)(8936002)(6486002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TwkfnDmKmTi9CypkmCmhs4Lvqt43NeMgGug/kxwzD7/x+o0aas293990pEoU?=
 =?us-ascii?Q?qf2D2PDw85M3JiwmmO4xPNl40EKIgekaesT83MWH23KPhAcbS7Q5XKLalSZP?=
 =?us-ascii?Q?rEvSf995LvLeTkvHiTej3a2vSN80l8EDCgYIWbJ8IFFo0rtGmU55I8KD1Ta3?=
 =?us-ascii?Q?5qpuYuz/oKXj15Mqk9i8O2UOX7317fvADWJvoB8cwfqLlAGlkg+LWNPSzvhA?=
 =?us-ascii?Q?XwTS40CX2SnRGS2RlZ+GHhjod90Ei5VRqw/jIxYBS+TAn3e4G2noY4dZusUG?=
 =?us-ascii?Q?RZC6gs6cd0jYV2W+7Xpl+5BFzREzXp95qNTvL4frQwBpPnsmt6FYqFxNSpaV?=
 =?us-ascii?Q?1ieALMWGWncN4imeFnasxsLGhi2KK6fiDcxuD6VheDfPXdOWgOiOD3D1Np4+?=
 =?us-ascii?Q?5uiowErO2lS6jIpj94cS71P2u10ME0SBK3ZYvCwIMskq2cS4OmcPZrLBHMMd?=
 =?us-ascii?Q?YYkFg8OXsx5027tqIpJaWKqRLB7Ic/OKuDVXi946OxOzHgS6+Eo3GsiGP/ou?=
 =?us-ascii?Q?kf6CqkcSVYyvpCbCqBGsffln7UJnB0e/vI6IR5dVIKNGAB9FxsoN+fJrrAPN?=
 =?us-ascii?Q?6aiW6Xbc6WRKhJg5Adbxgh02xk4Rz9nU48PdQ//ySP4jYOtRG6WY6qXq6ALZ?=
 =?us-ascii?Q?q1AxP2IGfqcz/IeQ9hfiloYvgolxn4iT7saogJomNkZGYmSOQDpqytSoI5Wv?=
 =?us-ascii?Q?EbnyNr33kZfC/x4HwpXehPZBmaOuYIfSkGIotvFGIm1m3E6YtR3TkISx3GlK?=
 =?us-ascii?Q?YVUHCU3rX8qj2MkS3AxfC6Bv09Jc2Wu8tLwH6zeYudji0myT1Ujx5kGMR35V?=
 =?us-ascii?Q?3JMZN/+cdgFl0YdlLQSoGNW72rhFbP1bXJzIWxCinve+0EEeqZ01z1lzV0X0?=
 =?us-ascii?Q?iXmv+6FYM1R4UdeXUCXGz1vs1Se49+4Dfdhpf/rrw63e09l4WhViSw1ssh4Q?=
 =?us-ascii?Q?f/P6cSfLSDep4zZF4cn+vrBOKCN5W3OtN+HTht37Fk0AnskKcIO8H9PSrxV6?=
 =?us-ascii?Q?OFQ524cHe5qMqlkuV7TRNeNzDVyo8Y9BAwRLGrGBQEIXCqV9nklHGtRjz+tZ?=
 =?us-ascii?Q?oIokfYtk/NlK/5h/reSpUMb+YEF6hS5pRb2krkXmkWvGKbLIAIxrcwi/tlNJ?=
 =?us-ascii?Q?rn4xVaomBe1mAtQZMXFQ3ejyL4VdJVH+RbDiQBd2C9gGT8abTMaHZjjW48Ge?=
 =?us-ascii?Q?HkAxKVT1p4FXixSjQslVl20cDFwbAoN+UlOgDMKvB7YGhVF7u3oVPyOvPvp9?=
 =?us-ascii?Q?2yG/lzYMJ0pI5yAxovXNLkE3MNr6nmd0T6Kl5CX6BN8aIGIxJG50yf5H+IYa?=
 =?us-ascii?Q?9Zy+fH9PfTtv+3K0PBWIZ/Kte/MUAt8E9gRToc1gU7H2DAYDdBm6Upg7PlLn?=
 =?us-ascii?Q?3d7vlYVbFG1uq8HxDEDf4M0We0mxJCCKV7VNBJY7Wa64c3ofRIlAuXGgL0dX?=
 =?us-ascii?Q?/j5B8Ovf7l8bq6mVN1rwtXE/Fe4EOWHPa6aTZTa0h7p7nqICQAsL378FEqoj?=
 =?us-ascii?Q?Nz4EGT+p+G9uaUKWw98A2Y/6saRkwtjOy0Z4UHGmhIt0R7NtUlZfMWBlfTeV?=
 =?us-ascii?Q?haU0YT4/x0xIBS75Gt+KOZp87+1gh3Vz6s8+avxKtKRZ3miUrmCPASEj2MFl?=
 =?us-ascii?Q?V1XVXzK8ef5sTv+LhGD3ILvNSfljdKt0AVU4P735QNtyDaJiu80pe2+OIq09?=
 =?us-ascii?Q?4z97RtqN+DTbselM/VONa6APYZahSradVBUz/dKc/5gJfg3FM3Z3yAcdj+D/?=
 =?us-ascii?Q?VI6qhBPBdy/DD2cKxM41pRhnoMhX1LE=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d32d0384-bbe4-4dc9-073a-08da21055a5a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2022 06:33:30.1686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TjJ1O8CJ3UJjyqc8/2382LAmiolMuZ3onMNX5A33WAbsboPAdze8WfUKNCP7SGtJNkw5gZglj3wsaNosib7shhh5gu2waywqaCGVRq3G0IE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2135
X-Proofpoint-ORIG-GUID: ButoW-6lM5AyMOjJ3mbWjvakjVxbG4Or
X-Proofpoint-GUID: ButoW-6lM5AyMOjJ3mbWjvakjVxbG4Or
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-18_02,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 spamscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=596 clxscore=1015 phishscore=0 impostorscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204180037
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

commit feef318c855a361a1eccd880f33e88c460eb63b4 upstream.

The ax25_kill_by_device() will set s->ax25_dev = NULL and
call ax25_disconnect() to change states of ax25_cb and
sock, if we call ax25_bind() before ax25_kill_by_device().

However, if we call ax25_bind() again between the window of
ax25_kill_by_device() and ax25_dev_device_down(), the values
and states changed by ax25_kill_by_device() will be reassigned.

Finally, ax25_dev_device_down() will deallocate net_device.
If we dereference net_device in syscall functions such as
ax25_release(), ax25_sendmsg(), ax25_getsockopt(), ax25_getname()
and ax25_info_show(), a UAF bug will occur.

One of the possible race conditions is shown below:

      (USE)                   |      (FREE)
ax25_bind()                   |
                              |  ax25_kill_by_device()
ax25_bind()                   |
ax25_connect()                |    ...
                              |  ax25_dev_device_down()
                              |    ...
                              |    dev_put_track(dev, ...) //FREE
ax25_release()                |    ...
  ax25_send_control()         |
    alloc_skb()      //USE    |

the corresponding fail log is shown below:
===============================================================
BUG: KASAN: use-after-free in ax25_send_control+0x43/0x210
...
Call Trace:
  ...
  ax25_send_control+0x43/0x210
  ax25_release+0x2db/0x3b0
  __sock_release+0x6d/0x120
  sock_close+0xf/0x20
  __fput+0x11f/0x420
  ...
Allocated by task 1283:
  ...
  __kasan_kmalloc+0x81/0xa0
  alloc_netdev_mqs+0x5a/0x680
  mkiss_open+0x6c/0x380
  tty_ldisc_open+0x55/0x90
  ...
Freed by task 1969:
  ...
  kfree+0xa3/0x2c0
  device_release+0x54/0xe0
  kobject_put+0xa5/0x120
  tty_ldisc_kill+0x3e/0x80
  ...

In order to fix these UAF bugs caused by rebinding operation,
this patch adds dev_hold_track() into ax25_bind() and
corresponding dev_put_track() into ax25_kill_by_device().

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
[OP: backport to 5.4: adjust dev_put_track()->dev_put() and
dev_hold_track()->dev_hold()]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 net/ax25/af_ax25.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 997866ed9cd0..3c923259a56f 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -98,6 +98,7 @@ static void ax25_kill_by_device(struct net_device *dev)
 			spin_unlock_bh(&ax25_list_lock);
 			lock_sock(sk);
 			s->ax25_dev = NULL;
+			dev_put(ax25_dev->dev);
 			ax25_dev_put(ax25_dev);
 			release_sock(sk);
 			ax25_disconnect(s, ENETUNREACH);
@@ -1122,8 +1123,10 @@ static int ax25_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 		}
 	}
 
-	if (ax25_dev != NULL)
+	if (ax25_dev) {
 		ax25_fillin_cb(ax25, ax25_dev);
+		dev_hold(ax25_dev->dev);
+	}
 
 done:
 	ax25_cb_add(ax25);
-- 
2.25.1

