Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9392363E
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389637AbfETM2O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:28:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:43936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389621AbfETM2N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:28:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA88B2171F;
        Mon, 20 May 2019 12:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355292;
        bh=yNCRd+eOXOTE0d/MEkfYEESKg8Bn3wudNisrxhdpgho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I1IAWiEdNypDJ8uEiC24RlaeFqRcMuEQ/7LjBJi6Izx7nfazwoMeDPb1T8jKynURw
         ZJc8SuVYpKfCrpXBefexO1tkO1nkweXLYsTYMGGUprRezDUFKGZdqx27QOEORulp88
         5oN9i9bpf3DvRsVC28Ud3VwJrG83YbpKB5VC2aEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yazen Ghannam <yazen.ghannam@amd.com>,
        Borislav Petkov <bp@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        "clemej@gmail.com" <clemej@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Pu Wen <puwen@hygon.cn>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
        "rafal@milecki.pl" <rafal@milecki.pl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        x86-ml <x86@kernel.org>
Subject: [PATCH 5.0 023/123] x86/MCE: Group AMD function prototypes in <asm/mce.h>
Date:   Mon, 20 May 2019 14:13:23 +0200
Message-Id: <20190520115246.373480039@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yazen Ghannam <yazen.ghannam@amd.com>

commit 9308fd4074551f222f30322d1ee8c5aff18e9747 upstream.

There are two groups of "ifdef CONFIG_X86_MCE_AMD" function prototypes
in <asm/mce.h>. Merge these two groups.

No functional change.

 [ bp: align vertically. ]

Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "clemej@gmail.com" <clemej@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Pu Wen <puwen@hygon.cn>
Cc: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Cc: "rafal@milecki.pl" <rafal@milecki.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/20190322202848.20749-3-Yazen.Ghannam@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/mce.h |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -209,16 +209,6 @@ static inline void cmci_rediscover(void)
 static inline void cmci_recheck(void) {}
 #endif
 
-#ifdef CONFIG_X86_MCE_AMD
-void mce_amd_feature_init(struct cpuinfo_x86 *c);
-int umc_normaddr_to_sysaddr(u64 norm_addr, u16 nid, u8 umc, u64 *sys_addr);
-#else
-static inline void mce_amd_feature_init(struct cpuinfo_x86 *c) { }
-static inline int umc_normaddr_to_sysaddr(u64 norm_addr, u16 nid, u8 umc, u64 *sys_addr) { return -EINVAL; };
-#endif
-
-static inline void mce_hygon_feature_init(struct cpuinfo_x86 *c) { return mce_amd_feature_init(c); }
-
 int mce_available(struct cpuinfo_x86 *c);
 bool mce_is_memory_error(struct mce *m);
 bool mce_is_correctable(struct mce *m);
@@ -338,12 +328,19 @@ extern bool amd_mce_is_memory_error(stru
 extern int mce_threshold_create_device(unsigned int cpu);
 extern int mce_threshold_remove_device(unsigned int cpu);
 
-#else
+void mce_amd_feature_init(struct cpuinfo_x86 *c);
+int umc_normaddr_to_sysaddr(u64 norm_addr, u16 nid, u8 umc, u64 *sys_addr);
 
-static inline int mce_threshold_create_device(unsigned int cpu) { return 0; };
-static inline int mce_threshold_remove_device(unsigned int cpu) { return 0; };
-static inline bool amd_mce_is_memory_error(struct mce *m) { return false; };
+#else
 
+static inline int mce_threshold_create_device(unsigned int cpu)		{ return 0; };
+static inline int mce_threshold_remove_device(unsigned int cpu)		{ return 0; };
+static inline bool amd_mce_is_memory_error(struct mce *m)		{ return false; };
+static inline void mce_amd_feature_init(struct cpuinfo_x86 *c)		{ }
+static inline int
+umc_normaddr_to_sysaddr(u64 norm_addr, u16 nid, u8 umc, u64 *sys_addr)	{ return -EINVAL; };
 #endif
 
+static inline void mce_hygon_feature_init(struct cpuinfo_x86 *c)	{ return mce_amd_feature_init(c); }
+
 #endif /* _ASM_X86_MCE_H */


