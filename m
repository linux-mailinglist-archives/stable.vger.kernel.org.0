Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB2276B8E7A
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 10:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbjCNJUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 05:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbjCNJUL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 05:20:11 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2093.outbound.protection.outlook.com [40.107.22.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D3C88D8F
        for <stable@vger.kernel.org>; Tue, 14 Mar 2023 02:20:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DHSP0lJakQoQuTJ/lzs59bnzH1lUfpZhpBBax42fmTZxDFAUn9nOEUF6MiiaxfU5Yh3DFxubYqKxSZ99VNHqFF90ncWz0ZOoRS+qa4cLbhz0/QZpbmKXFZNi+s4aYZ4kO+hDrKbchVATEdSuqIuJ749BIs9Dv0sn2cAcGim+5nFePrI0pdVlE2lMXjnoui1X22wPCvI+DKJ7T08GuWU8RBKRIO+H53YoMQoTxllvRy9WuocDr3rPN6k9H7zPqzvbQsjAK8DweSAvcKnDpyf+ghgGCJSMsW51aNgXHknA85F7h87K2y1zU+Wlb4KpR5M88ft8WYloxs/N0SH61k1gDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pMnWixIdTZd+egCdv/lnqdperLPqwOApETYyWvxbbs0=;
 b=Up+8bqJDbl6J1e/lpp4htkQPsILW986NgbyWlrdfq3JkKpN2KaBk7Sc/aKXEuY0Kd3xiCT245GTKXB/54vMwQMxY3YQfBMc3+sWZArH6y/PLP9mS5GSTod08Ge46UlL2YhiBcshHMvwriwRr4p1vOqfa9jevK2NHSGQuMXm5B/dJDzKv4W/VT/AuXfXyMngDx7mZWcOi+9hZOOxkbKnfhSEobz1FSb2u3gamtTkGegDGeqq9tpoRxGBQX3uWIt29BZbKu3SbxVEfPWMg69Ao4gDtI9/tmHkQ/gJzkPdBFffR1QImAiDoCWjulvrv8ZtlWi35U1zwakxA8dd50kGHpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=uipath.com; dmarc=pass action=none header.from=uipath.com;
 dkim=pass header.d=uipath.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uipath.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pMnWixIdTZd+egCdv/lnqdperLPqwOApETYyWvxbbs0=;
 b=QqczaEoG9B3ctDfV/sj2riPEeme0k61bvYXBdjhvXnpAcrEe4Z+zB2ZdNV02rpzmF097LMvmUXo7KLuJZra7LmFyXuNMiDlbgiG9NGbtUBa+BC/4sFLJ6BoxYMjS8ng1TpY/uCZGmB6Jd+Q/TkPmtaN0u7aAB/WwlYiVbI7kAMuLWlzoeEKPm0UqirUYxISLJ73JcluR5Hfa9q+HNdIwnfiWqXgJ86EO5yQVNjch90Co0zzWxTNH9OAjceOKOUtJeYfpPikH0yy1VDceHBnoFrgZi0DmWIOpWnKJFTwjBKIoFWijqSEr2tqL6np+2Vc47kk98BHYgXypololo7toBA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=uipath.com;
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com (2603:10a6:803:b1::28)
 by PA4PR02MB6543.eurprd02.prod.outlook.com (2603:10a6:102:fe::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 09:20:07 +0000
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::224e:d6bd:a174:9605]) by VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::224e:d6bd:a174:9605%6]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 09:20:07 +0000
From:   Alexandru Matei <alexandru.matei@uipath.com>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexandru Matei <alexandru.matei@uipath.com>,
        Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
