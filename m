Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBBC0409773
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 17:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234593AbhIMPhc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 11:37:32 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:62876 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235697AbhIMPh3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 11:37:29 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DFWk6s015226;
        Mon, 13 Sep 2021 08:35:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=28c4Crm6uJOGAK8q8QiGQnKLNSfbzWb9IOL+QWFms2I=;
 b=nPBWF3GsrRznkiOl9lPktOirgYe7zhfCROLTicyvSl3c5jjCT1DtIO5XjQLSWNPhp+ux
 rhMhWz6r9bmunovnbL74QR5bDAuCNQV8cbE4R0e9WoepdoWcCPMSFgYR0PCuk+6+Q/Hp
 /8SHYHn8OG3tA2/CetiI5FnDmvwKgm0yvqrTCzre5ZHr/nUc2w1F4CJPSL2dTvqu5GmY
 l5DkcLppc+AFRk2XFh87FxCGmSkKbNT9BhRJPQW5V+5Ph6POgR9p60Ilx6PaYoBrunWf
 U3wVkuFj4FVOijlvU0JG3RFe8ExVXdTJj10SqScN9tOP1XxSfu8lZYjbY7hA714B75bB jA== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by mx0a-0064b401.pphosted.com with ESMTP id 3b1kfn0pky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Sep 2021 08:35:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lSAc6GxKkIw7OMB8xlAdOYR4iiitwakCgH9ezmjpntI5hKLIQ+sF5tlqQfC7vwyrEJrbkZt/ZMRTJ0MrWRtUQFaGLkkPhwtMYtXSzbOsczlhsjARMk6LOncmUt23hy1W9l/gtlox0SP3na0Hzuq3XjV/9CYtG3OnlQ11+JEHoyLEebNohSspH/sJe6ZSgp+goVscBMEpBd6qXOKTiXSnDilEO7XI49qdEHs86kje1n/50PQy4WDYE2lga5BimotfqkXYQ+9TpBYlARN1nphui9JF2GIKz87gH69bRGNLx+nS99YZoa8pW5frFamouTB/DzHTSdfnjaVG/TurKWODHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=28c4Crm6uJOGAK8q8QiGQnKLNSfbzWb9IOL+QWFms2I=;
 b=LO4GWgld1fnRqjp7lzzbwRQLdPruFg9KCz1IuNmKODYnEJBvZN7ZG89E38ynL7BrXhAR4uaedmMLIRFAgsv8sFpXQ2ettOSg2mt0+xWxeCldsFPgjHX7TORkYENP/A2wGXDOGAgirKwNo8cVeyT/z8AUl/TCKC1pgDLgSvwVafjCZZXGHiWieFIaIN6j++4vbcgrFa2GokLI/R7g5R0cJUOExtHOXdwpnQedfrmf1GIwB8ISdV7NwzYuLoov6nHkq+ltVIu9+TiwQkZZFeFXH2vzeYTeAMXnfGlSXzL/9HeUibo0VcHL+hSoB77OdMKA7e69pShv88QhL/RTYZYVBw==
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
 2021 15:35:56 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::952a:bdc6:20c3:94cb]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::952a:bdc6:20c3:94cb%7]) with mapi id 15.20.4500.019; Mon, 13 Sep 2021
 15:35:56 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net
