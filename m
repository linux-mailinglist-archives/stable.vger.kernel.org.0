Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AED6851D40A
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 11:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235148AbiEFJQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 05:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381989AbiEFJQW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 05:16:22 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E306339E
        for <stable@vger.kernel.org>; Fri,  6 May 2022 02:12:39 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2468iumA011524;
        Fri, 6 May 2022 02:12:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=dzLt0aygkLkskYLrNNvizvQJ3bQoE27lOLZKYcucZVc=;
 b=Vg6eNtSm76yORMnxtSjx6+H3wkEtvLbLm7ISFx1x8CJOlZREnIDPqh83fT8xfSLgEgVb
 tEdgx9hDW0YPzqtJQO3Y4DZFunsl3Q+T/x1POvL5FeWwiM7/Y1wCV7wKy9uITnhwIMop
 f19ajHfhKq9YQB6fttJAtVbH7N/lti+bT0Wzpg7zUOpLVSHUKaLnSxt2EPph0rTSRX7r
 ab072mPHt5H1pacepYqZadSuwoA1caC92wFgJQuD/NVM8SIpX4GSyvVzi/3++a8v6mpD
 J/hStgt8VHgmkStZXJ2o299oSrQj+wXLw6U9Ktxm4YhRSKwu9zwG9Jp3cBiVwvpnB6e8 lQ== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fs0d3cerd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 02:12:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ra21t4A42JT1pmsGeyOSDHyZU3/K9aqdh7JQXI58IkC2npwsmZ1FgRrAcUT5v6n82WRw1sMTZjkoIwldzIFO2rzDbUnz6ZzWex/APIwfdU9X9iGsCqFvcPQOygKoy+Vkop94+s/tHDOPP40ND4E84THzrz9iKd5PEsmc9jF8uFL4oafqHBr85kGbPjGiGOfz/cQ8aBg54a4HW02/9avNC37qLeOB40lyyt07sSv4l6N+Iyoe5ACJIyDsJNdE3ADyPVJGXIneGVN4YwIhEhCdE638pdbQVDNm1r5z8SXDD6DrXM2PultsnCaFVSd79iEgy1YpeqxiAPs/qNute+E4Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dzLt0aygkLkskYLrNNvizvQJ3bQoE27lOLZKYcucZVc=;
 b=eDUKdTXXJ+d8RV1YX3qBn+TOyhyuOk4vftOz23UGIyFvzXW6b1Hcv8sCiVEleY2z+LPX+XOh7t9yLLNbQRIWN6uexw9aXFPc3j4QenRrJyjpOzuIQtJKMc5GYN2ecdagthrYfHTxMYouhW6NGqJNXo2L04pjkS3iAVC5K4IvYehH0zZmumEWuQmf8YenNqdh5VZZbEJats7cLcP0GPO0xdQTpKewg4/v8Io7fgyXhyD8uw9FtW1U6dNeQWy4aW92xMnZu+N87hvy1C5buGvwhUXnemHgwHQUs/xm+RPLFT7MNuFXUiqL/vHtMVgUQqW0T+1JjwlpTi/kqvZX6XnbtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB4444.namprd11.prod.outlook.com (2603:10b6:5:1de::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Fri, 6 May
 2022 09:12:21 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::806f:3f7a:c1be:ff34]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::806f:3f7a:c1be:ff34%8]) with mapi id 15.20.5206.027; Fri, 6 May 2022
 09:12:21 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     tiwai@suse.de, perex@perex.cz, kirin.say@gmail.com
