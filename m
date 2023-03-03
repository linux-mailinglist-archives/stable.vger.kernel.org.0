Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0B16A9619
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 12:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbjCCLZR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 06:25:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbjCCLYk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 06:24:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7182D618B3;
        Fri,  3 Mar 2023 03:24:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E57AB818A1;
        Fri,  3 Mar 2023 11:24:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84290C433D2;
        Fri,  3 Mar 2023 11:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677842651;
        bh=OsF78/yN0ehmavW0bRuBeeiT9PPgaYigPodJU4hzE08=;
        h=From:To:Cc:Subject:Date:From;
        b=FCk70iRfhKJKrEmtc2JQEmcATz8fQ7w5955vjIWfFOYfMXhJXW+2Mqz5m/nXMRXKP
         4UO/Ycf04xqiAVY+aOUHj2+p8jAmr6QgTxWpk7mCgpTjxfAl9Rlvz5RnsDGhM+4M0a
         n3hi5RbqtumUuEVFH26uNSuZfjfSy1xJqfDTs78Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.1.15
Date:   Fri,  3 Mar 2023 12:23:58 +0100
Message-Id: <167784263892226@kroah.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 6.1.15 kernel.

All users of the 6.1 kernel series must upgrade.

The updated 6.1.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.1.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/trace/ftrace.rst                                 |    2 
 Makefile                                                       |    2 
 arch/arm/boot/dts/rk3288.dtsi                                  |    1 
 arch/arm/boot/dts/stihxxx-b2120.dtsi                           |    2 
 arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts                 |    2 
 arch/arm64/boot/dts/rockchip/rk3399-op1-opp.dtsi               |    2 
 arch/arm64/boot/dts/rockchip/rk3399-pinephone-pro.dts          |    7 
 arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts                |    2 
 arch/arm64/boot/dts/rockchip/rk356x.dtsi                       |    1 
 arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget0.dts    |    2 
 arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget1.dts    |    2 
 arch/powerpc/Kconfig                                           |    1 
 arch/x86/include/asm/intel-family.h                            |    2 
 drivers/acpi/nfit/core.c                                       |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c              |  150 ++++------
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h              |   17 -
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c      |   10 
 drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.c           |   24 +
 drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.h           |    2 
 drivers/gpu/drm/amd/display/dc/dcn314/dcn314_init.c            |    2 
 drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h                |   25 +
 drivers/hid/hid-core.c                                         |    3 
 drivers/hid/hid-elecom.c                                       |   16 -
 drivers/hid/hid-ids.h                                          |    5 
 drivers/hid/hid-input.c                                        |    4 
 drivers/hid/hid-quirks.c                                       |    3 
 drivers/infiniband/hw/hfi1/user_exp_rcv.c                      |    9 
 drivers/pinctrl/pinctrl-amd.c                                  |    1 
 drivers/tty/vt/vc_screen.c                                     |    7 
 drivers/usb/core/hub.c                                         |    5 
 drivers/usb/core/sysfs.c                                       |    5 
 drivers/usb/dwc3/dwc3-pci.c                                    |    4 
 drivers/usb/gadget/function/u_serial.c                         |   23 +
 drivers/usb/serial/option.c                                    |    4 
 drivers/usb/typec/pd.c                                         |    1 
 fs/attr.c                                                      |   74 ++++
 fs/btrfs/send.c                                                |    6 
 fs/fuse/file.c                                                 |    2 
 fs/inode.c                                                     |   64 +---
 fs/internal.h                                                  |   10 
 fs/ocfs2/file.c                                                |    4 
 fs/open.c                                                      |    8 
 include/linux/fs.h                                             |    4 
 kernel/power/process.c                                         |   21 -
 net/caif/caif_socket.c                                         |    1 
 net/core/filter.c                                              |    4 
 net/core/neighbour.c                                           |   18 +
 net/core/stream.c                                              |    1 
 net/xfrm/xfrm_interface.c                                      |   54 +++
 net/xfrm/xfrm_policy.c                                         |    3 
 scripts/tags.sh                                                |    2 
 sound/soc/codecs/es8326.c                                      |    6 
 sound/soc/codecs/rt715-sdca-sdw.c                              |    2 
 sound/soc/sof/amd/acp.c                                        |   36 +-
 tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh |    2 
 55 files changed, 445 insertions(+), 227 deletions(-)

