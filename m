Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1060851D409
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 11:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344517AbiEFJQX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 05:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235148AbiEFJQW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 05:16:22 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DC563399
        for <stable@vger.kernel.org>; Fri,  6 May 2022 02:12:39 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2468iumD011524;
        Fri, 6 May 2022 02:12:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=4grWupm3sBSQ2IA7d2PJ+ace6WO7B776ruVHznaDDlg=;
 b=p1mokqr3ae4r0LjpRshlVNR9029q7ekSoOEwdUSkRG+71tdOzGUiYWOQ7sVSsGuitMIP
 fkEsKcOM4148s9/pZFbOnNZhGLtD/LiVUSZM1jEAW8a89yJKSvBuMhCAjfwN+by3ZLYq
 CWzq/3DuTHgSf/kb3r9I2HXQsxc1/Gc84K9UTcGD8f0k4DE4FfR+UGIG3x9AhD1R+S8j
 h/t03dv3AqH+OxtkBsntcBarxWsHDnFDvAA1gPBjJxGardZtdvOWsEwMZeFwqiSInRbN
 9+u+pQTjB8sgtltvNB0Lm3aEq5wP0HNpBtRqp/fd79psDmDmzu2cJxHpPcDAklKqRTSd JQ== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fs0d3cerd-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 02:12:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OXTOUHUmmp6Sj8JBXh+CKXHrlmG19TRywg8RIq0V1V1Fw87xVxAbsvmB+Hv2Rep3YHBDh/PwovSXPxDwhcB4hoe4tnOvWgU7YMl7RM6bYyGyrk+5NjAKoh0ieI5rBJljhMCAqXU8HzQv2oKPS8bNc1OJsO+FLWOLhmI/jqCh5QiYSmcMHaqiLYFMGo7z25c9zZNniPxba8T/sPYTy+XPZfkCOsJwDVp8Vr0tT/52wUHqoyV2A7NDuhUiubPPaugsXW8/jKn8RV4HswVWv02t1sw/lfV0BUjdxaMsQfoCIw+al/GDYrkr9aCT33e2kW9HJrg9nhBp9AcUzTyAEMGCNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4grWupm3sBSQ2IA7d2PJ+ace6WO7B776ruVHznaDDlg=;
 b=LcvM9S5B63mbcV78yJiELDNwGhtlmNna3BKZ1CuecLTKtdz2F+K3f7bDmWUmaAsxzoSdlzJA/fvp9BiJqJFrFAP034YP8IEz00DPByZnGMRYlBusbwEln4Gxv+7cdrCz1trVRbo0IfiPW47Igvp4IVSlQTXKTjW1UJZFJKxDtulC579B4iYF2alS7sTvQxjXO6Zkbz8UaE9qmx54KEQe8jEYED1xdiCtxEvPq7GSq/M+Z6RNXPWsPrGbV02sJPCJL0GYFPNlLLrXSYfwOmlchOvISq9TqPWhgstP+jH9TYSuk7Q7ntfEocHMRAQdVuo3w7FgQo/d56v1NAfYd6GZ1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB4444.namprd11.prod.outlook.com (2603:10b6:5:1de::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Fri, 6 May
 2022 09:12:24 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::806f:3f7a:c1be:ff34]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::806f:3f7a:c1be:ff34%8]) with mapi id 15.20.5206.027; Fri, 6 May 2022
 09:12:24 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     tiwai@suse.de, perex@perex.cz, kirin.say@gmail.com