Subject: [PATCH 5.4 1/5] ALSA: pcm: Fix races among concurrent hw_params and hw_free calls
Date:   Fri,  6 May 2022 12:10:09 +0300
Message-Id: <20220506091013.1746159-2-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: 5f51b5c0-07af-4d4c-4fe0-08da2f4086f8
X-MS-TrafficTypeDiagnostic: DM6PR11MB4444:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB4444CBB9FAC9D56C9422E827FEC59@DM6PR11MB4444.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 25PjDxFkAKgvOQdAKCoaukqz7Faf1u1WMgM36Z/WW04/oD/wPSh/QHxX2QHSo4/b9YLrqs7xdm2sP6GDlwkRshyUtrLYOT9mtD/umpg0nDWiJxxkaD+IQP5JNq0FG7IS4G/58F8n1UU4ee91k3lCdXaek4xNuibDBu5sAgwFVpm897pJGGSBmSgVNv9XE55kN1cbXriVhltfMQqu/erTeqp3/ZSt0UCwnU9y9Ce40KJIukmje0aCVWHo5z5CszF0TZO4WLe0paxyfwoMDOg3bBmpGluZ0X9GgE4ZopRzDTBarnNnEKz8e37BfqveJZqmjV7SWUL3YeIDD6dKl+K8ypVdzjM3s7sDIa90R9qrVb4BO1gAzM4xq6b4JBUw4/G/4/7e906O49X9F/G6pKsPNzsN8IRuWurx9ya7fogZ1x//3Ts51GL4XrEOFkbq9oADo2IhX4/YDldpBFSFRZZ80/D7MT6eqV67NGY8tdwYbu5SVArF8yknb4pHVSPbXY+0t5Ww1szoHUUIK/d0s3IslS4SYaQ1gAB/guFyS1wO+7P1qrJhoauea4CScI00y35EYp+wKk3seYsE9pNGHwU6PmZIQyo7+bs9lWfJAUI0g4wRWTHKNEb+LmXt1IAgOqnbjXN88pjqw1Z8fgO5Uu69m+XbnVWeR8MZRDB+v71JoFy/I0yIYgRM0mh06kxe3/+Bqj7dodMwyJ2NT+fviw6TTX1Ko41/mIWdu7Lx32RcredAOwtBk4L7P5BB2Fdk6ZEIdvgezXVgz1X1QD61OY8QI12TVzVo2mh+ysLAxSkBBXg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(966005)(508600001)(6486002)(5660300002)(4326008)(8676002)(66946007)(66556008)(66476007)(8936002)(186003)(83380400001)(6916009)(6506007)(86362001)(316002)(2906002)(26005)(6512007)(1076003)(38100700002)(38350700002)(44832011)(52116002)(6666004)(36756003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VaNXNvCesOA835U4vvRsr5SS8ITwcGc4kfNlU5ACCQaWBd7bDx/npxiVQ6aw?=
 =?us-ascii?Q?0QUTKhvW5HdaVIoHlOW3jOSHsPs+2LQdYe6F22T1VV1bGjTv+WM1ntjwzyO4?=
 =?us-ascii?Q?OVoxkKB+KxRV/U2SasLSeEHgkIhHiYi5Qz2erJm6tzg5+ML1PMqHKzi39gkF?=
 =?us-ascii?Q?xLLi9vUVQDamM4RQlZKx5oo1bI3TQxoNd1FbNHwh6bccatUwmsyMywLurnZ5?=
 =?us-ascii?Q?oYXqx9PmLmibUDWnDD1fsC06fm/W1Cfn/XjHjTCPUiAhCAxZ6PyB0iGNPc05?=
 =?us-ascii?Q?XyH3eOat6UipHrNOB91+c19KEnn16qVZ7WD6cOI+IZ2h/jL2G7m3MjhMfT9Y?=
 =?us-ascii?Q?Dat4hqLlQqZ86fJN0790JUouJ+411P/eiFvWmc3yAtRoGjrIvRRvAzRxfmZm?=
 =?us-ascii?Q?DVgAL947XLk+6qrBbcVsg2p5JVXNX/SK8GuZOXOKf0iNkNGPdYDEcDj3gFZw?=
 =?us-ascii?Q?UbDtjSa4HGXSDw1dqPxIr7cfBzPOscuw2GeDdMeMsB/HKThzvRYOg0DgJxMd?=
 =?us-ascii?Q?B7Iqh8Vn0dNEisXRJPiDwbqWzSa4sdVWa6kPOhLOV+duv42uGhEt/z3TI49x?=
 =?us-ascii?Q?/Jeg141gsK3YNzQ5ATfJm0M5FhgqqIRvFf5BX8nWbdwZdud4P9cXJUWmK8OE?=
 =?us-ascii?Q?vfFn3Ekf1tLiKcc6295W1HdW3uPc1bcaquC4P28IbqrdpFxBDHGZKKUtFhKp?=
 =?us-ascii?Q?ivvub/pFIG0kfWnG5Gl11Cz7jj8fpcL3aqWq49iRoJcFaC+9UeZXr6s5Z0cN?=
 =?us-ascii?Q?d/+2RumtJHfRy8cMlOtBOS/5Vmt15h2WrgGcfkcCc198mPE8VWzsw4WA/qtZ?=
 =?us-ascii?Q?zR76kxn1cCxXrj/NcPAXt6ESblYhcSTAR0FdPoTd675NH22Fn3KTd5O+ucri?=
 =?us-ascii?Q?zq4NSagDGkTqsgBhVexoxUspm2q7HjbvrOLV0Y7d3guMCmPcyIkRXmiMQ+c+?=
 =?us-ascii?Q?PuyVxNHKdaEOkb1TavLyXWTwaGyxZ1V2FXMFtqnWmSF7KXBzrqueW20wJcTc?=
 =?us-ascii?Q?Rc1m0pabpwS7xAlw0c1qAzM6mhjF1f6MSqQ1s5Bw1o6+YjHZi1C2XtvfaOKC?=
 =?us-ascii?Q?C7Df+A9pGjdw3hRcY85PqBDsFfUaNnc+d77J3ra6FVOlFVg4bXxHyDVrJHZE?=
 =?us-ascii?Q?KaVJtk4AA6uAnsZp2R7yWL8sBxkfuGnzz3x2oVM+LQ1JKiHKFUantUz1yrhq?=
 =?us-ascii?Q?mwS+S/zicVdrcjJVShEkIntv5X3YebHNMu52HTfu4qRNMPQzmUHHOyQpyTgo?=
 =?us-ascii?Q?2f9RfD1JLA/mpZou9bgYZpH20qhFtpa14HXhXxD2wkd0+FgSLvxXRveNFTZs?=
 =?us-ascii?Q?JIuFViUYmaJNlI4PNgU5FNo5lxh4wY+Ag1WTYNbCGWjcwzmXtHtpEgFuEN92?=
 =?us-ascii?Q?AfpG7BDsv/CuHy88DaOdsBoB1W3RWOuRL93IH/7MgSrARK5xKrfyYwtwfyoj?=
 =?us-ascii?Q?u7EJnuuVxx/nsFjk3wLbT9KJDLaiKOqIhUnM/ed9Cw/mGCwqIhoT7K9y9ojG?=
 =?us-ascii?Q?zBttFovxlz84BDISL7QSrAOeAjZFwxp9AsFAbR1TH9+/7IGtN3/xJt0NQmeq?=
 =?us-ascii?Q?oYTeWJb+scB0B0Fd37b523vIC0Zfg5CBrcNQLNGN7Kw0vjzpgTWys+mLupWG?=
 =?us-ascii?Q?kPwiLmIQ4kFJ1jWpMLdceBE+N1Q+KzEBXbVvl6/Wryaxdlh2Agi3Rmai3DHu?=
 =?us-ascii?Q?DAU0YXkHbEPVRxvG+iYjilav2oWZ+wSj3FicohmshODLmLJTP74NP06r3JGV?=
 =?us-ascii?Q?9PNvmvHNSGayjk3A2UQxw4RM+cXDbxQ=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f51b5c0-07af-4d4c-4fe0-08da2f4086f8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2022 09:12:21.6272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jiJ1Zp4058I8AT0QArQy3pI026qkCkQ4/I92D6Xf5MvQ3reNie5DKXgS6ZXg5kCt8mH713kuwK+z0Th3hhv2eZuybk7oe+xj+3ZnknhphhI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4444
