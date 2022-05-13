Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A656525CC3
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 10:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359590AbiEMIBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 04:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378015AbiEMIB3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 04:01:29 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BED71237CF
        for <stable@vger.kernel.org>; Fri, 13 May 2022 01:01:27 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24D7kSO3030554;
        Fri, 13 May 2022 01:00:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=+Vahm+pHURcSThrFckQF7RPEUQ/fHPUPgqN/Tq6ZJSQ=;
 b=O8Zm0F5+xcr0kFpzJBVi+tqAnDItXmLY2XJJPe8Wo92F9GCKBBtFbhRnNDtNIJNKUXlG
 MtYAuP4knnyagJNrznKpQMnC1jIkfVY2INEI3m8BfuKgrld3impsKIOX5yam9+nGa4ny
 3yP8bRnN3+PaMlXgNhatqE9zN22xz8162/IMq0PnSBBK1xeOuCFCwHsQT5GOEm/70QFM
 sMEkdR4Z0cisPX7XKKlN05I8Ux4/F1/8wQIAOjjTChuOJALSgmGDsh1xZme3LiD30Jbd
 BscmtKls1zl3vV/RZ+GLcqWHiFu5scnPxqQXCi9PlIrH2Iryq+HZWniyZxI2jA23COt3 zA== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fxde5kx1k-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 01:00:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HzSdSogcBswj7xCtaLsz+EOiO99BXXCGGuHvKCTbPSy2Zj1jLHxKGBjKczrGkQZCr8WEhsixXg9Gcj4qFaxRF1iNUGBEXWLc202sYyJNEPetgeo0MMey2CIz1IUw8sGTAwCLb1yBSldBmrMlpu4pIAQRHo+x3C7FDH8WRhIrpbLEjB1wlFn5BB1HxdEO/cizQXrdK1xaU/3JWYg7Pyo/Of4BrIAS3VfySdBOl0F59Yg5E8B9AuY7XE+CMq6RUa3jNKuSqfSUTcdfs/6PZKK+JG2lpaxuQxzRQheYcBXU78WP0j7xcCAYCeV/vhKMeieze3rUYH/g5Qf5bKla9HSPZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Vahm+pHURcSThrFckQF7RPEUQ/fHPUPgqN/Tq6ZJSQ=;
 b=h42fFQQxQ8He1YgZXW/8ivdqbnoYFdlPklF5X9qQjSnMQl4xK5szXJxYaTM8u0QTdZbhmwZs2Fg70A36FNsFWWTjtZYvXTK1qNelIdqeXLKCNkdeHEjobT5rXX3LTvo3rqcvgW50b5De+cFG+wTLRaaB1tdMuxlgPTe2f+W8S49zFt80x+HKZIFog8q2gIqBlJL58lU8jFYhsJXJMYp7iCdb0+wPVYzuJvpwZn2KZ9zCe0q1IeM+vnZX337vZU3N7rNp1UpAEgggTfHBYl73glnZdtlScYqslkxWafwlNfH4S4LozuAiI+ZER3kpYeL+d3cee1i9/Ixj04pB2MdRuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by BYAPR11MB3175.namprd11.prod.outlook.com (2603:10b6:a03:7c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Fri, 13 May
 2022 08:00:42 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::1d93:1511:5d6:9842]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::1d93:1511:5d6:9842%5]) with mapi id 15.20.5250.015; Fri, 13 May 2022
 08:00:42 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 3/5] ALSA: pcm: Fix races among concurrent prepare and hw_params/hw_free calls
