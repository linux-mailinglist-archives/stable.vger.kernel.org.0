Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 872713758DA
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 19:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236065AbhEFRFL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 13:05:11 -0400
Received: from mx0b-002c1b01.pphosted.com ([148.163.155.12]:22664 "EHLO
        mx0b-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236052AbhEFRFL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 May 2021 13:05:11 -0400
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 146GvSHv004005;
        Thu, 6 May 2021 10:03:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=proofpoint20171006;
 bh=PI+3+N0cuqklw2gpE3JR2fvCp/DBCDavESkuZhmTGJA=;
 b=OC8RA8c4fjJ7x2QM2mBgzYmBVcDHD7yLxB7xsYDggsnRry5OOF8ORtGRBFvbg7IFaCX+
 WoxBCYkszZU3HCWHg1qkyOVUY3rxzR1L6X4gYrrryq5geHyz363MJegZV1MNdXukbPZb
 AK6JJXc6nnUgeNePKxGyobwj+bJXASojWnaO2FGuluv5n0hg5eiBkdfGeEK8d1iStSU9
 srsgBitAYlCFNfAhw5egmbG+E73RjDx1Dq/6W/Qd3Dr+guQwEWlsmg5/mcMagZ3ge29Q
 MQ17tkJP2YoUIk1mw6ZgtcipMK4ZNtr8RNzaBQPxMWu1K45cPqeSuR2jhvofqViOqqOg vA== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by mx0b-002c1b01.pphosted.com with ESMTP id 38chwf8da4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 May 2021 10:03:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mb1CwvcNlx3uCU2fGkcMLYAHKUCEVRTKoZAH8NzUZRE6zoi6aGx+ZKCfjKzAD8q9DeE4ozF403VkLknYOeBkgChFX5+jKlh7ChRSYvphzXjn7EXzaORr8V4l+cUw9PApGZu4bkenCZs2G6yT4qnt2Ozt4Ch5fIFd7hY2yfACg/R4yAQzbv71emPFB4ersbfMdhVPfRtAiNU+YmzoDUNAlYQOhcZmI/v3tOlCiuX52Hs93tsgiaVM9/aaRLqEIuHytR2yAg2oYFKDnHyQvJYPWxVzGq7026ptsd3wlg9EhtfmTHWO8hW/VqZfQvSvei7wqxdcTvwaocFuXcnQ19AQMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PI+3+N0cuqklw2gpE3JR2fvCp/DBCDavESkuZhmTGJA=;
 b=ZZSxe/8ZilEnbtGS+8xZ+/JLQ0Z9dXkkS1xqHVJ46iU8f4XE4MPuXXne0My7gHB4JUbXaXMmyNj0+Tl6L8ucxsuxq69gfZeZGdsyd8rpVtK5XA/lV0zdDIPtOadjbvGyXh8PZrpS1awJbxy5qktmaDe9sfFyihx8xoVNpPXDJeHMDM4ONAarHJLHqGEnzNYw9axlkSnyClexmQJUSR41HSfrx9Bzio0pvZ5GMdorbEy/5obPUP+ec6VsAeufs+bCEvu7R0c9QQejQVP5jIRGl6VLc9Z1yth/JNRLrmhzrjcufEg25G7kmijjL6xV8pLIa3L6Ut0gPPGRkGOp510nAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Authentication-Results: nutanix.com; dkim=none (message not signed)
 header.d=none;nutanix.com; dmarc=none action=none header.from=nutanix.com;
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by MN2PR02MB6464.namprd02.prod.outlook.com (2603:10b6:208:184::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25; Thu, 6 May
 2021 17:03:08 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::75cf:5b99:f963:cc07]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::75cf:5b99:f963:cc07%5]) with mapi id 15.20.4087.045; Thu, 6 May 2021
 17:03:07 +0000
From:   Jon Kohler <jon@nutanix.com>
Cc:     Jon Kohler <jon@nutanix.com>, stable@vger.kernel.org,
        Babu Moger <babu.moger@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: move saving of arch.host_pkru to kvm_arch_vcpu_load in 5.4.y