X-Proofpoint-GUID: f1bUrJyXfdcM2T3Qv-412qLDhrXHnTr9
X-Proofpoint-ORIG-GUID: f1bUrJyXfdcM2T3Qv-412qLDhrXHnTr9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-06_03,2022-05-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1011 suspectscore=0 lowpriorityscore=0 phishscore=0
 impostorscore=0 adultscore=0 mlxscore=0 mlxlogscore=931 spamscore=0
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

commit 92ee3c60ec9fe64404dc035e7c41277d74aa26cb upstream.

Currently we have neither proper check nor protection against the
concurrent calls of PCM hw_params and hw_free ioctls, which may result
in a UAF.  Since the existing PCM stream lock can't be used for
protecting the whole ioctl operations, we need a new mutex to protect
those racy calls.

This patch introduced a new mutex, runtime->buffer_mutex, and applies
it to both hw_params and hw_free ioctl code paths.  Along with it, the
both functions are slightly modified (the mmap_count check is moved
into the state-check block) for code simplicity.

Reported-by: Hu Jiahui <kirin.say@gmail.com>
Cc: <stable@vger.kernel.org>
Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20220322170720.3529-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[OP: backport to 5.4: adjusted context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 include/sound/pcm.h     |  1 +
 sound/core/pcm.c        |  2 ++
 sound/core/pcm_native.c | 55 +++++++++++++++++++++++++++--------------
 3 files changed, 39 insertions(+), 19 deletions(-)

diff --git a/include/sound/pcm.h b/include/sound/pcm.h
index bbe6eb1ff5d2..24273d0f770b 100644
--- a/include/sound/pcm.h
+++ b/include/sound/pcm.h
@@ -395,6 +395,7 @@ struct snd_pcm_runtime {
 	wait_queue_head_t sleep;	/* poll sleep */
 	wait_queue_head_t tsleep;	/* transfer sleep */
 	struct fasync_struct *fasync;
+	struct mutex buffer_mutex;	/* protect for buffer changes */
 
 	/* -- private section -- */
 	void *private_data;
diff --git a/sound/core/pcm.c b/sound/core/pcm.c
index f8ce961c28d6..c9335d1d0e44 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -969,6 +969,7 @@ int snd_pcm_attach_substream(struct snd_pcm *pcm, int stream,
 	init_waitqueue_head(&runtime->tsleep);
 
 	runtime->status->state = SNDRV_PCM_STATE_OPEN;
+	mutex_init(&runtime->buffer_mutex);
 
 	substream->runtime = runtime;
 	substream->private_data = pcm->private_data;
@@ -1000,6 +1001,7 @@ void snd_pcm_detach_substream(struct snd_pcm_substream *substream)
 	substream->runtime = NULL;
 	if (substream->timer)
 		spin_unlock_irq(&substream->timer->lock);
+	mutex_destroy(&runtime->buffer_mutex);
 	kfree(runtime);
 	put_pid(substream->pid);
 	substream->pid = NULL;
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index dbe9a65cc1d4..b15ef9df114a 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -630,33 +630,40 @@ static int snd_pcm_hw_params_choose(struct snd_pcm_substream *pcm,
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_SND_PCM_OSS)
+#define is_oss_stream(substream)	((substream)->oss.oss)
+#else
+#define is_oss_stream(substream)	false
+#endif
+
 static int snd_pcm_hw_params(struct snd_pcm_substream *substream,
 			     struct snd_pcm_hw_params *params)
 {
 	struct snd_pcm_runtime *runtime;
-	int err, usecs;
+	int err = 0, usecs;
 	unsigned int bits;
 	snd_pcm_uframes_t frames;
 
 	if (PCM_RUNTIME_CHECK(substream))
 		return -ENXIO;
 	runtime = substream->runtime;
+	mutex_lock(&runtime->buffer_mutex);
 	snd_pcm_stream_lock_irq(substream);
 	switch (runtime->status->state) {
 	case SNDRV_PCM_STATE_OPEN:
 	case SNDRV_PCM_STATE_SETUP:
 	case SNDRV_PCM_STATE_PREPARED:
+		if (!is_oss_stream(substream) &&
+		    atomic_read(&substream->mmap_count))
+			err = -EBADFD;
 		break;
 	default:
-		snd_pcm_stream_unlock_irq(substream);
-		return -EBADFD;
+		err = -EBADFD;
+		break;
 	}
 	snd_pcm_stream_unlock_irq(substream);
-#if IS_ENABLED(CONFIG_SND_PCM_OSS)
-	if (!substream->oss.oss)
-#endif
-		if (atomic_read(&substream->mmap_count))
-			return -EBADFD;
+	if (err)
+		goto unlock;
 
 	params->rmask = ~0U;
 	err = snd_pcm_hw_refine(substream, params);
@@ -733,14 +740,19 @@ static int snd_pcm_hw_params(struct snd_pcm_substream *substream,
 	if ((usecs = period_to_usecs(runtime)) >= 0)
 		pm_qos_add_request(&substream->latency_pm_qos_req,
 				   PM_QOS_CPU_DMA_LATENCY, usecs);
-	return 0;
+	err = 0;
  _error:
-	/* hardware might be unusable from this time,
-	   so we force application to retry to set
-	   the correct hardware parameter settings */
-	snd_pcm_set_state(substream, SNDRV_PCM_STATE_OPEN);
-	if (substream->ops->hw_free != NULL)
-		substream->ops->hw_free(substream);
+	if (err) {
+		/* hardware might be unusable from this time,
+		 * so we force application to retry to set
+		 * the correct hardware parameter settings
+		 */
+		snd_pcm_set_state(substream, SNDRV_PCM_STATE_OPEN);
+		if (substream->ops->hw_free != NULL)
+			substream->ops->hw_free(substream);
+	}
+ unlock:
+	mutex_unlock(&runtime->buffer_mutex);
 	return err;
 }
 
@@ -773,22 +785,27 @@ static int snd_pcm_hw_free(struct snd_pcm_substream *substream)
 	if (PCM_RUNTIME_CHECK(substream))
 		return -ENXIO;
 	runtime = substream->runtime;
+	mutex_lock(&runtime->buffer_mutex);
 	snd_pcm_stream_lock_irq(substream);
 	switch (runtime->status->state) {
 	case SNDRV_PCM_STATE_SETUP:
 	case SNDRV_PCM_STATE_PREPARED:
+		if (atomic_read(&substream->mmap_count))
+			result = -EBADFD;
 		break;
 	default:
-		snd_pcm_stream_unlock_irq(substream);
-		return -EBADFD;
+		result = -EBADFD;
+		break;
 	}
 	snd_pcm_stream_unlock_irq(substream);
-	if (atomic_read(&substream->mmap_count))
-		return -EBADFD;
+	if (result)
+		goto unlock;
 	if (substream->ops->hw_free)
 		result = substream->ops->hw_free(substream);
 	snd_pcm_set_state(substream, SNDRV_PCM_STATE_OPEN);
 	pm_qos_remove_request(&substream->latency_pm_qos_req);
+ unlock:
+	mutex_unlock(&runtime->buffer_mutex);
 	return result;
 }
 
-- 
2.36.0