Subject: [PATCH 4.19 00/13] bpf: backport fixes for CVE-2021-34556/CVE-2021-35477
Date:   Mon, 13 Sep 2021 18:35:24 +0300
Message-Id: <20210913153537.2162465-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR10CA0095.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::24) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR10CA0095.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:803:28::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 15:35:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d872e3c-b3d0-4838-8a9d-08d976cc2d6a
X-MS-TrafficTypeDiagnostic: DM4PR11MB5549:
X-Microsoft-Antispam-PRVS: <DM4PR11MB5549E6287AE3D66B8D9C7194FED99@DM4PR11MB5549.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NGRaQfKH5j5sYbEAQ52kqIu4WzVhKft70Fw7Ba7SvL+pu6BRBsdX1jdbV5pdKOiorNdMdjis4d+v3jgJc/rJvx/ORBbILhGz8Vgyy16ODQ2Oedb0fTdbO44ysbsmda2Ylnc+w95KapISZ9XgEUKY7iPDK7zdNYSda8hmbdR47w8PbOq6Iz8HwVVi8AkNEaBsrNldMi90igBi1BzofyQLVXQj+Ff6GL5KOfyg5lNbGfFbifgY4ailWl3Px6x7s6nhnNITJskILG/VKT0qrg/wXE554yjZuU6wWaJTnht+q97AWgczks2Wz7HLuOKliK+blIY66YZS3JWp14w8C1OuckOOgzWiAhTQ1T7ZAqW6Lz0QRj6WpziogHabTknFEYjduDkZJZPjssKN0JUPMxRkZ2Pc5P8LMJS19aDsSb9MrSvJjLFYYQJiTAEYntWL01JM1WNy0GeAv7PelA2CKU+z9oZ5aYA5fjcOak9p6ans1OSBOzeFPhBNxDD2OU1RktQpeH5jOni0SRfqMDgP3EKaAO+7+N5oxVW8OVFLx6E20poZh3e8zsaSPi/pev7Mi9ylaYDaSMBzFSVXeExpjg3v7NDyFAQSQePJnIdX0/ZEHqcVb+T76KF3q5v7oMPKE3LUGX12suCSTFKyCo9X/AeBCrcbudpGuIMonVGvlnKePWaaqzaI9JZlvSdNW8hYYwNDxZcmWQ3hITEdp/f9SVbG/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(39850400004)(136003)(376002)(478600001)(26005)(83380400001)(186003)(38350700002)(2616005)(8936002)(38100700002)(44832011)(52116002)(8676002)(6916009)(5660300002)(6506007)(956004)(86362001)(316002)(36756003)(2906002)(4326008)(1076003)(66946007)(6666004)(66476007)(66556008)(6512007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gMbLPE2pNQYfq+LpDsdf9V16nucQTGvUmIwxMNGWcvjrohZXit+/E0jPDgqR?=
 =?us-ascii?Q?nMlvhUXGyw/ulmyXTArtdnzwUUAb6qJO5Iyt74MAzL4JCaC/2tPxc8Ik8Sj6?=
 =?us-ascii?Q?ycihJnVD1F91OMo/mYHgH5ka31srVHN9XIdDXxASwDPDZl6gmv/oDwl/MYNr?=
 =?us-ascii?Q?t0uvMRX/49VVPGuUlm9kKvQ3wv5m5+RqqTjCVmsad5TNJqyEhZO3W59IYYZQ?=
 =?us-ascii?Q?xTKJKEj7y5ROkW7YJzoxBZV7ZZrD3KLtR0V+1klraXMEtWTBJE8m3zMGRxJ/?=
 =?us-ascii?Q?dHmhsA4z+B27Am83LRErYTD/rim48ygE87ybKVvQcFOnsVq6z5ggXv5qmXYO?=
 =?us-ascii?Q?LFpYcnHzJtVggO2Eq9jkrNU9xXUbeCRBBTapyC8+rp7qvEuKg27tiKipFX/e?=
 =?us-ascii?Q?llCTDoihlI2FyUGdWF4zXQXPQclQK89Cxq87cKHQYQ+n2W9BQLuJFcNpcNV/?=
 =?us-ascii?Q?B7QRVgVqyGt5+QrY+U0kUkl4HlAq1Qou1VCnrJifpY9Z3q161DyKtZI7GDPm?=
 =?us-ascii?Q?6+f94NP+x7UPdHL1aNQooILJys8vaSGi4zZDlIWn0VOTYJsbK/Owd0Y/KYaD?=
 =?us-ascii?Q?9mDMQJNnI5Iosq0aUP5otCh1Q8Y7DZX7fH/m77pg2+plcZ52aeaQRM/0bwgV?=
 =?us-ascii?Q?1tQ9UYRZ+7HQ4kiyplc87xYJXDbPDXTXUR2MogabHVr4GlJIK1rqopl0LUc3?=
 =?us-ascii?Q?1jQLvYbnXoy/MEBnYJ5kty9wEUe7MSxXDCJZmTjn/6phTb5r7+qYXCmhxbX2?=
 =?us-ascii?Q?/cjvyolglkNfyUbTK/+ktEGdm1SCG4YGQDLnKCZX52TMWAlejc1yey0bMl31?=
 =?us-ascii?Q?lLnQy88kCraHWoh9KW/1WCTm68NucEvYue149s8blzP4RdH9gur/zkXv20hI?=
 =?us-ascii?Q?JR8gDGP6QhuvLZbgGfeD8qUfJ2Cpf7AYGAeVuNgom9GVysnBw2U1ZqvPsUNr?=
 =?us-ascii?Q?MIts5Ek1hFN6+7DgdkCMCTQmbS/Do76XksSwLQeNEomGlth2D+D1RtTNRQ7o?=
 =?us-ascii?Q?a+6M3hb5mCRN2f98q/WAIZ+YanZ1Fil2duo6WrOsSdCLtoDvn3H3XTTIp0TI?=
 =?us-ascii?Q?anKk/ON8q7BrLfmmN3sZ9vscRuZLouzyqHbMz9eZ04+9CDEWZI23027k4szt?=
 =?us-ascii?Q?GVf78WDOQ1zMksjQ3WsBaxtCspPzLhwzhESlhRNlCLAtmMWf2aPcl/YojQ7W?=
 =?us-ascii?Q?ICyazy2mXfJcoFW1X2xhIpKGGT1IWkYt2OYVbUOlpyunsIJQb0v7zuvK4L4S?=
 =?us-ascii?Q?gshc8Q34kj9YFVRa46eiZ1xnZuo13WwB/MthwoYwGf2f9n2XS76EMSM5Ea4l?=
 =?us-ascii?Q?r0fSV9xN6ZNnMdlFtXh7kFOJ?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d872e3c-b3d0-4838-8a9d-08d976cc2d6a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 15:35:55.9806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fZ+OpLwsCJOZdMMdoNpaFu7h/sMjCciChlUMtNCDzc0qPICiXM0JcYsj9/VTevCMpUHBNlJVXOmupvz0RcvzSS5X4lVKS8G2oZUkHAAb3OY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5549
X-Proofpoint-ORIG-GUID: DoYoOCxOU5h4Qavmn0b9d0weolSandY4
X-Proofpoint-GUID: DoYoOCxOU5h4Qavmn0b9d0weolSandY4
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

Backport summary
----------------
679c782de14b ("bpf/verifier: per-register parent pointers")
	* Context patch for 2039f26f3aca5 ("bpf: Fix leakage due to
	  insufficient speculative store bypass mitigation").
	* Context adjustments because of the code added by post-4.19 commit:
	  f92a819b4cbef ("bpf: prevent out of bounds speculation on pointer
	  arithmetic").

0bae2d4d62d5 ("bpf: correct slot_type marking logic to allow more stack slot sharing")
	* Context patch for 2039f26f3aca5 ("bpf: Fix leakage due to
	  insufficient speculative store bypass mitigation").
	* Minor context adjustement in selftest.

2011fccfb61b ("bpf: Support variable offset stack access from helpers")
	* Context patch for 2039f26f3aca5 ("bpf: Fix leakage due to
	  insufficient speculative store bypass mitigation").
	* 4.19 does not have the reg_state(env, regno) helper defined, so
	  replace the call with "cur_regs(env) + regno".

f2bcd05ec7b8 ("bpf: Reject indirect var_off stack access in raw mode")
	* Follow-up fix for 2011fccfb61bb ("bpf: Support variable offset stack
	  access from helpers").
	* Clean cherry-pick.

088ec26d9c2d ("bpf: Reject indirect var_off stack access in unpriv")
	* Follow-up fix for 2011fccfb61bb ("bpf: Support variable offset stack
	  access from helpers").
	* Drop comment in retrieve_ptr_limit(), as it was made obsolete by
	  post-4.19 commit 45bfdd767e235 ("bpf: Tighten speculative pointer
	  arithmetic mask").

107c26a70ca8 ("bpf: Sanity check max value for var_off stack access")
	* Follow-up fix for 2011fccfb61bb ("bpf: Support variable offset stack
	  access from helpers").
	* Clean cherry-pick.

8ff80e96e3cc ("selftests/bpf: Test variable offset stack access")
	* Selftest follow-up for 2011fccfb61bb ("bpf: Support variable offset
	  stack access from helpers").
	* Post-4.19, the verifier tests were split into different
	  files, in 4.19 they are still all in test_verifier.c, so apply the
	  changes manually.

f7cf25b2026d ("bpf: track spill/fill of constants")
	* Context patch for 2039f26f3aca5 ("bpf: Fix leakage due to
	  insufficient speculative store bypass mitigation").
	* Drop verbose_linfo() calls, as the function is not implemented in 4.19.
	* Adjust mark_reg_read() calls to match the prototype in 4.19.
	  (mark_reg_read() was changed to take 4 parameters in post-4.19 commit
	  5327ed3d44b75("bpf: verifier: mark verified-insn with sub-register
	  zext flag"), but backporting it is out of scope for this patchseries).

fc559a70d57c ("selftests/bpf: fix tests due to const spill/fill")
	* Selftest follow-up for f7cf25b2026d ("bpf: track spill/fill of constants").
	* Post-4.19, the verifier tests were split into different
	  files, in 4.19 they are still all in test_verifier.c, so apply the
	  changes manually.

f5e81d111750 ("bpf: Introduce BPF nospec instruction for mitigating Spectre v4")
	* Contextual adjustments.
	* Drop arch/powerpc/net/bpf_jit_comp32.c changes, as the file is not
	  present in 4.19
	* Drop riscv changes, as arch/riscv/net/bpf_jit_comp.c file is not
	  present in 4.19

2039f26f3aca ("bpf: Fix leakage due to insufficient speculative store bypass mitigation")
	* Contextual adjustments.
	* Apply check_stack_write_fixed_off() changes in check_stack_write().
	* Replace env->bypass_spec_v4 -> env->allow_ptr_leaks.

c9e73e3d2b1e ("bpf: verifier: Allocate idmap scratch in verifier env")
e042aa532c84 ("bpf: Fix pointer arithmetic mask tightening under state")
	* Contextual adjustments.

With this patchseries all bpf verifier selftests pass (tested in qemu for x86_64):
root@intel-x86-64:~# ./test_verifier
...
#663/p pass modified ctx pointer to helper, 3 OK
#664/p mov64 src == dst OK
#665/p mov64 src != dst OK
#666/u calls: ctx read at start of subprog OK
#666/p calls: ctx read at start of subprog OK
Summary: 932 PASSED, 0 SKIPPED, 0 FAILED


Alexei Starovoitov (2):
  bpf: track spill/fill of constants
  selftests/bpf: fix tests due to const spill/fill

Andrey Ignatov (5):
  bpf: Support variable offset stack access from helpers
  bpf: Reject indirect var_off stack access in raw mode
  bpf: Reject indirect var_off stack access in unpriv mode
  bpf: Sanity check max value for var_off stack access
  selftests/bpf: Test variable offset stack access

Daniel Borkmann (3):
  bpf: Introduce BPF nospec instruction for mitigating Spectre v4
  bpf: Fix leakage due to insufficient speculative store bypass
    mitigation
  bpf: Fix pointer arithmetic mask tightening under state pruning

Edward Cree (1):
  bpf/verifier: per-register parent pointers

Jiong Wang (1):
  bpf: correct slot_type marking logic to allow more stack slot sharing

Lorenz Bauer (1):
  bpf: verifier: Allocate idmap scratch in verifier env

 arch/arm/net/bpf_jit_32.c                   |   3 +
 arch/arm64/net/bpf_jit_comp.c               |  13 +
 arch/mips/net/ebpf_jit.c                    |   3 +
 arch/powerpc/net/bpf_jit_comp64.c           |   6 +
 arch/s390/net/bpf_jit_comp.c                |   5 +
 arch/sparc/net/bpf_jit_comp_64.c            |   3 +
 arch/x86/net/bpf_jit_comp.c                 |   7 +
 arch/x86/net/bpf_jit_comp32.c               |   6 +
 include/linux/bpf_verifier.h                |  19 +-
 include/linux/filter.h                      |  15 +
 kernel/bpf/core.c                           |  18 +-
 kernel/bpf/disasm.c                         |  16 +-
 kernel/bpf/verifier.c                       | 498 ++++++++++----------
 tools/testing/selftests/bpf/test_verifier.c | 144 +++++-
 14 files changed, 468 insertions(+), 288 deletions(-)

-- 
2.25.1

