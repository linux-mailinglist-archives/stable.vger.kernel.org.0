Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7D73D712D
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 10:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235912AbhG0I37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 04:29:59 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:49182 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235913AbhG0I36 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 04:29:58 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 16R8E2nF004378;
        Tue, 27 Jul 2021 08:29:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=bcsaEGtk4rx2oEdbS52dsyY85DLuuKwLaPXOaSbRtNs=;
 b=QIXancpgDfzHRKRG3x7ty4LzWch/1W8LW9TExzD/4FsYXM5KoGt66Hcx30H5WHBYwyX0
 dsftJ0fTtkE4kKy1vXxsajg7PISSUu+sPWU+MJmAGI9T7rlk2B5rH+dbFClxloR6pCWB
 0+BTuFyIiYHmFWF+uVA4SLsbvaJ2yOEP0cEYJPS14lLkc8JbP0dgBJvgbCNrjt/NaoLt
 cD7PBXPcsmeEDPPunODzOgdmAtxdea32OF83hDeUpDXrlaS5rVpZB6+Qw4Ep3ZwzJjun
 zoe/swTl3+vjl4qkLSWyKNpngO759/2QsJHT+HyDFDryXIsCYdt0qEeD8G7GLO5L67cV eg== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by mx0a-0064b401.pphosted.com with ESMTP id 3a2351gcr5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Jul 2021 08:29:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LglZlSgxlC9lvVdQ225VU9WZQ+iAdUwrLCbG7s+g3K7JVQ1J5L9TWwwkzxKG3H4MB6vGznFNCtJ0egE6eVZvb64H1swSb18W+RgUCVFECCa67PLYjyIqzkU//lPXXz7VgKULQsrkKqz/yiiNQSD2hSm3ZPEuccW/zxQc9Bw2pbuFHmTPIY+CbMCHqQe+75KS9pSd1rLBhOw1xDkv+wPxGBg5pAWR3Jz8JYuoSj+KLyDRg99gg/QaQAldei527D8u5VRsZ5p664qjdTObLo3RsEd2BJKom/Be2FZKoB1nGY867ndXPzskZ43hLs68FGtRMg3r7IrkXfAC9MtGtgWPuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bcsaEGtk4rx2oEdbS52dsyY85DLuuKwLaPXOaSbRtNs=;
 b=hJgUKSrByFapiibHRb7CdWNCYUa83RFLzTmPUaMamVja1+GBOIDOhqJiGgq9VopoKZRSyy3+MUpsX/KBkb1/YUPnJslxMItn4qZGWCGhq78bpymlKYBmAbr89HgkKpkXhIpRzEppZOAa0BUj8qO+/JXqXIgevfR/t5gw9+TF5xWZtJAdLy+XmdqXh91DsrO4bpRSUMkjpDhg6VBK8FMGK1neAy8cl7Op3zKg5jwAgxeNr8tmVmlDYyGZZpNyon4WWCJlD3De75vu8cKvvgee6qALOpF5DZzQKQr1n31iA1/VjySyQObI0yR+SrMgW0lJ7Y37987oB0c3NE8mPVG2QA==
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
 2021 08:29:51 +0000
Received: from BN9PR11MB5321.namprd11.prod.outlook.com
 ([fe80::5959:e459:a5e0:5881]) by BN9PR11MB5321.namprd11.prod.outlook.com
 ([fe80::5959:e459:a5e0:5881%9]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 08:29:51 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH v2 4.19 2/3] KVM: do not allow mapping valid but non-reference-counted pages
