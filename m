Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 806983DEF67
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 15:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236195AbhHCN4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 09:56:24 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:18330 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236128AbhHCN4X (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Aug 2021 09:56:23 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 173DhTCL023855;
        Tue, 3 Aug 2021 06:56:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=rwJrtBCb6mGvrcMntLalaeMbzHQKcYN2N1IzmmisL1o=;
 b=heg16l8bU5HCaRtrmRiDf6Go5lb42SXImlOwFAhToX9dZQ5+vodoRdQBLlf8NYSc0+Zh
 4jr+oCcp+lCCFj96zHoOKhmtwou2/EptF/oto5IT4i5yeZmqHfvFdwJulJBA6jLdDpG8
 RUAgDUVHOK6cqs03p1mbzDNTvebsLZshiJ3vSL1neXZDm4pWb4fGv/WOKx10C0yuo3MT
 A1BUxBoDiXxRxwptOGpMyQ3BSm1ferUKNWLEaN+qKYLwBHxFpY48o8St7krs4sbUaM+Z
 8Sja4lYcjPG6Sgq9842LKzBJE8nPWOO5i9GrcsNok6Q100eYQNh4y4EmNsHeXYZBLI9R hg== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by mx0a-0064b401.pphosted.com with ESMTP id 3a753s02rk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Aug 2021 06:56:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n3MTRezNsCfiEBGzlDggaxJiVib2BeSMSDIeTxctaDI1m/pYOuazcBOFHIvw/VXeyQwQ0GjiXjH8oz7NTD8wUOetOdk79IpWJq8a64ibM+8Z/XUfXwKIDYfrCvL7mMxgGlv2kzr6jm0BTi1IGBkXVn1voVttgmiVnZv1siCT78HV3aSSJE/37kWu9g3K2IGC249aiDJhRV/21UK9J+i+CnMfyllbkCQ1l+9tPXtuuJdk0Arzyadk5GFfnCCQHm0Si6vXlVovdgbr5PC4BZXUOvLZVYlQ0iHT+p0WjpUr49XW14VSCuzRJ3EW1YW0IjNYeHpIHHNtYo1KS6chrYAjAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rwJrtBCb6mGvrcMntLalaeMbzHQKcYN2N1IzmmisL1o=;
 b=BqoiFH6Wp9v0PHKzG6kxCCvfXIt6qIAhudoXC2T0No4OxG67nS9R6qkNThbf6WUyf6TRKAYF7nXq3fAQ40ruCJl5qlc9q1H87gJTm2ZjycfQUvFp17pNHzYt2/j4wg5wL+D9+ILrSOuNlNIfEQR4BNVUTLOZw9tLqDMY5V4UiB3w4FeM8fHLmgu0yWxOtcDH0OmdP7AY39GS20pG3SDaJQGBytlFzPrSf4eVK1Syjb9njuGd7Fqpn747hl/apLxWCutIYTuP2g0ksaCcLF/iNB/rk9mhpt93h7ioOLREtbEqJORb4XZl2rYjwWAAPKVxQI3you9kyEoYsVx+d7rKQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM5PR11MB1497.namprd11.prod.outlook.com (2603:10b6:4:c::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4373.22; Tue, 3 Aug 2021 13:56:08 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::dce0:cf03:275:4b3c]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::dce0:cf03:275:4b3c%2]) with mapi id 15.20.4373.026; Tue, 3 Aug 2021
 13:56:08 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 4.14 1/3] KVM: do not assume PTE is writable after follow_pfn
