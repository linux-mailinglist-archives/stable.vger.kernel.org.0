Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3210502D8E
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 18:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355280AbiDOQRQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 12:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355763AbiDOQRM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 12:17:12 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AAD71D326
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 09:14:42 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23FFQIe2014393
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 09:14:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=7Qv2z94CXNgn+dmn6Zg5YE+WbYUZP3D3dxz7F9XUboY=;
 b=Vy1LJ0358+Us5LJTdcCPuHyaP2kjVVc1de9YgZvwgckFJcu4ST36A+wfVl4HvPcBMS/m
 FXq37mcMq1yI+UkWlFdw9X78/vFgAkecnjD/gmFB44+3Q83gnco69xMvX0CoPRs88pOS
 JCJltyr6wDVk6Z8Z8X3YGcbg++Sza/T/fnfta0KEI7zsjg12gVOfyX4jKOw81/+l1qzl
 e1wj388PyvP7ZPc3e58EGLWORi1UCtmZdGVfAKgvqDIJoQEmQTB9a0+ZslKfZj+w2OWZ
 kOhjA6icPb2xJqKzmE5xXNTCKtYgIA92xzVK73LHHSe6OYTntYS9rzo1fgvCBZCy6K6B dA== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fb9nfvsk3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 09:14:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FKAgBfW3LcZrbfFO6bSDyrPxpJOxA+rDxymgDDcCNb+u6HLeFraUI06QgubQilwVzbeZBp5wkGK8o81dViLf074whfLK5u0bnID3gSJ20cO2S8uIOHr9r5WxynArYBcnyybDZiX6tHar1fLJH9bbggJO3+LvYHqJPLlpiSQkIyHGuMQlUZhOsbXc2Wqrg3CdKTU3N1DGavLCJCE2StTgPMjsXh/MRe8RZRbOC4Dp5qc8yKe+JUJuYx2hqIzZTwKHYVBnu4V8Yz2fcDLVGlaNsbIJkFqE3H4dQa0Vv4NgUKAwzSEJ9yd/VpE7fhIjEd3MIXXBV1tY3jDRNYtR+o3gHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Qv2z94CXNgn+dmn6Zg5YE+WbYUZP3D3dxz7F9XUboY=;
 b=mmaf2vvK6VU2fmSehSQuFnbU1Pa+6gUS8a76Slw1IqhzKSMM1IZ82OgK6iGIWsO1KRHM1VcuDKrD6CPb2yuqCKwSCni5enokowdgFlijBMgAZR4G+CJUBgqSNE4iT1phgNGFU9GENPR3nEVM1En02PLyYOF8bM5a290D3pS6Zqe0YsWQx/NAOsfGeZGzWE7Byo1aIynjr/7gzu3z4jbBWErVB53bqx2Sz/ZzwUn4PCDeoL/zD7DpyYASzadGItxvYgNmi1juiqHeiyutTT7beMIRy/z1g/kS4faRMhxbbC98BYpUo9kV8X9+KhtH6NraT2+c5+Iu3TO6qEbvQp6GBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB3626.namprd11.prod.outlook.com (2603:10b6:5:146::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 15 Apr
 2022 16:14:40 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 16:14:40 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.15 4/8] ax25: Fix refcount leaks caused by ax25_cb_del()
