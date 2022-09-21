Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC3875C04B3
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 18:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbiIUQwj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 12:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbiIUQwP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 12:52:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF31E44;
        Wed, 21 Sep 2022 09:48:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E72BB831AC;
        Wed, 21 Sep 2022 16:48:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C43C433C1;
        Wed, 21 Sep 2022 16:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663778880;
        bh=Uq+7kCNXeOIRo5XwITrK2IWj1Ufg3iGwxOhE4kBFrR0=;
        h=From:To:Cc:Subject:Date:From;
        b=J40hXYKCXdZlyaGQ3A4O2U1YOCccm76nvu2kOlyx1ef+LISqtylleTBEzqalFtso6
         VL6ZB8UW8CvNLNUtgHnGCJv0kEUMCP5ixac8rFnJXxPd1RNqZWzoHe6cHLH1wYJDyG
         rNA28PZKQYNJQL0psCbypd+6cSnsvfgWIShrnovs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.19 00/39] 5.19.11-rc2 review
Date:   Wed, 21 Sep 2022 18:47:57 +0200
Message-Id: <20220921164741.757857192@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.11-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.19.11-rc2
X-KernelTest-Deadline: 2022-09-23T16:47+00:00
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

This is the start of the stable review cycle for the 5.19.11 release.
There are 39 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 23 Sep 2022 16:47:28 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.11-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.19.11-rc2

Lu Baolu <baolu.lu@linux.intel.com>
    Revert "iommu/vt-d: Fix possible recursive locking in intel_iommu_init()"

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/sigmatel: Fix unused variable warning for beep power change

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/sigmatel: Keep power up while beep is enabled

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    cgroup: Add missing cpus_read_lock() to cgroup_attach_task_all()

Janne Grunau <j@jannau.net>
    dt-bindings: apple,aic: Fix required item "apple,fiq-index" in affinity description

sewookseo <sewookseo@google.com>
    net: Find dst with sk's xfrm policy not ctl_sk

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: move nbio sdma_doorbell_range() into sdma code for vega

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: move nbio ih_doorbell_range() into ih code for vega

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Don't enable LTR if not supported

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: make sure to init common IP before gmc

Nirmoy Das <nirmoy.das@intel.com>
    drm/i915: Set correct domains values at _i915_vma_move_to_active

Ashutosh Dixit <ashutosh.dixit@intel.com>
    drm/i915/gt: Fix perf limit reasons bit positions

Ben Hutchings <benh@debian.org>
    tools/include/uapi: Fix <asm/errno.h> for parisc and xtensa

Helge Deller <deller@gmx.de>
    parisc: Allow CONFIG_64BIT with ARCH=parisc

Mikulas Patocka <mpatocka@redhat.com>
    blk-lib: fix blkdev_issue_secure_erase

Stefan Metzmacher <metze@samba.org>
    cifs: always initialize struct msghdr smb_msg completely

Stefan Metzmacher <metze@samba.org>
    cifs: don't send down the destination address to sendmsg for a SOCK_STREAM

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: revalidate mapping when doing direct writes

Jens Axboe <axboe@kernel.dk>
    io_uring/msg_ring: check file type before putting

Thierry Reding <treding@nvidia.com>
    of/device: Fix up of_dma_configure_id() stub

Yang Yingliang <yangyingliang@huawei.com>
    parisc: ccio-dma: Add missing iounmap in error path in ccio_probe()

Stefan Roesch <shr@fb.com>
    block: blk_queue_enter() / __bio_queue_enter() must return -EAGAIN for nowait

Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
    drm/i915/guc: Cancel GuC engine busyness worker synchronously

Alan Previn <alan.previn.teres.alexis@intel.com>
    drm/i915/guc: Don't update engine busyness stats too frequently

Ankit Nautiyal <ankit.k.nautiyal@intel.com>
    drm/i915/vdsc: Set VDSC PIC_HEIGHT before using for DP DSC

Sascha Hauer <s.hauer@pengutronix.de>
    drm/rockchip: vop2: Fix eDP/HDMI sync polarities

Stuart Menefy <stuart.menefy@mathembedded.com>
    drm/meson: Fix OSD1 RGB to YCbCr coefficient

Stuart Menefy <stuart.menefy@mathembedded.com>
    drm/meson: Correct OSD1 global alpha value

Chen-Yu Tsai <wenst@chromium.org>
    drm/panel-edp: Fix delays for Innolux N116BCA-EA1

Dan Aloni <dan.aloni@vastdata.com>
    Revert "SUNRPC: Remove unreachable error condition"

