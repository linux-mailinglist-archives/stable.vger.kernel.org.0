Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE4E658C886
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 14:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242997AbiHHMo1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Aug 2022 08:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242958AbiHHMoY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Aug 2022 08:44:24 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59FB9DEE4;
        Mon,  8 Aug 2022 05:44:15 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 278CcUet017778;
        Mon, 8 Aug 2022 05:44:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=FVCdHVTbeSj87ppG9UvbmFBzP6CTXX5M7KHtvnBTWcI=;
 b=DNdMT+UdgMyFjZYr0Y8CosLj2/7gyQg01jT/OA92DqfE/XYftp6kyS/1HWqvl47Wc+lB
 5qtloS8PR2o3g9MG1tMHgLEcx3RT3jmb6g5nOhR4x6s95wAY5GvScp8pWSMAA3tfwom8
 6q1laHvN9D09oYrSxn/8Ex/aWUtvsxnoIaWMoE9Z/HjUrSkUFDzSiUAjWOHAMelTBakR
 dKgp5yLmnXMf7w0PDuQWN0pnXOTIaSjnGcU0ThnwyokINyPNmRl5cMZeq1Mpyaxqkaum
 rtjrNHNCccg4qMB4WCtCnY8jaESv1zHVdouaGqPXyyCnwgZUJwzrRWpoCUkeAZLcAFX0 AQ== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3hskk4hcgj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Aug 2022 05:44:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WTw3CD/wiU+9AlRRl62SIf5Z2fwPt1vXzonIslYE0uTbMgjgU6w4Uil21bEKlZw3VqkSqaa4mB07bQ/pH999x2Bd0ytBjiFfShEm7ctGI1CZMvaqlLz5BIKqcdX39i0UUvTfKhvUwXKp6VqpZkhbx3LgSpc7K3IKhz3xteYclbMoL7rDYqG6gvRpMKQgLBznQ7oaryex9IGXR0NIAlatwS8DDNlAnVd50ZYyyNvbU7fEjXeiZJGpQAhWBgRyTT1SMBnQoyhN1a0Gfh9Ilf/ZpWyDSBWRT1O9jgbG1rlfbAdcbmeYQs00TETUJtG7UluuGyffGs7XO5AFrvpqzPeb0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FVCdHVTbeSj87ppG9UvbmFBzP6CTXX5M7KHtvnBTWcI=;
 b=R1emU6ZkEqKKnm5v7FvLjiCNd91/wxC68Kuqc6TM5dq+hh6a2FXLlfK+UY4IJJx+Qdqfrf7lJep9jAIdld27MvfeDtmVrwwsnWiRKXozbB5wRScKIo7ZAGGEfvW757WaWr1WnLSIBeVKVgOrFuO39RJBg3/m7qgjeGcG/llN03IEtksDHQmEzIo6bF2v4tqxgfrSzesbN/mr+UmiLw3MHaV2+nEUySvHfhG4m97IzJaU1B2NJ2ACtuoO0j8sQaAIm+qV9XnP7KFuz5u8MhFgU5QZ1uyysaiiu7P/vhPuG5OjHGavy4liLME+bJGfkJ8Mvp6IJqXcZe17pxgJx53ofA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by CY4PR11MB2006.namprd11.prod.outlook.com (2603:10b6:903:2f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Mon, 8 Aug
 2022 12:44:03 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::e500:5c9f:fb41:287b]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::e500:5c9f:fb41:287b%9]) with mapi id 15.20.5504.020; Mon, 8 Aug 2022
 12:44:03 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org, wenst@chromium.org,
        hverkuil-cisco@xs4all.nl, mchehab@kernel.org
Cc:     linux-media@vger.kernel.org,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.4 1/1] media: v4l2-mem2mem: Apply DST_QUEUE_OFF_BASE on MMAP buffers across ioctls
Date:   Mon,  8 Aug 2022 15:41:30 +0300
Message-Id: <20220808124130.1928411-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220808124130.1928411-1-ovidiu.panait@windriver.com>
References: <20220808124130.1928411-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0064.eurprd04.prod.outlook.com
 (2603:10a6:802:2::35) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91fe1f06-e551-4108-2160-08da793bacd8
