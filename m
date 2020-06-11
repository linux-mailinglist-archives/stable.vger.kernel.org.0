Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 057311F6209
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 09:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726624AbgFKHNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 03:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbgFKHNo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jun 2020 03:13:44 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F40C08C5C1
        for <stable@vger.kernel.org>; Thu, 11 Jun 2020 00:13:43 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id e1so4967220wrt.5
        for <stable@vger.kernel.org>; Thu, 11 Jun 2020 00:13:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hsFz/gRwZLSwEkcvDUaUgYIl1q6nF464Pnh5iyMciVE=;
        b=WuRHYzvWJ7K0Y7BbQc1qPZPKJGh8m+5CuWVzqVYVTRT6LamgZ1xqDVgTA+PUpEXiZN
         rnJUciPFw2l4zrLdiezz2HPCDsdoXee4sGE2oys3W+k9IwAkWHv1UKMqK5A8gL3WmEiZ
         E+c3Pn1ruLcHmyi1jiEnDA8RzRSSN/x81mptOGQAMX6AdCzBWxshL6+2d3oHl1Rcxauh
         JndSQo9cFxwwRlRmdveA/K8dMwukSeDWJ8Yoa3sbz/YlM3LKoTrNyGvpCdcAgi+iYZsp
         E4RjJguQUcuFMWys4KEm5Kxzpk/KNswRX66Q22nBhY54BjOwuz6FHCApqDWL8RLq9Lmo
         yMzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hsFz/gRwZLSwEkcvDUaUgYIl1q6nF464Pnh5iyMciVE=;
        b=QNR0dPJCubLNfozXH3RoJwLdJxnkFiDEEFunno6GpzS8ps3IlMLJ0ngekjkqKITjLN
         3vlz/KdmORWBCutxHDUsesyWYE+N0LZw5c8ypXtNOIthNsGdtNrwsAhicnjr2xgTUvXy
         GZHh0unsuTCDrPXuRiH65pXSDpyZKC+SBo4mmAhe7yQdTdj/7AsAQF8MzWGWnVKlRE2l
         5vTrIze6E6sM4COqp/sVN4rY4u7MUVeiAiymsAFIYrztp0d4yDKAhSuSSF7wX9XEQCKe
         2wgT8q0At7/O1iXv2I4zrsF5uUUGYfHG1WK3MZGv2+6s+zmU7MRDqFRD2BiwUmDHuIKa
         qv8w==
X-Gm-Message-State: AOAM532KH7e6oBglq4ePJHWjDtCL6GVm+7+GuuOBF9l/gusz1LKN86MO
        AWDPdOyywM28jvXZ8Fd00aQRoQ==
X-Google-Smtp-Source: ABdhPJxxwGeG1O5E0Anm43GJTDpLz12UJcSkcvRqtypeoD3MuHBX4hcqFxdTZe4Lp35C2FjyXOZ1ig==
X-Received: by 2002:adf:f990:: with SMTP id f16mr7687812wrr.311.1591859621441;
        Thu, 11 Jun 2020 00:13:41 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:e8f7:125b:61e9:733d])
        by smtp.gmail.com with ESMTPSA id k21sm3587072wrd.24.2020.06.11.00.13.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2020 00:13:40 -0700 (PDT)
Date:   Thu, 11 Jun 2020 09:13:40 +0200
From:   Matthias Maennich <maennich@google.com>
To:     Maria Teguiani <teguiani@google.com>
Cc:     stable@vger.kernel.org, kernel-team@android.com,
        Fangrui Song <maskray@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Kees Cook <keescook@chromium.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] bpf: Support llvm-objcopy for vmlinux BTF
