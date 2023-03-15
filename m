Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C56C66BABAA
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 10:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbjCOJIo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 05:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231934AbjCOJIL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 05:08:11 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2128.outbound.protection.outlook.com [40.107.21.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A0947D08C
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 02:07:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q42/9K9F1VyOxZBJeHq/dreXfp3T6yTuMAQeOyybj8fzwKnsGglZMw7IfIaIOiDIOHNKBeoWsCE7Y9iJvQnMUK3d9np8DsYbHk26Ehs9AzG/4OU0VHgcQ5DgZc5MX1rOtYueqGDR9ikq81mSlZKYa8GFgwXmrNyCJbmM6P3X4osTWSVWCUyeuDyZMV5TAc9Mazxis2Lh3/ESMNwaPcg7wiWQqhuv/mqBE2DizoQ776UcBxiRgWbtIpjldGOV3+niL2dG8mCRmCagcly9I2MkwZlZtwFBgmAePpiTXmVMXO3E7nx129u9rUYA28xtH3bQRDys/I0sL52L94mP/xyb1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qDRGe9DYGzOHEOTp/wQHQDEuwR5pz7OanKiwY/Ex3Lo=;
 b=lSRgo5fNGkhHKc2vCWGAodvgDA6fDanojAH8bjh2aYglEVYUmDOigQv6pu+WBWRAKFGctU/Gfj1uQSGW0m2FRcjSsmVBmYdU3c17jDzv1uFhZxtlPIAHVcI0vK4WheFx1Nql/7DMdaeexmsoP63nw0lVA4sNqKOdSizfmkxNaDFpB0uu/VANahZygHueV8W19Dwzf+igj12rbzWaR7qhkB+EwZgG6WVo/xzWjXlP/YgvzKJZsgUqYGXj/Rg/YZ58mL1YouY8Isne1w9BMW+7xo8+oyNqVBXSFoj80ofxLGY2fT2p98x1I0EL1s7LzSrDkHYgrf4J+4hTKcVU1sv62w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=uipath.com; dmarc=pass action=none header.from=uipath.com;
 dkim=pass header.d=uipath.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uipath.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qDRGe9DYGzOHEOTp/wQHQDEuwR5pz7OanKiwY/Ex3Lo=;
 b=EsF1wPT9UZR7vv5Dydn9vaKdjc5OhcyEI2Lr7GmkT86LzpOgWr5kfcay76mcJWGpICLQT6vKqiDyj5PvTYDYbaUhdUus4PuNl85A3DA95HjxRrcwWQPi5Ru/D6DQ+446uVy/mz8RAbWskqoGrm/MwRJIxgUZaVd5PYz/26djzUUtUIrYtC9HAjeLJrWdqH8RrH1mRqYlSaglwJSkokWUKydFBmwikzayQsu1jA4s6g9MfS5QYZQ3iXpvKVSwq7BOCLNq/jE6hCWwN3BmZ52GNX/tVRdU7eUVor6Im/KMLNR4Z3FLzMyse1YjqxKTrt0OlCStWGn16tsWL5m4EXMW4g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=uipath.com;
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com (2603:10a6:803:b1::28)
 by AS4PR02MB8358.eurprd02.prod.outlook.com (2603:10a6:20b:515::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 09:07:26 +0000
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::224e:d6bd:a174:9605]) by VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::224e:d6bd:a174:9605%6]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 09:07:26 +0000
From:   Alexandru Matei <alexandru.matei@uipath.com>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexandru Matei <alexandru.matei@uipath.com>,
        Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
