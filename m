Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5B666A7318
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 19:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbjCASMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 13:12:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbjCASMg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 13:12:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB724AFF6;
        Wed,  1 Mar 2023 10:12:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 992AA6145E;
        Wed,  1 Mar 2023 18:12:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 816F6C433D2;
        Wed,  1 Mar 2023 18:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677694353;
        bh=y1d53xEgSUxUqIvrYe+1FEG+frmchlfXOOBCQftVxw8=;
        h=From:To:Cc:Subject:Date:From;
        b=zZJ27L5PooZ922V323VzzS8gbpvQikMGKAv89uvc+4TuySboOcY7Wfe9upCx+3RRf
         UpQm4eDNGwtnZ/WtcHWfDCbXDCFZUkwFDMqqonSBa51IBd01RRwrwcZI/MLE3nzPwH
         fI0pyGWqktXwqxCQ9PfdK7AtoBvE4s/zrol6/yiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 6.1 00/42] 6.1.15-rc1 review
Date:   Wed,  1 Mar 2023 19:08:21 +0100
Message-Id: <20230301180657.003689969@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.15-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.15-rc1
X-KernelTest-Deadline: 2023-03-03T18:06+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 6.1.15 release.
There are 42 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.15-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.15-rc1

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Don't hold device lock while reading the "descriptors" sysfs file

Carlos Llamas <cmllamas@google.com>
    scripts/tags.sh: fix incompatibility with PCRE2

Christian Brauner <brauner@kernel.org>
    fs: use consistent setgid checks in is_sxid()

Christian Brauner <brauner@kernel.org>
    attr: use consistent sgid stripping checks

Christian Brauner <brauner@kernel.org>
    attr: add setattr_should_drop_sgid()

Christian Brauner <brauner@kernel.org>
    fs: move should_remove_suid()

Christian Brauner <brauner@kernel.org>
    attr: add in_group_or_capable()

Stylon Wang <stylon.wang@amd.com>
    drm/amd/display: Properly reuse completion structure

Saranya Gopal <saranya.gopal@intel.com>
    usb: typec: pd: Remove usb_suspend_supported sysfs from sink PDO

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    arm64: dts: uniphier: Fix property name in PXs3 USB node

Prashanth K <quic_prashk@quicinc.com>
    usb: gadget: u_serial: Add null pointer check in gserial_resume

Florian Zumbiehl <florz@florz.de>
    USB: serial: option: add support for VW/Skoda "Carstick LTE"

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: dwc3: pci: add support for the Intel Meteor Lake-M

Stylon Wang <stylon.wang@amd.com>
    drm/amd/display: Fix race condition in DPIA AUX transfer

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Move DCN314 DOMAIN power control to DMCUB

Thomas Weißschuh <linux@weissschuh.net>
    vc_screen: don't clobber return value in vcs_read

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Remove WARN_ON_ONCE(sk->sk_forward_alloc) from sk_stream_kill_queues().

Martin KaFai Lau <martin.lau@kernel.org>
    bpf: bpf_fib_lookup should not return neigh in NUD_FAILED state

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: sleep: Avoid using pr_cont() in the tasks freezing code

Kan Liang <kan.liang@linux.intel.com>
    x86/cpu: Add Lunar Lake M

Vladimir Oltean <vladimir.oltean@nxp.com>
    selftests: ocelot: tc_flower_chains: make test_vlan_ingress_modify() more comprehensive

Luka Guzenko <l.guzenko@web.de>
    HID: Ignore battery for ELAN touchscreen 29DF on HP

Alexey Firago <a.firago@yadro.com>
    ASoC: codecs: es8326: Fix DTS properties reading

Xin Zhao <xnzhao@google.com>
    HID: core: Fix deadloop in hid_apply_multiplier.

Julian Anastasov <ja@ssi.bg>
    neigh: make sure used and confirmed times are valid

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    ARM: dts: stihxxx-b2120: fix polarity of reset line of tsin0 port

V sujith kumar Reddy <Vsujithkumar.Reddy@amd.com>
    ASoC: SOF: amd: Fix for handling spurious interrupts from DSP

Michael Ellerman <mpe@ellerman.id.au>
    powerpc: Don't select ARCH_WANTS_NO_INSTR

Dean Luick <dean.luick@cornelisnetworks.com>
    IB/hfi1: Assign npages earlier

Jack Yu <jack.yu@realtek.com>
    ASoC: rt715-sdca: fix clock stop prepare timeout issue

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: rockchip: align rk3399 DMC OPP table with bindings

David Sterba <dsterba@suse.com>
    btrfs: send: limit number of clones and allocated memory size

