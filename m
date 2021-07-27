Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F08A3D712E
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 10:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235629AbhG0I37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 04:29:59 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:48838 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235912AbhG0I36 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 04:29:58 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 16R8E2nG004378;
        Tue, 27 Jul 2021 08:29:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=MSNdrlHj47YlTaWn/hGM9Q09HTuUwUfWFXFRYPnc1tU=;
 b=kzFpmTpPUHkOQbO2lctZdupv0tuu10mHavf7nZLIUd9uLBGHmB0JOqX8RcbLH740e6gX
 lKGhIy9+5IzvirZykD/ecPPPJtSMnyDCDZDosrdZZF0xW5dzQkP4c71/mvDWIDr6eNIc
 cs9+2itl8rMPiA6QgyX07t3IJnB982NrllLuduOuG5RIc2Kjzw+kPeWsDHHkry+ZnRGH
 VxhMtI2F00mYtg2MVo9IxEpFKS7FRr1DVxk19rcCewg+QiVE6ywqKVju/L5Il2pIct+T
 wnCfho+RL7ML+buFCb6UW8PSkp3JiZVDeIBI5m9BNbbAJLHByi+qzJ8V14fGbPVzZLW3 0w== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by mx0a-0064b401.pphosted.com with ESMTP id 3a2351gcr5-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Jul 2021 08:29:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jtDm00x0c7/4GRxFyEB3XxgiwtAewXu3rLySLfvebS281o/CyK42Xd8uKnPp/tZeOrvXM7WBLIEwApygCOHkmiorcEZ+Yw3L7csFNvSTGhEDxltr/rFq3ox5YzeFA0UnIOmUxCkWGUNSmpSSrqN3r8AWWMtJBw0gcqdPipALJY0pfq1uEIgArxO+7cC5JGRpiOlpJRz+doIq43V653x6jNbykeatqigvwoMUVO2FBFS5TA2ctDLSZ4HIQxufIPoO60bLBXQ2lwAJECt8UfIt8sPdVcVzp7ycjZT/xUF6G95TST6R31vxZtNWiN3vnRqGs3EonTXMc5iAUTrrNQJEtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MSNdrlHj47YlTaWn/hGM9Q09HTuUwUfWFXFRYPnc1tU=;
 b=dA1IdT8seUegSi6JvRjIr/z6hJWgC8S7bFBOFpMWjjPl84iRyDfq9HRtkPaQdPmCBWtDTnX7TE07E6rL9i5dXRhr8ie7xulfjHC8tvQquXvRWPNSts/+x9nyUPV687iBByma/XZrp9A+X+w5hdF5TzokH4fCz6OPuSs6dnxPWw5huTbSVDkvxoL9oFiAlG8knSf55iGOOUiA4dQjvtarYaM2GqDwb3mT0BwxnNGQcrBPPeHbbocYyKEhO3oUrFEbEMTAoOl6d8muX5Eqj6j2qZPbkiFiLbBe0zrK0ui81xeOBLgWF3GQZoHR+iNMkKlcKDIlhzc2DES6o9ZC04pHTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BN9PR11MB5321.namprd11.prod.outlook.com (2603:10b6:408:136::8)
 by BN6PR11MB1634.namprd11.prod.outlook.com (2603:10b6:405:c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26; Tue, 27 Jul
 2021 08:29:50 +0000
Received: from BN9PR11MB5321.namprd11.prod.outlook.com
 ([fe80::5959:e459:a5e0:5881]) by BN9PR11MB5321.namprd11.prod.outlook.com
 ([fe80::5959:e459:a5e0:5881%9]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 08:29:50 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH v2 4.19 1/3] KVM: do not assume PTE is writable after follow_pfn
Date:   Tue, 27 Jul 2021 11:29:22 +0300
Message-Id: <20210727082924.2336367-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0158.eurprd07.prod.outlook.com
 (2603:10a6:802:16::45) To BN9PR11MB5321.namprd11.prod.outlook.com
 (2603:10b6:408:136::8)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR07CA0158.eurprd07.prod.outlook.com (2603:10a6:802:16::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 08:29:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a61af26-b3fc-4d2e-96a0-08d950d8b350
X-MS-TrafficTypeDiagnostic: BN6PR11MB1634:
X-Microsoft-Antispam-PRVS: <BN6PR11MB16344412673EDFAD2CF7603AFEE99@BN6PR11MB1634.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:478;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YSRoFD+l5qCT407KIbYBqCpmY6lnikMK5Zoxq2UrA3/sHp6qRCTUtFRE/qGvwp6UTAf9jPQiMHHmBbdzSeQ+SPgH6mmhDWshWIGbx6F95VVrU1YiKWj/2RmjoMOb+CFBqqmXp9rfQcW86BuWOjn9RBN9a0Ar1BvKP0NEnv8ozIC4PhYlU9DfOgjWRjwNUiTeo/yhr42cszvIa9jB9vkrX5vtagiCyOKlTYG9tku+VKDMF+IB6KpGeYoDxMN10F7a+JL1SntLhkHgAt0KjTwH4f8lOx3hXXiZb05Hol9JxcTMoFsl0mvRBL5RpYGWSAJRd9ZNu6v44gELQd6/NI8yRH5GMqOPLO4kp3pJpLlexBAVPK1WqTMm45wF2/FgFg/7qnCnebycBQnCCrIdIlKZG6Nh2yrHGZRCPaV0BDTQW6/rhgjIpl/oRxeV1XupI4YsX/7nfjlbd1TKXnOtyyCSj8R863YzlgdOizUj0GJ3laQkhAEKsMiDMr6NyRka5NER205LIfibPtJs5/3b6VZ/uFkj6GtUfn4pDzlC4m4sWvSMmECoYP8VIVeK7Tj4qElNDlqtLTk61r35j+5ZH9PxhHLl4ZKC2RkFiT9e4ZKOMoFNB3L42ynwdhr2rL9lFe1V0Blv9Z5/+urF2oPhCfK1LWpJM+FpBCmgq5v/Da6eOnGSn8ZhmNy+NbJMRVhn1cTN0Q9G0FywPVX108nlhLNkMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5321.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(2616005)(8676002)(956004)(5660300002)(316002)(6916009)(6486002)(52116002)(36756003)(1076003)(38350700002)(38100700002)(508600001)(8936002)(26005)(6512007)(66476007)(66556008)(66946007)(6506007)(2906002)(4326008)(6666004)(44832011)(86362001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3LC+fd1GgHUUEPqEsEORY+X5YqnqeaO69GlLjL0yfk79F8hbdiy8HiFSJi6L?=
 =?us-ascii?Q?v/T6r6D7gCm+dLamHWziMA5xqQxDYGUgAcbkVD9Luc6MZ5FjAAuLovhv1ZCM?=
 =?us-ascii?Q?wvkKoukQvWL/h9bdCxDs7iCzMoes4bNrecVV2jpuVnk1Y2FDlM/8SUsuq2L5?=
 =?us-ascii?Q?Z3R5rjJaup5Fr0qw1FVb46fOBz5JDRslryJDOAXG30vrccSDcFYm8CSUdYzW?=
 =?us-ascii?Q?WOCr7klTbr3os5bjd/Wt3Al9VELs3+oEuAYNfgQMjmhhTEUYgV0YVCrvqWU6?=
 =?us-ascii?Q?LSuwpU1/73cJXTgttOSo1CZuhr8TAen5g0LTj7CdDBw9kLPspXo+s9nveDFr?=
 =?us-ascii?Q?BYFRXua/3EJJUkbXzsEUzySD2bvD8eEmcjg/9kkiVi2aNX56uE3tjcZAkyJg?=
 =?us-ascii?Q?OUt5/BB0x8Zz3S0uvCdeAG9bndv55fcBY6u9ce8jFQJnDmkgvyUqVL3e9SUK?=
 =?us-ascii?Q?ZLkNwEr8q15hW+tqPtY8sQPgZAU4CMR/TMxK6sY+uOgmf7by7PR6dhRbYsHE?=
 =?us-ascii?Q?/PMuWHMFnbs/fJpGtF5vzj8OxvYrlDMnetGKjNadEsK57iz31KfFI7JIPblx?=
 =?us-ascii?Q?VWqqth+ifjMUOvxWRtBLTy+EN8j2ljNOvZRBDN4EH/52MceFkiwvx0v9u5Ra?=
 =?us-ascii?Q?VFYvqVTQcNbiFbbopAUrLtmZXBNNwCMxqEq9xJ3KKxsbpRSReJJkLiNeBU6Y?=
 =?us-ascii?Q?ZiVWGLlk9948xuFZyrpw5Pwlum0q3YvRvbekqMzEw7J6KQEHvr+Sytj3Jlz7?=
 =?us-ascii?Q?1R8V/ALjVoGlVTC0V7KEXaA4dnX47sBWEL5yCOAfYyxPQq7Hiui6nM8aL20Z?=
 =?us-ascii?Q?R7wUV9MCwKIm9A/2QtbYCbpR/1mzbQlEUihtwMJwp9Wls9wQlCz7VQ9hN5Yx?=
 =?us-ascii?Q?CNnpVJYSc+32lVvvhVYXoKu+6drQaZhsmlfgBE2RvDZhSC4n2LTZaN6/T9lO?=
 =?us-ascii?Q?4jxriJoFqEOtsSmObsJmjJPPeVaWujCaV/Fxn2c188oyn/9TNWDXjvyaHI6L?=
 =?us-ascii?Q?viL+2c4CzOj/wtKV89pFjEnn503vnP/ClR5ycXCnAgPiaRGeMYtZRVi/hIU7?=
 =?us-ascii?Q?kvSSFS1HmC0R7CtxmLMzXsFrcPCPRBJFworQGxka58DKWhwkWbHTil1/F7Am?=
 =?us-ascii?Q?9J1Ao18iS2lv7t94lgeHCeMMtpyv8xQkS96Pagwze9XhoGGmIKPYzopaCtbr?=
 =?us-ascii?Q?8e3Ap+FMKpPUO3Tcsulbiuvca5zE/4A+dNcmgfugWp6P47dVoW8ADHRmy8+Y?=
 =?us-ascii?Q?HcZT88T/ZSAAjkf3seLlsbeQCgvqDmbzafW1ZLkS9Imz9n3hB89YV/2cT08/?=
 =?us-ascii?Q?uk4yDuCPIqsr+qhwbKC1Z2E6?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a61af26-b3fc-4d2e-96a0-08d950d8b350
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5321.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 08:29:50.2979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KZq3GLFoiNgtEvBjNNFzdouncXJCwlBdEzS1D5soNYXDooMrb/NwBDuDnBZ6YyuWK8JoodYT+yCfasb9hy9uzUtJaKKErvJiaDjnZHgV+aU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1634
X-Proofpoint-GUID: YBZiaokuhs5Eyj9IbHni0ucF9dicV7xo
X-Proofpoint-ORIG-GUID: YBZiaokuhs5Eyj9IbHni0ucF9dicV7xo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-07-27_05,2021-07-27_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 spamscore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=744
 suspectscore=0 clxscore=1015 bulkscore=0 malwarescore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270048
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit bd2fae8da794b55bf2ac02632da3a151b10e664c upstream.

In order to convert an HVA to a PFN, KVM usually tries to use
the get_user_pages family of functinso.  This however is not
possible for VM_IO vmas; in that case, KVM instead uses follow_pfn.

In doing this however KVM loses the information on whether the
PFN is writable.  That is usually not a problem because the main
use of VM_IO vmas with KVM is for BARs in PCI device assignment,
however it is a bug.  To fix it, use follow_pte and check pte_write
while under the protection of the PTE lock.  The information can
be used to fail hva_to_pfn_remapped or passed back to the
caller via *writable.

Usage of follow_pfn was introduced in commit add6a0cd1c5b ("KVM: MMU: try to fix
up page faults before giving up", 2016-07-05); however, even older version
have the same issue, all the way back to commit 2e2e3738af33 ("KVM:
Handle vma regions with no backing page", 2008-07-20), as they also did
not check whether the PFN was writable.

Fixes: 2e2e3738af33 ("KVM: Handle vma regions with no backing page")
Reported-by: David Stevens <stevensd@google.com>
Cc: 3pvd@google.com
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[OP: backport to 4.19, adjust follow_pte() -> follow_pte_pmd()]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 virt/kvm/kvm_main.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1ecb27b3421a..6aeac96bf147 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1495,9 +1495,11 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 			       kvm_pfn_t *p_pfn)
 {
 	unsigned long pfn;
+	pte_t *ptep;
+	spinlock_t *ptl;
 	int r;
 
-	r = follow_pfn(vma, addr, &pfn);
+	r = follow_pte_pmd(vma->vm_mm, addr, NULL, NULL, &ptep, NULL, &ptl);
 	if (r) {
 		/*
 		 * get_user_pages fails for VM_IO and VM_PFNMAP vmas and does
@@ -1512,14 +1514,19 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 		if (r)
 			return r;
 
-		r = follow_pfn(vma, addr, &pfn);
+		r = follow_pte_pmd(vma->vm_mm, addr, NULL, NULL, &ptep, NULL, &ptl);
 		if (r)
 			return r;
+	}
 
+	if (write_fault && !pte_write(*ptep)) {
+		pfn = KVM_PFN_ERR_RO_FAULT;
+		goto out;
 	}
 
 	if (writable)
-		*writable = true;
+		*writable = pte_write(*ptep);
+	pfn = pte_pfn(*ptep);
 
 	/*
 	 * Get a reference here because callers of *hva_to_pfn* and
@@ -1534,6 +1541,8 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 	 */ 
 	kvm_get_pfn(pfn);
 
+out:
+	pte_unmap_unlock(ptep, ptl);
 	*p_pfn = pfn;
 	return 0;
 }
-- 
2.25.1

