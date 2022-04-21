Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC84509DC4
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 12:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388463AbiDUKlI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 06:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379782AbiDUKlD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 06:41:03 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC0925C72
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 03:38:14 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23L9rOWU020967;
        Thu, 21 Apr 2022 03:38:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=Y51S0zNai+VsC0pN4DKPayO7CJbwgw6YozZnpa/W+So=;
 b=LDYxTwpNgrnwllnC0CAcnpRMxDMmMCjVkJpOxSsuSYkq01MnOcL5kC55m1YLo8BH/1yK
 qI+ImiuVgEbwiQ91G9hKQ+d8+AAL9+kzOP/MopuZzAuxba6rfzPlTgNKOTd5u9dHgHEl
 OrnaNz0X236PoED3X3SZkPvGIm3BJVjOa8Z/CdSstobpZGmhzcLKKpWSltj1kPDeuqBL
 ZTBUnUe/tFljLYAwST3U1Ys0rp2b5Uud+AcfTIL8uuchhnYlBtUpreB09BaUui7FQWXU
 6vhtXZJXd9dGlaR+hcobq9kCOD3TGhkSdRkQCnZAeKqR7ZLDjkEqhtu5JMSlqNUrQC9m Lw== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3ffs313nqc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 03:38:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d6uMvL3d8kgXSeWX/Atb7ugSmqG0R2Bcn6WE1WHESjIszbB9PV9+XwgoI+qeAY69EATV81mEf796Ez9/LBZ6bzrojs8bgttQBzxke7j8zQ1qDKZTpoNHxtEGDqnczqfSK5wEj+LC/kBbY1wpIY9rHcS5xJgQ6l1/XlvGeUtXNtACSoQ7L3KJPPPBhwP1BjmL4qAGExlazrgd08EOL/jZ9h2/ytDYTtTQ7r1D+aoa718jg+trnc3u7DKdK5vr1lguepZUMbpwhyCUi9ABv0cDLonZxNfTtu2PzVtsQIV6PIvq22gcmSUWgik76lOfSz92WtD5JfOpUuF4a17mr0kMFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y51S0zNai+VsC0pN4DKPayO7CJbwgw6YozZnpa/W+So=;
 b=SSfMG53JdBLgoeShmbOns5nOeNHRvVvafK8BsTLVZbyzlrdrTvT81oztEu9s8qsx04KK85gu3Wj+nL6gwpWDodL+Tuc09cWKVG3in4uRGyogNzX1y6mYJUeth7CuN9HL0AumzgwoYbe2M7KwPmYymQjE9DJ7dMthB/EmaPtCNE9erFlKCX0MlIH1L5n40kBavWLOq/QXB/F9aEsUoUSQNn21gBQKA7EPdBJTtrUQbLlheZiY+q9hmhKuqCjZWGLKzf8Yp4g+VAAoZmN9gYWswi2v8nazuxbOgVlCmHFPxwVx4uAsFV01iR5vIj8zCnr6sxsaqZim81WUFCrN1f5zZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM4PR11MB5406.namprd11.prod.outlook.com (2603:10b6:5:395::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Thu, 21 Apr
 2022 10:38:02 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.025; Thu, 21 Apr 2022
 10:38:02 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Duoming Zhou <duoming@zju.edu.cn>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.14 2/8] ax25: fix reference count leaks of ax25_dev