Date:   Fri, 15 Apr 2022 19:14:18 +0300
Message-Id: <20220415161422.1016735-5-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: ec743d6e-ddda-4f55-aaf7-08da1efb0b6f
X-MS-TrafficTypeDiagnostic: DM6PR11MB3626:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB36268DEC66C5B385A6C8E66EFEEE9@DM6PR11MB3626.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HO6gZzxL5V9TI76cMyc0GRQKy3/W4KvrHTbM2gfp8LkmPjVgKbj1y3ZEbZsytFNPO2bozEbuDKzB6frBPgMk3PHVY7gK/Ry2iHNHWN0W2tcBi1RKe/eUaCI44D48hzIHnEB+zSkAA8jI5TsagK1UZdlpcmhMIht1aHXIEnyIHYwucotl1xIatBra+5PN1n6dyBIL1Qh67XqXVmQH+z5c7SY7RUlYjqOY7zf49wAbhhNpkGQOlZOEX71Kn6edzZsCp3fYvmLLhEqhEPwNpZ9pH0PXxSqtAaXiMcqemQuPmq61QX3rb0sn40OXM88hmoty6N/rXQij8pcCXS8HP6lLx3EfHBGULI84eM/GN5gkDm3yavf5itcnVk7bsbpXw7kYfjcSarv+gGDkZG2MKbtjA/UhA6pwerrOYyKyzZsD+4bEaCJYL9EBa9y2E8yvDxA4LpIvWWg2MAXGDRZSDmHg5QrRrpmzgJxdqhiM9GjzFUC2HEQfmD8WYqA7ZQ3u8C/Cy4Js5rMOyMOUSfPvVj23wv4AJfR5M2XEphJ3Q6+1YZvZvJ8KZo6N+RF2M4pAHpEHPEdkAs7fEa7hYMwEG+Fvl8g26QgL1rvRiBn8jqB3Di5JvG3yey8C76+nuCH9+nwc3FTAHjJYrYJjDTWbd6B5AIljLfMov4c9ZMA5WNF1rS7M1HUTqCic68Mvc7nE6Exknpzxn1kBwE0eZd2L0aqWNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(38100700002)(8936002)(38350700002)(1076003)(6506007)(26005)(186003)(2616005)(6916009)(52116002)(6666004)(508600001)(6486002)(6512007)(316002)(66556008)(66476007)(66946007)(8676002)(83380400001)(36756003)(2906002)(44832011)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aAONGUgCh4nHJrcUeG8tL8GBkUsrln+iSRIS8BzzzeibYXbV+jk5BSR/x3qj?=
 =?us-ascii?Q?kldozzGn9O1K1ubBplc7a24O4OVAFcFwETpKCCg1VESwSEXoeY2lnIgSPsDX?=
 =?us-ascii?Q?A2hIRJKkWk+gGCmD87VXq/9jCeDngX2rR+Mu3FR/SkQxDTVfwylHXACTrM5Z?=
 =?us-ascii?Q?2VjrkF1/3fx2AvWE55zxAXirhi8MFnAfVD0RIt0DdgoPtCgTXjRHOWmWxo1A?=
 =?us-ascii?Q?oSJ0Zf4gMJsjiaX1O5VSSX/LfJrDpjGAfZQRGjV/UVif1B21VMireJy4YCNZ?=
 =?us-ascii?Q?nrhb7o3E8XIRstceLynwzIahLg7Z3DRPg4gpCFiCTvLdCXWrhJz7SOiCBEps?=
 =?us-ascii?Q?VPMHus0IexQb2zFNLLUMs8e+EF6Ds3FqxfHVJhzLIZTpk4t8/KLY4OIhFw73?=
 =?us-ascii?Q?CqZS/Rd576VdSHKbS8CWE2XHV/nBMUd0uNPoduivPrpj4t8kF/XdsS/m/86S?=
 =?us-ascii?Q?kkC8K+mKAabPHjIw6v9ST/08py9FcM1D7sYPCSaRuifQAgaLWfQtv/oe4h3K?=
 =?us-ascii?Q?iJlU1MRLm0DBE9jUgbpVyge3iYvAasoKAqlxu26TiQ6jTH6Ip/Pb0kf/Y+mS?=
 =?us-ascii?Q?bSyx1MXto+XQGxmI8lR0jHRSZbSA/aWoFEV/up2Yo/ZxDkxNUL5rTlIp/8Cn?=
 =?us-ascii?Q?4LLhUhZDmN8oc6+fvq8uCkg6BEvrLAqoyVwOmwyLlKwF7UrMoB/aaDufyp1n?=
 =?us-ascii?Q?1HJZwQUfAEmTHLfdB6OnM6O3lzOshWpXDLkCyl+Lg/jYOdQXD5D1wLdLfZei?=
 =?us-ascii?Q?YHNjZpmCRzDkozXRQ6K6AnawHjexTNbsNksYEXgtNsBI/0e+ps7xHfJvXVdq?=
 =?us-ascii?Q?vcJR0FWEJDX9lt8VdWyeUThESgCbdDlnTnTAiB9shFq8PcFcy4zVyvjlqdIF?=
 =?us-ascii?Q?TRH90kiVlPniBBum108/UkMsazRi3FBvHuqZvQMAQkYmpQ9ofRgMW8JkelAG?=
 =?us-ascii?Q?2ieiVEqBOEmnKA/SQT0DvlQnYi5lVBfYYZ3Gl+bk0xrfc3/nZNkJW3rbzZG4?=
 =?us-ascii?Q?9bDUGTfHRZciQFBGlxTYPeL1iMaXK2e2zpTv6/3s/prwhRGMh/yb93jiHDys?=
 =?us-ascii?Q?Xi0NTy8dJp9GM+Bqkr2ittYFVTwwVKR5juBzh64NbLQhZV/AFE/wTD/0yHaH?=
 =?us-ascii?Q?NaWzvOeM15N/QG7Z4bAa6sL6fenMEGYYMZ5DSBplzYsEaGIEpm1iDi/gHy1c?=
 =?us-ascii?Q?8IZrnduVKE+nTIbDsZf/hbMXA4XMeXOh4jnYv/BOMHoLYuMZRmDK6gx7Ix8B?=
 =?us-ascii?Q?HJwz1zobFindCmNRT8ZMbB6wxoRYOZL6YOnW1O5ViGk7O8+NHWZh8kWEZJHG?=
 =?us-ascii?Q?EOdQrYVMojJbUSKnyZxd8DR4DaUtLoXIo7J4TTBzR0a1hiy7Xjsohq2zuoW5?=
 =?us-ascii?Q?PcH24PBzgz9rJEFvu/kAeyv9cHAfQZs8LaVwo7lv80yZV2YzWqAVr5obvAaN?=
 =?us-ascii?Q?9XX3WT6S2A4Dpl2oXRZnhhfHysFoQ615t3rIL/OrDv1nxfs4JABca047NTle?=
 =?us-ascii?Q?wr3HuvQ0+l0DXs39gO94vpOjw/6qylkxCHQj4M9NiJY+0dsnB09UGkhm6OUh?=
 =?us-ascii?Q?1Ah/BTZziITxmIX5oA8NzKzxkjZBtYIUupsnFu/wQfx6PxBd48NeTt5Q5Jtl?=
 =?us-ascii?Q?5upzopHl2HmTP5t/lpDvuBAHAVKPXUWx5moTkraaWgG2ko3tGa1A8DaSIL7n?=
 =?us-ascii?Q?qokhFl6hZ2G0aZ8fVmJBNPMPMmkOb7BooonvBN4PoUZK+unYS68v2lu7nVnh?=
 =?us-ascii?Q?vAdLdPi4OBB2Rs5B7EUpV34YY90IJk0=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec743d6e-ddda-4f55-aaf7-08da1efb0b6f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 16:14:40.4932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wKarfHSlTaS34g42ra6u2cOWMjYmkWcPISXeUCcwanK5spfJszpbOcJdxranyq1XGuAKv6KbCAY4/dzREBw/B9i6TfncQLzKEduU7MCTlos=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3626
