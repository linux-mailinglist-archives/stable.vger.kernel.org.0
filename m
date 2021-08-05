Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD80B3E18C9
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 17:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242606AbhHEPyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 11:54:44 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:2700 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242426AbhHEPyo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 11:54:44 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 175DgFAl013062;
        Thu, 5 Aug 2021 08:54:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=5drvWY7sfCjvwKY5eYRDnvjjF+gJDAGaepUGHICHw1Y=;
 b=ntOgFunx49wxs09dvDldL89Pg2iqtgCUuHirm0DHCQd3CLim3qN8g6sXOhV/RLQNI+6H
 U2w1R6FuQlq87PWBdrZ4X8vNdidPJT3jdXqHsxDjXEfSoTwzgr509a+nU8qHVyzN+U/9
 bhgXybp9hdQgUUjDezWl6TIZ+tuboiIp7pZw9Fcq9n0VZAr0kRvhpF7g3Q1OoAHOmoO/
 KiNflIxlNxEC6cbWSeFW621rg0qFS2rKEbNBYaZuEsTlLATNRweEUvPEbTUBVfYZWZHo
 YB0433C4IYzGrpy/CGd81wPizPHW9jP/UMBUJ4HOfg7w2F2Ilx8NvSKfS+orYpCgMibe tA== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by mx0a-0064b401.pphosted.com with ESMTP id 3a800vrrb8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Aug 2021 08:54:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g6Mk8dV20Ytlhw8ap9MPlB72FILPb18UaUEmLF6L2/DRrcK7Z3wNmcoKoWX3fnZdBJixUATQBokAHk5jeBmfICP27r9V7gnycaDkoEncbrnpykiya5N5QjSHI/RoETLa2u2wWoZhyTZNJg0Y+OrKz2mnsLJrUcxvr2uKl0R5IBFl64ejJPaGjBtB9MqQ/e9GwDwansUovk9OSDorsQIzm9pYW5L77zlHbytxeW1XSUDHpGlBFKOOdcf0C+3FKEobXR6d3KdnRDD0bnZEOnzTiE8oUEIwdgU9uoUr86QtbCR/0qRwVNWKD9ziYsNh4A1W+NME8C4f0l4oA6YyUeU1ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5drvWY7sfCjvwKY5eYRDnvjjF+gJDAGaepUGHICHw1Y=;
 b=Ke0/P5k7tfQU4yIaS4IMM1vs7Maaj7k1Qlx+8b4IVbg3tpzJKoyAGSKwfANxQBHMi3/a2ppc2Au1L6NR71jtK/Ov9bHIZ+Ls7iStkX1YYW3Sc1dP42t8l4+lvoFXRKt+6InUgslfUER7JZ7d9pn0DCeW3e2lhXfkbitHzOxko/QMM7E6faP/WjF3/i64kN/6HM/GaSwyxGX7iuVSPtWAMnSlZLG8p0GERSYCWSnKXmnNGTW/5oXr3KLo5Gdr6TpeGjpdMSXTb/ldhFSGXnKDb9iDk883If4acQT9xePpqHHmsrddbLG0AjwC6rPN4/7pNOPVGeAazxpfXTIU523ZxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM5PR11MB1722.namprd11.prod.outlook.com (2603:10b6:3:f::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4394.15; Thu, 5 Aug 2021 15:54:03 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3%7]) with mapi id 15.20.4394.017; Thu, 5 Aug 2021
 15:54:03 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        john.fastabend@gmail.com, benedict.schlueter@rub.de,
        piotras@gmail.com
