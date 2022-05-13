Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80775525CAD
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 10:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377985AbiEMIBg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 04:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378014AbiEMIB3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 04:01:29 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76F2822BDF
        for <stable@vger.kernel.org>; Fri, 13 May 2022 01:01:27 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24D7ijlI002190;
        Fri, 13 May 2022 01:00:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=XdCq9R5UVt+WRYC8xjjCQfjg0WtbbFBu7rBmAT4ec6g=;
 b=X5MudyP01d3B9rvHNc+hkd37N0MiGK2uhYh1R75ATaXLU5DNconyW86JX778ZWSkbI69
 dtlGKqf9b8CicRClWfAPlp+dJjkBQarap8tb1wkgtnblDt/9lejkUyCRT7T3u8jDAKUl
 jJfoMGYBa6HI71noPEKCcXj6VkDcIZX/vdONwWEi8r+vBx3z182hR/8HPT4wZr6l3drW
 99h3SmAIdD/hoVhueE7X476ofvLFmRzeX+XMDqwuqOgC1FJb/X1uJ+KDu5LcMdAr2Kp3
 xjz8LZQuLprqZjKuZEAcoaxoQYOeDNdZpTjBHOLE4CbEkctbt/4PMGBL83t5ouCUbwQ9 jg== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fwr9k4eah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 01:00:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KXafLykeI0cnAZrxd3x3D6dGOYzzILsQKXjS523gNLg97C2TLioG44XVUczERpexdBHfMbTDg6sabptG5oX1ytmCIqtk2r08L6rxITU6aSXMPinnqlMH8sFgiDm/RhHRtxa39sZdrdNAwDe5k0Ido0pnTxoUuW8GG+Z62ebySM6lGhktKdh8kh76q19pQSDaNbON9WYuklATr44kOxITQ6yQAXrqkys+4WGDRrbZOdqe7wajxlpzmW0qMi8iNHTDFVtHbYpg5CropEdBHlSk4It9GGqKU+5mJ6lBRpEClFCMGpqBV2K45WHga+7J6wtB8+BeMvlYKyfOjHg3OegjEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XdCq9R5UVt+WRYC8xjjCQfjg0WtbbFBu7rBmAT4ec6g=;
 b=Ix58juphMglQztz9r3j0rG5gS6q+n0sV9ISP/7067Nfk7HzjPiLgwQ5B+jdcOtdcpeJtHF9hr9E/6PXYaqEryR+3odMYbWap3+XlJrLuCpwTYcABgDkN1Zioy0LsPbF5wIjNb4F69d3zoWS1CfnDxfkIqmgIQOSWgs+pkVDuzJ9dcLdBI/J5ICqbPNudEhJjvLZNNJzPCNBW+mypaKzyzbBUYzeWjJl0OHrmi0DGHvknQdSl5hiQ+WB6QAFkqWe8yRPp9uDamhKIvHovSTLUN5/zY5ou8NvrE3QZd+yvN1vGAYNGQjSBu5SNsbSXwAaxyKFG1fQNhmpmD4sUdFoV6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by BYAPR11MB3175.namprd11.prod.outlook.com (2603:10b6:a03:7c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Fri, 13 May
 2022 08:00:43 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::1d93:1511:5d6:9842]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::1d93:1511:5d6:9842%5]) with mapi id 15.20.5250.015; Fri, 13 May 2022
 08:00:43 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 4/5] ALSA: pcm: Fix races among concurrent prealloc proc writes
