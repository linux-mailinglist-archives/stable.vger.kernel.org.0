Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC46B5E7B11
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 14:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbiIWMrh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 08:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231409AbiIWMrd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 08:47:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5797F135736;
        Fri, 23 Sep 2022 05:47:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC95460F95;
        Fri, 23 Sep 2022 12:47:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B37FFC433D7;
        Fri, 23 Sep 2022 12:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663937250;
        bh=3wEUd2nJrS9x47a4jkDVU1IMjEq41OriNd5gxzpZI+g=;
        h=From:To:Cc:Subject:Date:From;
        b=SdCnBV4TkM5ARAsUA5UGVTTxrKWtye08GXJTsqeq8kjhPTKNzkwQ5PAlF2pca7OgJ
         fbnAFylnM9NHCDCd5QgoRqBPnn+ArT4B4lYOALVWM4NpBctvpdZUYQf/SQWjw1K1k3
         y8ei/10ubMx5sSAryi7jbf4AEOy0CwX0tj48XTeg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.19.11
Date:   Fri, 23 Sep 2022 14:47:15 +0200
Message-Id: <166393723653182@kroah.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
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

I'm announcing the release of the 5.19.11 kernel.

All users of the 5.19 kernel series must upgrade.

The updated 5.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/interrupt-controller/apple,aic.yaml |    2 
 Makefile                                                              |    2 
 arch/parisc/Kconfig                                                   |   12 ++++
 block/blk-core.c                                                      |    4 -
 block/blk-lib.c                                                       |   11 ++--
 drivers/gpio/gpio-mpc8xxx.c                                           |    1 
 drivers/gpio/gpio-rockchip.c                                          |    4 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                            |   14 ++++-
 drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c                                |    9 ++-
 drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c                                |    9 ++-
 drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c                                |    9 ++-
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c                                |    5 +
 drivers/gpu/drm/amd/amdgpu/soc15.c                                    |   25 ---------
 drivers/gpu/drm/amd/amdgpu/vega10_ih.c                                |    4 +
 drivers/gpu/drm/amd/amdgpu/vega20_ih.c                                |    4 +
 drivers/gpu/drm/i915/display/icl_dsi.c                                |    2 
 drivers/gpu/drm/i915/display/intel_dp.c                               |    1 
 drivers/gpu/drm/i915/display/intel_vdsc.c                             |    1 
 drivers/gpu/drm/i915/gt/uc/intel_guc.h                                |    8 ++
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c                     |   20 +++++++
 drivers/gpu/drm/i915/i915_reg.h                                       |   16 ++---
 drivers/gpu/drm/i915/i915_vma.c                                       |    3 -
 drivers/gpu/drm/meson/meson_plane.c                                   |    2 
 drivers/gpu/drm/meson/meson_viu.c                                     |    2 
 drivers/gpu/drm/panel/panel-edp.c                                     |    3 -
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c                          |    4 +
 drivers/iommu/intel/dmar.c                                            |    7 --
 drivers/iommu/intel/iommu.c                                           |   27 +++++++++-
 drivers/of/fdt.c                                                      |    2 
 drivers/parisc/ccio-dma.c                                             |    1 
 drivers/pinctrl/qcom/pinctrl-sc8180x.c                                |   10 +--
 drivers/pinctrl/sunxi/pinctrl-sun50i-a100-r.c                         |    2 
 fs/cifs/connect.c                                                     |   11 +---
 fs/cifs/file.c                                                        |    3 +
 fs/cifs/transport.c                                                   |    6 --
 fs/nfs/internal.h                                                     |   25 +++++++++
 fs/nfs/nfs42proc.c                                                    |    9 ++-
 fs/nfs/super.c                                                        |   27 ++++++----
 fs/nfs/write.c                                                        |   25 ---------
 include/linux/dmar.h                                                  |    4 -
 include/linux/of_device.h                                             |    5 +
 include/net/xfrm.h                                                    |    2 
 io_uring/io_uring.c                                                   |    3 -
 kernel/cgroup/cgroup-v1.c                                             |    2 
 net/ipv4/ip_output.c                                                  |    2 
 net/ipv4/tcp_ipv4.c                                                   |    2 
 net/ipv6/tcp_ipv6.c                                                   |    5 +
 net/sunrpc/clnt.c                                                     |    3 +
 net/sunrpc/xprt.c                                                     |    8 +-
 sound/pci/hda/patch_sigmatel.c                                        |   24 ++++++++
 tools/include/uapi/asm/errno.h                                        |    4 -
 51 files changed, 262 insertions(+), 134 deletions(-)

