Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10B5E5B8799
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 13:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbiINLxn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 07:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbiINLxc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 07:53:32 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C3B7CA9F
        for <stable@vger.kernel.org>; Wed, 14 Sep 2022 04:53:29 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28EBCcTx000341;
        Wed, 14 Sep 2022 04:53:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=tXylEvc/RNxEwgxeiy3LnDd4in69k7eL7tBGjalmPIs=;
 b=tFIMeH19lTqMTeDESGq18amDgwINpRzPngHuumWVxDbhms/7kKTMttKJKP1NYtXadT1D
 V8xGxjSBsD3uultb0cc2l9HqQOTvR0J2lURbxYpTi6dFcvd92+x1D0XksPNbO5k9RnVH
 B8bYXYsN/X/vq0lc1Fcdi5fCE2zsl19V+PAfdC8lAfz1av7Kf+B4g4g2mzT7nymOrki2
 QDDfzyqc7CpU0i4O50LS1dVUGQAanEKGjFIUMv0/SFlLuXvlFuQ7pTO/q653Ny9PHZ+i
 dhoJ7peiu95sgnCk9U4r8dNT5fR6SgLHuiTknRBHPQfG5MZmtI2tMyFTl3uwc2pgGnFE EQ== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3jk4sh0es1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Sep 2022 04:53:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VcrJQprqwv/fkJ/EFJ6ZwPkK3fHSdQevhpIqtn/+oMAlcjd01FI1WPfN9SsqpgB1r2B9TDKBseuZt0epTbFqXzNMbY53Hk8bsIK1R0ZoHYzEohdVkmfS/6D5E4Sp4+99JzokzJ2nRhCeA7bKihEgUUyc6Lpet0Z+D2kE2zFrHD6+NsmGH2S0Rh93EsRaGddJJOsjXPIA8y/mth2FN4fchIqTQJLp1u1D8BT6Wa/7XtjL5KFmSX7wCQ36TND1bcF+Gg3hpz8JnZr+8+R+3M20Hrj+iOaWh/2a41F2lWUMuqNiWfD9MN9fNZEJKVPFygjNUnmzQtmRsRXhLax3fG7S3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tXylEvc/RNxEwgxeiy3LnDd4in69k7eL7tBGjalmPIs=;
 b=klEY+sddAJXw9d+E4rpCn4nDqE+Q9s+pr8rdeH3i2CmksUQfW8E6OP7Qtm4Rpa32rg/Xy1HEsDG+/Cyk/utzGPk6NMeoq5/RN/+34HfE4OBxQiVGW5I4e5CUPlp5xQIux+D9wKq2BNKJ/BNf6IdNAI//wh6sHsZyUuZi9RV2GtVKWh6NDTv/1PyJzKjv53oCBZehPGEVaKd96OzLaKSgpun8ep73LWW942F84sZcp3XIxXwNFl2mThXfFNo7426ndTfyUgzXggFdWR+7y9JzwCxoUYYsj7q+ta9qbuf1mAHVuELOIWCO5DHwHpD58DlwAwdPca6zdNOdEM62NrLRpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by MN2PR11MB4711.namprd11.prod.outlook.com (2603:10b6:208:24e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.20; Wed, 14 Sep
 2022 11:52:59 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::b4a9:c48a:51c2:d3fd]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::b4a9:c48a:51c2:d3fd%5]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 11:52:59 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     paul.gortmaker@windriver.com, gregkh@linuxfoundation.org,
        peterz@infradead.org, bp@suse.de, jpoimboe@kernel.org,
        cascardo@canonical.com, Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.10 3/3] x86/ftrace: Use alternative RET encoding
Date:   Wed, 14 Sep 2022 14:52:38 +0300
Message-Id: <20220914115238.882630-3-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220914115238.882630-1-ovidiu.panait@windriver.com>
References: <20220914115238.882630-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0801CA0083.eurprd08.prod.outlook.com
 (2603:10a6:800:7d::27) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|MN2PR11MB4711:EE_