X-Proofpoint-ORIG-GUID: FyL8xy-FB2gEY9eoSfA-Oz9WMIgxRSln
X-Proofpoint-GUID: FyL8xy-FB2gEY9eoSfA-Oz9WMIgxRSln
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-15_06,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 mlxlogscore=945 bulkscore=0 adultscore=0 impostorscore=0 malwarescore=0
 clxscore=1015 phishscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204150092
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

commit 9fd75b66b8f68498454d685dc4ba13192ae069b0 upstream.

The previous commit d01ffb9eee4a ("ax25: add refcount in ax25_dev to
avoid UAF bugs") and commit feef318c855a ("ax25: fix UAF bugs of
net_device caused by rebinding operation") increase the refcounts of
ax25_dev and net_device in ax25_bind() and decrease the matching refcounts
in ax25_kill_by_device() in order to prevent UAF bugs, but there are
reference count leaks.

The root cause of refcount leaks is shown below:

     (Thread 1)                      |      (Thread 2)
ax25_bind()                          |
 ...                                 |
 ax25_addr_ax25dev()                 |
  ax25_dev_hold()   //(1)            |
  ...                                |
 dev_hold_track()   //(2)            |
 ...                                 | ax25_destroy_socket()
                                     |  ax25_cb_del()
                                     |   ...
                                     |   hlist_del_init() //(3)
                                     |
                                     |
     (Thread 3)                      |
ax25_kill_by_device()                |
 ...                                 |
 ax25_for_each(s, &ax25_list) {      |
  if (s->ax25_dev == ax25_dev) //(4) |
   ...                               |

Firstly, we use ax25_bind() to increase the refcount of ax25_dev in
position (1) and increase the refcount of net_device in position (2).
Then, we use ax25_cb_del() invoked by ax25_destroy_socket() to delete
ax25_cb in hlist in position (3) before calling ax25_kill_by_device().
Finally, the decrements of refcounts in ax25_kill_by_device() will not
be executed, because no s->ax25_dev equals to ax25_dev in position (4).

This patch adds decrements of refcounts in ax25_release() and use
lock_sock() to do synchronization. If refcounts decrease in ax25_release(),
the decrements of refcounts in ax25_kill_by_device() will not be
executed and vice versa.

Fixes: d01ffb9eee4a ("ax25: add refcount in ax25_dev to avoid UAF bugs")
Fixes: 87563a043cef ("ax25: fix reference count leaks of ax25_dev")
Fixes: feef318c855a ("ax25: fix UAF bugs of net_device caused by rebinding operation")
Reported-by: Thomas Osterried <thomas@osterried.de>
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
[OP: backport to 5.15: adjust dev_put_track()->dev_put()]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 net/ax25/af_ax25.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 1235bbcc7953..13e8c9a0cf4f 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -98,8 +98,10 @@ static void ax25_kill_by_device(struct net_device *dev)
 			spin_unlock_bh(&ax25_list_lock);
 			lock_sock(sk);
 			s->ax25_dev = NULL;
-			dev_put(ax25_dev->dev);
-			ax25_dev_put(ax25_dev);
+			if (sk->sk_socket) {
+				dev_put(ax25_dev->dev);
+				ax25_dev_put(ax25_dev);
+			}
 			release_sock(sk);
 			ax25_disconnect(s, ENETUNREACH);
 			spin_lock_bh(&ax25_list_lock);
@@ -979,14 +981,20 @@ static int ax25_release(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
 	ax25_cb *ax25;
+	ax25_dev *ax25_dev;
 
 	if (sk == NULL)
 		return 0;
 
 	sock_hold(sk);
-	sock_orphan(sk);
 	lock_sock(sk);
+	sock_orphan(sk);
 	ax25 = sk_to_ax25(sk);
+	ax25_dev = ax25->ax25_dev;
+	if (ax25_dev) {
+		dev_put(ax25_dev->dev);
+		ax25_dev_put(ax25_dev);
+	}
 
 	if (sk->sk_type == SOCK_SEQPACKET) {
 		switch (ax25->state) {
-- 
2.25.1