Date:   Thu,  6 May 2021 13:02:41 -0400
Message-Id: <20210506170241.72133-1-jon@nutanix.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2601:19b:c501:64d0:a9a2:6149:85cc:8a4]
X-ClientProxiedBy: BN9PR03CA0337.namprd03.prod.outlook.com
 (2603:10b6:408:f6::12) To BL0PR02MB4579.namprd02.prod.outlook.com
 (2603:10b6:208:4b::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from C02F13YVQ05N.corp.nutanix.com (2601:19b:c501:64d0:a9a2:6149:85cc:8a4) by BN9PR03CA0337.namprd03.prod.outlook.com (2603:10b6:408:f6::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Thu, 6 May 2021 17:03:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 910866a2-8cfe-4407-e8c4-08d910b0d231
X-MS-TrafficTypeDiagnostic: MN2PR02MB6464:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR02MB6464A2C3D069594638756385AF589@MN2PR02MB6464.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:612;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o4UVTiCD4fEH3zDNwCD4XEMMjxXX4hIIDnjIO5hXX9Z1GTjdNAe/kpAch9UCAsSsUMYEjEUT8CUqqfXrjDCFj0eb9zkAy6p19X1VXGgk56UHzCcBfSusabZsexgfwUPxgnJJDFxl/GJL8uZWnYZhK2HJ3C9NrqcrRg7SnSaeP7LV3xJdiqi1YfXMgRLBm97sgNCqx/zWH7cv/Kx9wre5gyR7gjabEpwFgZK8oRVorSCRP1/c/55QFARlQe/PnW1R/8CiMoml7L2vk2kPV1p3W6JKOx9VfVoBohD3FcJ5u8QYhi99Qr74Wsj+lw4M035vEJi0Jsh9iApRx9D3HMfQpr8pOxufSJr/ngZkJEsjTYF5STm2c4vh9tZPwu4DU0YPgNNoAW4VVNRUYdJnFnrtDjdaUjCM1ZpYgcBrm/gwdJIlUsCyyRTisR0gV/iOtqCkalPpryNDZ5QvNBE0SX/VxqjrlawZwl0vfQydimn1XZfGP65zdPru7CPPmqx3OnOaioPlZ9URMyCegfSSQdDhBt9qbvB4jY/17iSx7nuVdUlbUl1xJUVUnxN/31LcAjUv4o2mTKWQIZbI+89CDuKFBoOW0FnxlSeob31VvjZiutSisMzYn66cSuqc+eToBkAaMnlGzyv0C5OtCxoJiX61cg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(39850400004)(396003)(136003)(366004)(83380400001)(66476007)(16526019)(186003)(66556008)(38100700002)(6666004)(1076003)(2616005)(66946007)(86362001)(54906003)(2906002)(7696005)(478600001)(6486002)(109986005)(316002)(7416002)(52116002)(8676002)(8936002)(36756003)(5660300002)(4326008)(266003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ExFbT6AF0k8cJ4JwjCQWkqlV9C+gtHfrTR4b2VgmbYutbXqAbDbGoJihlJZL?=
 =?us-ascii?Q?y4fs0bxIXn4U0YnSJUFSXepI4H4ovfT4Jz9Jlc+wDusQLu9MiePxNuALmY1y?=
 =?us-ascii?Q?K4aac3mPNwMOZnZjmbmV9qFct8rrkvcefvJ9L638z4YshG/6YpDULQPISlha?=
 =?us-ascii?Q?a4MXJ6qJ6woMSeZ3mZXiWKR8WKsiy14AVfdKVzQKd/IT3FdCda2OiPws7W5z?=
 =?us-ascii?Q?c7k2gfpHKJ/1eUDLO84l0IorsJPvJxBiB+Ur3bpoGjD6Hk79KH2wvHO7Rv84?=
 =?us-ascii?Q?yL5ISmeu1ujZYdUfkiyr81p2fK6vUC78H3aYDxxSx0oWHHtRe27JNIADVgGM?=
 =?us-ascii?Q?xNGQLTQix0rA0PfQ87LV5GZoqNMHvzSChqh0UCHV1yVNuynUdZ2BbzGmgZIM?=
 =?us-ascii?Q?Js39eb0wuUqALK3xR4a30hl2joxt5Bg5P/MRLs4iIsM6wUD9S4EIom89+JLD?=
 =?us-ascii?Q?m3cFtzRhtX0um4Qk+8MQ526puNADi2TUHy/YJ0tpcrSJVaf5BUFujGXXCsfZ?=
 =?us-ascii?Q?904WtJyTpottpbKXK4iZ1z5OHEFSciHa52FuUhXT5RhAJzeFJfoRLstwRkXD?=
 =?us-ascii?Q?dpCgxZE1RmAQZwye7uLvbzKNd+KcADt5fZp66rNBSre8uAkzbnrnbUvVvjHf?=
 =?us-ascii?Q?AxenMPEA1QCaNXLcJCEOSUE+lA+G8xg5hQ57iDhvJrmjHhqnh28M3IR6bTXM?=
 =?us-ascii?Q?F7pPxyPSp/Du+PuCQHOlxSd4D2VKQ4au4G4MIeQPqZZcEsHiPpeawfnh6m+B?=
 =?us-ascii?Q?cw90n4LIFuCMvHDku7s4uYboNqN9wWyvEMaO78Vr38cbmV6tpDZiDWlcjgeG?=
 =?us-ascii?Q?1jYEDzsN2TZtmSUQONIxhL14SQRP1jnXKgSasYgoYpbDQgSBI+5FoKoUkriK?=
 =?us-ascii?Q?YSLIn395BseYsLO7eYvbeuaPv75aUeFvBwrRxhTd4Psp2Gwfymx54I/cWE7E?=
 =?us-ascii?Q?mpvIyxFk+ilB+bb8Hm5GqVzXmeiycAblY+CIBmJl9+INSw97OQk+Au5MygJb?=
 =?us-ascii?Q?90cTH5u+Fm1pSFR+CPqErET8v7Goztb0WVJSP/gG08Tggr17+W8B3U4E6O8U?=
 =?us-ascii?Q?gEEs4WwNcxSW3q8XY9tHPySJDV9QnOqbYwxsAn7dURomx53LZgHi7AjY8viY?=
 =?us-ascii?Q?BrPZkhL5og8pclCSWvAtOWUD/TKHeFhY/wdGqCRp+o1R1TZCvpyK19L942rw?=
 =?us-ascii?Q?d0yhV6+OxJxhX5lbhExLgvpBv0l8UQQWlbQwOXqUikaz37xAjOnaVxOyci/Z?=
 =?us-ascii?Q?n525ZDLDy5Da8tlzVG8uL++xCas9dYuFe7De8c1+aNnIeYkksQKBf1+nzXux?=
 =?us-ascii?Q?+7ert9AS4zRAwoBuMJRavz2l9dYI04vA3NFMQIcv6SZJTSdDQlX4AC6vR4p/?=
 =?us-ascii?Q?UM3LAIRKts5mXFuv9o/EygNvxZcR?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 910866a2-8cfe-4407-e8c4-08d910b0d231
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2021 17:03:07.8049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VHG/kIMnWfSftmRmrf4SKPtMfCbbVInLv/5s99id4YwkkEuC2fCkfUfyR0y4sUoXO/K+TqYY5+sDPR2pO+aD9MX/lk0QIzfrv6tOnK0pFBs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR02MB6464
X-Proofpoint-ORIG-GUID: IjWa_SNOYMXzEnyYEdQFXr5blDfUhqlt
X-Proofpoint-GUID: IjWa_SNOYMXzEnyYEdQFXr5blDfUhqlt
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-06_10:2021-05-06,2021-05-06 signatures=0
X-Proofpoint-Spam-Reason: safe
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 37486135d3a7b03acc7755b63627a130437f066a upstream.

In 5.4.y only, vcpu->arch.host_pkru is being set on every run thru
of vcpu_enter_guest, when it really only needs to be set on load. As
a result, we're doing a rdpkru on supported CPUs on every iteration
of vcpu_enter_guest even though the value never changes.

Mainline and 5.10.y already has host_pkru being initialized in
kvm_arch_vcpu_load. This change is 5.4.y specific and moves
host_pkru save to kvm_arch_vcpu_load.

Fixes: 99e392a4979b ("KVM: x86: Fix pkru save/restore when guest CR4.PKE=0, move it to x86.c")
Cc: stable@vger.kernel.org # 5.4.y
Cc: Babu Moger <babu.moger@amd.com>
Signed-off-by: Jon Kohler <jon@nutanix.com>
---
 arch/x86/kvm/x86.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 153659e8f403..1f7521752a94 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3507,6 +3507,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	kvm_x86_ops->vcpu_load(vcpu, cpu);
 
+	/* Save host pkru register if supported */
+	vcpu->arch.host_pkru = read_pkru();
+
 	/* Apply any externally detected TSC adjustments (due to suspend) */
 	if (unlikely(vcpu->arch.tsc_offset_adjustment)) {
 		adjust_tsc_offset_host(vcpu, vcpu->arch.tsc_offset_adjustment);
@@ -8253,9 +8256,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	trace_kvm_entry(vcpu->vcpu_id);
 	guest_enter_irqoff();
 
-	/* Save host pkru register if supported */
-	vcpu->arch.host_pkru = read_pkru();
-
 	fpregs_assert_state_consistent();
 	if (test_thread_flag(TIF_NEED_FPU_LOAD))
 		switch_fpu_return();
-- 
2.30.1 (Apple Git-130)

