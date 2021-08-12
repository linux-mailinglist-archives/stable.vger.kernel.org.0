Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF8583EA8F9
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 19:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234075AbhHLRBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Aug 2021 13:01:24 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:28498 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234029AbhHLRBX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Aug 2021 13:01:23 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17CDv2US030865;
        Thu, 12 Aug 2021 10:00:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=HW3zyIzMBk8BnfH2Xt61qEbuIbIwq/12zyUjlDA6dXM=;
 b=hLGCYsVbvRj5MXJ9P7989k3BR/22kHxLH2dwheVSxwTXkqr6bSZVOz5PppWSQQtcCUfT
 jEGi3eGw86L8nZ1zjzac5niZIVcUvRsgQfNHBM9AnjvBJsIKTQ4PAvjBLxRhyhiZ+INV
 I3C+A+tEf4lWd1f/4RORm+8aKMBvH5Lxl115MusCFtYQVJYVXGllSQxzgGhE9+K2hwvg
 Xhzr3Z5fXy/QKL01lzLhlqooNtROWbEndZFiprTNTEnh6h5R4KORMEiAPWDu2y6cEJgc
 dv+uTpX08s5H19PUyWg+JjXPTWdKOlg+Y/YqlnBnYZh0W3WdmNo8Scc3Ifhu37EWVD+r xA== 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2170.outbound.protection.outlook.com [104.47.73.170])
        by mx0a-0064b401.pphosted.com with ESMTP id 3ad4wug5b3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Aug 2021 10:00:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PSPKqWsEKufFKUgvk8xOWbwsKyn0FIjKQQTmcrx1yN647iTGQHHdR0LMR6du1TFF5FzPLYnBU6TnpysO8wgsmxHWs6neAKnOYdMVcIOJ3Ox2M9ma1jp4A5bSv3B/onvD+VyBpD7BzyN7f3gf7ikYbTWNZkxOyV5r3r79o9wIrJkt8nvag1zNhq8d4ecCXF/l4QGwu0OuC8hco/2MxDGVWxqmb/YcX60mq5jeJaPDlQdre+Nwhr5WASd2sKeuXLbhq4UvzgBjcN9zfSy/TcRiZ4Q6P5cUnJgpBJEjY8P/MlBZyjDUkZvETw73zTlE0jxnPDVGgHMERupj/ReUn/zv3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HW3zyIzMBk8BnfH2Xt61qEbuIbIwq/12zyUjlDA6dXM=;
 b=VPaI/tmQw3hme2tau6+qzGb/IBZ+zQFok//F/jnSEv36o43zxfTH8ByfWNZtDqcddW5jTremsgK/FKZlqv9dVn/l1dOcoqNjFaYwiCWkOqL5+0TAnOkBFplMkoEM5BDRkoG5AtwzRdwtGZF3AhzEdQAxGEm9+BO6sn8D13tHA4iDM4ymF+rgico2QUKbzemK5r4AxYH63hyWqJ58KqfyZXlSoBLw7HFSlW89kUgE+DsJPwuGDWrLU3V+0yCUUJYQf4BKz/pWdohh+wmSv0/RKY3g2ZGSKUw4FuB3b6E/n9Yw5tjuEdcZw4IEE3oYYff7037XLU+uFEt9vmLnItNxBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM4PR11MB5549.namprd11.prod.outlook.com (2603:10b6:5:388::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Thu, 12 Aug
 2021 17:00:57 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3%9]) with mapi id 15.20.4415.018; Thu, 12 Aug 2021
 17:00:57 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org
