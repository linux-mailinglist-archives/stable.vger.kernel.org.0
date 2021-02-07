Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE66B3124F2
	for <lists+stable@lfdr.de>; Sun,  7 Feb 2021 16:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbhBGPH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Feb 2021 10:07:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:54596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229851AbhBGPHA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Feb 2021 10:07:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01AD164E43;
        Sun,  7 Feb 2021 15:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612710356;
        bh=hvdVPmFXtz1yYugMS32Sniazh5RrmlltUwfZ/GdKW2g=;
        h=From:To:Cc:Subject:Date:From;
        b=tT3kf29yuHQovCKcBf5HjfjQHR5aNhvGeT0YdWLFpCiQobHto4D9pYq9Puu7pAHlA
         rf5alihOd4EtRf78hS/mmbvVEnwfEzgNotfntSqSdf1jt0Tc+gfR53ZPgHKvJyy+2V
         UNLMTf8l1X8sbpVsFQzPJUIkXpjZM0WhHz3Wxe3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.96
Date:   Sun,  7 Feb 2021 16:05:43 +0100
Message-Id: <16127103446824@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.96 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                      |    2 
 arch/arm64/include/asm/memory.h                               |   10 
 arch/arm64/mm/physaddr.c                                      |    2 
 arch/x86/include/asm/msr.h                                    |    4 
 block/blk-core.c                                              |   11 
 drivers/acpi/thermal.c                                        |   55 ++-
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c              |    3 
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c         |    2 
 drivers/net/dsa/bcm_sf2.c                                     |    8 
 drivers/net/ethernet/ibm/ibmvnic.c                            |    6 
 drivers/nvme/host/core.c                                      |   17 -
 drivers/phy/motorola/phy-cpcap-usb.c                          |   19 -
 drivers/platform/x86/intel-vbtn.c                             |    6 
 drivers/platform/x86/touchscreen_dmi.c                        |   18 +
 drivers/scsi/fnic/vnic_dev.c                                  |    8 
 drivers/scsi/ibmvscsi/ibmvfc.c                                |    4 
 drivers/scsi/libfc/fc_exch.c                                  |   16 -
 drivers/scsi/scsi_transport_srp.c                             |    9 
 fs/btrfs/backref.c                                            |  157 ++++++----
 fs/udf/super.c                                                |    7 
 include/linux/kthread.h                                       |    3 
 include/net/tcp.h                                             |    1 
 kernel/kthread.c                                              |   27 +
 kernel/smpboot.c                                              |    1 
 kernel/workqueue.c                                            |    9 
 net/core/gen_estimator.c                                      |   11 
 net/ipv4/tcp_input.c                                          |    1 
 net/ipv4/tcp_output.c                                         |    2 
 net/ipv4/tcp_timer.c                                          |   18 +
 net/mac80211/rx.c                                             |    2 
 net/switchdev/switchdev.c                                     |   23 -
 sound/pci/hda/hda_intel.c                                     |    3 
 sound/soc/sof/intel/hda-codec.c                               |    3 
 tools/objtool/elf.c                                           |    7 
 tools/testing/selftests/powerpc/alignment/alignment_handler.c |    5 
 35 files changed, 347 insertions(+), 133 deletions(-)

Arnold Gozum (1):
      platform/x86: intel-vbtn: Support for tablet mode on Dell Inspiron 7352

Bing Guo (1):
      drm/amd/display: Change function decide_dp_link_settings to avoid infinite looping

Brian King (1):
      scsi: ibmvfc: Set default timeout to avoid crash during migration

Catalin Marinas (1):
      arm64: Do not pass tagged addresses to __is_lm_address()

Dinghao Liu (1):
      scsi: fnic: Fix memleak in vnic_dev_init_devcmd2

Enke Chen (1):
      tcp: make TCP_USER_TIMEOUT accurate for zero window probes

Eric Dumazet (1):
      net_sched: gen_estimator: support large ewma log

Felix Fietkau (1):
      mac80211: fix fast-rx encryption check

Greg Kroah-Hartman (2):
      Revert "Revert "block: end bio with BLK_STS_AGAIN in case of non-mq devs and REQ_NOWAIT""
      Linux 5.4.96

Hans de Goede (1):
      platform/x86: touchscreen_dmi: Add swap-x-y quirk for Goodix touchscreen on Estar Beauty HD tablet

Jake Wang (1):
      drm/amd/display: Update dram_clock_change_latency for DCN2.1

Javed Hasan (1):
      scsi: libfc: Avoid invoking response handler twice if ep is already completed

Josh Poimboeuf (1):
      objtool: Don't fail on missing symbol table

Kai-Chuan Hsieh (1):
      ALSA: hda: Add Cometlake-R PCI ID

Kai-Heng Feng (1):
      ASoC: SOF: Intel: hda: Resume codec to do jack detection

Lijun Pan (1):
      ibmvnic: Ensure that CRQ entry read are correctly ordered

Martin Wilck (1):
      scsi: scsi_transport_srp: Don't block target in failfast state

Michael Ellerman (1):
      selftests/powerpc: Only test lwm/stmw on big endian

Pan Bian (1):
      net: dsa: bcm_sf2: put device node before return

Peter Zijlstra (3):
      x86: __always_inline __{rd,wr}msr()
      kthread: Extract KTHREAD_IS_PER_CPU
      workqueue: Restrict affinity change to rescuer

Rafael J. Wysocki (1):
      ACPI: thermal: Do not call acpi_thermal_check() directly

Rasmus Villemoes (1):
      net: switchdev: don't set port_obj_info->handled true when -EOPNOTSUPP

Revanth Rajashekar (1):
      nvme: check the PRINFO bit before deciding the host buffer length

Tony Lindgren (1):
      phy: cpcap-usb: Fix warning for missing regulator_disable

Vincenzo Frascino (1):
      arm64: Fix kernel address detection of __is_lm_address()

ethanwu (4):
      btrfs: backref, only collect file extent items matching backref offset
      btrfs: backref, don't add refs from shared block when resolving normal backref
      btrfs: backref, only search backref entries from leaves of the same root
      btrfs: backref, use correct count to resolve normal data refs

lianzhi chang (1):
      udf: fix the problem that the disc content is not displayed

