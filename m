Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCE083A9F6F
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235012AbhFPPiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:38:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:50728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234886AbhFPPhV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:37:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4F7E613C1;
        Wed, 16 Jun 2021 15:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857715;
        bh=m47HLdSAX5GdIAkgYLWPwURJ+VfG6O1irtvdf42U4SE=;
        h=From:To:Cc:Subject:Date:From;
        b=tbcpzyhtMQT18wZMTWfE92WB6TpNz2btcfbaI47A9FrbWDRJEqlmIBk4nwiFe2vMg
         KRb7Mc/W69jTS9ld2Ee4LR9BOdvRMArwCUT+js/q4iiBRubYEpmJmmLI2pVc4a4WVB
         1k6s0ngcQbez+hlTo7uo/BD4rtn28cug8U2gwMC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 00/38] 5.10.45-rc1 review
Date:   Wed, 16 Jun 2021 17:33:09 +0200
Message-Id: <20210616152835.407925718@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.45-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.45-rc1
X-KernelTest-Deadline: 2021-06-18T15:28+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.45 release.
There are 38 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 18 Jun 2021 15:28:19 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.45-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.45-rc1

Zheng Yongjun <zhengyongjun3@huawei.com>
    fib: Return the correct errno code

Zheng Yongjun <zhengyongjun3@huawei.com>
    net: Return the correct errno code

Zheng Yongjun <zhengyongjun3@huawei.com>
    net/x25: Return the correct errno code

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    rtnetlink: Fix missing error code in rtnl_bridge_notify()

Victor Zhao <Victor.Zhao@amd.com>
    drm/amd/amdgpu:save psp ring wptr to avoid attack

Roman Li <roman.li@amd.com>
    drm/amd/display: Fix potential memory leak in DMUB hw_init

Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
    drm/amd/display: Fix overlay validation by considering cursors

Jiansong Chen <Jiansong.Chen@amd.com>
    drm/amdgpu: refine amdgpu_fru_get_product_info

Bindu Ramamurthy <bindu.r@amd.com>
    drm/amd/display: Allow bandwidth validation for 0 streams.

Josh Triplett <josh@joshtriplett.org>
    net: ipconfig: Don't override command-line hostnames or domains

Hannes Reinecke <hare@suse.de>
    nvme-loop: do not warn for deleted controllers during reset

Hannes Reinecke <hare@suse.de>
    nvme-loop: check for NVME_LOOP_Q_LIVE in nvme_loop_destroy_admin_queue()

Hannes Reinecke <hare@suse.de>
    nvme-loop: clear NVME_LOOP_Q_LIVE when nvme_loop_configure_admin_queue() fails

Hannes Reinecke <hare@suse.de>
    nvme-loop: reset queue count to 1 in nvme_loop_destroy_io_queues()

Ewan D. Milne <emilne@redhat.com>
    scsi: scsi_devinfo: Add blacklist entry for HPE OPEN-V

Larry Finger <Larry.Finger@lwfinger.net>
    Bluetooth: Add a new USB ID for RTL8822CE

Daniel Wagner <dwagner@suse.de>
    scsi: qedf: Do not put host in qedf_vport_create() unconditionally

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    ethernet: myri10ge: Fix missing error code in myri10ge_probe()

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: core: Fix warning on realtime kernels

Hillf Danton <hdanton@sina.com>
    gfs2: Fix use-after-free in gfs2_glock_shrink_scan

Khem Raj <raj.khem@gmail.com>
    riscv: Use -mno-relax when using lld linker

Bixuan Cui <cuibixuan@huawei.com>
    HID: gt683r: add missing MODULE_DEVICE_TABLE

Bob Peterson <rpeterso@redhat.com>
    gfs2: fix a deadlock on withdraw-during-mount

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Prevent direct-I/O write fallback errors from getting lost

Yongqiang Liu <liuyongqiang13@huawei.com>
    ARM: OMAP2+: Fix build warning when mmc_omap is not built

Maciej Falkowski <maciej.falkowski9@gmail.com>
    ARM: OMAP1: Fix use of possibly uninitialized irq variable

