Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4306A960E
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 12:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbjCCLYb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 06:24:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbjCCLYM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 06:24:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1515F5D742;
        Fri,  3 Mar 2023 03:24:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 731B5617D5;
        Fri,  3 Mar 2023 11:24:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86DADC433D2;
        Fri,  3 Mar 2023 11:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677842639;
        bh=djJbb2LiaC1XTZ5A2QIoWnrCAQbTvV39R9I64FRgGXA=;
        h=From:To:Cc:Subject:Date:From;
        b=hglodj1tt1Ghy67qJJHssSMYXsFwUENPJJtDKVAOI8XhSdoqTAGOokeXdhSh8HXiG
         KDuM+1/N/kUfuTHiO9siCYzs+NPCGGn/qzowrFudKoJADXk2SbWKNeUMYp9REJ8NtV
         PP1ffte4t+u+yzR+DKroOwrdhCfSMhyGx99pXAak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.171
Date:   Fri,  3 Mar 2023 12:23:47 +0100
Message-Id: <1677842627128187@kroah.com>
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

I'm announcing the release of the 5.10.171 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                       |    2 
 arch/arm/boot/dts/rk3288.dtsi                  |    1 
 arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts |    2 
 drivers/acpi/nfit/core.c                       |    2 
 drivers/gpu/drm/virtio/virtgpu_object.c        |    5 +-
 drivers/hid/hid-core.c                         |    3 +
 drivers/infiniband/hw/hfi1/user_exp_rcv.c      |    9 ----
 drivers/md/md.c                                |    1 
 drivers/tty/vt/vc_screen.c                     |    7 +--
 drivers/usb/core/hub.c                         |    5 --
 drivers/usb/core/sysfs.c                       |    5 --
 drivers/usb/gadget/function/u_serial.c         |   23 ++++++++--
 drivers/usb/serial/option.c                    |    4 +
 fs/btrfs/send.c                                |    6 +-
 io_uring/io_uring.c                            |   25 +++++++----
 net/caif/caif_socket.c                         |    1 
 net/core/filter.c                              |    4 -
 net/core/neighbour.c                           |   18 ++++++--
 net/core/stream.c                              |    1 
 net/xfrm/xfrm_interface.c                      |   54 +++++++++++++++++++++++--
 net/xfrm/xfrm_policy.c                         |    3 +
 scripts/tags.sh                                |   11 +++--
 22 files changed, 138 insertions(+), 54 deletions(-)

Alan Stern (1):
      USB: core: Don't hold device lock while reading the "descriptors" sysfs file

Benedict Wong (1):
      Fix XFRM-I support for nested ESP tunnels

Bing-Jhong Billy Jheng (1):
      io_uring: add missing lock in io_get_file_fixed

Carlos Llamas (1):
      scripts/tags.sh: fix incompatibility with PCRE2

Cristian Ciocaltea (1):
      scripts/tags.sh: Invoke 'realpath' via 'xargs'

David Sloan (1):
      md: Flush workqueue md_rdev_misc_wq in md_alloc()

David Sterba (1):
      btrfs: send: limit number of clones and allocated memory size

Dean Luick (1):
      IB/hfi1: Assign npages earlier

Dmitry Osipenko (1):
      drm/virtio: Correct drm_gem_shmem_get_sg_table() error handling

Florian Zumbiehl (1):
      USB: serial: option: add support for VW/Skoda "Carstick LTE"

Greg Kroah-Hartman (1):
      Linux 5.10.171

Johan Jonker (1):
      ARM: dts: rockchip: add power-domains property to dp node on rk3288

Julian Anastasov (1):
      neigh: make sure used and confirmed times are valid

Krzysztof Kozlowski (1):
      arm64: dts: rockchip: drop unused LED mode property from rk3328-roc-cc

Kuniyuki Iwashima (1):
      net: Remove WARN_ON_ONCE(sk->sk_forward_alloc) from sk_stream_kill_queues().

Martin KaFai Lau (1):
      bpf: bpf_fib_lookup should not return neigh in NUD_FAILED state

Miaoqian Lin (1):
      drm/virtio: Fix NULL vs IS_ERR checking in virtio_gpu_object_shmem_init

Prashanth K (1):
      usb: gadget: u_serial: Add null pointer check in gserial_resume

Thomas Weißschuh (1):
      vc_screen: don't clobber return value in vcs_read

Vishal Verma (1):
      ACPI: NFIT: fix a potential deadlock during NFIT teardown

Xin Zhao (1):
      HID: core: Fix deadloop in hid_apply_multiplier.