Subject: [PATCH 4.19 1/4] bpf: Inherit expanded/patched seen count from old aux data
Date:   Thu, 12 Aug 2021 20:00:34 +0300
Message-Id: <20210812170037.2370387-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210812170037.2370387-1-ovidiu.panait@windriver.com>
References: <20210812170037.2370387-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0251.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::18) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR07CA0251.eurprd07.prod.outlook.com (2603:10a6:803:b4::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.9 via Frontend Transport; Thu, 12 Aug 2021 17:00:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2799a577-291c-48db-0d6a-08d95db2c0ca
X-MS-TrafficTypeDiagnostic: DM4PR11MB5549:
X-Microsoft-Antispam-PRVS: <DM4PR11MB5549CAC79AE7581A06D92434FEF99@DM4PR11MB5549.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:843;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f8Ox89vY7SELtYNHb5HfJsBJlYCRMnmXGhumQg7yY3XXKUIOJfUuM5JkczRNvervPcvfqy+rNvFIFLeTJsFTRDiOYawEoAMGZ6vUiOZT8jJtY3uQWNcniOeLkzETMEAOxRY4UVWUDO4frkyRiLiK+o9iANpRL0eE33hxGlLrmR+cZaGeS6N0ciwJQnjM4uPWplqP7dcQEhGB7/joXCefcmIpOqOV5g6vtUQ/hUc+5662YfsWPF6uR70l1a32ObDodCm6mcST1wZgXJOI+rOW/WdP7gLNDyHTL+psl8SXrm3TB8ux0MG9Xm8yuYLv15qQHBXHzXRevaInNogBj8i2Nee2VXIGkprjZ2s///FstfEgG9xoKiNT3LujSuO18FtBcUph0FLkp8ZcJ6Fz+wGc0X7ZjDub6jtsWjJYGGpwfdtM9ye/AkAm4a8bSuA6nt6owyMkzgkE+ISV3RY5HdGdd2y6JiklLJUGme4Zk7qbfLit9xTDn749zxlgpTvPsV12kN7GrEPDPrTaOn9mQmnravTaT7SDzOltV8fn845d3NpqnzwSOqyPg+IFdVDyVqJ0mQp1rglW+ZxAMgbr1fI1ZKb3jDj4RwILI45mflbxvt889LXmkhOoPw9I0w82N4EOgDxCiRT+rbCym5fi5+uPv0cI7fDozkX22c3FtnahGyKApCzpiIoBuB8hwy7+zJlHHaDin8752SSe8kQyuuxdHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39850400004)(396003)(346002)(366004)(136003)(6666004)(478600001)(66476007)(186003)(52116002)(66556008)(26005)(5660300002)(2906002)(2616005)(44832011)(956004)(6486002)(66946007)(6512007)(36756003)(450100002)(8936002)(6916009)(4326008)(38100700002)(38350700002)(86362001)(1076003)(6506007)(8676002)(83380400001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YIke26tV06QfGA4ez5+EBGcybkOpzfYtj2nBGfXZcgWzxW06EbEVam5nGIU4?=
 =?us-ascii?Q?Qv9fOI8L7sK2mPZ6b9XAWkzJVh9Pj39ELe7cxm3AtzMviMMN8HHofF7h1zDr?=
 =?us-ascii?Q?jvAr35hs0MhB8qx9MM/N9tkoypc48X8zMKTe8DGp6m04WttsDtheNJdwgGYr?=
 =?us-ascii?Q?j018f7T4WrFXj9SiAOIyq1z7xWhJ55NDuTWxAGX/7ev2AMdasq/YHqPNX+pE?=
 =?us-ascii?Q?7wKa2j6rg3/uWeDFyE15fthhFW9SKWmMiQuv5Luomzy0UUT1eKlY7FGe5wO8?=
 =?us-ascii?Q?WSfGQpmUzZmMfWTKBBPp2SOToS74d7timH2+sGnEwXOthx4MaQ1AhOzGgZU1?=
 =?us-ascii?Q?BrVbuB94w4bkfJ0rXPa0Gdt+b1BmvBR+1vTl7cJpJV5VuV5Z8IDIz8xOT1CO?=
 =?us-ascii?Q?lZ21CpOtL2s1ecwI4mEcUbtKA6omvbScSezrZfcfeCBzK/xry25OSr6ztNQ6?=
 =?us-ascii?Q?S1wVGEnSb2Zp02dnlTvTIpq5iP4Ic1vymUUGInT/FNRqwodBteMpAcz/MGdX?=
 =?us-ascii?Q?kZoZQXPWtTLHBKQQa7LheSMf2vtCc7mJvedEreCwfs+a8KI8HmP2LhvpHQWv?=
 =?us-ascii?Q?AbWEYo+jeNq3DxKl0T9cYv7qC1LjTuNCGRsfP2zP7YrEckdMAGWuiSr+wt+S?=
 =?us-ascii?Q?ZgLlpgq4YU6U0SNfXkvJsxQEWdQBSCLFynLsny837N7efVQxxY7gO7PE1DtW?=
 =?us-ascii?Q?iprqe2jXhnju8xIqIa++p2dWBuVuSwpjUFaq0J2nzaBhnYOupsT/abtr/gXv?=
 =?us-ascii?Q?cNUQevuSzmWXRr6rhRwxPtK53QcGPa0EkU+EregznDnT5eJr3sRum0yzBwPO?=
 =?us-ascii?Q?kdtxdmTSpx4QnoZMEqFBPJieNiBLuaBy48+HMGLu/0uUbxoPq16N/vLXY41n?=
 =?us-ascii?Q?U/W/BIzhu/LGehOBi+RJ5AN1cVSdObsxBIc9WZcPIrH1wuT6yhW2tlPLohVu?=
 =?us-ascii?Q?hIyfZm1OoSAoX8yKzRB/NmwKx6uBWbMAHkOCVPRkY1oT3EgPFi/qjq0y9KHm?=
 =?us-ascii?Q?Kd1wuLbkRdW88Ff1VHo5Pz94gh6klhw0gJBJVDs3GTcZYsFALvMkxf+Jo9Lt?=
 =?us-ascii?Q?QfUcc6Di2N9PsJ/3YCM1W0+L6grWlqpc8NK53rSlpKcvIQhlTUOZcQqmkCJ3?=
 =?us-ascii?Q?BkeEYxNHjPSnfjVYCab+nZFMgxRGVHCQIgFEe9O1wyDFPQHZIMCgiCwc/kCt?=
 =?us-ascii?Q?HTxQjybLWc9s2ADpnrRdy1Ao7J8TvVThKl4qmYQEcLJ1anEAK8IO4MpvJpdJ?=
 =?us-ascii?Q?xiegUjKDFvx9BnKAT/JzFRK1TlPIMYm/eeNDQRonQG9W3ZHt85Gxe/njk2wt?=
 =?us-ascii?Q?Fl0Jm2NmpzSwLpBKrVre+PFo?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2799a577-291c-48db-0d6a-08d95db2c0ca
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2021 17:00:57.1118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TydoAuGZSawoUTns4eeAhT68OXA/sO/0pi0c7q9S6e3BK+QsVqeiAip+iWR25Zu9l3OISaU0sb90r4EFQM2mdxJaQJZteAdrMsCNzaBdEnI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5549
X-Proofpoint-ORIG-GUID: Jt1CUo5zClFmh-ujh5zVVIIskqbVZ6ZX
X-Proofpoint-GUID: Jt1CUo5zClFmh-ujh5zVVIIskqbVZ6ZX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-12_05,2021-08-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108120111
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit d203b0fd863a2261e5d00b97f3d060c4c2a6db71 upstream.

Instead of relying on current env->pass_cnt, use the seen count from the
old aux data in adjust_insn_aux_data(), and expand it to the new range of
patched instructions. This change is valid given we always expand 1:n
with n>=1, so what applies to the old/original instruction needs to apply
for the replacement as well.

Not relying on env->pass_cnt is a prerequisite for a later change where we
want to avoid marking an instruction seen when verified under speculative
execution path.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Reviewed-by: Benedict Schlueter <benedict.schlueter@rub.de>
Reviewed-by: Piotr Krysiuk <piotras@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
[OP: - declare old_data as bool instead of u32 (struct bpf_insn_aux_data.seen
     is bool in 5.4)
     - adjusted context for 4.19]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 kernel/bpf/verifier.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 4ce032c4acd0..70cadee591f3 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5690,6 +5690,7 @@ static int adjust_insn_aux_data(struct bpf_verifier_env *env, u32 prog_len,
 				u32 off, u32 cnt)
 {
 	struct bpf_insn_aux_data *new_data, *old_data = env->insn_aux_data;
+	bool old_seen = old_data[off].seen;
 	int i;
 
 	if (cnt == 1)
@@ -5701,8 +5702,10 @@ static int adjust_insn_aux_data(struct bpf_verifier_env *env, u32 prog_len,
 	memcpy(new_data, old_data, sizeof(struct bpf_insn_aux_data) * off);
 	memcpy(new_data + off + cnt - 1, old_data + off,
 	       sizeof(struct bpf_insn_aux_data) * (prog_len - off - cnt + 1));
-	for (i = off; i < off + cnt - 1; i++)
-		new_data[i].seen = true;
+	for (i = off; i < off + cnt - 1; i++) {
+		/* Expand insni[off]'s seen count to the patched range. */
+		new_data[i].seen = old_seen;
+	}
 	env->insn_aux_data = new_data;
 	vfree(old_data);
 	return 0;
-- 
2.25.1

