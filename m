Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5546BABA4
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 10:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbjCOJIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 05:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbjCOJHk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 05:07:40 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2135.outbound.protection.outlook.com [40.107.15.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BECF07B98B
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 02:06:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nuv8WC8ELnMyngfo+7HGzoODKQ6GLInVU8oY9fqgJMOZOTlRIgKKrh1cUhh3H6u5MwcqSZKArJStM1OYszCFfA899UmW8Hj1gv2jRDX0qkAFKiqpsCuhUAH4JhOoIJ8n31Y89zTNkBOvnX9zacPkzlfS1we7IKBCqrIFGHMeU5IRf36BS6eUxCrfp8MhngAAOeCqsOhsRLixn6xuLvmXnlOET/qSspiIAf/4Z8PPpENeRg/9SlfvZgeAGpUkHuWkbwQJwY6VSqlJRlk1HFfxW/qmNAFuwvhD5vi2+6NybnW1BHkzGOTGory74SEGiVMe84pkragPu+eaasXzAc7PJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2x3G80S2iomfzAAgWv2TLDKDWedlVIZ8uUzrz7eCgPc=;
 b=EqxZ16d7lmFl4LMhWMpNmjIQm0/e56hFWXDhfEHlxnh5W83ivjVqrNA9lLwUWBAo994h4MZWuRyNAhkL+EchhSGCkftJHRIxgXbtgNr8hRw3R0XEXdugicB7eTj6i7ZnVNysQ0RkESqbK068Va1glkzKV5t8FMVZ01/Fwzil1UO1PXond/h1nY3y7HmsoBIjcZ7d9TD+RlXah2euL4D+KSb0JyeloJOgM/BP0xDHSxqiIf24rpoAWXwOzRpQD7CGv5JFM4Lct6L/IT7Of7EfeMqikK8X1KHqYu5KhqDupfI2D7ZXHe92hvWZu4Cz+hfM1AnUIDIEGJ0fO3Gr16wuPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=uipath.com; dmarc=pass action=none header.from=uipath.com;
 dkim=pass header.d=uipath.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uipath.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2x3G80S2iomfzAAgWv2TLDKDWedlVIZ8uUzrz7eCgPc=;
 b=USUMY3sBpcU/2mF2Wl2PvsuXxN42LwVMcRS7KULXGmSfdXoQwkPItTZHXRK1EVFmAGEKtyj/gASGXeUw4bBXAsqxiMcqQv7R7jPTTHd1Un3To0P8XR3MM/fwJqeDizXl/0ALce0BYsbA0LaZFUfRwJOHxd0XFKdR5WRyki7xl1IIPC3BYBf0y2aT6qFCjaWJea3w4j9FKjzyM4d2d3j4sVzbFjMu6yret2PTU+BCWyGzzBiuOW7QWwaEoLBu7Yz1A2qqYJWSTzQfx/QC5734FYk3ipcIglO+C6pFd6eSr72WDVEMBFL9oDODsinfHoKBESprjmXu/5V/quRaaXWwfQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=uipath.com;
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com (2603:10a6:803:b1::28)
 by PAVPR02MB9866.eurprd02.prod.outlook.com (2603:10a6:102:310::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 09:05:57 +0000
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::224e:d6bd:a174:9605]) by VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::224e:d6bd:a174:9605%6]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 09:05:57 +0000
From:   Alexandru Matei <alexandru.matei@uipath.com>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexandru Matei <alexandru.matei@uipath.com>,
        Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
