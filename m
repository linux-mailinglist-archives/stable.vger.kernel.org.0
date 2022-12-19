Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 855C26512F7
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 20:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbiLSTZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 14:25:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbiLSTZJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 14:25:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A6612AE8;
        Mon, 19 Dec 2022 11:24:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F19876109A;
        Mon, 19 Dec 2022 19:24:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2C8C433EF;
        Mon, 19 Dec 2022 19:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671477890;
        bh=VEG+uXiflBKhgqBO/xFeCoQH0Zpafl5hadus6dwG1Fc=;
        h=From:To:Cc:Subject:Date:From;
        b=E4/jb++WWMo/EyVUzGh1yKmxCtM+4dFlkE0bumKwIHclJKx8UWGHVWcTJU42xOXwv
         jq+tNByZHcVc6ghPYlWMpo5Ob6EuzRrCFmem7V+i4zDoVee/1A3lAaajgtlyR9nLnh
         WOAFMyJwsdUCUyf/CKmiAaEP4rnnUPI43Ai6sGF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 6.0 00/28] 6.0.15-rc1 review
Date:   Mon, 19 Dec 2022 20:22:47 +0100
Message-Id: <20221219182944.179389009@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.15-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.0.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.0.15-rc1
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

This is the start of the stable review cycle for the 6.0.15 release.
There are 28 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.15-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.0.15-rc1

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    net: loopback: use NET_NAME_PREDICTABLE for name_assign_type

Tiezhu Yang <yangtiezhu@loongson.cn>
    selftests: net: Use "grep -E" instead of "egrep"

Sungwoo Kim <iam@sung-woo.kim>
    Bluetooth: L2CAP: Fix u8 overflow

Ferry Toth <ftoth@exalondelft.nl>
    usb: ulpi: defer ulpi_register on ulpi_read_id timeout

Nikolaus Voss <nikolaus.voss@haag-streit.com>
    KEYS: encrypted: fix key instantiation with user-provided data

Shruthi Sanil <shruthi.sanil@intel.com>
    usb: dwc3: pci: Update PCIe device ID for USB3 controller on CPU sub-system for Raptor Lake

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: typec: ucsi: Resume in separate work

Tony Nguyen <anthony.l.nguyen@intel.com>
    igb: Initialize mailbox message for VF reset

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

Jiri Olsa <jolsa@kernel.org>
    selftests/bpf: Add kprobe_multi kmod attach api tests

Jiri Olsa <jolsa@kernel.org>
    selftests/bpf: Add kprobe_multi check to module attach test

Jiri Olsa <jolsa@kernel.org>
    selftests/bpf: Add bpf_testmod_fentry_* functions

Jiri Olsa <jolsa@kernel.org>
    selftests/bpf: Add load_kallsyms_refresh function

Jiri Olsa <jolsa@kernel.org>
    bpf: Take module reference on kprobe_multi link

Jiri Olsa <jolsa@kernel.org>
    bpf: Rename __bpf_kprobe_multi_cookie_cmp to bpf_kprobe_multi_addrs_cmp

Jiri Olsa <jolsa@kernel.org>
    ftrace: Add support to resolve module symbols in ftrace_lookup_symbols

Jiri Olsa <jolsa@kernel.org>
    kallsyms: Make module_kallsyms_on_each_symbol generally available

John Thomson <git@johnthomson.fastmail.com.au>
    PCI: mt7621: Add sentinel to quirks table


-------------

Diffstat:

 Documentation/security/keys/trusted-encrypted.rst  |  3 +-
 Makefile                                           |  4 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |  2 +-
 drivers/net/loopback.c                             |  2 +-
 drivers/pci/controller/pcie-mt7621.c               |  3 +-
 drivers/usb/common/ulpi.c                          |  2 +-
 drivers/usb/dwc3/dwc3-pci.c                        |  2 +-
 drivers/usb/gadget/function/f_uvc.c                |  5 +-
 drivers/usb/host/xhci-pci.c                        |  4 +-
 drivers/usb/serial/cp210x.c                        |  2 +
 drivers/usb/serial/f81232.c                        | 12 +--
 drivers/usb/serial/f81534.c                        | 12 +--
 drivers/usb/serial/option.c                        |  3 +
 drivers/usb/typec/ucsi/ucsi.c                      | 17 +++-
 drivers/usb/typec/ucsi/ucsi.h                      |  1 +
 fs/udf/inode.c                                     | 76 ++++++++---------
 fs/udf/truncate.c                                  | 48 ++++-------
 include/linux/module.h                             |  9 ++
 kernel/module/kallsyms.c                           |  2 -
 kernel/trace/bpf_trace.c                           | 98 +++++++++++++++++++++-
 kernel/trace/ftrace.c                              | 16 ++--
 net/bluetooth/l2cap_core.c                         |  3 +-
 security/keys/encrypted-keys/encrypted.c           |  6 +-
 sound/pci/hda/patch_realtek.c                      |  2 +
 .../selftests/bpf/bpf_testmod/bpf_testmod.c        | 24 ++++++
 .../bpf/prog_tests/kprobe_multi_testmod_test.c     | 89 ++++++++++++++++++++
 .../selftests/bpf/prog_tests/module_attach.c       |  7 ++
 tools/testing/selftests/bpf/progs/kprobe_multi.c   | 50 +++++++++++
 .../selftests/bpf/progs/test_module_attach.c       |  6 ++
 tools/testing/selftests/bpf/trace_helpers.c        | 20 +++--
 tools/testing/selftests/bpf/trace_helpers.h        |  2 +
 tools/testing/selftests/net/toeplitz.sh            |  2 +-
 32 files changed, 412 insertions(+), 122 deletions(-)


