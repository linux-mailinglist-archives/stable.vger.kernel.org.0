Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 100643D4155
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 22:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbhGWTbb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 15:31:31 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:55978 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229964AbhGWTbb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 15:31:31 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 16NIXpTA017927;
        Fri, 23 Jul 2021 20:12:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=MSNdrlHj47YlTaWn/hGM9Q09HTuUwUfWFXFRYPnc1tU=;
 b=GWrQGS6+LPouc077q+/CLGXLGUSbZt3frvOKKK6IE1hn7Lcdci0NwxRM3N0aCKXtMuFJ
 Zqa1vSNQ8BUJiCv37OLem3b4JOmGPQxHcdw75S1QSe6e3K5wjo9Z7um9gkHF/HSs1/PD
 +JpVg3AYX8Xub+nxx0swg/x1KRShRQaFIUuCMjSTAGcDOhQrGo371lNhZAVFBaWGj60r
 EwjqDO/UbVonLUcqB+HWUxyTSU8EGfzHDbxOP8DwRrC0VY/t41toLqZgwu8XGzE6MmoC
 umRGkV7SCD3waIG0VqBZg1MmjkaT+c9WkndAbwJIonWVihdMj8PRSFcAp/ue5rS4/5FR og== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by mx0a-0064b401.pphosted.com with ESMTP id 3a035h821j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 20:11:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jU4Sy7Q0SkKiu2kFx4w5rShdwZs+Sx5hRqjufPBArI/dZ+4oxqu/bYtH8rkGYPT9B7/JsizwLexHtBK7Vhtvt0X23Rc4vbDeNlTwR7/2Mad3vtjzWAYISxiwMFhkGdZZ6XR1+z42S3ssOINWmtk5tgtg4gpIp6GzDmQ/MSNULEshx2YiPi+SqE74Hxg++a11fQFgmNqU5ydVdQ8eueSATLLneIECtsg0njjy1DPd8p7jndMWYLmQs29oub54FrdmW2mVon+3GxxBzth6eJipWX3SVoJlx4UUZ7Rabk0gftqyBcHvfpxagUNpkL87afVlg2RnRYDD3rGITjukzRXknQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MSNdrlHj47YlTaWn/hGM9Q09HTuUwUfWFXFRYPnc1tU=;
 b=bKTLAEaum5LQxaNQO32r8m8WHlTV5D6Rr+8zyoC+1LzRr7JqWZR53Gj/vwy7OCLXnDBs/Si7Bb6jzn2yFF81CLWqvt6kwlJXck+wg2calDpaAUH3//XYOOIV2HoEGN/jfg7etKhGJAutRuT4Sl6xx/BcKixKut+5I9xAAc+vRzOkdstArhoI3bby7i8ivpcxrO799uyt1hviHhZ5pe9Hiy/tjhc411Yez5X9Fj7IXJzR48jtlmOyT4Q3sgkO1eXqyohmYHf7rcAg1gtwzjmb7BoQd3/3UHHuIRfBBBOEX07GEbKIQkipL18VEndwqkg9FaFbwHtfg0JuLxGDcaVT4Q==
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
 2021 20:11:57 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::dce0:cf03:275:4b3c]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::dce0:cf03:275:4b3c%2]) with mapi id 15.20.4352.029; Fri, 23 Jul 2021
 20:11:57 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     stevensd@google.com, jannh@google.com, pbonzini@redhat.com,
        npiggin@gmail.com
