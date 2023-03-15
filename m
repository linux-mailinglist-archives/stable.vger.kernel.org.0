Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77DE56BABA2
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 10:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbjCOJIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 05:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbjCOJHe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 05:07:34 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2131.outbound.protection.outlook.com [40.107.15.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6417B984
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 02:06:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LS2JMXZAMIG+UT/DJAZa2iGeNUMVUvBk7eDocxnSLCvJwITWc7/nFsG/OwX7Peqe3bsZbskuJ4fO6HYzwE9RbRsLOq9CZh5shyKPOGiwagAaxAEnXMT8NfZdbqV1KKHw0qu1RuQ0DrTjtwq/PqkT6C3sTKy4K7gEBfnMvaAJDpADZieBM8q7kYR1B2Fbx5MoCLd6Jyb3+6aG5CJsF33+kGEIWq44U4Aak3dVXuJfPIUeshbpj8ZFpCKv9/pOjzKZS6zVYXxtPcM81K4/lfkl3qOvaIcMu0/b4VAXnWLHZsWSdC+veXwq5EOzeOzFF7DlUflllHk+TMRFF5X7lm/W7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iALStBCbLmSDR0Yd5IWPpnRALmdzGCPCycBIdImiLo8=;
 b=L5vFR1D1Ie3WVmxd9thTWLTNlADlUK0xwmDjKa+NxzcCZLlIdR1DTNfM3woMtQiyoih0i7RQwOVy8o17Z7kNZH/AzkcRBjOZ1DR/WcU4i0E3OF9k8qk0IHPltT6D78XbLhiTJgEmP4735kD4pr9/xBdBx1aKUnPU+XBUCjmhaji1BDo4ACQ6tPoaskD+x/G9hX8N2bEj2yopaj00v+QXr8bMH2lF6gWiXYg5iIL2+g1Dt08gTM5FDP8PuZRTG2GhAoesjZhELKngtWezSmYYUtWnABJBC3JTvMZytmJcjkVYtB+jT8efvfZGb0/72HIi1JdI5HT63xKw6tA27+07Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=uipath.com; dmarc=pass action=none header.from=uipath.com;
 dkim=pass header.d=uipath.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uipath.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iALStBCbLmSDR0Yd5IWPpnRALmdzGCPCycBIdImiLo8=;
 b=SInVr9cAAZVZnz5LLRg3ygL0J0q5YDL0vbSDEx5E5kp6S/2dqtYyXlanChhPRoYOy5ZnsTYuJS80R45tRNEOYNdCmuoqDXLApZjxJ8eeSRZLvKbDhF2AmvozMRd87V+CPZZb3Yzbw7KFvhBsaaaCwkcg7s8YyvnlKCHVV0pXHCAJBWlssVcah1oOPNkRDU+QBws2+kFfM0VuGVXa1Tyj++5xg66A7m29/g7zgi/yrZS62kFnp9PWAt2w/wDVRZrNPnVv1QEBEywWC14ETvFq/js4AfHHzlL4akf4faljBvCa3vL5U0UkL8E6WhRDwjta0zcJ8DKEtOAo1Hml7p4DiQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=uipath.com;
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com (2603:10a6:803:b1::28)
 by PAVPR02MB9866.eurprd02.prod.outlook.com (2603:10a6:102:310::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 09:05:56 +0000
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::224e:d6bd:a174:9605]) by VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::224e:d6bd:a174:9605%6]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 09:05:56 +0000
From:   Alexandru Matei <alexandru.matei@uipath.com>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexandru Matei <alexandru.matei@uipath.com>,
        Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