Date:   Tue,  3 Aug 2021 16:55:19 +0300
Message-Id: <20210803135521.2603575-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0159.eurprd07.prod.outlook.com
 (2603:10a6:802:16::46) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR07CA0159.eurprd07.prod.outlook.com (2603:10a6:802:16::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.6 via Frontend Transport; Tue, 3 Aug 2021 13:56:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e79450f3-966a-4d56-048d-08d95686716e
X-MS-TrafficTypeDiagnostic: DM5PR11MB1497:
X-Microsoft-Antispam-PRVS: <DM5PR11MB149743A25D87CA601826981FFEF09@DM5PR11MB1497.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:478;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E7bygJwIN3o5FAC3Tjr0lq9ZaQfGae4ZV4nu5KUCibp7ojQQL3aUtcHtLlmITtLM3nZKOkbibYHwujxIFdZidT/TWDOo54Wlq71Rw3X45PEqAgV5BLcqCVOFX7xUN2gtiROn/heU6QpxwhBe3pBRqLnYwPh3Kr7X2+FdIFs3OLoofW1GBEfpxFyFFXj9MNWT3e9vhupH7IDYczukPgvLUE7fDidjrhhb4UpIjo7HzW3eEZfhgsoLxsrx7AXnpy6fat39tvcnU8imeEVN4IQKiUyHGg0XzlTkNfraPjENb21FpQ5fvvuTcooIpSOToglXCktE2lO8WBcLhZDGFjMi/LDTEtulis0yEidZv7T0VfqRF3V155eE23a3NifzcIOpSRhNf80Ykq52pMQfGL2iSZmYmBp6D2A7qRQm8b0ISKqL6DIKNmkvwrpBZ637ZEp4T83xjI2p7Qr9vitQVhUxIVCceoOlJDdZIs3aMvOh8YH5pPSIRbT9MYG4D4RShvqYD/Ds0ZLAnYz7pvpbFcMpo2x/qvKug1/SPKebdoEZAUfkWUppwJ0JVSoUID/WbTuZWAZYk5KbPe9sxfigupcg6kYZKWgZ9GcAYRcXxW3HG0PDEvCoq7rVEmCkHEP3dKPGFQ/ljkwlcYn/mUSw2CuANVatOE/avtDap5AWonQGSMWx/1Y71Ek3MHA4Pk8TwqMRFNrD3HByoDNXp/m7TJFjbQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(366004)(39850400004)(346002)(38350700002)(8676002)(6486002)(2906002)(316002)(6666004)(6506007)(5660300002)(38100700002)(6916009)(186003)(26005)(1076003)(8936002)(478600001)(86362001)(83380400001)(4326008)(6512007)(2616005)(956004)(44832011)(66556008)(66946007)(52116002)(66476007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZKFWqfAAcLMN7Q88R0BYIK2UurpujyWL8RihLu/2Aif5j3LDq67IYXjb5W2E?=
 =?us-ascii?Q?O4l1t/Yv4tKYbwPH+lz80MxFRFi3uU1l9l9O5gTUyis78Ux17RlSeVviOjEw?=
 =?us-ascii?Q?Pvydw5ydxjR34NcgnVW4g6csPkQyG+ICxwiP4kd+qSgxb6wQ4m1xW7ehsYhZ?=
 =?us-ascii?Q?RDEQKvK7VkJU3PtoMd+sQvJuMBe/pjzzW0yFHfCfeov74XeexkZ7mRT/zvmW?=
 =?us-ascii?Q?ey3DhZEFBCCdHvwhmlTR4Py09TxuOpy+rUgu8q1VTRiB5nFp3E6Gmblw5V1E?=
 =?us-ascii?Q?h0h0iEboR3UrJZ86mQyC1o2v1jrPBzVU7F7RZYKQhtz1/DM2iC83PHVTgHck?=
 =?us-ascii?Q?ZTYgkbYWwWU4rsrNcoxCWaP9oAg2MT+vetAZs/hg9Bq7HwV2rEHuemhkGUNI?=
 =?us-ascii?Q?teb/mD/+zSi/WoOVb9jGVDH5/DZPQ1yrZjrMWeJxEi6dRJGiXTXWY2JLFKB+?=
 =?us-ascii?Q?Sad7/Gt9Op3k+YylJQEbsYgDAult5W8sWj3HDGoPM9QseB5DwLLAw9rH6o2E?=
 =?us-ascii?Q?//am8QD0BBlSxbh9AvZJumYWiCP2ES7WjCrbTDQBFAstop6SdYa3dOzGyKxm?=
 =?us-ascii?Q?IEiObpke3u4zaVknIWVyaly77j5SzanByjA3OXKn6hjwMWv0Smj3M/W7KWQx?=
 =?us-ascii?Q?cQ1ixGxCOdfoI21HoKBHDx4VXANPo0ai3EICHkaP0dxcw5zmtM9AbNYDalQH?=
 =?us-ascii?Q?iPD3x9+Eq8d9j/VKlGKNQTaFZgyoTo0j7pnOkDm5uQBK90qxINMEnhxj6Xpw?=
 =?us-ascii?Q?ZUp3MHwZsl02yChwjaxbJUpMcAWG0zdAQKDceRGvCjmNmhh1vRFHUUqUS7MB?=
 =?us-ascii?Q?3PpxkGgvMMznHBhZL6qkymlTbx6FaX2+Ebo8RtcX/gFVOoDBr60hIsACBin2?=
 =?us-ascii?Q?KegFYPRv+yZ1qIy6r6fkpWy2n7PSwRo2iO2J1AD1bhFhC7nHObz6LyCFw/Ns?=
 =?us-ascii?Q?lLBkMv8e+NBrljrInacPpllQPqcsI41I0o3DrZqu0G6RZ9/e6v8Un7MyCl5r?=
 =?us-ascii?Q?CUOgZhNTr1yvPxNkpryPNKbFvt97f5lCqJXJh7AmvRez2ivGnYCK1CL4qu7c?=
 =?us-ascii?Q?RAavnfOglDEyElyShIqtAbag5WHd4//GfawQqr3sRqVczEmfKbpecJQyhIaS?=
 =?us-ascii?Q?aGndi0GxYse7UwwwLCJdX3jiuXF1/jo7nzk7lGzMW6x3Or17hASZa/I7G4Br?=
 =?us-ascii?Q?CPkLsxPJ1gJs5KUImQQU3h9lWBTr4JXcagsRp3qsdy8PD/ab9WAEQnMARE/h?=
 =?us-ascii?Q?qzYuupqMkn2vRjsasJJ2QZwc3pX2UDhC5HGlHgPNLEN5hdnI/QnCUvir4ixu?=
 =?us-ascii?Q?O6QOJCLfZ1SR46G3Q3BSUbd0?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e79450f3-966a-4d56-048d-08d95686716e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 13:56:08.0657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IVPV3GASZ10dXslMKJxl81QtKCshT7D5283EZ7KITGA0k/5Bjq/GA3+yBoOgazIK6eRc1gr+gVdQuigxRokNHBYO9hI6qoZNcttTSDrvFJk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1497
X-Proofpoint-ORIG-GUID: iHVCzy7-bIwxeNORBzlxNKOKqWymWfaF
X-Proofpoint-GUID: iHVCzy7-bIwxeNORBzlxNKOKqWymWfaF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-03_03,2021-08-03_03,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 impostorscore=0 mlxlogscore=697
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108030093
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
[OP: backport to 4.14, adjust follow_pte() -> follow_pte_pmd()]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 virt/kvm/kvm_main.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 547ae59199db..4e23d0b4b810 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1491,9 +1491,11 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
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
@@ -1508,14 +1510,19 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
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
@@ -1530,6 +1537,8 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 	 */ 
 	kvm_get_pfn(pfn);
 
+out:
+	pte_unmap_unlock(ptep, ptl);
 	*p_pfn = pfn;
 	return 0;
 }
-- 
2.25.1

