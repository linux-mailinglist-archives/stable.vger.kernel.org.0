Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B44D46B8E7D
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 10:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbjCNJUX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 05:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbjCNJUU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 05:20:20 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2115.outbound.protection.outlook.com [40.107.22.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9682A8FBEB
        for <stable@vger.kernel.org>; Tue, 14 Mar 2023 02:20:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EXT0jkvDOVAeLsojDVWa+Rp7Of3vX9zv8mx/LPJWgtfk5C2Gun5/MntJEY0SeuACE5qJ8t61RfKXeVVntbUISNHH0/tgL1CYShBPSBZrvcbT7Bsyb4Jl/IO/wfDPO+T6zqq0M/n54W4oHZOJmhWjqcV1gGiKqoip3gATUu6A5bktJ/ik1aYl2hjZs0XrIEQcxfkf5E4y9aQ5PWiLt4PV2vi5E1twq87+Mare3n3+AHs+V/lbdWanKxigjWWYyz/+1ltCfBD2CxZ652CS45L0wMMKC1zF7m2EwqTnn2ZdhQWQ+xPM9z38Tv0z+qZP/wuolwm/KS68jqUQmZNP4i1UDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zD4IzJymevbGi3MGqa23nRSHX+Hq1qF3oalvH3J6f20=;
 b=k62ETuCohZX37YbYm7eIKISHfyFeJClEFOS3akLIJcVatquAxM2ELY0efJQpnuHV86hafWkfcxfPYqgRLur6I03eXVaU5fENXOyS+sVZiN2QJ73IhUZUf/2qiC9MenxZI70iPwCqPseaTyD3voOAVgKNHbSEqErkiLghWRvDSnhIlQgFJjQFeTaZNUYHcJn5/IX/7iTKyKirr0KNAPWRPHS9o+8fa3O69GY6vDPxkD4owtHcVF6RUpDAVe7FVOS+VMAMMupO04ts54iWszD4VqQeT+KVKylZlia9hVK7PQIqzDlbVRMa1/0YfbRkUoAYjuW3bse/u7ezjXCnsk3N4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=uipath.com; dmarc=pass action=none header.from=uipath.com;
 dkim=pass header.d=uipath.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uipath.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zD4IzJymevbGi3MGqa23nRSHX+Hq1qF3oalvH3J6f20=;
 b=at4XC7o4eijvWSBpQ6AaLIGZ8SIfmzcCXNwNWv5rdcxtxSl0zYKkadAuJbkerp+2Ymj24yrb00H4t7iMGvbwPWw+82fr+BYpNT7F0wCY2pj94nNsyyDeBt7YOvJdOGfN+H4ci/EDpjSO5jIhx7Kx8PiVoMyKp1iXJ5FjhDxol5qBPwDhntDMkZ5ltAeEnysFBVJiwzI2+SZHnMuM/R1aVM4RPlatu+VZ1C/y4lv9LDNwFtvrKFFFhoGrTTWEP9rz/eXkMmDZ/VCrDryzGSaptiMCvCZ4XuV/N66fxjr/OAn9epXNOJlIhZUQti48B4lFefCwwRW914Lk9RZK0uwXuA==
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
Subject: [PATCH 5.15.y 2/3] KVM: VMX: Introduce vmx_msr_bitmap_l01_changed() helper
Date:   Tue, 14 Mar 2023 11:19:52 +0200
Message-Id: <20230314091953.3041-3-alexandru.matei@uipath.com>
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
X-MS-Office365-Filtering-Correlation-Id: f6daf454-510c-40a0-5bd8-08db246d4d5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JAlWEnqWmxpcyWOtZNm0z4qqZLRQZy5lpMrqR5pcla/tfKW17csBMdKjRDS0+ZobhMWMzQ4RH5FosxIcLKKXzfCJUez6to3Antj5qSokZfNDZTwEgW62CR76e0OCRRR2zmexIe4v8qyS6drepRo08YOCc0DNNC9gfveHTCAFt9izZywQN7ERcvDZVDBVFAiLJ52XQsHjGuoXDEDm8xPce/dtirv0EDGhiNFO41RuDoiACQrz1ne7kuGh9zZI6hYp59veH3AmkoxK+4xH42K52b5zyBLUTGZDdPpRKhnxdGoQNIPXYUAgBtyHWO/U0k8VKlNDtQ5ar2All5lvnu+ndjf4Qu7qCv/z3LtijOUlvhbiLPJcYbjk2iGb+JlhM19GNszyByqz1PoreuCCGdP0qobtt6B+tlP+3tmaGG8rOkzypnylKO+nzsFjamFDm7i+XamdKMaH8ltTrO2vQ9wnI4/6uy9ocBmhJ6jnTxckCAKYYh9y1Rzg3WqutbHFijf97wgqbkg08N+iqfjHICHnQLDl13ZfmKy17O6GgJBl+DBrNBe7Sf0XlcdcXEmqPD1N+fwhMhsWt4JDciLi1m5zGk6vQUT0dglvGUMs219vY4Ug/tZ+2f29IDUE2GQ0dyVUkFXHNwGTosnbP0EMK1iShQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR02MB4527.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(39860400002)(366004)(376002)(136003)(451199018)(5660300002)(41300700001)(44832011)(2906002)(38100700002)(86362001)(36756003)(8936002)(478600001)(6486002)(66476007)(8676002)(66946007)(66556008)(107886003)(6666004)(6916009)(4326008)(83380400001)(54906003)(316002)(186003)(1076003)(26005)(6512007)(2616005)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?krUEMuMkG3QIxfvmcshCudO/+gwfmnw/pdrlCcMwhXpqL8uMMLc1FRJtg/Yc?=
 =?us-ascii?Q?qMhiSlsV7y5J9kf9YMKtJCw7fjCiqY/Q/9FV72+arluipvavLPNIeEscitjT?=
 =?us-ascii?Q?OMKaPKcsPRZBO3rp/yaMEH8evWGZhdfZ5jvHDMv6RRxtGd/8Dlx8+q3YYqLf?=
 =?us-ascii?Q?IZan1Ivxaf15GP1GWXyJmMGkJwiv6v+HGPEh8FoYgxIfFQl0z8VgBYMrIsPM?=
 =?us-ascii?Q?kJ9dSgeFsKGXEtaj4bELtcRxGoH6B7lafE3NynQr0wKIIYI0TZjY1wMJ9fq4?=
 =?us-ascii?Q?2O0miELj0vcYJzFUKR0VS0Lj/oO/RCGmWeZRRSXjaiTzca2yUvTihCOULYNO?=
 =?us-ascii?Q?8UMbKLDigOu9NZHzntGwcnDi1QcCgen+w5MtaM/8bfuiNVicUK8haGbVPi0T?=
 =?us-ascii?Q?DY4ZF+6BzFTPQyQ5rgNEoT6EohF+jPUutjMXwWK+ARqcdAWBoodY6K76QcPY?=
 =?us-ascii?Q?LJF9aX20/ziOAwuFiYUxBkwOI31CT/3PTAFfjBlfHb2FDY8P7lvmfxQ73Ome?=
 =?us-ascii?Q?AOEg5aJZ+Gpx5fI/YC91D3ikoJFMcsidJ7jfXSWFzT0Me9OXwVSA7Q4chbzZ?=
 =?us-ascii?Q?pApsL4Y22BFw2R6TM6utTJDMdv/jPRAM9PNLMTDx+1SETaQw86aBqaaeriEY?=
 =?us-ascii?Q?dFzTB81hv+xviEE7ZawCrDa8LiFuLNbLWeXMQPKeqSqgsQAFMVSdoFH5+6vG?=
 =?us-ascii?Q?T88BWzLN1McuS+25cBUpBppSqyt9WsbGhl+JTqYDqlxGvT8VKzPo3z5Ztks/?=
 =?us-ascii?Q?UaYjiI/gRumIrrT4WK0/o5q6EPZOglqpzB1pnUU4tdnRcFmfwmbSVUYpLQf/?=
 =?us-ascii?Q?sgr8WK7/RUnMb7c137EEtw60dhRUzTV3vnt/ZLT/ukmEHcLTUSDgJujEAPIx?=
 =?us-ascii?Q?Xivds1kgSSatr5UXIEaTxFGTs0NLLw26HP3c3BxMHBMZ3jMqSQeP/Ubz3nRr?=
 =?us-ascii?Q?CWpI/KzuC/sGGJM7GuwOfFg7EfYXcgJgXSvs76c+83Ud8PEGRRNG0eyoQcTb?=
 =?us-ascii?Q?Xk1SqDjAz5cnUlX0c/0Zui2LkNe6U6dPswcdGjXwRYq2EoW5KyajHmlcmFT5?=
 =?us-ascii?Q?VuRpLDz8eH1G6D/eALJtgudj+7z0RHfNQln2YOwuBB5BwZmCDQTAS0sjtl8c?=
 =?us-ascii?Q?4zDDbmKY4UatrEp+02vGjRVO7CvA76/1Ns3kPNMH5aXV4nUJjVFEL1i8rKvJ?=
 =?us-ascii?Q?O88H3zVQvRIIvyzHQ31OukzrTDcIPP24xlOFK5olAuP4iV05JGoqh1AX827U?=
 =?us-ascii?Q?BtWp/mwQDnUTgjEhVeCDfOFtd1J58ucP4m7O14BlNt2t+Dw9QEkVkrJQrssT?=
 =?us-ascii?Q?A3s3whoEZAzyP9SdKvnPYoQeVZnbF7eSpGF3yWNDfaq7riqKz29YTT+STxIx?=
 =?us-ascii?Q?xhfgsvHr6zBjUTyvQ2rlq7prRIzkT0nB0t9ckCNH7X9lStZvkmV9vWpDYAdz?=
 =?us-ascii?Q?08lhTD3wQqBxHpFwzncC/WLDiy7hQSwnuQ2ID6sB55QDZYyplTxsirUHLnD1?=
 =?us-ascii?Q?BShF5M6EsAahwhJ9XGfcnLy9+8DGiAELwR/WmHG1P1FBUpUgUlndLtyf4BUl?=
 =?us-ascii?Q?aw0cYC0dNHezyAMTKKOleuPh9uOmBkFwKweovExuCwt6Si8X+CrDq8yFqnqO?=
 =?us-ascii?Q?Qg=3D=3D?=
X-OriginatorOrg: uipath.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6daf454-510c-40a0-5bd8-08db246d4d5f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR02MB4527.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 09:20:07.4156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d8353d2a-b153-4d17-8827-902c51f72357
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DoO2GKJ/t7m1gvZPNcv2jUeCtvSvtnr9GduaxQ2/huq6Zjp81xhSMhX+0kx6CScB7g0ZPYWSiPPKpAp3LQmMjgcM7Tr6VQ4mawi1a30o+wA=
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