X-MS-Office365-Filtering-Correlation-Id: 81265635-6425-4f45-8b43-08da9647abc4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g2k8ZiH8v3I+bb3XLFVEEAPnMxzgrTwwPNLYXmhVe+2iRcKhhJIq89oJiEitpOalKw1tPd5Erh8IxkpGrFpvsoPaLyh5mumsHPhr2tbneGi41/++sKuVY2MB981NH0Z3yf7wXCuBruT8gMalJmFCG4sXRTFTNIxCd3OszaHjvZWQ7eapt93ZhxTe8O8tOBQts8r2ELLtb8ASZ4+zx8qiPe0JbKSUs/1kQyWDBkMeZx1LpgYQYqnH9CDqjTXxaMk4Y1L1jRz7pQJ/7rfsg8lA6dg7MzbnIsfzcE0HyX1LHJB3Hh2vR7SVehASWTkJLtJ+wd4pFUx8Tl06T9xxqlX10bKjDoCEWOWOlwGmeHUBNsios4T8EkdKYT9rCVA/CzRrA7Wma63L0eCefxhOn2tjGIH2WOVC3uG/fs/OUFYYZx7NG12y0B+O/gX0ZBMmLF7cvaN6p74tOm+OZHbCCqNHE0rlczM+3ih3MV39EQrnLojbLPyox4/yT/qQwCqE//lIh/0lKqodjz9TPsq2/WT2uvHW8ewoLGhdL/jbq6LeqaaGI07ymfX4VGirwmMT8mhJEn6T6xf+S5Eri/ezAlRCS+xbubFyWCudwCJIChU35U/5ilP2E8NYb/SY72K8N93ySW+lh1SUaDid4qfjhgrYUJY91GAotD0YhrcssaLWXcwD3bwJCvFV9JHNI91LmRbVKjidPNoKd1Ki2mN40KlOFvqmIi/PEuZ2LqNS2ePwc9HvHCMUPPTsWH3U/vMZlbxOPVzGzNlDEv0Pnqq0L6jf1Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(136003)(39850400004)(376002)(366004)(451199015)(66476007)(86362001)(38100700002)(2906002)(8676002)(2616005)(83380400001)(4326008)(6916009)(26005)(478600001)(6506007)(186003)(8936002)(6512007)(107886003)(52116002)(36756003)(44832011)(38350700002)(66556008)(316002)(6486002)(6666004)(41300700001)(66946007)(5660300002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tZcYTsrsULSb7s0bNGVNyadHhuz6C4VvEeFTsBTSbRNQmyw+0btur87mXBpB?=
 =?us-ascii?Q?1zs5PXlHezHTKeVlyOnP1tIfu8wLsanYgTfvtRUCaE6SRsyqoecbgEsGoSoy?=
 =?us-ascii?Q?jjToDzX6Hf7F2kizr65RHTuS8wq9oS4jtAcH+t3rESSDWCIKkUuIiFpKbOim?=
 =?us-ascii?Q?r+Mlq4sK9XFHF0c05/YfTtwLQ9XNt4uCccbcRxpe4xoPhmub9PIsm2Dfbeyn?=
 =?us-ascii?Q?bn6IvoN7Bcx3jEpJUmizqWjk6VGBdutFm5DmifNmKG15OESPlyZf7L3zkWUW?=
 =?us-ascii?Q?9z0+w7bkp6PjwaEPPyD5j+YBEXKhEKbvDSWNmYhzmiFmCBk7sQuVXYwyv8Ds?=
 =?us-ascii?Q?bn6i7cbqcg9cjApxCZPXm9InVMHNaDGsGsq4Ks7roVyOiZpEiZixDdrOpGb2?=
 =?us-ascii?Q?AOzv13aQOEdX1fKnlUOj4QgEPghxYjF5UKJqyWFIzu6VPpVKbzqFdOkY/Ich?=
 =?us-ascii?Q?S8DyGSkSYO33LUbRSavWLwQSCR5ifpATPXZ2DFOiV0ERonZ3g+MRtlpeNdWE?=
 =?us-ascii?Q?QDvBsCYoM6hgjP3d3T45R2zW6aWgeTZrjAJTZeEtX6yGWGRaAj+rENcOm/J5?=
 =?us-ascii?Q?xjYbMQHmu8111hvoIx2GEuyo00DIVIAzIWdeoKeEKQNPnLHQJMlzZXxFjWMK?=
 =?us-ascii?Q?B/Xh107V36qa1qqwe6WvqCSyaEec9wQLTsjWJiUlDQEarFVswapo9yyTr6rs?=
 =?us-ascii?Q?jJp+duXa8keP9Kj3IvQtXF7RIq0kXvJudgOaVMBJdlWWenHBTjofFUFX4KVn?=
 =?us-ascii?Q?hLdO4RgAQyIcdwOUH5LWFODvnO1ityDZ3nVPYFdjpDjZbD7/2UQJ4MvuCHJZ?=
 =?us-ascii?Q?J8KjKDqbbXYatmma4NCl8NSiy6gcGUO34KYe2Tm+kKBjjHaS6TiJlNsPdYI5?=
 =?us-ascii?Q?Cs3Nhp5M1UUA+czT29IdxwH4D4mHna5Xk1uRYpEclZTVjmwY+irf6QXmHB8J?=
 =?us-ascii?Q?QvhK0kBqJEouNpsi/pUFqiKuBbD0r5D/YGSqQqEl8PoLtDjQdgPwQ4dk3IE2?=
 =?us-ascii?Q?tH4UzIJzodB8nKaQN9PHPxVXytTNmLXZMktuP96noTfx7rWGxkdxffNeMBxB?=
 =?us-ascii?Q?Em0LnPuOSzU/p1AY10O5EDPvOy6dDb0SV3SvIamrOXHBi72X7jhpnu/q3drB?=
 =?us-ascii?Q?zCZtY9Fd1hQgs77VYnIGZIkVYCOZe3meGvZ7r3Pq+TMuthKdzVE4nwKeByO1?=
 =?us-ascii?Q?4LAuQEO/EMkbQ3WQnC8GA4ktWs0h8nGkp5r5iSWhPP56iL3YDwvalMbzEaFQ?=
 =?us-ascii?Q?QI+cGnK+pLetXnM8pPNDaVfhXEzOlqUnOTwvHMXJf9mHQnUhUiL2ixPfUJ8z?=
 =?us-ascii?Q?xTLDP8O+K1fLSQrzKdfYCZY0f+4HDHDk+uF7mE51uZ9yuUumqDa3bm18Vmek?=
 =?us-ascii?Q?uSyd8sQeLBySW7kWJgc5WWEaR33h2Sp2ubhEPqxOVtMsONvFW1HRKG/xFpBH?=
 =?us-ascii?Q?/T2e7uLGcW6f7ihuR1tl3cjSkhAscHpTZjnjoJm3eftMuKR2XWpjx434yScS?=
 =?us-ascii?Q?hCM+33JaANxbMoBNxOktQ6e2MKwjFFnvp9nXDmxnztj0ZdP44+wWbii1FZHa?=
 =?us-ascii?Q?pKu9anJQijmBpV7IGkfAUR0fhoZKu7jqmFpDqffy1ZzyLzxwppXqCs8VKdcb?=
 =?us-ascii?Q?FQ=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81265635-6425-4f45-8b43-08da9647abc4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 11:52:59.6850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AxqBLLKwpbyMbGTxnD6BcoiGDxjke/C6ns1mxSrFuxmbvHoJyV6jlPYAnr6EvB75wHoHYfZzXCNr1W6uANgDqOHgbFZAslgTrb6fF+9asr0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4711
