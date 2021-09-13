Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 243BE409789
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 17:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244247AbhIMPhr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 11:37:47 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:47112 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243425AbhIMPhn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 11:37:43 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DFWYAC017553;
        Mon, 13 Sep 2021 15:36:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=7PlTESSJq47KFwdWMPFjFRngLo7BG5w+K3FDSTNjtv0=;
 b=Hrz8HtDEtbEn1TjHnblZqbI0auiBcebtPVsWl3wVLexSQxrXfF2JQTxo8xv07tIV/bFj
 2irf9Jy9FHwsugtlii29H3ZSzpIAuHPXYvcDRWB9RuacVziLgAIfWrM+KCBECMyZf/Ws
 PfGpP93LKc/GgbBZ2Ji8tHjaDahdhC+O4hqtomeZR5FxDyHYRBpFHoYOCpDw/hRxgGp7
 lP4ixVPQJHxRo3L6/2LDx/qCSL8NlQCLHPn/v0NAcGhe72BQhR9h+ygot6JgskuRy6dG
 e1cqHqGzL3kYOZFmtpOskYbQ8Ye1vUTRSBKjPmYTPJAqm6EQ891ftzSppoYBdK3Y5zbZ gg== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2045.outbound.protection.outlook.com [104.47.56.45])
        by mx0a-0064b401.pphosted.com with ESMTP id 3b26m1854d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Sep 2021 15:36:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SqodCRFL15fje5gXd2kgxi0O9rXAG0umvSqMR/LzTNgX/RYSHw0chZCD3b1pLA/ZeajhdNBjXMRMV/XOWbgSlxfmaCu7okCIVE5Ggq41REA9bBQ6VZ0nYrRauX5zdPaeLYwfj75XUJVwiKDdW6fhAYxHk8gyER06L7DxKqsArHVWkhV3BksBGUq+2vxig14XxZRiMJHCDXNL5SmGdoxP9VgWsMsxSP+WYF/RIkysdubp1rlYbdy/OAnmNbY5o8yln90wKNJIhdtHn9PuHnycxq4eqOeC2vujMK6Lo1+QrCOSRvf8j/IKb/7AZspV7tbXGyQYQYK1trip26l5XifZZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=7PlTESSJq47KFwdWMPFjFRngLo7BG5w+K3FDSTNjtv0=;
 b=aESqUvBCuXfvhmSr7S0xR6N3YUsgkiDqLkYb5ZOOLdNx2f3G0z5m1FwELIhDlb1Di+aEe3kP+0RnM1gor/kdwdtqeDQqAzEMZDLiKL8kKr+p+euvou0HE6HaYXbe27igw6QRHkNmxTrM0211O09DdEv4K/HVRa7QiVW7nGUeLo7tevv6q7albZcg19aP6gZeHo7LVXnNucTbcesUHx+iepS+rOYRCDSy1n7EI9Wv7lY1ei+LbVuwfOP4lyLKqLiwU+iuB0u9MmOvSgXFqj6YtaFstsVx7PtHGzz93rpJFgOSZK45R5zTR10wGTC/qT4ttgS4yX0w6xK09QPEF8/sJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM5PR1101MB2201.namprd11.prod.outlook.com (2603:10b6:4:51::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15; Mon, 13 Sep
 2021 15:36:09 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::952a:bdc6:20c3:94cb]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::952a:bdc6:20c3:94cb%7]) with mapi id 15.20.4500.019; Mon, 13 Sep 2021
 15:36:09 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net
