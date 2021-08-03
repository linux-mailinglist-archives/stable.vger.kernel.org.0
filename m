Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9703DEF69
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 15:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236128AbhHCN4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 09:56:24 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:18814 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236138AbhHCN4X (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Aug 2021 09:56:23 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 173DhTCM023855;
        Tue, 3 Aug 2021 06:56:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=acnyeXh7PDb2Sq2wyQuKPG9TJoofPELjLjwiWQ/DHVE=;
 b=Axv+y6kDeOOr0e9E3OrkeDU36Z4G6H0ge1KExP8qzVemHquvOxU28EIoxTwn9Vmgyl3g
 00hffi0p02sBg44ihz82CPk+gk6cXMKlf9s7Nw0reWyIUFp310wjL3EDscZpQHNfXJTU
 EjwmLD3oiA8cfU8PMwrd0tjgq7NTES/bmwAcL3PIKwhQfVFbxaMjo79y5E1pTfboeZhq
 4n7ngEqZPkGKg0VscAYHb6LM9DEt3aQfoOl3u1lfBNnsuD/cFdp6oQWe3c+J5yZRheOZ
 4jr7hxw7Kta0nG6WU0TmcORcri4Bcol0SGc6JAd/VLz13Z/7Wf1KiMbgCi9v4e6QLGfy ZA== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by mx0a-0064b401.pphosted.com with ESMTP id 3a753s02rk-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Aug 2021 06:56:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=akr8UzDLom44E45OJCqF9aIPR1vJ+mQaorLGH6v2nC6vWQbNoYAvdXbA1QpkUNjVu7BABf7EFoQxLYaSljfPq7C44i+iA1Vlra4YrPWcgp06THZJon3fvAc2nyjQpImG2sfbWtvhURKs7HYUdVtSPy5V5qWb9ijR2g95hFe9Vm7Cy5dC+jOPh2/08vRnHGX70dvJKqfo0iyz76uNqgz2K8FdFjcmH4mXhZ9SKCf0JHWIVRD/KiikLAcPQ0+S7n9iDpex2572aBpFkqces7I0iKOMGglR+p/rMldz828x0GlcVi7nUWIn3EyN47RaGebTP3RwvgXVIh8LarWccyQKzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=acnyeXh7PDb2Sq2wyQuKPG9TJoofPELjLjwiWQ/DHVE=;
 b=jGwa8pxq2eZcTP0FIT4MBftIRUJOjLGk0Ag08rrFKCFSi25c5w7GvobaFtHGPrJwRxiV35TldxTnnmzQZAU90mF4HlpBbx8l7rz8AmTm50E9Yvg2Brn3rfduzWQ5gl3xYq9eXUoHJlRUFCW8OcDGKJWuuimJRxy23WRmfntAyBokDuRDHhI3pFi3OI5YQyFsOcHILmunMEAJoYda8PZKaRIbfrGigihwDxWSbY5NmpbURg0Ots6AZ54lppoQ3XFX1kLxnnoo7jlv2xr7NM4NuG3NGwy7FPrapih43OG6KQoqWzgfXvM9nw84uF5hgHVHA7Vt9aWB3yS5rvHe6aVjHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM5PR11MB1497.namprd11.prod.outlook.com (2603:10b6:4:c::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4373.22; Tue, 3 Aug 2021 13:56:09 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::dce0:cf03:275:4b3c]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::dce0:cf03:275:4b3c%2]) with mapi id 15.20.4373.026; Tue, 3 Aug 2021
 13:56:09 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 4.14 2/3] KVM: do not allow mapping valid but non-reference-counted pages
