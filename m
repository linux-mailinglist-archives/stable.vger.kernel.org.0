Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CDBC60C5B6
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 09:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiJYHpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 03:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232039AbiJYHpR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 03:45:17 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE03102DFF
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 00:45:14 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 29P6mmHW010829;
        Tue, 25 Oct 2022 07:45:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=Y8u7JvtqLjMXEQjOZ/XjzcjArTn+sBsqWpNZLq/kzZs=;
 b=mll+w/9VeDTXMFokKYoWpEk/0Yyr2spnlqY6zY9fYYkcY/SdKAmlA3pLLruQCtRdCkgl
 tsd9uJMzbcQFpUQ62mo4JIvyosAeuTpaqpxmCY2noU9exFwCFInEKjayPE5PNPKArzuI
 9rdYvs0UL8tCU9fIUPX7E9ja1//eKakvTw66U9u/5a+jVvbcANMnNLvbf3r1ZFaVZXrv
 hkL2xbZQ4Y50tTrdmHo5vQmCiz4ZEZbMrIn1Gu0FYKlCgIKNYwMVZOt9X/pm2KuqUMXJ
 FcNd7T96Q0GotTVUXXCne588/Ma33oTSjr44rceRN33X5ArT/vhrHeoHDMmSgk/KkC3Z mg== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3kc7g9u17e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 07:45:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UnzfFxivZKpy1/RX6NQ0EiCG0Q32S6ZXrDsD2lq8bbhgNEquBmmiQvX6ls+S7yNCM/jqDVC9lQdWR+75QSYi7j/an3auPxixlS3gRBi7+m06T0qOk6PXbzhuQrynDTkUPCUZ192jgt9UBkVAymApKYqLyOQ8zUJqEkWYxldgeD7mPh37AY2vJAF2k7AdwVIi2sOp8aFQrC4ue+Wgb4aksX46rTWlEMPi7CHwstZ0CKdXhaq3Z41xhNFZbW5xVK9a8RPV0oqpqPkHUz8l2PGhSQ4xBilRkXMkSmFE1sA6OhhDKsIdtKP7P/NpS0VFs8oXAdJ/iOi5Epi8fZk5LF5x7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y8u7JvtqLjMXEQjOZ/XjzcjArTn+sBsqWpNZLq/kzZs=;
 b=GDjBJ1SrOi/uP/CFr5p4/d6uwOxSC9ZioCh/eNF/HMXxaxBdkGOdjc7XRUKA7Na4/IVc9srHozV6iuhF6fOVaiQTX1cHimtWsQNQqv57+H4WfG1YhK9tAmrRm+M9VqE2UJnS2WBtc+SvcBKl6OZaLgMKqlWBwSTIJCDsO1lqI7+kfdTChK5WEWjXGmU4HUbFHhgKq6siu6HR+TLD+A2I6ikK3469TnJQMO5JXaCg9+x9JPjfDHuXkUUdE541aLSzA4wamQ84EgN4VreUGxRr8DT9uBtQ0P4SkVw5gMffJXxbGQZckFA+ukw29UmPEiR4qZHIw13d35BlOmjF7PkcIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DS7PR11MB6245.namprd11.prod.outlook.com (2603:10b6:8:9a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Tue, 25 Oct
 2022 07:44:59 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::a8e1:fa27:6954:d5cc]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::a8e1:fa27:6954:d5cc%7]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 07:44:59 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Chen-Yu Tsai <wenst@chromium.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 1/1] media: v4l2-mem2mem: Apply DST_QUEUE_OFF_BASE on MMAP buffers across ioctls