Subject: [PATCH 4.19 11/13] bpf: Fix leakage due to insufficient speculative store bypass mitigation
Date:   Mon, 13 Sep 2021 18:35:35 +0300
Message-Id: <20210913153537.2162465-12-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210913153537.2162465-1-ovidiu.panait@windriver.com>
References: <20210913153537.2162465-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR10CA0095.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::24) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR10CA0095.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:803:28::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 15:36:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39972a95-9714-4bcc-f3d7-08d976cc359b
X-MS-TrafficTypeDiagnostic: DM5PR1101MB2201:
X-Microsoft-Antispam-PRVS: <DM5PR1101MB22017A34D0246F82B9A22A91FED99@DM5PR1101MB2201.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MdNgcJiGqxhsd755F7hDEKDSrtVmOUm7H9AW+2k5ZQS7enAL9+bn7n9RcIQDXT7MD5ERONvKqkOTqgLzDI4oL/Cqqmm2JFRMfEYLTRmxr6anYC9Ssi57x60uwk6Rf22KpPkNP6hwJGzLJCNcqPAag8ooyGtldRW1V9Csf2kSnTEn+TPuFB4FGLJ0wL30hVx+JR7wLsLn2YVZ/mnVZe4Pn6f1OdKBp5zNQWUAKcWP0DjXW+RC2XzzIGWK/JAbvgpZbJVMuM4AoPha0QibS1LixoifVQ589bgaa/V+FRVZTLwcjDucrxSLBN5M1dTUHW+JQdGZLk35TJ5KTu0D4PmBzBR+XO6PuoObiaRdCtyuT8v8wW6LKUHAOGLcAhTrQuejJoOFF5spOOx0fhHCeBmSufB+vbUHOHrZtRp7x8lG4H9DKPZjvvEccZKBptznQvK08kUFQkK5U6DpPVdRX+DAtUAMwQxts6P1MjvzjGrFS8WuXZhH1jzTChTci9AXQ0SpQmv4gk/zF00uJDMC7Ok8xWYwPK8IDsBmsKbWOMtuq3AXvK4Ewn/igFTDwXX2MVHSHtxQv5gOyQcivl0wr33UQsRjCDoZGTnAI+Bl5R1xiI9mwcYe9fZJ3xoH4jevtzHHWFw20ulNZ2gXqJsC40Y0hYUauhSBq9stfpMMoUl603Sp5r5CkzzU79npxaS3wayEjFy2XDWZv99BcvdF1wJWsLHNYASzpaEyAwX94Yp5STqndbAI7ImqmvxmxbKcJx/8uglTVZz2myKiwExnpcNoroJ95O/KdinuoTO+pWbXg3g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(39850400004)(376002)(346002)(52116002)(6916009)(316002)(6486002)(38350700002)(6666004)(86362001)(5660300002)(2616005)(4326008)(8936002)(26005)(38100700002)(6512007)(6506007)(956004)(83380400001)(30864003)(478600001)(1076003)(36756003)(186003)(44832011)(966005)(66476007)(2906002)(8676002)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XYAwDP0SBb3sSgEq/xalIfmuur9NAJh6ogVhiHS4qsRDLqcu/R3RxAf4ROzC?=
 =?us-ascii?Q?NJ87H1voCEE6CN0rLvDMWZFzv5O1QWcCbDeZUxcqBcdEGtsqb1JfaA/tvtqx?=
 =?us-ascii?Q?Yow2JewFW8iMnHhY2XTCRbg7xDqNy6EwxVpn3J1Glsa0sfIjIr5wK+FDzAS2?=
 =?us-ascii?Q?u3635DGxsJFr7+pwLDsNeywrGphUlw7NFpkI7aQ6iL9Fj4s1YUrdmimWC185?=
 =?us-ascii?Q?Vx3gei0ApdE8BFTf3gExqBdfxQoHFMWyjMXAoOJaX5K8zSNJJylGJs/v53A7?=
 =?us-ascii?Q?hXNuqPBSwYUEY5MBrXOqipEHt0Rb0cC+/OVVFNNxc1V6bvsAeD6iUksl05h+?=
 =?us-ascii?Q?QRDJL8k+rtBeXf38+QUXTQyDFs2KriogEOEXKtUWd7sUG7Zd3GPTyxmb4fGn?=
 =?us-ascii?Q?MwoPWghO7p53URzh7ehr3jXOnS01l5c/DjQGCfyqiXtZUx72z7u987KktTS+?=
 =?us-ascii?Q?UeOizSPI/OFmqpGh5jw+kn4AVgnqYdR3MDN4ZRAQ9XFNhOJlCswJAHfi+33R?=
 =?us-ascii?Q?jPI2l2zmNu/JHKpIyodwwTI6LTvIDjrM+VqNP1GlOgA5HJKJdSwNN7cRp564?=
 =?us-ascii?Q?33NZiSGNdws/jz1iXERrTbc+X0ahm+zVyUxSpiy7rpCqSWeeWmAbXnBlImW5?=
 =?us-ascii?Q?1jJtukHC0a0nL4is7fHHfSju6rJQc1sVnJ+uGJhRhAsVz2OpWe0246/Y+Vq+?=
 =?us-ascii?Q?iR9B2V0FEmjsOJEnLqeUgZIG88tD642eNxLxEwz2yMwttn1kSLeH6UM5MgV+?=
 =?us-ascii?Q?XTVDfsydVobTrOG6F9j+mwxf6Hme/Pg/aoZbKPW3gJgAIfaSbS2RBTMnWU0q?=
 =?us-ascii?Q?3487NE5oYKQF8XlrLCSKloWbvBwbign9sKv2mWDk9iB/t7pp2klGVbKczI4n?=
 =?us-ascii?Q?3G1jL/mcYhJTGtjzJFB3bkRPRpv316QirOAKIHi/DRMdPJQmR/2B+CqseHJc?=
 =?us-ascii?Q?nFvZRRZrrU/fQF7tMLMLN9+YGC9S2orfrS4fCp5/mJAv5ygkX24R4k5deOjV?=
 =?us-ascii?Q?QGpm54OFP/UTvSKbzPv7U49ziP6jWGS7uEiApce9FbtKn4zHbTWsqc1RpZrA?=
 =?us-ascii?Q?Ndt2JLQ0v1b7vKVLYeHxwYaMEhDAK1YBvUV0la/qXD5YTAjNqY7Ac3w301YI?=
 =?us-ascii?Q?d7tnqdli60tJoec9wKA1T/jCYkGTShZID6PZRtPjytMALf89PB6nvyo7S/wj?=
 =?us-ascii?Q?xpf1pDJ8PuiI5ClFD/xADPl5Ct4n9/ve5oDua200bkZVJwfZGlI1/Ky9mI86?=
 =?us-ascii?Q?vSVLHn/Hzc/qSMiZ41TJIpmaI5FUFFR8ZeY5E2XUbqPdTKBpD4ek1b5+nSgY?=
 =?us-ascii?Q?Nc3C2B9cw3ZV6f+4gFBixihp?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39972a95-9714-4bcc-f3d7-08d976cc359b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 15:36:09.7172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RSK84MFzj7SOTPNDghHQR4kX9sgiwnx/U02tkfWY0QatPCpGwEjYEIhkkphfdNdO2P1jBkxlHPmxmDlP0lkmED+md/1SWehQlWSgay0dsWY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2201
