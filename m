Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6243EA99F
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 19:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236396AbhHLRmY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Aug 2021 13:42:24 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:45400 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236065AbhHLRmX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Aug 2021 13:42:23 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17CErLG1030867;
        Thu, 12 Aug 2021 10:41:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=hf3+lvzUfc/HxY2LoWPCGSNp1yzzNk+drTfsgabFduQ=;
 b=E2BAz1fj+bb5ofzTMekDFYWy1pN5B45Gx4AeEa6QZovb2ki6IaqWzHw//Zr+OIxkM//N
 9dheTCBCdjDCMxj6JS7xVCqE4xvSRTha+JONIQnxSFzuRxP6bSKjcUL1z8MDg3dyVBw7
 mn36c70msv2L+LDHEMQv+Vpmu6dfubBFiUfmeayqjqBG62/uwBO/qJxaGgwAYxxIsSVi
 SZjmWxlaBeEadZTWQPelqCNCvuAIVmga8YngQK1PrISw2y4VqWG+660Zs5gkTscDdZin
 ekoIG2knFgNMAu07igQ19uF/pWDjT8Lqe9FKg78vezjzc1v30Ocl3hUT0f6r0disivBF 3w== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by mx0a-0064b401.pphosted.com with ESMTP id 3acucv0hta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Aug 2021 10:41:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iJVp/Ra0kA+j/Tz/PZtY7W3Osp7zKD5de5+v2WXpCPe/eJoZ1TpengfRNzKa74qPYzHSD/VT4UHGdIfRa8i+8blFNk6sCn1fxuiTFMPSZE/8cug1sGTviV7DwbUMfd22P752NQ5rOrLo7vEqi2CDIWzQFqWVUhZLnbg43QMZCPYtZzOt1HNf6zceHDzs2EHyVAhluXGowTwKjMqAYXSV9Y9dssxe/p6q+/792bJTsk6lYiyWVzlSrc5uw+VAZOx8L1R4M7x+MqhQK3rDhYkuc5n6MRFbVopWlTMUZrerhpSTqm+ZNv75LzDngW+x+PBDHUbUO6/x1NsAc1DTE4pOmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hf3+lvzUfc/HxY2LoWPCGSNp1yzzNk+drTfsgabFduQ=;
 b=T13n6Hhurl45+gJqG93yV0SfqdBeKbZ7wY8L9/Klw5PPsGuvonF02uIZjQQvTC6PT1t742Lv/TRr2HO/hVD/ljA22MSKf0hGlFPRVYs3JaMFlHxWuzN/c4SjGO6uCtD3wthoCOsOJKCCyxXxTVtXKd/up7XtKwBEs9TtX1hmL1ucprPV06Uno7RKUiC3oeiQ2NjXFtUWgblxQJc20asDtkuMwCl6CMZ7o3z9Zs3ORV8on/cX3W2PZ8MP8E7bRAA0A6eZqCAlAf+OmKqK/Jlot6sV/k5vCx4A2OAzUvmHbvYJ1wUHCnIF+9iazh20jGyZZN/Fc5BPVYdtK5r54t0lZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM5PR1101MB2204.namprd11.prod.outlook.com (2603:10b6:4:58::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16; Thu, 12 Aug
 2021 17:41:54 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3%9]) with mapi id 15.20.4415.018; Thu, 12 Aug 2021
 17:41:54 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH] KVM: X86: MMU: Use the correct inherited permissions to get shadow page