Subject: [PATCH 5.10.y v2 1/3] KVM: nVMX: Don't use Enlightened MSR Bitmap for L3
Date:   Wed, 15 Mar 2023 11:05:26 +0200
Message-Id: <20230315090528.4180-2-alexandru.matei@uipath.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230315090528.4180-1-alexandru.matei@uipath.com>
References: <20230315090528.4180-1-alexandru.matei@uipath.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0105.eurprd06.prod.outlook.com
 (2603:10a6:803:8c::34) To VI1PR02MB4527.eurprd02.prod.outlook.com
 (2603:10a6:803:b1::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR02MB4527:EE_|PAVPR02MB9866:EE_
X-MS-Office365-Filtering-Correlation-Id: c2665147-3acd-40b5-02be-08db25347c96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W0pkjXqBzXrVjDrEMeI2x2vkV93iwSS2y9gRT9Xk7f10GfyiEN5x3fTjk9gw9pELNUhBWvo13l1AI0vrwo6US4xbCnHLPo53NkKUx7d9IEEcavggOoMNk4+8VzO32fTZH2mFJnFToKuQh1fnvhUCaFgNvzgNXu30SqFB1VfPcnCcRip4TaLuO8Kj/Tzr5WJgF6o4ZK5BRrwevH25Yn2iTo+8vVmtfeTz++QFJOpmL4L6Z/HDNG2qRxqLJVPrdVcWBUPVAzJvVbZ2Dwb7jNVpPBHyecbxu+zRaR4dnlnoN5U+N6RhsK5YIVzH5K+2C6TIk6L36djdcdi+kY9FyTVPvSuTLZ3tSVB7oHiOT2x2tcIIvcvU9oxZj53Ndyny9Uuv79nezSs/PjTqwUXAfIwLFnlSXDSwzg6S+gZ46SZWVUaNlapEib5ymQ3IKwgCEBLIQtzhNXEvisCAjkaXdbBZcXy228D6Ztk4BJVD/Y9/DHpD+jisU6VxzSPheaeJRynlnTmmcCHYExi/ddwn9QMETfkqKPBSnf9UlE8iXztNZjuYL+bapyUBJcAC1Y74jaVv7NyQSQ42sCZyOSt/rqaB5yEACRykW46es19cm/XDdTbrXzomoi1RlTAjVInTyHQOFZ51KsBM6Dho10KlyQBoJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR02MB4527.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(376002)(396003)(366004)(136003)(451199018)(316002)(41300700001)(66556008)(66946007)(66476007)(186003)(6512007)(26005)(1076003)(6506007)(54906003)(8936002)(6916009)(8676002)(4326008)(44832011)(478600001)(5660300002)(36756003)(6486002)(2906002)(107886003)(6666004)(2616005)(86362001)(83380400001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LEM/jllBlBxZayThlnCkUbqx6Vddbdx+HrpAqmOD/DmOc6vy/uBEaMRFOuvE?=
 =?us-ascii?Q?PJfXw5SiJs/qQpkfNZOTxfM9AqS0YwJnce1Rdw8ipyEWza5UOCLtVauhQIjF?=
 =?us-ascii?Q?kU50x3G2pLDTsS7p6jsKYtKfr0oori/ndVcY99MVEdJOqQRPpFssaA9IUqB9?=
 =?us-ascii?Q?MN/VP1DFuR9gvVrDlxLRfxhpM9x2kK6/zT83QsZOS2u5zTYULhs/cPSVODJW?=
 =?us-ascii?Q?jT3df1A8AnH3IWle2NvLUTNXnmWWVSKo822w5WnFC/sWUEgDCNRZsslpvXT0?=
 =?us-ascii?Q?z70o7oTUP20DKSJZhOy9f1+dw/s+8GCdYr9KaCF9I1HiAgYXZkD/QA3/FBH+?=
 =?us-ascii?Q?/YPnDnMtDNY4ypWZUUjA9hdqKV6e+PZKIYFcDnyW133FXovx/jp5A7+74FG/?=
 =?us-ascii?Q?Nz8TastgXqoe1hcS9QLuh3rCsMsu3QobHnnC0vAceS6+asjiua3/SfEMW/ou?=
 =?us-ascii?Q?7M+wBIjf6KbPcBlGX6SlxvxHPUSp563nhtLfOkjaA7l3u+soFETC3i6U8BPU?=
 =?us-ascii?Q?SiEEzs5VWlZUALEu97IkToChuAeHpDdvgFfqwQVIUt7rg406MnYcOxRtfOQ9?=
 =?us-ascii?Q?zuwbVlwLjQlkbhDx9dYhtPHyoXevtf/SnXhLAeJC0JYBmYZtcH0PEmItam90?=
 =?us-ascii?Q?cxcWrrbVBk1pK4yUom50It1EPuQdstWM7RDuHpTc+nXaQwSFwwFnoqKDEzZE?=
 =?us-ascii?Q?1sDY+4ucb1n0YUHXTsv8egZoV6Sz6XvOUkIgcxW114KbutRYvrHkm7Uv84Fw?=
 =?us-ascii?Q?12VWy2TzlKsGA0nMlXHhpgD/Y+ZwRLjsE1wa2QvkopSixkC/4GMmY4WuUmmi?=
 =?us-ascii?Q?/6sab6w+u+uxZ65kyvn3wWq5Z1jbzpARCbc8tWA7m2NgWxtXLi1DIA8GRXR9?=
 =?us-ascii?Q?M+XzGH74lrf2eEb5TFRSYAmL1Bg1XcHmzH/pLO0wnzorBQKsFUPqzPyCyc+p?=
 =?us-ascii?Q?+va+XG3+knKfQwJdvzMhu+rbgoFJp8ce5fJAMIuvOcYEng/MwLsw0zX7BQwJ?=
 =?us-ascii?Q?x1KRya1tX387bcJPP/l5n7Mk61llIrg+dl81yCNBhSF02dpsZFe8VfIEdHnz?=
 =?us-ascii?Q?2zwhUFIBuUH/vOJ8+j9hLw64QC98SUmHsuuCHDsdD4gkzIwj8P4ZmhMpN0/H?=
 =?us-ascii?Q?PhHgolE6OftD8kUlKvz2C5aWnHR+WXq4wz0dK2KZmWZWGAF+oWGritDPCE4T?=
 =?us-ascii?Q?eeydpkeb/HYy/dSLXW3Zd5Cma/JM3FnPSdueAj+IHkiMS8TBIjS2u/j/gMmo?=
 =?us-ascii?Q?IV0iwkUvUo2pTNraKRGZ53z5huGYJoRtYG2n5z/MULr9o21gEZ5FO5Slt86O?=
 =?us-ascii?Q?Fyzc54SDGYCa65fUV3kjSfT1cQ9lQ3sS61rX2EZzJ8v7RkPMmFboeb1y3J7o?=
 =?us-ascii?Q?eCLqG1lSEMp/pkooIIKxzGIBXw2pFgy7kqlPIEMqGAOKOBEhqidj9/Gn99nG?=
 =?us-ascii?Q?+A/PVDl+rSNdebXRF6FTJ9oupqtzDcbxHZOGfkKa0gheSw9+kuRqR8DoDzVZ?=
 =?us-ascii?Q?P4bMW1A3E/MQUuYD4DkUGQ0GqJpkMBNAxw9SvpV4xOB1XUBkal7w4u+tNZwo?=
 =?us-ascii?Q?PftLePtfgok+JnWQQlP43Fisl3u7JVqG1C77MbDrA/WlEnfFCIpCsr2WoFzT?=
 =?us-ascii?Q?0A=3D=3D?=
X-OriginatorOrg: uipath.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2665147-3acd-40b5-02be-08db25347c96
X-MS-Exchange-CrossTenant-AuthSource: VI1PR02MB4527.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 09:05:56.4758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d8353d2a-b153-4d17-8827-902c51f72357
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4jOj7xQ550q7j8VOtHbEVTRMwlSD+w+1CI8K0Bs4pmn24MWMrLWGclNl9JwClcqOtqIFMeZalximFjzYU4FJND725iZ5WHSzHI7SGiXf9+E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR02MB9866
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
Signed-off-by: Alexandru Matei <alexandru.matei@uipath.com>
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