Date:   Tue, 25 Oct 2022 10:44:40 +0300
Message-Id: <20221025074440.3756462-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.38.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P193CA0010.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:800:bd::20) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|DS7PR11MB6245:EE_
X-MS-Office365-Filtering-Correlation-Id: 95dc4fb7-380f-457e-c4ca-08dab65cd117
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +03QC1PZWuE3OA260iDrp3elCqmLBOWM1lg9R+I3AzyHMrac29cm1YR6TmltmRuU9CYEiHxJmSOptMggO4JkKgO6ifuYcPjBAM6pyOHhfHZnAoJpLDZOexpDThnDwSopKDbNQ+34u69l8+o6t6dnAGNinG4sWTtIwM9md39z1/7nDaXIuc5Osstcy+VNhaVA/TxcGoO8Zix5lYgF9qRidsh2EwPWhaoF2VGH6saKyVf+Cesqc5JewuwfHbIgT1i8HsUW3g5ZU+jeeJERsRoddVTUrjGt1ToOPNwQ6igIfu5rCGCeSxk8cYoQGsirUMGyBGsvY8wc8Oix95OyVjMlG+9gb7lX4Gck05G+/za/uyO4ngTof4xsXF83DAOpiG83nuBJYia30I2QybHDQLfkoNmdeqeQ5tQ4wnvGP4+E8qUEHdlkh7IEMhvGx8zFYu3i1GomOb4HbhGkSfcNvvb6+SrpxOHUp+KkjSjjJ8IexY6sv8k1PCKo++xtA83GqAkvPo5BKUxl2k80Z8eFhaixy0KYiySvckdSuhBVQZivuIe1f1JCMP/1fWghnGMX0dZPa74ZpacYUUYacsXiiN9q/y8uLUAZTfgzdr3xw1LNC5D3Hqdhnfyr5FNGqbdoQDgVqOK9S0IYzAbKO4J+oFb//Vtd7Yi/1z0Ref8WtpgnufKYaiTpP6gFzHMKV+lt4GfCtBZxWEp2KONsz8jxjDe0IDudlhIBceLaI0DsD0l6eiqC1ZHI9h+4dlOMg0b9Fy4G
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39850400004)(396003)(136003)(376002)(366004)(346002)(451199015)(26005)(6486002)(478600001)(6512007)(107886003)(6506007)(6666004)(36756003)(52116002)(2906002)(86362001)(316002)(38100700002)(5660300002)(38350700002)(2616005)(1076003)(83380400001)(186003)(66476007)(41300700001)(8676002)(4326008)(6916009)(54906003)(44832011)(66946007)(66556008)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r3jHYlqZVr4hfNuAHkmd1CLAJcXICKYn/hOBae1c2tyT8t05L+QMh2htsFyu?=
 =?us-ascii?Q?g1eJCzcZggsjOibKyt+cwyMkHtFqP+8VcmjxOqSJVkLn6dsUJNlUI92Gl+Nx?=
 =?us-ascii?Q?oBzucXLYR5GXN1azLkuk2zuiFlH52s0BePiHRWOMGZwato4VMgBfTTSyJ/+/?=
 =?us-ascii?Q?1mWXZXKpPUxChdb5hSjQkTQyf91ESUXzBR+J1KHgwaCxWjowdyAna14rUQqK?=
 =?us-ascii?Q?UHk7NAioY04HraiFxK7FXta3U0WeqiMK3r7sXPauErUAJ0XRg9aAB5r1e+a8?=
 =?us-ascii?Q?nQ59tVWq0sR4NyZUOOLzXuBzv1I+sBGazhBW/NsjZKNxpZ1+i8nJDmm3Wp2T?=
 =?us-ascii?Q?e5bgpQWzaYbpSxLJsAY9Sk44NdcnVNpLCAlVraz3wmNOHmYMDZPzFCNr4Lmu?=
 =?us-ascii?Q?4RwN0FVpacDlOGIPiLpxw7jEBMqHx8b+AQnViX2IWU/BmynWZmQC9LUC4Wr0?=
 =?us-ascii?Q?zwNDHEGaazi6h11wdGjdGYcm7ta9CVd8VfnnPSmQ8BPqwUC931txrcvdpjlr?=
 =?us-ascii?Q?ZPLAHGNYl8QkDmv+nDCG7samqxkEHzKviD9Yq4XC07Qv1+gwJ19VYFKdN/35?=
 =?us-ascii?Q?i7BYBHqugWf7KxMJQ97xvVyG2TppmdK0BuYEgDvyGPLecWwe0H1eEHE/aW8Z?=
 =?us-ascii?Q?7sCnMmxznUUrL8a8hcjgHZgiPQ+6NI/dJi2x//eCMIzyMiZdMgx6NRbkLvKQ?=
 =?us-ascii?Q?/Hq7CxS18GcD9vvsw6eMKhIllt8ziuHWqoN8ifmZs8UVpSQLqblWc4iU9+j7?=
 =?us-ascii?Q?fBIv8sQCSkjONe04XFE3306DlEvHjSAaHoXjGOo13+lkjVGjz1gTLiGGqDcd?=
 =?us-ascii?Q?O8hAsCSSJePk3iOgL495DlftlY3hq49Ym2DZkgq3q3XkzaraxU7NX2QJt8GP?=
 =?us-ascii?Q?R7e2BAAGuOGSrTiqR6Iz22Fmfyrl8pHzqc3l/5kleNZBZCMMcFsqF6lfmzIw?=
 =?us-ascii?Q?mE9Vt1aAKA6+6kxfpvSzhKYtYlLzES8XgqbpGXjq1gsN0ghWSLefPVtsPDJH?=
 =?us-ascii?Q?sc5qCGQKNB6QvbMD6E2QHxz406u/hTd0g+6JHt426lIF0L5mcBKQm7MJOfjb?=
 =?us-ascii?Q?RImPOi9W2yw4ewHvTjla8TvdP/B0ErrK23iupEIT+z2f3IU2C0qRokdyKJNj?=
 =?us-ascii?Q?xTktJoY35pPn4pHjYLNaIB1x4IHKEos4l8cbdrCrhq9cXuc6erZn4Ycj5NQv?=
 =?us-ascii?Q?WNWNE6sSFF0NwBPuYP52yC8eBalQNS48ZkJiG/ZV6pguQvPC2D7jl0div+ts?=
 =?us-ascii?Q?sjNI9XVf8VP1YA6hqCSGimwYlybuP1sTLpNi5Unbs1oOYExghFHnMCMLolRY?=
 =?us-ascii?Q?YAhP/8nMh5ynvXJerMfAX8MZGBFUFCjxzF9WFyrqg70Iqy9VGN+mXn6/F9iU?=
 =?us-ascii?Q?z2LqJW5QegXWEFKqDFwicoz1gIWVs6ukqDjaSyCqAYeJjhxOw07/mr/dF60A?=
 =?us-ascii?Q?SAaY9QERV3SNuuK8yX3vtR1X9Bzsz81vqhqrfy64LfwELVqbsOWkDt7VRpnW?=
 =?us-ascii?Q?SOJTXKVQhdsE+c/kOwOQghwpJoOszO++aNK2+GRcOyWHn7pzo2eq74pM0MK7?=
 =?us-ascii?Q?YILbkJDu2PwWtl1ItjpQlpFLqPjGgwXJrKE+zIj6vF7rPf7979q7D63xSVzc?=
 =?us-ascii?Q?vw=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95dc4fb7-380f-457e-c4ca-08dab65cd117
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 07:44:58.9619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PxhP7C7koFfmVx90zxI74A9USA0QjKkF6qalH3MLkjboAbyK0LsWyRIxU5bcTQ4nmC7NWGiS6lVXOV+JnO/c0mEIkwiq5cdrP49Yc6gm5j4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6245
X-Proofpoint-GUID: SxtCty3mc-AIazsl11DER0s7Ekjop7Rk
X-Proofpoint-ORIG-GUID: SxtCty3mc-AIazsl11DER0s7Ekjop7Rk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_03,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1011
 bulkscore=0 malwarescore=0 mlxlogscore=934 spamscore=0 suspectscore=0
 mlxscore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210250044
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wenst@chromium.org>

