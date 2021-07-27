Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 805783D712F
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 10:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235920AbhG0I36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 04:29:58 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:48500 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235629AbhG0I36 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 04:29:58 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 16R8E2nE004378;
        Tue, 27 Jul 2021 08:29:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=ssGNotrP2E8XYOjs9s8Xtda3mkjZOJRMvcdv9ALKJrY=;
 b=BKZTu9ILZybDIv25GiZe8jCxWR/C0lDBpRO/fUWyQdjNtUX1TXixhTHTvoX6D84ET9tq
 QePEodJ3k97ToWrl9N8hT826d5lvvvxcYSPkSGv0mem17ce7R/vMfThtEuaJbmT0IDn0
 QffT9NDShh4ord8doMvJ+zFfe247AOKqOukAwmxmfSlKmUaVrN9+6Bq3wRQtJcBoYp61
 EkFuiYbXMmfHahVhrYvVTBWuhXJzRSdLD4sykDd3AUSeo5bMI6gv2/ZmQXfzsH66mBZC
 uNlrkbL6+ID3FpiBYYiXKk86BvcSyPEdz2tnLUlR8dLRfpqoLiBlR2aUhb1CA4tHFqQO sw== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by mx0a-0064b401.pphosted.com with ESMTP id 3a2351gcr5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Jul 2021 08:29:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XpeJumv0vLw7+etikj8z+IrU5V5y11LsGt0+5cW5FSt0L5L00SUhFPu3cWzh/KHHXbQ8Okp1LW50PoGZLh3pwgZcFCt3brK4Vv1NV140mxRmEE/3ED/tktCGx9d0Fp2lJeutRDIV25r2+i3i3wyespchxI/dmSvX/eBUOhqdl9mlMpfSlVklk01NdxvffpwR4b+/vqjXXiAcBZ4y6Sc/7mEritZBxq2PeHVTNlD8VH7YYMZg+Ss6+E4anMZhP6nSCs5uZnbE+lvIOz/LF8IFwrdhH5OgY6pfS+OxRXLztrrv3fJ5nBjS+EZfpdrMUOmAKNAAh/jCChUDsEw1akhDpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ssGNotrP2E8XYOjs9s8Xtda3mkjZOJRMvcdv9ALKJrY=;
 b=Rk6W2RrVgI21OznCFrwVaPHF+IcKvYxNnvAk4dyH/gM1kZ79hr2UV1OewotNPPmzZPz18naCPwyT3ITcCbRhFa8JFmz2qjJtJg51xJHB5ZMl6PZLId48+IyXJIJCb20lrB+2ksUwASr8U4+daVxW5UmPGrM38DGo3oTBOzgVPeJIZRnJ4i5m7Q7fdphLB0SAL8RkPVix/jyyDKLS17bJfak4pxDV9zv7i8n8Nx9k8BlpOsa38DchcqOwCYxty0JhCHF8/BtP0xjhBzIGD4VjyOPA3g2mM4U9UrVUkGJGfMWluwyECtNnFqA+7A0pr7FjfWyQgjMzy02Qzdcr/As5Uw==
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
 2021 08:29:52 +0000
Received: from BN9PR11MB5321.namprd11.prod.outlook.com
 ([fe80::5959:e459:a5e0:5881]) by BN9PR11MB5321.namprd11.prod.outlook.com
 ([fe80::5959:e459:a5e0:5881%9]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 08:29:52 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH v2 4.19 3/3] KVM: Use kvm_pfn_t for local PFN variable in hva_to_pfn_remapped()