Subject: [PATCH 5.10.y v2 2/3] KVM: VMX: Introduce vmx_msr_bitmap_l01_changed() helper
Date:   Wed, 15 Mar 2023 11:05:27 +0200
Message-Id: <20230315090528.4180-3-alexandru.matei@uipath.com>
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
X-MS-Office365-Filtering-Correlation-Id: 56002b5b-2f8a-4d32-4acc-08db25347d01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hh8BfJbzJMmeXEXSttF/fUd1sx222dWRX93JVQz6n4I7nefMpJVuEOvrPbHngSXZQuQXgvYsyCOok5v3/b86t7ZD2SmojW+GlSZmssH1nuvI0lGpGqYB9mlUZjfiPuuE8ND5MkkqOnuKHTQuX1NM/PIvqisuJ6wUmdMjzGHHW3IEFShaNCRHj3arunhCRf4QzDE4AYSn2Yivs29IS5dNOtMg7TWOKi0zn1e7f4hVywmERR0AxDv6LS9CX5tPxFoSmCYZPduvA+/D62paxlUcujk7EekhDEGimRGEcupkXgHgYmuDoeQU4afUAQicY2UWfRf46BsKxxU3YfvZNXsxDWJAHwSV0sHX1m7X4KVeLRoUuI27md9oaiVzy9moUej6C85orgOatdtIZtUCHmpy4lZXcqkUurafHj7qk+bUl3UegvbGn0dlPXq09ctsvFvMYiGkDWvpwB4IwSByV73FeALRDgDxFRmO6zM7QUgHFL6urdnrsO4FVW3HNvgIvqDhaSW97VcdBfngz17UYMFN0UbdLIe9u3Jy1MpvpgebSHycLxuQ0RzDxDLAxKh91JlrqEu05m3KwT6445htUsit2XoJ9OooxrNSF2qzReCzqw3XiSpFBmrdr2D1hHUY7rG9c8ChHb7vny/jAcdMtTRwmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR02MB4527.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(376002)(396003)(366004)(136003)(451199018)(316002)(41300700001)(66556008)(66946007)(66476007)(186003)(6512007)(26005)(1076003)(6506007)(54906003)(8936002)(6916009)(8676002)(4326008)(44832011)(478600001)(5660300002)(36756003)(6486002)(2906002)(107886003)(6666004)(2616005)(86362001)(83380400001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xRhEmiLQk2lXbwgoW9gth91eY36gm7yqbmVeILZTbYyx8wYL9olXYA0yj2gV?=
 =?us-ascii?Q?yXefBMcBasYS2qgr3kccuVSogQsyCFn4ZmVW/0AGqzZQyx3K0cWpE8Cyp/xK?=
 =?us-ascii?Q?zj2c3kuPikYyvomc2H1H2fOfkkUeb7u0mmBEtwf5Z2LYBbUKct1IPn++36kI?=
 =?us-ascii?Q?XncxIqIVoF867jB5Q9EzarIEeZN3M17FD8o5llI3OO//9BVJbFmC7JujJKqZ?=
 =?us-ascii?Q?tp+bBff7pQIBaxYDAob09QXrLWxl+WQhuv2mIHfkjRbvRadncrylxN8o/JUK?=
 =?us-ascii?Q?EPejVcoSFkSmv3ziKr8RupZgYKo7kChg4ifTmMlEacBeoi0qJ2MdnqrEdcSe?=
 =?us-ascii?Q?uibjHKQh0C5tS30OXJVpFzzGTCYDYa6eJTte4zu4Tf3RRs2TxNGEYfsfMy36?=
 =?us-ascii?Q?VVfbUc+X6ZjUoc5HTfZ+JQrMRsu8qlS5Ec6C4Vtl2MMMUDnIsMfUxs/iiR5G?=
 =?us-ascii?Q?93qjjSd7gPBkjf8FOHqgMuZFrV4AqLc5bD+WQauGI0oUPT4A0fFfxVnWeOlG?=
 =?us-ascii?Q?M6vj4ObXfj/SDy30l6Eo2wskYKEPLW6g31FhAANty0+YdRftCJf8fRYIx9lj?=
 =?us-ascii?Q?SPPuZjZ6y/GT9eC7wVYKHRh8VvzpkaOb3T3fwIDU1I2O8z5wuuSpENbBnX6N?=
 =?us-ascii?Q?0alaq1XrXrMF0ain7f6JadXDjVCgEXhWCmyOaHgrWwYc0Ah+aTa6hPrYFPt1?=
 =?us-ascii?Q?TPY3eJjH9szf+p/Brc802VAzWHtAhAxMKuNsTvKSZX6wI6mZ/xRMKHIJlinc?=
 =?us-ascii?Q?fhjU1ZWML+pXqmmZFuJ1S012bYeY1rGqb6jAkp18JPzmeB84bgtlJL4yiXYM?=
 =?us-ascii?Q?bEKEvjQqcHxQWniRTjLGrgvoVkMhJV5H+AvjFvJkqEfuq3GklGVMibqo5VH2?=
 =?us-ascii?Q?xEpJHCN726ZWwOTMIeTNlo1UEkRnrO+1JOzSIOkeS+2LnBA/9lCsMJTE2JjA?=
 =?us-ascii?Q?Qly7fpFfklCgdjfH76HRc+GHJSHEFrRZkOdhSIl9Z9usW+PLHKvCIeCOapCG?=
 =?us-ascii?Q?j69OCK/Tm9fMMNy4h1aCoAAbObzL4RkKPpQkKtp0Ce9QcOoEn+zvTXjP+Hwh?=
 =?us-ascii?Q?r0ME3zT0mL8E9I9yYTbfnO0zo7HKEMNSiwvaOtUo7JwVHppRyr2G46zueWrG?=
 =?us-ascii?Q?Uu+eIwh3MHizSn++PZJ6Thn3EbmdPv0dCuQvn9GGJLIe0TIdZWn4Zfa4cmkp?=
 =?us-ascii?Q?hFgek0L8khAjbhyRZ5mMFqQfiQSswS6dZyZm1rTlJHkdjY0t+4Xor5dv68AU?=
 =?us-ascii?Q?rHO4R4+dMmp4oXBmG6XyQf+e5rEvFsIQhJXq2E7WcG5rlOgKRrMjA0mSwlcd?=
 =?us-ascii?Q?Mnrv3/avwKxm8BoxLzuoWitkoQdGkbMYkobDshs+U0KioyXqc5bM5GBwSjaO?=
 =?us-ascii?Q?G4RaJAuBNZ+DmvLj6nkZVPTSbgRhavEWSdC/lycMQGcZ9PKdj3F25f0nTzFw?=
 =?us-ascii?Q?vD/I4m3UkLFkfup9EW+jbmhoO2yyYAZPm3VBXtrR+1tzXfFr4OF5jzA9uS0b?=
 =?us-ascii?Q?3ChoI5fTY/r96OfIH4iyx54Qni/EyG0znMwJoilYN9b2fuKfhCLsQrNmy2Uo?=
 =?us-ascii?Q?cIN2aXgviRmbfPMJFox7BFoO9Ckd4OTKirQnDlvPbCG6h/9u0ktsx2Z9kvEa?=
 =?us-ascii?Q?tQ=3D=3D?=
X-OriginatorOrg: uipath.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56002b5b-2f8a-4d32-4acc-08db25347d01
X-MS-Exchange-CrossTenant-AuthSource: VI1PR02MB4527.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 09:05:57.1945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d8353d2a-b153-4d17-8827-902c51f72357
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y62Fp7WJu0QLTcYXedwSajZjP7d/NIuSwVCGqjzHrwy7ii88JppuEy6S6sktakyoyRcf6h/9vwkZR8bYkJ7E9arInzODwzF/e72z+HPJUvY=
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