X-Proofpoint-GUID: tdJQDfbbs6koPJ2YKRqXL-gQ4TU9DF4M
X-Proofpoint-ORIG-GUID: tdJQDfbbs6koPJ2YKRqXL-gQ4TU9DF4M
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-13_07,2021-09-09_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109130103
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 2039f26f3aca5b0e419b98f65dd36481337b86ee upstream.

Spectre v4 gadgets make use of memory disambiguation, which is a set of
techniques that execute memory access instructions, that is, loads and
stores, out of program order; Intel's optimization manual, section 2.4.4.5:

  A load instruction micro-op may depend on a preceding store. Many
  microarchitectures block loads until all preceding store addresses are
  known. The memory disambiguator predicts which loads will not depend on
  any previous stores. When the disambiguator predicts that a load does
  not have such a dependency, the load takes its data from the L1 data
  cache. Eventually, the prediction is verified. If an actual conflict is
  detected, the load and all succeeding instructions are re-executed.

af86ca4e3088 ("bpf: Prevent memory disambiguation attack") tried to mitigate
this attack by sanitizing the memory locations through preemptive "fast"
(low latency) stores of zero prior to the actual "slow" (high latency) store
of a pointer value such that upon dependency misprediction the CPU then
speculatively executes the load of the pointer value and retrieves the zero
value instead of the attacker controlled scalar value previously stored at
that location, meaning, subsequent access in the speculative domain is then
redirected to the "zero page".

