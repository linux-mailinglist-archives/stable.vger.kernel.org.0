Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 060EB4E3490
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 00:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232954AbiCUXjY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 19:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233114AbiCUXjV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 19:39:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9091054FBF
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 16:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647905871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uzBrE/xKFER9oTs4R1yQOb5Smm6sapxjMw0ldJAMeCY=;
        b=f1SKtT2F5UfMKC2bDQ029PVr9ykg63JI+KBzHTfxyCE6HZTcDIe2ehxMKnSiwb+vsrUh5L
        P6YIVshFDwlhJUT5hpXt6GtsVkc4HwwaGvEOymdWFCy2A+S0Ukzj9QrFuX5sC50WPoc7lq
        nZBHAgExBQ55fw1jOLeUzItrdjGYV4o=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-371-PR3nhyU5O3Oy62KOuoSGSA-1; Mon, 21 Mar 2022 19:37:50 -0400
X-MC-Unique: PR3nhyU5O3Oy62KOuoSGSA-1
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-2e5d456d198so91802327b3.23
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 16:37:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uzBrE/xKFER9oTs4R1yQOb5Smm6sapxjMw0ldJAMeCY=;
        b=0092CBKTHZejjVAfJiD5yil1zgEz1k8arI9aZNQoJQzCRvHsX1YbEpBbO/asLRqGng
         j3xW4ADTfYoTsk5SwoFb3r4xJam6/IyDlaryhxi9Qa2CTPDaA4ajqbBAlTRlfR290WNP
         llEidviOc+f90nEJQnIYVoezVQa210OWyrCSftxFXg0awOHHBrGZkmP9U5/WQ696NO38
         Sgtsboglex6V5/Ud0U7FjqRmiyVducU/Bl+bNqeGok+31fZRsjG+Dkj0D3khYBF+fdA4
         NA+nqXCyufTWhTZaHX33hr7SumvOM+LTqaJG3CwkXpToySd74L/RLvkYu0ohDmAET6kA
         MUdA==
X-Gm-Message-State: AOAM531u4PkhVgHnGZ2Y2c53CkdLtaxqMRQmH76mkgCT0DpHd888NeiK
        4eBY3ZOtfz7wEx9iAiksLK9z4HttLVl4RrwSE0MlHl4x1IkJbH2EshJ9BBOFmorGcpO+e8h+CzC
        NsO/49PLkOcTLRzN9Wwr1di2MpVWmUGIP
X-Received: by 2002:a81:5bc5:0:b0:2d6:5659:73c2 with SMTP id p188-20020a815bc5000000b002d6565973c2mr26915868ywb.121.1647905868546;
        Mon, 21 Mar 2022 16:37:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyZDeclsfrCetATc8VAEyW1jquLTzrNR9LFM3udw/x+j0o/Or8O7TRRVLhT5BZmuQvKh/HJDxK24979jGo9y6w=
X-Received: by 2002:a81:5bc5:0:b0:2d6:5659:73c2 with SMTP id
 p188-20020a815bc5000000b002d6565973c2mr26915853ywb.121.1647905868276; Mon, 21
 Mar 2022 16:37:48 -0700 (PDT)
MIME-Version: 1.0
References: <CAE4VaGDZr_4wzRn2___eDYRtmdPaGGJdzu_LCSkJYuY9BEO3cw@mail.gmail.com>
In-Reply-To: <CAE4VaGDZr_4wzRn2___eDYRtmdPaGGJdzu_LCSkJYuY9BEO3cw@mail.gmail.com>
From:   Jirka Hladky <jhladky@redhat.com>
Date:   Tue, 22 Mar 2022 00:37:37 +0100
Message-ID: <CAE4VaGDKXnQJKdayeNsAD5RcqsKu5XG2UeweLvgZoFO-pn-t9Q@mail.gmail.com>
Subject: Re: PANIC: "Oops: 0000 [#1] PREEMPT SMP PTI" starting from 5.17 on
 dual socket Intel Xeon Gold servers
To:     stable@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Cc:     regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Cc: regressions@lists.linux.dev stable@vger.kernel.org