Message-ID: <20200611071340.GA215455@google.com>
References: <20200608133959.97810-1-teguiani@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200608133959.97810-1-teguiani@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 08, 2020 at 01:39:59PM +0000, Android Kernel Team wrote:
>From: Fangrui Song <maskray@google.com>
>
>Simplify gen_btf logic to make it work with llvm-objcopy. The existing
>'file format' and 'architecture' parsing logic is brittle and does not
>work with llvm-objcopy/llvm-objdump.
>
>'file format' output of llvm-objdump>=11 will match GNU objdump, but
>'architecture' (bfdarch) may not.
>
>.BTF in .tmp_vmlinux.btf is non-SHF_ALLOC. Add the SHF_ALLOC flag
>because it is part of vmlinux image used for introspection. C code
>can reference the section via linker script defined __start_BTF and
>__stop_BTF. This fixes a small problem that previous .BTF had the
>SHF_WRITE flag (objcopy -I binary -O elf* synthesized .data).
>
>Additionally, `objcopy -I binary` synthesized symbols
>_binary__btf_vmlinux_bin_start and _binary__btf_vmlinux_bin_stop (not
>used elsewhere) are replaced with more commonplace __start_BTF and
>__stop_BTF.
>
>Add 2>/dev/null because GNU objcopy (but not llvm-objcopy) warns
>"empty loadable segment detected at vaddr=0xffffffff81000000, is this intentional?"
>
>We use a dd command to change the e_type field in the ELF header from
>ET_EXEC to ET_REL so that lld will accept .btf.vmlinux.bin.o.  Accepting
>ET_EXEC as an input file is an extremely rare GNU ld feature that lld
>does not intend to support, because this is error-prone.
>
>The output section description .BTF in include/asm-generic/vmlinux.lds.h
>avoids potential subtle orphan section placement issues and suppresses
>--orphan-handling=warn warnings.
>
>Fixes: df786c9b9476 ("bpf: Force .BTF section start to zero when dumping from vmlinux")
>Fixes: cb0cc635c7a9 ("powerpc: Include .BTF section")
>Reported-by: Nathan Chancellor <natechancellor@gmail.com>
>Signed-off-by: Fangrui Song <maskray@google.com>
>Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
>Tested-by: Stanislav Fomichev <sdf@google.com>
>Tested-by: Andrii Nakryiko <andriin@fb.com>
>Reviewed-by: Stanislav Fomichev <sdf@google.com>
>Reviewed-by: Kees Cook <keescook@chromium.org>
>Acked-by: Andrii Nakryiko <andriin@fb.com>
>Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
>Link: https://github.com/ClangBuiltLinux/linux/issues/871
>Link: https://lore.kernel.org/bpf/20200318222746.173648-1-maskray@google.com
>(cherry picked from commit 90ceddcb495008ac8ba7a3dce297841efcd7d584)
>Cc: <stable@vger.kernel.org> # 5.4.x
>Signed-off-by: Maria Teguiani <teguiani@google.com>

Tested-by: Matthias Maennich <maennich@google.com>

Cheers,
Matthias