X-MS-TrafficTypeDiagnostic: CY4PR11MB2006:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yJ27q9qlzW5Nd4QgrmbEuII2/Svmt2ajZ6oUF0sQrz8x7jN4LmCfvXgL+upW+cjZjBa9uyf0ScTRBFKV/+wxf84nLTmJCOpHmF0IuG+55gRuXaMer33eeWZBd5rPNKeOyBmIdtzOHjr71deV0gdwlXBz0rA47GkrXB21ytUtmb7Oca1ankrS+byb3PrzMqFDPRE9/TXR18w0aVFuw0q+livC2E3Lob75H+i3oe466ApqRlG9hjB9y5ronPm6hghp/CPCno232X7VACcKKZBy1SSHbTownxUaXBK2RZH64bHoFLSCj+FzIuRyjRE6NiFh9UEnV7/8mOncU1LCbeWbi3BHaLbu3jLfpadWY77BSKQro804qIzllFCoGai8x7Lm6FjKUMvzVyy0soZZyc+b22m7Ks+SR2xlLqgCXmf7qGQ9G1MYtxwJ9O3QLYma+TLsVDIoQLuLglUsWZ95tWwbcyDaq1zxYkVLf1ccRJY2PF5IlAZGAv2uXaC+1+JtscSNeHgK9NjTHaF96Vq9yvFRQBFvn1pW8qNeKAGgfyTpDbYZLCGM+HgCo4+diwt+ZZQHerz4imvM9AVTWdW9BiHuUZnGDYN8rOJA57In2+KvM/HnclEcihsIMnk85Wz465qdef4E8YL6yJI5wC7XKp06e8wn2vDyp4BEkThyOeRtTnRsVBRTwUU8eawZHCmOaWoN5fgr0vUeQzPssH32oFJR3m/xFeNCrCCmaCoSHaY4pfQrNwk/osV8ozJ4VVbxaUxNWRugtYpFFKbc6S+d+Z+bXkMT58nKMcJIjr4CNH5L277zG+oSt5mFd2sfxormjE1R
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(39850400004)(366004)(136003)(396003)(83380400001)(26005)(6512007)(107886003)(1076003)(36756003)(2616005)(186003)(4326008)(86362001)(316002)(41300700001)(6506007)(52116002)(2906002)(6666004)(478600001)(66946007)(6486002)(38100700002)(44832011)(66556008)(66476007)(38350700002)(5660300002)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oKVhGLRklQ6vXpzXNFkUbmqYrACQ8eJ6vxHbxM1co+F8GL1FKJUt3CMJ2rYg?=
 =?us-ascii?Q?wE1veyKXoXi4oQOTFa55vUQkcqzZNVSSobPvgOeXcE/CqXKtndmebp4aoxgx?=
 =?us-ascii?Q?9ST7E01xr/aKAVJ9o0sLSyOZR5cpL034yEejYhhNvOdvR2tdzxgrX8oDiXLJ?=
 =?us-ascii?Q?V3PgI0a+mbfskt595/q4ugg3OSNkSAdTH1L8n/Urq1OsVTS9/vH1gfKXGYBO?=
 =?us-ascii?Q?7j+OGDTjkORpCUPV69NCnylOsKexXY8bRHPn8cZ58fJu8OyNW3ahzQ/Ucpdq?=
 =?us-ascii?Q?V3Z6n+P2A6K0DQ3WDWO03Qf2bLqZLrzXJ10qx7wh+FZuWmB1S6wNYU0vC0MW?=
 =?us-ascii?Q?H/MRflSvI1lBhIMfyVNQt5quH9En7vHYyPCHewROOdiQbf+HpjfV58ECZ4K6?=
 =?us-ascii?Q?L7gX+yo4FPJD1wA9Ky951w4tO0q7n5g6WKmDUj1wrPfu4YemM0KIQdJSnddP?=
 =?us-ascii?Q?l2cOSKGSUCMg4ziJoQRpkHaDDjGBNEu8FqJ4OEX72LbWlPvfxFtn47UpoKr8?=
 =?us-ascii?Q?FO/mOL0YjzXN459FsXARavWPhuQfiIHN3jGyp7X4/kSQu25zse2u2lx1w2CW?=
 =?us-ascii?Q?kapSE0uueGkfQk5LOnWZ4ZLjAHIMTc8Ej5R9M0wv6yV0HxTPBT2HFHGmY810?=
 =?us-ascii?Q?raYbOinQ5MR2z05C/xlz5RGnTJXJe5xb2z+O3+X2QVXSgAVQMJnou5dr0exz?=
 =?us-ascii?Q?Lk4QeLg3/QWlkQr7QJuZK/MiiukorqGC7gxWtyMLoI4gl3jloc2CxgB6xVPv?=
 =?us-ascii?Q?IFPyI85ouJfQntt4XuQQU7HcUGCemVIxKW2dBqg+AeyPpHuInW1DrUo3Iex1?=
 =?us-ascii?Q?Fb2BqHT4bV8jpdNPadYiwqX0fN0ub1qUOfQ18lrYUk/FNQJ+AJUuT353Tcm9?=
 =?us-ascii?Q?vCfuXSPyHnMIqqky6/ae7vN8sSJRpMpyfWw11Lb5e9d4EITfNwDNwiocM+W9?=
 =?us-ascii?Q?IRt+hXAHOcmcSO3paRMUektctkfB6boMjmRlqW6pIDVE5Hddjm/4LZKK7HqA?=
 =?us-ascii?Q?Vbfmag6ydAyVlPtH02RA4ABCsC6sW7JaG9jayrPcGZo4qth2ntqiBdv1SuMV?=
 =?us-ascii?Q?VZHjLj/00cCmZ/F6U5aX52/KG2ofkDMP8U+l1lcKXIglPBgfmrVzDrHldZ+H?=
 =?us-ascii?Q?3yCbA2hhhlR5KBASXdJEur63/TtZ+3UbMecI6Vxk3YE490gf2Ze/mWNAf9in?=
 =?us-ascii?Q?dr4QPz2rn8AD60FmS9o6zzTni1dpsiZmAJZ7XQmGrFgvi12GPo1pw2C454uq?=
 =?us-ascii?Q?CUCHXOWw5diDO/xAeMskEOufniQEoW4PtWorLu5j+/DzwcE636I8siExStu/?=
 =?us-ascii?Q?4I0laGCKPz2Ru/8M9hTfAq3r4VCOA08WmwPYKbfzmgJKU4/V4O/AfJbY3i3M?=
 =?us-ascii?Q?dPHTULPDXMNjYo/ePvcXRHEnkuSAgO97iYM3lYAUI8O1JvVi9lcpGOQoGcHk?=
 =?us-ascii?Q?ZdlKi7lZcTpZTLe+He3WVAbxAtufxdss5QgWxWEd4eLkN77eAzUqWRx7Fsj/?=
 =?us-ascii?Q?QdrZvNu5pMQzrX9yZG4ogEMqKH7Vxe49PfJHyOMfeTUaFyKpAMIwVEee4hFj?=
 =?us-ascii?Q?zfiDhCKkmK7R9MvTTIPfRtJAMX03v11zXyMK4e0kXoDHHYg3Zad8O2mJmC/0?=
 =?us-ascii?Q?Eg=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91fe1f06-e551-4108-2160-08da793bacd8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2022 12:44:03.7785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qqLXOVDacrH5k/YRgIQHUHhXDesa3OHPeAuByXZ2l8S8RbktKncvXYJxOyO8KlHdWogJNa53c2vr2GaKH8x7pHxiYSUM+Amx4vjUkxXrTlI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB2006