Alan Previn (1):
      drm/i915/guc: Don't update engine busyness stats too frequently

Alex Deucher (3):
      drm/amdgpu: make sure to init common IP before gmc
      drm/amdgpu: move nbio ih_doorbell_range() into ih code for vega
      drm/amdgpu: move nbio sdma_doorbell_range() into sdma code for vega

Ankit Nautiyal (1):
      drm/i915/vdsc: Set VDSC PIC_HEIGHT before using for DP DSC

Anna Schumaker (1):
      NFSv4.2: Update mode bits after ALLOCATE and DEALLOCATE

Ashutosh Dixit (1):
      drm/i915/gt: Fix perf limit reasons bit positions

Ben Hutchings (1):
      tools/include/uapi: Fix <asm/errno.h> for parisc and xtensa

Chen-Yu Tsai (1):
      drm/panel-edp: Fix delays for Innolux N116BCA-EA1

Dan Aloni (1):
      Revert "SUNRPC: Remove unreachable error condition"

Greg Kroah-Hartman (1):
      Linux 5.19.11

Helge Deller (1):
      parisc: Allow CONFIG_64BIT with ARCH=parisc

Janne Grunau (1):
      dt-bindings: apple,aic: Fix required item "apple,fiq-index" in affinity description

Jens Axboe (1):
      io_uring/msg_ring: check file type before putting

João H. Spies (1):
      pinctrl: rockchip: Enhance support for IRQ_TYPE_EDGE_BOTH

Lijo Lazar (1):
      drm/amdgpu: Don't enable LTR if not supported

Lu Baolu (1):
      Revert "iommu/vt-d: Fix possible recursive locking in intel_iommu_init()"

Michael Wu (1):
      pinctrl: sunxi: Fix name for A100 R_PIO

Mikulas Patocka (1):
      blk-lib: fix blkdev_issue_secure_erase

Molly Sophia (2):
      pinctrl: qcom: sc8180x: Fix gpio_wakeirq_map
      pinctrl: qcom: sc8180x: Fix wrong pin numbers

Nirmoy Das (1):
      drm/i915: Set correct domains values at _i915_vma_move_to_active

Pali Rohár (1):
      gpio: mpc8xxx: Fix support for IRQ_TYPE_LEVEL_LOW flow_type in mpc85xx

Ronnie Sahlberg (1):
      cifs: revalidate mapping when doing direct writes

Sascha Hauer (1):
      drm/rockchip: vop2: Fix eDP/HDMI sync polarities

Sergey Shtylyov (1):
      of: fdt: fix off-by-one error in unflatten_dt_nodes()

Stefan Metzmacher (2):
      cifs: don't send down the destination address to sendmsg for a SOCK_STREAM
      cifs: always initialize struct msghdr smb_msg completely

Stefan Roesch (1):
      block: blk_queue_enter() / __bio_queue_enter() must return -EAGAIN for nowait

Stuart Menefy (2):
      drm/meson: Correct OSD1 global alpha value
      drm/meson: Fix OSD1 RGB to YCbCr coefficient

Takashi Iwai (2):
      ALSA: hda/sigmatel: Keep power up while beep is enabled
      ALSA: hda/sigmatel: Fix unused variable warning for beep power change

Tetsuo Handa (1):
      cgroup: Add missing cpus_read_lock() to cgroup_attach_task_all()

Thierry Reding (1):
      of/device: Fix up of_dma_configure_id() stub

Trond Myklebust (2):
      SUNRPC: Fix call completion races with call_decode()
      NFSv4: Turn off open-by-filehandle and NFS re-export for NFSv4.0

Umesh Nerlige Ramappa (1):
      drm/i915/guc: Cancel GuC engine busyness worker synchronously

Yang Yingliang (1):
      parisc: ccio-dma: Add missing iounmap in error path in ccio_probe()

sewookseo (1):
      net: Find dst with sk's xfrm policy not ctl_sk