Mario Limonciello <mario.limonciello@amd.com>
    pinctrl: amd: Fix debug output for debounce time

Vishal Verma <vishal.l.verma@intel.com>
    ACPI: NFIT: fix a potential deadlock during NFIT teardown

marco.rodolfi@tuta.io <marco.rodolfi@tuta.io>
    HID: Ignore battery for Elan touchscreen on Asus TP420IA

Takahiro Fujii <fujii@xaxxi.net>
    HID: elecom: add support for TrackBall 056E:011C

Jonas Karlman <jonas@kwiboo.se>
    arm64: dts: rockchip: fix probe of analog sound card on rock-3a

Jensen Huang <jensenhuang@friendlyarm.com>
    arm64: dts: rockchip: add missing #interrupt-cells to rk356x pcie2x1

Johan Jonker <jbx6244@gmail.com>
    ARM: dts: rockchip: add power-domains property to dp node on rk3288

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: rockchip: drop unused LED mode property from rk3328-roc-cc

Jarrah Gosbell <kernel@undef.tools>
    arm64: dts: rockchip: reduce thermal limits on rk3399-pinephone-pro

Benedict Wong <benedictwong@google.com>
    Fix XFRM-I support for nested ESP tunnels


-------------

Diffstat:

 Documentation/trace/ftrace.rst                     |   2 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/rk3288.dtsi                      |   1 +
 arch/arm/boot/dts/stihxxx-b2120.dtsi               |   2 +-
 arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts     |   2 -
 arch/arm64/boot/dts/rockchip/rk3399-op1-opp.dtsi   |   2 +-
 .../boot/dts/rockchip/rk3399-pinephone-pro.dts     |   7 +
 arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts    |   2 +
 arch/arm64/boot/dts/rockchip/rk356x.dtsi           |   1 +
 .../dts/socionext/uniphier-pxs3-ref-gadget0.dts    |   2 +-
 .../dts/socionext/uniphier-pxs3-ref-gadget1.dts    |   2 +-
 arch/powerpc/Kconfig                               |   1 -
 arch/x86/include/asm/intel-family.h                |   2 +
 drivers/acpi/nfit/core.c                           |   2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  | 150 ++++++++++-----------
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h  |  17 ++-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c  |  10 +-
 .../gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.c   |  24 ++++
 .../gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.h   |   2 +
 .../gpu/drm/amd/display/dc/dcn314/dcn314_init.c    |   2 +-
 drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h    |  25 ++++
 drivers/hid/hid-core.c                             |   3 +
 drivers/hid/hid-elecom.c                           |  16 ++-
 drivers/hid/hid-ids.h                              |   5 +-
 drivers/hid/hid-input.c                            |   4 +
 drivers/hid/hid-quirks.c                           |   3 +-
 drivers/infiniband/hw/hfi1/user_exp_rcv.c          |   9 +-
 drivers/pinctrl/pinctrl-amd.c                      |   1 +
 drivers/tty/vt/vc_screen.c                         |   7 +-
 drivers/usb/core/hub.c                             |   5 +-
 drivers/usb/core/sysfs.c                           |   5 -
 drivers/usb/dwc3/dwc3-pci.c                        |   4 +
 drivers/usb/gadget/function/u_serial.c             |  23 +++-
 drivers/usb/serial/option.c                        |   4 +
 drivers/usb/typec/pd.c                             |   1 -
 fs/attr.c                                          |  74 +++++++++-
 fs/btrfs/send.c                                    |   6 +-
 fs/fuse/file.c                                     |   2 +-
 fs/inode.c                                         |  64 ++++-----
 fs/internal.h                                      |  10 +-
 fs/ocfs2/file.c                                    |   4 +-
 fs/open.c                                          |   8 +-
 include/linux/fs.h                                 |   4 +-
 kernel/power/process.c                             |  21 ++-
 net/caif/caif_socket.c                             |   1 +
 net/core/filter.c                                  |   4 +-
 net/core/neighbour.c                               |  18 ++-
 net/core/stream.c                                  |   1 -
 net/xfrm/xfrm_interface.c                          |  54 +++++++-
 net/xfrm/xfrm_policy.c                             |   3 +
 scripts/tags.sh                                    |   2 +-
 sound/soc/codecs/es8326.c                          |   6 +-
 sound/soc/codecs/rt715-sdca-sdw.c                  |   2 +-
 sound/soc/sof/amd/acp.c                            |  36 +++--
 .../drivers/net/ocelot/tc_flower_chains.sh         |   2 +-
 55 files changed, 446 insertions(+), 228 deletions(-)


