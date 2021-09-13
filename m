Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13798409774
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 17:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234182AbhIMPhb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 11:37:31 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:62880 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241053AbhIMPh3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 11:37:29 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DFWk6u015226;
        Mon, 13 Sep 2021 08:35:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=34FZp8QcNQGX7/H2kt6f38q+ycMsfFnOwwBK+1woWH8=;
 b=EjM6oBGAHLVLqnCJrO/2OBbgUd6Ty7fYfZj2XFEZp7c7eHFNjPDXPZSVqOO1NfjskI/K
 yNE61dm2QeiTG4fPY0OiN+o09Q6fS6mLfUtrosnv7jcEBfy+yg9f+AaYNfDUYmGba4Rm
 ITB952caoTYXkIutyYnBKB0kslJGfhC5eR2MWCcmKGA628ePd2qsexjvHZ/BO66t1bKs
 4dLBJsi+p3+D3+MMSnkqERQL1usTEHSz7RbzuTtCq6Hr/llHRPFAcCHRdiKhC7DDLwmH
 DxkQLd9MOO6udsHygtk+Z+5mZXmqEfGmuFhNXcPt2rS/ItX8YZrnDggwpWlMN9m6QbPj Zw== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by mx0a-0064b401.pphosted.com with ESMTP id 3b1kfn0pky-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Sep 2021 08:35:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jxo+vSGwzCcB8DXukR4YvXWobxkL+Av++tLh/Nw2Hg0MyUcJgf5d6CYS8SjThbhF7qy+8+ltOGu7ovkYeaEC6KYXgxy4Og0C2KyzBlSXhoaRrDyUSZqMIT9YT6p+6LuF6G8fJXpDmXmXEmkji/FJMKm/uu1AmjmEHJ6vdUQaaiE/cAEtnkRWOoiJE5v+S+gXbZ1z3WVNc10gnSqhWRNpwssC10MSxUKcE9UTR7VjCdLx/AVi0w+IQsNx9sGDK71ehvIW0buOTHbcjz7hkucnJfGYxChnqXf2Qu1RM68UQObZsr0Y/KkVz2M4FDmsYMYdhFKzdzqRgDwPu6TiGWFoMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=34FZp8QcNQGX7/H2kt6f38q+ycMsfFnOwwBK+1woWH8=;
 b=c2yFMX9oA4UA0VlFWunlIL5luFgci99v0Jt0ky6PYlxCSeG/276kmfBWuEnPXbOTmxUDPsyfTJDJNH5427u2JBvTJRsPjX2i88iGkuPEcylJ+gbxDtHxihLdnU9i+K6fbjOXC1e7eXsQR8inBSzauhO97EfxtVGzE7BLSL7PqSvFv3crsSH9XwAuopvrSo8/kzdPW4Fn4/cQOxETyYoOe8aduRMrhrNEiWTfpeWMxthYRIFiYYw6NwRk/YqLLxLOjGEka7Y/ITk3PEKgKaurNQwH9KIf8dRbD96XnNS4yNc/65w/Tn13hUVOHnJFBw49X5TvZkB1yBqB10imN8a0RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM4PR11MB5549.namprd11.prod.outlook.com (2603:10b6:5:388::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Mon, 13 Sep
 2021 15:35:58 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::952a:bdc6:20c3:94cb]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::952a:bdc6:20c3:94cb%7]) with mapi id 15.20.4500.019; Mon, 13 Sep 2021
 15:35:58 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net