Date:   Fri, 13 May 2022 11:00:17 +0300
Message-Id: <20220513080018.1302825-4-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220513080018.1302825-1-ovidiu.panait@windriver.com>
References: <20220513080018.1302825-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR10CA0104.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::33) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69d73d71-044e-42f5-e4f6-08da34b6adcb
X-MS-TrafficTypeDiagnostic: BYAPR11MB3175:EE_
X-Microsoft-Antispam-PRVS: <BYAPR11MB31757A5442320CE6C092A692FECA9@BYAPR11MB3175.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kum2VTzJeCP1D01TSYlIajaf41y2QskkvdvL0IzvDiIeqmd4XnJOaE5E5+WCD0CrjJU/iK3pNly0UXDfLUaA/WikxwUGF9qRXZEVHo5VAg+XaKc++y6Vhhttbpx5MdHwkVK40VE/aFeyeIuuP+cnnsnflemP+i2+nci+CXHARjE/ZS0F8dwAz36DEejohC/mS4HIR9AwM2F9YwOyKz0yGV+VLrcZMRHWie9AFsuKhVPdBD3pO9KA7F6qhUL/up3rK9tm6RsIZvYGGFGOkG81Ru5W3r5bCAYYmBHhVgSdKgRxjywxFIt6vtzhpDRQRXBpjZNH487Ds4q8ue/ow9ZWdGVjbMbOw3S7LP4U12jWQSrotmWfQr26xWBEj/NF0enuGw9EQIqiJjSzWYirUaQc51f1rgOsRXC7S1JJVRIqE7H6rAQpR9RdT6Hzge7nCxYgjqM/pcDCH6By2ZqddI9bA2O9eagGXqBEZM04fKIrX1nwxNXoovgF8LYxf5fE3KmI6+0eNbMdiB3pRVL8GsDqfMX6+3RxT/Gam6tWrVrbeHKR15QwhKMgZuEtaDLJzBlpKH2/qazHTI5BDk8uPIUN6zFIXqBtVsyamfg5hEB4p16qlmQG4xx7DS71ZWG12qq19gIksQDmzWY7zQlBtaLXPb7slktXUOB+QI8x9skqhquaXVYfngjEE8wzQA6TeXYfg1Aa7tnwUld5Uj3SQwTn0dEQbAmsNYfLhyEIfTruNz3mEU/LNvcA20rkXsEUiL1i2QXlKsR9eh4twHVBjT0nzCRtMthRZCeI/SoGBD1Ea/o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38350700002)(38100700002)(54906003)(2906002)(4326008)(83380400001)(8936002)(44832011)(5660300002)(66476007)(6916009)(66556008)(8676002)(316002)(36756003)(26005)(6512007)(6506007)(86362001)(2616005)(6486002)(966005)(508600001)(107886003)(186003)(1076003)(52116002)(6666004)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XV6VD54rQvDgM85pNH1tyATMTZha7MGYsLG1L8a174KoJtibryaWnHS/7jjp?=
 =?us-ascii?Q?9Dt+TmESNfA5Fqi2fkeyxVzUjRMNs9OoQiswcXdDinYEn+cz7TobpScXyvzY?=
 =?us-ascii?Q?laGTURe9O4WUub73errspMpv1rXDQIS8YoT8Hz6Bp6PWGyxd8ieDhWpC2E/I?=
 =?us-ascii?Q?Ra9N6Twuj/DruuBibmCFkaNYAn25NBcRkQ2acFqXNfqOptHSWoLa1M/BXPwy?=
 =?us-ascii?Q?Gnu0Tk7RWPLILSajLSomkCc4i5XPuRtsj/Nt2wOMckmiCTcV4wiWNMK2j+8y?=
 =?us-ascii?Q?4O9L1eOKhe856/8JmTKFqvzFp0hVbYXjFWVik2kFMMuNbKze5OpGY99YPEa1?=
 =?us-ascii?Q?T7nuBlqjcUNttvMQN8cYQR306rp+89BMOiG530cTouI04/BQ0Fu+bsCcCszt?=
 =?us-ascii?Q?epJynBfImsRnlB0l2S0ijNi1OALRKxXxo+JtNnqXAdm5UnKrXjtvfqzo5+EM?=
 =?us-ascii?Q?jxf5EAT5Y7FZcDeQphRSIWVpryPNQgs3YVJ8FZ/TeSv97kaeS6V3sLp2g+xM?=
 =?us-ascii?Q?AAvcwssOYePy9lwECDs5rO9brlVnMotDi0qzyjIbtMf+AHyRXPdN30UDpxSJ?=
 =?us-ascii?Q?8nlkh7rBZ+dvjOeRdOczRUXx/zo6T7mWoaeHw7d3A9Xu3/Z4KCkd4RYunrjJ?=
 =?us-ascii?Q?UMJNKn4KILRj83WPWoi0X3ZHsodkXIB/P1mKHazw0jss5s6s8hAtMZOpsbFO?=
 =?us-ascii?Q?qZx72T4vM8uKmx2vyYPYFFjVRYolbSw4fjNeeQPLEdA1kmpWeBSt/Xg4+vJc?=
 =?us-ascii?Q?L+C8eSOxLWK/Fj6CzgyMxHA3BB/UcxNVB1qCfdyXMdtdzj9lfuVvg66/9cKE?=
 =?us-ascii?Q?bNSnQf9k4Q8OBCqkDOmg6onDAp5A1EiXjQK8It//7q651Ocwk3Djl5/sa28h?=
 =?us-ascii?Q?Pz3m4rJm3yhEVLGP02VQJZF1zrKWFsdGJ0TIZAgFwU2OvTZWUzEQ+6Zuo4+5?=
 =?us-ascii?Q?B+HzCyfOBwQxerghGDYi3+1/oSEd5Dho3g32exiRLk0VIdNiVNAFIYQ1ocJB?=
 =?us-ascii?Q?a142Aivfw6EFEKhuEwpQta6lHMtJYzguZyEyyFxGhj6oFoZgH4xzb1vlc3to?=
 =?us-ascii?Q?l5+o2typRzn+QiTlFKoPpYF6DJ1xVXR8Bx6+3eThg2RN+RKsob0nxNcDqfvj?=
 =?us-ascii?Q?yQXdl4CmDxbNrILUxx3U/TWmk2sr0vJmuheoZd9Icmz1/dnERzJXHxJ0ezN3?=
 =?us-ascii?Q?jMEQkSlrqYP2/vHt2A8DeA6Aez/3jNsOovYkai0M+f1mOwREL2uKqzsz2vfd?=
 =?us-ascii?Q?2A9cJSYYuwJ5GWIZ33hwTKswLNFPAACgMqo6dk7zI7/Jvk4bbNS/0VdfmsWy?=
 =?us-ascii?Q?pOeNxOnShg4R/0rqXRSITtYURTXuerGV/MwzWSgvnR5yR9sZmAxajGnpqaeB?=
 =?us-ascii?Q?2B0rxfORSTuVa2rW+hKc9VgPGHy7cXvIwZBsmYyc1rE0+lbVkyEszsGtjOOh?=
 =?us-ascii?Q?yF9yA25JafFFSzbm3oj6RwZH1uctDObSHOeFCqrsfH195DQyii5iev9CDtWD?=
 =?us-ascii?Q?54qWESnDgPPjLZ4CBH9DLj4HdjjUAH8a5K8/ljTU10x38rxjXpHDDCthFx/O?=
 =?us-ascii?Q?OKrasZxLxJnTaxB9I8j24JwAQXFZ2hIiECLXRl6EDte6o5g2yTvtsv6l12G9?=
 =?us-ascii?Q?5SDN2mQ6CrOtrbVL7C4MUTSKM0FBmtnB0phUn02HfrGUSUsboMHKVL6CeuAw?=
 =?us-ascii?Q?2WUiHDr+m+fZnOYfyhAjNc+9rn/5cnHkJgOPUzW5V9ppZskoiFbUMuikTsRi?=
 =?us-ascii?Q?n0Ed5jw286/4SmvjqDd8CZgcLsXlrSo=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69d73d71-044e-42f5-e4f6-08da34b6adcb
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2022 08:00:43.2108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YB5KVYTEezFIk53HUo85hgZBhKDThyhAbb9wsbI8SolM9js2YA72I3jJr/sLcQ0yepIc72vyL5epdA+o0wuphLM8oMZCPHPbxkHEM6Wyks8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3175
X-Proofpoint-GUID: qNVh3RhTVJhQs5nTW1walZFCs22g7gES
X-Proofpoint-ORIG-GUID: qNVh3RhTVJhQs5nTW1walZFCs22g7gES
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-13_03,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 impostorscore=0 spamscore=0 mlxlogscore=695
 phishscore=0 malwarescore=0 suspectscore=0 clxscore=1015 mlxscore=0
 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2205130034
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
[OP: backport to 4.19: adjusted context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 sound/core/pcm_memory.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/sound/core/pcm_memory.c b/sound/core/pcm_memory.c
index 4b5356a10315..48e5f0091ce4 100644
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

