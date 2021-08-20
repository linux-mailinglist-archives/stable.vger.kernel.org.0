Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B6E3F2CED
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 15:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240600AbhHTNNb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 09:13:31 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:26714 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238510AbhHTNNa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Aug 2021 09:13:30 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17KBeBR1023259;
        Fri, 20 Aug 2021 06:12:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=G+OzaO1VTknV32YHPjZ+bEG8pGdZDeCzV6mVD8hZ/Fk=;
 b=kiqkHBHzqolNxgDuDatq6/BzwxgInzizOqKso17wehhS28CJhJ09Bzppt4zZaR54SQb+
 Gr4QeW2WC30+feCcpVg+Az+/SbtOjl5QtxD+yW5YzQcsbISK84IywGDM01EVoEsD5Egs
 jrgG49VgbrDv4KhlNgTxJ4T/2HqUr+UJmm5w/19IZhB5F9vkzRUEWFEGpmLsVYh9NH6N
 74QqMJCwjXUNkmzm8IPXbBhtb+2cQ3bVFZt8BiQskbw4NwAZ8Ar169PcTUD+sPLpRNK6
 5E/uLCMM3vfVL92XDDIjRwdj9QmWwqTrIgCfM+e0BvyFAKC0Q05UUCUk/xEjZJtZGHhW ew== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by mx0a-0064b401.pphosted.com with ESMTP id 3ahtm8gq9g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Aug 2021 06:12:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rzirx10N8a2YWnQZu5gKIb0tBjqhZNrbazFSfOUx4IXqMz6R4bWr9G3uCjSAh1dwmOH18MVwu97UaU42W6bo0xp7VTCMfgke5kPlXEaut+y2HrUHdysGQyVREtgok+1oxMBfwwmNXhpsVdpCFQg7/jzJDE8Kf2G/OpDsuaKm6jwR4FgWF+sJTFmRd0nZHhzYs/HaQe4evZvmF5cF7SCrAZDHPIxDqPDU09U/iPo4wWDDrU88MQzAJDMus619W866Dl95DHcBnUI88xa9C+iyuiuCEDMd1gX4A6JFVHP4YMm/tAjXavZ9/g6RdiwnFt3aUygb1xVM0Ir8IZYuEaRA0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G+OzaO1VTknV32YHPjZ+bEG8pGdZDeCzV6mVD8hZ/Fk=;
 b=lSUROByQxoaR3A/mxTFQxakqx3hcwUiFEav5JEOaj5sAosYiPJv8t4u37GyQPCrxNEGj+Pru2FDN2glBgttdgHbHQXweBl7yxdBAvi5W9rKKKGd1j61TXekOU/AaZsF904CBpGwYEB2fd/rHOidk/YY1ZHrm21+MJPGpsrda7/QsHJLG7jYPNKrwDosKyn2lEJCss5lxuT5VEYFfYUFKdOyVlun5GSMAF1dleJ+TzW2F95w/k9/0NVgm0GZch6ALibjWvjk5LFOdgaa4tGgpAcmjJS9igJCnUrRwQYeLpuD/HYtokp6QloGj4N9wojPfXWdBUFgXM1lCCn1C2RAHQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB3113.namprd11.prod.outlook.com (2603:10b6:5:69::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 13:12:46 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3%9]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 13:12:46 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 4.14] KVM: X86: MMU: Use the correct inherited permissions to get shadow page
