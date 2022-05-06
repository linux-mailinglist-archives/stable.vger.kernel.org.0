Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B34851D40B
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 11:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390356AbiEFJQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 05:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352619AbiEFJQW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 05:16:22 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561D7633A0
        for <stable@vger.kernel.org>; Fri,  6 May 2022 02:12:39 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2468iumC011524;
        Fri, 6 May 2022 02:12:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=s5nqvEcaI5xNCc2PqoLkAehM+R0ZsrS83tG0g27VLoA=;
 b=LXy/dsUy3CN+2XC+Qs6svi+h3P7cgLUhAhUtbdftuXnMit4csrjqmgW0JUSBjthx/ED0
 aHCLx6wGaf+hphAGE43BGumii6w1zbMMpEbIq9BeQN7PKxns/BVj9nvkGRfxFSPse4H8
 CxMk6Nzo8aNyOsc1vfO29ff7B16rrF5xtWIqm7F7zrbCysYdntbw/J2fXB+1nW09Yrp9
 uyaqvDYMvOYdCBZJdB75/ZeF5sTXnLaXFqZ4taeUBka10pJ2fAbfl9RTv58l2itvn1sa
 QlUGcurTfhkpVnXl631VORaFuAOiNOB0A1be5aMziYqz/JstNeVhqqpAFK+BM/6X26sW DA== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fs0d3cerd-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 02:12:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CKLFnMaTR9Wibz2naWkwkwHU7LbXL6bIm7R5JH29rYYcABJ6EsYAAhTJIaJXZOBgrd/N6IkOmEjKDqXNFevcBBX75jq7K/ELmj8VjcpatbTo1YoaaaU3J77arib9B4iA5a3xhqHNHCVTPqH5oJSKt9YjXqMlCLuzc3yKaI9eU+JAP/cfZz+UTURV+Ukl8zhO/3MQFoR14Q6OTvgy8VGiaG3292qIZhFffhdVnJ79lCwMn29yjtgzN+TVEqpr1Fl4XyEoWSMvp32HDyz1niECcP/wACgJM//2np5jwR2m2JMvM+t3W5KpafOB6Z71SWHJ5NVn+f9z4dE+E7CG5DT/CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s5nqvEcaI5xNCc2PqoLkAehM+R0ZsrS83tG0g27VLoA=;
 b=EdsL1yQaaOaITPB0tcXqeaswPkmmHl2f81+Xt+EoT/Ec8P7Wny291tgTUth69VL3MSFqTlEQNs4tDle1YNnAK0DaNK6i+dMqKN3slVRDNkMHHDBF200kK7xeFe8e2H3HJ8/0El25iGNMDFhrZJpmF5/stOnsAjergFaHK5UeFJzaVJLPJ/HtuWFOxOuLIPdLZDqizy/NjNzhy2N55OiVG0fWn6IHJeCC51v+wHYzgjKmezi17wPH9+srYe5VKFHpfxSmPx7iFa78L2araBKziLmOtwq0MkKPxnyTdIg0rg68XuGdP4wxLjppX20MvhU3dbJGQDBV6eltZ+oG4bh8Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB4444.namprd11.prod.outlook.com (2603:10b6:5:1de::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Fri, 6 May
 2022 09:12:22 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::806f:3f7a:c1be:ff34]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::806f:3f7a:c1be:ff34%8]) with mapi id 15.20.5206.027; Fri, 6 May 2022
 09:12:22 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     tiwai@suse.de, perex@perex.cz, kirin.say@gmail.com
