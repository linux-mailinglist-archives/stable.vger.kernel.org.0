Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A74153E94F6
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 17:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233215AbhHKPrz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 11:47:55 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:33438 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233609AbhHKPrY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Aug 2021 11:47:24 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17BBXV7n016127;
        Wed, 11 Aug 2021 08:46:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=KzCR+MS7hd2eujwdFW3OIKiVUEAR0ALmMnj7KjqXF7o=;
 b=ZiCelerHL64P/OQ/yG0M1g0JKrd5Y560Tlbf/G3bDMMG5srjPHuxsu2m5dYoPDOKRLZ3
 DRFp39dTwmPokoTVN6KlEiwWHZWIavp7g1PlD51r9Bkvyifkte87D2J7rIxjlL2Loj6o
 U0OHPitDbKC3h8FPnUmLm3vIHQACe2zIfECZbGN8AroIe3NaxuqEeJpuQLsq9O0IRDFs
 CojW6ZD3625yToko84Y7JwxKxVroyAtUQqYzidT7S8Twx3cl3JvMF0DGBfFO7hNC65iR
 +9/Gv5JrQh5pksDEbtxqiCVh5nRH9eG3jX6d3Yd4AF89uN42mQYu7X3kWPxnCjk3UIi9 PA== 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2040.outbound.protection.outlook.com [104.47.73.40])
        by mx0a-0064b401.pphosted.com with ESMTP id 3ac2xf8gy8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Aug 2021 08:46:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aXf4JZM8FiUU/WS9cc/2vqsUn5h+vaiDd5Q/yF1QE3PGq/WWxmC7a5I0VDYgxzBGMXXyCu/llz/bf9Q5BfJOwCHuNBh5n688t3lq6f2No8ScV6VRzrnPCqQtHuIh6zHC4fcIb6Osduzz44a58ryX5/N6O07fRoZQ91hX6jaHaGQEORnbpfiR3h1zzLj7PiAiJxCBO+Adu1dd0zTPNmLjOn6NN5xTTAjvZrNzj7kL3bYAfsmrmHO2ApOqFvL/BKBls2NXX4j7TUMr5eg9874ZxtAaa3Y5ttP7QMjK8CUjOOUwK59e7qDv366vtk12Xcj8AkTFE411S0k2AOULBCoLEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KzCR+MS7hd2eujwdFW3OIKiVUEAR0ALmMnj7KjqXF7o=;
 b=g/vI9+W0G8os4WO9whXXS5e2913AcoWv0XnWclqXnVAuPw6jLg35vATqXCzfmh3/PADfj+Mmkdjy/aiqOVTniBjbmRduBnKlEZ4jkYhRGhKuq5FFYo40n91ZKHxPS9xhD7Soqj36+NWooOY7B7rlkCJ1xEUDJdX2F96ynr+CCMjT71bbNdhNvaBMA9/8mC7aEvEKGq180qfe2oeI/fBYnXV5A7/ZTIbZQmSjPujpNmVg5MopKbwb/Z3vahzowr1f6r61e6NFUbTYz0LFMySKfKrMJ6CFPmDO7UshJl2O100rMbYmUnbdk7RExGRbsvCgir1JjOFlUsstUij/IDwL8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB3852.namprd11.prod.outlook.com (2603:10b6:5:13a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.20; Wed, 11 Aug
 2021 15:46:47 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3%9]) with mapi id 15.20.4415.017; Wed, 11 Aug 2021
 15:46:47 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     pbonzini@redhat.com, laijs@linux.alibaba.com
