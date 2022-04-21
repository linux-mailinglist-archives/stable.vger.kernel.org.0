Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2075509DA7
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 12:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388386AbiDUK2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 06:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388519AbiDUK1q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 06:27:46 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E5CE58
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 03:24:55 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23L900Eh031125;
        Thu, 21 Apr 2022 03:24:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=EFm9CK8S35NbxWfgOIVAwrebnCI4q558ZRlaBHg1YCo=;
 b=XDd4ZZpfzcyP51yVO1u8FiMGNxqwDRI3POj2XHHuSmvYrTpNMMsiAZZJTKRx4x5Xz9jJ
 7wpbDy6dkV3XdWe27X8uV8LXBdSBOl6uVgrPHUw6UnWxaxJm0ayGWvHtfT3OjPAHIL7B
 U3S30yy1goAHzNbXx6EdroMtwAA2wPIReze+moSigFCRSr9j3Uo5p/PfMwybbX6fXpL6
 VKfnkFdMhxyDnwcMMMJKMRPT5ncV0gc4ouu8z8LMpJSwHVXeNviM0ClAMVTdFQyePzyS
 79GATuu6afNnaCRRVmV6LRP/4nLmiD7/vGiAZWE6rcP6D7HBGw1lbck+Y67ZjdFvZbfU 4A== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fhmfc1wxw-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 03:24:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fRgPyuu2r6VjZhAnoWwdpvEW0EFMCn7lxdhYUcyEUrvJz0H52rY175zDatCNZEk3h3mYTqor/Mkbckn3z9E6h/pvN8uAU6YW4OfqietmbXdz3oa0IzOPlOyxQiyEfSzE05PPBkv22GdIyffNOqjpkbfTW7dCFyBrkpI1Zoz6jwuZdec5xXSwNMockSM0mFoiYSUK8zl7bjFBVtbMgLK03qXK+UO2xs7wiPUokIJrhSE0TlC+xTyMQovUIe6ZB2U4ZXgLNN1xSvgzwBriWOmo631wHdwXn6asdFV60/goDE6mYJJ8//f4O7lLLOWSXiMnf02dmlVB3NIH3ta3vTLbCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EFm9CK8S35NbxWfgOIVAwrebnCI4q558ZRlaBHg1YCo=;
 b=m9CO27lS9N3lMx4JakKhQCPkXctcROYeaLAoWo1NJzP+AQrMaxG3vzxCIUA0fj6onZEJ+v7xuJLlMKRYA9c8whpQYWtvJ8cwLnfxEFGV1PrFEsABYnk5AY5+3xFg8UQ+nv580upAG6y0cnwKsLKTxQZRnwJAejMISfRCDZnUblnR6YrifZIwUrnc07W1hWpvchny+Huq577e+z7f08HNqrM6ELjw8mTVMVLxHNyfPrB439is0FdWSDoOd417oPXn9aTGirikSib14olKz0Lc7w2eHRcT2auyjIJpjFPUSYXUIzhuajphTFg4QCCk5l4lj5HHDfEvuVvBTvE4GQuxng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by SN6PR11MB2640.namprd11.prod.outlook.com (2603:10b6:805:56::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 21 Apr
 2022 10:24:53 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.025; Thu, 21 Apr 2022
 10:24:53 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Duoming Zhou <duoming@zju.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 6/8] ax25: fix NPD bug in ax25_disconnect