On Tue, Mar 22, 2022 at 12:29 AM Jirka Hladky <jhladky@redhat.com> wrote:
>
> Starting from kernel 5.17 (tested with rc2, rc4, rc7, rc8) we
> experience kernel oops on Intel Xeon Gold dual-socket servers (2x Xeon
> Gold 6126 CPU)
>
> Bellow is a backtrace and the dmesg log.
>
> I have trouble creating a simple reproducer - it happens at random
> places when preparing the NAS benchmark to be run. The script creates
> a bunch of directories, compiles the benchmark a start trial runs.
>
> Could you please help to narrow down the problem?
>
> Reports bellow were created with kernel 5.17 rc8 and with
> echo 1 > /proc/sys/kernel/panic_on_oops
> setting.
>
> crash> sys
>       KERNEL: /usr/lib/debug/lib/modules/5.17.0-0.rc8.123.fc37.x86_64/vmlinux
>     DUMPFILE: vmcore  [PARTIAL DUMP]
>         CPUS: 48
>         DATE: Thu Mar 17 02:49:40 CET 2022
>       UPTIME: 00:02:50
> LOAD AVERAGE: 0.32, 0.10, 0.03
>        TASKS: 608
>     NODENAME: gold-2s-c
>      RELEASE: 5.17.0-0.rc8.123.fc37.x86_64
>      VERSION: #1 SMP PREEMPT Mon Mar 14 18:11:49 UTC 2022
>      MACHINE: x86_64  (2600 Mhz)
>       MEMORY: 94.7 GB
>        PANIC: "Oops: 0000 [#1] PREEMPT SMP PTI" (check log for details)
>
>
> crash> bt
> PID: 2480   TASK: ffff9e8f76cb8000  CPU: 26  COMMAND: "umount"
> #0 [ffffae00cacbfbb8] machine_kexec at ffffffffbb068980
> #1 [ffffae00cacbfc08] __crash_kexec at ffffffffbb1a300a
> #2 [ffffae00cacbfcc8] crash_kexec at ffffffffbb1a4045
> #3 [ffffae00cacbfcd0] oops_end at ffffffffbb02c410
> #4 [ffffae00cacbfcf0] page_fault_oops at ffffffffbb076a38
> #5 [ffffae00cacbfd68] exc_page_fault at ffffffffbbd0b7c1
> #6 [ffffae00cacbfd90] asm_exc_page_fault at ffffffffbbe00ace
>    [exception RIP: kernfs_remove+7]
>    RIP: ffffffffbb421f67  RSP: ffffae00cacbfe48  RFLAGS: 00010246
>    RAX: 0000000000000001  RBX: ffffffffbce31e58  RCX: 0000000080200018
>    RDX: 0000000080200019  RSI: ffffdfbd44161640  RDI: 0000000000000000
>    RBP: ffffffffbce31e58   R8: 0000000000000000   R9: 0000000080200018
>    R10: ffff9e8f05859e80  R11: ffff9e9443b1bd98  R12: ffff9ea057f1d000
>    R13: ffffffffbce31e60  R14: dead000000000122  R15: dead000000000100
>    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
> #7 [ffffae00cacbfe58] rdt_kill_sb at ffffffffbb05074b
> #8 [ffffae00cacbfea8] deactivate_locked_super at ffffffffbb36ce1f
> #9 [ffffae00cacbfec0] cleanup_mnt at ffffffffbb39176e
> #10 [ffffae00cacbfee8] task_work_run at ffffffffbb10703c
> #11 [ffffae00cacbff08] exit_to_user_mode_prepare at ffffffffbb17a399
> #12 [ffffae00cacbff28] syscall_exit_to_user_mode at ffffffffbbd0bde8
> #13 [ffffae00cacbff38] do_syscall_64 at ffffffffbbd071a6
> #14 [ffffae00cacbff50] entry_SYSCALL_64_after_hwframe at ffffffffbbe0007c
>    RIP: 00007f442c75126b  RSP: 00007ffc82d66fe8  RFLAGS: 00000202
>    RAX: 0000000000000000  RBX: 000055bd4cc37090  RCX: 00007f442c75126b
>    RDX: 0000000000000001  RSI: 0000000000000001  RDI: 000055bd4cc3b950
>    RBP: 000055bd4cc371a8   R8: 0000000000000000   R9: 0000000000000073
>    R10: 0000000000000000  R11: 0000000000000202  R12: 0000000000000001
>    R13: 000055bd4cc3b950  R14: 000055bd4cc372c0  R15: 000055bd4cc37090
>    ORIG_RAX: 00000000000000a6  CS: 0033  SS: 002b
>
> [2] dmesg
> [  172.776553] BUG: kernel NULL pointer dereference, address: 0000000000000008
> [  172.783513] #PF: supervisor read access in kernel mode
> [  172.788652] #PF: error_code(0x0000) - not-present page
> [  172.793793] PGD 0 P4D 0
> [  172.796330] Oops: 0000 [#1] PREEMPT SMP PTI
> [  172.800519] CPU: 26 PID: 2480 Comm: umount Kdump: loaded Not
> tainted 5.17.0-0.rc8.123.fc37.x86_64 #1
> [  172.809645] Hardware name: Supermicro Super Server/X11DDW-L, BIOS
> 2.0b 03/07/2018
> [  172.817123] RIP: 0010:kernfs_remove+0x7/0x50
> [  172.821397] Code: e8 be e7 2c 00 48 89 df e8 b6 8c f0 ff 48 c7 c3
> f4 ff ff ff 48 89 d8 5b 5d 41 5c 41 5d 41 5e c3 cc 66 90 0f 1f 44 00
> 00 55 53 <48> 8b 47 08 48 89 fb 48 85 c0 48 0f 44 c7 48 8b 68 50 48 83
> c5 60
> [  172.840141] RSP: 0018:ffffae00cacbfe48 EFLAGS: 00010246
> [  172.845367] RAX: 0000000000000001 RBX: ffffffffbce31e58 RCX: 0000000080200018
> [  172.852501] RDX: 0000000080200019 RSI: ffffdfbd44161640 RDI: 0000000000000000
> [  172.859632] RBP: ffffffffbce31e58 R08: 0000000000000000 R09: 0000000080200018
> [  172.866764] R10: ffff9e8f05859e80 R11: ffff9e9443b1bd98 R12: ffff9ea057f1d000
> [  172.873899] R13: ffffffffbce31e60 R14: dead000000000122 R15: dead000000000100
> [  172.881033] FS:  00007f442c53c800(0000) GS:ffff9e9429000000(0000)
> knlGS:0000000000000000
> [  172.889117] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  172.894861] CR2: 0000000000000008 CR3: 000000010ba96006 CR4: 00000000007706e0
> [  172.901997] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  172.909127] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  172.916261] PKRU: 55555554
> [  172.918974] Call Trace:
> [  172.921427]  <TASK>
> [  172.923533]  rdt_kill_sb+0x29b/0x350
> [  172.927112]  deactivate_locked_super+0x2f/0xa0
> [  172.931559]  cleanup_mnt+0xee/0x180
> [  172.935051]  task_work_run+0x5c/0x90
> [  172.938629]  exit_to_user_mode_prepare+0x229/0x230
> [  172.943424]  syscall_exit_to_user_mode+0x18/0x40
> [  172.948043]  do_syscall_64+0x46/0x80
> [  172.951623]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  172.956675] RIP: 0033:0x7f442c75126b
> [  172.960271] Code: cb 1b 0e 00 f7 d8 64 89 01 48 83 c8 ff c3 90 f3
> 0f 1e fa 31 f6 e9 05 00 00 00 0f 1f 44 00 00 f3 0f 1e fa b8 a6 00 00
> 00 0f 05 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 91 1b 0e 00
> f7 d8
> [  172.979017] RSP: 002b:00007ffc82d66fe8 EFLAGS: 00000202 ORIG_RAX:
> 00000000000000a6
> [  172.986584] RAX: 0000000000000000 RBX: 000055bd4cc37090 RCX: 00007f442c75126b
> [  172.993715] RDX: 0000000000000001 RSI: 0000000000000001 RDI: 000055bd4cc3b950
> [  173.000849] RBP: 000055bd4cc371a8 R08: 0000000000000000 R09: 0000000000000073
> [  173.007980] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000001
> [  173.015115] R13: 000055bd4cc3b950 R14: 000055bd4cc372c0 R15: 000055bd4cc37090
> [  173.022249]  </TASK>
> [  173.024440] Modules linked in: rfkill intel_rapl_msr
> intel_rapl_common isst_if_common irdma skx_edac nfit libnvdimm ice
> x86_pkg_temp_thermal intel_powerclamp coretemp ib_uverbs iTCO_wdt
> intel_pmc_bxt ib_core iTCO_vendor_support kvm_
> intel ipmi_ssif kvm irqbypass rapl acpi_ipmi intel_cstate i40e joydev
> mei_me ioatdma i2c_i801 intel_uncore lpc_ich i2c_smbus mei
> intel_pch_thermal dca ipmi_si ipmi_devintf ipmi_msghandler acpi_pad
> acpi_power_meter fuse zram xfs crct10d
> if_pclmul ast crc32_pclmul crc32c_intel drm_vram_helper drm_ttm_helper
> ttm wmi ghash_clmulni_intel
> [  173.073900] CR2: 0000000000000008
>
> --
> -Jirka



-- 
-Jirka