Date:   Thu, 21 Apr 2022 13:37:33 +0300
Message-Id: <20220421103739.1274449-2-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: c7d544d8-ff12-46a2-b6ca-08da238302da
X-MS-TrafficTypeDiagnostic: DM4PR11MB5406:EE_
X-Microsoft-Antispam-PRVS: <DM4PR11MB540643AA2AC951081DD29370FEF49@DM4PR11MB5406.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oSW6GcJEduMyJ+DLOYJtZXRv3siwFZt9LjmdGVmrk/v3CVqqwDwqyyf9k6fYsKWZZGD4GN8sUGK7qTf+9EzZzDVkNuIPzy9Khna+FjQ0a7s9scOuWcS3jr+KIbDqaPVFvgOjJ47y1upq6kKsyefmzwLNuI6TRAV35ymWi4ErKQawuSrYznlRw5DlMqqkIPxdH9a8/x3eakVEITi8iq6s+ZDfzHwIuxdc766OQPT0hGi7anxIAVc1kdvhHvbBKWzXdy7Yx8LYOcAmDyMB4dYAzZ6h1+cN0RYxeVs4DhRtTyw4jylaomRWsaVfpa25lJBIq56fPoC1QFw7gGFxD4Z1JVzVemP1KqnVjQ7rhDwMNCveB1aZdhmzosInV8QgmgvW2LXwmQHKPB7W6A+HxLw1C4ah9E4yna3YN1rDBBD/qP4SZkzXa73yKN5yOmUGEltUhYPv8ACndSSK/0MlkkhXJbicOZlhCfPVk15F9fXCewVmqJof9h3xCZ69GlS+0v+AKxa2dG0XeLmsV8pvFPGwxqY/Wy9STs7QRtBHiKFfR1NgZRv61xb+aPySNe8LYTydXLgI3kSgRj69WuPl5DlPZnAr+cXyNZCdlHcwN1J4nMbcpPDmEwsg/7WeXhrBj6fmSZpDSIOMBGnmkWDR1FwHcJfEWhgoAtantYUrzcnqCu69uGywOq6//kLZTpxHjr2W0zdfNIcz7KMwQVTu1+xWO7NWdvBIfxHMY7VSRjfdeHpoRQhcR5xf8a/hD87wYuxqSSGShSWgqp8M+iZF1R4Iap+a32rN/mh/jWoFwWcrqpg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(966005)(38350700002)(38100700002)(26005)(508600001)(8936002)(86362001)(6916009)(316002)(54906003)(52116002)(36756003)(186003)(107886003)(4326008)(44832011)(66556008)(83380400001)(2906002)(6506007)(66946007)(6512007)(5660300002)(1076003)(66476007)(6666004)(2616005)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g5JWRnfAjXsWyx2S467vGHeni3V+dUymXV+wzsBekiJqTLk6xry5OU8zMzF/?=
 =?us-ascii?Q?3E7l7xzhRtvkYNgreoYvSi6kvjkYMmIqQ+76tvbWQ11UbY7+cPPnIaWp+lyy?=
 =?us-ascii?Q?YwP0eVoYkHwaweJk8YVv91pfogK+nXCOO3L6ZZUcyQMp7mTHUZNbmmmOPGWd?=
 =?us-ascii?Q?vxddKXZ+/yE2pDjsDvqqaC4qualopEdaBTxRjMaYM95FWx3SPtj65ff57Dqo?=
 =?us-ascii?Q?kri6P6f+wItU/uT07CWqUDSzwpenI69bSXrHA/Udcf0yY12T/HyguP/U827E?=
 =?us-ascii?Q?DwCROH4krsgchRWyaD7dDDsKv4/b1kAD/P964PrladaqdKjpGbtlsCHTVb2A?=
 =?us-ascii?Q?1B2LqcxYn4ypPYs5163eZ0WbG+zlQeTcMAOAqbY0UWXzeXcZzUCRfPKwbzOg?=
 =?us-ascii?Q?fPP6s4ygc8LkGlJblCzfbUXr1z5EYmMTKil+jTsHEHmY7Pz+vTCBQ1H3tSBM?=
 =?us-ascii?Q?2XJQLOf8fDOU3TdpXAtjLDDfVpst9ORLP08msi9q9KnhybjCFoz/WsEBKowo?=
 =?us-ascii?Q?zpzHVycS2XjVpQ2RAagia0vfnR+URw8DX2Wu4HxZ+xqPto1dlcAPNkd/Lfa+?=
 =?us-ascii?Q?cb6aaH2hNeh6yN5ElaVbXKH1UhO9f6jONu132z18SN50M5LsKhRtriOI7eP2?=
 =?us-ascii?Q?JDRADE0KFBx43V0y276bUsFBjTojSfgeli+jklxjO+xn8f4qmai460QqyuWt?=
 =?us-ascii?Q?dADQ2QtHiTxlmdWPTICF4peFS0L+CAu8/6kBO1YpCqmajTryN6lzNhEaen7o?=
 =?us-ascii?Q?aHX5uHHjJ6wRpTgvc8SVmN5iXAO16p4gQ92+hhAJDYZe9HMMwYphj+vQTml0?=
 =?us-ascii?Q?/TI1CB9i/bx91CYI3/Mi/dpRAAGxH+cZ+tQ8yu6dsCeOErr7Y1HxHH5B8XgB?=
 =?us-ascii?Q?YlfEsN9m8OAsf6HjomSr5nBRIc11z5x9CsHyVsRA5OL9tKDHvziD8FIQRcwh?=
 =?us-ascii?Q?t0C9Qj5ZWJNM4vzUBUDjgayz1PqJXksp8Lpg/U2ocjuDEIKeBGCo15bghIY2?=
 =?us-ascii?Q?KeM6fywdKet9X+a9eyXv2Ms7rdsZt6eQezqfn/2C7AsGo850mn5tpPWOBN/K?=
 =?us-ascii?Q?FMjFAUdB0ovnkUtsKVebd+qJm4X6O/6DNaB70x19wdmBlPNnq2cN1+rpWqJO?=
 =?us-ascii?Q?lJjXtwTxM5fP9h/Wdkq8FAVw7yDH3tw+TyrLUdk5LfJkM5V3J9o2floM4PGe?=
 =?us-ascii?Q?a0KjwUFccbIxvWH6ATS400ZCXYTKODbawdrIXLKxPinsIQsJa6yUGgI5t6c4?=
 =?us-ascii?Q?OVVcOKJHeNm1y9vfeUQIYuLJraAcaHM3EdTwXt51Xy8/ncMiX3onsM27L7FQ?=
 =?us-ascii?Q?ir91dZ8ebMlAvB/XAszmKnESPZHtmhHNQglGIK4QuXVAJt7xKxv+zMrno4qS?=
 =?us-ascii?Q?GXvM7KfL7jjxj3l9ynqwIY3VLDHsCuR+nqmO0N2dUXaHio6kN8n7rEvtlkuD?=
 =?us-ascii?Q?4cTNs3Yq+hjHYzx7pYE8dKqXe45l4+5wqqTObUvkQrO4OmsjQve8Qgo4hTRA?=
 =?us-ascii?Q?JNPdt+n9//cNWZ9bW7ERZxYKwayKzSyxUjcHihCR2z4ulAK8SEFiqsel3/zB?=
 =?us-ascii?Q?0EL8coBvD/XhRiJSH3w4I9Kkna4oMnjmjuQCI3CmNU/+TS5QZTf+OJwo9OF4?=
 =?us-ascii?Q?2j8TCyxB03WgM6IbgW5Yz6mXFtF5dOrBctJ2D5H3tgbS/ZccMCSTy1IzYJCv?=
 =?us-ascii?Q?bPXGKmOlYTnNnnRlcmr+9TS+3g3Mv8fGrpM0gBB2HEMx7vLlquMNpssupl3i?=
 =?us-ascii?Q?KmxE/H79AxfoOHVGE3SzQCoIz0gR5KA=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7d544d8-ff12-46a2-b6ca-08da238302da
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2022 10:38:02.3328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5GSgWuelLuSYhOsvxwTv8R0UIVfhgpZTR8dwU8IIQwkkoSaKjq3zcFThhWwSh3F647oPeHjxEpQna9y8uETCWBC+7GEAACc3MzOdaASmbn8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5406
X-Proofpoint-ORIG-GUID: y0BshWE5NZtAcg2i5CjmF_dqYkI40xb-
X-Proofpoint-GUID: y0BshWE5NZtAcg2i5CjmF_dqYkI40xb-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 clxscore=1015 spamscore=0 bulkscore=0 malwarescore=0
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2204210059
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
[OP: backport to 4.14: adjust context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 include/net/ax25.h    |  8 +++++---
 net/ax25/af_ax25.c    | 12 ++++++++----
 net/ax25/ax25_dev.c   | 24 +++++++++++++++++-------
 net/ax25/ax25_route.c | 16 +++++++++++-----
 4 files changed, 41 insertions(+), 19 deletions(-)

diff --git a/include/net/ax25.h b/include/net/ax25.h
index 390e32103a6e..5db7b4c9256d 100644
--- a/include/net/ax25.h
+++ b/include/net/ax25.h
@@ -290,10 +290,12 @@ static __inline__ void ax25_cb_put(ax25_cb *ax25)
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
index 3f13c619824b..e699bd80a861 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -370,21 +370,25 @@ static int ax25_ctl_ioctl(const unsigned int cmd, void __user *arg)
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
index 76d105390706..55a611f7239b 100644
--- a/net/ax25/ax25_dev.c
+++ b/net/ax25/ax25_dev.c
@@ -88,8 +88,8 @@ void ax25_dev_device_up(struct net_device *dev)
 	spin_lock_bh(&ax25_dev_lock);
 	ax25_dev->next = ax25_dev_list;
 	ax25_dev_list  = ax25_dev;
-	ax25_dev_hold(ax25_dev);
 	spin_unlock_bh(&ax25_dev_lock);
+	ax25_dev_hold(ax25_dev);
 
 	ax25_register_dev_sysctl(ax25_dev);
 }
