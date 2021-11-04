Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299824454C2
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 15:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbhKDOR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 10:17:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:45658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231760AbhKDORI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 10:17:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 760956120E;
        Thu,  4 Nov 2021 14:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636035269;
        bh=8gF1ytMAlSbNADtEh0Ln9jSLFrzuCedBjtVmYNAc3J8=;
        h=From:To:Cc:Subject:Date:From;
        b=kSHk4mSdeHOHVh/j7tIIH/PLhlzuHkizeCDK0+9W9qrwo8U7tu+V9a+fhJa+ivA8H
         lUtXgU8d2NU5qhzh2WoGOCKh9oaX03KxApIeGInqMCxh5a9BCcOXtMBhNNUWavxDCq
         uOgMR0cbNoND9oGa8pCwMSRYnwm0/deWvvlM0nzQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.14 00/16] 5.14.17-rc1 review
Date:   Thu,  4 Nov 2021 15:12:31 +0100
Message-Id: <20211104141159.863820939@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.17-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.14.17-rc1
X-KernelTest-Deadline: 2021-11-06T14:12+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.14.17 release.
There are 16 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 06 Nov 2021 14:11:51 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.17-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.14.17-rc1

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add Audient iD14 to mixer map quirk table

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add Schiit Hel device to mixer map quirk table

Matthew Brost <matthew.brost@intel.com>
    Revert "drm/i915/gt: Propagate change in error status to children on unhold"

Anson Jacob <Anson.Jacob@amd.com>
    drm/amd/display: Revert "Directly retrain link from debugfs"

Christian König <christian.koenig@amd.com>
    drm/amdgpu: revert "Add autodump debugfs node for gpu reset v8"

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    Revert "wcn36xx: Disable bmps when encryption is disabled"

Wang Kefeng <wangkefeng.wang@huawei.com>
    ARM: 9120/1: Revert "amba: make use of -1 IRQs warn"

Lucas Stach <l.stach@pengutronix.de>
    Revert "soc: imx: gpcv2: move reset assert after requesting domain power up"

José Roberto de Souza <jose.souza@intel.com>
    drm/i915: Remove memory frequency calculation

Yifan Zhang <yifan1.zhang@amd.com>
    drm/amdkfd: fix boot failure when iommu is disabled in Picasso.

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "usb: core: hcd: Add support for deferring roothub registration"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "xhci: Set HCD flag to defer primary roothub registration"

Dan Carpenter <dan.carpenter@oracle.com>
    media: firewire: firedtv-avc: fix a buffer overflow in avc_ca_pmt()

Eugene Crosser <crosser@average.org>
    vrf: Revert "Reset skb conntrack connection..."

Erik Ekman <erik@kryo.se>
    sfc: Fix reading non-legacy supported link modes

Ming Lei <ming.lei@redhat.com>
    scsi: core: Put LLD module refcnt after SCSI device is released


-------------

Diffstat:

 Makefile                                           |  4 +-
 drivers/amba/bus.c                                 |  3 -
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                |  2 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        | 80 ----------------------
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.h        |  5 --
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  8 ---
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |  3 +
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c  |  3 +-
 .../gpu/drm/i915/gt/intel_execlists_submission.c   |  4 --
 drivers/gpu/drm/i915/i915_reg.h                    |  8 ---
 drivers/gpu/drm/i915/intel_dram.c                  | 30 +-------
 drivers/media/firewire/firedtv-avc.c               | 14 +++-
 drivers/media/firewire/firedtv-ci.c                |  2 +
 drivers/net/ethernet/sfc/ethtool_common.c          | 10 +--
 drivers/net/vrf.c                                  |  4 --
 drivers/net/wireless/ath/wcn36xx/main.c            | 10 ---
 drivers/net/wireless/ath/wcn36xx/pmc.c             |  5 +-
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h         |  1 -
 drivers/scsi/scsi.c                                |  4 +-
 drivers/scsi/scsi_sysfs.c                          |  9 +++
 drivers/soc/imx/gpcv2.c                            |  4 +-
 drivers/usb/core/hcd.c                             | 29 ++------
 drivers/usb/host/xhci.c                            |  1 -
 include/linux/usb/hcd.h                            |  2 -
 sound/usb/mixer_maps.c                             |  8 +++
 25 files changed, 53 insertions(+), 200 deletions(-)