Alan Stern (1):
      USB: core: Don't hold device lock while reading the "descriptors" sysfs file

Alexey Firago (1):
      ASoC: codecs: es8326: Fix DTS properties reading

Benedict Wong (1):
      Fix XFRM-I support for nested ESP tunnels

Carlos Llamas (1):
      scripts/tags.sh: fix incompatibility with PCRE2

Christian Brauner (5):
      attr: add in_group_or_capable()
      fs: move should_remove_suid()
      attr: add setattr_should_drop_sgid()
      attr: use consistent sgid stripping checks
      fs: use consistent setgid checks in is_sxid()

David Sterba (1):
      btrfs: send: limit number of clones and allocated memory size

Dean Luick (1):
      IB/hfi1: Assign npages earlier

Dmitry Torokhov (1):
      ARM: dts: stihxxx-b2120: fix polarity of reset line of tsin0 port

Florian Zumbiehl (1):
      USB: serial: option: add support for VW/Skoda "Carstick LTE"

Greg Kroah-Hartman (1):
      Linux 6.1.15

Heikki Krogerus (1):
      usb: dwc3: pci: add support for the Intel Meteor Lake-M

Jack Yu (1):
      ASoC: rt715-sdca: fix clock stop prepare timeout issue

Jarrah Gosbell (1):
      arm64: dts: rockchip: reduce thermal limits on rk3399-pinephone-pro

Jensen Huang (1):
      arm64: dts: rockchip: add missing #interrupt-cells to rk356x pcie2x1

Johan Jonker (1):
      ARM: dts: rockchip: add power-domains property to dp node on rk3288

Jonas Karlman (1):
      arm64: dts: rockchip: fix probe of analog sound card on rock-3a

Julian Anastasov (1):
      neigh: make sure used and confirmed times are valid

Kan Liang (1):
      x86/cpu: Add Lunar Lake M

Krzysztof Kozlowski (2):
      arm64: dts: rockchip: drop unused LED mode property from rk3328-roc-cc
      arm64: dts: rockchip: align rk3399 DMC OPP table with bindings

Kunihiko Hayashi (1):
      arm64: dts: uniphier: Fix property name in PXs3 USB node

Kuniyuki Iwashima (1):
      net: Remove WARN_ON_ONCE(sk->sk_forward_alloc) from sk_stream_kill_queues().

Luka Guzenko (1):
      HID: Ignore battery for ELAN touchscreen 29DF on HP

Mario Limonciello (1):
      pinctrl: amd: Fix debug output for debounce time

Martin KaFai Lau (1):
      bpf: bpf_fib_lookup should not return neigh in NUD_FAILED state

Michael Ellerman (1):
      powerpc: Don't select ARCH_WANTS_NO_INSTR

Nicholas Kazlauskas (1):
      drm/amd/display: Move DCN314 DOMAIN power control to DMCUB

Prashanth K (1):
      usb: gadget: u_serial: Add null pointer check in gserial_resume

Rafael J. Wysocki (1):
      PM: sleep: Avoid using pr_cont() in the tasks freezing code

Saranya Gopal (1):
      usb: typec: pd: Remove usb_suspend_supported sysfs from sink PDO

Stylon Wang (2):
      drm/amd/display: Fix race condition in DPIA AUX transfer
      drm/amd/display: Properly reuse completion structure

Takahiro Fujii (1):
      HID: elecom: add support for TrackBall 056E:011C

Thomas Weißschuh (1):
      vc_screen: don't clobber return value in vcs_read

V sujith kumar Reddy (1):
      ASoC: SOF: amd: Fix for handling spurious interrupts from DSP

Vishal Verma (1):
      ACPI: NFIT: fix a potential deadlock during NFIT teardown

Vladimir Oltean (1):
      selftests: ocelot: tc_flower_chains: make test_vlan_ingress_modify() more comprehensive

Xin Zhao (1):
      HID: core: Fix deadloop in hid_apply_multiplier.

marco.rodolfi@tuta.io (1):
      HID: Ignore battery for Elan touchscreen on Asus TP420IA