The sanitized preemptive store of zero prior to the actual "slow" store is
done through a simple ST instruction based on r10 (frame pointer) with
relative offset to the stack location that the verifier has been tracking
on the original used register for STX, which does not have to be r10. Thus,
there are no memory dependencies for this store, since it's only using r10
and immediate constant of zero; hence af86ca4e3088 /assumed/ a low latency
operation.

However, a recent attack demonstrated that this mitigation is not sufficient
since the preemptive store of zero could also be turned into a "slow" store
and is thus bypassed as well:

  [...]
  // r2 = oob address (e.g. scalar)
  // r7 = pointer to map value
  31: (7b) *(u64 *)(r10 -16) = r2
  // r9 will remain "fast" register, r10 will become "slow" register below
  32: (bf) r9 = r10
  // JIT maps BPF reg to x86 reg:
  //  r9  -> r15 (callee saved)
  //  r10 -> rbp
  // train store forward prediction to break dependency link between both r9
  // and r10 by evicting them from the predictor's LRU table.
  33: (61) r0 = *(u32 *)(r7 +24576)
  34: (63) *(u32 *)(r7 +29696) = r0
  35: (61) r0 = *(u32 *)(r7 +24580)
  36: (63) *(u32 *)(r7 +29700) = r0
  37: (61) r0 = *(u32 *)(r7 +24584)
  38: (63) *(u32 *)(r7 +29704) = r0
  39: (61) r0 = *(u32 *)(r7 +24588)
  40: (63) *(u32 *)(r7 +29708) = r0
  [...]
  543: (61) r0 = *(u32 *)(r7 +25596)
  544: (63) *(u32 *)(r7 +30716) = r0
  // prepare call to bpf_ringbuf_output() helper. the latter will cause rbp
  // to spill to stack memory while r13/r14/r15 (all callee saved regs) remain
  // in hardware registers. rbp becomes slow due to push/pop latency. below is
  // disasm of bpf_ringbuf_output() helper for better visual context:
  //
  // ffffffff8117ee20: 41 54                 push   r12
  // ffffffff8117ee22: 55                    push   rbp
  // ffffffff8117ee23: 53                    push   rbx
  // ffffffff8117ee24: 48 f7 c1 fc ff ff ff  test   rcx,0xfffffffffffffffc
  // ffffffff8117ee2b: 0f 85 af 00 00 00     jne    ffffffff8117eee0 <-- jump taken
  // [...]
  // ffffffff8117eee0: 49 c7 c4 ea ff ff ff  mov    r12,0xffffffffffffffea
  // ffffffff8117eee7: 5b                    pop    rbx
  // ffffffff8117eee8: 5d                    pop    rbp
  // ffffffff8117eee9: 4c 89 e0              mov    rax,r12
  // ffffffff8117eeec: 41 5c                 pop    r12
  // ffffffff8117eeee: c3                    ret
  545: (18) r1 = map[id:4]
  547: (bf) r2 = r7
  548: (b7) r3 = 0
  549: (b7) r4 = 4
  550: (85) call bpf_ringbuf_output#194288
  // instruction 551 inserted by verifier    \
  551: (7a) *(u64 *)(r10 -16) = 0            | /both/ are now slow stores here
  // storing map value pointer r7 at fp-16   | since value of r10 is "slow".
  552: (7b) *(u64 *)(r10 -16) = r7           /
  // following "fast" read to the same memory location, but due to dependency
  // misprediction it will speculatively execute before insn 551/552 completes.
  553: (79) r2 = *(u64 *)(r9 -16)
  // in speculative domain contains attacker controlled r2. in non-speculative
  // domain this contains r7, and thus accesses r7 +0 below.
  554: (71) r3 = *(u8 *)(r2 +0)
  // leak r3

As can be seen, the current speculative store bypass mitigation which the
verifier inserts at line 551 is insufficient since /both/, the write of
the zero sanitation as well as the map value pointer are a high latency
instruction due to prior memory access via push/pop of r10 (rbp) in contrast
to the low latency read in line 553 as r9 (r15) which stays in hardware
registers. Thus, architecturally, fp-16 is r7, however, microarchitecturally,
fp-16 can still be r2.

