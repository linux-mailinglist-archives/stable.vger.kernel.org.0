Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2106512DB
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 20:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232767AbiLSTYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 14:24:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232717AbiLSTXm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 14:23:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98164140AF;
        Mon, 19 Dec 2022 11:23:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33D9961128;
        Mon, 19 Dec 2022 19:23:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AFB9C433D2;
        Mon, 19 Dec 2022 19:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671477790;
        bh=UmWRj50CS+Sz6srh573HQXVnfVm/n0diT9WYhtc13GI=;
        h=From:To:Cc:Subject:Date:From;
        b=sgwqocd/vGoGHICDJT69TSTjv5ANAa/w4Adp6pr3kzaUvyisBPjKF/iR/kfcvtnGG
         RXJefU4lu9f6TxgZ4bjRNTgHiF/QFoTzXBM0fBPSlnjAzKctTGOixdeLJcL6fs4nyA
         qdestD57XuuCQvEkrOwgb5F9Hzwcu8skqSeQtup0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 6.1 00/25] 6.1.1-rc1 review
Date:   Mon, 19 Dec 2022 20:22:39 +0100
Message-Id: <20221219182943.395169070@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.1-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.1-rc1
X-KernelTest-Deadline: 2022-12-21T18:29+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 6.1.1 release.
There are 25 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.1-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.1-rc1

Ferry Toth <ftoth@exalondelft.nl>
    usb: ulpi: defer ulpi_register on ulpi_read_id timeout

Nikolaus Voss <nikolaus.voss@haag-streit.com>
    KEYS: encrypted: fix key instantiation with user-provided data

Paulo Alcantara <pc@cjr.nz>
    cifs: fix oops during encryption

Shruthi Sanil <shruthi.sanil@intel.com>
    usb: dwc3: pci: Update PCIe device ID for USB3 controller on CPU sub-system for Raptor Lake

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: typec: ucsi: Resume in separate work

Tony Nguyen <anthony.l.nguyen@intel.com>
    igb: Initialize mailbox message for VF reset

Martin Kaiser <martin@kaiser.cx>
    staging: r8188eu: fix led register settings

Reka Norman <rekanorman@chromium.org>
    xhci: Apply XHCI_RESET_TO_DEFAULT quirk to ADL-N

Andy Chi <andy.chi@canonical.com>
    ALSA: hda/realtek: fix mute/micmute LEDs for a HP ProBook

Johan Hovold <johan@kernel.org>
    USB: serial: f81534: fix division by zero on line-speed change

Johan Hovold <johan@kernel.org>
    USB: serial: f81232: fix division by zero on line-speed change

Bruno Thomsen <bruno.thomsen@gmail.com>
    USB: serial: cp210x: add Kamstrup RF sniffer PIDs

Duke Xin <duke_xinanwen@163.com>
    USB: serial: option: add Quectel EM05-G modem

Szymon Heidrich <szymon.heidrich@gmail.com>
    usb: gadget: uvc: Prevent buffer overflow in setup handler

Jan Kara <jack@suse.cz>
    udf: Fix extending file within last block

Jan Kara <jack@suse.cz>
    udf: Do not bother looking for prealloc extents if i_lenExtents matches i_size

Jan Kara <jack@suse.cz>
    udf: Fix preallocation discarding at indirect extent boundary

Jan Kara <jack@suse.cz>
    udf: Discard preallocation before extending file with a hole

Sean Anderson <sean.anderson@seco.com>
    irqchip/ls-extirq: Fix endianness detection

John Thomson <git@johnthomson.fastmail.com.au>
    mips: ralink: mt7621: do not use kzalloc too early

John Thomson <git@johnthomson.fastmail.com.au>
    mips: ralink: mt7621: soc queries and tests as functions

John Thomson <git@johnthomson.fastmail.com.au>
    mips: ralink: mt7621: define MT7621_SYSC_BASE with __iomem

John Thomson <git@johnthomson.fastmail.com.au>
    PCI: mt7621: Add sentinel to quirks table

David Michael <fedora.dm0@gmail.com>
    libbpf: Fix uninitialized warning in btf_dump_dump_type_data

Nathan Chancellor <nathan@kernel.org>
    x86/vdso: Conditionally export __vdso_sgx_enter_enclave()


-------------

Diffstat:

 Documentation/security/keys/trusted-encrypted.rst |   3 +-
 Makefile                                          |   4 +-
 arch/mips/include/asm/mach-ralink/mt7621.h        |   4 +-
 arch/mips/ralink/mt7621.c                         |  97 ++++++++++-----
 arch/x86/entry/vdso/vdso.lds.S                    |   2 +
 drivers/irqchip/irq-ls-extirq.c                   |   2 +-
 drivers/net/ethernet/intel/igb/igb_main.c         |   2 +-
 drivers/pci/controller/pcie-mt7621.c              |   3 +-
 drivers/staging/r8188eu/core/rtw_led.c            |  25 +---
 drivers/usb/common/ulpi.c                         |   2 +-
 drivers/usb/dwc3/dwc3-pci.c                       |   2 +-
 drivers/usb/gadget/function/f_uvc.c               |   5 +-
 drivers/usb/host/xhci-pci.c                       |   4 +-
 drivers/usb/serial/cp210x.c                       |   2 +
 drivers/usb/serial/f81232.c                       |  12 +-
 drivers/usb/serial/f81534.c                       |  12 +-
 drivers/usb/serial/option.c                       |   3 +
 drivers/usb/typec/ucsi/ucsi.c                     |  17 ++-
 drivers/usb/typec/ucsi/ucsi.h                     |   1 +
 fs/cifs/cifsglob.h                                |  68 ++++++++++
 fs/cifs/cifsproto.h                               |   4 +-
 fs/cifs/misc.c                                    |   4 +-
 fs/cifs/smb2ops.c                                 | 143 ++++++++++------------
 fs/udf/inode.c                                    |  76 +++++-------
 fs/udf/truncate.c                                 |  48 +++-----
 security/keys/encrypted-keys/encrypted.c          |   6 +-
 sound/pci/hda/patch_realtek.c                     |   2 +
 tools/lib/bpf/btf_dump.c                          |   2 +-
 28 files changed, 319 insertions(+), 236 deletions(-)


