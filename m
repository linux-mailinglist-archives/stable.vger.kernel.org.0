Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36A4F6BABAB
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 10:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbjCOJIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 05:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbjCOJIH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 05:08:07 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2128.outbound.protection.outlook.com [40.107.21.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 755707DF94
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 02:07:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IABofLOekmO+UWHZTjQWWj+YMtx3WXbvsRug6bCtnMx54jS+8TL3kcWfs5G7k61RyhYmYAHP5d5JcYIQ6jJ0rsK1ewnhziGuqX5qGpqAqgHdAfYq1Ax0ybWheznBfCxLTdw5IBlSi7rI9eq17/RRedLGxj/AUH4GzmooXLQ0BKToWXypIJObEYpJ0fRNMQwenKKtkfOYv6KhD1PrUuL5HNKtw+FsJmp3B14Ak8dnnA9Vq/cLSzgGgxRZXRJnsXPUVwJ7ckIdmOeR2FQKa6fsHXpOwsO/eLnN+4MQWlZ0nymbR1JXJ3j18kVZSffahWE2XXrgEhVNFXtaL4dUuZqDjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EVzG11koXLGrpXw5BSicbNPwIq0fe84HgRw7+DA8uNo=;
 b=CV3W4Rt2pmZsnSjlrcPwdSA00GlBJfCW/rz0P73JtzFCz8EvYXn+LscOL9ScHmvKpM38DpG2LmwWYtfqNYzN12jWyWK5VuGNzkKFcYyu3YNj90uuKimbw9Vekhvy/Jok6olB/Wk4VUAbQ4fDXcWzrrmeyfueHXpvy0PeRaU3BILvStxDg1Jet7RQl8FMjGTyFvjj3PR+DtUcf8aJJUX1TN5QGSwJOADegbcCaHi5fDH8CPTJnKcInVBBmtaLfdhiqOl5uD0Z4ziV8G6cLRKBqdrqnigj2o3VTmx7LJgE2EC3teRL/aoNlUJj/YJNjXPa1049V0CTQXQ2AAyZXj9/bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=uipath.com; dmarc=pass action=none header.from=uipath.com;
 dkim=pass header.d=uipath.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uipath.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EVzG11koXLGrpXw5BSicbNPwIq0fe84HgRw7+DA8uNo=;
 b=Nkf5TBNa/W7tEfsI0Q9+GP6FrmWK3+k6+aVE87a4Pjc7+B5bYDExcdzj08Xnh/fBROCzFNGvGCdtvNjsMZhwbR6Xt5Dm7zLUFam1nTW1v+l4TkZP8qcvdBy/MkPnmdwJnHXL4CXow51sGoGbH7Wh3w7NgQvpxla9nuZWsiYCBLviu/WjZWwew1D4ckFrH1P/4HoQJ2RrnHFaCOaUeyaG+08TeaxEUdkjPVb6LWmbX3T7Ygzht75zKvUy4wy7UAs0T8b/QW0CA8l3OhvxTfZOlWCIVmmVruWjKIEpDlZrldS0zh1SSYOI3jnscM2V1eMzjkX/0E2CHceGtciRJppO1A==
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
Subject: [PATCH 5.15.y v2 1/3] KVM: nVMX: Don't use Enlightened MSR Bitmap for L3
Date:   Wed, 15 Mar 2023 11:06:54 +0200
Message-Id: <20230315090656.4258-2-alexandru.matei@uipath.com>
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
X-MS-Office365-Filtering-Correlation-Id: c8033f47-454d-4941-0cbf-08db2534b1fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Guxvqoha1+/AJq74FfQ7QomSzZUwTaCF3vk95MK3J06nmcT5l9IrmGFgEfKucbk+ixvxjGBpSUoAdYDz4C2HClxVoti/s+6DG+cjtjFZTWus4OPv69IXwIoSd9OAYkjnHpJDS/EhQmgPekuwM/Hm9HvbHcqaStuZjA+p2Ro1kSaO9HG/kqdEP6/j32PpBaOU5vEPXyShJI2IdiodnJyCztBUWpCSmyVlXSbXKoK27KIMu9c5agql0eDZfajxbQsPSg3H3+rIECHm4EZL1K+sQgw/SR7+SYkrB8pqXyZqX7i0PAQTtn/DpXPrN5XZAvyULdbiDmXygai240PkKNTTJNwymCbb1zy2Z2aesCLEjaQgbbUVxR4N+ZPeHTb1LlH7ol2J24W9bNLbmcOA+UdNcJv5G63B3NxllPK5hjw0Ye2FiKinpxtN6zeVtHArktTWP2N0fQFo28XQQqPx2/rA/KuM+uxUztTNgblpVL8fJ7WZ/aFVB/B6xCrObBOkBfVfQ4nHMSrKQUejQtNzHEa3OTNN+gSTKiOzouXR6e7hgIxanHbCTXxWaTLTAEeNCzfSegy8rY383qyKUtRpcjXQr+xCCsZiDcv4c8RZ+MYJtmLV0M5rWECKZzN8wWXT1+B6+wF2kpX832HGpMC6/OtvTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR02MB4527.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(39860400002)(376002)(366004)(396003)(451199018)(8936002)(44832011)(5660300002)(41300700001)(6916009)(4326008)(8676002)(86362001)(36756003)(38100700002)(2906002)(2616005)(6506007)(6512007)(1076003)(186003)(478600001)(83380400001)(6486002)(107886003)(6666004)(26005)(66556008)(66946007)(66476007)(54906003)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NijlUyC4gNuNm3Xa1yLocihxEjMTy3lDEYl4OzOmD6AqXXmU7LCLiAds0VM8?=
 =?us-ascii?Q?l8yF5+bsVXN5LQ2Po1RZ2jICsrtl8lg6zrVcJmXLizwevEWO79MQOJFtfx9J?=
 =?us-ascii?Q?as8P0FFduEKR+n15vhgm7QYD6GNQAnjd4wCCndAeOGQ1RPgJOqXrIbGR7SUv?=
 =?us-ascii?Q?Umicoh6Nb7WebnhLikWu1BItbzSxgwKf5WgQDwVeAExfR4YQI69YclvyR9os?=
 =?us-ascii?Q?PnAWjCpEkD2eBl/mS/05PFW4NWIBWm4Rnfl13dovS3Iu0mvyQA152yjtysJg?=
 =?us-ascii?Q?gtXKdya+Xq1yCHsFj1fEhHSsNo81R6Q4c0p8U25f8rYjoz6gauKvYdUJ/Q24?=
 =?us-ascii?Q?xYl0dJdVO+6dawRrzrDkRNP5K1okWmNgaZC9EzBy3CPE1yWKQzWEkClDv7E9?=
 =?us-ascii?Q?A8JazstW+ulM1W9AfHrg4LSuwRvI1mQ5RIVxcWavnbOTSaJfXzdbQ+YOz1xK?=
 =?us-ascii?Q?X58TiiwnJ0Ne6U6EzQIycTtXJ6xbqA4POizYJ/IccbyGxCYlkVo0UC48gF6k?=
 =?us-ascii?Q?G86GfwIC0CpUffkZZumAMan45jhn5bqGDKBqvtkRSkRy5cptrKGMG0ssfUyH?=
 =?us-ascii?Q?yucaTkeP3McbMRsm4sdNVK8I770h9ZvDdPX8Vb26kXzX/SMHvTWk9Np7zQhw?=
 =?us-ascii?Q?+IEzMZZpEZ3OOTz9qeZOIzTzlqbqJVirBm8bey3hSeLhW3NX8d24Q/Hco3aC?=
 =?us-ascii?Q?SQ6HZHQhLQ0aWqqJGgFHbAh+6WoFknsa435QbdD5b8Trl3FKGohPNGuIa6f8?=
 =?us-ascii?Q?JWak5EkuI3vYHUyJVK2BcArnF8VsVXGIZ5/FADRTRzcFKgJAt8uvoyzzmE7Y?=
 =?us-ascii?Q?Xj4DAwAUhlBMT/GjJPfznff5bQrFf7nPemnsfmXehukDt9HT55FwA5uKfG8X?=
 =?us-ascii?Q?k7/GeWe9DVtPJ72waPHnar3/PPPcLvuL0/1VKH5EL2VR+pHmLBorzns+3Q8u?=
 =?us-ascii?Q?TMIkF8+h8ySrC7XU2QbUazFbJJ36hrw1HQqkISzUQxB3qAFPDi6ujWqSaqJ8?=
 =?us-ascii?Q?7oIr6UUgDfdY0yHTB6rpZWpOmg5Xq020+0eUDhKeP/QdwDaFiFEWT7TT2N/v?=
 =?us-ascii?Q?ZGItOAw0BI5m8QWtDKR91QnXt7r/fCwaNsBmDnnrXA7mRYjQUzeBof7/yzeu?=
 =?us-ascii?Q?JTwZHH4wh0xJQPI8k8D+0qphDL6vGEjrkWGzyhgew0qzgOulcLaascSZ3oav?=
 =?us-ascii?Q?P0vU9N0vq2lMpC4EAALELmDk7ZlqGTl2BlaXA3BZ4KO6vPWjdgtOqoz2ybLv?=
 =?us-ascii?Q?RsVGwOOqV4CPeASx4Rxvaqk8/taLJbKu4qKVr17WpLRXH23dkL/bB9db4Cdq?=
 =?us-ascii?Q?KBrrWOYncDydRXpY3g2yKh5pxg9elB2gtFGBg2Z8fcPv9CvhmaKcKoxQGQv4?=
 =?us-ascii?Q?ugW1xQjubhCni1h3Xh3sMFCnKqeZoMizRhrsvuZgQ0LFdTjOD6Js4J3cwr/y?=
 =?us-ascii?Q?IVyDS7zFaytOox05bLS/vl2dU1quNxByt8Ru6q7aDhZ+j1fwdAJt4KPfWBtQ?=
 =?us-ascii?Q?s6Taj2Re3ZudcdfWBjhjXKXa9SYPXOvfzgKMqzJl57ECicqa17XLqAFdYfnV?=
 =?us-ascii?Q?D+Ldd3y9tR8qxpoQ73BIG8TDhiZ2x1UfCHQ9MVh5YYH9Endls8FYgHNKIgln?=
 =?us-ascii?Q?/w=3D=3D?=
X-OriginatorOrg: uipath.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8033f47-454d-4941-0cbf-08db2534b1fc
X-MS-Exchange-CrossTenant-AuthSource: VI1PR02MB4527.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 09:07:25.9544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d8353d2a-b153-4d17-8827-902c51f72357
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Kg68mB2y0qNy6mQTMcIo3noBtKkT2mbkwURacB/HirwSzgUermz+YEaMOXVIGSlciqIVm1TPe0TxeIbkZ2niboinDjA48XHJexMiF0N/+s=
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