Initial thoughts to address this issue was to track spilled pointer loads
from stack and enforce their load via LDX through r10 as well so that /both/
the preemptive store of zero /as well as/ the load use the /same/ register
such that a dependency is created between the store and load. However, this
option is not sufficient either since it can be bypassed as well under
speculation. An updated attack with pointer spill/fills now _all_ based on
r10 would look as follows:

  [...]
  // r2 = oob address (e.g. scalar)
  // r7 = pointer to map value
  [...]
  // longer store forward prediction training sequence than before.
  2062: (61) r0 = *(u32 *)(r7 +25588)
  2063: (63) *(u32 *)(r7 +30708) = r0
  2064: (61) r0 = *(u32 *)(r7 +25592)
  2065: (63) *(u32 *)(r7 +30712) = r0
  2066: (61) r0 = *(u32 *)(r7 +25596)
  2067: (63) *(u32 *)(r7 +30716) = r0
  // store the speculative load address (scalar) this time after the store
  // forward prediction training.
  2068: (7b) *(u64 *)(r10 -16) = r2
  // preoccupy the CPU store port by running sequence of dummy stores.
  2069: (63) *(u32 *)(r7 +29696) = r0
  2070: (63) *(u32 *)(r7 +29700) = r0
  2071: (63) *(u32 *)(r7 +29704) = r0
  2072: (63) *(u32 *)(r7 +29708) = r0
  2073: (63) *(u32 *)(r7 +29712) = r0
  2074: (63) *(u32 *)(r7 +29716) = r0
  2075: (63) *(u32 *)(r7 +29720) = r0
  2076: (63) *(u32 *)(r7 +29724) = r0
  2077: (63) *(u32 *)(r7 +29728) = r0
  2078: (63) *(u32 *)(r7 +29732) = r0
  2079: (63) *(u32 *)(r7 +29736) = r0
  2080: (63) *(u32 *)(r7 +29740) = r0
  2081: (63) *(u32 *)(r7 +29744) = r0
  2082: (63) *(u32 *)(r7 +29748) = r0
  2083: (63) *(u32 *)(r7 +29752) = r0
  2084: (63) *(u32 *)(r7 +29756) = r0
  2085: (63) *(u32 *)(r7 +29760) = r0
  2086: (63) *(u32 *)(r7 +29764) = r0
  2087: (63) *(u32 *)(r7 +29768) = r0
  2088: (63) *(u32 *)(r7 +29772) = r0
  2089: (63) *(u32 *)(r7 +29776) = r0
  2090: (63) *(u32 *)(r7 +29780) = r0
  2091: (63) *(u32 *)(r7 +29784) = r0
  2092: (63) *(u32 *)(r7 +29788) = r0
  2093: (63) *(u32 *)(r7 +29792) = r0
  2094: (63) *(u32 *)(r7 +29796) = r0
  2095: (63) *(u32 *)(r7 +29800) = r0
  2096: (63) *(u32 *)(r7 +29804) = r0
  2097: (63) *(u32 *)(r7 +29808) = r0
  2098: (63) *(u32 *)(r7 +29812) = r0
  // overwrite scalar with dummy pointer; same as before, also including the
  // sanitation store with 0 from the current mitigation by the verifier.
  2099: (7a) *(u64 *)(r10 -16) = 0         | /both/ are now slow stores here
  2100: (7b) *(u64 *)(r10 -16) = r7        | since store unit is still busy.
  // load from stack intended to bypass stores.
  2101: (79) r2 = *(u64 *)(r10 -16)
  2102: (71) r3 = *(u8 *)(r2 +0)
  // leak r3
  [...]

Looking at the CPU microarchitecture, the scheduler might issue loads (such
as seen in line 2101) before stores (line 2099,2100) because the load execution
units become available while the store execution unit is still busy with the
sequence of dummy stores (line 2069-2098). And so the load may use the prior
stored scalar from r2 at address r10 -16 for speculation. The updated attack
may work less reliable on CPU microarchitectures where loads and stores share
execution resources.

