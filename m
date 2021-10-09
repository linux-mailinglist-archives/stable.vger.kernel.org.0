Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533DF427B5D
	for <lists+stable@lfdr.de>; Sat,  9 Oct 2021 17:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234655AbhJIPfp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Oct 2021 11:35:45 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:59311 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234106AbhJIPfo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Oct 2021 11:35:44 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailnew.nyi.internal (Postfix) with ESMTP id 4EE6A5805BB;
        Sat,  9 Oct 2021 11:33:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sat, 09 Oct 2021 11:33:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=CjqZFjsf0wtrLRmkm2rIEEPKiPR
        3fFKC9K6unVkxDow=; b=VmQHa6bp6nJuIXkPw+PjgzxqNOBppvCN2dEOy8Inysd
        VgYBQlB4/NHAL40Shv9ltyrDzxBboKs6B5T9Mk7Rv0T0GIS0Fou9Br5V8bjyRc3d
        EHOek0wwLpJeadNe4XrI2VVVEABtMG1Qu40GvSCizguVJk3sCtk7ScTt4DqEe6RP
        VDW0wsITg/G88g1/JY6QBi2mqOYWwFsVAKokSToleoiDJtGDux1BpdqCHjFIJ19b
        ohNr4X8XcyPR7NNaJEcQILF+T60NALlp8xkDqkmvJuUhksuuBNDPCXatl6hzPbIx
        7yL8uvOy2IOzXXWlMpmtL/vRQgw2jCtKbOR4VgxCiiA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=CjqZFj
        sf0wtrLRmkm2rIEEPKiPR3fFKC9K6unVkxDow=; b=nzMs6NFcEowRqNoE+YLfbd
        G84lJ2BUeQPHefZMd7VZD9tdJug2QyR3+GNNGB6+DrmHp/vzQUg/PavWSj2Gycp3
        mNUCFabmVUKXXW6ICX8Xf/2zotMsob23bURL8dfaN8VqBGLpmJMaEsuvq5Wg4a6G
        rutcwjC4bfSQE4ck8Hsn8U6CCAzulESEi/eTI36m1gjnL9h58Sera56boN5fLoLM
        AEhrRqxbDNtIgPImc34PuSJ9eThLJWTwspV2yLq+E1XNiJatu70Mw+1oaAvWCUob
        dD3U8l+9ds2fEh7ZbKlQVymUwfGw6XhyfATvQI9IkSrgFPAVit7qv3RUrzmKYvTQ
        ==
X-ME-Sender: <xms:WrZhYUYBgL3GuIcGZVBTL7ZThuwscEUjTDw90BBC49CEust83bDzpA>
    <xme:WrZhYfaKI9labgKXjh2cbDPK-KfnsN0asTAinBrI_ILCBanTYgl5_wBNqwEDhMJsZ
    whsGVReReOqIA>
X-ME-Received: <xmr:WrZhYe-GI8nMsaZ2jYJvtBSUzL7aCPfCQU2omKeSf9LccrzT7x_wjmsOlZ_HDCVUkbxiHJuTr53NqOD7nRiWRChj3N1BhzoA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddtvddgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:WrZhYeqZknp4d2r7aV9BZxso9Fdhi2_gYnlpxQy6G7kINb8O1VkNYg>
    <xmx:WrZhYfqIr_KQDyysZa56BLWhDgj7Q4MvAxKSxid5QPXOKpLyUA30Pg>
    <xmx:WrZhYcSKLJ3ONeLzN8lVTdFRbugQXRBNQytf90SwYlhASuAIiiaL5A>
    <xmx:W7ZhYchNUl9EU-6jBkoFdRqFrgRdMvscC2OE7CTkqE32Y_GQe3aFeQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 9 Oct 2021 11:33:46 -0400 (EDT)
Date:   Sat, 9 Oct 2021 17:33:44 +0200
From:   Greg KH <greg@kroah.com>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org, piotras@gmail.com, paulburton@kernel.org,
        daniel@iogearbox.net, johan.almbladh@anyfinetworks.com
