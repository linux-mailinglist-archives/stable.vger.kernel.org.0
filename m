Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B836D51D408
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 11:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390357AbiEFJQX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 05:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344517AbiEFJQW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 05:16:22 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1879763391
        for <stable@vger.kernel.org>; Fri,  6 May 2022 02:12:39 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2468n0vg028714;
        Fri, 6 May 2022 02:12:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=3VGLXMKxN1rM/BG2etzpnQCdb1e2S5nOG/61LAWwzhc=;
 b=oZmTFUarJ5/QpV8EMNUYHVnDwLwsPrwuqSgLXAZFRyVXB20hQCfdqv0jZj79adDp7xQj
 seUbOkvrdZzcbU6Bl5ogjhwGKVuiuHf+tQjhjn2ENEnQx1dDytTSBWerVaIPolggO737
 D8aENdUoIrHMZdXbXNAEVGPr8+xgfUTXHaGQdq8DBjO7hzUMNZSTwE8+Lj9/3Ly0RLbe
 hh5mba4VEgqCdCQmudf+P5tbv+5bk66eiHMYNaYQ/7LKoOgcG3IukcAjHf06iXH0QsNZ
 2FviQrvHCndq3cy3nCIUAlfP+NkAf1qQsuducy9LEt2cRc/LwNBpwJ6DlTkXQs+q9GCg Hg== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fs4mjcaxu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 02:12:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BE3q551oBJQqvCoyfSNi2gbWacniLpKjJvWrcbNOxYbpeUYz2mxE0r3E6np/0x6JTdLqSQjDskZJjTLbTX/TSX/HZVzpfucGY7635k/NaCBWF8Pc5X2Vh1zqcQGMOTrjSO1eqh2hOYVL5R666pchp5r6r3XJjFmnFlgzAZwqdi+Zj69SyAMzeoTBIfoPZAhsAr4ry0VGTnjWv5AgDlIWFgNCQNJsJ4D3s5x8kX9XkKEKEqYwT5HkqdItO1sRfESYVbsW7pZY4+ERWQbcq1ENlGmy20uiGgQW7A+5+U5SBPJyKNLrXHeWkeUbF8dgyztcBwyWDg1pPLDZlmKCoYs5wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3VGLXMKxN1rM/BG2etzpnQCdb1e2S5nOG/61LAWwzhc=;
 b=autgucQs9h93xzlYNqzfwuoXnhztZyaa589OX5TRBy/q2ADpxrlpfkD419UauNuAHp8kv6jR1JjSzQOyfaYXd8JibSgl4W33TwLQIXQ9v6aMzT0dKcJ1Jj6dB5gJ+HSTfqnBaPPHtyFg2uGmHnavnPmUpmenvY5gTpna/oysqgc/NEufMgRJvJl3ItW/OXpkgURpCmPTAawAVsAqbQ7x752wIMBHmZHa2jtCCU6hWtMhuMKdqUikPqJKfwNoabTVPut06licNHTrHcDfbDpso2okzQYFYgVktzY7uxDBsezeDyldzgjExZECOhXGyDhBh8nMM9MkEg9FRwclZwi+xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB4444.namprd11.prod.outlook.com (2603:10b6:5:1de::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Fri, 6 May
 2022 09:12:25 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::806f:3f7a:c1be:ff34]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::806f:3f7a:c1be:ff34%8]) with mapi id 15.20.5206.027; Fri, 6 May 2022
 09:12:25 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     tiwai@suse.de, perex@perex.cz, kirin.say@gmail.com
Subject: [PATCH 5.4 4/5] ALSA: pcm: Fix races among concurrent prealloc proc writes
Date:   Fri,  6 May 2022 12:10:12 +0300
Message-Id: <20220506091013.1746159-5-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220506091013.1746159-1-ovidiu.panait@windriver.com>
References: <20220506091013.1746159-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0009.eurprd03.prod.outlook.com
 (2603:10a6:802:a0::21) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25625ebf-4afe-4efb-0306-08da2f408935