Thierry Reding <treding@nvidia.com>
    drm/tegra: sor: Fully initialize SOR before registration

Thierry Reding <treding@nvidia.com>
    gpu: host1x: Split up client initalization and registration

Pavel Machek (CIP) <pavel@denx.de>
    drm/tegra: sor: Do not leak runtime PM reference

Anirudh Rayabharam <mail@anirudhrb.com>
    HID: usbhid: fix info leak in hid_submit_ctrl

Mark Bolhuis <mark@bolhuis.dev>
    HID: Add BUS_VIRTUAL to hid_connect logging

Ahelenia Ziemiańska <nabijaczleweli@nabijaczleweli.xyz>
    HID: multitouch: set Stylus suffix for Stylus-application devices, too

Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
    HID: quirks: Add quirk for Lenovo optical mouse

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    HID: hid-sensor-hub: Return error for hid_set_field() failure

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: hid-input: add mapping for emoji picker key

Mateusz Jończyk <mat.jonczyk@o2.pl>
    HID: a4tech: use A4_2WHEEL_MOUSE_HACK_B8 for A4TECH NB-95

Nirenjan Krishnan <nirenjan@gmail.com>
    HID: quirks: Set INCREMENT_USAGE_ON_DUPLICATE for Saitek X65

Dan Robertson <dan@dlrobertson.com>
    net: ieee802154: fix null deref in parse dev addr


-------------

Diffstat:

 Makefile                                           |  4 +--
 arch/arm/mach-omap1/pm.c                           | 10 ++++--
 arch/arm/mach-omap2/board-n8x0.c                   |  2 +-
 arch/riscv/Makefile                                |  9 +++++
 drivers/bluetooth/btusb.c                          |  2 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c     | 42 ++++++++++++----------
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h            |  1 +
 drivers/gpu/drm/amd/amdgpu/psp_v11_0.c             |  3 +-
 drivers/gpu/drm/amd/amdgpu/psp_v3_1.c              |  3 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  | 14 ++++++--
 .../gpu/drm/amd/display/dc/dcn20/dcn20_resource.c  |  2 +-
 drivers/gpu/drm/tegra/sor.c                        | 41 +++++++++++----------
 drivers/gpu/host1x/bus.c                           | 30 ++++++++++++----
 drivers/hid/Kconfig                                |  4 +--
 drivers/hid/hid-a4tech.c                           |  2 ++
 drivers/hid/hid-core.c                             |  3 ++
 drivers/hid/hid-debug.c                            |  1 +
 drivers/hid/hid-gt683r.c                           |  1 +
 drivers/hid/hid-ids.h                              |  3 ++
 drivers/hid/hid-input.c                            |  3 ++
 drivers/hid/hid-multitouch.c                       |  8 ++---
 drivers/hid/hid-quirks.c                           |  3 ++
 drivers/hid/hid-sensor-hub.c                       | 13 ++++---
 drivers/hid/usbhid/hid-core.c                      |  2 +-
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |  1 +
 drivers/nvme/target/loop.c                         | 11 ++++--
 drivers/scsi/qedf/qedf_main.c                      | 20 +++++------
 drivers/scsi/scsi_devinfo.c                        |  1 +
 drivers/target/target_core_transport.c             |  4 +--
 fs/gfs2/file.c                                     |  5 ++-
 fs/gfs2/glock.c                                    | 26 +++++++++++---
 include/linux/hid.h                                |  3 +-
 include/linux/host1x.h                             | 30 ++++++++++++----
 include/uapi/linux/input-event-codes.h             |  1 +
 net/compat.c                                       |  2 +-
 net/core/fib_rules.c                               |  2 +-
 net/core/rtnetlink.c                               |  4 ++-
 net/ieee802154/nl802154.c                          |  9 ++---
 net/ipv4/ipconfig.c                                | 13 ++++---
 net/x25/af_x25.c                                   |  2 +-
 40 files changed, 231 insertions(+), 109 deletions(-)


