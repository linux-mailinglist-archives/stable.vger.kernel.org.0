Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E33E40298D
	for <lists+stable@lfdr.de>; Tue,  7 Sep 2021 15:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344664AbhIGNUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 09:20:25 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:5446 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344507AbhIGNUA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Sep 2021 09:20:00 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 187Bn3FZ002074;
        Tue, 7 Sep 2021 13:18:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=BNtK4LOuzuDoqnhSxzmttc46zCEEKJ1DJjxgJMQmmu4=;
 b=PNRfYvk49Uy6G4EEgxHs6ET7BQxIuqyvHcTNYt2JEKcJ3N9cAbiI/IeXAaTqmqbZKCB5
 EOT6xjPum5TVnbOPWKxyeBVFyLzGh+1qxeJ4HDIL2EoEgEInNGvOVFFzvAIGkl5L91SF
 A9gimuKzV5ZdKhWCh+5OOU4RITKLjwRI0hO90cKlscUl3HIwWNeu2Zuv/6FFzmuxkD+u
 PRsGmEjDxbOVfunTdHjhhhgOpGdgTPyYxymuyDksg+HDxDjF6a4hgpr92fW5DNhSA11j
 4c1GsoOVmz6ip9/dk3jb2UW/s+eipcApTo6mmSmtd0qnEsNB/OvbHpQIHZzJKd14sgkD HQ== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by mx0a-0064b401.pphosted.com with ESMTP id 3awjhygq69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Sep 2021 13:18:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QypMntpeCp9JN175wWM0OBfNuWpIF6vdLB3jXlXyxqGdpIYKCHoxLre6TwRF8MZDtxf3txgEDc0sTyczJ/UsZUrSsD/EJB5qI2dF5A3TCpuCD6L+9f7plQYMFuDNeKIxQ4dl7p9YMzCmY5LsGYC0NQA1+U0busBuLDRbznRnIYZwEb5RXjvFV3UQ8Zy+3pmfedkytWQw9A5aK6SyFki6aKjHbrreblk0QP8JtH36njkJmjm+6LtvWngccO7YVcgdTSfHd3E4+Q84KLa8tQ2OI+dAyU6zaZFRNayWkqtY5zgjrdWDQhb6l3uy57qG0litJuCmOr6Vn7GZhmAuBzwZFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=BNtK4LOuzuDoqnhSxzmttc46zCEEKJ1DJjxgJMQmmu4=;
 b=TqyJlCOt5MgXbH0x5b8OJcGs2tPhp3zFf/cCHrT3Sn6WQ3q04i99vTlDA61c1dOVWUPeCCNaEF/OuGdECGdfpOTP8Qun/MFv7o8EsOl92+hogNbFaZ2J7rDyLiufbQxYL5kwOao+tL5mntlijQgnVOxWj7WUIvwORDTo/OWmioRSNmbcpgnnfgHAy64e15SIKELZQ1MeCoFaNNFtMaBH3wEKRS2e0gM+W9A3OKpg4ofXw04Qeu9/ShZrhyCiTk9MLglzuY9cnC0nUpQZGkaZMqzOwxYRDeRS9PbQvgVFxPiklUNhT0g8i4+1AS9oAOVa1cyDkSXf7XlFotqcJojrjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB3114.namprd11.prod.outlook.com (2603:10b6:5:6d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Tue, 7 Sep
 2021 13:18:38 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::952a:bdc6:20c3:94cb]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::952a:bdc6:20c3:94cb%6]) with mapi id 15.20.4478.025; Tue, 7 Sep 2021
 13:18:38 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net