Date:   Thu, 12 Aug 2021 20:41:40 +0300
Message-Id: <20210812174140.2370680-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0096.eurprd08.prod.outlook.com
 (2603:10a6:800:d3::22) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR08CA0096.eurprd08.prod.outlook.com (2603:10a6:800:d3::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Thu, 12 Aug 2021 17:41:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bbf54f39-a0fc-4439-dd3e-08d95db87972
X-MS-TrafficTypeDiagnostic: DM5PR1101MB2204:
X-Microsoft-Antispam-PRVS: <DM5PR1101MB22044FF2F179CC3BED611062FEF99@DM5PR1101MB2204.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0lw33iiD7qxoZYsnBGZG6AlUaf81nzURxzSfisVAhyS9wrhVHh9iQGR/frsyl5RJu4+q/VXB+gPOFymuJ4NYvAW2Zr2+g2sfWzzLan5XUhIicFsJaJfInylsClD5SvMqinUVr44YdbNKlSMn+dIz9LZhFdSSpANP3CCyI7aAJhU3qPM0DPOHYhcmpYlXrJkVI9NbBej2Q8UCFBS7nd2s5WTAT6DMsQfdI8oCBpa9V+loAY+Yqjsry5Jlc3k2gsv75cfQ61hPExLVWgxsl+YBw6bKBqBtMBAaCIL3cuyC1bd2B18tP+88JOBC+owRvs7EM4GVnxEzpcA4NwY6tOewzV9uO3W/POOX6FgzyGHckvD/uSj8XJwFZnxnUoWGIwZs/m6+A26yI4jUX34QLz/S/9pudxcPAJnCjlHO2XlvEnScAYovwVSdU/1UjdrvHvXMTLiOnvgGyeC7EwBwUO93sjFMVhpnDhT1JHicwDAzEMWw4+hgR7X5s/uA0XYh3yG1PpOz/k8oKMpVQlqSQcykfKPflMh+MMUjNOHUzCTgqVjJg8OrCpPjiWBS+OvbnDGrgAp8uGDDo/GtRQQnQPJCyW0peb66h/7B9nhNT0JzSZsXMwGcW9XvBHyRgl+/kUywcAJzBJTCxFlHdOjqZPqP9mpXtW31eTos7gB2JOcfSdZSI1Li6FxeZiBlkZe4m0tZexrLyL7WnTAUgVZ5o0BQrWYFv7DHmIkkLoq+fGQh61pCBIUPaTKBCRgn9k2gSSwRGRSxl7ugGaHruS+6cZ5x5Gml0M5MNAb99PS/iPzrordQyAUshOyXH7NpPClLIbdvHybuG5Sm8NPmxjHdLnhHfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(346002)(396003)(39840400004)(6512007)(1076003)(6666004)(8936002)(2906002)(66946007)(6506007)(86362001)(478600001)(186003)(6486002)(26005)(66476007)(66556008)(316002)(956004)(2616005)(38100700002)(52116002)(966005)(36756003)(8676002)(5660300002)(6916009)(83380400001)(38350700002)(44832011)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aQKFUaG5/pAnOYL8UkimQOsgMAYRwbPJHXVliIBLOxvNw0u0D4RFTl1kxGgZ?=
 =?us-ascii?Q?o5+J9fAetOSWHhUTQq8gZWrl5RJeFEj13h+XZiw+3tlN6a/4QWgZFKfdUPvs?=
 =?us-ascii?Q?Ca1HLPTR18sWhDZjZJ1hP3fSzf76kKK6J/cWWTgU2bzmMLeCtsTwibS9taLW?=
 =?us-ascii?Q?ILmKAIuzAaZwjNvVzU/KE9SNxixwqjcIYOkpz6f0vRRwNERyTpqHgO08yIJe?=
 =?us-ascii?Q?jWS45BAvrekIlaIQeWF3Ccno5ESOsd/iQtp9ls3rnIJcWAgMJ0p65gj1u5GK?=
 =?us-ascii?Q?tiqmmNG/0wVTg/tOv+FMx6kx8AoW55V0+IELcTjp6Z/q8G4XPWozLFy34rE7?=
 =?us-ascii?Q?2J2mHA35nLI7b4f4xiWatOTgSu52Xcq9R1r2w41bzfxlPkpMbu7bsTq2CdEl?=
 =?us-ascii?Q?+Ga7ruG+U5z95xSLiCo+nr8QpZ9gMxuiFjs4a9TDbwGLWAlzxJQRn3/Q3ZVQ?=
 =?us-ascii?Q?8w2xIWhX1nuL3GswN4+kMzcsy2MjDT2hw3Oi2SG4BwEMRpbJvlzwb3NYuek2?=
 =?us-ascii?Q?jgf/u5GpjRXCNU+ISIQ+MyoL7U6W2mBYGqlGwwATQyizhBhnFbctAV5Pt3hF?=
 =?us-ascii?Q?M3xUnQ6qHWWXiTxA1wtoROc+tpcF0fQTppxM/6jDKs4ODMzfw7DtDZCg6z5j?=
 =?us-ascii?Q?hOBJePYQzBxERxKO5etKG0SL0V5siRhHHAKeqLbLl2pZf/72R0xH6oHV5rRO?=
 =?us-ascii?Q?vYGdG+VHVMTL4uOnElsn3IvL01xosn38AOCYQrE0e/sa51eHgX++wCwl1PCy?=
 =?us-ascii?Q?WG1OKLloHO3wBq86wVuMRNCuLYCbWBZZ9io7wcpE0MsouMa0DCTuGAf4ju2i?=
 =?us-ascii?Q?9qggYmQgM+rlMhwEUZDt10I4zzjCPji+spdbXqs39qwXgOprD07K11XSkh6+?=
 =?us-ascii?Q?xLU02k29P/TNg1pTAM/m5fe+v9gun+9QiFYehxe51+WU9Y9lsjOc0EOVkxbH?=
 =?us-ascii?Q?LFT3I2voBJEW84XiYMO6lu4cS7PeqmxRSDVtR0RwuXAtbIpFNZLC4M6+Yf7u?=
 =?us-ascii?Q?lS2lex6QRlXY2jhAyNanIH0FUSZ4OVLy2Oa1mCekbZz/1369g45MdEH2Mslv?=
 =?us-ascii?Q?MF8UXF3S2PLdlxGHQKCUCaGQV7PAAA9LS+vHmxxJ/9jppOa4H0lIpnlNWgkp?=
 =?us-ascii?Q?VHZZcYE4Kmi9IgDh3WWIKtMxuWmwdbldZHNA4sbGw+z1KVD6rBoVKP64y/yA?=
 =?us-ascii?Q?9CK8MUMP9484921HLQjviBnhaM+IBrexbS4TZBYugW0TK9gBEPl5WbOuvt5L?=
 =?us-ascii?Q?O/si7fQJRtfLWyVTvzxirqi1BgrdD+B2odnfn2AmnKp16kgVj2E/UuGEiYFn?=
 =?us-ascii?Q?ZoJUGVKqeDcKWxNarP46ra8w?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbf54f39-a0fc-4439-dd3e-08d95db87972
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2021 17:41:54.3707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tWwqpFgsS9wFXI7W1pW34/F29aZGut3tivZufofDNuKtKbpo9asnx8pIQy9H8/LIqIVGMkSLY1it+YBkxlILEt1P1kkdriiezUhWVB6Avdc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2204
X-Proofpoint-GUID: K7K7uPaFVh7Ik46cgn2cTbMEFpIjn5pP
X-Proofpoint-ORIG-GUID: K7K7uPaFVh7Ik46cgn2cTbMEFpIjn5pP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-12_05,2021-08-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 bulkscore=0 clxscore=1015
 spamscore=0 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108120115
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
     - apply documentation changes to Documentation/virtual/kvm/mmu.txt
     - adjusted context in arch/x86/kvm/paging_tmpl.h]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
