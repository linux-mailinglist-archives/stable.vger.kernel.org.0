Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAD06573660
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 14:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbiGMM2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 08:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236428AbiGMM2C (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 08:28:02 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC31105E2C
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 05:26:57 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id ss3so13530421ejc.11
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 05:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=lc+/M1BplS7r5Zj+3T5uoCd5ifjV5GydvuEMJY/U8Ng=;
        b=EP/9l8JBHNJ2a91VA+XUUnIsIVObGqqjVcX3TLW9DKqiSFD57FuP9KMKhL1I7hmPPk
         5NXsqxtSxvlOL2y51KglLTq/7fkwT4B+lY+sB8uHENGDp77aCtZ7qXQAwmmU08AFxcRe
         bGGAdOOO8+l364149JEJuNz8tMSlzYShlBzavXnC3Ke85S5fwnPS2mtDiIKMFqVvcrff
         DI+rs/DKyBYHOjQsU/gJWguiuo1EYMu8rEufwRbsYNCgJm66n5zQbgl/L6I4xBgL/7eZ
         kGmNVV08EOPz0dqfjHglRKEdFn896wWdlFg3EnipLx/HfXMUYvGpZlnJ20pKkVQ3Y0ri
         Z3tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=lc+/M1BplS7r5Zj+3T5uoCd5ifjV5GydvuEMJY/U8Ng=;
        b=SN+Kc1Y74bOZif8mk8eTJ90QRE+wWeaj5DDMzepeAr5fzGq++LB9RCw7sAqy+rvkJ1
         C59WFH3wjsRLzIDCxch4IlMDkrg3Y7tkVpDryA7YrGkgs1Yzvw+d/Y5Tj04U0vxR3Qz1
         PWIT3IUU2EfC7Wt97HcJwWBsp7B2/pKTP19SH+4NIWbr/qOmrMvUPsn2rhbXIlUzmfwi
         az+Rk8Uz5Fpecq5r8lDS0y+7fv3vUuoeuzsZvggYYJ0aaVofQAaOTX+VJelf1lNRPZen
         vmKQDz7KLWDi2u/nHYuNGXVXVwg6EyhVQfM47z26rBV3RAh/BdlJnVal9QOvTO9huVNk
         wLsg==
X-Gm-Message-State: AJIora/cf+5/uoAibkkGz+RGLXDKjh+h9FSDEAUHOkXCFRa3vFcSTfaR
        4yjqxs2XhSYTsFz300UjcBbK/EgILFDObF5BQ9OO7RKRaCgj5w==
X-Google-Smtp-Source: AGRyM1vUJ8BBGJtoqJUvu1Qll4rrSIwnPwQDvBfjummKCcTYA+FgMwvwBfzsP6M9cqAG80fTccGWosqm4JeWhnTfqQY=
X-Received: by 2002:a17:907:7ea6:b0:72b:4afb:e8b with SMTP id
 qb38-20020a1709077ea600b0072b4afb0e8bmr3229192ejc.205.1657715215103; Wed, 13
 Jul 2022 05:26:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAMGffEm9y0wnn8LNS9Qo3obPhs0GD5iJZ0WejFzC4baGPDsYTw@mail.gmail.com>
In-Reply-To: <CAMGffEm9y0wnn8LNS9Qo3obPhs0GD5iJZ0WejFzC4baGPDsYTw@mail.gmail.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Wed, 13 Jul 2022 14:26:44 +0200
Message-ID: <CAMGffEnTobhKvwKcRTnSz1JgNBVeTTtbOvP2OtAMgceqOOhN4A@mail.gmail.com>
Subject: Re: 5.10.131-rc1 crash with int3: RIP 0010:xaddw_ax_dx+0x9/0x10 [kvm]
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 13, 2022 at 12:49 PM Jinpu Wang <jinpu.wang@ionos.com> wrote:
>
> Hi, all,
>
> When I test with 5.10.131-rc1 with kvm-uint-tests on Intel Broadwell
> and Skylake server, it panic also immediately with following call
> trace:
>
> [ 1867.769328] APIC base relocation is unsupported by KVM
> [ 1895.977424] kvm: emulating exchange as write
> [ 1895.979316] int3: 0000 [#1] SMP
> [ 1895.979317] CPU: 40 PID: 14811 Comm: qemu-6.1 Kdump: loaded
> Tainted: G           O      5.10.131-pserver
> #5.10.131-1+feature+linux+5.10.y+20220712.1850+30f4172c~deb11
> [ 1895.979317] Hardware name: Supermicro SBI-7228R-T2F2/B10DRT-IBF2,
> BIOS 3.0a 03/05/2018
> [ 1895.979318] RIP: 0010:xaddw_ax_dx+0x9/0x10 [kvm]
> [ 1895.979318] Code: 00 0f bb d0 c3 cc cc cc cc 48 0f bb d0 c3 cc cc
> cc cc 0f 1f 80 00 00 00 00 0f c0 d0 c3 cc cc cc cc 66 0f c1 d0 c3 cc
> cc cc cc <0f> 1f 80 00 00 00 00 0f c1 d0 c3 cc cc cc cc 48 0f c1 d0 c3
> cc cc
> [ 1895.979319] RSP: 0018:ffffab6e63c6fd30 EFLAGS: 00000202
> [ 1895.979320] RAX: 0000000089abcdef RBX: 0000000000000001 RCX: 0000000000000000
> [ 1895.979321] RDX: 0000000076543210 RSI: ffffffffc0f3e4a0 RDI: 0000000000000200
> [ 1895.979321] RBP: ffff997c29c214e0 R08: ffff997c29c214e0 R09: 0000000000000002
> [ 1895.979321] R10: 0000000000000001 R11: 0000000000000000 R12: ffffffffc0f73540
> [ 1895.979322] R13: 0000000000000000 R14: ffff997c29c214e0 R15: 0000000000000000
> [ 1895.979322] FS:  00007fc44a5a3700(0000) GS:ffff999a7fc80000(0000)
> knlGS:0000000000000000
> [ 1895.979322] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1895.979323] CR2: 0000000000000000 CR3: 000000012bf16004 CR4: 00000000003726e0
> [ 1895.979324] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 1895.979324] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [ 1895.979325] Call Trace:
> [ 1895.979325]  ? fastop+0x59/0xa0 [kvm]
> [ 1895.979326]  ? x86_emulate_insn+0x73a/0xe00 [kvm]
> [ 1895.979326]  ? x86_emulate_instruction+0x2d0/0x750 [kvm]
> [ 1895.979326]  ? vmx_vcpu_load+0x21/0x70 [kvm_intel]
> [ 1895.979327]  ? complete_emulated_mmio+0x236/0x310 [kvm]
> [ 1895.979327]  ? kvm_arch_vcpu_ioctl_run+0x1744/0x1920 [kvm]
> [ 1895.979327]  ? kvm_vcpu_ioctl+0x211/0x5a0 [kvm]
> [ 1895.979328]  ? __fget_files+0x79/0xb0
> [ 1895.979328]  ? __fget_files+0x79/0xb0
> [ 1895.979328]  ? __x64_sys_ioctl+0x8b/0xc0
> [ 1895.979329]  ? do_syscall_64+0x33/0x40
> [ 1895.979329]  ? entry_SYSCALL_64_after_hwframe+0x61/0xc6
> [ 1895.979329] Modules linked in: nfnetlink_cttimeout nft_nat
> nft_counter nft_chain_nat nft_meta_bridge bridge openvswitch nsh
> nf_conncount nf_nat dummy nf_log_ipv6 nf_log_ipv4 nf_log_common
> nft_log nft_limit rnbd_client(O) intel_rapl_msr rtrs_client(O)
> intel_rapl_common rtrs_core(O) ib_ipoib rdma_ucm rdma_cm iw_cm ib_cm
> ib_umad sb_edac x86_pkg_temp_thermal coretemp kvm_intel mlx4_ib nft_ct
> kvm nf_conntrack ib_uverbs nf_defrag_ipv6 ib_core nf_defrag_ipv4
> irqbypass crc32_pclmul aesni_intel sd_mod libaes t10_pi crypto_simd
> crc_t10dif nf_tables crct10dif_generic cryptd glue_helper
> crct10dif_pclmul crct10dif_common vhost_net sg rapl intel_cstate
> nfnetlink tun(O) ethoip6_pmtud(O) vhost vhost_iotlb ahci tap iTCO_wdt
> libahci input_leds mei_me libata iTCO_vendor_support mlx4_core ioatdma
> scsi_mod led_class watchdog evdev acpi_ipmi mei ipmi_si 8021q garp stp
> mrp llc ipmi_devintf ipmi_msghandler acpi_power_meter acpi_pad button
> fuse ip_tables x_tables autofs4 loop raid10 raid456 async_raid6_recov
> [ 1895.979349]  async_memcpy async_pq async_xor async_tx xor raid6_pq
> libcrc32c raid1 raid0 linear md_mod crc32c_intel igb i2c_i801
> i2c_algo_bit i2c_smbus xhci_pci dca lpc_ich ptp i2c_core mfd_core
> pps_core xhci_hcd
>
> Is this bug known, any hint how to fix it?
I did more tests on different Servers, so far all the machine
checked(Skylake/Icelake/Haswell/Broadwell/EPYC) crash immediately
except AMD Opteron.
kvm-unit-tests succeeded without regression.


> Thanks!
> Jinpu Wang @ IONOS
