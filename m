Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51D76588EEC
	for <lists+stable@lfdr.de>; Wed,  3 Aug 2022 16:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235945AbiHCOum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Aug 2022 10:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236279AbiHCOui (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Aug 2022 10:50:38 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE28DF
        for <stable@vger.kernel.org>; Wed,  3 Aug 2022 07:50:37 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 273AwRKJ012049;
        Wed, 3 Aug 2022 14:50:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=HNqJPPQJXVc/m1DpgxtXJwDejAJEW1voi/GkKnIsrDA=;
 b=cZtGvI6neHLsepnySEzqFYoRnXdGNMGCtX3VZlhuGcU2e9eAVrBCZehK6HPX0A4PW9fF
 RjTlvnlceoKNYn+yIdVd/kBZTuUX4i7an2e0aoO/OruThycrTg8SGABdEzXQ/eVbyT8K
 ngsrz7Zla8q7mS+xgcv2vSjfEcOhKfTp6aEcz7tbZzWGqKP0JhAoj878CdK3DrNnPWJJ
 MQuEd8Hl+TIMzxJ0nVdMKj/Oz0+H88tV5AbCFPCgCJ75ogkenBQJjblRLlxIp7f0oQ/M
 aF1exkf9yZ8YkCsg0+z+TkZj1sp+Ijr5iez0cIZH3hXB+ny9i6diC+NUXd4in7wY7mRT cw== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3hqdbvrhkt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 14:50:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Blk9DDA7eYPuGqyUFLYhJsCj0vh2E6hP1S1jYYaBulSEw949geEAAwpJeAq8wQe1p61mtzNROgtX5+EmjelpYSSQEL7D8FaY8ofD9EPSzrXvCcjxJb5w7XZfxqoafZ6M27NycWA2XTm32b7GNrNlPRw921YwyJVx0OGB0dL8QVr5v75BnxkqeSSHjdgBFAWG4Q1VGvufovgggQ4Hs8ySisomhB9ZIOE5sxaxIhg27zsmpLFB2tonDAu9KIKLaOEDzUbj6HiFDXPSeLKAlwm1uyXvTrOy7bt9Bnl40CwhK0S77p5qc0B1+xTACm+Tb7KITnQqBf5xLLnVOkeUMZSO0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HNqJPPQJXVc/m1DpgxtXJwDejAJEW1voi/GkKnIsrDA=;
 b=kJ9BrmeFIUbTyx2utU6rv90aEcOB4Q6Yd7kLyOKNJZ8eXP8qabH4oPtpGKmH+xTkzDkwjKWPT59ysTcoWn/GHfYdiOUUwjDyHCDCysJ2nAG+HQxy6TMXo/CiqbkzT2AoTXpq1MFdQNWwwiPHkR6a2wjO8F/osODmyk5qHrudzrEd7dZJW6f9PMpyddEE7fQVTjqddjTczzegwQym72Il9clCzCHLox3TG3oXQMOdVy9GDSO4btlro8EopQXTdNCYqaK7amdNRburnmKvn/CEzy5kRz0p+rztRZmAFvAPGDeGHrgKLod5qtm5kYkZnBPYBA8GAHe084cmIZLKnF3ItA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by CH0PR11MB5505.namprd11.prod.outlook.com (2603:10b6:610:d4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Wed, 3 Aug
 2022 14:50:24 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::e500:5c9f:fb41:287b]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::e500:5c9f:fb41:287b%9]) with mapi id 15.20.5482.016; Wed, 3 Aug 2022
 14:50:23 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.4 2/5] selftests/bpf: Extend verifier and bpf_sock tests for dst_port loads
Date:   Wed,  3 Aug 2022 17:50:02 +0300
Message-Id: <20220803145005.2385039-3-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220803145005.2385039-1-ovidiu.panait@windriver.com>
References: <20220803145005.2385039-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0250.eurprd08.prod.outlook.com
 (2603:10a6:803:dc::23) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29f486bf-ed2e-4af6-9224-08da755f7ec4