Note: The backport was validated by running the kvm-unit-tests testcase [1]
mentioned in the commit message (the testcase fails without the patch and
passes with the patch applied).

[1] https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/commit/47fd6bc54674fb1d8a29c55305042689e8692522

 Documentation/virtual/kvm/mmu.txt |  4 ++--
 arch/x86/kvm/paging_tmpl.h        | 14 +++++++++-----
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/Documentation/virtual/kvm/mmu.txt b/Documentation/virtual/kvm/mmu.txt
index e507a9e0421e..851a8abcadce 100644
--- a/Documentation/virtual/kvm/mmu.txt
+++ b/Documentation/virtual/kvm/mmu.txt
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
index 8220190b0605..9e15818de973 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -93,8 +93,8 @@ struct guest_walker {
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
@@ -388,13 +388,15 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
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
@@ -433,7 +435,8 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	}
 
 	pgprintk("%s: pte %llx pte_access %x pt_access %x\n",
-		 __func__, (u64)pte, walker->pte_access, walker->pt_access);
+		 __func__, (u64)pte, walker->pte_access,
+		 walker->pt_access[walker->level - 1]);
 	return 1;
 
 error:
@@ -602,7 +605,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 {
 	struct kvm_mmu_page *sp = NULL;
 	struct kvm_shadow_walk_iterator it;
-	unsigned direct_access, access = gw->pt_access;
+	unsigned int direct_access, access;
 	int top_level, ret;
 	gfn_t gfn, base_gfn;
 
@@ -634,6 +637,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 		sp = NULL;
 		if (!is_shadow_present_pte(*it.sptep)) {
 			table_gfn = gw->table_gfn[it.level - 2];
+			access = gw->pt_access[it.level - 2];
 			sp = kvm_mmu_get_page(vcpu, table_gfn, addr, it.level-1,
 					      false, access);
 		}
-- 
2.25.1

