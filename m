Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E39E525F0F
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 12:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379081AbiEMJjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 05:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379105AbiEMJjO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 05:39:14 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB6B92A76A1
        for <stable@vger.kernel.org>; Fri, 13 May 2022 02:39:11 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24D9Snxf011490;
        Fri, 13 May 2022 09:39:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=ffuGkn6ZjJdXWbOG3FM0V/UDcMqJWt7seRT5QsLbNq8=;
 b=i2owYen5UpJBIx5cD9EuPU2/yE6og2f/sRF9TC1qsodIFjXw8CpEtA2tudivGnKDv6T0
 QA1nyLloJClXymTvzKzJn+N8nEaK+kLTLcrTw5d5KK+8MiWzIfKO7JRiG1RVNW9dKKdE
 n9pqfpZeMtXzxNr/kcCnv0AHrlg/WiQ3iNZMRGdoq/rhPLT2T/PL9prPve1lJMOKGoxr
 Nopgbriij3Zw0/y2S3Bi1WgKNwtmBoYg57I9a7YcTQuUhGkZ2e18orrjex9mFTdzFLNl
 brgD8W6TD9Y2oFTTT671O3JfvTSOLVOO87rmT8vnpPho4uMSyhpIdZcqLxpjxAlXB+fl ZA== 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2044.outbound.protection.outlook.com [104.47.73.44])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fwdyyvq42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 09:39:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=en1OGY2F5N2hJFnhQ9olwHZ+vWZl47yBqxeRBiiGBdtXXua6yocL9bIjz3dKwnGaJNpzWt22Ck+JKqgRXjSxkkvfwgXiQNGHJivi8hcdyif2sDSjX6P6r4O1SDZ24PovK0htutgJ/2VK9pFEaa9x9xm78WtruziQnQtT9beQbcabelLkhepivq/Gc6WuzSZK/QU/7xNMUHQwjdgcezK4vZZC5c5RBq80L2IHsm2Inv256Jn6cmjQVosnudWK0UJy3rOTG7JkCFOkcqYVNR4wejZ3G9ruRG7UYpfjSjk+n5r7dhVQS1c3dTAre2djPd2JwGf1cSneNc4W3fbXcbLwfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ffuGkn6ZjJdXWbOG3FM0V/UDcMqJWt7seRT5QsLbNq8=;
 b=Lc5enzEAByZ0Rz96k6xvF4nK/XzXQNN05Vv5O9Q/e0ovfJQS9r0hekyz160SntISh1DqFjLTOnPdtabcTxmrCX70Ihu/e2j6P1c51iOrvtBP/E5byHCAKMIzWB5GmWGcECF9uHj6J9skuR+t/hHkwOHpqEamld9Ho2dZTI3PIC8xXnScNk90e1+ZaEKBk3Bx6S16dmd0VnztPd8JoeZdrcYvTjGg1n4nu/vh0agyLGxU+baB6jlYWx+MwsNBkLOdAGivVNcgZpjhDUsHFTOF3aNG0Y6zpQSlXD9+y5WSPo5nwDVQP480c//XGnkWTqSwo3QKe68pcqBv+UP1JPe69w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by SA0PR11MB4527.namprd11.prod.outlook.com (2603:10b6:806:72::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Fri, 13 May
 2022 09:39:01 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::1d93:1511:5d6:9842]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::1d93:1511:5d6:9842%5]) with mapi id 15.20.5250.015; Fri, 13 May 2022
 09:39:01 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.14 4/5] ALSA: pcm: Fix races among concurrent prealloc proc writes
Date:   Fri, 13 May 2022 12:38:31 +0300
Message-Id: <20220513093832.1434697-4-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220513093832.1434697-1-ovidiu.panait@windriver.com>
References: <20220513093832.1434697-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR02CA0047.eurprd02.prod.outlook.com
 (2603:10a6:802:14::18) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ecae668-cd7c-4bf2-f916-08da34c469b0