Subject: [PATCH 5.4 1/1] KVM: X86: MMU: Use the correct inherited permissions to get shadow page
Date:   Wed, 11 Aug 2021 18:46:29 +0300
Message-Id: <20210811154629.2104425-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210811154629.2104425-1-ovidiu.panait@windriver.com>
References: <20210811154629.2104425-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0278.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::45) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR07CA0278.eurprd07.prod.outlook.com (2603:10a6:803:b4::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.8 via Frontend Transport; Wed, 11 Aug 2021 15:46:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 440c5b5d-c968-4e86-6eb4-08d95cdf3a5b
X-MS-TrafficTypeDiagnostic: DM6PR11MB3852:
X-Microsoft-Antispam-PRVS: <DM6PR11MB3852FF9CCFBC6766F0EA4EF6FEF89@DM6PR11MB3852.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZJr+++5qsmwx4lfIWWx2BG2vXam+MIgA79QQZPGk34Q3G4xcB5CGEZFPDYJK8ztuJmKore8M+xpr716PlxI4LTFe/MeN4m1AVuasjwgtAXCc16GPcdetIDbV0bVe2ssbVKzQ8ohn/hom5J7vrUf/m2alZxsyc31bt9ajcH95oHRf0A0Slz1aPtjRXnaEvWXF3L3exIzuNta74RAsXGBB5LvN/Sc4xaYFw670MfVmTRZqXVlq3HzzIDYMFhJvxIYe+fvfPW+2qqpp/nLbUaWK3Hro1sUOT+Js6IwRMqX55ynIuhlAKuMKv3Uv1t6ojM26sD6uxhZivTWN+Icotq3jtWkRV9BaMZWqbbYLC3UE22j149XFBjgVlU7NwS4tXgkMJeHBiBJRmcal9yx3SWb0JRDhz/lRhJA5nTc4JYMvxVDa/Tn+8q1+vm8nqUtpOpQvLACFhmyFrHFYb5Y/I7WS1Wtb+kEqQJvATtZ5JrhLEVshcFH17QsyMbLKoSjUkItgdYp0lA5ON1G9cn+FfEw3JTpCSJ9omFlHusKA+vfHVba/QRLgo6uIjknAOfjPFqFLKHc9muL9T2WKEzA46GNtW0V3PL4H39JQdIN6gn9xY4GIrWv8xFmBCq40KL401Zvh3zAFTyLJJIhNmg2YMCJZ76IF4z+bnfXgN+VSh5oKuYMwDkYpZXMuqOy2tU4khNXm56XHBuAKPSJGu1x9YJHG5y3M+jTzWTwjtgpuhE4M12WgZZEDGkNxC1wwOyuuhGHcCMsHDJgCdzYU6I7rTuWsVpSFZX9wYb/k78o1PPXupQE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39850400004)(136003)(366004)(346002)(396003)(186003)(83380400001)(316002)(44832011)(6666004)(8936002)(8676002)(26005)(1076003)(38100700002)(38350700002)(86362001)(36756003)(956004)(2616005)(66556008)(478600001)(6512007)(6506007)(4326008)(66476007)(966005)(5660300002)(52116002)(2906002)(66946007)(6916009)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?V597jT6RC+trADi++yqfHk5zG7TYKmAZ2E8aHJ7vwJIZoNDblOODwUBdx+y/?=
 =?us-ascii?Q?M1l08uattvCcwaafBfRIo0y6WUKTEhoD9ijUVnCl9OHeNd2f0O6ZBvuTzCuq?=
 =?us-ascii?Q?0LvWwhoF+zhomcRJITX+Y/ZLMCCcvhVo2SaXm/c1E6v2m7drIx72poqsHE4B?=
 =?us-ascii?Q?P3yA1mEzCeZyusEQ6XsIGIKZ5H5WR4AJEnBORWb9eSgi7oI9yKM++5v7qNwb?=
 =?us-ascii?Q?S0WG5+nQliDtnLy1e7L7gRAubcE+dhTn5Dmfdlwg4O4D10snDChHzx2m032T?=
 =?us-ascii?Q?mFVI76/zlTqNT5FpDFcK+mppB5jlgNLEiw3pwVGcBSIKpbeWPm9uCOuiW4ZD?=
 =?us-ascii?Q?0n0JVrJeUTVhEK1K9Rz14iMxOuwIXZgpit/114iaj1TkhtbgetL77ke6RzdD?=
 =?us-ascii?Q?o4ZhCO9wD1p5aBPp4r2Ztnsy2iloAZhP43qu94n5DmG755rluQBbvYrBxOrb?=
 =?us-ascii?Q?EXsW8ELAXnHSEQV3qBI3esiW+XNii0jigBhXKlxwIkB6CGA2UeCgr5btYZuN?=
 =?us-ascii?Q?iOlQaIOwopeUbS6V+flGL4BQUpL7EsN5991axUpBN0BxMZskQXuYmEveUVs0?=
 =?us-ascii?Q?Soj4Z9MPRGp9KWrSnq+17CDshzDQjYG22IxQ0gR8ff2I4qRfXQqHBY/e9RQ3?=
 =?us-ascii?Q?H0W0R+csHcgGdK61CHDvogPHvpb4IvZCuHLKN+33RvlsTAz3OYX2Qa4uSq6G?=
 =?us-ascii?Q?BdkpH+5ZkOXeiIybULO5ShPc+ZoYUewtMwxnGFzzN4XXfFBypBTCraDg1K7h?=
 =?us-ascii?Q?ngNvJr51VEZujfCEjU22JS6b2lYmwZs3FDOEeQijwv6BzsdYifpaouMbZWeV?=
 =?us-ascii?Q?FQYlcRY1w/I+teQ/mjKtd+75EgSqhQRy42cUzurZylzUTljqHUgYLvndOWVU?=
 =?us-ascii?Q?DGsRvchf8/lE1bg+vZNI16xMBbxoA3RE4A8O7K3GZMfYx69aKN+soC1ESBkD?=
 =?us-ascii?Q?9bCUUEuhK2Sm5svqPBvzq4SYh9aD+ZtJn2BirGZ1I7tl9SCpA9Aigg1wVFad?=
 =?us-ascii?Q?wmQot5uT16JCm4mQ5RjPHDODUjQLghI3v40fp5PsYQEioch400bytXnxDyIY?=
 =?us-ascii?Q?tPnIiFZaADAb8MRfc6iLGpPF3pYDNx2b9wA6qAAih/y5t30zypDTFsriM5AJ?=
 =?us-ascii?Q?JdUc0i86rj1vFhw0cQ7g2jYlWqEQBTkYreXNstOVzJ19uVSANPzkfIvk+yY9?=
 =?us-ascii?Q?nX+0JSsAq4AuTqgdVftwsPaRJTIUkmIeTgQNp4tQwBIMI1x79MrDebh1fLGo?=
 =?us-ascii?Q?L+QGTRjd6zFKrLYCVvmi982kgdZRSudUTmuLYDGEfmJT75G2YN9ECfY5icX3?=
 =?us-ascii?Q?P2do9N2U7sh9PF4eQzgI67Af?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 440c5b5d-c968-4e86-6eb4-08d95cdf3a5b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2021 15:46:47.7274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qZfeyp8Z6TiiV3yi/SJ5SnZ7sOavm2DeHnJCC0uEcqPezbQ5y4c+BuG72NDQhlfjruJBRPQvzaekyG4kE7fE0deuhZVI5CSkJYj1vF92I3k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3852
