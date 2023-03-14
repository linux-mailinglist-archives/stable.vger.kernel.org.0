Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D17B6B8E72
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 10:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbjCNJT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 05:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbjCNJTX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 05:19:23 -0400
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2114.outbound.protection.outlook.com [40.107.249.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62C0A97FF3
        for <stable@vger.kernel.org>; Tue, 14 Mar 2023 02:19:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iUl2ylW5P5wkQP/g3DpHCp+XtMXh41pFUvumvHjMr/M8qL7MWuklZSIKgy4/nc5Bv62wi76R2aaePwE7W/w83F0HAWrQAUXMGlTBoHD7Y+i0XZy9td2QFGJfl7BUuQ1aAh42NaBiNMhDn+6gFNkwVF8MLEdxMlGcsynrFHFZ02cqQ/LWm4kQ6E5Lx+gJTerRGT2fEEI/9V+63aCxxVu2h0m40fKaApMM9NTcPju6ebNjbta9VwgnapVZqzpC0w+bhlYa5EPUMTXWiWXxDVpkaeIy5CneDy7ASi0o/nWWDx2mF/XFh21TxAEG+tbvxO40HIL3Wr3HKMYmH53egGEPKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5DSbBIwojVebY32/yMINMNiDnisoaLB+WhMhTRsPlMo=;
 b=Mfexe1DP1PdVwpTWVb1FJHpv96FOphxNLPume5adfoNlN+xw9xQ+Ujz5j2hh2d9z9mPyJFRofaIUzuhsfTFVuYTZCqFKXom7z3Uhb2U29okJut6oRJhks0ibstJ26OHh69Sfu/c0gxeBlmWqyCvbFJdRKR35NVWJoXDw1Wl3ShlApcjD0Qxheh6ScEIoblFTIZWsOR0UUtaDQYnx8G48F5Les08Ya0r+aorbIdAWAeh3p2AFUgZ/I+1j2fsrjfYoTgadfiwDXES1kP7x0qGSFqG8hX54uDbzotnl75H+TzaQkCCBjZRh8BIr0vHvJP2HfTzVXiJddRUuN/Ul2g8rsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=uipath.com; dmarc=pass action=none header.from=uipath.com;
 dkim=pass header.d=uipath.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uipath.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5DSbBIwojVebY32/yMINMNiDnisoaLB+WhMhTRsPlMo=;
 b=qNCIeO+S84XZ9cwMgENGlvJ85HE8h+xQ/2zGZx4Q5TAkODpP+UvlQhRNJKPfsCaiCwTjaUpOQnqvsWoglMS3ZCmGWB2w4vQ6O0OKkdtuJEtHlW+ONWPnso2TG+ymmdlEn+FH8Jnhazqty/Em3SUjlDS2C8btH/BBU6ov7+gq3mVAfUfvfSMFUwtFtNJg2q6pmPGUorLPCnRCHmwdDQmg+ybUt8Z/KW1Gxt/Wxdhq0wydQAxknAF5thd+NyoWSz5mcWpMWdXhoLt93NRfRkuEpc3KffX3yzRP2XOu1uYHBPeb5Fa3iwZVgo0yOu/nLV1u4fH8Pw1MDszi703xkJ3YxA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=uipath.com;
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com (2603:10a6:803:b1::28)
 by PA4PR02MB6543.eurprd02.prod.outlook.com (2603:10a6:102:fe::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 09:19:17 +0000
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::224e:d6bd:a174:9605]) by VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::224e:d6bd:a174:9605%6]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 09:19:17 +0000
From:   Alexandru Matei <alexandru.matei@uipath.com>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexandru Matei <alexandru.matei@uipath.com>,
        Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