commit 8310ca94075e784bbb06593cd6c068ee6b6e4ca6 upstream.

DST_QUEUE_OFF_BASE is applied to offset/mem_offset on MMAP capture buffers
only for the VIDIOC_QUERYBUF ioctl, while the userspace fields (including
offset/mem_offset) are filled in for VIDIOC_{QUERY,PREPARE,Q,DQ}BUF
ioctls. This leads to differences in the values presented to userspace.
If userspace attempts to mmap the capture buffer directly using values
from DQBUF, it will fail.

Move the code that applies the magic offset into a helper, and call
that helper from all four ioctl entry points.

[hverkuil: drop unnecessary '= 0' in v4l2_m2m_querybuf() for ret]

Fixes: 7f98639def42 ("V4L/DVB: add memory-to-memory device helper framework for videobuf")
Fixes: 908a0d7c588e ("[media] v4l: mem2mem: port to videobuf2")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
[OP: adjusted return logic for 4.19]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c | 62 +++++++++++++++++++-------
 1 file changed, 45 insertions(+), 17 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index fc237b820c4f..75c51007768e 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -445,19 +445,14 @@ int v4l2_m2m_reqbufs(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_reqbufs);
 
-int v4l2_m2m_querybuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
-		      struct v4l2_buffer *buf)
+static void v4l2_m2m_adjust_mem_offset(struct vb2_queue *vq,
+				       struct v4l2_buffer *buf)
 {
-	struct vb2_queue *vq;
-	int ret = 0;
-	unsigned int i;
-
-	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
-	ret = vb2_querybuf(vq, buf);
-
 	/* Adjust MMAP memory offsets for the CAPTURE queue */
 	if (buf->memory == V4L2_MEMORY_MMAP && !V4L2_TYPE_IS_OUTPUT(vq->type)) {
 		if (V4L2_TYPE_IS_MULTIPLANAR(vq->type)) {
+			unsigned int i;
+
 			for (i = 0; i < buf->length; ++i)
 				buf->m.planes[i].m.mem_offset
 					+= DST_QUEUE_OFF_BASE;
@@ -465,8 +460,23 @@ int v4l2_m2m_querybuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 			buf->m.offset += DST_QUEUE_OFF_BASE;
 		}
 	}
+}
 