X-MS-TrafficTypeDiagnostic: CH0PR11MB5505:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7RN2hwCHVDuWS+9G3ddP6MeXMcNordOOJV8FMctC0m6w8f2IQ0GekDhqR2ym1haNdXBO7JBGEQcnN71aDEXY1a19on8VPZJnpRWeAXt7XKDjYkVbj9xgR+Bp6qB4L3kYacTedEO+JjVWmyiTWhrpeX/HOqxycWATEr2S4I+mtclrXT6RvLyXfKc2n16NcX9hyuXUVf6/tzKVf0sEXlrl4IAudM7nDZ0dvG0umeJqtOtttQvRUcceFoINoXPM7ThG3qUGgiz5DzhRqc13Zack0X5pPtzOi+1PkIdGTJkA4yJjb/7csMZwu9WALPS3fnQ7I33QcoMVoBlRq8nYzWruln3eyBGFR60Ut1rYtvE3jv7vOE8RKzkBoUitndks/yNmZEveHgBtOhOZLEucTjOejx8TPT3xChKJRhQrxNehPxExr8kOCPg1f/BTz7G8MtapuvIUWr/joTKydH82f/bc8dqUp3u4XAl6towGqTBuOj0RMeBM5fUvzROzmyP0EoVkjcqYIrTZWSaDiQ0XXYyVNzrzmuVLQ3elSO2uGuKzOTlz9H6eRHvJxuT5QPrBm7hW3qJLXgzYvGlt2FNmY0oliYP7Bn4ydIplwSfIefxPs8bk5mm/jZa39xjMHDDLbuC5s6qVEUvdEoaMUo5cU7utFELaP3m8pCXmtKDJUDOofb5/YM/8Iw2NK9BXjWaTn4uzCmicqk1in4r17PGz8HtEVf7mCRxMLG+u2XLG6m/FWb4aWaIo2Tt40/y6Ia9bsHcVuhGIjxFPxAnqPeS8RXtvc6hxIjWQaIf4JIPNsFGCiZV5LiT8tpI6cohVu6inWms/yOMewOzesgFpIi3mpdsseA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39850400004)(376002)(346002)(396003)(366004)(107886003)(2616005)(1076003)(2906002)(6666004)(83380400001)(186003)(5660300002)(36756003)(44832011)(6506007)(52116002)(41300700001)(6512007)(26005)(86362001)(966005)(6486002)(478600001)(54906003)(6916009)(316002)(38350700002)(38100700002)(4326008)(66476007)(8936002)(8676002)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2eqw5yiS+V7cEOR4K8TESA0U/EibHdHPflMS5a+Rv6uxoiZWLFslDbda2BUs?=
 =?us-ascii?Q?ytehRixcnLUCOAT0ZPrJwdXIh8XKxWscU4o2H7HuYEeJAhapcUerGMfnH5hE?=
 =?us-ascii?Q?9R9mqZAJ8CrB0oetiGMmO8i8s4DMaDPFdeznJ90cGYzcb5GAuaHOVZmbUqLk?=
 =?us-ascii?Q?ejlCH+Hcl4a0+JWEMVcm3yKh2o9JCM1VbwBIN1b3KogQhDYEEXddTj0bNGy5?=
 =?us-ascii?Q?MPd+et/YarofrUCJm9IkFWWHLXX6ZQ3fcNWeVEwmxS0LeQpzDxRFG23D5sBx?=
 =?us-ascii?Q?BPplM2gREctfwvvcr2lEaFMiwgjbQQLCG9FDLHlVrkibnh3wLTC7xs34kUWl?=
 =?us-ascii?Q?AFNfQykQSFye3CjrPwV8YDTzKXpRf9gQTtnArqTKMS+RegnKpCXgXqjAgzN4?=
 =?us-ascii?Q?HtPUs/BpEQ297Sa6VkJaJi2LqxSrSLKSyQblcQsj1O40XcDOTfILz/ezvQon?=
 =?us-ascii?Q?dJDqEowcHzzKhtVg2DusQjeUEfjUdiBe3nAa67QiPgq0P111HaP30dq+WXUi?=
 =?us-ascii?Q?meu0orZTX1Glj7Z8+UnAosq/2EHSxhwm+pGXM+S9JrlsIe8K5avZtiUT1jiV?=
 =?us-ascii?Q?NxruPAsiUgUrYh4oEccCoLAD5i5XDAmd0CUgmQ2GvHG0XaXch5eBa9x932NF?=
 =?us-ascii?Q?ukncLQ/HrvbB5gZnrYBvTHkIXQ63agyR/ztq3bce8xsIMKd5mC8pUlW5TkT3?=
 =?us-ascii?Q?GOvXoDFU5q1XosfWxuRS34M+usBVLM3aD7Vk/aMH4nfjeBwi9pU+d+gKPDvD?=
 =?us-ascii?Q?konSY+psNGi1nnCkR+9Z0bpzVNCvVeRAhwqzv2RTVA/HcYMQqwAM9oDCGsVG?=
 =?us-ascii?Q?iGpIglMJswQiW9BLH5WrsQp72V14vzqv9W27QsEZinoGKR16hZbqhrUOb7d/?=
 =?us-ascii?Q?6UHBTtidCGWKXQCLIDdD4hHL8UVrnqoVovcQvZNCKRvwTXgSNUEOsnlb4F9T?=
 =?us-ascii?Q?zncxPyNQJhtDMfeqfNfC8wnAp30M2zvnm6g25TpRbhJSraXWd0dGw/idjcuS?=
 =?us-ascii?Q?qRdjCbQ9rNSoghUB+9ELsk/bIxe54rywgsPsDKWHDGFOdQgY8PS57+wvJXUI?=
 =?us-ascii?Q?gPsboXNQZIV9I+zOFo81QsGOxjmeC5TAkKzLSZvtO6grBO9yHKaqGHfqbBu4?=
 =?us-ascii?Q?4cUW0AT5sbb//v3osX998z70Y3Z4ESOPfK0Cl23rNNURsqVNBfVtDmE4NBw9?=
 =?us-ascii?Q?Z0NXWjTtZw5nQREmVlm5NphGPcF+OChiQc/4qTDHKcwsaTpkVVqLTUKs9/sA?=
 =?us-ascii?Q?C6VwkYQEYuKxBr3NJ1pEgU8eV7kPEmjoWiijLBvAxM7O2cMvTUiSzPJWcb3T?=
 =?us-ascii?Q?OFVPKnhYZebDaeJ/Q2RzJ2XdubLvpFf08pkeOlcgXiwQE+ghXgwzpQnJ5T0+?=
 =?us-ascii?Q?eXDp7WcIavAyDpC2qvTuxduBRjVdmyRtvPKb8cC6TE9j/LwXo1BpLCyPcsVE?=
 =?us-ascii?Q?XvJYmkpHSe8FT6LppIVTJfQzPYYP7eqbn0z2AcOp0OEZVRpHiUzF0R5WFMmR?=
 =?us-ascii?Q?BAKebgLMCuyB0+tfImlseQOLb9fLUJROH1RDk3zJObpbgFX1ES4VxDGsqij9?=
 =?us-ascii?Q?4iITmZsaTWioimOFgcA0ai39AvQsF0dSbR8xdXhihPR2aIftisjpPl1s11ti?=
 =?us-ascii?Q?Zg=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29f486bf-ed2e-4af6-9224-08da755f7ec4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2022 14:50:23.7231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qBthX7WXm1Vc2pgHXqZsshTXedWJ9RX7R62QvFG7u9PZAx70bc+ywYVwkcYbgvqupdD+1pL5wEyv92wOSZAVL2C70N8SYs3M2RCCpbBWC/M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5505