Subject: [PATCH 5.10.y 1/3] KVM: nVMX: Don't use Enlightened MSR Bitmap for L3
Date:   Tue, 14 Mar 2023 11:18:59 +0200
Message-Id: <20230314091901.2975-2-alexandru.matei@uipath.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230314091901.2975-1-alexandru.matei@uipath.com>
References: <167811889022881@kroah.com>
 <20230314091901.2975-1-alexandru.matei@uipath.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P194CA0050.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:803:3c::39) To VI1PR02MB4527.eurprd02.prod.outlook.com
 (2603:10a6:803:b1::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR02MB4527:EE_|PA4PR02MB6543:EE_
X-MS-Office365-Filtering-Correlation-Id: c06874d9-8864-4d07-4ded-08db246d2f4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F+fc6FOLloo2ypv86H9h/nRcE0SIYJUCS04Qo8pTtRjkAfWBmE9opoEGFkKP/36kuMr59/dullQ2O499qY5sigIklqggpj1g2qAU8G5Jo1qoWDqydQu3i2/mwx8tbpDMYocLe28g51LuxE2C+6muH827D1/pZmyA6ASd+ZVkjMeg3aD3/FMJVuBWd887tR5qHphaJLj8nJ7JBf9BjuebY9+hq+xBw8/r7Fw21cWgWt1DJCzIKisCW/DfHnAP/ALV9rNP+hHkM3VEuKjXzxf3xfD59I1fm9pt5MTcf9gk6Kik9zEGAb2OKnMr5Dm1EzFhmLdJDOA/TEBC4XPyax8u/IFMVa28ViYek+o0Q3o+QMmGCHa/XEhsyXJllDAgU3Cx44ScvCvEksr9E25O5IwpTO6qnMKXeLw9CKI+0dphYQ/HzACMakXUnHKcAKVeWFM09Amj0xyU5MhXrnIeha3/jKg6l8zn9poPhHnH6meH42eFHkUgBQIu1Ou3CKXplXDVHmBMV4B/Bx8UZCrMEJ91SrZA2iaglNz9UoqUPhE0nSINw5tLOwmyC3EO4dagWpIKS5vsqCge/Ol03ZuQAZmAAf556Wwza9f3ZnrpnfHcizGgc1AR9av0xxAsER512Z0PcqnSVRns2SGr/4Z2SmLg/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR02MB4527.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(39860400002)(366004)(376002)(136003)(451199018)(5660300002)(41300700001)(44832011)(2906002)(38100700002)(86362001)(36756003)(8936002)(478600001)(6486002)(66476007)(8676002)(66946007)(66556008)(107886003)(6666004)(6916009)(4326008)(83380400001)(54906003)(316002)(186003)(1076003)(26005)(6512007)(2616005)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RLNcIh/Qr3cNCWysRSAylA5zRSY0o5Yish/t6LX+YJbgI0GrDy19G4gNDpTg?=
 =?us-ascii?Q?Q2d5V2sV3v164zyuhD5kmZbxY3I3u21y3dzxl8bbKEQRyLpbOm13Of9nUph6?=
 =?us-ascii?Q?R2GYa9t58Xh+7tJQuF+lvY8Ra3YBpT3EUzZLyH/j0neDezpmxBQlOr0kHpKq?=
 =?us-ascii?Q?e95QdCb6XHex9WRK9GIbSslOkFzBth/6lvXBxTkkwVa7Qb1EY2SLLpiPQwKn?=
 =?us-ascii?Q?amFOPCV/rIei59CkAjgFWYlK/qBlpDnGOcQfDR+VpPa0wsj7QQqdfAZHPHDq?=
 =?us-ascii?Q?0JAfc16kJbv+GzggAdc7/P2bySOCnwqX2B+ccLOzN4qwyGyRhbXmvpSaxKp+?=
 =?us-ascii?Q?FiGdkufHOZr3nucj9pJYlDRFo9gPpBen7AzLyrBHGu67l6t1lQs4IBG7F/Ts?=
 =?us-ascii?Q?/N6ioWBnqdPtQAdzE9nOLbjYWdmFZCEwLufPD3GjrPME8q06zuG94K+Wkxhg?=
 =?us-ascii?Q?EXJDj3lc1S0aBygtzDeDDbc2YEl9vkJXSvsfZAxUn9Z9e93lcKPU1RulpOVG?=
 =?us-ascii?Q?UolwcKh/bFNUofhHtyY9m/UMIecZ6FzvgriC7+C94oXXWpsj0j6/SdGwGWIS?=
 =?us-ascii?Q?NiHyQF9Taws/gzEPkV/qnZ5aJc6PbUf6+tXwdpiOkqBZI5J+cCJT2nhh4usq?=
 =?us-ascii?Q?RetUdoCrNy6BmQEYUijf5lIWPF2me6eNQS6S5HxysFXzbWdIXOEaQ9EkUFW8?=
 =?us-ascii?Q?xfzCzl0kv/kj2h2EMdnPWTQkQ5KrTj2YXMi+OEGD+xsAGxaqz7XNKA76kqfO?=
 =?us-ascii?Q?/48x7zYtCPgS79faFdI2WKK3WMO2Gd3aQUjqrie90VBsxdh7UB5eHN0OgCRX?=
 =?us-ascii?Q?ae9a8SU+HA92Ll5cmLFJxwRQyiW17e+NSAypct4EUMp60xURQP+4jbIY9kVK?=
 =?us-ascii?Q?GkKt083IIiUoTGud+4zFhyF/Nni3Qorfqyye1czt0cOE+jQ/0zdVNfEQNMj2?=
 =?us-ascii?Q?Y1O6I/SE+UKQC2G6ETMzGqIj+5aBolpPSiCUDthBMY5mx+YGrE0Urf0w/9es?=
 =?us-ascii?Q?9Z2i600Bk5yJkS9ActJ2kiJwuHwUcZHNVTWBJa98Z93QGktnIwz3jzuBTEjP?=
 =?us-ascii?Q?EpbsJAe0rJVun3Oh24qvrKl//zx0tlgxV9srPUrfkZJmDUWdxzloveK9qGla?=
 =?us-ascii?Q?SmooakEfvo/2jnpQ4tEF/TplSsr5NfUiM5mFo4KSA2vJEcnnBtQyBows4yet?=
 =?us-ascii?Q?Bs+AOIKNOafhYjUtcJRCjxEaS0IT8rVmbozu6CnhIiq0mt3c7mUpNhQnaOPl?=
 =?us-ascii?Q?3fFhPqkk8yc0sOhHsj6JaLX9Yr5Xv5xxZtZrXT2Cqdp0nNG9wwZ8rxB3ynLY?=
 =?us-ascii?Q?ySaafVHuKzV+LTkbKmaNtJZoatwyQUDTZVIVFa6iGLtMsjPPZH/IZK2zJhG2?=
 =?us-ascii?Q?4ejeS0zC8BcIGHZP4ec8lBvbSCQkfFs5QRExJDcWrA90w5yQ3N+geaTn3Yvo?=
 =?us-ascii?Q?/0RXCAf00NnISNZwMM2olbDDQpAyrNBPaVdWSbLVm5VbM9i9wP4Hnvh+AuHp?=
 =?us-ascii?Q?Di8RakyCf1uP3U3A0458DMI8NUEpF8eunhsTv6MjmFXAY15Ch4xn+2N6dwgb?=
 =?us-ascii?Q?1cw2bs5KflyX1iMPJTBmxp83FKWZxpXbLbzuuClNgCofC46/gGPmrBf4mUy8?=
 =?us-ascii?Q?Dw=3D=3D?=
X-OriginatorOrg: uipath.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c06874d9-8864-4d07-4ded-08db246d2f4d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR02MB4527.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 09:19:17.0437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d8353d2a-b153-4d17-8827-902c51f72357
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4jEKj3PA4c3K3GDH9TM9Z1mDnHAHz6HDHgCopJmi3y3WNOR31q1Tf7fW3wYml2J7hxC+rQUqL/JhzwsixchVMX6L2slXYFQyhe+2eGi/6VQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR02MB6543
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

commit 250552b925ce400c17d166422fde9bb215958481 upstream.

When KVM runs as a nested hypervisor on top of Hyper-V it uses Enlightened
VMCS and enables Enlightened MSR Bitmap feature for its L1s and L2s (which
are actually L2s and L3s from Hyper-V's perspective). When MSR bitmap is
updated, KVM has to reset HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP from
clean fields to make Hyper-V aware of the change. For KVM's L1s, this is
done in vmx_disable_intercept_for_msr()/vmx_enable_intercept_for_msr().
MSR bitmap for L2 is build in nested_vmx_prepare_msr_bitmap() by blending
MSR bitmap for L1 and L1's idea of MSR bitmap for L2. KVM, however, doesn't
check if the resulting bitmap is different and never cleans
HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP in eVMCS02. This is incorrect and
may result in Hyper-V missing the update.

The issue could've been solved by calling evmcs_touch_msr_bitmap() for
eVMCS02 from nested_vmx_prepare_msr_bitmap() unconditionally but doing so
would not give any performance benefits (compared to not using Enlightened
MSR Bitmap at all). 3-level nesting is also not a very common setup
nowadays.

Don't enable 'Enlightened MSR Bitmap' feature for KVM's L2s (real L3s) for
now.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20211129094704.326635-2-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c37cbd3fdd85..eefd6387a99d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2725,15 +2725,6 @@ int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs)
 		if (!loaded_vmcs->msr_bitmap)
 			goto out_vmcs;
 		memset(loaded_vmcs->msr_bitmap, 0xff, PAGE_SIZE);
-
-		if (IS_ENABLED(CONFIG_HYPERV) &&
-		    static_branch_unlikely(&enable_evmcs) &&
-		    (ms_hyperv.nested_features & HV_X64_NESTED_MSR_BITMAP)) {
-			struct hv_enlightened_vmcs *evmcs =
-				(struct hv_enlightened_vmcs *)loaded_vmcs->vmcs;
-
-			evmcs->hv_enlightenments_control.msr_bitmap = 1;
-		}
 	}
 
 	memset(&loaded_vmcs->host_state, 0, sizeof(struct vmcs_host_state));
@@ -7029,6 +7020,19 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 	if (err < 0)
 		goto free_pml;
 
+	/*
+	 * Use Hyper-V 'Enlightened MSR Bitmap' feature when KVM runs as a
+	 * nested (L1) hypervisor and Hyper-V in L0 supports it. Enable the
+	 * feature only for vmcs01, KVM currently isn't equipped to realize any
+	 * performance benefits from enabling it for vmcs02.
+	 */
+	if (IS_ENABLED(CONFIG_HYPERV) && static_branch_unlikely(&enable_evmcs) &&
+	    (ms_hyperv.nested_features & HV_X64_NESTED_MSR_BITMAP)) {
+		struct hv_enlightened_vmcs *evmcs = (void *)vmx->vmcs01.vmcs;
+
+		evmcs->hv_enlightenments_control.msr_bitmap = 1;
+	}
+
 	/* The MSR bitmap starts with all ones */
 	bitmap_fill(vmx->shadow_msr_intercept.read, MAX_POSSIBLE_PASSTHROUGH_MSRS);
 	bitmap_fill(vmx->shadow_msr_intercept.write, MAX_POSSIBLE_PASSTHROUGH_MSRS);
-- 
2.25.1