X-Proofpoint-GUID: N8E3cy9OG2VwFB9Lbe2KdZyW972WfGeK
X-Proofpoint-ORIG-GUID: N8E3cy9OG2VwFB9Lbe2KdZyW972WfGeK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-08_09,2022-08-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208080063
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
[OP: backport to 5.4: adjusted return logic in v4l2_m2m_qbuf() to match the
logic in the original commit: call v4l2_m2m_adjust_mem_offset() only if !ret
and before the v4l2_m2m_try_schedule() call]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c | 60 ++++++++++++++++++++------
 1 file changed, 46 insertions(+), 14 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 639dc8d45e60..d56837c04a81 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -460,19 +460,14 @@ int v4l2_m2m_reqbufs(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
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
@@ -480,8 +475,23 @@ int v4l2_m2m_querybuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
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
 
@@ -500,10 +510,16 @@ int v4l2_m2m_qbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		return -EPERM;
 	}
 	ret = vb2_qbuf(vq, vdev->v4l2_dev->mdev, buf);
-	if (!ret && !(buf->flags & V4L2_BUF_FLAG_IN_REQUEST))
+	if (ret)
+		return ret;
+
+	/* Adjust MMAP memory offsets for the CAPTURE queue */
+	v4l2_m2m_adjust_mem_offset(vq, buf);
+
+	if (!(buf->flags & V4L2_BUF_FLAG_IN_REQUEST))
 		v4l2_m2m_try_schedule(m2m_ctx);
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_qbuf);
 
@@ -511,9 +527,17 @@ int v4l2_m2m_dqbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
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
 
@@ -522,9 +546,17 @@ int v4l2_m2m_prepare_buf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 {
 	struct video_device *vdev = video_devdata(file);
 	struct vb2_queue *vq;
+	int ret;
 
 	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
-	return vb2_prepare_buf(vq, vdev->v4l2_dev->mdev, buf);
+	ret = vb2_prepare_buf(vq, vdev->v4l2_dev->mdev, buf);
+	if (ret)
+		return ret;
+
+	/* Adjust MMAP memory offsets for the CAPTURE queue */
+	v4l2_m2m_adjust_mem_offset(vq, buf);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_prepare_buf);
 
-- 
2.37.1