Date:   Thu, 21 Apr 2022 13:24:20 +0300
Message-Id: <20220421102422.1206656-6-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220421102422.1206656-1-ovidiu.panait@windriver.com>
References: <20220421102422.1206656-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0092.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::45) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ea95e46-4517-4b23-7ae8-08da23812ccd
X-MS-TrafficTypeDiagnostic: SN6PR11MB2640:EE_
X-Microsoft-Antispam-PRVS: <SN6PR11MB2640380481DEF0D8D9ECD5BCFEF49@SN6PR11MB2640.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G/+7+liweDUqAqFhCEFtKORuLN3SOyTHBzSJ0hUcw4ue+D+UIIGGL79gYVjmWeyxKqOdf+ZRCYUwbk26by2MZni5QhRKxJVYounmIGPbyQvS3J6bqw8EaJdZjzD/xhV5YTl4gd08zYhDYnbNDGGYOzpMzomibEx9Jg3LvdFA8LDwWSpp2lhhi27ZVDEvyxjTvD+3jPtuxv70BZI0NjF3LemuAOG0lGk309QbRE1NXVjsT1BTOm8YwJxb7a4DfmouJoce+6gyfnW/KKQj20Uvtl1WSoW9YE16M3KbVNHhg/XxlBuI8iWrqlLGBB3t0a1KgimboqMZxRVe0+4drSVBIp9KkjencYuKGS1l9xlUEH8lHIcRoGvOlh1X+5EutNTWfuy2BbrzQuRfRJj7FiFVExTW8piZHV1OEAq8LFkruRTnvhxxkM+OOpVYHbz2DAa8wxqUKkFLQ+QX4ol8MnWfqCG34sjq/7Kx/PU3MEMi62pRdSHUE0jYwOMyJGaOo0rtBKQJQJBK1d/8o9n5oM5c+Zc4t/1wwobgoiY3SIdKF9kZdyZFfGAU8ft5ItrqxcS9hxRang4zM9xiDBKCtTvgKW8PvE9Tdz1cfcGSuXGbooMSgbVNvjrBaPdlJ/1k2zw7tRsg9kcvCcY3ROLlL/STl13Y4Q7KDfhB8e+jlOm6ec/Oy5wqa24GD9B5eiklXyRrWZyFXMgInJzYGTcN5qMIEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38350700002)(38100700002)(66946007)(36756003)(83380400001)(8676002)(44832011)(2906002)(4326008)(6916009)(5660300002)(6486002)(6512007)(8936002)(107886003)(66476007)(508600001)(6666004)(66556008)(86362001)(54906003)(1076003)(2616005)(186003)(26005)(52116002)(316002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nIR/H4V5zk70NELeou4OoKeMtrA2EpLOaYq77lak3KvJEpafGqNVz1k14sZX?=
 =?us-ascii?Q?r5ba1X3laRl8Gwqqvy3wB9o8UP8/v8cur/EPD9924hFqONT3lom0Nz7QHspz?=
 =?us-ascii?Q?V0yFQGkZ9NMJPU/SJQ/Vmc749PyPIDKDwOry5IJZ8nA0abQQ5p2+vhmZP9f1?=
 =?us-ascii?Q?RRcsRvjqhRGDFcCYVie0pFCEw9IYrHEsVnBgsWHnLW0ucnEGJ4u15Df52CNa?=
 =?us-ascii?Q?YyYG/tF/yYXwDD+8zfVsWgM81qK9o8kF4P8XCIZrzC5/cbA8r5qiK0xxzIxE?=
 =?us-ascii?Q?gm3Z8hmTdeooZEaiJ8j9wWf1XgRahFGPMonxtNCvaXIRI+b5p8uq+Xfud5Mw?=
 =?us-ascii?Q?ljrvU4nv5dVoHMl60yYMzmo1MHuJS/92q0slpY7/R4plWqjRnKN3wyCpV0II?=
 =?us-ascii?Q?LpYwjKLU1tWHkdEhEShQeRoq3VhWQ3hSXzqjxHcyfMX/3BeGtlhu8B18CTUZ?=
 =?us-ascii?Q?j5QKu6w+DDh+S457hfu5/Fn/pMLGTLSF8j56CVFE8tTtqFJEyTcL5IcbY2+K?=
 =?us-ascii?Q?COUW1XVzWgknQRV3S09T8bVt2j3YJ1z908HoaWR0w+aM9InJPlDP9HL5LZN1?=
 =?us-ascii?Q?mtpelU+tUNyo1Dai3Um9x3bDw2NGeheoEptk6PLEp+k2GOjEfqEk+Z7dXkRb?=
 =?us-ascii?Q?OaV+ESyj+9ywHT60DNmgYQP3blBQIoS22Ozm2slJzuzXS31zjfOMlTs4G7+Z?=
 =?us-ascii?Q?/Z9Q2d05fU6TXBMtkllEyp1XwkA4KkUG3jhbJB0j20C1NSeOaO77yuR7T9CG?=
 =?us-ascii?Q?ahHfxTIyt8D/ePuXVOVip+j4TN+zSQktQC3GUAL/zF2jSe2eYkHX8pBN3ryX?=
 =?us-ascii?Q?+c383j8Wsexrcy4HEbku7BFhAIxNq+Svhx1cj65kmQccrMtS9fRVrlCW1S0U?=
 =?us-ascii?Q?171I8WOvH4oF5itW2JtSfiyFb5trM31jMIMvRyeD3CixLL6/gVvk7Kn5PYe6?=
 =?us-ascii?Q?nZgYoMx4cpl1+lf1vWAl7kYceWRldY4LC2v2VjFTHhfZds7BpDkhfn8+rXan?=
 =?us-ascii?Q?wbChmZKDB7nB467nevnc1w6Kz16XH3cqpv9I+QiTACoAyrTUpfVoPsX7mTr1?=
 =?us-ascii?Q?Wey53bxfEpJjyx3bo+LPHeb1MHxoPTRQdRroOBIlUXCWOZOlzlRsYiUDqvo7?=
 =?us-ascii?Q?ANT+2TQM7yQLW5BxwObtJX/ZhBIhGd1n0IQFsG6GXX7IDS0168aS9of1SbTh?=
 =?us-ascii?Q?O2ZRtRPNjL/7a1zSg+BJtKHEQY1eE9jPCW9CdqnHlD8I/cFrOIWJmfeCsWnR?=
 =?us-ascii?Q?i5O6ZPIzuOxyQ6D1GE6XW8bOoK3SDSt8atrwLwudUXJ2O2utMxXrYl1DWhWW?=
 =?us-ascii?Q?3cFqE0XrzObr7Oi9d/1/LybcZCjUw72jeRcTx8kcfuIS6BUNxmwanFcCkZEm?=
 =?us-ascii?Q?FIyeP8k4RnT6b2cBa98d8Ar83P/BlvHNybQQJ5Srp8I8RG0ZrJo3Fp8AF+5t?=
 =?us-ascii?Q?wc69vxGrRC2un/K2hdHTFJe0H3s6c+lS+JyRvnqeKY5fQ0qLcZIxk/FWAric?=
 =?us-ascii?Q?hDOr187vSOr1zXOUEA0c1dAwz7L4RpEzGCWLmHKCIONsaklxb+s37mi1rHN+?=
 =?us-ascii?Q?+qjLSmH23PZjrnLeoRQlyCnbn2Ovb/6kWVWk6MdGvwYjiJeagyrlGLX/hXC9?=
 =?us-ascii?Q?8LFhG2lR8kBmeSBit0TZ7KAF/tpqOjOZT2bO8JKlD9dlXDKiGR2VZN8kvAI3?=
 =?us-ascii?Q?DyvifrG6feRNl/IAN0DS7/BiOAS9+/2oW8YjLORjeMdXChlCsnWHZDtCLytW?=
 =?us-ascii?Q?rsC4Xh8Bgr38MX+CDBMi1vg4K6oDqCQ=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ea95e46-4517-4b23-7ae8-08da23812ccd
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2022 10:24:53.6857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KboJV2dswzMLDLNO2ijShYOlDWuCuHucNY5g31yK7t6RuLyEUv7CIqkE1QCVbKAC/N3c1PCR4gPfuLfecKTpz74sppDuJQ3+zXP8b/fkFBo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2640
X-Proofpoint-GUID: d2ykiAczQGPVVGeKwRUtBrhuk94JOJSe
X-Proofpoint-ORIG-GUID: d2ykiAczQGPVVGeKwRUtBrhuk94JOJSe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 priorityscore=1501 mlxscore=0 mlxlogscore=885 suspectscore=0
 malwarescore=0 clxscore=1015 bulkscore=0 lowpriorityscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210057
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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
[OP: backport to 4.19: adjust context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 net/ax25/af_ax25.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 6d08b8ef4219..cc0d6b3d5ad7 100644
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