Subject: [PATCH 5.4 3/5] ALSA: pcm: Fix races among concurrent prepare and hw_params/hw_free calls
Date:   Fri,  6 May 2022 12:10:11 +0300
Message-Id: <20220506091013.1746159-4-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: 6f3995c8-831e-4363-4c66-08da2f408878
X-MS-TrafficTypeDiagnostic: DM6PR11MB4444:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB4444FCE3D2638EE4DEA1F88BFEC59@DM6PR11MB4444.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wODqthnhiYnF/8MSVHNXaAshF432Lu7Pnv38XYVgT+fHM8xWf8rrI8vPJWx1V9P2uzRJA3hZEMz/F+fdD1pgGyy8OdkNTiX+UvujMyiN6VELcBZzJJxAKaPkDJ11MSEsksj7ZSrY7nMJfjEYOeGbqqvCJXTfj02Ewxkn0seHdJL51fNRg2M7X5iiY9YJbkuGfRn8NYsPgm7c3cCiiwzXHxq8T4b/gWmcxyGzKP1kCMKsuFkRAaCfx8glORbgpPCJge+Ym33/MvQYV1HUubh+LnTYIGrdIqKClhMP99hOwzFh2zvU5uDLN8zoLrMvN02FN94xbVBnfBiRqYPz1Su38y56SFuLWxemaH1kQixq0oAUW23dH6AQSMQfe6AZyW4RwzWmJHqonjpBdFSA/M6QHGViQD1Y8Gc4c0CDX9z4vB5UrwuQQvNgufYSOB0LDQHrGf3jXSB0ak1dgpNgBcPA/n0Bf8tMcasjfQnBoH5F0gTLMnKtZuzBzzmaOCLhWn5IYpPhXnBMERCt3UGIfPReCcaZ0TyqZkHDyLFZXi0Y3CFzcHFhjxlbllNOSdGwQcT3ybwQ43go1Fm3bw8tlrZhIGE4tUTpi4dDeZJ/X+D7Pkx1QEWrBhPEDcvVuHs5WgIw9w6qZsB9B73/52wYgdLg92b0IzVvDU+MQjE+pU9jEAkRRYUjuHpjQY/0WKFwUJ9ocBA/Cep1RrwR0xQjeNryz1lLr9rOWMnktfLgGy3WfgabQEWJeUCFiLKpAINR3BekD3KQJMRGeq1VI0D5pINCExEzm0lc6B6OE7F4WyzMkz8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(966005)(508600001)(6486002)(5660300002)(4326008)(8676002)(66946007)(66556008)(66476007)(8936002)(186003)(83380400001)(6916009)(6506007)(86362001)(316002)(2906002)(26005)(6512007)(1076003)(38100700002)(38350700002)(44832011)(52116002)(6666004)(36756003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+GAHIEruc/EfBq4CNo2+bJc/8DDL5iNwFO9HsvTDhUuPMVJievgnjD6NQWhn?=
 =?us-ascii?Q?ThNfpHNdUdFn+cjQ95PHYvg4y3wY1OnNiYh7gPsM45GrFMbjgJtB1gO37elI?=
 =?us-ascii?Q?PRLuL0YYUE2SpyqnPeD3Q1rExJqMIKeJs8ccnppomFtdAfBKfN7V1503r78b?=
 =?us-ascii?Q?qfsHVlVfEMVPzehaURW6EhNRmMPVhU+93dTf7F2++kRFAfgiwQPH+TPGO4PN?=
 =?us-ascii?Q?DQjkHiZFBrD/DAwJ3HE6q+MQb3o/SIMuot8M5pUmbI9TptBf8Ss/Wx2NIhIs?=
 =?us-ascii?Q?+GxG3Q4950vslBalZk6JqA7R/QNcpIePydRkeWi23Y30pqwVUSzKc3DYr51z?=
 =?us-ascii?Q?+RRH6wJSfFDXB9d8Yx2mcCS/GJoP4aXM4WFxI+6HKNnYrgVFICm6n/yj51Uz?=
 =?us-ascii?Q?PSsKrIAC5LvocnYa4DkzxVlz/7ospE0tdFXC5HHTSlvR13nK+tG6NjkIOEXb?=
 =?us-ascii?Q?rFSlQwLYKcxIQgEqwL53hDtYSPlXMdvhCQMlCtbebDosZtnyL6TC3yRswUPH?=
 =?us-ascii?Q?lDjy2GDhR3Nj4QkpOihZ8vqfZPSH0+XfBIL30qn3eDHHo5gKEtfldQg+EpEI?=
 =?us-ascii?Q?qipaU00fTOQyQ9w2OaLayzWbOw4sbGse28xrnEdFj8s/XTzGHovTAIC/zLYw?=
 =?us-ascii?Q?wFxQpjw/FPVsWzjbfngI+Cmhr9BauAz8VsDi14fWwY0fQ8KvjFdGYglr9DCP?=
 =?us-ascii?Q?4M7sHBoUZkb2ql3m6zSfm76hXNOcffwkI1Xy8x19V1u7Tq6pOOwNRz8ps9bx?=
 =?us-ascii?Q?tkSHJDMTf+l2s1vI7Fx22nnbzJKghkonri2Yq5vP8zl4ULN3N618PqlbbHcW?=
 =?us-ascii?Q?pHiCU7IDTupIH7KCluZrerPGlf+xtUlt/GKmSNRMAFTtjcNAZxJjtGQeMZqE?=
 =?us-ascii?Q?6lb3ZA4ggMKN9LFU3WHgN+6NqaUUBpwOLl+nxfPVQQY7yGpQyAudHD3KhL8m?=
 =?us-ascii?Q?ZyF6t++2P2W5Ro60FBWpt3Wub8n96uvEzziY4W2Pby6gyyTMLqK/DRnGdHSX?=
 =?us-ascii?Q?JAGpqkLQd1225ImarmjgPE0m1QxTWseYyc/XQ7/nJdti0rPOmUjx3rOvt7ua?=
 =?us-ascii?Q?BseTiJD2dZS0jrT0Cr4mEQGiS8q0/HFsPyu0TdGBHfZ29m2A1QmeijvOIGe6?=
 =?us-ascii?Q?vch3Lc9lfEzxernJj/LLBW0l6Y6U7kRl0d/p4rXGI5GhBICMe2yhyjYPsaIL?=
 =?us-ascii?Q?AE6wcs2MOGpV+fAtOwwXZW7e9akBWxhv/iAiC02ydEPGpyV61OHJDqKIUoME?=
 =?us-ascii?Q?K3VnA2KuJVSaGsSiBibLb00OhQe6Un8HajIs7yWvXmaaGAOkbfeFHXSIEIcP?=
 =?us-ascii?Q?6WShfkAFo0/iYOLmmJvIDUiRpgv2kKqHNYciPDgJSmD9zaHhOh6V64HqCJlD?=
 =?us-ascii?Q?YSLeMAgxaTlpR/w/6cbMq5OZ5ogzmMLV0vzeuKGVb/uXBoNCr0QeRtVX0ixw?=
 =?us-ascii?Q?JcFQkVsbacNCE29BXvpaTvRoEeh82Vg3Co4L8EwugeJr0iTZ4zuQQE0abEix?=
 =?us-ascii?Q?LTPy3uljecHb7qgsrqi6o8cBDSdq7atsZBcLKwxYU0y5HzGHXA4G2c07+JhE?=
 =?us-ascii?Q?n9BkVkMxj4L5RorRKnuQJ3xw8lJhH9Y5r48LcfZu4eNg0q9OUZlLgcLVLYrn?=
 =?us-ascii?Q?UQJoaOopMLWCJLiJVa14953AW56rcwr+mNF6z3k1GCMCceCOe0mlAUT7/KyR?=
 =?us-ascii?Q?2VAm+C2CEakYcqtpC+XHgxDINgakm+eZK+lAxLIgYnO+4Ddx/2j6C659DKEx?=
 =?us-ascii?Q?DnplLAiusGBBj+FZFmG93kxVNv6PKb4=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f3995c8-831e-4363-4c66-08da2f408878
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2022 09:12:24.1450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6fyNTMp5u4AEOeOse+I1OKCdxW9v0DMDYFLZjLO/UnXfXGIJh7zmNb+wvpgQjL+Pz3bNirB9C/TigrKdDHJNgJ31gIIlXKaKn4GuciCvhPc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4444
X-Proofpoint-GUID: QB3UgOR9tu-3LPtfyy4iSxOpb_W_bkmU
X-Proofpoint-ORIG-GUID: QB3UgOR9tu-3LPtfyy4iSxOpb_W_bkmU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-06_03,2022-05-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 suspectscore=0 lowpriorityscore=0 phishscore=0
 impostorscore=0 adultscore=0 mlxscore=0 mlxlogscore=920 spamscore=0
 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

commit 3c3201f8c7bb77eb53b08a3ca8d9a4ddc500b4c0 upstream.

Like the previous fixes to hw_params and hw_free ioctl races, we need
to paper over the concurrent prepare ioctl calls against hw_params and
hw_free, too.

This patch implements the locking with the existing
runtime->buffer_mutex for prepare ioctls.  Unlike the previous case
for snd_pcm_hw_hw_params() and snd_pcm_hw_free(), snd_pcm_prepare() is
performed to the linked streams, hence the lock can't be applied
simply on the top.  For tracking the lock in each linked substream, we
modify snd_pcm_action_group() slightly and apply the buffer_mutex for
the case stream_lock=false (formerly there was no lock applied)
there.

Cc: <stable@vger.kernel.org>
Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20220322170720.3529-4-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[OP: backport to 5.4: adjusted context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 sound/core/pcm_native.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index b15ef9df114a..4f53e6103fd5 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -1042,15 +1042,17 @@ struct action_ops {
  */
 static int snd_pcm_action_group(const struct action_ops *ops,
 				struct snd_pcm_substream *substream,
-				int state, int do_lock)
+				int state, int stream_lock)
 {
 	struct snd_pcm_substream *s = NULL;
 	struct snd_pcm_substream *s1;
 	int res = 0, depth = 1;
 
 	snd_pcm_group_for_each_entry(s, substream) {
-		if (do_lock && s != substream) {
-			if (s->pcm->nonatomic)
+		if (s != substream) {
+			if (!stream_lock)
+				mutex_lock_nested(&s->runtime->buffer_mutex, depth);
+			else if (s->pcm->nonatomic)
 				mutex_lock_nested(&s->self_group.mutex, depth);
 			else
 				spin_lock_nested(&s->self_group.lock, depth);
@@ -1078,18 +1080,18 @@ static int snd_pcm_action_group(const struct action_ops *ops,
 		ops->post_action(s, state);
 	}
  _unlock:
-	if (do_lock) {
-		/* unlock streams */
-		snd_pcm_group_for_each_entry(s1, substream) {
-			if (s1 != substream) {
-				if (s1->pcm->nonatomic)
-					mutex_unlock(&s1->self_group.mutex);
-				else
-					spin_unlock(&s1->self_group.lock);
-			}
-			if (s1 == s)	/* end */
-				break;
+	/* unlock streams */
+	snd_pcm_group_for_each_entry(s1, substream) {
+		if (s1 != substream) {
+			if (!stream_lock)
+				mutex_unlock(&s1->runtime->buffer_mutex);
+			else if (s1->pcm->nonatomic)
+				mutex_unlock(&s1->self_group.mutex);
+			else
+				spin_unlock(&s1->self_group.lock);
 		}
+		if (s1 == s)	/* end */
+			break;
 	}
 	return res;
 }
@@ -1219,10 +1221,12 @@ static int snd_pcm_action_nonatomic(const struct action_ops *ops,
 
 	/* Guarantee the group members won't change during non-atomic action */
 	down_read(&snd_pcm_link_rwsem);
+	mutex_lock(&substream->runtime->buffer_mutex);
 	if (snd_pcm_stream_linked(substream))
 		res = snd_pcm_action_group(ops, substream, state, 0);
 	else
 		res = snd_pcm_action_single(ops, substream, state);
+	mutex_unlock(&substream->runtime->buffer_mutex);
 	up_read(&snd_pcm_link_rwsem);
 	return res;
 }
-- 
2.36.0

