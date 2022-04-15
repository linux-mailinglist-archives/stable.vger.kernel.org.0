Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13D4E502D93
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 18:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355752AbiDOQRR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 12:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355756AbiDOQRQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 12:17:16 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7AAF1D327
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 09:14:47 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23FG0fep007781
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 16:14:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=f+Izoyzeb9FMfBCMipzOKF1SnqIgBUSXeM0IJM2Ltj0=;
 b=RYTG3NzDGBwCApdTG63uFYYHp34UcYpwBrpRrP81DUCDUReH85CfnN1HQO3hGxCPTM/t
 Lch6GwJXzI+C95JR9AxJYyLPXj64iU6sFcZuC1H3lPEViENCrsDBXeHHjp2BZiZWasJT
 z3KK9sfG4ub2Epw/EK/Wft+q5E496i3dgZUxSsVDcpQV0roSmpz/NI1gfV/pRJ13V64G
 jc8rXzhoFa7WPxNWeNXe12db0b0BIP8S0vFju0u38I3wA14MfPUhKd5rzXD/f7ooYBZp
 kHGLOGqR5qYHfjpGgTwCl60h/GhGAczMsqcWQpG2aEoB+4pCUnM5gRzCRHzCSEdCwSmD uQ== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fb66evugx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 16:14:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Prqx2f9yaO5eT58PliUO6YcH/pzZPb6fuk3GOxXZN6o78T7MfVonqFQr3WIHxkCDYlVv01Fr6/35W5zWwPxiF+GkljIy+E8q+E7zEK/aqYFuP6E150JvD2WcvEthD/j6T+OFt+PYTwYpzmGbhkamLm1OX8mFv/DLWNzw3T5om51MF36w7c8hGt9RTEXSYmZcSf7BxcOboSCBvZ/dvFtwkF+FqfeYTEe5KjIDp8kfF57GR8/otNn8xh5cma/cHhAEGX9Y+24EodJeVU1j0UclirZg/EOp1KS+jHq3sVyFbA5ApQhraY5ZeFNT0e2zaMaoD4T/bbvuXI0Xb+WuSK5P1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f+Izoyzeb9FMfBCMipzOKF1SnqIgBUSXeM0IJM2Ltj0=;
 b=U82iBzN0t4ueXHWpNuTi3q5trwbERPi6acIggxOoEQOaUcHTU4lCsLpzKkM+EJOfSjgcku+pPgBkbGFDsb5FEQorsodSzld8QkL6eTX9rOm1v5y01sRo7iRuZ9U/mhnyRuO85cfl4ZEcyZGb0LPYrPrK1vwemk8aBw33ip6RDSPZ535PjFTHOYJJKTRlhIxxPLuDBhFM4GnVLVnXsfOJnW3GdAjnwcTqODFTUd86GeHWnXFcha3V28zssG+S+HEgqNdQd3oltwunudfsLTPXdQDRaudlNrOtYVx/lTMtfdpXLcvDhZ+yaMeGh0ujEzrpUbsZSIWM18/svTOYlGDuNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by CY4PR11MB1768.namprd11.prod.outlook.com (2603:10b6:903:11b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Fri, 15 Apr
 2022 16:14:39 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 16:14:38 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.15 2/8] ax25: fix reference count leaks of ax25_dev
Date:   Fri, 15 Apr 2022 19:14:16 +0300
Message-Id: <20220415161422.1016735-3-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220415161422.1016735-1-ovidiu.panait@windriver.com>
References: <20220415161422.1016735-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0202CA0009.eurprd02.prod.outlook.com
 (2603:10a6:803:14::22) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 62da20fa-1ca4-4c7e-46d4-08da1efb0a76