Subject: [PATCH 5.15.y v2 2/3] KVM: VMX: Introduce vmx_msr_bitmap_l01_changed() helper
Date:   Wed, 15 Mar 2023 11:06:55 +0200
Message-Id: <20230315090656.4258-3-alexandru.matei@uipath.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230315090656.4258-1-alexandru.matei@uipath.com>
References: <20230315090656.4258-1-alexandru.matei@uipath.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0046.eurprd03.prod.outlook.com
 (2603:10a6:803:118::35) To VI1PR02MB4527.eurprd02.prod.outlook.com
 (2603:10a6:803:b1::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR02MB4527:EE_|AS4PR02MB8358:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fe5dad3-c2bd-4faf-2ddd-08db2534b260
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sLtkDAmGs8Bg3JxO/SpJL4r9wNxfah4F8v59ygoKApjIWwAt70PM+Hf5WqEbZVYASL60XOxZY0huYG3LQo7pBnw0Zv1HaFh9z2/Zfo97jykMbfjRGJ/Z/HlaWj/kY5Gj/QhIW3kvFxQQ6QnIN6WFrCOPR/nZ9NhO2wjJOhWz1Y5DJwX1OC8CBtc8rM+Goj0CdUPyRvmEiuVPudb/9GM1RfhBH+3hNYSVqe2KsFOOZDkty9VaHtxjSUpWaKi6EtNZw7jCbOymWYeyHiZwx54NAoetWUX15UiFaChQB4wzR3QOpLp2A5eJkyMY3Pv62SXWqHSvdRQ7bbHc9elMhVBZJLKGt8vUlqtW5Q5Zu3g2FftXZ96klO7yWyscz0mC1Il+cP6r4sDdXU0MMZEUIM93x5LFQSaRMIFLwcNnGIjwA7SrG7QMbfCDy9CSXvqB3wlYqFJqIcueAnSUrD28Z5EhNTSWodf7kJ+EfxlM5lfIad7Pe7sNDpuwZhX7OMAHFSXsL1SwUTkZPqbimt8ICbPWC4j2Tras+3u9sAlWUqKg8K9BLmIfnta3wmslj6ODlvngAjEMz/yYNezSmlaXs//9Plnn9/dNU8+gPsMLN2UfRMqfVjKbl5DADANAcam6lLDapPT9XjqlP+nzMxQMWtxIHA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR02MB4527.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(39860400002)(376002)(366004)(396003)(451199018)(8936002)(44832011)(5660300002)(41300700001)(6916009)(4326008)(8676002)(86362001)(36756003)(38100700002)(2906002)(2616005)(6506007)(6512007)(1076003)(186003)(478600001)(83380400001)(6486002)(107886003)(6666004)(26005)(66556008)(66946007)(66476007)(54906003)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?15zS1mUm/mrZT03nxE9SxS9NffsC93qquChIgRgPf/GHv8wsO8+G9k5xCZQT?=
 =?us-ascii?Q?adl6p9qnWhjxhOCulyZLFyQowvtUm9bZN3XbhilFDGsRDtuNz//J8VNc5hpt?=
 =?us-ascii?Q?YirH+a3+wKkqSoVFmz20Df4oed8nDhNM6BIky7Gxw5H3xAAaGDVAWfNphf8l?=
 =?us-ascii?Q?bt5EUcmsCJVgFF67Q3lSdCJAMyMbMc1Rs9jsCYtulC9Omkaa3DujO+huD8qj?=
 =?us-ascii?Q?p0fznUy6k1JFhoKYqe188Fdtki1wWT4TkwmNok+j/lRCtx38tFXyT8nEEIRi?=
 =?us-ascii?Q?AGkecbjgAidcG7J8qM/XvTLkhtDZu4Pp+dEa4HbHgrsBFE3ItiWSpEYzKe1A?=
 =?us-ascii?Q?iktLEJIBW4F7YI+cA0OVigeH6CPeng3r0xP2YJ3B5e7a2KOETqkyK5a+k1OY?=
 =?us-ascii?Q?wbYFDivkzBLgbUULZ4KSjZHEegIOLXyAvxJlScmLFpn0/yZGPG7IOAF7h7Gp?=
 =?us-ascii?Q?tjx4mgbHvb7ZjVXwVwRzJk8uiRQZpMM99YYdAA2kyzScUQm6ara8ws98rbip?=
 =?us-ascii?Q?hdEy90nO8kKltMcIsT4anogmrfOHkyyi4naStWEDknWXh85vNPxLO42sx/U2?=
 =?us-ascii?Q?RYgqHsIB0TzFezoSNenexSquSUbGxW1mlaJHOX3cy7E9+wp7JMd0xUTcJSUD?=
 =?us-ascii?Q?kC+n6/RRKoGhSWbAC9XuMICXXKJgbXYENWg+Hvclkn3M/AjXpwne51sFQBBG?=
 =?us-ascii?Q?duJkZFtSdF9/TnVI1MSdX271CMNz5HnnXqFINJKNlWDpVasJnIE/tt8h9wDz?=
 =?us-ascii?Q?bESkrDPT5etB8E2GdXuJbzccSakpj8ljzNZA0bVdUeRXy/K956qJr1Y19MmW?=
 =?us-ascii?Q?cQiaVyo6Y89TuT4ts7hyLLpusopwyXaaHm3ffi1cLHCC2/j0UGxTGbKk28uQ?=
 =?us-ascii?Q?m3EhydAcvSMAHmSg2sj91RtKeO1mMbKoB0jwfppwFL20g6yqWWRJQ2Zox5Ue?=
 =?us-ascii?Q?Zg68nz/gFjqf/YFEfbQ+mDAMtlW+IhfOXwD8jMl3TPKB/SB/LLiaUUp4MxnA?=
 =?us-ascii?Q?n9KsQdOrCiXSMB7Zl5Oy9ytq+XSMBtUjIWIyCc8QgInwOLD5kAVMoE4tKdmH?=
 =?us-ascii?Q?7asZWymrZXd/g0TPUb+1ro7dNTlypnVMb9XjzB5HDi45NZFCUZZtjS26IfeC?=
 =?us-ascii?Q?Flo/H0nW4f3KRR/97gZ1QVrcCMk4sQCIye2AAkVvrKdMCz6NoWAm1vlmHfia?=
 =?us-ascii?Q?XUmMkPKuJgidGujgILgqHnDvqdOhWDLRANb8EaXb03uAAFSLkVdTg7BuaKeG?=
 =?us-ascii?Q?XlXEmFf20ZQSLIzxVj8/1cxAE6GgqtHRR/gcuVDQyCnsDvy7VaaVpVA0E10N?=
 =?us-ascii?Q?F5fg/wBga1SsBBI67jL1llwTyJZ0JEcEVArwOs0IPbFFLuOdiDkB2ntTtOJh?=
 =?us-ascii?Q?xFE4PpxM5+umb808Mv4FpxHS9ekbUHXah6SWd54uLZuV4QL48JdPOvgGUmQA?=
 =?us-ascii?Q?jzBYEhSYCCQsXVxuyPSfvIhzUYjgyfMfJVLJCRwLvEQjJ78S/4ukZJBIYZQR?=
 =?us-ascii?Q?TT+vJvGfQEsH0WGZ8B+6fTa5heG6ohMvszBfDIH4fTnGpArNbBKk7CLHyZiX?=
 =?us-ascii?Q?CH4BF5QeOe+ViDD0n4bqKx2AbZJRgCzishW6mBG14nNDLBsEbhdWmtjJdT77?=
 =?us-ascii?Q?mA=3D=3D?=
X-OriginatorOrg: uipath.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fe5dad3-c2bd-4faf-2ddd-08db2534b260
X-MS-Exchange-CrossTenant-AuthSource: VI1PR02MB4527.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 09:07:26.5950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d8353d2a-b153-4d17-8827-902c51f72357
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3ZRu479CzCKvZpj73nQL/Ux+9S6edV4WVogkIShwuBHLXfluzMPELtX+P+3NeGu6JYeodGrd6FQlpf+dcDR3LBFM7Nb0ombl0li0EU6+Oeg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR02MB8358
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

commit b84155c38076b36d625043a06a2f1c90bde62903 upstream.

In preparation to enabling 'Enlightened MSR Bitmap' feature for Hyper-V
guests move MSR bitmap update tracking to a dedicated helper.

Note: vmx_msr_bitmap_l01_changed() is called when MSR bitmap might be
updated. KVM doesn't check if the bit we're trying to set is already set
(or the bit it's trying to clear is already cleared). Such situations
should not be common and a few false positives should not be a problem.

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20211129094704.326635-3-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Alexandru Matei <alexandru.matei@uipath.com>
---
 arch/x86/kvm/vmx/vmx.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 97a1aa5a0956..9c8353b17d8e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3772,6 +3772,17 @@ void free_vpid(int vpid)
 	spin_unlock(&vmx_vpid_lock);
 }
 
+static void vmx_msr_bitmap_l01_changed(struct vcpu_vmx *vmx)
+{
+	/*
+	 * When KVM is a nested hypervisor on top of Hyper-V and uses
+	 * 'Enlightened MSR Bitmap' feature L0 needs to know that MSR
+	 * bitmap has changed.
+	 */
+	if (static_branch_unlikely(&enable_evmcs))
+		evmcs_touch_msr_bitmap();
+}
+
 void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -3780,8 +3791,7 @@ void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 	if (!cpu_has_vmx_msr_bitmap())
 		return;
 
-	if (static_branch_unlikely(&enable_evmcs))
-		evmcs_touch_msr_bitmap();
+	vmx_msr_bitmap_l01_changed(vmx);
 
 	/*
 	 * Mark the desired intercept state in shadow bitmap, this is needed
@@ -3825,8 +3835,7 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 	if (!cpu_has_vmx_msr_bitmap())
 		return;
 
-	if (static_branch_unlikely(&enable_evmcs))
-		evmcs_touch_msr_bitmap();
+	vmx_msr_bitmap_l01_changed(vmx);
 
 	/*
 	 * Mark the desired intercept state in shadow bitmap, this is needed
-- 
2.25.1