Anna Schumaker <Anna.Schumaker@Netapp.com>
    NFSv4.2: Update mode bits after ALLOCATE and DEALLOCATE

Pali Rohár <pali@kernel.org>
    gpio: mpc8xxx: Fix support for IRQ_TYPE_LEVEL_LOW flow_type in mpc85xx

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Turn off open-by-filehandle and NFS re-export for NFSv4.0

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: Fix call completion races with call_decode()

Michael Wu <michael@allwinnertech.com>
    pinctrl: sunxi: Fix name for A100 R_PIO

João H. Spies <jhlspies@gmail.com>
    pinctrl: rockchip: Enhance support for IRQ_TYPE_EDGE_BOTH

Molly Sophia <mollysophia379@gmail.com>
    pinctrl: qcom: sc8180x: Fix wrong pin numbers

Molly Sophia <mollysophia379@gmail.com>
    pinctrl: qcom: sc8180x: Fix gpio_wakeirq_map

Sergey Shtylyov <s.shtylyov@omp.ru>
    of: fdt: fix off-by-one error in unflatten_dt_nodes()


-------------

Diffstat:

 .../bindings/interrupt-controller/apple,aic.yaml   |  2 +-
 Makefile                                           |  4 ++--
 arch/parisc/Kconfig                                | 12 +++++++++-
 block/blk-core.c                                   |  4 ++--
 block/blk-lib.c                                    | 11 ++++++---
 drivers/gpio/gpio-mpc8xxx.c                        |  1 +
 drivers/gpio/gpio-rockchip.c                       |  4 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         | 14 ++++++++---
 drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c             |  9 +++++++-
 drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c             |  9 +++++++-
 drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c             |  9 +++++++-
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c             |  5 ++++
 drivers/gpu/drm/amd/amdgpu/soc15.c                 | 25 --------------------
 drivers/gpu/drm/amd/amdgpu/vega10_ih.c             |  4 ++++
 drivers/gpu/drm/amd/amdgpu/vega20_ih.c             |  4 ++++
 drivers/gpu/drm/i915/display/icl_dsi.c             |  2 ++
 drivers/gpu/drm/i915/display/intel_dp.c            |  1 +
 drivers/gpu/drm/i915/display/intel_vdsc.c          |  1 -
 drivers/gpu/drm/i915/gt/uc/intel_guc.h             |  8 +++++++
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c  | 20 +++++++++++++++-
 drivers/gpu/drm/i915/i915_reg.h                    | 16 ++++++-------
 drivers/gpu/drm/i915/i915_vma.c                    |  3 ++-
 drivers/gpu/drm/meson/meson_plane.c                |  2 +-
 drivers/gpu/drm/meson/meson_viu.c                  |  2 +-
 drivers/gpu/drm/panel/panel-edp.c                  |  3 ++-
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c       |  4 ++++
 drivers/iommu/intel/dmar.c                         |  7 ------
 drivers/iommu/intel/iommu.c                        | 27 ++++++++++++++++++++--
 drivers/of/fdt.c                                   |  2 +-
 drivers/parisc/ccio-dma.c                          |  1 +
 drivers/pinctrl/qcom/pinctrl-sc8180x.c             | 10 ++++----
 drivers/pinctrl/sunxi/pinctrl-sun50i-a100-r.c      |  2 +-
 fs/cifs/connect.c                                  | 11 +++------
 fs/cifs/file.c                                     |  3 +++
 fs/cifs/transport.c                                |  6 +----
 fs/nfs/internal.h                                  | 25 ++++++++++++++++++++
 fs/nfs/nfs42proc.c                                 |  9 ++++++--
 fs/nfs/super.c                                     | 27 ++++++++++++++--------
 fs/nfs/write.c                                     | 25 --------------------
 include/linux/dmar.h                               |  4 +---
 include/linux/of_device.h                          |  5 ++--
 include/net/xfrm.h                                 |  2 ++
 io_uring/io_uring.c                                |  3 ++-
 kernel/cgroup/cgroup-v1.c                          |  2 ++
 net/ipv4/ip_output.c                               |  2 +-
 net/ipv4/tcp_ipv4.c                                |  2 ++
 net/ipv6/tcp_ipv6.c                                |  5 +++-
 net/sunrpc/clnt.c                                  |  3 +++
 net/sunrpc/xprt.c                                  |  8 +++----
 sound/pci/hda/patch_sigmatel.c                     | 24 +++++++++++++++++++
 tools/include/uapi/asm/errno.h                     |  4 ++--
 51 files changed, 263 insertions(+), 135 deletions(-)