X-MS-TrafficTypeDiagnostic: SA0PR11MB4527:EE_
X-Microsoft-Antispam-PRVS: <SA0PR11MB452790728E0B801979878681FECA9@SA0PR11MB4527.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nWir0vrCSJ1jmxT4jBnlwjFsHYwAmJgFnGmud5m7k2GOUIpd708vPU/x1qvkYchGpeF9RxydF1fOu0AJv1NKeRnN35JQuzQAOmXxk2HIaOmUwNQMnLXyQrQigaYzekXUAjhKFuUCq2Eq6Lehx3cPaVd14Cv/YMNJRqVxpFQzPCeVK7g05++InJmhwOJtgRfFNXd+aH63w+Di0UMqY4dhi5aSzgdvoEXeVlGhwMMIPd7eKN0sHckKFBIyNiZwidb3/DS0U7R86GjWry8i8tEPcZbnJ0atb2LNiAlp7H7PFAm7Bv1WJoUcarim/manXuHhVPEXeNMecOv2P7u16DRgI1KAk04idJLNoxrodGCPDqKHkRxsAHCRQ+3ud5UUlkdWfhp93dk6P+aMAncBAneaDTt7HXB75OVv4QWRLmhswq1t8N1k/kJYRml10yCFHkboHI7I8D4uskpvD5sLbX9nfcJCUNJXaC47+f8PxfiflvoUG1cPdoIuBWoHfT6S2cxPyDFuJ35o3TmxMaqUkUBonTs8u2KBQxSS8V33W89uEI4iRlHXFS4NA7uIJ0jpnye6yU4AQLDdDq2Aq3KLvONhzRZf8M8x8hCERzvi7NqiVEcn7btsgWx4RW5hEzNNnHQLLiMc41djYVjijO2WkGYRnChT81v54iEV7PFGcTvCN90N3sSowMK3Roy7cwhMb3lm0l/2+YotXydkevvwJ7VQAaudyk7VefLFD25oh0yDexGjdc1ZgGIiGAvjK1blM88GkoUfdg+DTZ799YIVcgoNc0UAPFXguVOF1HVZ1UjELtw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(38350700002)(316002)(66476007)(8676002)(4326008)(54906003)(6916009)(8936002)(66946007)(6512007)(26005)(1076003)(2616005)(107886003)(6506007)(52116002)(6486002)(508600001)(6666004)(186003)(966005)(86362001)(38100700002)(36756003)(5660300002)(44832011)(2906002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4n9pTRYNYTACW2bd1AB6bxcEqgXDNPLJpu2Y1vFbHKb9V1qei/tz0YK/uoVL?=
 =?us-ascii?Q?u0f4ry8bWloVuSycIzKKoEgvnAnW2FLx4ONrt+rUPbJz3pd1ZZE8IGNXh3qP?=
 =?us-ascii?Q?M3KydaLmIdZ2a1/v1Mx8Vown/Y6qwMMdYQGXILU0h+JwA2ZFt2ZX1mrgS2nq?=
 =?us-ascii?Q?8Mh1fJotnaO/3KlmQBaD+rctBT16JIipwdKb3fDv6BkHca96ymV0fF/w2mGA?=
 =?us-ascii?Q?e0N9yw2E5/tFHT1b5BsPaqEivQghXxtp+fS4skJbMP0asEPkIAkdy2JXnFH5?=
 =?us-ascii?Q?fw2YHtmAu8kQ1aZr29DrtYkKcIdC/Zhj62rh/o2VbWX40vJdw6UWk8VePI10?=
 =?us-ascii?Q?eSLijyd8MeYgPHeKwQoCIZ0AnqfpO+P4VpZoxkfE/YYVPS2Ux5WsaoNxtRaf?=
 =?us-ascii?Q?vGyC0nt3AZHXMOW420+jh1IkKZ0k0rSpv0ysJMFa+l+S4gDdOg0jsoDCtfk6?=
 =?us-ascii?Q?TJ5rWxgd9NvP4Y5CSEpYL026Xq4CGt+736tOCFXpdFJWuWWnqgNP2OIlyuc9?=
 =?us-ascii?Q?oXzyVBzOe/iNdGldeOMnvricYT0QNAyS3UCZ3oRhstDmQcAdzLgeO6n7rVwq?=
 =?us-ascii?Q?wuCISLuiQfKZFO0+MSD5e5saz7qJNAwh9bWlbPVVzujupYIL2CT9h5LWRXxL?=
 =?us-ascii?Q?hIAt620YUzPxNMbBjhciZt4Zas1OPEc9MDUryqBGZ35UPtuSgKdCQ3bXHzwG?=
 =?us-ascii?Q?izbpxuEf1+8kDtf+8JPgAC5RpZNV4fLcZmC/JRoUqsvC4ZCx1BV60eruy8hb?=
 =?us-ascii?Q?mvuA7zmWk3DvW3ahJZw7HFe1DdV3wqqQ13uBH0Jvcjh6xUoo+ittT1rjUiJB?=
 =?us-ascii?Q?QtvfBCnsrdrjvtmtBT6MPuFmBSx/FH6SsfJpMH7YvD8PimIcFDPFmcqykF1y?=
 =?us-ascii?Q?mWT3SPfnOw4alwmM6rL4egGcyGX5c1amSvPu2Wlk2JlKPl8/N1oTBx90SXZI?=
 =?us-ascii?Q?L4yenDfT7u5pRKFAQyvjpZh3436qga9oLa88m9uHPlFPfmCcC3mq9RANPbTI?=
 =?us-ascii?Q?vRGM1mHrLXZCV36gyjid8gqMMiqueZaOph4EyW0g8yYDW2bisIvc795S1+jx?=
 =?us-ascii?Q?4+5MIR75Uca7LKCN3cRK83Pg1H4qdRcas1vETe6SHE676+Jzb7r2Z1mBE7ai?=
 =?us-ascii?Q?tdky0fXIpFzEYkaXoN+mxs/MDfr2khangxe+0HtlGQbW4uqQLrKIcO/Y85P1?=
 =?us-ascii?Q?FnCd7k2wceGNwVoIhcoKRTCdPgRYSroKFQzSd3oTGPM6H7ob+D8mNCxaW3MZ?=
 =?us-ascii?Q?QcsfZpWxZYXDlmxGFYvFQQe5um4q88+cfNnCHtHT3cCzvVm4yHodiEqW4XBu?=
 =?us-ascii?Q?mMip+GogiwB3OSCKgNgpBOeQPu0GqhVtF4wv+Lb44qvq3YqIM7WLA5Bkj24P?=
 =?us-ascii?Q?pzeun4BWiadTV6oy4Kqk9rS82kutjZGuJW4iw1TB/IETF/7oFsFLb8Oe4CbJ?=
 =?us-ascii?Q?ItyKkDEkMCJyZdE2pdMse1e5J6K9jv56PEOQmQcAy6LSb+eK+zgDJ0/TyLOP?=
 =?us-ascii?Q?i5zm+v/2CYGcL8NFsIj1dversrjx90DRnuqU+3TnO7PErDFjwwX9hha3AIbD?=
 =?us-ascii?Q?THi8c94dOdIQmbPAEj9NC/blp0hhUP6BcDOHCjWX1nGXzsX8vQWL7gNbYpoI?=
 =?us-ascii?Q?iiXkCTZ1LvTBpsY0H+R9tSZQeB1AHgTiEI/x+6cNC1vSI1WeKZkSkiBKkgMd?=
 =?us-ascii?Q?w1gWfMymPCM4fUUuhj5PjS/FzHknSkhxhU3V++KxbNwtJDnIO771gPwKvbs3?=
 =?us-ascii?Q?1OLJHoWxS0VdpR0BS6lZlIzUD2pcePQ=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ecae668-cd7c-4bf2-f916-08da34c469b0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2022 09:39:01.8567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bTwxxXYkQRyMRJxSItY2Btb8eSIume+zTQWbBwr5a1iXGf8uqk19pWGkw1vNDuT/Qk3SO2kG/fD/g6KkmPQHEG+T/yedm+PRmbFhGJANhzA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4527
X-Proofpoint-GUID: fa2qDdVADRLmcxSHlESlFYfZN0-E2tra
X-Proofpoint-ORIG-GUID: fa2qDdVADRLmcxSHlESlFYfZN0-E2tra
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-13_04,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxscore=0 spamscore=0 impostorscore=0 clxscore=1015
 mlxlogscore=695 adultscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205130041
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
[OP: backport to 4.14: adjusted context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 sound/core/pcm_memory.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/sound/core/pcm_memory.c b/sound/core/pcm_memory.c
index ae33e456708c..adc5f3c2379b 100644
--- a/sound/core/pcm_memory.c
+++ b/sound/core/pcm_memory.c
@@ -160,19 +160,20 @@ static void snd_pcm_lib_preallocate_proc_write(struct snd_info_entry *entry,
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
@@ -180,7 +181,7 @@ static void snd_pcm_lib_preallocate_proc_write(struct snd_info_entry *entry,
 						substream->dma_buffer.dev.dev,
 						size, &new_dmab) < 0) {
 				buffer->error = -ENOMEM;
-				return;
+				goto unlock;
 			}
 			substream->buffer_bytes_max = size;
 		} else {
@@ -192,6 +193,8 @@ static void snd_pcm_lib_preallocate_proc_write(struct snd_info_entry *entry,
 	} else {
 		buffer->error = -EINVAL;
 	}
+ unlock:
+	mutex_unlock(&substream->pcm->open_mutex);
 }
 
 static inline void preallocate_info_init(struct snd_pcm_substream *substream)
-- 
2.36.0