Subject: [PATCH 4.19 1/2] KVM: do not assume PTE is writable after follow_pfn
Date:   Fri, 23 Jul 2021 23:11:33 +0300
Message-Id: <20210723201134.3031383-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P190CA0035.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::48) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1P190CA0035.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:2b::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend Transport; Fri, 23 Jul 2021 20:11:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf601133-f504-478d-13e0-08d94e161f85
X-MS-TrafficTypeDiagnostic: DM6PR11MB3209:
X-Microsoft-Antispam-PRVS: <DM6PR11MB3209FFA0733934621741C963FEE59@DM6PR11MB3209.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:478;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LnNBglpwCu9b3acb5uUrP+2zWql+2LnTlH29xDz3/l0MQ7jJXoXjPQjsiC/u8lVD3qWtZvu9b+YrpFjWKfA7PNiEzvESKOSnJtSRoMtLPgEvtMsm5OapkqxBfmRxynQGD1o5i1Dtp2vfHN/FX3QMaajLn5fDfMXR1UGyiUbUCAdzLk5V11xbBEZFLFxNf0HIcSqkdoTKM5mFhpKFXo6zLXApGV+C3UO6fMgHuSUNR0wUyjYyJPNoyd9H+rTBDGNz8Y6J3HILUMPuqAg6tDoDK9+w66qmmWBev/Cc5+dgno5eY3ptXMVgfjFyz3hwqEMEwzCcOoKU9Mf9yJAFz8tNlDAFrqSCg/iLsB+PTke335mS1LYp42LSoKGFPb36joYzz000Nz3dhw0Mlhdm8APvRpuWY7j78PsE/zyzkVpjPQvBm2QvzN9ag8EZylN6T1w3Jt30rjPpb9vH3nEASPPJ+zYQi+1ygGr7+IPSaKLj2K7aQBtmUFwIZt1JsSgIzzDvqMTdA4efVSnRW1W+dvR+qLMFwBzn5lga6rlUq3ueyPofKafB5IlCLxxkITQaRyGXw0A8xAvbCJ1gNDAqiDrkFbLf9pnaAsvnk0cYXPgjUh3YrE19mIIBiXpLRvqf3uuLXq0CL+mMy0HADTuvK2RWbtvO2xcQl2nIMWzvZehGnKKRi4BctQiVCbGioC8xyNLl7yXX9nE+4J4LBvhrAfhxEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(39850400004)(396003)(136003)(83380400001)(66476007)(1076003)(186003)(66556008)(6666004)(86362001)(6486002)(2616005)(316002)(5660300002)(4326008)(26005)(44832011)(52116002)(66946007)(8676002)(2906002)(38350700002)(38100700002)(6916009)(478600001)(6512007)(6506007)(956004)(8936002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?l8C7NEW/3lf5zOqQ7bXmHWOBWTyPg//x7bJ8c9QNEu4nuOfbL6fPJ90af6vx?=
 =?us-ascii?Q?jcIMIPVA6RSCvyzDsMDr+C6iS94dSzdoOzs40o5abD4ED1C6jkB0TvTHNLOt?=
 =?us-ascii?Q?3DphkGry9SZCFNvE+yiFG2VDMzqxLTMHV0OYXp9xjVot+U8x8whvrP6/RwRU?=
 =?us-ascii?Q?dyrSN+IwnQQETLPPmnqXC5JMmM5wkRhA2UP7zVHXT1ggYVfq+fljARbbDg9I?=
 =?us-ascii?Q?tAu8pmWfgESfoknICzEiSFim/0luR+URSBr52jow+/s2G24l/DrphQWaQqtI?=
 =?us-ascii?Q?WaQwUdkGMYeYxOMFf65qvcgAOFHeujyw3pkYNOQF42KL5bCAd0vCLb9FnLM7?=
 =?us-ascii?Q?Sf/l7KjRlbddqTSR+1ZFkaKBs57KlUrpXBxexe/D3SNrXmyYW2MhOOWXcQtZ?=
 =?us-ascii?Q?+WETj+RpBC918ttQQl5f7Ghh3Z99PoDeXdSFvpWABmRNUYCrQqh9h75JIYMq?=
 =?us-ascii?Q?KJooItlk2cXt+eZ4IJskImfp9upsF8HgShtr6OAR5ECV4WxfRp2R9vguMyxy?=
 =?us-ascii?Q?Fxug4KYmAxfYYU/dzxu19ErpABUWUYEJU8JCHFPRbn5z9B7bYWgzFrMy02R+?=
 =?us-ascii?Q?ySwFppu5HA1LRyabOsHZB28OlDkxO0CwcaicI7icWA1D821HSyNjzacZABLv?=
 =?us-ascii?Q?gf+xPzlyMDcMmxit5crSlb8zbTuR9pdTkLOg4Rs2koEJfy2ovocNxt2BZj90?=
 =?us-ascii?Q?McAt610yYQtcha9bO+aOujiZa+tcfYUcOn+qMduvmSGm5kGAhfJQJ89UY0uu?=
 =?us-ascii?Q?tJhp2PQPexVg0nZNM2jzhdzq36AKzvdBCb33iMaw7Ba0Vz2dpDoq1q2VmmhC?=
 =?us-ascii?Q?jweX82itLJ6iX6PHz14vdOmRKsg4fiOwtrd6StSeljIFMMm485VZrbq5mFiY?=
 =?us-ascii?Q?HH5ebhcbhvuMkqAIcg3+gQrdxoXmsuMtaXDB3ptq2rlyB0lGMsr9Nrf4pqSR?=
 =?us-ascii?Q?UzxkBsLYFwXjqAfad5a/isyXolvHZ4NLG6f7T1n4vlQM+/DuhFo6ofklA/RQ?=
 =?us-ascii?Q?T2E/E55clViJqImdzQ28PLKMf8cOr6B90UvbI6qpZKoxg7BzRJHgts/Y9nLG?=
 =?us-ascii?Q?tXNdXIsM9RznPgp8LUhSLCRZD8No/ejJSIYlZ+CDB1eFH2Xnp5c+3fuXO0a1?=
 =?us-ascii?Q?xHJ+mNWAy0emKJaa+DTV09rmJKVimRU2nTEzSgh/Vlm6SRQUApB1VgryxYhD?=
 =?us-ascii?Q?k7TXK6VfuRv1+u2AuWQ/VEbhfzczKJ4K8ESvdtDFce8UolO25MM9iLr4ZLdV?=
 =?us-ascii?Q?5QNqxsWXr9VtTmaRDZ2xSDrg/7ahAKCYNWRtLDGqgYSaIWyRUO7E6CxV8JX8?=
 =?us-ascii?Q?fymIz2tMXrOInFz4GnFt2Mn7?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf601133-f504-478d-13e0-08d94e161f85
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2021 20:11:57.6071
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bqv+/AY/FgRd9zZZ9XT6rs6BE8H5OpDQ8wWbw2R6kFE069sEqeZ72/vYn7JULU1LZxCnrskBuiDAUCv45bcThHDXtsCyy0QnKguojlKgR5M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3209
X-Proofpoint-GUID: LZrbre1MydJtESmZWptKywuGyA2joVQQ
X-Proofpoint-ORIG-GUID: LZrbre1MydJtESmZWptKywuGyA2joVQQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-07-23_09,2021-07-23_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 clxscore=1011 impostorscore=0 spamscore=0 malwarescore=0 adultscore=0
 phishscore=0 suspectscore=0 mlxlogscore=748 bulkscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107230122
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