Date:   Fri, 20 Aug 2021 16:12:29 +0300
Message-Id: <20210820131229.3417770-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0101CA0058.eurprd01.prod.exchangelabs.com
 (2603:10a6:800:1f::26) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR0101CA0058.eurprd01.prod.exchangelabs.com (2603:10a6:800:1f::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 13:12:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22b1490c-24ef-4fd2-c52a-08d963dc3384
X-MS-TrafficTypeDiagnostic: DM6PR11MB3113:
X-Microsoft-Antispam-PRVS: <DM6PR11MB31131CB0D74A88E816CF492BFEC19@DM6PR11MB3113.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NacToOf5dBmTquSt3sS1PPLwXPnlnDCKdid84ai2KgG73WbnCCSdQZCzv/t6x8Qvqf7NItJll9TzdwgYEAP5eeM6gjQnQ+9HHwf0TQPpkyWxXo2UrSlFgl6KnG17BRpVVImhjjV4tttpfrUCnexZHWo65an8mJbFJQtOdyRDehFW9rkj1qN/sSrdtD9Qu6UHt5rFtlgmPJYNltNApW1qRsqxHn23LKN7kDUOeSiVkztIalJa7pPHpoJ6Fae+fmkkqoCRZUZ0PHZG4QFY8kmwU9ekq89tIij390ZDZu1n4sUCMpXr3FQXjvGpIZMY6CZgCXAtrschrEdMd9e6P1HXZ0VfywhFxfpwqld5jNzzbxJwz4XZacJRZhGLOZtTcj4slmdPamEtQydBofF4GpdQjb4ZE+NMvTilTfroZgHrQWHSFRUNadnPwsVnQZURD+PIGTIoVO3mTD76yta6l4BAuZc1XAR9QPEgcDdmK5j53LaG66wI5mIrRbrEVZpTdIZYoRnVH6Zd6MRkzT4/II2fJ8LC6F2gmrWR2uSUFsV4Vz+Qzt1BLkeglUuhyLxpPbbxGtcDMKws61FRZbI0nCX4SM9e7rMoDpu1gJEv0S/uiTRWWOx/PERvgkNMc7ORbZKBi4rtQakduyUYTjGQKyIEV6y94+BD4T5Ft9pggoA3AufjChvzEnSB+WVaj674j4RwZg4yJmLevwyEmtYNq/r9gB9DR874IogYVa3NxBbLYaRXrP9ESow8NeZ6bq8wK9eteX620FL/LYAFdH/csrShf0L/swSE76GUz9559qhS1/eLKJY+uWN25mxgG8e5Hl+7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39850400004)(366004)(136003)(346002)(396003)(5660300002)(66476007)(966005)(316002)(66556008)(8676002)(8936002)(478600001)(6916009)(6486002)(66946007)(2616005)(956004)(6512007)(2906002)(6666004)(4326008)(44832011)(1076003)(36756003)(86362001)(38100700002)(38350700002)(26005)(186003)(83380400001)(6506007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9Rfu4l0UDPAlyurkOOH18dtJdUUmiaLtGYh0/jX5csSdcBCYI0wru06JT2oT?=
 =?us-ascii?Q?cOIt3pqkfWO0PMmzqNm9LN+ZYKmbsXm3wI/J946/pvL53dz1mlT1toucdwB6?=
 =?us-ascii?Q?E2j2+uRESeMEJOG8YdiS5Z6EBsebsryycMy15UzPBpmsBL1nsxBz+IJyXfZT?=
 =?us-ascii?Q?9ETbGXKLmLWMyseQbSkSCVO4h5HY09gsKmxGIR4I4eKFCiBsmmhOO3B1BTIz?=
 =?us-ascii?Q?sm9+hwJ+KKPM1oJ9E11X0ISbjSlivPZIu44WN22T8FZ+V1Z9tm/2xg+TZWql?=
 =?us-ascii?Q?+Oi6CCWFLaAN3DQ5y64ECgkxoL74Odqoa6Gkkwg1pApgE+7xyVeQS1jAjNZ4?=
 =?us-ascii?Q?OuqOTwl9Feedqt8D4KsanVIXpXGbjStJsYcWKGc53bo1KimOXqfkaqPtiOzE?=
 =?us-ascii?Q?KHOy8/fzH2GsZkcSy5tpobjec4BKBKD0hGjFrCrMivZBGWscWMQw8xQG7WFb?=
 =?us-ascii?Q?edv87fPEIqHu6/OAZes5Wmj2skgJMz+qfq3oCkAs0TMeMMtOcnWiWBCUAsGe?=
 =?us-ascii?Q?7lriVNb2nGQLV7OgNJwjVFWM9hPRQ5h7vzuPAB7jVk6bOthr/wH9SxryIy34?=
 =?us-ascii?Q?gVIGpEYlyRV81yP460ulv/e9mFLum29Gl+TlUHZn4KtRI44DZUL8XcnD4b3U?=
 =?us-ascii?Q?Kl3ob7D1q99pgUBhONPSVZBfpzYsHUGyy/Bc9/D2gnxlsLAvKAGjCWuAb1CV?=
 =?us-ascii?Q?ezRq9bi+ZYxqtiHds1lZXFNBwIVPUvllhPdnVE/C6H8aOccVx7Icbsxtua4h?=
 =?us-ascii?Q?qyVSde8SPXx+iOz0riEMTCXZFczAdWIUYBM4HFo7bg1nYKkTp87b4drKpofK?=
 =?us-ascii?Q?hc12zIc4xCbiDAWW4nKdD6hTaqwdhavvBAFb6ISP1lkh96argnMohQNkBC6S?=
 =?us-ascii?Q?EFEJNm43h0UpLNG1tAon/Apq88jDbg+rxNgBpUtpEhPT10kZYw/SlKVeZcqL?=
 =?us-ascii?Q?P+ffyyqHAYnaVJEagLPOiyfsi7L92yiFg8NNoLa8MvjkMUHFUBBue4O/khvl?=
 =?us-ascii?Q?cFdFGuzfQH2oDT//QI4YG8u/fxCnk8EH6kksqDTE6f7JGUzxBUGs+P1qem3g?=
 =?us-ascii?Q?0gO8ABQvvs2louniQ3DaR299DtkpH4CYhq70WQUa3L5FHJCcvuKVLXaWEcQa?=
 =?us-ascii?Q?+i/1hDGEnJhqGxRHwanVy3ovgyRkRLp72HHnV9XPtehKVyJpvtmanNpWerU3?=
 =?us-ascii?Q?1mz+QWSjQcDAaR7GS6wWP8POa1iBjtIfWnSN0ygg7hvIDNG0r4Z9pW4QYTnp?=
 =?us-ascii?Q?26GixBUy7XBJFOQY1aviVuAz07t67QPzwwVwUD8Sgu2U51EQfpY8wvv7Yxdd?=
 =?us-ascii?Q?iZ5bRCd3DWEsOgV0Z70POTm6?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22b1490c-24ef-4fd2-c52a-08d963dc3384
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 13:12:45.9771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3ROqaunKb9FtlvYAqc98U8XlwVr7Cg/dBHZ4j6uZfu2DqjfY2NmQdPTVbKmhjdflUsHTjdMY430XeVKNfEBWOmcfZIZfOk+d2M8+ZkBBtSw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3113
X-Proofpoint-ORIG-GUID: sB_dTWKpXtLMPFB5nDfHV4isCKvrcON8
X-Proofpoint-GUID: sB_dTWKpXtLMPFB5nDfHV4isCKvrcON8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-20_03,2021-08-20_03,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 impostorscore=0 adultscore=0 mlxscore=0 suspectscore=0
 spamscore=0 clxscore=1015 mlxlogscore=999 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108200075
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
     - add vcpu parameter to gpte_access() call]
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
index 8cf7a09bdd73..677b195f7cf1 100644
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
+		walker->pt_access[walker->level - 1] = FNAME(gpte_access)(vcpu, pt_access ^ walk_nx_mask);
 	} while (!is_last_gpte(mmu, walker->level, pte));
 
 	pte_pkey = FNAME(gpte_pkeys)(vcpu, pte);
 	accessed_dirty = have_ad ? pte_access & PT_GUEST_ACCESSED_MASK : 0;
 
 	/* Convert to ACC_*_MASK flags for struct guest_walker.  */