X-Proofpoint-ORIG-GUID: RUzUMBmshQm1mOMKZIOE8vuKD3QvfO9r
X-Proofpoint-GUID: RUzUMBmshQm1mOMKZIOE8vuKD3QvfO9r
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-14_05,2022-09-14_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=469 suspectscore=0 priorityscore=1501 bulkscore=0 phishscore=0
 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2208220000 definitions=main-2209140058
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 1f001e9da6bbf482311e45e48f53c2bd2179e59c upstream.

Use the return thunk in ftrace trampolines, if needed.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
[cascardo: use memcpy(text_gen_insn) as there is no __text_gen_insn]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 arch/x86/kernel/ftrace.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index b80e38cbd49e..d096b5a1dbeb 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -309,7 +309,7 @@ union ftrace_op_code_union {
 	} __attribute__((packed));
 };
 
-#define RET_SIZE		1 + IS_ENABLED(CONFIG_SLS)
+#define RET_SIZE		(IS_ENABLED(CONFIG_RETPOLINE) ? 5 : 1 + IS_ENABLED(CONFIG_SLS))
 
 static unsigned long
 create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
@@ -365,7 +365,12 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
 		goto fail;
 
 	ip = trampoline + size;
-	memcpy(ip, retq, RET_SIZE);
+
+	/* The trampoline ends with ret(q) */
+	if (cpu_feature_enabled(X86_FEATURE_RETHUNK))
+		memcpy(ip, text_gen_insn(JMP32_INSN_OPCODE, ip, &__x86_return_thunk), JMP32_INSN_SIZE);
+	else
+		memcpy(ip, retq, sizeof(retq));
 
 	/* No need to test direct calls on created trampolines */
 	if (ops->flags & FTRACE_OPS_FL_SAVE_REGS) {
-- 
2.37.3