This concludes that the sanitizing with zero stores from af86ca4e3088 ("bpf:
Prevent memory disambiguation attack") is insufficient. Moreover, the detection
of stack reuse from af86ca4e3088 where previously data (STACK_MISC) has been
written to a given stack slot where a pointer value is now to be stored does
not have sufficient coverage as precondition for the mitigation either; for
several reasons outlined as follows:

 1) Stack content from prior program runs could still be preserved and is
    therefore not "random", best example is to split a speculative store
    bypass attack between tail calls, program A would prepare and store the
    oob address at a given stack slot and then tail call into program B which
    does the "slow" store of a pointer to the stack with subsequent "fast"
    read. From program B PoV such stack slot type is STACK_INVALID, and
    therefore also must be subject to mitigation.

 2) The STACK_SPILL must not be coupled to register_is_const(&stack->spilled_ptr)
    condition, for example, the previous content of that memory location could
    also be a pointer to map or map value. Without the fix, a speculative
    store bypass is not mitigated in such precondition and can then lead to
    a type confusion in the speculative domain leaking kernel memory near
    these pointer types.

While brainstorming on various alternative mitigation possibilities, we also
stumbled upon a retrospective from Chrome developers [0]:

  [...] For variant 4, we implemented a mitigation to zero the unused memory
  of the heap prior to allocation, which cost about 1% when done concurrently
  and 4% for scavenging. Variant 4 defeats everything we could think of. We
  explored more mitigations for variant 4 but the threat proved to be more
  pervasive and dangerous than we anticipated. For example, stack slots used
  by the register allocator in the optimizing compiler could be subject to
  type confusion, leading to pointer crafting. Mitigating type confusion for
  stack slots alone would have required a complete redesign of the backend of
  the optimizing compiler, perhaps man years of work, without a guarantee of
  completeness. [...]

From BPF side, the problem space is reduced, however, options are rather
limited. One idea that has been explored was to xor-obfuscate pointer spills
to the BPF stack:

  [...]
  // preoccupy the CPU store port by running sequence of dummy stores.
  [...]
  2106: (63) *(u32 *)(r7 +29796) = r0
  2107: (63) *(u32 *)(r7 +29800) = r0
  2108: (63) *(u32 *)(r7 +29804) = r0
  2109: (63) *(u32 *)(r7 +29808) = r0
  2110: (63) *(u32 *)(r7 +29812) = r0
  // overwrite scalar with dummy pointer; xored with random 'secret' value
  // of 943576462 before store ...
  2111: (b4) w11 = 943576462
  2112: (af) r11 ^= r7
  2113: (7b) *(u64 *)(r10 -16) = r11
  2114: (79) r11 = *(u64 *)(r10 -16)
  2115: (b4) w2 = 943576462
  2116: (af) r2 ^= r11
  // ... and restored with the same 'secret' value with the help of AX reg.
  2117: (71) r3 = *(u8 *)(r2 +0)
  [...]

While the above would not prevent speculation, it would make data leakage
infeasible by directing it to random locations. In order to be effective
and prevent type confusion under speculation, such random secret would have
to be regenerated for each store. The additional complexity involved for a
tracking mechanism that prevents jumps such that restoring spilled pointers
would not get corrupted is not worth the gain for unprivileged. Hence, the
fix in here eventually opted for emitting a non-public BPF_ST | BPF_NOSPEC
instruction which the x86 JIT translates into a lfence opcode. Inserting the
latter in between the store and load instruction is one of the mitigations
options [1]. The x86 instruction manual notes:

  [...] An LFENCE that follows an instruction that stores to memory might
  complete before the data being stored have become globally visible. [...]

The latter meaning that the preceding store instruction finished execution
and the store is at minimum guaranteed to be in the CPU's store queue, but
it's not guaranteed to be in that CPU's L1 cache at that point (globally
visible). The latter would only be guaranteed via sfence. So the load which
is guaranteed to execute after the lfence for that local CPU would have to
rely on store-to-load forwarding. [2], in section 2.3 on store buffers says:

  [...] For every store operation that is added to the ROB, an entry is
  allocated in the store buffer. This entry requires both the virtual and
  physical address of the target. Only if there is no free entry in the store
  buffer, the frontend stalls until there is an empty slot available in the
  store buffer again. Otherwise, the CPU can immediately continue adding
  subsequent instructions to the ROB and execute them out of order. On Intel
  CPUs, the store buffer has up to 56 entries. [...]