Date:   Tue, 27 Jul 2021 11:29:24 +0300
Message-Id: <20210727082924.2336367-3-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210727082924.2336367-1-ovidiu.panait@windriver.com>
References: <20210727082924.2336367-1-ovidiu.panait@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR07CA0158.eurprd07.prod.outlook.com
 (2603:10a6:802:16::45) To BN9PR11MB5321.namprd11.prod.outlook.com
 (2603:10b6:408:136::8)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR07CA0158.eurprd07.prod.outlook.com (2603:10a6:802:16::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 08:29:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6cf164ea-5a42-4802-e50c-08d950d8b479
X-MS-TrafficTypeDiagnostic: BN6PR11MB1634:
X-Microsoft-Antispam-PRVS: <BN6PR11MB163425DC3DA587DFDECDDE03FEE99@BN6PR11MB1634.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1186;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sX5/a8d3R8b6nfOrXnRpHNxoWP/ZKf9IN1cq/cPT856HqdKqttkPkfxdVE+R9mMIBHbtB3Y9j06DOfO2TfsrT3M6zAOD+Rx1POlwfxEuUqFUlQhNtnhCTOuQ6jnfy21gHOZ3Pdu6fyLEfTyHWJR8zm2NOdsIBg4JI71UUUHL/JGJyGbMBGsDsrDsBsPwJkZvytX5t4KOfvfaT14aPU7KD8uctj8lGADFiivPK3Omi/5QYPmECqxyMh676yCVxw6VyL01F2CQ/qu8xKkX3OrlUX9wBX6/af1u/0wQc+9yzWV/JNHQNy5QPcqKge26pmC0MN+PgsAeJ4pTeb3g4jRE9pe+B/fHpxFkxAiDg+KHcHNOgmXetxHf3WA1AN9YyfoyJ4Mkzdqm/tpcobMzdK3NcBUxdujvXdhgq2jLf60OsdnKif5OWxdMUJyFTwy/H1mE4V0DQgeV0Mq4xCkMP435Z4SiiafIg6f7vjGu0v7HlHJpYOzxlzjUUbPghrIS760mFvr6+/glIjzfDZlIbvEe3g+4W8urhAOOWa+0Hrnawz/2Qpm5Q+xtVFLnuFSsmOz0iUVEqJ5Cddz4sI48Libb/IKjNPFKFDUwtHPqtIPCKE1uGJQvyDFZU8W43bXe65L22M00lvVvplAZODnx6obZeZSOzaydju1SbEsgCU92QomLSvIyenPplnCG3Dh79yF2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5321.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(2616005)(8676002)(956004)(5660300002)(316002)(6916009)(6486002)(52116002)(36756003)(1076003)(38350700002)(38100700002)(508600001)(8936002)(26005)(6512007)(66476007)(66556008)(66946007)(6506007)(2906002)(4326008)(6666004)(44832011)(86362001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dEpnc2tNaFE1bHMwQnBVRDZ6ZStFRE9XVEZDMHh1eGdabVFaa0JvbnZJUjBk?=
 =?utf-8?B?YXRadE0xVjBTT1FhV2RaNm9WYXpsOHkxSHVNUWROeHRDM09ZeXcxQkloZFQr?=
 =?utf-8?B?dThGS1IvcEM3U0tuUWtEeW9idkR3bjZIU0ZLRHdNU0JMSXJZYTJNc0llMkpP?=
 =?utf-8?B?TmxQcDhxM2tOVytNWVZHcDkvc0szUEMwdHJvQUlqeGlqNHpXR3dxSk4yRms3?=
 =?utf-8?B?MEpISi9YVUQ3Sm1qYkw4R2xGc0M1bnlOeFpYQkx2QVJjdjVqWFZCYkRYbUtL?=
 =?utf-8?B?MDRTVDF0bG1PZ0ZpYUFuTE90SlN0SjN3MUNaTUhmeGlkWVRoQ3ZpZHMrTXh0?=
 =?utf-8?B?dmJsOCtDYmJiWEJkSXd6R3VYVTBadC85UnhMZDhxaERidU5SWWZ5d3JxZG5T?=
 =?utf-8?B?QUV5QXlhcHZzQ3grU3lVVzllWDJnRklaZDdwdWhOVVBUeFpucjA4V3Z1UFpv?=
 =?utf-8?B?dWtGbzFKanJGYkh6bkI3cVRkZ3kyQkIzcU1LQlZDK0wrdWFYLzF1RkxMK3dp?=
 =?utf-8?B?bmpVdGRTUWJ5N2JrU1kxYU1lZkRyL2h1blM4am5pbngxNTZRcXNmT2praDh1?=
 =?utf-8?B?V0FnT1lSaEg1OVhWMEFDOEtmZ1RpM1FmU2JHajdBZ2NOYWUrcnNiZ051eitO?=
 =?utf-8?B?R2FyMG4rKzFrRkxxZGJaemM3RDJLc3plWE1Zby8vVlBESlQyeHFSYkREWGlR?=
 =?utf-8?B?VmJlbDh0TG92bXVIMnRIenZYajJJWnBsZ0c0U21MT25tRURJUkttYTNIbWhl?=
 =?utf-8?B?ODZqNUVRR3ZiUzdsU2dvVE1hYVZ5S1FnSzl2ZHBXdlVES01QRkNhRE1oam95?=
 =?utf-8?B?N2JYeHl2cHk3bzhhVmRZQTBsSWlNMWlMWjQvVmlvK2hDY2tTUkNFbHN0aDFO?=
 =?utf-8?B?dFU1blZBVFd3dzFXSWQzWkV6TUhHMnZ5ZEhTNG4xa2orT2VKZzZRV2J4ampV?=
 =?utf-8?B?Y20ramJyQ080SVNhbHB5elY1SUN0UmpqNmsrSVl0S3RrMjVIWEpnNzlFL1JM?=
 =?utf-8?B?dnVINmdPRnRuNWs4SWcxOUtXTVFlNnN2ay9ONkJocGFlaHFqR1VQRWllcUVF?=
 =?utf-8?B?Y3pxbVhuQ2RwdE82SndyTDJYMk9WbUtkRDA1WUhLMmJha08zdXp2RDFXaGIx?=
 =?utf-8?B?VU9hOFRSUG9FSERvMEc2a3RtNVhGNTdIK3IrU0xuZ295bzN1cWN0b2pLQmFV?=
 =?utf-8?B?TDg3SVVST0hwWEJDc1d2MytaQTg4b0Z5ZTI2eWZSaXNwT05PcVZwT2lLR1RN?=
 =?utf-8?B?Z1J1a0Y1clpsODgwKzRYL2NMWVlZc2tSMmI4WkZlNlY2RXVXQ3ZQQkl1REs4?=
 =?utf-8?B?UlczeTM0YlhQT1E2TlBra0VPb2VJaTlod1dFZmZOYklCU1A0Ry9Rd1Y4dnZi?=
 =?utf-8?B?aHhUZm9NU1hyOUJTWUJUL25oRktLaDNTajNyZFl6UjltdEQzSVlYNTllbEp4?=
 =?utf-8?B?ZnFkUndMdnBkbGw1bWtnYmNNYSt1eVlaUUx2c2hRaWV1M0Q2MDNGNnFBelBB?=
 =?utf-8?B?bVZDZ0NqdWVIVXpTeWlJOVNFTDZEQUVQbjhBeFZnVDROMlNXYlFONXBtUnBn?=
 =?utf-8?B?clZDcmxBaThIcEdrL000NElPWkc1Z0FwZGRLVjhENVpGR2wvalNHQkZVRnhZ?=
 =?utf-8?B?UVNETkE2YzRidXdReEk3MEkzK0c0TURIclE4K3NNZkJLTHVTaW0vRGtTWmV3?=
 =?utf-8?B?ZUZ2MDlQTlRYaVVXSmxIQzNDR20xSHhCZUJZZGNkTzd5cHZmYURDSENnV0Zx?=
 =?utf-8?Q?5+LgbAbjRsisGT0lSTiIshK4C7hqF4ZHYEsb1yG?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cf164ea-5a42-4802-e50c-08d950d8b479
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5321.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 08:29:52.2373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yq0izG6zt4FREjivxQpdRIu7RCDb9TMBORcO1PyllB7KJMDUHxInaQLw8CQ1A8mZTrcV4+toOGkjRJEikjhV9TqhXowm5X1o/vM837ALRmI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1634
X-Proofpoint-GUID: 2GTbX7FaFenDmiRiClILg3I4eLOVE5Mo
X-Proofpoint-ORIG-GUID: 2GTbX7FaFenDmiRiClILg3I4eLOVE5Mo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-07-27_05,2021-07-27_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 spamscore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=910
 suspectscore=0 clxscore=1015 bulkscore=0 malwarescore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270048
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit a9545779ee9e9e103648f6f2552e73cfe808d0f4 upstream

Use kvm_pfn_t, a.k.a. u64, for the local 'pfn' variable when retrieving
a so called "remapped" hva/pfn pair.  In theory, the hva could resolve to
a pfn in high memory on a 32-bit kernel.

This bug was inadvertantly exposed by commit bd2fae8da794 ("KVM: do not
assume PTE is writable after follow_pfn"), which added an error PFN value
to the mix, causing gcc to comlain about overflowing the unsigned long.

  arch/x86/kvm/../../../virt/kvm/kvm_main.c: In function ‘hva_to_pfn_remapped’:
  include/linux/kvm_host.h:89:30: error: conversion from ‘long long unsigned int’
                                  to ‘long unsigned int’ changes value from
                                  ‘9218868437227405314’ to ‘2’ [-Werror=overflow]
   89 | #define KVM_PFN_ERR_RO_FAULT (KVM_PFN_ERR_MASK + 2)
      |                              ^
virt/kvm/kvm_main.c:1935:9: note: in expansion of macro ‘KVM_PFN_ERR_RO_FAULT’

Cc: stable@vger.kernel.org
Fixes: add6a0cd1c5b ("KVM: MMU: try to fix up page faults before giving up")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210208201940.1258328-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3559eba5f502..a3d82113ae1c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1501,7 +1501,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 			       bool write_fault, bool *writable,
 			       kvm_pfn_t *p_pfn)
 {
-	unsigned long pfn;
+	kvm_pfn_t pfn;
 	pte_t *ptep;
 	spinlock_t *ptl;
 	int r;
-- 
2.25.1