Subject: [PATCH 5.4 2/5] ALSA: pcm: Fix races among concurrent read/write and buffer changes
Date:   Fri,  6 May 2022 12:10:10 +0300
Message-Id: <20220506091013.1746159-3-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: 18ed42a6-7dc7-4d66-372e-08da2f4087b7
X-MS-TrafficTypeDiagnostic: DM6PR11MB4444:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB44446509E3978CBDA6797ED7FEC59@DM6PR11MB4444.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XjJi6HSTnUDRDfFOXrBrMUk617fnPvJYAifjwCewnbQtyRJeK8HnrRsMbrPz/3vVldA9SiJjrV/vh65fP/BPMr9viQW5sXgvBSue5LqC5RQMNEQIp/OWrg2kiNaenlGBlkBgoCn779ljUo2Qspy/JgSATPOjMj5eF39kRMvm3GTp2HpxjOJ9da2ho6cffSjDoVqyp+lbjCOg6bfC6zPg5k2mxDh7esGljc9tNKpZUJYmeWKf1adVoHhJ2tMbwqYZbFNUF1yvKCEcHJerF6gQ5Eyd9lEoTqofV5ZiUDvFonHwBnURDHKHxLw1RPM799P6u+sB4uXXi++unQhmvcfAefrmrZex6AsHqPd3b04Wp+rW+LPVgtmhed3w33KiE9m3FpUwEREUdlR8bW+3ZqvOWVsDcKnTVAij7ESK9Vd1+GtPEVImOlRx099LHP/KHavlE+cb9LlUrCiMDLpPwXEeWYc5P9QFtZBK81z0hlbWnrE/NMUVNU2HzGBrpaA6RACFdCxcO0tauZAkHQCJvqH0z/XI/KWVUwTJEpgUqSbrgVbZ8kQYyEGNDHp0P1DoZTc1FTPYbBNfFtWxhr7ifwO1SSzOZBoT1PuGMTPi+FUIJA39gdNyLrhlwUgEpppPhvCSNPuvpKG5lb06MUwiq36UJ67YjyxvlbH3W4hI4XuWSCoq4tR8PVStGKrP9LQJVg8rhmFcTd2qYWHABPMRdgRl1whW8KXhph+83K4AuR3+lzTjeO9HUsdTStjPHrKrj8mJEtiLVfN2ePwJJmUXRIK3TcjeR+i2Zxz6ZFsIIplyVc0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(966005)(508600001)(6486002)(5660300002)(4326008)(8676002)(66946007)(66556008)(66476007)(8936002)(186003)(83380400001)(6916009)(6506007)(86362001)(316002)(2906002)(26005)(6512007)(1076003)(38100700002)(38350700002)(44832011)(52116002)(6666004)(36756003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OJGvLZ83xZYTk6N7lOd93jDljPMTpHEetgPjtnfscYBQ9dwKfsoIc5EQdnU6?=
 =?us-ascii?Q?qkWvgPrJOKyWwhE3UiKjSIWJZycTyXCmbgT1RiTuTqXIco2iZuzCdzPZBdAe?=
 =?us-ascii?Q?cRu6qyPxrk79A0LZEkXPtT6Mp2HatmQ6u+xg+sTj4OsdUVAwVRAg71eGo/Mf?=
 =?us-ascii?Q?o9fVj8F34jluV4U3ZYSQFZlLK1D8bTSVnG1JRveHQGBWXno7f2iUuv8OLlxu?=
 =?us-ascii?Q?5BZI1RUfghOLok20sku8wTr9fL51ObIZZOskSBSFI6kbjQhYyo5tY4KWpJkI?=
 =?us-ascii?Q?zZLjxbubWoZ6IBvNo9UTt/ElcctYkvAcjL4+hPTgcm3Wzfh67irQ3t6tMdXc?=
 =?us-ascii?Q?Tb0pwc2xKSAZa12kx8k4cH4oSbKOenj67F//Ge903pg7axRelFIL0eB68uPC?=
 =?us-ascii?Q?Uk2kGSfM9WgHcQC/myzu3DYs2f39IC0r0450wvSm+pGFFE3o4EsdDma7zbBO?=
 =?us-ascii?Q?6b6mUDb5WRZGhfukxVIgrqaH2DmzGWjHI6JbP+Sg6YwQzTvSElLVCDqEqpVZ?=
 =?us-ascii?Q?uyThi15de7JtRQ0Kkm0GKr0hJUPWE8JKTdLaqNVS4EtLZMU4Bu/wPHIRtQ5m?=
 =?us-ascii?Q?jKngNn4ulEGG9fpjGn4J+3rwyTixcLTzqOPSGsFwPRxS9R3ec0IX2CGA439o?=
 =?us-ascii?Q?bK/QlEtp0jVFqJ5k4TbXokYA96vtNJqGYqMZUVPE5ncFOewTnyn8ZGSbBQgi?=
 =?us-ascii?Q?ZHTwG+iCONHwKjceVrYJpAY60h7Vc3K2PQQCeiIL5fjWWb6nSE9H71kORjwQ?=
 =?us-ascii?Q?b5ymZxsjO8aSSoOkad+P9vKC4L6yz1C/owWXDO+IP9JIhvNg0O9h7pPKFc6z?=
 =?us-ascii?Q?Iwld6+tQPwUCByB4AWljtfSHexJ8ihk4K3nKqxLKZLnVF0br/4uJChdNDKs+?=
 =?us-ascii?Q?jOJVAngcUUHY5GoBllUrqSc0+qBCRdOjDmWT4gQEjj/S7g96lkAiaHKW9Ert?=
 =?us-ascii?Q?WX+ZmSTHpsEk1uiZN/aYQUSYqI1z4DbqLXFJScZUaFG2pj15VPcBC/NtWOaQ?=
 =?us-ascii?Q?oHb1catk43pR0NQKDrg9VQUrIwUud6rsaiNp65Ouw8QygWyTSPFtuGQQFTmv?=
 =?us-ascii?Q?8kcsUdmovEUUH3/H6kOpxEl4rh2KKcgyok7rN1FI/AEHIjr1/NvpUT7kd4Mj?=
 =?us-ascii?Q?KUSauQW3oatooYprv3GQspqwtvlZqQYvh/cj973cMYyFQL6HKk/ZE9+E0L4L?=
 =?us-ascii?Q?tnNa4uYmi1G+fEAGgKEvSL1gJK+4JzTA4JIfME96AS306lw7pscaeYev5snm?=
 =?us-ascii?Q?jOB94DjTQg+/b4/FRKXUtg23aDk/3cq+QD5aD1SA+NgRaWB6sXqhhJMJsnde?=
 =?us-ascii?Q?KWlmlEEKOxewvrIKB8Ddvx1jjxTH+uPGJRZ3F69H5sMhqyxwmOgxiPt1Es8H?=
 =?us-ascii?Q?vT9HiyUrrDwLpxDa5MoMErrXByHyKJxLAZt8Z/25DzYE5ebNrmK3XZ66ui82?=
 =?us-ascii?Q?vOIHTFkS81gSwXWp4cdusTDBLEB6ZRjgK9X8KN2nJry0NSJa4vGCl26NJANG?=
 =?us-ascii?Q?MS4tDtvbPj31cYojOBzNn1xKxm4HWS0/p6MwPfE7rGJNrXTIAbEA337DwpMb?=
 =?us-ascii?Q?lXn7wkHqKLpi1ucxU+ueEQ/RwsNXUhvA8riQnpEtgRDdS8jOuyBtnRxf0dNj?=
 =?us-ascii?Q?mKe22VZzeupya5bMY1zUcoqJS6HI4oLVlZvpS0Cna5ackBApZrvO12q+KS/f?=
 =?us-ascii?Q?CLAs6QhE1Vmeq9pdhQ4ATJ/c7JvuOdf9kXahQPv3PkvaMKJvNEVk126nYo/0?=
 =?us-ascii?Q?TgZcd+4xerHEj4xxX2QlQXLNQZClIeY=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18ed42a6-7dc7-4d66-372e-08da2f4087b7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2022 09:12:22.8940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MUGCYO1RJl6jWI9zQS+lVpj2Be8BpAvQlCPsxSFHZcYtP7Tqft3xSOJVFQsANRyDOHPaen4gQLQkAIuZs1tj+Vf7LhyfM1Hs7zofrevD5a0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4444
X-Proofpoint-GUID: tdOHlQ5iF3q5YVwxQR4mXMQ3KAiefSG6
X-Proofpoint-ORIG-GUID: tdOHlQ5iF3q5YVwxQR4mXMQ3KAiefSG6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-06_03,2022-05-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 suspectscore=0 lowpriorityscore=0 phishscore=0
 impostorscore=0 adultscore=0 mlxscore=0 mlxlogscore=948 spamscore=0
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

commit dca947d4d26dbf925a64a6cfb2ddbc035e831a3d upstream.

In the current PCM design, the read/write syscalls (as well as the
equivalent ioctls) are allowed before the PCM stream is running, that
is, at PCM PREPARED state.  Meanwhile, we also allow to re-issue
hw_params and hw_free ioctl calls at the PREPARED state that may
change or free the buffers, too.  The problem is that there is no
protection against those mix-ups.

This patch applies the previously introduced runtime->buffer_mutex to
the read/write operations so that the concurrent hw_params or hw_free
call can no longer interfere during the operation.  The mutex is
unlocked before scheduling, so we don't take it too long.

Cc: <stable@vger.kernel.org>
Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20220322170720.3529-3-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 sound/core/pcm_lib.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index fd300c3addde..fdb141e426ac 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1861,9 +1861,11 @@ static int wait_for_avail(struct snd_pcm_substream *substream,
 		if (avail >= runtime->twake)
 			break;
 		snd_pcm_stream_unlock_irq(substream);
+		mutex_unlock(&runtime->buffer_mutex);
 
 		tout = schedule_timeout(wait_time);
 
+		mutex_lock(&runtime->buffer_mutex);
 		snd_pcm_stream_lock_irq(substream);
 		set_current_state(TASK_INTERRUPTIBLE);
 		switch (runtime->status->state) {
@@ -2157,6 +2159,7 @@ snd_pcm_sframes_t __snd_pcm_lib_xfer(struct snd_pcm_substream *substream,
 
 	nonblock = !!(substream->f_flags & O_NONBLOCK);
 
+	mutex_lock(&runtime->buffer_mutex);
 	snd_pcm_stream_lock_irq(substream);
 	err = pcm_accessible_state(runtime);
 	if (err < 0)
@@ -2244,6 +2247,7 @@ snd_pcm_sframes_t __snd_pcm_lib_xfer(struct snd_pcm_substream *substream,
 	if (xfer > 0 && err >= 0)
 		snd_pcm_update_state(substream, runtime);
 	snd_pcm_stream_unlock_irq(substream);
+	mutex_unlock(&runtime->buffer_mutex);
 	return xfer > 0 ? (snd_pcm_sframes_t)xfer : err;
 }
 EXPORT_SYMBOL(__snd_pcm_lib_xfer);
-- 
2.36.0