One small upside on the fix is that it lifts constraints from af86ca4e3088
where the sanitize_stack_off relative to r10 must be the same when coming
from different paths. The BPF_ST | BPF_NOSPEC gets emitted after a BPF_STX
or BPF_ST instruction. This happens either when we store a pointer or data
value to the BPF stack for the first time, or upon later pointer spills.
The former needs to be enforced since otherwise stale stack data could be
leaked under speculation as outlined earlier. For non-x86 JITs the BPF_ST |
BPF_NOSPEC mapping is currently optimized away, but others could emit a
speculation barrier as well if necessary. For real-world unprivileged
programs e.g. generated by LLVM, pointer spill/fill is only generated upon
register pressure and LLVM only tries to do that for pointers which are not
used often. The program main impact will be the initial BPF_ST | BPF_NOSPEC
sanitation for the STACK_INVALID case when the first write to a stack slot
occurs e.g. upon map lookup. In future we might refine ways to mitigate
the latter cost.

  [0] https://arxiv.org/pdf/1902.05178.pdf
  [1] https://msrc-blog.microsoft.com/2018/05/21/analysis-and-mitigation-of-speculative-store-bypass-cve-2018-3639/
  [2] https://arxiv.org/pdf/1905.05725.pdf

Fixes: af86ca4e3088 ("bpf: Prevent memory disambiguation attack")
Fixes: f7cf25b2026d ("bpf: track spill/fill of constants")
Co-developed-by: Piotr Krysiuk <piotras@gmail.com>
Co-developed-by: Benedict Schlueter <benedict.schlueter@rub.de>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Piotr Krysiuk <piotras@gmail.com>
Signed-off-by: Benedict Schlueter <benedict.schlueter@rub.de>
Acked-by: Alexei Starovoitov <ast@kernel.org>
[OP: - apply check_stack_write_fixed_off() changes in check_stack_write()
     - replace env->bypass_spec_v4 -> env->allow_ptr_leaks]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 include/linux/bpf_verifier.h |  2 +-
 kernel/bpf/verifier.c        | 88 ++++++++++++++----------------------
 2 files changed, 34 insertions(+), 56 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index daab0960c054..e64ac93f7f4c 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -158,8 +158,8 @@ struct bpf_insn_aux_data {
 		u32 alu_limit;			/* limit for add/sub register with pointer */
 	};
 	int ctx_field_size; /* the ctx field size for load insn, maybe 0 */
-	int sanitize_stack_off; /* stack slot to be cleared */
 	bool seen; /* this insn was processed by the verifier */