X-MS-TrafficTypeDiagnostic: CY4PR11MB1768:EE_
X-Microsoft-Antispam-PRVS: <CY4PR11MB17683F83FBD93926053F7EF8FEEE9@CY4PR11MB1768.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7FwoLPZ4cxTQwoTd4ZatzUblDhFlccTjL87ATW8MnfmXEjSjRe5+ZfTntIg4gRrUgc72op3Fh1CaqINHuVwZe6WY7J62ARA5DtqSe8ZG6NzSToQt2CnFHO+Qm81wd5TOrGP/W4akefvpk+1uzSqMHRcLoh5ImRUfXgT5geG/5IZjLfOLq/NJ1EBKDglSNyRF/0c0SnJbuar3Y3o+0vEiErsy1n7PQzDz6s2ABbWiwyYyEjNT5F8E2wlG5wfbN6BmJzW6enq0tFKuXVJXceEkO8lC0QhbnsxgYGINUyGODXPDFM8jGunVYyurDqhdhja36vdPWacC+Jrht6875CMKPuAFdyqFmlXX4ofpBsKbLfxeFgk1rHMNE+mrOjr2JPbmz2yX6E7pJLvcWsyiIFU7Jl4Qsxo/bO6JykFeclieSiTKgfxrg50tJFcRkg/Sh1LlyZZmp8EmuC3gpGMyjk10JsuceVjC/GZ7neZ5zh/2rkqDVEkg2RsbusRd9x+JQe+k5w6Pk1q2gfh3j8P/L7RqphGYBNHSBNwpOYR6G5wAzZNd97D10Pk1HEwAzP/r+kySGNumyCz8NHGmub2FaAo+/dz/JdrJDylcw5HG69isC+Fl0qjHAqbmc0lpEEy9uZjsXkDfFtCgVrrVN4ze1xQqIiRn1DCqMFXzPNQJgXFsdgKyGdtt4ZhHJ9WTZ4meHaBEN7sPOaIT/P+8cKEFHY0U+zWqa9rvwKuynwLiOZQ7pGSkVydkLAxtKRpKwpjUeq+ool+srKN+oYddQwNDU2kTCKbLr+PgnhjWnG/kAeNsP40=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(44832011)(2616005)(66476007)(1076003)(508600001)(186003)(86362001)(8676002)(966005)(2906002)(6666004)(6486002)(8936002)(52116002)(26005)(66946007)(6512007)(83380400001)(66556008)(6506007)(38350700002)(38100700002)(316002)(6916009)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1HivgFJuYMrQAdUjrO5/PwnJwaVWxR9UuWMirztJv3gJ2yqZTwK9tbyGhm7C?=
 =?us-ascii?Q?Of8lb9RxX1ILVLO5wEY5DuEDyFHnEOpM3DBfjskoBsgkMBMMkJ/znWEYnjKx?=
 =?us-ascii?Q?+ksX9iMClJ0Ps7XBLYLOeG9X7wCaBp17cfUHLyE0gmncQuTYyN3FfxP5+NxD?=
 =?us-ascii?Q?hTs000gjpSGZ8oUAoBdq8q7GB/oi2Ibem2OBHNku84CUbSbwp1XsjPWQ0lhj?=
 =?us-ascii?Q?mwZSVte6ALOF+kYxy7DE9R+ZBdG8NhWS7XxrGUFuM57sjh9v+hszQvjTEaY5?=
 =?us-ascii?Q?7AOtPXO8qrdtG1bfNf3OtgeT+cUfjbA2XO9aptvKHxMBzqHV62iAqCs/2MwX?=
 =?us-ascii?Q?sYLosHLegVh+s9JRRKXnwdfbT7awSVNuKnH+n0IxeaqyQXkD3A0pCGjwIbJS?=
 =?us-ascii?Q?0+S3cZkQQni8a7mHidV3DmQitmST0g+KmO0e5DkVNSMwPx381u54culpMsQ7?=
 =?us-ascii?Q?T/fDmJiEe1S6NuMozqOrRFXYrDmF39S2zBRhPfxzWzotaHcZ0akHsohXSYJq?=
 =?us-ascii?Q?fAE3vPQDisTKY6bDcoJy0wEB/DV75F55+erC0BwjhK3SkitaQDX9BbZyW/Jr?=
 =?us-ascii?Q?rJr2qhDiKdrP05Zubcj232SU58SqDrVPeeR9N2sgMqqiWJUsq9XfEks++f5P?=
 =?us-ascii?Q?0X8N+3GeM/Z48Wwhxu25Uta+S/U1nGliDGPCJs35l322Ys4cZcb/Mts8KSUl?=
 =?us-ascii?Q?k+H2l2o3DJsmxl8kaNDkBYVhHmOznlbd8l5eHbe0iAAYZCVouw+pdmbxw73O?=
 =?us-ascii?Q?MgZKjGursltm69O0+GxFDooKiB7nRmM1WGiUQUB/DXrhivC7INpMofBLDBJv?=
 =?us-ascii?Q?i9ryZpst6d2uavoymjsKE2n1gZqMZy6LWnSd4yUhtp07zQUkdmlTKnmT0fKd?=
 =?us-ascii?Q?z2n5G9NdKOmEkbDu0PWDGLu6qeS2uvowx9glxBd/tXofD/QoP2wUddFnZRNJ?=
 =?us-ascii?Q?J+tCgBL2AvpLVbquRYS3ncpVgy+bAIO3NXWZRo/5XBdvvW/N9EKvC8n4NIGR?=
 =?us-ascii?Q?D62COY+ev6o86bHjLUL9FMLJiXE+THQZHyd9AxRV7vfsGWugzFZcwSWUO3c7?=
 =?us-ascii?Q?I1/nOG6UJ2Az4f2rKKtB7qrJQd6al6cS7XCyNtwq5O8EKvggqfjyaxtuhYES?=
 =?us-ascii?Q?dQd6kUrGgfEyXXHjXgpHd39g/uQGKXTi6AcljReFizVIzcx/0Cd2IZcsEnh2?=
 =?us-ascii?Q?8TJYPBT1/ar+5X5Rra1H7pmDf0Q/HFtt/RzEWkuVg4BuAZc9FasIxzAGSxn/?=
 =?us-ascii?Q?HJnI/kwQNTeZF3nMRCaGwZ3rYOE78kGQXCiFv4eJTGhKK1VnasZDnhqK8m0z?=
 =?us-ascii?Q?R6+eEsr6aKBCiTbJeQgmDK5P2Y6H03RUIM1+Uljm/9w0Oku6dDy5g5sTM9Xn?=
 =?us-ascii?Q?5ZqDbWMxvOP3p6/AkKQD+9xIu3WDye8lHa0iUMvQs0bEL1+8OnAa4ID/BYnd?=
 =?us-ascii?Q?xbRIXa8c2BmiRCGJr1p/79Mmq4j1sbyJlcJiXQkfSp+nXKFTiwCoOP4sV9tM?=
 =?us-ascii?Q?P+siZaQeQlJ2HvGLCPPWStl/TStxjJ9wENHS+aolg3AzsVz96qU8o0ReqDgD?=
 =?us-ascii?Q?KOT/jSumjhsCAhOOLaESb6fOBVjLBW3ElEdLo/weELnKlmN4yw/RfexnkU9E?=
 =?us-ascii?Q?UU+E4Kv7agR/BqeRIBNY4uofeN26Z4xlDmkuY75dXXikJXyaQWL8z4mRE8kF?=
 =?us-ascii?Q?qCrhqrVycBUrdKgMCXijSZkKBoV0177k6lr9Qr8fcvc0MdsfX35KTGcLPJLO?=
 =?us-ascii?Q?NmmKSk5fdb7RtMIgybUettjRi7OLFQ8=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62da20fa-1ca4-4c7e-46d4-08da1efb0a76
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 16:14:38.8900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZajXe8LPSw9hy43Spj8b3W8WwX4P/Ip1URjzKGHArQafveoicgeKXsWrnx3yv48J3TNDgoLVKQUhi9kgrW7heXXhpUCbZyD81oroO1ZBATc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1768
X-Proofpoint-GUID: mtYkU2HGHYDxWpS_JpKOs31AMkApr0U7
X-Proofpoint-ORIG-GUID: mtYkU2HGHYDxWpS_JpKOs31AMkApr0U7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-15_06,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 suspectscore=0 adultscore=0 lowpriorityscore=0 spamscore=0
 priorityscore=1501 mlxscore=0 mlxlogscore=999 impostorscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204150092
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