Subject: [PATCH 4.19 02/13] bpf: correct slot_type marking logic to allow more stack slot sharing
Date:   Mon, 13 Sep 2021 18:35:26 +0300
Message-Id: <20210913153537.2162465-3-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210913153537.2162465-1-ovidiu.panait@windriver.com>
References: <20210913153537.2162465-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR10CA0095.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::24) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR10CA0095.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:803:28::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 15:35:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 993ccacf-e8c3-42b5-385b-08d976cc2f08
X-MS-TrafficTypeDiagnostic: DM4PR11MB5549:
X-Microsoft-Antispam-PRVS: <DM4PR11MB5549BEF70217F6EC1CBE9DAEFED99@DM4PR11MB5549.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HFvRZH/SWjLQYUFewjwN9LHr08s1FZT8ClCltm43WzF30Y+oEUBiLMaPNh80aWIVjWclgZWhesYPOEkjDicO8J4SwXnKeDCdAPMEuf7FuSKhssefGV/LT4J9AAKRS9z8oKrQBpnkFNFr469JxZmO8PBdu0JC8WvKi7KDWEvaQYV7FbkY8Lci+ua+f57uKUgF0jDbm/x2O6E2zhR3MuKMAuLBLXjRkF04yTXRCj2/DC6w/YlunL5h8Yu8Zt4eF9duHoupxohO1DALDLbZ0BtRURSj9xwz8aj0kqz4AYYRotoF5DNX2+IdfO9meRacrtdod40NRgPLaDX+dpJAOvHvBkDOZ8iCzOD+FjbfhrNzI5JWtcy9hm4aodwfj7tJLZhSgC26zuhauj9h41MYkNVDYhcHzCCfsa5ZBXgxzyIRZ7zm2aEwbyzsd5Co1wINkynirHI4r0E+7kCQIV6AhQx+ZV4UCZddC2fHGnSSLGYGfqhXc++c83UD0A8F+s1RZ95R+TZ621BY3opbZN8AGYv3yEeYXju3CeOjmp5ot5cfA7HbuZItlC6Kh4C9VmGVb6D9rFfqzJIm/kkH8hwChmNCXLfKj0zm4bpeKEG9pka0lfqy5SGoZZRWNoMJX5uOeXtgUZLOA0pSo4yLIENVtAbY78l2ir87iF2Zkb0t/J8EuEg5VqPYVAtjsnwwaU+mdkJx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(39850400004)(136003)(376002)(478600001)(26005)(83380400001)(186003)(38350700002)(2616005)(8936002)(38100700002)(44832011)(52116002)(8676002)(6916009)(5660300002)(6506007)(956004)(86362001)(316002)(36756003)(2906002)(4326008)(1076003)(66946007)(6666004)(66476007)(66556008)(6512007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WnRydPktcREcWyIaai6HAoXDgwus7ACtnoiYX6rBjkc8C4yFq8IRus3lZ2H7?=
 =?us-ascii?Q?5MERkbmUh++31Dd5vVzjLAdtgSjuPj1wrGispTJB0evQSJKxuWvi9Dua+IHk?=
 =?us-ascii?Q?n0rjeQtS+nn3KDp7kY2V6J6d2Ynaanh2z0ZlYd2qUi8wt9axSAlRly84o1xo?=
 =?us-ascii?Q?vxSNcJdX9UFaVzrbtq+wc6cqBI0MC6COa1IKpIxk7gH1UyAdfKYpRa0VVxRj?=
 =?us-ascii?Q?MPVkw1gE2ErTJ+3FgpaUTF8uzGcUoY1zJL8B86396bM8pRsjjQJwHxVFPU2Q?=
 =?us-ascii?Q?JUBkiBH+hdDSJ0LAlMnqsPdl+wOblOaQRYVkyT+/iSl7y0UzkJDyj1T+gkmh?=
 =?us-ascii?Q?ldMH5vFe2mUuKHgTu66jU7Hc0tf/Eg0yCIdMuNjTKnLmW1EEyIv1P1A4LpsY?=
 =?us-ascii?Q?vH+nmPXrpeUbI9lkZm2P8fhb6xIMvfnwfrjDNzxgFCzIjbiWo1OkYlWbyU3C?=
 =?us-ascii?Q?Uzi1vwMQHVksDn4P3LGsxOBd2D7CnAJdob5TDdII9AFTwfP5Dz4q+buzBKoj?=
 =?us-ascii?Q?T8zI4LhSZvLpBcEPYMb2xKJCQ2ljPawi27dGoiwzXEGZcxTx4hy42UjKrF1m?=
 =?us-ascii?Q?rjrH3U93ZfWxzmH48nCa/98FbrLKZoGMcJtvdKriYOhbshumnUOeTSixtFWd?=
 =?us-ascii?Q?uJJgJEKdWSnlF82QTRpWTutLJ7VU1mGKN8ZUlFLLO0F2+QkRshbpePC0PUFM?=
 =?us-ascii?Q?P8pYdF7Xdcq8vL/P/CdymBAoQopAnbD/jNre5vXbwLAOTQ77spw+iZjQ64iS?=
 =?us-ascii?Q?xElrgcWchhtNtXcplBcStCj9oyN16Ul/58s9SLZ9nUymLd6EH94GDIUkxcJe?=
 =?us-ascii?Q?XVAaGNrDlfEmUgjm3YNZwOWTKY/eWJhUZ9+vz/BWdDUzHvgxY9tUidCcD6VL?=
 =?us-ascii?Q?ziEAGC0dMyFAmfsqdfwyotDGuf/BY+08t2aEzrXtNfqOPF2gxp0tgsdiY5i/?=
 =?us-ascii?Q?2T/1UgepXhHFaxWMPDPXqn2nZrTuq1CC+Sq0Mt9WTschGMMk3HTn82Lg0Vv8?=
 =?us-ascii?Q?zPE4JUfEIrA7euo2X+wBPSjrKcd3GEs9qkatJcHGQryjyCLUUdBv8gqqNj3o?=
 =?us-ascii?Q?s0FJaAQ5uMbXUJrOa2Qy0txIpl2e8/ARdPt6L9wXbmwlHSbmFlm8ZqszmA7R?=
 =?us-ascii?Q?dzmv+yVcQp8EK4+vqvuB4ORFBbuQ1KfwSmtxH+gb0nUBwmIgb9nRAVLLWucI?=
 =?us-ascii?Q?MZJqvJXPQSuGJn/HmrwapdcHhiOXMJVrgbtvNQFzZw/r6jAjHbTvI85s062i?=
 =?us-ascii?Q?aEhPrggLXK0t4Y2fUCZS9v7ITimMQCnRCYUiLn9eRoc8vl+QrEV1AIQjSWa3?=
 =?us-ascii?Q?YMz0zvKXQ1JWTR7F++yg8Dpt?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 993ccacf-e8c3-42b5-385b-08d976cc2f08
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 15:35:58.5463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6WgASMZiDEZriB1fGZZxrMZQV9c+4ekpgcYo+9rdIbOCZKwQAg9m/UlLVHOlu/0r850QvwrIDhK3X5B8WhyP5Z7Nj6+tQxN1EscFTotCEUE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5549
X-Proofpoint-ORIG-GUID: Gno-mZy5kEcAWbB85lDKklgdImDmfTzw
X-Proofpoint-GUID: Gno-mZy5kEcAWbB85lDKklgdImDmfTzw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-13_07,2021-09-09_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 impostorscore=0 clxscore=1015 phishscore=0 suspectscore=0
 adultscore=0 bulkscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109130103
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiong Wang <jiong.wang@netronome.com>

commit 0bae2d4d62d523f06ff1a8e88ce38b45400acd28 upstream.

Verifier is supposed to support sharing stack slot allocated to ptr with
SCALAR_VALUE for privileged program. However this doesn't happen for some
cases.

The reason is verifier is not clearing slot_type STACK_SPILL for all bytes,
it only clears part of them, while verifier is using:

  slot_type[0] == STACK_SPILL

as a convention to check one slot is ptr type.

So, the consequence of partial clearing slot_type is verifier could treat a
partially overridden ptr slot, which should now be a SCALAR_VALUE slot,
still as ptr slot, and rejects some valid programs.

Before this patch, test_xdp_noinline.o under bpf selftests, bpf_lxc.o and
bpf_netdev.o under Cilium bpf repo, when built with -mattr=+alu32 are
rejected due to this issue. After this patch, they all accepted.

There is no processed insn number change before and after this patch on
Cilium bpf programs.

Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
Reviewed-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
[OP: adjusted context for 4.19]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 kernel/bpf/verifier.c                       |  5 +++
 tools/testing/selftests/bpf/test_verifier.c | 34 +++++++++++++++++++--
 2 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index a5259ff30073..b6f008dcb30c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1039,6 +1039,10 @@ static int check_stack_write(struct bpf_verifier_env *env,
 
 		/* regular write of data into stack destroys any spilled ptr */
 		state->stack[spi].spilled_ptr.type = NOT_INIT;
+		/* Mark slots as STACK_MISC if they belonged to spilled ptr. */
+		if (state->stack[spi].slot_type[0] == STACK_SPILL)
+			for (i = 0; i < BPF_REG_SIZE; i++)
+				state->stack[spi].slot_type[i] = STACK_MISC;
 
 		/* only mark the slot as written if all 8 bytes were written
 		 * otherwise read propagation may incorrectly stop too soon
@@ -1056,6 +1060,7 @@ static int check_stack_write(struct bpf_verifier_env *env,
 		    register_is_null(&cur->regs[value_regno]))
 			type = STACK_ZERO;
 
+		/* Mark slots affected by this stack write. */
 		for (i = 0; i < size; i++)
 			state->stack[spi].slot_type[(slot - i) % BPF_REG_SIZE] =
 				type;
diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index c7d17781dbfe..6b9ed915c6b0 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -956,15 +956,45 @@ static struct bpf_test tests[] = {
 			BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_1, -8),
 			/* mess up with R1 pointer on stack */
 			BPF_ST_MEM(BPF_B, BPF_REG_10, -7, 0x23),
-			/* fill back into R0 should fail */
+			/* fill back into R0 is fine for priv.
+			 * R0 now becomes SCALAR_VALUE.
+			 */
 			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_10, -8),
+			/* Load from R0 should fail. */
+			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 8),
 			BPF_EXIT_INSN(),
 		},
 		.errstr_unpriv = "attempt to corrupt spilled",
-		.errstr = "corrupted spill",
+		.errstr = "R0 invalid mem access 'inv",
 		.result = REJECT,
 		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 	},
+	{
+		"check corrupted spill/fill, LSB",
+		.insns = {
+			BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_1, -8),
+			BPF_ST_MEM(BPF_H, BPF_REG_10, -8, 0xcafe),
+			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_10, -8),
+			BPF_EXIT_INSN(),
+		},
+		.errstr_unpriv = "attempt to corrupt spilled",
+		.result_unpriv = REJECT,
+		.result = ACCEPT,
+		.retval = POINTER_VALUE,
+	},
+	{
+		"check corrupted spill/fill, MSB",
+		.insns = {
+			BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_1, -8),
+			BPF_ST_MEM(BPF_W, BPF_REG_10, -4, 0x12345678),
+			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_10, -8),
+			BPF_EXIT_INSN(),
+		},
+		.errstr_unpriv = "attempt to corrupt spilled",
+		.result_unpriv = REJECT,
+		.result = ACCEPT,
+		.retval = POINTER_VALUE,
+	},
 	{
 		"invalid src register in STX",
 		.insns = {
-- 
2.25.1