X-MS-TrafficTypeDiagnostic: DM6PR11MB4444:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB4444C7EB127498CF567AB52BFEC59@DM6PR11MB4444.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fss0rP3bIjcuCIzve/KPmdDeb9xMl8cYMlZ76+wRZGEj8DLO/Kbw9qXnfsOk3WKs9IgfIWHpemXgBQ/wB2vY/ZBuEioMZqr6m0RwGg+iBt+Etk4q2ccY2h1J9KJMMDCVC3yZC1g+Hl+Jj+BgefwlC/4a4wYrR9D6AKGgM71rgVXd8H60lDzmPOdI8h4irg3WRjVjgAm0ZKlxILlr9KZFdB8vKlZ1d3ef8Dg7iDdixTdHSNpHDMvh6JM4p84hyI835pVIIv0ekVO+SLke1yRRm8IRnrWEjHZYM5PmGtLXziQGszL2Z4s8/Ih74uYR3Y3qspxyl1ScKO3JjgL9RunGyrceOf0lfE17GOQTDUj39iuHXUPqdQJD7pvbCoen3r2PCAdFCMVoQntGikcq9t354eRttAR4HFPHm+8PGjsowoPlVt26nWRYU+Ge5Wa3DP8lkWVi5loivh41Yia7NgHr3Dt907DCTaxZJCdIIo4pShn5MI2nrefr5fMScHxYe5aZrAIllY3dDnUXGe8ZnncaxGLAhOzxF7rJzdCZk1Unv8eSP28DNFsSfF4AbW9xDBG+RN10lJpn0ercgtP40cEbZeY1X5J6SkOTOG5dpHX76kdCO2uD1QVBJBwZOEbwLAkOe5fL7lKzAvsm2tKVmr3mJhSAbkt7qi3R8sVwEBXaT2sOBtmt1PglF5MLb61TaBYcmGvSU79k7gjZZmUJFf1pad8iHPvm3kC1idrS7LRevOKed0oyLe/5JLSox9q0ZoIb5dteEuWNYGSs0y6jKOSSZSSfypMg+P33X2FHjYz/GVM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(966005)(508600001)(6486002)(5660300002)(4326008)(8676002)(66946007)(66556008)(66476007)(8936002)(186003)(83380400001)(6916009)(6506007)(86362001)(316002)(2906002)(26005)(6512007)(1076003)(38100700002)(38350700002)(44832011)(52116002)(6666004)(36756003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nzH6lOp5H2NGMCt5sGmb+lvC02Uw3mlj4721vX+UmlbMUxkXogAT3celltkV?=
 =?us-ascii?Q?zm6r4NHtI5cYXSOFcdLUbGSW3V+URuyxw+/EThJleZzs6wzfA8b1e4PzB+og?=
 =?us-ascii?Q?NDGpuBTvSwKpxWIDNJd9tyY4Q7lKgf4Nlb1iXScfO69DDHQmmhOC5yc4LaPz?=
 =?us-ascii?Q?LVFc+PJpxqkT+l/31pLYCfz/w97EXMqhKjgD/f9qSpc1Scscp31joYmcOrso?=
 =?us-ascii?Q?1Pby8+XMt9iHnoAOSUib7QMKG1Ay+vuwfQ3njuO8df2Y51kvn+Ihf33/eOe/?=
 =?us-ascii?Q?t8jABsgVTwQjgORyFd0+4v7Eo8UMl+9sRo8Uzr8Ul20Dae1X84pI1hXKJWX2?=
 =?us-ascii?Q?nT/bDbJktMw7TnfjGv+fFOx+zOhFuIUGZmzwaACAXy4Q1rthKL3FALH0WMiY?=
 =?us-ascii?Q?KmX/dpJapqSCaUkKksvMG0DaJSUNCisUgNnMaSkFUCBRUKfU2Drpfu0u5DMD?=
 =?us-ascii?Q?aWsbWSFbaRx0BTMswtjFzE7Iy9Kx8tkX+Q11k9tPDigR5EUTzvdw4fi+dvW+?=
 =?us-ascii?Q?TmP015VxIxVkgZSPdLf+cEA9Ew6qupHk4zhGQojRjOm1L20ok75zDFBslh4L?=
 =?us-ascii?Q?6XJV2+olfAa1PYOUQwx4IfaH4CrAlhcEq/oG0rPGKdXlnqlk3J+WBVNmvj6M?=
 =?us-ascii?Q?02iErLEJzE2KVuQ/8NvjcT/hcsUYpEKx84uqqdVvvikaE8TltIIOv417SFo/?=
 =?us-ascii?Q?p3mloyN7q+EKJL7CjdagW3C+iDXVDZCpmhsx98EAUk5ejcMrZQf5+Wl6R7w+?=
 =?us-ascii?Q?p1hiz/mJPLJfU4sI0DUnTAN2+MY+2m/lAD9EuJHudlUvs9G1sgR9t/OVQIeg?=
 =?us-ascii?Q?kjADXXv/XoL+xUeSBlulVlUlKoR+UL7TtZqXUj47VxmJClmPqVCZ8QRDjQ/H?=
 =?us-ascii?Q?q4mhwmwUykKDrpGRbDA6nI+mDDcBOMNGojyFuJKSF58C8yriT3z5d1zZ2+U7?=
 =?us-ascii?Q?hYcXjNYtn0VV713cTm1+XVERtotKoAx4zgKphJuqZCLv3ShNEWnT9ejHXq+T?=
 =?us-ascii?Q?CEXJIcxpERAUFzPWKTm7VT64TOweNXAUX4vCKl2E/5k35UPdaY+ZwIzaSXKN?=
 =?us-ascii?Q?GVCLdXmHoNlnhCigi0aYEd7AMAhA3WLCAcWofXFg05sp4zpOpdwo2h6/jNf2?=
 =?us-ascii?Q?WQSsNHe2k2lFTSDymqwVD32WFaGSL8GGDsvYA0AvWqj2RaRf3gvNAoxz2dAk?=
 =?us-ascii?Q?dkk9/xNGhuEL3XW9uevR0Ei42y3SuXe+7cGttrZfWB+G4dKIa7XG4MUNsvLA?=
 =?us-ascii?Q?Z6dZrVrnvn+Pb+3hv92DBWmyN+aYNivaivDkoaLr+ftT5ck48cHrbCemkIrD?=
 =?us-ascii?Q?YAuZ9Rx7dyAFIjQoqEA8A+4ac0YRI6GYHgLa1xr5RULJ3CPSpW8YnN8xG8B8?=
 =?us-ascii?Q?lpMIMbpVcLKXxQ8ZGLz9OAQTCyyaGafsHfm2QouqvIiw+e0UYg1dDdl/19Od?=
 =?us-ascii?Q?IntSqV1MGU5cCeupGvmIKcongA6PX8t4VnjcPfs1nJu/ORgt7tX5zmG55Z8Q?=
 =?us-ascii?Q?45FjTEg0WiMCxZAoQAG7o6IglDK6Ud11XJ7XtP3azVqpZrvrzmJZ0a0RykSf?=
 =?us-ascii?Q?VKMHLBokEfqmS3+sr8QrWJSNpBGDv0V7ihHdVhcdBW6q2LXZUzx5rD8Pc14E?=
 =?us-ascii?Q?QMZdqsZe4vqb37Lq1KjqRQB2JKl1jnpNxh4nU02I3bqbSKJUsdNWyT8aaKai?=
 =?us-ascii?Q?smeGZGofPQa4QhQc1+zfZS/qupbxAG5RvlhMK4vN2UehE+EN/xs/3P6vR6fR?=
 =?us-ascii?Q?1nW0uZvmOCl/SJZtklIPQU2uveDaDmo=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25625ebf-4afe-4efb-0306-08da2f408935
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2022 09:12:25.4586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OX2aGx0sZm2HMmAew1kxfoTJGh0WZTF/f1077KYce7uFj3FHSozr7862W5C0L+gOEHVySVDRAdokawOgsf3o2w1vYlWzvLUmuoKI7dx0PrQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4444
X-Proofpoint-GUID: KDSWX1hMSF9dVf6VR-GBIp5z9Go8LguT
X-Proofpoint-ORIG-GUID: KDSWX1hMSF9dVf6VR-GBIp5z9Go8LguT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-06_03,2022-05-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 lowpriorityscore=0 mlxlogscore=692 adultscore=0 malwarescore=0
 priorityscore=1501 impostorscore=0 clxscore=1015 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205060051
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 69534c48ba8ce552ce383b3dfdb271ffe51820c3 upstream.

We have no protection against concurrent PCM buffer preallocation
changes via proc files, and it may potentially lead to UAF or some
weird problem.  This patch applies the PCM open_mutex to the proc
write operation for avoiding the racy proc writes and the PCM stream
open (and further operations).

Cc: <stable@vger.kernel.org>
Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20220322170720.3529-5-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[OP: backport to 5.4: adjusted context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 sound/core/pcm_memory.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/sound/core/pcm_memory.c b/sound/core/pcm_memory.c
index 7600dcdf5fd4..9aea1d6fb054 100644
--- a/sound/core/pcm_memory.c
+++ b/sound/core/pcm_memory.c
@@ -133,19 +133,20 @@ static void snd_pcm_lib_preallocate_proc_write(struct snd_info_entry *entry,
 	size_t size;
 	struct snd_dma_buffer new_dmab;
 
+	mutex_lock(&substream->pcm->open_mutex);
 	if (substream->runtime) {
 		buffer->error = -EBUSY;
-		return;
+		goto unlock;
 	}
 	if (!snd_info_get_line(buffer, line, sizeof(line))) {
 		snd_info_get_str(str, line, sizeof(str));
 		size = simple_strtoul(str, NULL, 10) * 1024;
 		if ((size != 0 && size < 8192) || size > substream->dma_max) {
 			buffer->error = -EINVAL;
-			return;
+			goto unlock;
 		}
 		if (substream->dma_buffer.bytes == size)
-			return;
+			goto unlock;
 		memset(&new_dmab, 0, sizeof(new_dmab));
 		new_dmab.dev = substream->dma_buffer.dev;
 		if (size > 0) {
@@ -153,7 +154,7 @@ static void snd_pcm_lib_preallocate_proc_write(struct snd_info_entry *entry,
 						substream->dma_buffer.dev.dev,
 						size, &new_dmab) < 0) {
 				buffer->error = -ENOMEM;
-				return;
+				goto unlock;
 			}
 			substream->buffer_bytes_max = size;
 		} else {
@@ -165,6 +166,8 @@ static void snd_pcm_lib_preallocate_proc_write(struct snd_info_entry *entry,
 	} else {
 		buffer->error = -EINVAL;
 	}
+ unlock:
+	mutex_unlock(&substream->pcm->open_mutex);
 }
 
 static inline void preallocate_info_init(struct snd_pcm_substream *substream)
-- 
2.36.0

