Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7243D4154
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 22:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbhGWTbc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 15:31:32 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:56296 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231268AbhGWTbb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 15:31:31 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 16NIXpTB017927;
        Fri, 23 Jul 2021 20:12:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=bcsaEGtk4rx2oEdbS52dsyY85DLuuKwLaPXOaSbRtNs=;
 b=O8G7blOnQX/pidoY0mR7wkLFNR0SnN+fJXoU/KoeUg5MQA/SI6jKWfWcj5V7V/d1hXqv
 AMfpNf6GZpEhixHDxMlenJsywsq/KE9Ouh+wGlf6Tpw4kZwW8a4rmU5LKfdTRnCn6F6p
 loZxOz35jUqCluyszq+Bt1x8xvVGMYC1mfrAbWec65ijbZ6q3VaSRjJBnP07SthqsiE2
 X5rnFLreG4ctXTXZLMe4aI5+B3HEu+1ZfW+b/mnUy2Nx8KQuDnF3FEO0jPo7ueU34CIz
 fl4KAI81p1hBJhqst3WuTHTNiuOs77aWsMj0cUozWdyp+pnKQpd3kSDY/DT6P/Nrcuk/ Yw== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by mx0a-0064b401.pphosted.com with ESMTP id 3a035h821j-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 20:12:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=egK587kjQNWzjAYsgD4+unDVelqjXk/xfvRVek+JAGNXep7Tys2VCpHgKDrR09fdhiU0HbO+P7GaM/vw5zE+aya5/vNoSOCilcVrYMaZF2tk2A6CUyoIB2Pq1F15kleKayMbExryDEx/9WDs4DV/b5VTFmTETSOCB9SkSlnli88wkyqkLdZJJhTJJUtY200eLIk+J1/dEDQLQxdWAC3Kr6cZMr9uBj2P7zhC/0lNoATHEYbzx/OxCUkujm2KFjLt/AxdfUPxDU7a2MQtxtGsQ4evFNQLdpZ7MSgMxVz1B2fFJLF0dRLZmpniIhItKF6WiwFqpoCzvsUcD02RdKXoaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bcsaEGtk4rx2oEdbS52dsyY85DLuuKwLaPXOaSbRtNs=;
 b=mlZzYd/JDKFRe7dHhOsYYKVthn1dodHRjf3BK6ZTj68KpEupm7lh8sLNX6g4nHsKdB/VN83IVTCBuVU3Shvj2+mhChpr5eZzxCBHbijmu09BZgPfRnvunSQgpe7RuVAYHH3CPEdTvp4d3xUqAwDZHTwJRgJ0GPqDml3oafsQzY2rypcO8qbln514JNl3p4Lf/ehEyN14T6XcAVTFAumQl+02owrbupWIyJxUUgbCV6VrH0lcA7yudnS8Sjy/YzZi3kl7XrN6B4Txgz9cEm9xo1MZJoI8ZYauckO8pDQ8yVsGj6OD2dr5FsHS502JgfYMa3E2qWAgNI8WgVnvBWGEaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB3209.namprd11.prod.outlook.com (2603:10b6:5:55::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Fri, 23 Jul
 2021 20:11:59 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::dce0:cf03:275:4b3c]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::dce0:cf03:275:4b3c%2]) with mapi id 15.20.4352.029; Fri, 23 Jul 2021
 20:11:59 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     stevensd@google.com, jannh@google.com, pbonzini@redhat.com,
        npiggin@gmail.com