Subject: Re: [PATCH 5.4 0/2] bpf, mips: fix CVE-2021-38300
Message-ID: <YWG2WPGdH9jGU1zz@kroah.com>
References: <20211008135059.1114363-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211008135059.1114363-1-ovidiu.panait@windriver.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 08, 2021 at 04:50:57PM +0300, Ovidiu Panait wrote:
> 5.2 upstream commit 716850ab104d ("MIPS: eBPF: Initial eBPF support for MIPS32
> architecture.") introduced eBPF JIT support for MIPS32 and removed the cBPF JIT
> interface. However, it was subsequently reverted by the following commits,
> bringing back the old cBPF JIT implementation:
>     f8fffebdea75 ("MIPS: BPF: Disable MIPS32 eBPF JIT")
>     36366e367ee9 ("MIPS: BPF: Restore MIPS32 cBPF JIT")
> 
>     From 36366e367ee9 ("MIPS: BPF: Restore MIPS32 cBPF JIT") commit message:
>     """
>     ...
>     Until these problems are resolved, revert the removal of the cBPF JIT
>     performed by commit 716850ab104d ("MIPS: eBPF: Initial eBPF support for
>     MIPS32 architecture."). Together with commit f8fffebdea75 ("MIPS: BPF:
>     Disable MIPS32 eBPF JIT") this restores MIPS32 BPF JIT behavior back to
>     the same state it was prior to the introduction of the broken eBPF JIT
>     support.
>     """
> 
> In 5.4, only f8fffebdea75 ("MIPS: BPF: Disable MIPS32 eBPF JIT") was
> backported. This patchseries re-enables cBPF JIT support by backporting the
> second part of 16850ab104d ("MIPS: eBPF: Initial eBPF support for MIPS32
> architecture.") revert and also fixes CVE-2021-38300. Both patches are clean
> cherry-picks.
> 
> The testcase specified in 37cb28ec7d3a ("bpf, mips: Validate conditional
> branch offsets") commit message now passes in qemu:
> 
> Before:
> -------
> root@qemumips:~# echo 1 > /proc/sys/net/core/bpf_jit_enable
> root@qemumips:~# modprobe test_bpf test_name="BPF_MAXINSNS: exec all MSH"
> [   58.577385] test_bpf: #296 BPF_MAXINSNS: exec all MSH 
> [   58.579267] ------------[ cut here ]------------
> [   58.603827] WARNING: CPU: 0 PID: 166 at arch/mips/mm/uasm-mips.c:210 build_insn+0x4e8/0x520
> [   58.605354] Micro-assembler field overflow
> [   58.606585] Modules linked in: test_bpf(+) i2c_piix4 sch_fq_codel openvswitch nsh nf_conncount nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4
> [   58.608979] CPU: 0 PID: 166 Comm: modprobe Not tainted 5.4.151-yocto-standard+ #3
> [   58.610838] Stack : 00000000 00000000 0000010e 1000a400 80f90000 00000045 0000010f 801978cc
> [   58.612647]         80c40000 0000000b 00000000 00000000 80e051d8 1000a400 8d119950 ffffffff
> [   58.615304]         00000000 00000000 81030000 0000010f 00000000 00000000 00000000 0000ffff
> [   58.617685]         00000000 00000000 00000001 0000010f 00000000 80e60000 00000000 80000000
> [   58.618968]         8d119a8c 00000000 80130000 c0064000 00000000 807742f4 00000001 003871d7
> [   58.620309]         ...
> [   58.621313] Call Trace:
> [   58.622310] [<8010e748>] show_stack+0xb4/0x17c
> [   58.623612] [<80b90cbc>] dump_stack+0xa0/0xcc
> [   58.624755] [<80134a90>] __warn+0xcc/0x11c
> [   58.626008] [<80b85ec0>] warn_slowpath_fmt+0x8c/0xb8
> [   58.629175] [<80121a18>] build_insn+0x4e8/0x520
> [   58.630225] [<80121ba4>] uasm_i_bne+0x1c/0x28
> [   58.687860] [<8012d3a4>] build_body+0x6b8/0x2f38
> [   58.740612] [<8012fd38>] bpf_jit_compile+0x114/0x1e4
> [   58.793484] [<809cb584>] bpf_prepare_filter+0x2b0/0x464
> [   58.843345] [<809cb7b8>] bpf_prog_create+0x80/0xc0
> [   58.894788] [<c00572d8>] test_bpf_init+0x2d8/0xcf8 [test_bpf]
> [   58.946096] [<80100e50>] do_one_initcall+0x54/0x2c4
> [   58.992934] [<801d9850>] do_init_module+0x64/0x240
> [   59.042867] [<801dbc84>] load_module+0x2180/0x27fc
> [   59.093033] [<801dc568>] sys_finit_module+0xe8/0x100
> [   59.142974] [<80117304>] syscall_common+0x34/0x58
> [   59.823417] ---[ end trace af3af640ae837a28 ]---
> 
> After:
> ------
> root@qemumips:~# echo 1 > /proc/sys/net/core/bpf_jit_enable
> root@qemumips:~# modprobe test_bpf test_name="BPF_MAXINSNS: exec all MSH"
> [  215.882154] test_bpf: #296 BPF_MAXINSNS: exec all MSH jited:0 667558 PASS
> [  216.618220] test_bpf: Summary: 1 PASSED, 0 FAILED, [0/1 JIT'ed]
> 
> Paul Burton (1):
>   MIPS: BPF: Restore MIPS32 cBPF JIT
> 
> Piotr Krysiuk (1):
>   bpf, mips: Validate conditional branch offsets
> 
>  arch/mips/Kconfig           |    1 +
>  arch/mips/net/Makefile      |    1 +
>  arch/mips/net/bpf_jit.c     | 1299 +++++++++++++++++++++++++++++++++++
>  arch/mips/net/bpf_jit_asm.S |  285 ++++++++
>  4 files changed, 1586 insertions(+)
>  create mode 100644 arch/mips/net/bpf_jit.c
>  create mode 100644 arch/mips/net/bpf_jit_asm.S

All now queued up, thanks.

greg k-h