-	walker->pt_access = FNAME(gpte_access)(vcpu, pt_access ^ walk_nx_mask);
 	walker->pte_access = FNAME(gpte_access)(vcpu, pte_access ^ walk_nx_mask);
 	errcode = permission_fault(vcpu, mmu, walker->pte_access, pte_pkey, access);
 	if (unlikely(errcode))
@@ -432,7 +434,8 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	}
 
 	pgprintk("%s: pte %llx pte_access %x pt_access %x\n",
-		 __func__, (u64)pte, walker->pte_access, walker->pt_access);
+		 __func__, (u64)pte, walker->pte_access,
+		 walker->pt_access[walker->level - 1]);
 	return 1;
 
 error:
@@ -601,7 +604,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 {
 	struct kvm_mmu_page *sp = NULL;
 	struct kvm_shadow_walk_iterator it;
-	unsigned direct_access, access = gw->pt_access;
+	unsigned int direct_access, access;
 	int top_level, ret;
 	gfn_t gfn, base_gfn;
 
@@ -633,6 +636,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 		sp = NULL;
 		if (!is_shadow_present_pte(*it.sptep)) {
 			table_gfn = gw->table_gfn[it.level - 2];
+			access = gw->pt_access[it.level - 2];
 			sp = kvm_mmu_get_page(vcpu, table_gfn, addr, it.level-1,
 					      false, access);
 		}
-- 
2.18.1

