Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC41F6A72DA
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 19:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjCASKN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 13:10:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbjCASKD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 13:10:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45D2D10E3;
        Wed,  1 Mar 2023 10:10:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D58466145E;
        Wed,  1 Mar 2023 18:10:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D52C433D2;
        Wed,  1 Mar 2023 18:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677694201;
        bh=phJJOaIMrRBvJAMZkjNY1dHfdR84It1s0uty7i2sixs=;
        h=From:To:Cc:Subject:Date:From;
        b=YIxhg4lpCElNIiMhZBaPYotTQz4ZEThY/Q7Hp9TTzi5xTT1L8P5cQIZyOECbouRRX
         lZAvDU4vbfTBW6Y7TSEwBYvFU+OLHuBmOPPgC3YkBQUcjIEm5tnFJpB8VzTClk/pgT
         Oj/ZraBzXedS3D5Y8oxeI9TXIbjiV/M3NZ2OCdTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.10 00/19] 5.10.171-rc1 review
Date:   Wed,  1 Mar 2023 19:08:29 +0100
Message-Id: <20230301180652.316428563@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.171-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.171-rc1
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

This is the start of the stable review cycle for the 5.10.171 release.
There are 19 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.171-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.171-rc1

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Don't hold device lock while reading the "descriptors" sysfs file

Prashanth K <quic_prashk@quicinc.com>
    usb: gadget: u_serial: Add null pointer check in gserial_resume

Florian Zumbiehl <florz@florz.de>
    USB: serial: option: add support for VW/Skoda "Carstick LTE"

Dmitry Osipenko <dmitry.osipenko@collabora.com>
    drm/virtio: Correct drm_gem_shmem_get_sg_table() error handling

Miaoqian Lin <linmq006@gmail.com>
    drm/virtio: Fix NULL vs IS_ERR checking in virtio_gpu_object_shmem_init

Carlos Llamas <cmllamas@google.com>
    scripts/tags.sh: fix incompatibility with PCRE2

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    scripts/tags.sh: Invoke 'realpath' via 'xargs'

David Sloan <david.sloan@eideticom.com>
    md: Flush workqueue md_rdev_misc_wq in md_alloc()

Thomas Weißschuh <linux@weissschuh.net>
    vc_screen: don't clobber return value in vcs_read

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Remove WARN_ON_ONCE(sk->sk_forward_alloc) from sk_stream_kill_queues().

Martin KaFai Lau <martin.lau@kernel.org>
    bpf: bpf_fib_lookup should not return neigh in NUD_FAILED state

Xin Zhao <xnzhao@google.com>
    HID: core: Fix deadloop in hid_apply_multiplier.

Julian Anastasov <ja@ssi.bg>
    neigh: make sure used and confirmed times are valid

Dean Luick <dean.luick@cornelisnetworks.com>
    IB/hfi1: Assign npages earlier

David Sterba <dsterba@suse.com>
    btrfs: send: limit number of clones and allocated memory size

Vishal Verma <vishal.l.verma@intel.com>
    ACPI: NFIT: fix a potential deadlock during NFIT teardown

Johan Jonker <jbx6244@gmail.com>
    ARM: dts: rockchip: add power-domains property to dp node on rk3288

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: rockchip: drop unused LED mode property from rk3328-roc-cc

Benedict Wong <benedictwong@google.com>
    Fix XFRM-I support for nested ESP tunnels


-------------

Diffstat:

 Makefile                                       |  4 +-
 arch/arm/boot/dts/rk3288.dtsi                  |  1 +
 arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts |  2 -
 drivers/acpi/nfit/core.c                       |  2 +-
 drivers/gpu/drm/virtio/virtgpu_object.c        |  5 ++-
 drivers/hid/hid-core.c                         |  3 ++
 drivers/infiniband/hw/hfi1/user_exp_rcv.c      |  9 +----
 drivers/md/md.c                                |  1 +
 drivers/tty/vt/vc_screen.c                     |  7 ++--
 drivers/usb/core/hub.c                         |  5 +--
 drivers/usb/core/sysfs.c                       |  5 ---
 drivers/usb/gadget/function/u_serial.c         | 23 +++++++++--
 drivers/usb/serial/option.c                    |  4 ++
 fs/btrfs/send.c                                |  6 +--
 net/caif/caif_socket.c                         |  1 +
 net/core/filter.c                              |  4 +-
 net/core/neighbour.c                           | 18 +++++++--
 net/core/stream.c                              |  1 -
 net/xfrm/xfrm_interface.c                      | 54 ++++++++++++++++++++++++--
 net/xfrm/xfrm_policy.c                         |  3 ++
 scripts/tags.sh                                | 11 ++++--
 21 files changed, 123 insertions(+), 46 deletions(-)