X-Proofpoint-ORIG-GUID: lu6olWa1jWC3-NONQoU1DB9VsxdiMrex
X-Proofpoint-GUID: lu6olWa1jWC3-NONQoU1DB9VsxdiMrex
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-03_03,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 phishscore=0 clxscore=1015 lowpriorityscore=0 suspectscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 spamscore=0 mlxlogscore=900
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208030066
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Sitnicki <jakub@cloudflare.com>

commit 8f50f16ff39dd4e2d43d1548ca66925652f8aff7 upstream.

Add coverage to the verifier tests and tests for reading bpf_sock fields to
ensure that 32-bit, 16-bit, and 8-bit loads from dst_port field are allowed
only at intended offsets and produce expected values.

While 16-bit and 8-bit access to dst_port field is straight-forward, 32-bit
wide loads need be allowed and produce a zero-padded 16-bit value for
backward compatibility.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/r/20220130115518.213259-3-jakub@cloudflare.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
[OP: backport to 5.4: cherry-pick verifier changes only]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 tools/include/uapi/linux/bpf.h              |  3 +-
 tools/testing/selftests/bpf/verifier/sock.c | 81 ++++++++++++++++++++-
 2 files changed, 80 insertions(+), 4 deletions(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 0bfad86ec960..cb0631098f91 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3068,7 +3068,8 @@ struct bpf_sock {
 	__u32 src_ip4;
 	__u32 src_ip6[4];
 	__u32 src_port;		/* host byte order */
-	__u32 dst_port;		/* network byte order */
+	__be16 dst_port;	/* network byte order */
+	__u16 :16;		/* zero padding */
 	__u32 dst_ip4;
 	__u32 dst_ip6[4];
 	__u32 state;
diff --git a/tools/testing/selftests/bpf/verifier/sock.c b/tools/testing/selftests/bpf/verifier/sock.c
index 9ed192e14f5f..b2ce50bb935b 100644
--- a/tools/testing/selftests/bpf/verifier/sock.c
+++ b/tools/testing/selftests/bpf/verifier/sock.c
@@ -121,7 +121,25 @@
 	.result = ACCEPT,
 },
 {
-	"sk_fullsock(skb->sk): sk->dst_port [narrow load]",
+	"sk_fullsock(skb->sk): sk->dst_port [word load] (backward compatibility)",
+	.insns = {
+	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1, offsetof(struct __sk_buff, sk)),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_1, 0, 2),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	BPF_EMIT_CALL(BPF_FUNC_sk_fullsock),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 2),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_0, offsetof(struct bpf_sock, dst_port)),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_CGROUP_SKB,
+	.result = ACCEPT,
+},
+{
+	"sk_fullsock(skb->sk): sk->dst_port [half load]",
 	.insns = {
 	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1, offsetof(struct __sk_buff, sk)),
 	BPF_JMP_IMM(BPF_JNE, BPF_REG_1, 0, 2),
@@ -139,7 +157,64 @@
 	.result = ACCEPT,
 },
 {
-	"sk_fullsock(skb->sk): sk->dst_port [load 2nd byte]",
+	"sk_fullsock(skb->sk): sk->dst_port [half load] (invalid)",
+	.insns = {
+	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1, offsetof(struct __sk_buff, sk)),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_1, 0, 2),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	BPF_EMIT_CALL(BPF_FUNC_sk_fullsock),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 2),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_0, offsetof(struct bpf_sock, dst_port) + 2),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_CGROUP_SKB,
+	.result = REJECT,
+	.errstr = "invalid sock access",
+},
+{
+	"sk_fullsock(skb->sk): sk->dst_port [byte load]",
+	.insns = {
+	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1, offsetof(struct __sk_buff, sk)),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_1, 0, 2),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	BPF_EMIT_CALL(BPF_FUNC_sk_fullsock),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 2),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_B, BPF_REG_2, BPF_REG_0, offsetof(struct bpf_sock, dst_port)),
+	BPF_LDX_MEM(BPF_B, BPF_REG_2, BPF_REG_0, offsetof(struct bpf_sock, dst_port) + 1),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_CGROUP_SKB,
+	.result = ACCEPT,
+},
+{
+	"sk_fullsock(skb->sk): sk->dst_port [byte load] (invalid)",
+	.insns = {
+	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1, offsetof(struct __sk_buff, sk)),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_1, 0, 2),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	BPF_EMIT_CALL(BPF_FUNC_sk_fullsock),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 2),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_0, offsetof(struct bpf_sock, dst_port) + 2),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_CGROUP_SKB,
+	.result = REJECT,
+	.errstr = "invalid sock access",
+},
+{
+	"sk_fullsock(skb->sk): past sk->dst_port [half load] (invalid)",
 	.insns = {
 	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1, offsetof(struct __sk_buff, sk)),
 	BPF_JMP_IMM(BPF_JNE, BPF_REG_1, 0, 2),
@@ -149,7 +224,7 @@
 	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 2),
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
-	BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_0, offsetof(struct bpf_sock, dst_port) + 1),
+	BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_0, offsetofend(struct bpf_sock, dst_port)),
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
-- 
2.36.1