Subject: [PATCH 5.4 2/4] bpf: Fix leakage due to insufficient speculative store bypass mitigation
Date:   Tue,  7 Sep 2021 16:16:59 +0300
Message-Id: <20210907131701.1910024-3-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210907131701.1910024-1-ovidiu.panait@windriver.com>
References: <20210907131701.1910024-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0181.eurprd07.prod.outlook.com
 (2603:10a6:802:3e::29) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR07CA0181.eurprd07.prod.outlook.com (2603:10a6:802:3e::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.6 via Frontend Transport; Tue, 7 Sep 2021 13:18:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6286d474-27fa-4917-0def-08d972020123
X-MS-TrafficTypeDiagnostic: DM6PR11MB3114:
X-Microsoft-Antispam-PRVS: <DM6PR11MB3114E3A2D3676691F1106FA7FED39@DM6PR11MB3114.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rBvtw/2764F2H/UvdTZhkY6WpdXWg2JLkaPHIx+YeopEYNlalzKzHPvUTLodr+j7ktXeOA07UCKTCHv1C1J4566LYC0Y3/e+PhdJJyLtC35959ky8kZUwW50Bwl5LXBqB4CZp5dnU8nvAtiGumzUrz2LqH2F5yXw6e8hsC7wISyJOzkp97oC3ltC8KyXyEI/zlQbin9CfiGbSIG2ahnXpVjGVZvxBvZ5bOSvRS5sxo2TkOreHuiKH7lAK3F9yZYiO4uzEA0tec6/uT++06FRf4JlxNIQHa2/ohF6PbVC1qy3Zmow4PQ0OTjFBQHxSj970Ef6pMnQ+QJe9uU1ceOhCJdLO2r4Eb2s8Br8/QVY1JHUCuLQj1EWrV7sNUgATTnliNZfdNH+WNC8EzQ930KN+B8a3a8xlkRj8uoWvcQJUqzzK9l5HzsXCf+2Gj0qUANNk04W9Y2ZgMCQXhIVFED0OmHOAfi5FssAgQgHYGSno0auRIh9Vp2WiPSR44WdQP35ZyJlVbxUK2c/5YxeZgKZvFh+KO54KACX3H2pw+yOW2iFLGhWxAoV8LoSSRzKLYNDMSqIN60aTMZydONgpRppF492bp2inFmYKp2W1t/6dr+V8gRVYngs3+K3n4Vx93K7a9UwxphO9E+oRLu6KklqCxQ8/DmqVRziMd2G/SIRTLksOAmCgeb51WPWh4xX0vHEiKC6cGvu8aB78cHaz3mT7AeAWyn64XKIYc6gBNYxmv5j7cs0J3B0oedlJbag2xfbdja925CBeHeFO6jwOr1nriggUDWC5nZH5cvP0CrsY9I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(366004)(136003)(376002)(39850400004)(8936002)(83380400001)(38100700002)(6916009)(186003)(4326008)(36756003)(38350700002)(86362001)(2906002)(956004)(26005)(6666004)(2616005)(8676002)(66476007)(1076003)(66556008)(44832011)(6506007)(6512007)(52116002)(966005)(6486002)(30864003)(478600001)(66946007)(316002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fAiF0IIrrSL63Dfo1XpqX3JA9MobIEPvWxNSQ8KGKLqltybDt05tvv6At3qI?=
 =?us-ascii?Q?gNjdetbcEVCMpkZLJTRbFWj50GHWecWq5dSYIPdkhdKwnBswusdBHqFg1ey7?=
 =?us-ascii?Q?HaJfo2tVbov/08dytRJFLsEWJMOD7No8A3IFaqt7neECry2MtVReAhKuNZDk?=
 =?us-ascii?Q?epuA1C8JCy4x8JMFLCG71iTyFx6YUhxilIO6net1XDIquaKR07C2a8+XBNkM?=
 =?us-ascii?Q?hjANlGaNIqKULM24mdsJ7fkSTmf9nT+DcO5d/xaQhjTGBvYhFHHTQzuslfWw?=
 =?us-ascii?Q?4WlQvB5I8eVLWrUMs0IB3xZD7dm+DN9aQ6F/JqLge6zQekMjVAgUOSWIBj83?=
 =?us-ascii?Q?niIal9PWmU9izVRnz8I7imQVVgd7E1+Obt6UbVBguZFjJGxvpzqSF7SqkwIp?=
 =?us-ascii?Q?Th+TPbBRi9xfAzliq0/RG1SymDGIW+kJTYmzsletda8x+8Y961WcYX1Ek9Cd?=
 =?us-ascii?Q?r4gTPaaWGMcqFJJro5tTBvnMz/b/FXqk+4zHL5IZHHqOhjh2n5g6dRyOK251?=
 =?us-ascii?Q?IB9i30v3U4gDlkMxE4mAwrAofLyLhtC6zRBpz7Cu+Zgr9Ir9W/DvUTWtnfl+?=
 =?us-ascii?Q?A6JYF1bPa7sNXSXZh+uYHi+s/Eepvglggwg9vy31EE0PK/P+kqbUuVS2HA18?=
 =?us-ascii?Q?DI/zJA2hEML81ajrPqYL0mxQ7DX7rLMSiuidD3kWZGApBzlpMfqDkawXyFYH?=
 =?us-ascii?Q?y59TZhzU3fHs5zUkGoGvKXOEyUTn1WFGJcRjH9yF2F9Evg03Enizks9I1Lev?=
 =?us-ascii?Q?i//P3SKBLkNkEtcG8PQdwSKQ8SRor4P8VCR/5or2OxQFB7mqk64Uvc3De4bA?=
 =?us-ascii?Q?ZyfgKGF18H7kbNvLWdy6s3zJWFg1pfFBBxNTR35hvubG2WonjDITWin+6EMM?=
 =?us-ascii?Q?n6p+agsVviEB+wXci3gXapKP8yAc8OvcsedMgXLgzTNsa4cWYabRgX0i3A4V?=
 =?us-ascii?Q?+MsJFw+ORJgYUOU22CnIf1uzITV8PY7O6jeMwDhyeNBMeNH6SxTO+iXV8kVz?=
 =?us-ascii?Q?HpYvcYhNfleQW6NqvPzh50s1frn1kIXamZrodfgRxw0LoLoWP0PYnvpJQoQh?=
 =?us-ascii?Q?0P1ujdl1ew9o10AJWscgIM2SioMNRNY8kI1QbFcoTlcDEVVS46LnsA/xnxEp?=
 =?us-ascii?Q?Nek1OvbKakNdlRcrTdwcI6sNaiRac/mJSZ3WaQUFBZe7W3H/KsADq5iroCXr?=
 =?us-ascii?Q?HE71hQMNT0DDPUYOlWa053vB3iPllxxU69v0sqVQx+4Wu/P4LBxvgtyrARVH?=
 =?us-ascii?Q?atpz1KH4Y/00ZIUGMT0Pa4aDSPz1RK3Nk6iVFFEKYznDJ7C6tQjNXs49uSH4?=
 =?us-ascii?Q?7PpZYKu4esQoL7m3gWy8rggo?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6286d474-27fa-4917-0def-08d972020123
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2021 13:18:38.7068
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SD6X1rG8t3YGaj6FNGduwDUc0NKF6CjQDEJVnSzoLQVRweh/G/1tyhcsYz1BlUBfG94nhUWxSiQfArZbeUk4GMeV7lfzMPv4c6+Ppc49Rdo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3114
X-Proofpoint-GUID: YZEa0_XZ-JB1sesPbYbOfefHpTWKMIcS
X-Proofpoint-ORIG-GUID: YZEa0_XZ-JB1sesPbYbOfefHpTWKMIcS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-07_04,2021-09-07_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 mlxscore=0 adultscore=0
 impostorscore=0 priorityscore=1501 phishscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109070088
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
[OP: - apply check_stack_write_fixed_off() changes in check_stack_write()
     - replace env->bypass_spec_v4 -> env->allow_ptr_leaks]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 include/linux/bpf_verifier.h |  2 +-
 kernel/bpf/verifier.c        | 87 +++++++++++++-----------------------
 2 files changed, 33 insertions(+), 56 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 22f070085971..4292e8e42c12 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -301,8 +301,8 @@ struct bpf_insn_aux_data {
 		};
 	};
 	int ctx_field_size; /* the ctx field size for load insn, maybe 0 */
-	int sanitize_stack_off; /* stack slot to be cleared */
 	bool seen; /* this insn was processed by the verifier */
+	bool sanitize_stack_spill; /* subject to Spectre v4 sanitation */
 	bool zext_dst; /* this insn zero extends dst reg */
 	u8 alu_state; /* used in combination with alu_limit */
 	bool prune_point;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 4deaf15b7618..ec06c4f0402e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1920,6 +1920,19 @@ static int check_stack_write(struct bpf_verifier_env *env,
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
@@ -1942,47 +1955,10 @@ static int check_stack_write(struct bpf_verifier_env *env,
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
@@ -8849,35 +8825,33 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 
 	for (i = 0; i < insn_cnt; i++, insn++) {
 		bpf_convert_ctx_access_t convert_ctx_access;
+		bool ctx_access;
 
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
@@ -8891,6 +8865,9 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 			continue;
 		}
 
+		if (!ctx_access)
+			continue;
+
 		switch (env->insn_aux_data[i + delta].ptr_type) {
 		case PTR_TO_CTX:
 			if (!ops->convert_ctx_access)
-- 
2.25.1

