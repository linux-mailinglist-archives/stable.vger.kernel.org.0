Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B47FB1F65F4
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 12:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgFKKwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 06:52:09 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:57717 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726995AbgFKKwH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jun 2020 06:52:07 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id CAC3E5C00DE;
        Thu, 11 Jun 2020 06:52:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 11 Jun 2020 06:52:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=hFixsBB4fRrJtbpr+200c7FS6ZE
        e/kugxM+bJ6/yTEI=; b=pLtP1EiekFwYm9vY0vAivtJgw1XrxlQhbVht+6Ek/p+
        WINXG4E+6fOy8P2due999w/VaU+zk/hwlGkCraJfE6LppM/TBeyjHfr8NyAtLNyj
        QfJCeA0QI9YrUSIzO4yUwoIDPgbySKgZ2zp9ivlcUlVcidQvoyXm17tzpmCCzA7q
        l69e6fANcyxVBWdArt1srhkALoIo4v/qI9YBhFbAVzezreSV05h57/RHeWgJRP1A
        1bREtGWilzVx2oJENiymuW1vn5BjgE6asV7/SrkxyEOkl7xT//6mCpciBXJnNxl1
        uyttuslyJt5MGgksfb0kV31TTk8QwKILCM4Osj/GaAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=hFixsB
        B4fRrJtbpr+200c7FS6ZEe/kugxM+bJ6/yTEI=; b=FXcdkL6gyxwQUehM5dPZM/
        puFxW4inLc2P144enkJ3gYITiObP3bn30XyKlSymhHOdceB3+kXObdBHwBQAqNNE
        z+3iJvwtbzhExI6q0o2xLQNNifXoa9IvGe2a0wJ2E7dHV+scAid+JOa7luK6p0il
        a8KtOEkw62g6xVRljjqjMmn9yYptAUrdfBXoOYBD7PxpdFopsa5N0vHdaUr7CiJ6
        23RXZcuYXVEcGPMTofdbmi4Y7Mu0XtbjgYmX3sCqD/iiEDxB1MM1WwEoiX0yMBbm
        cvuAd38zOVtnI+/7OYC/ME2VqAU7O7qABfyKXVclS5LzGMAAz1uemRFw3no+lMgw
        ==
X-ME-Sender: <xms:1QziXj7qXj4YD-ZkEnaeSraU1D0GoM6GUP2nuZNi45whjKGzckQSNg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudehledgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpefhuedtfe
    ffgeefueevvdfgfeekudefleduveetfeehjedtkefhffejuddvveehfeenucffohhmrghi
    nhepghhithhhuhgsrdgtohhmpdhkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrke
    elrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhho
    mhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:1QziXo6M-9G8hm0pbqLcc4HFFUsag3sEACpyoZQAtUIg8NXdlbpOvw>
    <xmx:1QziXqfEqhbSXnWXlUEqEpcv2RTTJUSf1hBpQDOH8rRsvrdCnf4WYQ>
    <xmx:1QziXkIxO3SwfUA19JuCJZOB82OI8dt48v1vAwbzYgYQkq83AZM-WA>
    <xmx:1gziXv9ac6MOnCcR-Eg_KXQsY8DiUTdxiEpFmPVdkOX0v_NyHMqXGQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 556C4328005E;
        Thu, 11 Jun 2020 06:52:05 -0400 (EDT)
Date:   Thu, 11 Jun 2020 12:51:58 +0200
From:   Greg KH <greg@kroah.com>
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
Message-ID: <20200611105158.GA3802953@kroah.com>
References: <20200608133959.97810-1-teguiani@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608133959.97810-1-teguiani@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 08, 2020 at 01:39:59PM +0000, Maria Teguiani wrote:
> From: Fangrui Song <maskray@google.com>
> 
> Simplify gen_btf logic to make it work with llvm-objcopy. The existing
> 'file format' and 'architecture' parsing logic is brittle and does not
> work with llvm-objcopy/llvm-objdump.
> 
> 'file format' output of llvm-objdump>=11 will match GNU objdump, but
> 'architecture' (bfdarch) may not.
> 
> .BTF in .tmp_vmlinux.btf is non-SHF_ALLOC. Add the SHF_ALLOC flag
> because it is part of vmlinux image used for introspection. C code
> can reference the section via linker script defined __start_BTF and
> __stop_BTF. This fixes a small problem that previous .BTF had the
> SHF_WRITE flag (objcopy -I binary -O elf* synthesized .data).
> 
> Additionally, `objcopy -I binary` synthesized symbols
> _binary__btf_vmlinux_bin_start and _binary__btf_vmlinux_bin_stop (not
> used elsewhere) are replaced with more commonplace __start_BTF and
> __stop_BTF.
> 
> Add 2>/dev/null because GNU objcopy (but not llvm-objcopy) warns
> "empty loadable segment detected at vaddr=0xffffffff81000000, is this intentional?"
> 
> We use a dd command to change the e_type field in the ELF header from
> ET_EXEC to ET_REL so that lld will accept .btf.vmlinux.bin.o.  Accepting
> ET_EXEC as an input file is an extremely rare GNU ld feature that lld
> does not intend to support, because this is error-prone.
> 
> The output section description .BTF in include/asm-generic/vmlinux.lds.h
> avoids potential subtle orphan section placement issues and suppresses
> --orphan-handling=warn warnings.
> 
> Fixes: df786c9b9476 ("bpf: Force .BTF section start to zero when dumping from vmlinux")
> Fixes: cb0cc635c7a9 ("powerpc: Include .BTF section")
> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> Signed-off-by: Fangrui Song <maskray@google.com>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Tested-by: Stanislav Fomichev <sdf@google.com>
> Tested-by: Andrii Nakryiko <andriin@fb.com>
> Reviewed-by: Stanislav Fomichev <sdf@google.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
> Link: https://github.com/ClangBuiltLinux/linux/issues/871
> Link: https://lore.kernel.org/bpf/20200318222746.173648-1-maskray@google.com
> (cherry picked from commit 90ceddcb495008ac8ba7a3dce297841efcd7d584)
> Cc: <stable@vger.kernel.org> # 5.4.x
> Signed-off-by: Maria Teguiani <teguiani@google.com>

I've also queued this up to the 5.6.y tree, thanks.

greg k-h