X-Proofpoint-ORIG-GUID: YjMxmgOEpSOgI_EYWNQZ0ux2-shpyrB0
X-Proofpoint-GUID: YjMxmgOEpSOgI_EYWNQZ0ux2-shpyrB0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-11_05,2021-08-11_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 clxscore=1015 impostorscore=0 bulkscore=0
 malwarescore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108110106
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

commit b1bd5cba3306691c771d558e94baa73e8b0b96b7 upstream.

When computing the access permissions of a shadow page, use the effective
permissions of the walk up to that point, i.e. the logic AND of its parents'
permissions.  Two guest PxE entries that point at the same table gfn need to
be shadowed with different shadow pages if their parents' permissions are
different.  KVM currently uses the effective permissions of the last
non-leaf entry for all non-leaf entries.  Because all non-leaf SPTEs have
full ("uwx") permissions, and the effective permissions are recorded only
in role.access and merged into the leaves, this can lead to incorrect
reuse of a shadow page and eventually to a missing guest protection page
fault.

For example, here is a shared pagetable:

   pgd[]   pud[]        pmd[]            virtual address pointers
                     /->pmd1(u--)->pte1(uw-)->page1 <- ptr1 (u--)
        /->pud1(uw-)--->pmd2(uw-)->pte2(uw-)->page2 <- ptr2 (uw-)
   pgd-|           (shared pmd[] as above)
        \->pud2(u--)--->pmd1(u--)->pte1(uw-)->page1 <- ptr3 (u--)
                     \->pmd2(uw-)->pte2(uw-)->page2 <- ptr4 (u--)

  pud1 and pud2 point to the same pmd table, so:
  - ptr1 and ptr3 points to the same page.
  - ptr2 and ptr4 points to the same page.

(pud1 and pud2 here are pud entries, while pmd1 and pmd2 here are pmd entries)

- First, the guest reads from ptr1 first and KVM prepares a shadow
  page table with role.access=u--, from ptr1's pud1 and ptr1's pmd1.
  "u--" comes from the effective permissions of pgd, pud1 and
  pmd1, which are stored in pt->access.  "u--" is used also to get
  the pagetable for pud1, instead of "uw-".

- Then the guest writes to ptr2 and KVM reuses pud1 which is present.
  The hypervisor set up a shadow page for ptr2 with pt->access is "uw-"
  even though the pud1 pmd (because of the incorrect argument to
  kvm_mmu_get_page in the previous step) has role.access="u--".

- Then the guest reads from ptr3.  The hypervisor reuses pud1's
  shadow pmd for pud2, because both use "u--" for their permissions.
  Thus, the shadow pmd already includes entries for both pmd1 and pmd2.

- At last, the guest writes to ptr4.  This causes no vmexit or pagefault,
  because pud1's shadow page structures included an "uw-" page even though
  its role.access was "u--".

