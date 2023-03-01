Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 285D76A72FD
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 19:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbjCASL2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 13:11:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbjCASL1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 13:11:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 166FF4AFF6;
        Wed,  1 Mar 2023 10:11:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A41736145E;
        Wed,  1 Mar 2023 18:11:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E70DC433EF;
        Wed,  1 Mar 2023 18:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677694285;
        bh=DAWGd67V7iFd+CjYIBrPhVp9zUPSIqgnmcIWQ1HsWcc=;
        h=From:To:Cc:Subject:Date:From;
        b=FamDpuBfWsOQTk8GKm8bZGuwF8oJqmzOGxGI9Q/VS3Us62ItLSog4SFW9B9aFfqoZ
         90TOqFTV2BzEOQEYJANM3bbGQjFK/XorgasZ/oMABZ/jP6q/rB9PJxT2LmQTPgmtcD
         bhz+E4KXcowAC/Hs1YrDmlvSzxqfRTW3N+SaaNRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.15 00/22] 5.15.97-rc1 review
Date:   Wed,  1 Mar 2023 19:08:33 +0100
Message-Id: <20230301180652.658125575@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.97-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.97-rc1
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

This is the start of the stable review cycle for the 5.15.97 release.
There are 22 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.97-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.97-rc1

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Don't hold device lock while reading the "descriptors" sysfs file

Prashanth K <quic_prashk@quicinc.com>
    usb: gadget: u_serial: Add null pointer check in gserial_resume

Florian Zumbiehl <florz@florz.de>
    USB: serial: option: add support for VW/Skoda "Carstick LTE"

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: dwc3: pci: add support for the Intel Meteor Lake-M

Carlos Llamas <cmllamas@google.com>
    scripts/tags.sh: fix incompatibility with PCRE2

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    scripts/tags.sh: Invoke 'realpath' via 'xargs'

Thomas Weißschuh <linux@weissschuh.net>
    vc_screen: don't clobber return value in vcs_read

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Remove WARN_ON_ONCE(sk->sk_forward_alloc) from sk_stream_kill_queues().

Martin KaFai Lau <martin.lau@kernel.org>
    bpf: bpf_fib_lookup should not return neigh in NUD_FAILED state

Sergio Paracuellos <sergio.paracuellos@gmail.com>
    staging: mt7621-dts: change palmbus address to lower case

Kan Liang <kan.liang@linux.intel.com>
    x86/cpu: Add Lunar Lake M

Xin Zhao <xnzhao@google.com>
    HID: core: Fix deadloop in hid_apply_multiplier.

Julian Anastasov <ja@ssi.bg>
    neigh: make sure used and confirmed times are valid

Dean Luick <dean.luick@cornelisnetworks.com>
    IB/hfi1: Assign npages earlier

Jack Yu <jack.yu@realtek.com>
    ASoC: rt715-sdca: fix clock stop prepare timeout issue

David Sterba <dsterba@suse.com>
    btrfs: send: limit number of clones and allocated memory size

Vishal Verma <vishal.l.verma@intel.com>
    ACPI: NFIT: fix a potential deadlock during NFIT teardown

Takahiro Fujii <fujii@xaxxi.net>
    HID: elecom: add support for TrackBall 056E:011C

Johan Jonker <jbx6244@gmail.com>
    ARM: dts: rockchip: add power-domains property to dp node on rk3288

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: rockchip: drop unused LED mode property from rk3328-roc-cc

Benedict Wong <benedictwong@google.com>
    Fix XFRM-I support for nested ESP tunnels

Neel Patel <neel@pensando.io>
    ionic: refactor use of ionic_rx_fill()


-------------

Diffstat:

 Makefile                                         |  4 +-
 arch/arm/boot/dts/rk3288.dtsi                    |  1 +
 arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts   |  2 -
 arch/x86/include/asm/intel-family.h              |  2 +
 drivers/acpi/nfit/core.c                         |  2 +-
 drivers/hid/hid-core.c                           |  3 ++
 drivers/hid/hid-elecom.c                         | 16 ++++++-
 drivers/hid/hid-ids.h                            |  3 +-
 drivers/hid/hid-quirks.c                         |  3 +-
 drivers/infiniband/hw/hfi1/user_exp_rcv.c        |  9 +---
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c | 23 +++++-----
 drivers/staging/mt7621-dts/gbpc1.dts             |  2 +-
 drivers/tty/vt/vc_screen.c                       |  7 +--
 drivers/usb/core/hub.c                           |  5 +--
 drivers/usb/core/sysfs.c                         |  5 ---
 drivers/usb/dwc3/dwc3-pci.c                      |  4 ++
 drivers/usb/gadget/function/u_serial.c           | 23 ++++++++--
 drivers/usb/serial/option.c                      |  4 ++
 fs/btrfs/send.c                                  |  6 +--
 net/caif/caif_socket.c                           |  1 +
 net/core/filter.c                                |  4 +-
 net/core/neighbour.c                             | 18 ++++++--
 net/core/stream.c                                |  1 -
 net/xfrm/xfrm_interface.c                        | 54 ++++++++++++++++++++++--
 net/xfrm/xfrm_policy.c                           |  3 ++
 scripts/tags.sh                                  | 11 +++--
 sound/soc/codecs/rt715-sdca-sdw.c                |  2 +-
 27 files changed, 157 insertions(+), 61 deletions(-)