Date:   Fri, 13 May 2022 11:00:16 +0300
Message-Id: <20220513080018.1302825-3-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: 06c554be-2621-424c-341d-08da34b6ad08
X-MS-TrafficTypeDiagnostic: BYAPR11MB3175:EE_
X-Microsoft-Antispam-PRVS: <BYAPR11MB3175358ED009DF2DBAA0289FFECA9@BYAPR11MB3175.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 51lZRlmojgxvvyx1gm9nLmy7Ktu/WSBFrbvlDlgtFnvPuyCg6kgPHPY+CdYUd6EQqEnZEHzBe0N4I1ttUV6HNz5kgVA4IWnIJ5Ke9tZ81gb8hleoaEg24UwjY1KvRkneCJfTu7PL4k2l1G0VEQ3BHEmc6vmSzPICm/4XsLUSIK+GmUgogN7LxN1+U/o4VZO+txtO4nyfegVrvmwJRm9etdCSdL++DygsuTNmUok43P26+zCIs0FJbKbu17jon2EiWbS2YOGVXTT7L9an6RHFXCUqU0iZ6rtTPVF18rK4fKanU38bWUnCtsr8VdG1/gROHBIICU+o2mLRu0zJ/G1Tb6cilj4tDRYMuxO2IE3FQiPFDfFeVHG639l5OCWl7tpBxxqVETfh+AfKElrLhPDH0yvo1N7d4pwcoAo3jTZyOMjin6/ko2HJJ+Zcld1J6aXyqwo5AbUqD4g5TjjG8kb3gry5gmAzH8XYVMkGlqRatn8YErflKXQQ7LXgcsSrX63QZO1vh6l6wKFv6ftIwGw+oc5qzis7fKcMuZsufh5HNpK+wDXBAUzN/czzHYiHdkNGhjU20Y2z5O3wuI2yuQowgmqcabG838W25kApg62j6+DsGZqiT4bhuFRqmpUagCePtvsARx68myugUmaF40e6bIvPmMPvWlC3dl9sKuMUbi73sjrXPQEycP8JBOEkUiAWekhqwuYrzKBO/Ck4nmpDryRteDbIDmY7qlpdhms9/vgxwaZYRLnaOIZ5Z4V9BlCEMI1Wuys+3LPTGvd6FXQj+ohsrUWyJimKujTPxAUIo2k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38350700002)(38100700002)(54906003)(2906002)(4326008)(83380400001)(8936002)(44832011)(5660300002)(66476007)(6916009)(66556008)(8676002)(316002)(36756003)(26005)(6512007)(6506007)(86362001)(2616005)(6486002)(966005)(508600001)(107886003)(186003)(1076003)(52116002)(6666004)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RdpGM72kflaLZNRBOMJsQgGRhXWG60wn/SuEAuc33Ajw4xDm9NCmkF6XXxoW?=
 =?us-ascii?Q?xM1ETT9608y5cdCuitZ6rABmho2osoYoUdj1o06SlIUiVGLjvfebLRN5Qcxj?=
 =?us-ascii?Q?4QCDqveH0kFm5TjWOErTcfxb4GOVEhkR7eGHkCYmf8S8eugnyhyiN+YkU/Yy?=
 =?us-ascii?Q?ryE+NLCvAT9QZXRIDjDzvufCljNE05GyH3QNBb1zIBxIPo+xezih2MDEnkh0?=
 =?us-ascii?Q?vbTK0LSnfvTMbreI8t5oOTkSnX0a+aZTRRI0jQCXh0MdL6uwwqcYeqd7SuJh?=
 =?us-ascii?Q?L3IvPwI7BeAY5phTKJ0AQ4vHpJZ40HG5t51OGvQX4xR10AFeANW0kW++EUkm?=
 =?us-ascii?Q?QdU2OQQJZDHADE1tSTjrgClLI5IeiZN8JZmYzY+iylfvNTspyj15Ct6A60s0?=
 =?us-ascii?Q?p36YzXQQ7STdd2cS6rlEOkGe/VkxSYD/VrCkEOEf3HjXlxQfZ4+mEaHATyAM?=
 =?us-ascii?Q?a/o7IW3x6pOKx/9Mxo5uPLUHka/zOqKOrYG94+G/9SOsW9O4gK/F3aNCDS3/?=
 =?us-ascii?Q?yi3SemXYk/Olus3DW9WyDtNae8YL73Q4taAc2Yxk5sp4NEMm63UCqh1YG4GN?=
 =?us-ascii?Q?rOkYV8fK+qbXIRD6RCreYAsGlERY96T2RaeJFBRmMJgKOKPYr++mOwwsg5ys?=
 =?us-ascii?Q?ULsiIre3fUpdARTH395/HnZl5wFE9Mv9PCGTPs8UhAXCgyxTpvKVzgdIqbKT?=
 =?us-ascii?Q?U7rj/Q9QZqy7MbKkf7uGxzaFAi2bl9iIqklrU/vFwb3XFxxDIE5rGRMYxojL?=
 =?us-ascii?Q?RSgvQbNWkCYwYsNVkYTUljGb9dzn9MwdLthE99E5kWZLpDi8UN9jO35J8kZ/?=
 =?us-ascii?Q?WimRJJMeJJaM5t6U1684UKTnvwVdzI/5KcfVptTILeDoepk4e8/0brCwQIq4?=
 =?us-ascii?Q?fKTnZzk5uGP5YZUyG4wvvqVsccT0QPvz1mcPP45aP673TY/dPvASmVfgVIg1?=
 =?us-ascii?Q?xKgqK/IAsW/OiPe+uQCdXfqiopnDLyI70B82W4Wxlxw1ydKaT+hdGLTUDDOA?=
 =?us-ascii?Q?femYYaWNg9YQs58jnKBEHacj19zmN2sKZ28viBlam6XvoelOOWKR46i6fcWk?=
 =?us-ascii?Q?eCBmXOQ/3Ul0I1/R8ozn0mTkCw+xRIt+Hk+01iezU2wVd/5MsMZ70Hi2tr5K?=
 =?us-ascii?Q?AzSeOEJb7g/ZUF6L1VfYP7QWXLizEpOodRVZOryULE0MKmaoLWs/Y/zDbipS?=
 =?us-ascii?Q?IRYsLNEIXvmKUTv6WabpRau+H40BK5FUD75Wlbxzrt2Z6CQsGbOaG7wdm6SB?=
 =?us-ascii?Q?+qjSvr3jL7o70gO/KusdfpdBPps/ZZCQ+FiHUSI6HPcgpdq5vP8QFgFndHT7?=
 =?us-ascii?Q?dn/9ho1gqFpnkt79JaiW41LUkWv7nwIz41HXg4PvBMqjsahJwCs/iUFyi2YE?=
 =?us-ascii?Q?O0z6gxGFUDX1XkdBydzQBWZr2/rmfh1XMuW+x2/W898u2wsSh85dfG4Jf6IT?=
 =?us-ascii?Q?cOM0v9DN4oBS0KzQe+Eq0d0z0BlOOb/fX3Gju/8VguX4Eknbg63ITOUVmmBp?=
 =?us-ascii?Q?XNm/Ohwfu5ij2lIL86Z8zJD2L927N69sAKjZ6VOFWu0D382OujDYdiJwhprn?=
 =?us-ascii?Q?22viNDDPR/mKd2lyhjxE0z3JP3VnrRrfNsyK4ngAnVd1vJjjyIn0fxAK1mnf?=
 =?us-ascii?Q?+bg7HErfkNWdHX1HatBuBJgrYujjud/uClWewvwmNhd/T+XVlDZo9hKZMDZh?=
 =?us-ascii?Q?n6dYrTrb5cgc+nT+KMtBCj7VfUJ5JHkQyBZYvggLgnwyUuEIK0WMMK6oU+AA?=
 =?us-ascii?Q?2H5KEtqlLRGYWkx+gvf2NTbsFQQB4mI=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06c554be-2621-424c-341d-08da34b6ad08
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2022 08:00:41.9284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /YtBBJQkki0auQK09C5vG08ePyi9xhNk1iXDaN1JZGBr6xVU3KNBJE/7CDRvKRSC36tM0j+2379azwq4olTN8Zoj3clRSm7elLb5Bb1YFtQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3175
X-Proofpoint-GUID: gJaARvf2YfExwdacvHOKt6zc_U4Rsm1g
X-Proofpoint-ORIG-GUID: gJaARvf2YfExwdacvHOKt6zc_U4Rsm1g
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-13_03,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 mlxscore=0 malwarescore=0 clxscore=1015 bulkscore=0
 mlxlogscore=896 suspectscore=0 adultscore=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205130034
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
[OP: backport to 4.19: adjusted context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 sound/core/pcm_native.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 2b46a2ebefe0..f2508f1f13a3 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -1078,15 +1078,17 @@ struct action_ops {
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
@@ -1114,18 +1116,18 @@ static int snd_pcm_action_group(const struct action_ops *ops,
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
@@ -1206,10 +1208,12 @@ static int snd_pcm_action_nonatomic(const struct action_ops *ops,
 	int res;
 
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