Any kind of shared pagetable might have the similar problem when in
virtual machine without TDP enabled if the permissions are different
from different ancestors.

In order to fix the problem, we change pt->access to be an array, and
any access in it will not include permissions ANDed from child ptes.

The test code is: https://lore.kernel.org/kvm/20210603050537.19605-1-jiangshanlai@gmail.com/
Remember to test it with TDP disabled.

The problem had existed long before the commit 41074d07c78b ("KVM: MMU:
Fix inherited permissions for emulated guest pte updates"), and it
is hard to find which is the culprit.  So there is no fixes tag here.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
Message-Id: <20210603052455.21023-1-jiangshanlai@gmail.com>
Cc: stable@vger.kernel.org
Fixes: cea0f0e7ea54 ("[PATCH] KVM: MMU: Shadow page table caching")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[OP: - apply arch/x86/kvm/mmu/* changes to arch/x86/kvm
     - apply documentation changes to Documentation/virt/kvm/mmu.txt
     - adjusted context in arch/x86/kvm/paging_tmpl.h]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 Documentation/virt/kvm/mmu.txt |  4 ++--
 arch/x86/kvm/paging_tmpl.h     | 14 +++++++++-----
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/mmu.txt b/Documentation/virt/kvm/mmu.txt
index ec072c6bc03f..da1ac6a6398f 100644
--- a/Documentation/virt/kvm/mmu.txt
+++ b/Documentation/virt/kvm/mmu.txt
@@ -152,8 +152,8 @@ Shadow pages contain the following information:
     shadow pages) so role.quadrant takes values in the range 0..3.  Each
     quadrant maps 1GB virtual address space.
   role.access:
-    Inherited guest access permissions in the form uwx.  Note execute
-    permission is positive, not negative.
+    Inherited guest access permissions from the parent ptes in the form uwx.
+    Note execute permission is positive, not negative.
   role.invalid:
     The page is invalid and should not be used.  It is a root page that is
     currently pinned (by a cpu hardware register pointing to it); once it is
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index a20fc1ba607f..d4a8ad6c6a4b 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -90,8 +90,8 @@ struct guest_walker {
 	gpa_t pte_gpa[PT_MAX_FULL_LEVELS];
 	pt_element_t __user *ptep_user[PT_MAX_FULL_LEVELS];
 	bool pte_writable[PT_MAX_FULL_LEVELS];
-	unsigned pt_access;
-	unsigned pte_access;
+	unsigned int pt_access[PT_MAX_FULL_LEVELS];
+	unsigned int pte_access;
 	gfn_t gfn;
 	struct x86_exception fault;
 };
@@ -406,13 +406,15 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 		}
 
 		walker->ptes[walker->level - 1] = pte;
+
+		/* Convert to ACC_*_MASK flags for struct guest_walker.  */
+		walker->pt_access[walker->level - 1] = FNAME(gpte_access)(pt_access ^ walk_nx_mask);
 	} while (!is_last_gpte(mmu, walker->level, pte));
 
 	pte_pkey = FNAME(gpte_pkeys)(vcpu, pte);
 	accessed_dirty = have_ad ? pte_access & PT_GUEST_ACCESSED_MASK : 0;
 
 	/* Convert to ACC_*_MASK flags for struct guest_walker.  */
-	walker->pt_access = FNAME(gpte_access)(pt_access ^ walk_nx_mask);
 	walker->pte_access = FNAME(gpte_access)(pte_access ^ walk_nx_mask);
 	errcode = permission_fault(vcpu, mmu, walker->pte_access, pte_pkey, access);
 	if (unlikely(errcode))
@@ -451,7 +453,8 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	}
 
 	pgprintk("%s: pte %llx pte_access %x pt_access %x\n",
-		 __func__, (u64)pte, walker->pte_access, walker->pt_access);
+		 __func__, (u64)pte, walker->pte_access,
+		 walker->pt_access[walker->level - 1]);
 	return 1;
 
 error:
@@ -620,7 +623,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 {
 	struct kvm_mmu_page *sp = NULL;
 	struct kvm_shadow_walk_iterator it;
-	unsigned direct_access, access = gw->pt_access;
+	unsigned int direct_access, access;
 	int top_level, ret;
 	gfn_t gfn, base_gfn;
 
@@ -652,6 +655,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 		sp = NULL;
 		if (!is_shadow_present_pte(*it.sptep)) {
 			table_gfn = gw->table_gfn[it.level - 2];
+			access = gw->pt_access[it.level - 2];
 			sp = kvm_mmu_get_page(vcpu, table_gfn, addr, it.level-1,
 					      false, access);
 		}
-- 
2.25.1

