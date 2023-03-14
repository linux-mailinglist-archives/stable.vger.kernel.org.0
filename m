Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2B0D6B8E73
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 10:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbjCNJTb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 05:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbjCNJT2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 05:19:28 -0400
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2114.outbound.protection.outlook.com [40.107.249.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B862097B55
        for <stable@vger.kernel.org>; Tue, 14 Mar 2023 02:19:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BjQXWwW7bA04NQHaC+5lopJXuugSl/C47Z01r/pH5nvNj8h9KcFQATCIFhGfLN9nzUA7oo60shE+hSqsMjd5KggsCPdKRjxjINj6PkTUXH2a7/iASqBqQ0S9IKORxttEfGN6nas/j5/aCg/Ib8oja+b6HDfdzPFcqrlyZZfq14xZoosIzZokdyvHqr6y8wf651YuVh2KeC0L1l+3Oti5lraNcmvVpexs2bp+4eeFUEW/C93ddwJ1VU/vBPiE8Q3QxUqLR3dDgP59rSOFaSb3cSU5ycokbE4u/qtIVvGoNHAg3gZFY6fsYyacaPtYlURX0YQvebmtzq1eAaKQVtoiZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4BrPe56+WUMXymk926M0a388UUXWgdIh4aZyzTlsxsM=;
 b=avhpYW67ilpP2aXSC7BBdK5cYi8iY6YPbxcsW/y5gj6bz0e/E6oiBJyekUYq42urFaqhKsEHvOVl65cLyGd+zdoT2VSbD0ERlY/zHYzoYrJ8lbfWq2TG9pbZhQ3LTVciEiSGeWsrAcEwcSHCr0GdVn+lWZ+NvwxG5reHMPhnThV+SLczthOpsP+q67HVOKYUOebVT2PWrgC511AJ8aEELpw0pk5PnV2KRJoGbEzXMSA6C3QPOkh7OrUr0vsTpc4gYe9u3vWsjMZlzxj9+fL18XRNoIOnqzTky1qdbv/chwa+8nNVh7OBofTMZZUBnbjN0eb8SI7oODYwh4FtmmPqyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=uipath.com; dmarc=pass action=none header.from=uipath.com;
 dkim=pass header.d=uipath.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uipath.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4BrPe56+WUMXymk926M0a388UUXWgdIh4aZyzTlsxsM=;
 b=P5jA94wVyyAM136Ux6Gn0tu6KDjCkZvjN0pJibxQSpClLwau1lJTlWMCb3BEYMF/0JeWwdXxoPuNNGPM7VaVM7gIAmApGTDi9GU7Gih1kzR+kmBDRHnI4/kg6ABlt82e0BolSPooH94aZ9FvjtFwec6Wo7K2kTfalt+1rWk8K3ephytenA/q0aN1LnhDDt3XzBTTft2VeeJMGHV1GqDmL1VR3Xc+BtpqzIDbrpk2aSP0CCN7/FVIaER45pjY0fhst4GXfmRBTW/wc3fRTsXq90JbUSLK6GJ1CwiEZAuTxOXZ1gGLTfIFjFgno44n7cCbnKBgfpf99DPM2YFk5qcVDg==
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
Subject: [PATCH 5.10.y 2/3] KVM: VMX: Introduce vmx_msr_bitmap_l01_changed() helper
Date:   Tue, 14 Mar 2023 11:19:00 +0200
Message-Id: <20230314091901.2975-3-alexandru.matei@uipath.com>
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
X-MS-Office365-Filtering-Correlation-Id: 3716de3f-e32f-43ab-4611-08db246d2fc9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I/bgLi8LptBS+vepG0f2yn+Q6XTC6Vcpnr2f/E9cLvxiVe0Mtcf2rfkdRh5cO1WUGZZc4FbHj1titQnKFvQOo4IZDLMIRb1MOt5K2Pt5llUj6oc1TgzRz/bMC1brDWrTYvBFCh1O93W6pKTSv4eElGj9+Yh0PvWbIdm3yiRU+l8zZ9Wg9WLP+zJ8h+DubqBqHkUcAOTqH/0QXHv3XC52Mk5JvW39u+3bBkEJBZ8OAd929litx1fnpLn2owpS3xeGtl+rYOsdHAlqlQhjJIP8wvb0YF4prTCvhh8nScIZvxxx03oPiWOtZDjzDcVdl79hr4y6Zk0dTAZhroJVk+G2QsPST+LABt4Uyos5xUpu2/pOwS2qFvg5gobPg3DksFMQ7z2JOd81gAdFM07lk9t80zLfQa/TiLn7KOhcf0xks+n7rZdkQDMKMDPUucvHCSc2pH7RwGhEb18boTLzS9/cdle/qs7trf/fo/Y/pEkrldXdJdgK/K5TIoYYeRkjQqeR9G39VamDUniJM8jrFVhOEt6uXjy0BEPuA21Jt3z3QF1vA+pgqbyAC/2RZjTSrvdbwyJrwfl4rSCojcobXSp3A7ISUvEAqieQEoo5nagJzMOdQYvgj/jzfwY3cPlTkrA0yeQbVF6OaVvkUpgk/Ob88w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR02MB4527.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(39860400002)(366004)(376002)(136003)(451199018)(5660300002)(41300700001)(44832011)(2906002)(38100700002)(86362001)(36756003)(8936002)(478600001)(6486002)(66476007)(8676002)(66946007)(66556008)(107886003)(6666004)(6916009)(4326008)(83380400001)(54906003)(316002)(186003)(1076003)(26005)(6512007)(2616005)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Tk8VO2L0QhbXJjFLpiIbdZZ06NbnmAQhQeS5LjX5jyqo9mW9zKM43j90fvj1?=
 =?us-ascii?Q?JiuDHFzprWS/wdQrUIzfAsDVRP2n9n5sOyfYa7zjkM/7btEz5h+gAeUXGcI5?=
 =?us-ascii?Q?9GWt7uQsTCemfCImBB/pVvA7mUMODO8BZAYsvFdYACno6V3nHzSkjQvPkNnd?=
 =?us-ascii?Q?MoJYv2zLJ+s3tcBQqfBUobtDNqoZiUBmigZBLzZsQJP2YtaPJHquLvPs6R/y?=
 =?us-ascii?Q?leUy2IzZa9B+Pa0uftA4HoXc2cUzpYOVxdN12i9BAd1ZZVywF1ggYX9QcRBz?=
 =?us-ascii?Q?CMCzIFUd7Lk/1+KEWDZCt8m4abTDIuoQIe8WzZ7aqTeJLglAt6EXbOsZHZY1?=
 =?us-ascii?Q?utFxU7NSnkktC4N5XpNsoRp9GA2OmuuDcOn/T6B1Zwzv4MPnaITWyFQlv1Kb?=
 =?us-ascii?Q?fQL22dmNj+7BVCf6HaYBXYMFJxHCf3MwP4gyQYPwcDy8rfkWqzqFL9ewKCrM?=
 =?us-ascii?Q?eb4J/d8AtzDVOjMl4CfSP7Q9psQJk/N29tmLGRjIDRf9kFetyGzgYnWL6vbt?=
 =?us-ascii?Q?b5n1/f7krF9dlDv5FR3FPxwQLGCkHipz+w8GQ6u5SQy8Ll89bovaL6FradlL?=
 =?us-ascii?Q?DprFB6cvhlmEv8cYG+ePRX831q5h6ZZV0u3nj9yzOYIIpY2Ga7IkzU9Swd9X?=
 =?us-ascii?Q?DUUkx9JyJepN4PYcy9b4Ecumt5jC38cGWhi1uP3L4NxC3M6CE5qlzS2lDf2z?=
 =?us-ascii?Q?a+tSZjDJ03Lfvn3rDza3VERo0L3XqhL05XzK6WHGr01L1N0cYy/YpHUPncxO?=
 =?us-ascii?Q?BZ467Kd1XR3igwJdWcWbwydDjMK5yT/jFCQVy82+d2g6HO6vPYvGdZ6QiF4e?=
 =?us-ascii?Q?1fOigVswjo2wyaTGTMdddAZ43pzxgN6H2Bq5yy/7I5/zSoyPK7GzoKQSFqgQ?=
 =?us-ascii?Q?4U4IEQOg2sHFObpaovO7GUzUq0n1OwdgXmLBHKShh849H93Pd8BRu8OfsKWZ?=
 =?us-ascii?Q?se6Qp7CbO9Pllhquvxql1wfCw+UEW7li+arJ+yyFCifsjBBC+SDqVKB5Bomg?=
 =?us-ascii?Q?3OqwlHOgPpIImW/AuArrlqCBWT8kNHByvAkiJse75cDPq9rB1ls1e5u5bXgr?=
 =?us-ascii?Q?8BqcQllFxENOHKWRYARgrP6h6h0ihtwXRs6+NupxESv/hNpQf3bwnIkWXqIH?=
 =?us-ascii?Q?VCW8PxWFAPKtmAUGshfJAb1Pl1v620lohFougOW6qQimr2Q4wGhSUdzZjqZZ?=
 =?us-ascii?Q?vO9igkKe1X5nlM3oaq6xV2xJLxLIVXlhSxkdVymWY/qtGGPMK1XP01xlIMZU?=
 =?us-ascii?Q?rGZTleJsz+wnU5sqwW4QpWRy19iQklbx0CtzriCtsPhBzU2lrFfXAUmdMvuK?=
 =?us-ascii?Q?qz3KOcwDEbWUgtm/0fMuA10a/iGexnqEMCWIV7TUJy94VuWbdyM5mMN8QPk+?=
 =?us-ascii?Q?73qU0cQRsLYJkweEzB2q7hZM9Kor4GNM668Z4Pr4pPzawiAqlDkLBeHOGFKo?=
 =?us-ascii?Q?SBIxo1GgH78n+HD/GmyyBZA2aueIxvI63KlEmY5YsieqEvYYbaxHDs02SnAh?=
 =?us-ascii?Q?ElXDGqbb48ZfHvKj9/duvWTx0I9pSWY6GBb2RVrxYcWPck7PBG2f1153sFYo?=
 =?us-ascii?Q?T7tiLPUt+qZZ6MrdMJMLvjdc29fRwR69X38xZTRg1hB+pg6KEbXlAjwGmcJv?=
 =?us-ascii?Q?hA=3D=3D?=
X-OriginatorOrg: uipath.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3716de3f-e32f-43ab-4611-08db246d2fc9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR02MB4527.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 09:19:17.6999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d8353d2a-b153-4d17-8827-902c51f72357
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NTgY4k74xmH4H9zJzYoLt8L1QoLyg08KVVif2SNG3bZWPWxeXdfFLr+m1F3zTOK1SmtrjY4rYI+COUfgK+75pneo05aWoNUtLMDi3ReGrzA=
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
---
 arch/x86/kvm/vmx/vmx.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index eefd6387a99d..ee05c0e1cb2a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3785,6 +3785,17 @@ static void vmx_set_msr_bitmap_write(ulong *msr_bitmap, u32 msr)
 		__set_bit(msr & 0x1fff, msr_bitmap + 0xc00 / f);
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
 static __always_inline void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu,
 							  u32 msr, int type)
 {
@@ -3794,8 +3805,7 @@ static __always_inline void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu,
 	if (!cpu_has_vmx_msr_bitmap())
 		return;
 
-	if (static_branch_unlikely(&enable_evmcs))
-		evmcs_touch_msr_bitmap();
+	vmx_msr_bitmap_l01_changed(vmx);
 
 	/*
 	 * Mark the desired intercept state in shadow bitmap, this is needed
@@ -3840,8 +3850,7 @@ static __always_inline void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu,
 	if (!cpu_has_vmx_msr_bitmap())
 		return;
 
-	if (static_branch_unlikely(&enable_evmcs))
-		evmcs_touch_msr_bitmap();
+	vmx_msr_bitmap_l01_changed(vmx);
 
 	/*
 	 * Mark the desired intercept state in shadow bitmap, this is needed
-- 
2.25.1