-	return ret;
+int v4l2_m2m_querybuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
+		      struct v4l2_buffer *buf)
+{
+	struct vb2_queue *vq;
+	int ret;
+
+	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
+	ret = vb2_querybuf(vq, buf);
+	if (ret)
+		return ret;
+
+	/* Adjust MMAP memory offsets for the CAPTURE queue */
+	v4l2_m2m_adjust_mem_offset(vq, buf);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_querybuf);
 
@@ -478,10 +488,15 @@ int v4l2_m2m_qbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 
 	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
 	ret = vb2_qbuf(vq, buf);
-	if (!ret)
-		v4l2_m2m_try_schedule(m2m_ctx);
+	if (ret)
+		return ret;
 
-	return ret;
+	/* Adjust MMAP memory offsets for the CAPTURE queue */
+	v4l2_m2m_adjust_mem_offset(vq, buf);
+
+	v4l2_m2m_try_schedule(m2m_ctx);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_qbuf);
 
@@ -489,9 +504,17 @@ int v4l2_m2m_dqbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		   struct v4l2_buffer *buf)
 {
 	struct vb2_queue *vq;
+	int ret;
 
 	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
-	return vb2_dqbuf(vq, buf, file->f_flags & O_NONBLOCK);
+	ret = vb2_dqbuf(vq, buf, file->f_flags & O_NONBLOCK);
+	if (ret)
+		return ret;
+
+	/* Adjust MMAP memory offsets for the CAPTURE queue */
+	v4l2_m2m_adjust_mem_offset(vq, buf);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_dqbuf);
 
@@ -503,10 +526,15 @@ int v4l2_m2m_prepare_buf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 
 	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
 	ret = vb2_prepare_buf(vq, buf);
-	if (!ret)
-		v4l2_m2m_try_schedule(m2m_ctx);
+	if (ret)
+		return ret;
 
-	return ret;
+	/* Adjust MMAP memory offsets for the CAPTURE queue */
+	v4l2_m2m_adjust_mem_offset(vq, buf);
+
+	v4l2_m2m_try_schedule(m2m_ctx);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_prepare_buf);
 
-- 
2.38.1