commit 87563a043cef044fed5db7967a75741cc16ad2b1 upstream.

The previous commit d01ffb9eee4a ("ax25: add refcount in ax25_dev
to avoid UAF bugs") introduces refcount into ax25_dev, but there
are reference leak paths in ax25_ctl_ioctl(), ax25_fwd_ioctl(),
ax25_rt_add(), ax25_rt_del() and ax25_rt_opt().

This patch uses ax25_dev_put() and adjusts the position of
ax25_addr_ax25dev() to fix reference cout leaks of ax25_dev.

Fixes: d01ffb9eee4a ("ax25: add refcount in ax25_dev to avoid UAF bugs")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20220203150811.42256-1-duoming@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[OP: backport to 5.15: adjust context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 include/net/ax25.h    |  8 +++++---
 net/ax25/af_ax25.c    | 12 ++++++++----
 net/ax25/ax25_dev.c   | 24 +++++++++++++++++-------
 net/ax25/ax25_route.c | 16 +++++++++++-----
 4 files changed, 41 insertions(+), 19 deletions(-)

diff --git a/include/net/ax25.h b/include/net/ax25.h
index d81bfb674906..aadff553e4b7 100644
--- a/include/net/ax25.h
+++ b/include/net/ax25.h
@@ -291,10 +291,12 @@ static __inline__ void ax25_cb_put(ax25_cb *ax25)
 	}
 }
 
