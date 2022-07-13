Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0D16572AE4
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 03:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233662AbiGMBgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 21:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiGMBgi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 21:36:38 -0400
Received: from sonic307-8.consmr.mail.gq1.yahoo.com (sonic307-8.consmr.mail.gq1.yahoo.com [98.137.64.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3462D1ED1
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 18:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1657676196; bh=ilQ63Qlh/pxWEmqxuxayijK2KJ9t+TQhVpcbdyvIRRY=; h=From:To:Cc:Subject:Date:References:From:Subject:Reply-To; b=PCONkz1sV3u1EryJ5YBSI/Vg3MtWr6jEa9qOBNKYeqP/Pu6ltZV6+rChsMyx2fJ0XNHhav48mVNbeMzN2giGWwr+L1ybbfbkWPwYQcyWgKV3jZHBEEDo6+j9k+Qx0uP/h4TIw2yb876mthUEMZiFnB1mVhLAVEid1wCr7BlYoeVoZ8SOMWaJwnJab8YfxRZdb3lfqDKdQ6ApQOVEc2QaxkV6HxRjRtlzjzKWri1C63iYeC0DZm3gZ+5lXCT1+6VBF7a1Agox/psCN8YXf2DWtq67jCV00N2BvL4BtXzU2Y9P7f+eHK53Kucx0Hdosg2tCpiFqZnZ4MLBz7NjzKJTfA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1657676196; bh=CfK7C2itV8VfkLP5ECLS/mYB/CEjf8Zzcx3VvW/HYW9=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=tgZea/8XuqvZi2f1BW+Srlk2njPyiMDabqbEwXkgH0gX6YGvIpBueBL3stkKGhgDn7D0bNNQvjlyl8uJSInpr5AN/9dPEyXlksyOwCwE5BD0DJjwoBzvUzaVCVamanpTe3xea8CJRLEhyRvPO3Msj4I0cx876o1GiM2L9dKw/ZTGUjzVGwG9fahmE+9qUSXxVgg/tgDsYxoCjBE9uBZTYs4GstjDlRN8A9aEsXmEy7E5IHgdIhRbIwlgTnocHEFm4cctb/0i9vMDONq5m+dkBPYJfEppqnnY9BAQ6T1mQsiz0/vh6P7Zm3/rofVHmpZDcInIQMbvXQrawdDZd7v0AQ==
X-YMail-OSG: wumnrFAVM1nJcpCj0FRu7OkeKPNBfKyNn3Z3Xi7QLjW.NGYqi6U1HzPu3JduYmS
 M08rb_OnmfwSrtLELFpb2Vg_BaA3lskWK9BQbt_OE0hAQuOHqVF1CW.2wjcgkuxnIbx0mQgZJ3vF
 gcIw84.JIufPAuJP6FwCP3MN467DUrjpjvdYuX4m9mwb7ZbFHUYIYxHi1dpzsfCMmGO0dRo0.Thg
 DkSvAAIUeGCGvsVR0MA17XtODtkZ03ZaFOUrh2vxV_mzBhNG2lXuiA1_FqpFLRECexBLZbEK472_
 oTcTejAsPR_D5leIh4fzHHJ_.q6LVK6GHWc3ynEyeuv4J0GT8TBT_NwbuUODDpJE41cUfl_ecbq2
 lDIz0WLKfPNZH0VhsGbteMKmhjEzU.J38Aa1lrnOMAncw0zT4ipL1MLzKRwLu3j2aAnbkzjjAm8I
 GpzjzCw5Y3AQCQcvnsrRGWaWIgXPoe25qnwcQojKGXgQTcXXnh4P47FZGGrvHZndLvfRmScTYtz6
 jiKIPBuxEcX2ybGjXcKWVBiw3dvSFm1GpyLGe9ifV40G47pjXUAzjYBWU_aof7qMCxJXX7EuFOmH
 3j7stKBYQ4GEQ2MNBwooPucjzeNZPH9Mm9Vjc48uCju0WSRYTHfdRNRyFieoZX50hm8eiPAEjAmY
 8MvIT1EJ0Zhsb_32VWnn98jqlUO0GFiKiZtuRNE6COb4QHzNAYv3aMuU6xEcZXMCGbuUAyK8HdEf
 _i9HqQ9.Rt78Wav9FK7FnZwVi6FNJ6urdS1IiWxCbEelvhJbAgoHIuwkwLN1cKrOtUjPMsEByu5Q
 tIn.ZoLx4gu2eoz_y5ZvUxKhE2rEu1wHveInW7IesHyldbHbUJqCEbFBG1AZBdUCIefG0Vaynt8B
 qZI85nCdssUT96AwufSzKvkTxeb2OFJubJHRHAjO_yz2.taV0HvCuTfmWNWMANKMOv_vevgD7HAj
 kIqTL05wZoHGlUVnE.OMqzeVbNAU7KqoVYLJ1tR6SBaThKwunBBo4kFqMsfjuOVJYidwMRSrLp35
 dCXUCr8KG.wJG24o6I6zh84zxvcOjTbLPkpdSfZOVLRPcoA8NfR80kTIaS9U1t97ZcOSivJp1UzL
 uJqiFSu4ydh.OzVFxi45.2iG6L593Sy2QTJg6vmMxWNmoS24QzIbwgScbhETPchGdvCM2Fe.IjvT
 06RvN8kaIHooA8VebWoErAWlN3yMEUzhbTjBQizIlF3A4zU4ZsI3.0AOnKBGaUpmBz_PBSCgglnT
 kgdawGYS1C4x9fPLEH4DZ1pZ6wGPZORHVCwZw3mAEcJgQ..5BPXHJd2.CEvNOO52bKuvwjCiMf_h
 LjNa3m2fwVbLiLio0uo9oypoUjOubL5F34v4qlvx9fjnryCzMKne9em_d5sfAxghrmuOX3N21FEU
 RtR_soeO4aSbO2ppt0cXdiq8wtdc2xhSJeec4bvKzRLDmEojX5slrdyJPJDwL3eNMhnJePcVynfi
 cwLqIFqlvtA8zE4oN_e6k0YTcu6GEZrpaxPIFVzIzY5_VALY4NztEI2h8EwiLT.f2Mh6e_.bZSUk
 .j1w6ikSRiEehXxzA.uSQJsKAuj9VmEheZEo4GWe0AHY.7_nXbz4CE3F1DevEgmefKoX2NBLAl1p
 Jm5p173vfBI2_Ad8LOOcVOPEVJzYo5rfQQeYNN.svewXFyEvIC1c_ARsrDAnMb_0IWn4H293rCs5
 BY7GewJHlVZ60golVgZkdTef5wTbxNYtGxPYqPzqma2TlPO_RdydxbgUYVycpF0hX3pGokxJUpf0
 m2QtoVvyLID.ifyCGyGP7Cl7EaJ9Kz5vjSqVq2l2mS8sctELhiKgxlPpIlgPoNs2W_1HkONFJ4OO
 PFIFV9b2NXnkH5mQqlbX.SN1awwekaNX0NlA0aJpycsTrDYkW9BZVWnxPtFw1MM.ykkNXzzOzubJ
 VBP5UVpFTo_v9T7RB_TcwQpbf98RJyb8Ezp8yeV2sp7YuF0wlCbzAcpK8dBtDijt0LBsA9U0sgZa
 Xni.JVxiN2Q37LtsDV2MVZuyA7wzHjxifbyic.ti_T3kZbCpevWuQEWrCc8ji6OtoR0mWx1Kyi_a
 CgMVcvzynmRKHXdP5qxuUj9JHf.XXfqNGJUdugXIdYXnIOOd475oNRctSulgNDDRTMnH5RlC4yZB
 _LzGgqoISOPb7rz807J2Zeb2lDc2MgByXghDseqr6KhO51QP8KJnCsPup.oM8svNsHg--
X-Sonic-MF: <brchuckz@aim.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.gq1.yahoo.com with HTTP; Wed, 13 Jul 2022 01:36:36 +0000
Received: by hermes--production-ne1-7864dcfd54-jt2sh (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 103a284e887da164b6a51a28e1ee36f6;
          Wed, 13 Jul 2022 01:36:33 +0000 (UTC)
From:   Chuck Zmudzinski <brchuckz@aol.com>
To:     linux-kernel@vger.kernel.org
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Jane Chu <jane.chu@oracle.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jan Beulich <jbeulich@suse.com>,
        Juergen Gross <jgross@suse.com>,
        xen-devel@lists.xenproject.org, stable@vger.kernel.org
Subject: [PATCH v2] Subject: x86/PAT: Report PAT on CPUs that support PAT without MTRR
Date:   Tue, 12 Jul 2022 21:36:12 -0400
Message-Id: <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz@aol.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
References: <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz.ref@aol.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The commit 99c13b8c8896d7bcb92753bf
("x86/mm/pat: Don't report PAT on CPUs that don't support it")
incorrectly failed to account for the case in init_cache_modes() when
CPUs do support PAT and falsely reported PAT to be disabled when in
fact PAT is enabled. In some environments, notably in Xen PV domains,
MTRR is disabled but PAT is still enabled, and that is the case
that the aforementioned commit failed to account for.

As an unfortunate consequnce, the pat_enabled() function currently does
not correctly report that PAT is enabled in such environments. The fix
is implemented in init_cache_modes() by setting pat_bp_enabled to true
in init_cache_modes() for the case that commit 99c13b8c8896d7bcb92753bf
("x86/mm/pat: Don't report PAT on CPUs that don't support it") failed
to account for.

This approach arranges for pat_enabled() to return true in the Xen PV
environment without undermining the rest of PAT MSR management logic
that considers PAT to be disabled: Specifically, no writes to the PAT
MSR should occur.

This patch fixes a regression that some users are experiencing with
Linux as a Xen Dom0 driving particular Intel graphics devices by
correctly reporting to the Intel i915 driver that PAT is enabled where
previously it was falsely reporting that PAT is disabled. Some users
are experiencing system hangs in Xen PV Dom0 and all users on Xen PV
Dom0 are experiencing reduced graphics performance because the keying of
the use of WC mappings to pat_enabled() (see arch_can_pci_mmap_wc())
means that in particular graphics frame buffer accesses are quite a bit
less performant than possible without this patch.

Also, with the current code, in the Xen PV environment, PAT will not be
disabled if the administrator sets the "nopat" boot option. Introduce
a new boolean variable, pat_force_disable, to forcibly disable PAT
when the administrator sets the "nopat" option to override the default
behavior of using the PAT configuration that Xen has provided.

For the new boolean to live in .init.data, init_cache_modes() also needs
moving to .init.text (where it could/should have lived already before).

Fixes: 99c13b8c8896d7bcb92753bf ("x86/mm/pat: Don't report PAT on CPUs that don't support it")
Co-developed-by: Jan Beulich <jbeulich@suse.com>
Cc: stable@vger.kernel.org
Signed-off-by: Chuck Zmudzinski <brchuckz@aol.com>
---
v2: *Add force_pat_disabled variable to fix "nopat" on Xen PV (Jan Beulich)
    *Add the necessary code to incorporate the "nopat" fix
    *void init_cache_modes(void) -> void __init init_cache_modes(void)
    *Add Jan Beulich as Co-developer (Jan has not signed off yet)
    *Expand the commit message to include relevant parts of the commit
     message of Jan Beulich's proposed patch for this problem
    *Fix 'else if ... {' placement and indentation
    *Remove indication the backport to stable branches is only back to 5.17.y

I think these changes address all the comments on the original patch

I added Jan Beulich as a Co-developer because Juergen Gross asked me to
include Jan's idea for fixing "nopat" that was missing from the first
version of the patch.

The patch has been tested, it works as expected with and without nopat
in the Xen PV Dom0 environment. That is, "nopat" causes the system to
exhibit the effects and problems that lack of PAT support causes.

 arch/x86/mm/pat/memtype.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/pat/memtype.c b/arch/x86/mm/pat/memtype.c
index d5ef64ddd35e..10a37d309d23 100644
--- a/arch/x86/mm/pat/memtype.c
+++ b/arch/x86/mm/pat/memtype.c
@@ -62,6 +62,7 @@
 
 static bool __read_mostly pat_bp_initialized;
 static bool __read_mostly pat_disabled = !IS_ENABLED(CONFIG_X86_PAT);
+static bool __initdata pat_force_disabled = !IS_ENABLED(CONFIG_X86_PAT);
 static bool __read_mostly pat_bp_enabled;
 static bool __read_mostly pat_cm_initialized;
 
@@ -86,6 +87,7 @@ void pat_disable(const char *msg_reason)
 static int __init nopat(char *str)
 {
 	pat_disable("PAT support disabled via boot option.");
+	pat_force_disabled = true;
 	return 0;
 }
 early_param("nopat", nopat);
@@ -272,7 +274,7 @@ static void pat_ap_init(u64 pat)
 	wrmsrl(MSR_IA32_CR_PAT, pat);
 }
 
-void init_cache_modes(void)
+void __init init_cache_modes(void)
 {
 	u64 pat = 0;
 
@@ -292,7 +294,7 @@ void init_cache_modes(void)
 		rdmsrl(MSR_IA32_CR_PAT, pat);
 	}
 
-	if (!pat) {
+	if (!pat || pat_force_disabled) {
 		/*
 		 * No PAT. Emulate the PAT table that corresponds to the two
 		 * cache bits, PWT (Write Through) and PCD (Cache Disable).
@@ -313,6 +315,16 @@ void init_cache_modes(void)
 		 */
 		pat = PAT(0, WB) | PAT(1, WT) | PAT(2, UC_MINUS) | PAT(3, UC) |
 		      PAT(4, WB) | PAT(5, WT) | PAT(6, UC_MINUS) | PAT(7, UC);
+	} else if (!pat_bp_enabled) {
+		/*
+		 * In some environments, specifically Xen PV, PAT
+		 * initialization is skipped because MTRRs are disabled even
+		 * though PAT is available. In such environments, set PAT to
+		 * enabled to correctly indicate to callers of pat_enabled()
+		 * that CPU support for PAT is available.
+		 */
+		pat_bp_enabled = true;
+		pr_info("x86/PAT: PAT enabled by init_cache_modes\n");
 	}
 
 	__init_cache_modes(pat);
-- 
2.36.1