Subject: [PATCH 5.15.y 1/3] KVM: nVMX: Don't use Enlightened MSR Bitmap for L3
Date:   Tue, 14 Mar 2023 11:19:51 +0200
Message-Id: <20230314091953.3041-2-alexandru.matei@uipath.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230314091953.3041-1-alexandru.matei@uipath.com>
References: <16781188891829@kroah.com>
 <20230314091953.3041-1-alexandru.matei@uipath.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P194CA0029.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:803:3c::18) To VI1PR02MB4527.eurprd02.prod.outlook.com
 (2603:10a6:803:b1::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR02MB4527:EE_|PA4PR02MB6543:EE_
X-MS-Office365-Filtering-Correlation-Id: 16d210fd-d1dc-4dea-eab4-08db246d4d0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /V2mzxxYurdKBWcq7+0I/G1ECNMHhY+NWMfAmilUYik8FW0F50iTACz4vDPeTtG0+Q2uoRdTY+HslUQtiKXCmJvch923zdlcpapZWysfLIMQSCCZYKkYK8EoLpzFAjwlLkGm6N9+y8xI1DgbuA4IfjZZwVMr/YwlVxj7CwfecQm3G4gEetIEMVY/NPuznMQkfzo5s+YSj6PsrvZMGvgv903cmXf91gOMj0OFbehOTA0I0PCW4/Si3odVvk+ohTlh+7RGROtHpFXiEeSjwW2moZoyRY2zGyDfy3hyp8H+YtpKI/vDtFlDw/P9Ig+yblwd46Zio/dqDYLkXTqy7Oa+wSDDEfUMrmn2/ruP2JP3RpTZBdljFWpoAHOjGyKL6VXasc7yxSGIePUigIhT/D+kQtlg4HhmWstu0JuX2xar3xH3vOmxppO+QgvIuqm3F4R0uhNL99EVInPGihUesFeDSN7L7CdNVg7rvScJjX8yPj0OLQLm529ZWwt1yr357ucf+7mpqKeo6cYdf1U2N8ImXWQ6U4hxPrC/iJEwSgv7q07nl4/YRktZMWpntJkofkFK5MqkVNUG51ET2p9K1J2r27m3G4DA0WURrpysOupP95C1ybGCIbnXjIrCPwvR9JnhAiDAxoHxC0M4gMe99LyRgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR02MB4527.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(39860400002)(366004)(376002)(136003)(451199018)(5660300002)(41300700001)(44832011)(2906002)(38100700002)(86362001)(36756003)(8936002)(478600001)(6486002)(66476007)(8676002)(66946007)(66556008)(107886003)(6666004)(6916009)(4326008)(83380400001)(54906003)(316002)(186003)(1076003)(26005)(6512007)(2616005)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QdChjBsqRy2ToEXxwvrmHFt20zwY/qlSui29NT246O6nJzTpe4vDtngZLII0?=
 =?us-ascii?Q?Q2CDV3B1+fsStRpc4tGzdjd0JDxAX3xGnhVc0Y7uY7vfYh06+USjmNCekX/n?=
 =?us-ascii?Q?kcps6JApx2xQxTapY8oEMrbHEwGf+0/igePvTHlFGlc18dUxHGDg3CdpreiN?=
 =?us-ascii?Q?muonCjJkP1PneMR6fJ6bUTdNKwUfkN9sT2dR4X9C7hVe5iPNJEgis+k/ZnkQ?=
 =?us-ascii?Q?71EBxjGI7nVq5G13zgB0D5gferweMW0fF11dtOIraW1vnkjV5dEx0xpaJnFB?=
 =?us-ascii?Q?fXQXNZ27O7L2zCEZLlJ/Z3hZjLvJbVaEOuKET6zXOXMBwftqAr1FYgfdOAui?=
 =?us-ascii?Q?YcSYMTqPls247fJseUSje1yXajToBEawUANxuuhVpxPtF81+6CbTLb9MHomD?=
 =?us-ascii?Q?eip7krzmm8MPqhG4v7KUHmESr0BTK7sdaV73p7MAkHJSAb9FOuUyURYg/s35?=
 =?us-ascii?Q?r63pwQBO/fXa9vKHAlpW+Hz+A2cNDuCi/dZb6qN77It/jcbUCLXqmh0D2o+L?=
 =?us-ascii?Q?6NfQ17KOUx+olTr2MNt0mnMp1YW1n0ix4U/jkNvmWkhkoQNgig53viInTcyh?=
 =?us-ascii?Q?s5mukZ1LeLOAi1gwu/D1d4SkMoruevknO4OJFBG8zoYKVNDamWeySE8LJtuf?=
 =?us-ascii?Q?sLG3HibeCagBCeoALZco+ODiKKdyMBHQolduot6WWawQjbOJfOECTyiOrq4a?=
 =?us-ascii?Q?3wMP0DKIdBK31zOTU1p3roe2XGQbUjBxu7wlv8hc65ELOxmeXcWTVIxus5ER?=
 =?us-ascii?Q?I8XoKZPdNnQnmMyZymkOkKGB/2tRFGfeaxo4OTPpqVwKLseCoaStTfIRDVm2?=
 =?us-ascii?Q?jwviFnPBseCVn9pakEt7mn08TfhE1xgOldALUKlreJKNhmaZhe9baTSLwX+s?=
 =?us-ascii?Q?+uLzBLN2XvnDST7JlAaIr+nOFcwBmMeIzr8p/7LZsw2h0sQawHV8T0i327zz?=
 =?us-ascii?Q?JqeuMxg5FtUzAIUER5vSV+E9panpLDVrmm8xCPY4XZF24sjUoZg9odm5Wxoi?=
 =?us-ascii?Q?Dp4DGVumUPUBQswe73NSLVenVQsAYooU5Kbac4M51aG3FUqfG67tSYLYrj2l?=
 =?us-ascii?Q?KPupmtR5SstelUTJLrHWzNcoznBBqoMit7jeOHEDPc/CEBdSG2xCffSZ+Vch?=
 =?us-ascii?Q?4sUDe8EzM7Ruu9e46ZQt63sdAOka2bzUv7ako6XK+PJtlZQfMT5ahMcT5b10?=
 =?us-ascii?Q?vsLeIftbHGATXV8VqtkFDR0ED6PRsvZztuVZk09V3Zm5jq7t8/4CAHU6jylD?=
 =?us-ascii?Q?FYnL18gb7liChd50LgyjBlemqRHR4IEGAROJ/yU6zy6B9sJ8AIDBHbIPDNvT?=
 =?us-ascii?Q?24rslZiG069oKjsfX9ufL4hUP5L9Sqrg1Xtrk1rcfUKJtk2w+/xBLmEl6wF5?=
 =?us-ascii?Q?Ei/sW7QwWJZriLy/EZZZIqEY5QlmMI/3mjv9xYDJObKr82/VOgy9EOveYpCq?=
 =?us-ascii?Q?lHTDp7s9h7HjM5b7NnaAI3IEfM59qaZZOjHxeg0ZBV/Z46y/EUOCXCXpTUrI?=
 =?us-ascii?Q?BD0iMiL+K4OjnIrLuU21gJAsxRXpJ/TMEpOnCuNwpJXEI9gR8MguzrQ1HGi+?=
 =?us-ascii?Q?muxQO99YvaT1Z7rmjqrl8u0zbhbpDtI8BCzMO7rVwqYE8KcnJXj8puJIQ9wf?=
 =?us-ascii?Q?Mg=3D=3D?=
X-OriginatorOrg: uipath.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16d210fd-d1dc-4dea-eab4-08db246d4d0b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR02MB4527.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 09:20:06.6968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d8353d2a-b153-4d17-8827-902c51f72357
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oSO+pct//NUyuX/1FmntF+QjQkwgb/I0p+koTcNpGpKsImZCt6xnmaOdmKaFhgEWza/hLtp+QGipS0B7wrBaGQoQppCb+NBu52na4Pb3Gk4=
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
index c849173b60c2..97a1aa5a0956 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2739,15 +2739,6 @@ int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs)
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
@@ -6969,6 +6960,19 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
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