+	bool sanitize_stack_spill; /* subject to Spectre v4 sanitation */
 	u8 alu_state; /* used in combination with alu_limit */
 };
 
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ce051c0b9a54..d38ec3266a84 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1008,6 +1008,19 @@ static int check_stack_write(struct bpf_verifier_env *env,
 	cur = env->cur_state->frame[env->cur_state->curframe];
 	if (value_regno >= 0)
 		reg = &cur->regs[value_regno];
+	if (!env->allow_ptr_leaks) {
+		bool sanitize = reg && is_spillable_regtype(reg->type);
+
+		for (i = 0; i < size; i++) {
+			if (state->stack[spi].slot_type[i] == STACK_INVALID) {
+				sanitize = true;
+				break;
+			}
+		}
+
+		if (sanitize)
+			env->insn_aux_data[insn_idx].sanitize_stack_spill = true;
+	}
 
 	if (reg && size == BPF_REG_SIZE && register_is_const(reg) &&
 	    !register_is_null(reg) && env->allow_ptr_leaks) {
@@ -1018,47 +1031,10 @@ static int check_stack_write(struct bpf_verifier_env *env,
 			verbose(env, "invalid size of register spill\n");
 			return -EACCES;
 		}
-
 		if (state != cur && reg->type == PTR_TO_STACK) {
 			verbose(env, "cannot spill pointers to stack into stack frame of the caller\n");
 			return -EINVAL;
 		}
-
-		if (!env->allow_ptr_leaks) {
-			bool sanitize = false;
-
-			if (state->stack[spi].slot_type[0] == STACK_SPILL &&
-			    register_is_const(&state->stack[spi].spilled_ptr))
-				sanitize = true;
-			for (i = 0; i < BPF_REG_SIZE; i++)
-				if (state->stack[spi].slot_type[i] == STACK_MISC) {
-					sanitize = true;
-					break;
-				}
-			if (sanitize) {
-				int *poff = &env->insn_aux_data[insn_idx].sanitize_stack_off;
-				int soff = (-spi - 1) * BPF_REG_SIZE;
-
-				/* detected reuse of integer stack slot with a pointer
-				 * which means either llvm is reusing stack slot or
-				 * an attacker is trying to exploit CVE-2018-3639
-				 * (speculative store bypass)
-				 * Have to sanitize that slot with preemptive
-				 * store of zero.
-				 */
-				if (*poff && *poff != soff) {
-					/* disallow programs where single insn stores
-					 * into two different stack slots, since verifier
-					 * cannot sanitize them
-					 */
-					verbose(env,
-						"insn %d cannot access two stack slots fp%d and fp%d",
-						insn_idx, *poff, soff);
-					return -EINVAL;
-				}
-				*poff = soff;
-			}
-		}
 		save_register_state(state, spi, reg);
 	} else {
 		u8 type = STACK_MISC;
@@ -5867,34 +5843,33 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 	insn = env->prog->insnsi + delta;
 
 	for (i = 0; i < insn_cnt; i++, insn++) {
+		bool ctx_access;
+
 		if (insn->code == (BPF_LDX | BPF_MEM | BPF_B) ||
 		    insn->code == (BPF_LDX | BPF_MEM | BPF_H) ||
 		    insn->code == (BPF_LDX | BPF_MEM | BPF_W) ||
-		    insn->code == (BPF_LDX | BPF_MEM | BPF_DW))
+		    insn->code == (BPF_LDX | BPF_MEM | BPF_DW)) {
 			type = BPF_READ;
-		else if (insn->code == (BPF_STX | BPF_MEM | BPF_B) ||
-			 insn->code == (BPF_STX | BPF_MEM | BPF_H) ||
-			 insn->code == (BPF_STX | BPF_MEM | BPF_W) ||
-			 insn->code == (BPF_STX | BPF_MEM | BPF_DW))
+			ctx_access = true;
+		} else if (insn->code == (BPF_STX | BPF_MEM | BPF_B) ||
+			   insn->code == (BPF_STX | BPF_MEM | BPF_H) ||
+			   insn->code == (BPF_STX | BPF_MEM | BPF_W) ||
+			   insn->code == (BPF_STX | BPF_MEM | BPF_DW) ||
+			   insn->code == (BPF_ST | BPF_MEM | BPF_B) ||
+			   insn->code == (BPF_ST | BPF_MEM | BPF_H) ||
+			   insn->code == (BPF_ST | BPF_MEM | BPF_W) ||
+			   insn->code == (BPF_ST | BPF_MEM | BPF_DW)) {
 			type = BPF_WRITE;
-		else
+			ctx_access = BPF_CLASS(insn->code) == BPF_STX;
+		} else {
 			continue;
+		}
 
 		if (type == BPF_WRITE &&
-		    env->insn_aux_data[i + delta].sanitize_stack_off) {
+		    env->insn_aux_data[i + delta].sanitize_stack_spill) {
 			struct bpf_insn patch[] = {
-				/* Sanitize suspicious stack slot with zero.
-				 * There are no memory dependencies for this store,
-				 * since it's only using frame pointer and immediate
-				 * constant of zero
-				 */
-				BPF_ST_MEM(BPF_DW, BPF_REG_FP,
-					   env->insn_aux_data[i + delta].sanitize_stack_off,
-					   0),
-				/* the original STX instruction will immediately
-				 * overwrite the same stack slot with appropriate value
-				 */
 				*insn,
+				BPF_ST_NOSPEC(),
 			};
 
 			cnt = ARRAY_SIZE(patch);
@@ -5908,6 +5883,9 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 			continue;
 		}
 
+		if (!ctx_access)
+			continue;
+
 		if (env->insn_aux_data[i + delta].ptr_type != PTR_TO_CTX)
 			continue;
 
-- 
2.25.1