-#define ax25_dev_hold(__ax25_dev) \
-	refcount_inc(&((__ax25_dev)->refcount))
+static inline void ax25_dev_hold(ax25_dev *ax25_dev)
+{
+	refcount_inc(&ax25_dev->refcount);
+}
 
-static __inline__ void ax25_dev_put(ax25_dev *ax25_dev)
+static inline void ax25_dev_put(ax25_dev *ax25_dev)
 {
 	if (refcount_dec_and_test(&ax25_dev->refcount)) {
 		kfree(ax25_dev);
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 954196ef7788..f8c39ccd03bb 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -366,21 +366,25 @@ static int ax25_ctl_ioctl(const unsigned int cmd, void __user *arg)
 	if (copy_from_user(&ax25_ctl, arg, sizeof(ax25_ctl)))
 		return -EFAULT;
 
-	if ((ax25_dev = ax25_addr_ax25dev(&ax25_ctl.port_addr)) == NULL)
-		return -ENODEV;
-
 	if (ax25_ctl.digi_count > AX25_MAX_DIGIS)
 		return -EINVAL;
 
 	if (ax25_ctl.arg > ULONG_MAX / HZ && ax25_ctl.cmd != AX25_KILL)
 		return -EINVAL;
 
+	ax25_dev = ax25_addr_ax25dev(&ax25_ctl.port_addr);
+	if (!ax25_dev)
+		return -ENODEV;
+
 	digi.ndigi = ax25_ctl.digi_count;
 	for (k = 0; k < digi.ndigi; k++)
 		digi.calls[k] = ax25_ctl.digi_addr[k];
 
-	if ((ax25 = ax25_find_cb(&ax25_ctl.source_addr, &ax25_ctl.dest_addr, &digi, ax25_dev->dev)) == NULL)
+	ax25 = ax25_find_cb(&ax25_ctl.source_addr, &ax25_ctl.dest_addr, &digi, ax25_dev->dev);
+	if (!ax25) {
+		ax25_dev_put(ax25_dev);
 		return -ENOTCONN;
+	}
 
 	switch (ax25_ctl.cmd) {
 	case AX25_KILL:
diff --git a/net/ax25/ax25_dev.c b/net/ax25/ax25_dev.c
index 2c845ff1d036..d2e0cc67d91a 100644
--- a/net/ax25/ax25_dev.c
+++ b/net/ax25/ax25_dev.c
@@ -85,8 +85,8 @@ void ax25_dev_device_up(struct net_device *dev)
 	spin_lock_bh(&ax25_dev_lock);
 	ax25_dev->next = ax25_dev_list;
 	ax25_dev_list  = ax25_dev;
-	ax25_dev_hold(ax25_dev);
 	spin_unlock_bh(&ax25_dev_lock);
+	ax25_dev_hold(ax25_dev);
 
 	ax25_register_dev_sysctl(ax25_dev);
 }
@@ -115,8 +115,8 @@ void ax25_dev_device_down(struct net_device *dev)
 
 	if ((s = ax25_dev_list) == ax25_dev) {
 		ax25_dev_list = s->next;
-		ax25_dev_put(ax25_dev);
 		spin_unlock_bh(&ax25_dev_lock);
+		ax25_dev_put(ax25_dev);
 		dev->ax25_ptr = NULL;
 		dev_put(dev);
 		ax25_dev_put(ax25_dev);
@@ -126,8 +126,8 @@ void ax25_dev_device_down(struct net_device *dev)
 	while (s != NULL && s->next != NULL) {
 		if (s->next == ax25_dev) {
 			s->next = ax25_dev->next;
-			ax25_dev_put(ax25_dev);
 			spin_unlock_bh(&ax25_dev_lock);
+			ax25_dev_put(ax25_dev);
 			dev->ax25_ptr = NULL;
 			dev_put(dev);
 			ax25_dev_put(ax25_dev);
@@ -150,25 +150,35 @@ int ax25_fwd_ioctl(unsigned int cmd, struct ax25_fwd_struct *fwd)
 
 	switch (cmd) {
 	case SIOCAX25ADDFWD:
-		if ((fwd_dev = ax25_addr_ax25dev(&fwd->port_to)) == NULL)
+		fwd_dev = ax25_addr_ax25dev(&fwd->port_to);
+		if (!fwd_dev) {
+			ax25_dev_put(ax25_dev);
 			return -EINVAL;
-		if (ax25_dev->forward != NULL)
+		}
+		if (ax25_dev->forward) {
+			ax25_dev_put(fwd_dev);
+			ax25_dev_put(ax25_dev);
 			return -EINVAL;
+		}
 		ax25_dev->forward = fwd_dev->dev;
 		ax25_dev_put(fwd_dev);
+		ax25_dev_put(ax25_dev);
 		break;
 
 	case SIOCAX25DELFWD:
-		if (ax25_dev->forward == NULL)
+		if (!ax25_dev->forward) {
+			ax25_dev_put(ax25_dev);
 			return -EINVAL;
+		}
 		ax25_dev->forward = NULL;
+		ax25_dev_put(ax25_dev);
 		break;
 
 	default:
+		ax25_dev_put(ax25_dev);
 		return -EINVAL;
 	}
 
-	ax25_dev_put(ax25_dev);
 	return 0;
 }
 
diff --git a/net/ax25/ax25_route.c b/net/ax25/ax25_route.c
index 1e32693833e5..9751207f7757 100644
--- a/net/ax25/ax25_route.c
+++ b/net/ax25/ax25_route.c
@@ -75,11 +75,13 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 	ax25_dev *ax25_dev;
 	int i;
 
-	if ((ax25_dev = ax25_addr_ax25dev(&route->port_addr)) == NULL)
-		return -EINVAL;
 	if (route->digi_count > AX25_MAX_DIGIS)
 		return -EINVAL;
 
+	ax25_dev = ax25_addr_ax25dev(&route->port_addr);
+	if (!ax25_dev)
+		return -EINVAL;
+
 	write_lock_bh(&ax25_route_lock);
 
 	ax25_rt = ax25_route_list;
@@ -91,6 +93,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 			if (route->digi_count != 0) {
 				if ((ax25_rt->digipeat = kmalloc(sizeof(ax25_digi), GFP_ATOMIC)) == NULL) {
 					write_unlock_bh(&ax25_route_lock);
+					ax25_dev_put(ax25_dev);
 					return -ENOMEM;
 				}
 				ax25_rt->digipeat->lastrepeat = -1;
@@ -101,6 +104,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 				}
 			}
 			write_unlock_bh(&ax25_route_lock);
+			ax25_dev_put(ax25_dev);
 			return 0;
 		}
 		ax25_rt = ax25_rt->next;
@@ -108,6 +112,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 
 	if ((ax25_rt = kmalloc(sizeof(ax25_route), GFP_ATOMIC)) == NULL) {
 		write_unlock_bh(&ax25_route_lock);
+		ax25_dev_put(ax25_dev);
 		return -ENOMEM;
 	}
 
@@ -116,11 +121,11 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 	ax25_rt->dev          = ax25_dev->dev;
 	ax25_rt->digipeat     = NULL;
 	ax25_rt->ip_mode      = ' ';
-	ax25_dev_put(ax25_dev);
 	if (route->digi_count != 0) {
 		if ((ax25_rt->digipeat = kmalloc(sizeof(ax25_digi), GFP_ATOMIC)) == NULL) {
 			write_unlock_bh(&ax25_route_lock);
 			kfree(ax25_rt);
+			ax25_dev_put(ax25_dev);
 			return -ENOMEM;
 		}
 		ax25_rt->digipeat->lastrepeat = -1;
@@ -133,6 +138,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 	ax25_rt->next   = ax25_route_list;
 	ax25_route_list = ax25_rt;
 	write_unlock_bh(&ax25_route_lock);
+	ax25_dev_put(ax25_dev);
 
 	return 0;
 }
@@ -173,8 +179,8 @@ static int ax25_rt_del(struct ax25_routes_struct *route)
 			}
 		}
 	}
-	ax25_dev_put(ax25_dev);
 	write_unlock_bh(&ax25_route_lock);
+	ax25_dev_put(ax25_dev);
 
 	return 0;
 }
@@ -216,8 +222,8 @@ static int ax25_rt_opt(struct ax25_route_opt_struct *rt_option)
 	}
 
 out:
-	ax25_dev_put(ax25_dev);
 	write_unlock_bh(&ax25_route_lock);
+	ax25_dev_put(ax25_dev);
 	return err;
 }
 
-- 
2.25.1