Subject: [PATCH 4.19 2/2] KVM: do not allow mapping valid but non-reference-counted pages
Date:   Fri, 23 Jul 2021 23:11:34 +0300
Message-Id: <20210723201134.3031383-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210723201134.3031383-1-ovidiu.panait@windriver.com>
References: <20210723201134.3031383-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P190CA0035.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::48) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1P190CA0035.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:2b::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend Transport; Fri, 23 Jul 2021 20:11:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31ac74c0-5eb3-4293-d93f-08d94e162083
X-MS-TrafficTypeDiagnostic: DM6PR11MB3209:
X-Microsoft-Antispam-PRVS: <DM6PR11MB3209A72A93556E6502AEDBFCFEE59@DM6PR11MB3209.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LNXhk5H6Mmde0doSoRrxGlpFexVsP3tfnTR7JszKxl5WEK1KTuyWruhh6X8KUr7zdfIWSfPHLbcoxke4EjD9TWQ5mfXHQyuFRYE2hZXnMiBhHFEwarYhUuRrQz8N/m/o1mCKQJdNRwyQce6hrwGAz5jaKap8Y2M7wkGrdxekTkllVRwNfKXV0Z4OO2CrxB3jzh/jdH6UtWwu+C5IM4ICpc0uVeZbQVvdfuE34qL0HeqC15KAsEl2FjIy03G0ccC0gBK7Q5g3+XhJpgbLmslRUEEaMEYFsYtGT2YuGk5Kc5sSknDXeEAxpKjFP58Q3katZbQefJRzU4pyu+xa3YoGh3xC5vJnmKDzieloTQSOJBYk+KllEL2wPW3GrnoL7cwSaGtUdMPGLsX5BIUqrCFc8fx68FJo3BdCp7Sc3Lsc0oFk58lNWA0fK6FyIfl37yHnZH2qH2RS4phF1z/It6Y0/LIEO1SdwgSmnfdpoDQXxKyh1I8Fp8SHuRVde+L+0G+1SPX9jYPr5yqehva+Vhl8cZv1Ox4QVIrgeLO/ZyEFN76w8cgzGcEQEtVhdm7TqKbfJbCQBDI+QU3WshshEVIocuK1KboauUz71qPazVt9SRoFP4TE5XpXB6komC6IHj+TmazSETQdfrtb+1iGJthUr3eL9t4u5dwdsCMM4rnkTz9ZUlFwHg4P6rtumhmPew1ZB8fvfgc8ChVDOWGHQYPQBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(39850400004)(396003)(136003)(83380400001)(66476007)(1076003)(186003)(66556008)(6666004)(86362001)(6486002)(2616005)(316002)(5660300002)(4326008)(26005)(44832011)(52116002)(66946007)(8676002)(2906002)(38350700002)(38100700002)(6916009)(478600001)(6512007)(6506007)(956004)(8936002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WcBSzs8ORgpBRWCy7nEGYiKpwXBsLzmb62GsQa+A6m6j6y7ezkWbtEqKZFWZ?=
 =?us-ascii?Q?+mIM++g4EptnCS+03gKwx59n/gAA/IkcuGKyPJnR+s8RXJ4TiikCHcvjE++w?=
 =?us-ascii?Q?ou75koBkPe1fiHwr3kS3nzaXhodJUiCxORTykTCSxNeLjePjHuUZWn85f/5B?=
 =?us-ascii?Q?ztFRTRaD2KQVSTPmGXPz1CZoBNhvasNTui7H82zgt4iGKS6UMLUT1Fip7bhx?=
 =?us-ascii?Q?YhypjDQdWSJkGsn5X647PEBz1u3Ieh9pDM971jWl/rY+VkVKW7nyWj9Apx03?=
 =?us-ascii?Q?P73KdMKMESFkwyly0bqT5FNJs+O+VRhrZqo1T5ld2G6aIh2+9ecn6epEINa4?=
 =?us-ascii?Q?tJRLWXN3doCbfDslCv/jnMVgyyI9brIHu3VVIps4F3Z1lO3dXfQcV5ckWZNr?=
 =?us-ascii?Q?SOvf0GWyUOz+lJD7SyJ7CGlcXUq9espMNPVDCkfRZG8t1Ufx5j5e99ZghFpp?=
 =?us-ascii?Q?HkEow/b7vm4HcGPA8iDC5RIjphr6kRoEZo9cVXHc8g/DHIfQhxAVx2OtCENl?=
 =?us-ascii?Q?lvJbRLaeH3lvm89jZMbpHQFKIH0cQFvbsQm4rBAy6N4/p9HLULQpusTHaU+N?=
 =?us-ascii?Q?/YelwjZ7fcj2m9FXT3EriZmEB47zAvad7/eoTyeNxuiyz+HhNeB8cbjlhzur?=
 =?us-ascii?Q?dewCrZ/kRYuhgbMRddJfY7HVS+OXoS2zbi/8iwjPmSE4rlHkfapwQ0AkhqkZ?=
 =?us-ascii?Q?aqOP2P1Lwy2E/qK0B+fNldGUhyB6PwGbzDxygLGh7QvOIk8LX4KFJthou+Q3?=
 =?us-ascii?Q?TfTD+GJzn4KfhBKwyJrdj2TpTlPkABf3WYXZjFfYgpVv5RpDSzA46N24xGZR?=
 =?us-ascii?Q?sSMbrCSMDPWxXBoq/htlgVYDCt6sVYD/rh9wrjtxC5D6ZTF4lajPcVNIC1Np?=
 =?us-ascii?Q?BRDNoUb3SPh8j+4QZzzTlxLzRkbaQwd9L2NTKNasy0ktC8X1AvQRgo2Th0PN?=
 =?us-ascii?Q?PRJimeBuL5c/oMED93A6Tr+oY5d1pPxVj14UjbOkT3cdCi0hxoxiScreRCje?=
 =?us-ascii?Q?oq1u01HZzfKuS6HilfVuoqNpHki006BBZ9M4WWFOXtMZyoc00lhx/2mHnYXJ?=
 =?us-ascii?Q?vtu+8sPu7tI0CgRNJoszWRb0kFULxq+nbTEB1lF+B0ZkEoE01j33PIKZ++6O?=
 =?us-ascii?Q?CZeMhisJmdrAeyTCwuUbt0/hMQyQR1IPyJTtqBUC/h2pQYwSXyioahWjanx+?=
 =?us-ascii?Q?18mNSU+Mc3hIvLnC8Ic/u83Ng5YxlMlj244VwsrgG79S7rVCspuF6EK96QMv?=
 =?us-ascii?Q?jJtLxSppSyemenAeCjRj+sV+PevW5h1J86cf3v25Kfxawaxf00iP3IL5dH0e?=
 =?us-ascii?Q?yxKkGNEsgQjHndGe+BIQJ5GB?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31ac74c0-5eb3-4293-d93f-08d94e162083
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2021 20:11:59.4202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CjcKUE8/EPuZ3wu2vYuYO3ky7Qb/B/r3RIirim2UeY1JzYgg7yNr5+fzurYcjwItfSGewAOJBQ3UM8I7QaGk0A88GIiQSY0R5PXvDestGj4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3209
X-Proofpoint-GUID: 7kWnQSw3Mipq2aulzdx1_BYGLmiqWCqM
X-Proofpoint-ORIG-GUID: 7kWnQSw3Mipq2aulzdx1_BYGLmiqWCqM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-07-23_09,2021-07-23_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 clxscore=1015 impostorscore=0 spamscore=0 malwarescore=0 adultscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107230122
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

commit f8be156be163a052a067306417cd0ff679068c97 upstream.

It's possible to create a region which maps valid but non-refcounted
pages (e.g., tail pages of non-compound higher order allocations). These
host pages can then be returned by gfn_to_page, gfn_to_pfn, etc., family
of APIs, which take a reference to the page, which takes it from 0 to 1.
When the reference is dropped, this will free the page incorrectly.

Fix this by only taking a reference on valid pages if it was non-zero,
which indicates it is participating in normal refcounting (and can be
released with put_page).

This addresses CVE-2021-22543.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Tested-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 virt/kvm/kvm_main.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6aeac96bf147..3559eba5f502 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1489,6 +1489,13 @@ static bool vma_is_valid(struct vm_area_struct *vma, bool write_fault)
 	return true;
 }
 
+static int kvm_try_get_pfn(kvm_pfn_t pfn)
+{
+	if (kvm_is_reserved_pfn(pfn))
+		return 1;
+	return get_page_unless_zero(pfn_to_page(pfn));
+}
+
 static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 			       unsigned long addr, bool *async,
 			       bool write_fault, bool *writable,
@@ -1538,13 +1545,21 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 	 * Whoever called remap_pfn_range is also going to call e.g.
 	 * unmap_mapping_range before the underlying pages are freed,
 	 * causing a call to our MMU notifier.
+	 *
+	 * Certain IO or PFNMAP mappings can be backed with valid
+	 * struct pages, but be allocated without refcounting e.g.,
+	 * tail pages of non-compound higher order allocations, which
+	 * would then underflow the refcount when the caller does the
+	 * required put_page. Don't allow those pages here.
 	 */ 
-	kvm_get_pfn(pfn);
+	if (!kvm_try_get_pfn(pfn))
+		r = -EFAULT;
 
 out:
 	pte_unmap_unlock(ptep, ptl);
 	*p_pfn = pfn;
-	return 0;
+
+	return r;
 }
 
 /*
-- 
2.25.1