Date:   Tue, 27 Jul 2021 11:29:23 +0300
Message-Id: <20210727082924.2336367-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210727082924.2336367-1-ovidiu.panait@windriver.com>
References: <20210727082924.2336367-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0158.eurprd07.prod.outlook.com
 (2603:10a6:802:16::45) To BN9PR11MB5321.namprd11.prod.outlook.com
 (2603:10b6:408:136::8)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR07CA0158.eurprd07.prod.outlook.com (2603:10a6:802:16::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 08:29:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22016dff-2da8-41d9-d636-08d950d8b3e6
X-MS-TrafficTypeDiagnostic: BN6PR11MB1634:
X-Microsoft-Antispam-PRVS: <BN6PR11MB1634178512E46D4902321F84FEE99@BN6PR11MB1634.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Td7B5u4G6AwIbz2NhOuXP7PCy7FxnjONN6NocdLXAndp1ZRM/vyEMvcNtXrBqOQaxd1gSkWuu6VrTzKylNemiKx6qHQXRygHZ+vQkrKxN0upomEcx7ecZ2DMS7E7A1HHlYQfTGN8d8yuBVfnVXompGtav5HCXzC+82jFzoDBMXbZmSGEmdtIaZ6YciIaGDSzQTyztZDm8+1hc/h3i2upD9A3Iz16MIXQPeK6lFnkd7ICFixQdIVG6KDiHWVHiK7FVnAjp3yi8kZ0ewF4mquNib8BQ4bahK64EhaBrEnGC+U2ZY8yRLI+ktHqpFDLJOjPAXEAomLymj3DHnVF9YFZerYG0EjpaJPjS5q/09VcLsGd029OJ9mVatuCMJ/fwXrDs8Vsck+EVEB3+UMzu3S8tUJhQ8n/Ipq+6P1rCfGW63FkzkA1sBiCNGtYYIbeYaIBRiobgM237qpoygSXgpx4MMu/lNjLz+uqxizljFNQgj+4cQd0sf3lnRkq/mfAHUw+eXlSu67bXfHPG54kdDeHJnOLOKtxDTCAoKvAzto6Utup5IYszmgUIvEbIuOuHoGnZomIL13Z94ecXtt3tZlFu6xw6X2Sewo1rp0pVWomU6zJ+n+ZsqPQiC5ggeoD8boq+6n99JEbD14YjXlJjnKcySdwAvbfLRWmabAuYVxxju1zPKBIx1ZB2tDSzXTBCZ1dyDcjTjtp86qA93UcxQqsrQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5321.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(2616005)(8676002)(956004)(5660300002)(316002)(6916009)(6486002)(52116002)(36756003)(1076003)(38350700002)(38100700002)(508600001)(8936002)(26005)(6512007)(66476007)(66556008)(66946007)(6506007)(2906002)(4326008)(6666004)(44832011)(86362001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s+ZI9geW5t90SmHtQBpgunCGoRZeBDs+KZbltIilZRpl6tBqyuqqUAwFsjaV?=
 =?us-ascii?Q?+QaxSU6j9aqJvuhyE5m9yZIDQWRyT132ik0vqnhQUsd4FAymotEEvUmw879y?=
 =?us-ascii?Q?yI1Tz48RMtvIk3yZirJkvhGvfjSkHMFjB9rxkqgOXNa5zb9jY017M4sdHRxK?=
 =?us-ascii?Q?dtHI1dMiSoaErstR6E9uiH/vhY3FFNV3U07dNNmyhX6ENvjie2iLKutP1nLN?=
 =?us-ascii?Q?c5bFFav3q50WadTHYtHqAHzBYVtO+sc9TcKB8VWaOXMMEsYcoh/ydzq59IJR?=
 =?us-ascii?Q?6VQJj8rU+1KbIcmBgX2MSM1yGZtG1bAfJC2BbEpwh3GjKYEWzLdie5eBFdC2?=
 =?us-ascii?Q?W9UU0+QT5Dl8VmzS76eYQbg5vtw53R6LwnhzXRelnxN41fABAsC4PYStWbmv?=
 =?us-ascii?Q?tAFL9bFz9+ALeyL5LVI8KrR3zNm1NAtcLBhLLg7/k2eb9vUXM9LCL1TrvTSM?=
 =?us-ascii?Q?iSwHX2JJ+psnBQYyVxTRITlS0c5CK9quy8kgWk1s6Hih63XwktY4eEJirhXx?=
 =?us-ascii?Q?NE6ZPHaZ36k/gcMGseHUT0xnVq+Ce4kZZ+Bb7fM5ADz9rbM/ZpvKG3J1fyrv?=
 =?us-ascii?Q?gsbSs1GWXcPbB1d+L9K9Pj6GngUmNw0yluLX7+8ysn1N+G4k+ujZ3D++nosT?=
 =?us-ascii?Q?QN8wh95QcNdaFolEA1wFIZ4sPUuAtfnX8K6xxEg7HiNMSWsfWFFy88zJaCO1?=
 =?us-ascii?Q?gduEQpT5CsnQcwUNUsu1U9jYlQwy03bsGRcDcstIV6Nahj66MFQic3UoU0eq?=
 =?us-ascii?Q?IozBx0s4FVlZalHD5PQDrJT2jCb3k7U4p0zp6NHJvqCdFb6ySbFeRSMXcrVS?=
 =?us-ascii?Q?41FtXHpwiQlokQJ/wmACDTECRZii6AehrOGNKqe/NGrBW9Gqo0Rjl2sY22H6?=
 =?us-ascii?Q?auTdbXOvCWuSbz4PF1OI0JdVtuhBapKTi3Sl5uYn+tvrdms1vO5EZarxzakO?=
 =?us-ascii?Q?oYDthVSE4r02j5Fkivbwwe9RCOFnsr3dcriZKjaTZz8S1KSVytcgi7SbSZ/F?=
 =?us-ascii?Q?JpZirqGy5VFQ1fuq0tlW6YroEQ3PyG0LTK2zNOxAMrsAqDngMNN011UlU/1s?=
 =?us-ascii?Q?vTK46pyq+knN6DfB0cdZkj4Gv4LrzSw57bSwNhJYDZnWT5rsoH3GREQjjjx3?=
 =?us-ascii?Q?Vbdk+F88zQ6qxiBIEFTZIj9f5P3Dbg1GJryYCNiqSTtPLucoFpg5LfTCGleg?=
 =?us-ascii?Q?zxHbSYKsc7a6Trpeq8tESongGG2Omk1xP0EJLyCLTMaLSL9BFTxZQnhhaVOJ?=
 =?us-ascii?Q?AnqryfywXIyhcr8/Kog6PM61FvS/Uf8HNQmgBGyA4HxpzwzuCy0I7blm6acR?=
 =?us-ascii?Q?s+Fuox2WkXY2r0BPJTisCaHf?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22016dff-2da8-41d9-d636-08d950d8b3e6
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5321.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 08:29:51.2686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 15FvjSzdtoO2ycoRy2TzV5TUhZ4gFkIRQmciIoq9Z2CLiKpdKn38sI6L+Gl+J+CaxZmVokEvAWFDHQjqoDUzkNMF9Q8MbNuXYVwFLUJJxW8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1634
X-Proofpoint-GUID: UJGPOTR_XcLDjSumRjxJ1wzhSC0RFB8O
X-Proofpoint-ORIG-GUID: UJGPOTR_XcLDjSumRjxJ1wzhSC0RFB8O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-07-27_05,2021-07-27_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 spamscore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 bulkscore=0 malwarescore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270048
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