>---
> arch/powerpc/kernel/vmlinux.lds.S |  6 ------
> include/asm-generic/vmlinux.lds.h | 22 +++++++++++++++++++---
> kernel/bpf/sysfs_btf.c            | 11 +++++------
> scripts/link-vmlinux.sh           | 24 ++++++++++--------------
> 4 files changed, 34 insertions(+), 29 deletions(-)
>
>diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
>index 4638d2863388..060a1acd7c6d 100644
>--- a/arch/powerpc/kernel/vmlinux.lds.S
>+++ b/arch/powerpc/kernel/vmlinux.lds.S
>@@ -326,12 +326,6 @@ SECTIONS
> 		*(.branch_lt)
> 	}
>
>-#ifdef CONFIG_DEBUG_INFO_BTF
>-	.BTF : AT(ADDR(.BTF) - LOAD_OFFSET) {
>-		*(.BTF)
>-	}
>-#endif
>-
> 	.opd : AT(ADDR(.opd) - LOAD_OFFSET) {
> 		__start_opd = .;
> 		KEEP(*(.opd))
>diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
>index dae64600ccbf..b6d7347ccda7 100644
>--- a/include/asm-generic/vmlinux.lds.h
>+++ b/include/asm-generic/vmlinux.lds.h
>@@ -496,10 +496,12 @@
> 		__start___modver = .;					\
> 		KEEP(*(__modver))					\
> 		__stop___modver = .;					\
>-		. = ALIGN((align));					\
>-		__end_rodata = .;					\
> 	}								\
>-	. = ALIGN((align));
>+									\
>+	BTF								\
>+									\
>+	. = ALIGN((align));						\
>+	__end_rodata = .;
>
> /* RODATA & RO_DATA provided for backward compatibility.
>  * All archs are supposed to use RO_DATA() */
>@@ -588,6 +590,20 @@
> 		__stop___ex_table = .;					\
> 	}
>
>+/*
>+ * .BTF
>+ */
>+#ifdef CONFIG_DEBUG_INFO_BTF
>+#define BTF								\
>+	.BTF : AT(ADDR(.BTF) - LOAD_OFFSET) {				\
>+		__start_BTF = .;					\
>+		*(.BTF)							\
>+		__stop_BTF = .;						\
>+	}
>+#else
>+#define BTF
>+#endif
>+
> /*
>  * Init task
>  */
>diff --git a/kernel/bpf/sysfs_btf.c b/kernel/bpf/sysfs_btf.c
>index 7ae5dddd1fe6..3b495773de5a 100644
>--- a/kernel/bpf/sysfs_btf.c
>+++ b/kernel/bpf/sysfs_btf.c
>@@ -9,15 +9,15 @@
> #include <linux/sysfs.h>
>
> /* See scripts/link-vmlinux.sh, gen_btf() func for details */
>-extern char __weak _binary__btf_vmlinux_bin_start[];
>-extern char __weak _binary__btf_vmlinux_bin_end[];
>+extern char __weak __start_BTF[];
>+extern char __weak __stop_BTF[];
>
> static ssize_t
> btf_vmlinux_read(struct file *file, struct kobject *kobj,
> 		 struct bin_attribute *bin_attr,
> 		 char *buf, loff_t off, size_t len)
> {
>-	memcpy(buf, _binary__btf_vmlinux_bin_start + off, len);
>+	memcpy(buf, __start_BTF + off, len);
> 	return len;
> }
>
>@@ -30,15 +30,14 @@ static struct kobject *btf_kobj;
>
> static int __init btf_vmlinux_init(void)
> {
>-	if (!_binary__btf_vmlinux_bin_start)
>+	if (!__start_BTF)
> 		return 0;
>
> 	btf_kobj = kobject_create_and_add("btf", kernel_kobj);
> 	if (!btf_kobj)
> 		return -ENOMEM;
>
>-	bin_attr_btf_vmlinux.size = _binary__btf_vmlinux_bin_end -
>-				    _binary__btf_vmlinux_bin_start;
>+	bin_attr_btf_vmlinux.size = __stop_BTF - __start_BTF;
>
> 	return sysfs_create_bin_file(btf_kobj, &bin_attr_btf_vmlinux);
> }
>diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
>index aa1386079f0c..8b6325c2dfc5 100755
>--- a/scripts/link-vmlinux.sh
>+++ b/scripts/link-vmlinux.sh
>@@ -113,9 +113,6 @@ vmlinux_link()
> gen_btf()
> {
> 	local pahole_ver
>-	local bin_arch
>-	local bin_format
>-	local bin_file
>
> 	if ! [ -x "$(command -v ${PAHOLE})" ]; then
> 		echo >&2 "BTF: ${1}: pahole (${PAHOLE}) is not available"
>@@ -133,17 +130,16 @@ gen_btf()
> 	info "BTF" ${2}
> 	LLVM_OBJCOPY=${OBJCOPY} ${PAHOLE} -J ${1}
>
>-	# dump .BTF section into raw binary file to link with final vmlinux
>-	bin_arch=$(LANG=C ${OBJDUMP} -f ${1} | grep architecture | \
>-		cut -d, -f1 | cut -d' ' -f2)
>-	bin_format=$(LANG=C ${OBJDUMP} -f ${1} | grep 'file format' | \
>-		awk '{print $4}')
>-	bin_file=.btf.vmlinux.bin
>-	${OBJCOPY} --change-section-address .BTF=0 \
>-		--set-section-flags .BTF=alloc -O binary \
>-		--only-section=.BTF ${1} $bin_file
>-	${OBJCOPY} -I binary -O ${bin_format} -B ${bin_arch} \
>-		--rename-section .data=.BTF $bin_file ${2}
>+	# Create ${2} which contains just .BTF section but no symbols. Add
>+	# SHF_ALLOC because .BTF will be part of the vmlinux image. --strip-all
>+	# deletes all symbols including __start_BTF and __stop_BTF, which will
>+	# be redefined in the linker script. Add 2>/dev/null to suppress GNU
>+	# objcopy warnings: "empty loadable segment detected at ..."
>+	${OBJCOPY} --only-section=.BTF --set-section-flags .BTF=alloc,readonly \
>+		--strip-all ${1} ${2} 2>/dev/null
>+	# Change e_type to ET_REL so that it can be used to link final vmlinux.
>+	# Unlike GNU ld, lld does not allow an ET_EXEC input.
>+	printf '\1' | dd of=${2} conv=notrunc bs=1 seek=16 status=none
> }
>
> # Create ${2} .o file with all symbols from the ${1} object file
>-- 
>2.27.0.278.ge193c7cf3a9-goog
>
>-- 
>To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>