Date:   Tue,  3 Aug 2021 16:55:20 +0300
Message-Id: <20210803135521.2603575-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210803135521.2603575-1-ovidiu.panait@windriver.com>
References: <20210803135521.2603575-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0159.eurprd07.prod.outlook.com
 (2603:10a6:802:16::46) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR07CA0159.eurprd07.prod.outlook.com (2603:10a6:802:16::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.6 via Frontend Transport; Tue, 3 Aug 2021 13:56:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3103f4f5-a223-4705-6c7a-08d956867228
X-MS-TrafficTypeDiagnostic: DM5PR11MB1497:
X-Microsoft-Antispam-PRVS: <DM5PR11MB149721CCFA305CF227403C5AFEF09@DM5PR11MB1497.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AhM88zvnhPVTF6AtLUvoYs0fIN+yj7LOYL2kIZ1CxEcCxB093E1+hmIClxZJFr9Cckj8HEJhD5wQ2V95oQfBpn9XiDiqVv5bW51PicyXXI9cHg9vfjEy3eUh5YkUXdzBukgGE8VPoVS38PwM1/kVeqfGcFKFVV7wIeiCvV4awYhEVXgmyy9S2PKL5n0Kns0OWqy8Bxhj0i3ez7977VGiQfpLaVNybz95TQ88q8vb39tqGyAs4cskwEWSgWVe5A6OPQTDQFA4krlbktjR9E0c3fJaMM6iKWdexxFcFE22ip3vilwF65PHHh8vVWGTqXJJjpSF/Hho82CNYnfvLdIjCYosijyqtmeeQ7ATmeLceMuTJtFegwOZHNvpdVbz+NMYAwgATJ5PArbLwf+j4farfDQvT+8SjLUOKO2vQ4uCtlV9l1uyvP6FEyF2zfIKmyrS0Md5kb3hCez24285lvv94nFq9gTQLenH+y8XJDHFnBPcYDapWI/WM+CCr6gN/JM06JHeNqWdSNXwN2FValdHMYMgnOQGZZiGNNL0cGWf9CRkVCR78+U/adXXVS7SS6e9LwWMjnmn05CMLXcWaiNzM//WvWnjaGhvr2O2tr+vAMsq8Z0iBMqnHnRKkHYLeiShrHKpLh9W9jXzWMnyDF6MdN9rINSQLlLeJ1JtnEUissKTylJUkBCYKdLLSigGpWrDHVeeqO7i84Gf1D/8zOVhlw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(366004)(39850400004)(346002)(38350700002)(8676002)(6486002)(2906002)(316002)(6666004)(6506007)(5660300002)(38100700002)(6916009)(186003)(26005)(1076003)(8936002)(478600001)(86362001)(83380400001)(4326008)(6512007)(2616005)(956004)(44832011)(66556008)(66946007)(52116002)(66476007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XEyvXXvAG1ijIFLmUVvEMR4CyS6KiF0HDHOLxvihIFyMkm5BUCKYrwBNMNAJ?=
 =?us-ascii?Q?pi8pRHrkjVX0n8xyV78Xs3X0larBnzScmMm6w1m10tQPranOpIdZLA0TAZz3?=
 =?us-ascii?Q?LYemdQtU1VnBf5EHWIhrN7xZYuif+OU6Ui18ZtNESDBoYHg8gkPJlAkwDnT/?=
 =?us-ascii?Q?D7glJGAufeofK7hfhi6MJrNWssp0ny9zwvUnk8Xw8MDHE86bG67rl7ie6fi3?=
 =?us-ascii?Q?rUDYbNl/1eDwlSHNjQ1qhixPlr4qx0BYilDjiZMb3V4I7x8e2Y3IQEPftCSw?=
 =?us-ascii?Q?jb0qIl0ggaxkJVuq8gd2urgcCZ3y4JExUpdU8E5mdhvZ3kC9wk7jfVNBjwLU?=
 =?us-ascii?Q?JmK64p9QYaSiuzJqODVRyXNlRP0FAb1TzMR9aOpn+F2POTIewxb9pCE0LcDA?=
 =?us-ascii?Q?6a8zlLiWGnmKS/yz/YcGRq1oQaYO4Q6BOpi4QYuGxjD376LSUGO+3SL0TSab?=
 =?us-ascii?Q?WhDTq2Jgpd7/+kzGZwbliFuECdQW4WTA59APXG0m6XDUUYGgJiuMGAaPwoZd?=
 =?us-ascii?Q?7kmMzU/qsjt10mPgo7U/m+QU3ZNTdn7X2Ck42qrVJjHTRupaW33Z5DAEC19q?=
 =?us-ascii?Q?BqoRw6S7Y/RXSzR0nS3BvBOouGQx4HUW/hbzk+2EAu3fUKEUGg/SWlZ6jm90?=
 =?us-ascii?Q?l1lN2sL5kM55o+0sdA3KplUgaPUM6go3SUQ6PiaXNCs6Pz5l7TCFLg0d2x+2?=
 =?us-ascii?Q?U8S33Fa3dGHKh08MzQin/Zw3Rzsk6SrjPtWq5pLhNDKMASfs1vxnI6T9JbTi?=
 =?us-ascii?Q?lmv7UybqQkYx1QMmWj5k5BGEY8ZuNUqTudyJC6Ws2WI7/owZ8hP5pa/wz9KS?=
 =?us-ascii?Q?84VCEGC0uCoZSlkN/tlqLQPClBZ2fDK4QZGGx+qgFYzUmVKytYPTLsQ1rdXJ?=
 =?us-ascii?Q?WQfKfXou7TwcCiZPkSIlFagZ6r+VdQFyvb9Uwycm6NR6r8hdDx5kvQFcKGqi?=
 =?us-ascii?Q?0OIKuUUoG479tPaeYAhodfqi7ofDTOT+le1+zImnPSthQK1VJonwh+ZEXzOX?=
 =?us-ascii?Q?JfphBGMAK3yDLEG7nVWjwluk79yXwjtnc/YoDNAJrFf0qzfq7eQwO+xlJejr?=
 =?us-ascii?Q?vh+e+b1pLhJCDqkaI6V2E2mIgSLSZfofDYl9TJdSuOWq8cgGFFdvsxefgQfm?=
 =?us-ascii?Q?2ZQR00Cw1sY53d6OwD9wbRwCmY2iOgV+a5dQJ6kCJuYgndw8Dyht5C3lLJwE?=
 =?us-ascii?Q?uv8Mm5U31o1x70GNizyvCpAZ0K9NfhaproLwf17K0t37YkdQkmHnV2uAsc3r?=
 =?us-ascii?Q?u/2gP00uc3bQIKWI9dvwrjkmsH2q6J0XYoJ5jZmXI6nuMEp2eUTYLUvQRzOX?=
 =?us-ascii?Q?cOoiFWJ8WEN0tiwoSe7t9rJM?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3103f4f5-a223-4705-6c7a-08d956867228
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 13:56:09.1977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u32/zY5tbfVSXGV5onFG/lKVpMO5szR4AVtLpoM/EaDkKC3RAfGSmWF9GXGFtTu0b59U9tDDpEfg5Qf4iCIm85lfkmSrjqNhThEKkq72zco=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1497
X-Proofpoint-ORIG-GUID: 9ceWf8GMdopM4ynT3UfqOD7qTgGw1vRt
X-Proofpoint-GUID: 9ceWf8GMdopM4ynT3UfqOD7qTgGw1vRt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-03_03,2021-08-03_03,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 impostorscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108030093
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
index 4e23d0b4b810..469361d01116 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1485,6 +1485,13 @@ static bool vma_is_valid(struct vm_area_struct *vma, bool write_fault)
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
@@ -1534,13 +1541,21 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
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

