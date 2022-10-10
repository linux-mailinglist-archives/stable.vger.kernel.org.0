Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1715F98EF
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbiJJHEH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbiJJHEF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:04:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DBF64DB27;
        Mon, 10 Oct 2022 00:04:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B401CB80E52;
        Mon, 10 Oct 2022 07:04:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A62C433D6;
        Mon, 10 Oct 2022 07:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385440;
        bh=ME2vPBDDVlWsg0nWvuOgmZbdCcq23e8vJZol34q0aiU=;
        h=From:To:Cc:Subject:Date:From;
        b=GIna2Zf1uMA1v5ADg+qWt2dQ1fTmYtgZcRkOrOLL4KKicN8pJtoVah+g9OckaoN49
         KsE2vQYtU91Fst9YKUnKF+ydhbsTWDfv4qbDgesO2OMQIGsD8i+xn55LmZxg3QwV2W
         HkOWsLjR55jyAxnh6xbO0VjiZZ3k3XbyOC9YpO8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: [PATCH 6.0 00/17] 6.0.1-rc1 review
Date:   Mon, 10 Oct 2022 09:04:23 +0200
Message-Id: <20221010070330.159911806@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.1-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.0.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.0.1-rc1
X-KernelTest-Deadline: 2022-10-12T07:03+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 6.0.1 release.
There are 17 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 12 Oct 2022 07:03:19 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.1-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.0.1-rc1

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    Bluetooth: use hdev->workqueue when queuing hdev->{cmd,ncmd}_timer works

Jules Irenge <jbi.octave@gmail.com>
    bpf: Fix resetting logic for unreferenced kptrs

Daniel Golle <daniel@makrotopia.org>
    net: ethernet: mtk_eth_soc: fix state in __mtk_foe_entry_clear

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Gate dynptr API behind CAP_BPF

Palmer Dabbelt <palmer@rivosinc.com>
    RISC-V: Print SSTC in canonical order

Mario Limonciello <mario.limonciello@amd.com>
    gpiolib: acpi: Add a quirk for Asus UM325UAZ

Mario Limonciello <mario.limonciello@amd.com>
    gpiolib: acpi: Add support to ignore programming an interrupt

Johan Hovold <johan@kernel.org>
    USB: serial: ftdi_sio: fix 300 bps rate for SIO

Tadeusz Struk <tadeusz.struk@linaro.org>
    usb: mon: make mmapped memory read only

Aleksa Savic <savicaleksa83@gmail.com>
    hwmon: (aquacomputer_d5next) Fix Quadro fan speed offsets

Shuah Khan <skhan@linuxfoundation.org>
    docs: update mediator information in CoC docs

Kees Cook <keescook@chromium.org>
    hardening: Remove Clang's enable flag for -ftrivial-auto-var-init=zero

Sami Tolvanen <samitolvanen@google.com>
    Makefile.extrawarn: Move -Wcast-function-type-strict to W=1

Bart Van Assche <bvanassche@acm.org>
    sparc: Unbreak the build

Al Viro <viro@zeniv.linux.org.uk>
    fix coredump breakage

Dongliang Mu <mudongliangabcd@gmail.com>
    fs: fix UAF/GPF bug in nilfs_mdt_destroy

Jalal Mostafa <jalal.a.mostapha@gmail.com>
    xsk: Inherit need_wakeup flag for shared sockets


-------------

Diffstat:

 .../process/code-of-conduct-interpretation.rst     |  2 +-
 Makefile                                           |  8 ++---
 arch/riscv/kernel/cpu.c                            |  2 +-
 arch/sparc/include/asm/smp_32.h                    | 15 ++++-----
 arch/sparc/kernel/leon_smp.c                       | 12 ++++---
 arch/sparc/kernel/sun4d_smp.c                      | 12 ++++---
 arch/sparc/kernel/sun4m_smp.c                      | 10 +++---
 arch/sparc/mm/srmmu.c                              | 29 ++++++++---------
 drivers/gpio/gpiolib-acpi.c                        | 38 +++++++++++++++++++---
 drivers/hwmon/aquacomputer_d5next.c                |  2 +-
 drivers/net/ethernet/mediatek/mtk_ppe.c            |  2 +-
 drivers/usb/mon/mon_bin.c                          |  5 +++
 drivers/usb/serial/ftdi_sio.c                      |  3 +-
 fs/coredump.c                                      |  3 +-
 fs/inode.c                                         |  7 ++--
 include/net/xsk_buff_pool.h                        |  2 +-
 kernel/bpf/helpers.c                               | 28 ++++++++--------
 kernel/bpf/syscall.c                               |  2 +-
 net/bluetooth/hci_core.c                           | 15 +++++++--
 net/bluetooth/hci_event.c                          |  6 ++--
 net/xdp/xsk.c                                      |  4 +--
 net/xdp/xsk_buff_pool.c                            |  5 +--
 scripts/Makefile.extrawarn                         |  1 +
 security/Kconfig.hardening                         | 14 +++++---
 24 files changed, 141 insertions(+), 86 deletions(-)