Subject: [PATCH 5.4 1/6] bpf: Inherit expanded/patched seen count from old aux data
Date:   Thu,  5 Aug 2021 18:53:38 +0300
Message-Id: <20210805155343.3618696-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210805155343.3618696-1-ovidiu.panait@windriver.com>
References: <20210805155343.3618696-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0002.eurprd05.prod.outlook.com
 (2603:10a6:800:92::12) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR0501CA0002.eurprd05.prod.outlook.com (2603:10a6:800:92::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Thu, 5 Aug 2021 15:54:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cee0eb06-9f4e-4ea0-0cd7-08d958293f8e
X-MS-TrafficTypeDiagnostic: DM5PR11MB1722:
X-Microsoft-Antispam-PRVS: <DM5PR11MB17225ACABBCFFB98686D6445FEF29@DM5PR11MB1722.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:639;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JgI39XSHJ+TXmTpC64ZAYTh89cN2T3MFL4R/K/lw1YvzaeiwmClJewgoEbqn8+m4jFt7CvhbohapRzX/u5xu57rw7AXBnFjVuYzNbLKJAWf7T6l+zWFrarQmJZVjnGUCSKYIxQBCGDeEqXdLsMEOK1HoFGc28EY6puTfjQZ3RQzNZqt+EtRler8hSIHQ7Jmi0OaryBn0fM3mGZtIHktkNchv14inOsy0T0uZNFe0KYg0K4xWlEejxvFKpZiGBeTmJNb2xxmT5HP9zdwL1FNX3r7bBrrAJqaDPgO6sU7XpPk5ZHunnWoCXLnn6wGl/vzg/OrBTjhMgIvdPUh+Tp0gQzLPZ2pkLP3wXJB0eadkfC8oZtlDgdc0NPvwNZmsD96QFINkICv2GkZYpk30vyF1F2rMBMRQEf3uWOp2FVqR9A0C18C0LcGU0Dy1gh6IKaYWDQbRFnczXgGosdefoLlbLbJsacPg4u1x/1WaHoCIOV7/wLWUyNktz/HnGmdQrEjTckhkxbOEESljfc7HImsFQxWADKaUTlrqNTcOn4DmTL3KKmNNnr6Dbc+8xasLFXms3INzzpThardUC7/YJWhCM64KFJrSNWrXXbaMSpARD7C02WSrYUYlRmr1ncEJ4O3ISvoAYEbkcgybxHH1He2AsyaQaBCdr1ONcJRYjuh4QQkrCyQGLtEpUJoroCvjW48SP9GRlkax6pfkhBsvnMLa5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(376002)(366004)(346002)(136003)(478600001)(6506007)(6486002)(956004)(36756003)(2616005)(186003)(38100700002)(1076003)(8676002)(5660300002)(38350700002)(316002)(6512007)(8936002)(6666004)(2906002)(52116002)(83380400001)(66946007)(44832011)(26005)(4326008)(6916009)(66476007)(66556008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lWsmXEZyKXCgZa2k1NMsnUNsr1uBWlL70A0BKQ37KrE4t0N5cjbTlW+t+bv4?=
 =?us-ascii?Q?KG58/rOxWiv9HH/TqZD1pblpv0HiH+bnsEtUZlIIKA5H67uMAALlodgnBpFH?=
 =?us-ascii?Q?giL2pxVuW/GsezwMaarkTZI1xFiNLymgte/cPNSS+MPZhtlSAKMNXhv7WXP5?=
 =?us-ascii?Q?b82vzvRp5Cpqav9Tzu7Jvzp2YtjvMlipkc7L3u2rUMU+9N2i2HzcLv5wRmwv?=
 =?us-ascii?Q?F1oyzSqansapp6ZgcbADl0h4a8Ya1kmpvhNSrS5rDFDzU0twSzFILQNfCrhB?=
 =?us-ascii?Q?wgftiN2o00Roc2JQQg5ZTuHvFmOCZDnpAG8bQ36Z0BZjVDA9sW8JccGYxpRI?=
 =?us-ascii?Q?lhnd8iZBVW6I5xN2YqKZZArLqmtDlnvv4DXk89RBMdxwpK3/9FZYdr5MUMzY?=
 =?us-ascii?Q?PkZsxujFdg1sbq2h7z88dHnLIc+tAAVGJ/Xkej+P39UJxjA7rGT1urzESn1K?=
 =?us-ascii?Q?wDnE1nl4NVlU2uenKtxvxGsP4GgpIB3C4ZacolWfbxCJu5pCWrUWUS8eu5iK?=
 =?us-ascii?Q?sREMgcyDRcOkXhWpVdffssBLi+PWQShNO9Ly8qHPeHAMvOonxYyiHsu5tPBw?=
 =?us-ascii?Q?EaI21VZuc/j6V6HvJ8W1NINyLZKxgNMltnQfxkEeG7CZ7nbm6BdIR23VCdTY?=
 =?us-ascii?Q?fUyC1/HFvns9jAdnoSAyN0sgUkhjCDSkjmnG7bkbFiTSl438BDwYW24xqYPJ?=
 =?us-ascii?Q?ilRSPqlz9ixbY7NYo+AG59Fva09RG1F6CgAIMo+Lx2FvFRS0EiPoEWMLxLzP?=
 =?us-ascii?Q?bxPZcNlOhN3tbJLOoyPZZ/jNaosMZymlhAAlvtiAnqhIUtktBCweA75RoQVx?=
 =?us-ascii?Q?Qf286eo5IdGX4Sx+1qqESn3117lqFyItwezrHnq3o9Zrk3g8rNq910t9kAyx?=
 =?us-ascii?Q?WzsqoD1N2mFqsW4r0wVWtVd3vO5298Mw88MFY46DItwVMZXywMP/+IXC67dt?=
 =?us-ascii?Q?2GfL2cdfUxxj2EdPpGtYDp/1xYein1h//4EKnhZ8DUZQUum4Sy+EBBxL+jNv?=
 =?us-ascii?Q?XxmGY/vje2Ic4y2gIgdicfC5lwx45FBS1vAjKo0HK7Y/zTuuPNghgI1yJjJv?=
 =?us-ascii?Q?y9sLdH+QPelb2rt6NAk5fnDRfVgO63bdAwoRtpUcPQ6jmm2fpVcUXnqIffb/?=
 =?us-ascii?Q?95ZJL6lX7CfuVYc9pbGzYFiL7pQ7vvmKYPgcIetYbMuEn01HH57MpN0DqnoB?=
 =?us-ascii?Q?cR8DpFzX0FYy9Xq+eJ1/y5SKAHpDmPLVE3mjQ9Mo2kB+vuytD2mF5CcGQqgh?=
 =?us-ascii?Q?UdQhtoZxIVQi+bG62nS5dyo+HbMang2klYikH1wX+V5JQC73VCR4b2em7GHs?=
 =?us-ascii?Q?4lcZnSCRJI2OuTfAX3ETUPwF?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cee0eb06-9f4e-4ea0-0cd7-08d958293f8e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2021 15:54:03.4147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Ot+RYZsXTgQSfNIXaG+mFvF2CrBaTXHf90YoQ19j6QySt1MQ7e6pWYz4rVDMjuYzEn9R2EeW7fNvKmxv+1faNQTdqmtZSSK5Ihkh/kJYtE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1722
X-Proofpoint-ORIG-GUID: Xi_H4Ure9pIAXHXWu4pesyJef9elmUrK
X-Proofpoint-GUID: Xi_H4Ure9pIAXHXWu4pesyJef9elmUrK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-05_05,2021-08-05_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=861
 spamscore=0 mlxscore=0 clxscore=1015 phishscore=0 lowpriorityscore=0
 adultscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108050097
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit d203b0fd863a2261e5d00b97f3d060c4c2a6db71 upstream

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
[OP: declare old_data as bool instead of u32 (struct bpf_insn_aux_data.seen
     is bool in 5.4)]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 kernel/bpf/verifier.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index aefd94794796..526e52f45ab3 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8304,6 +8304,7 @@ static int adjust_insn_aux_data(struct bpf_verifier_env *env,
 {
 	struct bpf_insn_aux_data *new_data, *old_data = env->insn_aux_data;
 	struct bpf_insn *insn = new_prog->insnsi;
+	bool old_seen = old_data[off].seen;
 	u32 prog_len;
 	int i;
 
@@ -8324,7 +8325,8 @@ static int adjust_insn_aux_data(struct bpf_verifier_env *env,
 	memcpy(new_data + off + cnt - 1, old_data + off,
 	       sizeof(struct bpf_insn_aux_data) * (prog_len - off - cnt + 1));
 	for (i = off; i < off + cnt - 1; i++) {
-		new_data[i].seen = true;
+		/* Expand insni[off]'s seen count to the patched range. */
+		new_data[i].seen = old_seen;
 		new_data[i].zext_dst = insn_has_def32(env, insn + i);
 	}
 	env->insn_aux_data = new_data;
-- 
2.25.1