@@ -118,8 +118,8 @@ void ax25_dev_device_down(struct net_device *dev)
 
 	if ((s = ax25_dev_list) == ax25_dev) {
 		ax25_dev_list = s->next;
-		ax25_dev_put(ax25_dev);
 		spin_unlock_bh(&ax25_dev_lock);
+		ax25_dev_put(ax25_dev);
 		dev->ax25_ptr = NULL;
 		dev_put(dev);
 		ax25_dev_put(ax25_dev);
@@ -129,8 +129,8 @@ void ax25_dev_device_down(struct net_device *dev)
 	while (s != NULL && s->next != NULL) {
 		if (s->next == ax25_dev) {
 			s->next = ax25_dev->next;
-			ax25_dev_put(ax25_dev);
 			spin_unlock_bh(&ax25_dev_lock);
+			ax25_dev_put(ax25_dev);
 			dev->ax25_ptr = NULL;
 			dev_put(dev);
 			ax25_dev_put(ax25_dev);
@@ -153,25 +153,35 @@ int ax25_fwd_ioctl(unsigned int cmd, struct ax25_fwd_struct *fwd)
 
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
index c13f1e897b39..7d4c86f11b0f 100644
--- a/net/ax25/ax25_route.c
+++ b/net/ax25/ax25_route.c
@@ -78,11 +78,13 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
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
@@ -94,6 +96,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 			if (route->digi_count != 0) {
 				if ((ax25_rt->digipeat = kmalloc(sizeof(ax25_digi), GFP_ATOMIC)) == NULL) {
 					write_unlock_bh(&ax25_route_lock);
+					ax25_dev_put(ax25_dev);
 					return -ENOMEM;
 				}
 				ax25_rt->digipeat->lastrepeat = -1;
@@ -104,6 +107,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 				}
 			}
 			write_unlock_bh(&ax25_route_lock);
+			ax25_dev_put(ax25_dev);
 			return 0;
 		}
 		ax25_rt = ax25_rt->next;
@@ -111,6 +115,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 
 	if ((ax25_rt = kmalloc(sizeof(ax25_route), GFP_ATOMIC)) == NULL) {
 		write_unlock_bh(&ax25_route_lock);
+		ax25_dev_put(ax25_dev);
 		return -ENOMEM;
 	}
 
@@ -119,11 +124,11 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
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
@@ -136,6 +141,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 	ax25_rt->next   = ax25_route_list;
 	ax25_route_list = ax25_rt;
 	write_unlock_bh(&ax25_route_lock);
+	ax25_dev_put(ax25_dev);
 
 	return 0;
 }
@@ -176,8 +182,8 @@ static int ax25_rt_del(struct ax25_routes_struct *route)
 			}
 		}
 	}
-	ax25_dev_put(ax25_dev);
 	write_unlock_bh(&ax25_route_lock);
+	ax25_dev_put(ax25_dev);
 
 	return 0;
 }
@@ -219,8 +225,8 @@ static int ax25_rt_opt(struct ax25_route_opt_struct *rt_option)
 	}
 
 out:
-	ax25_dev_put(ax25_dev);
 	write_unlock_bh(&ax25_route_lock);
+	ax25_dev_put(ax25_dev);
 	return err;
 }
 
-- 
2.25.1

