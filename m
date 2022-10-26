Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE3060DFD0
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 13:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233621AbiJZLk6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 07:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233684AbiJZLj1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 07:39:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122B1D8F60;
        Wed, 26 Oct 2022 04:38:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C760CB821D4;
        Wed, 26 Oct 2022 11:38:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24269C433D6;
        Wed, 26 Oct 2022 11:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666784316;
        bh=GJ0lJ/sQasQIzGcA/Wg5jZJdTRFq+5Z4bQVEy0Jv/Aw=;
        h=From:To:Cc:Subject:Date:From;
        b=2cM64551no9CFubrMxHznNWt5YH6vsiulGSnB29C6A/h5KcQt0zs/cmr/o2y4Ewm0
         V7aUrDTdU9bhRbM1KZDpidmElKx6EOhfdFKXchurhjs4rVuMXkNMXcW0O7vXRdQr8l
         j96NjYNmrZSZlC1R1FpBbnFM5RAs5EKmp9lQIMmk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.0.4
Date:   Wed, 26 Oct 2022 13:38:21 +0200
Message-Id: <1666784302211190@kroah.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 6.0.4 kernel.

All users of the 6.0 kernel series must upgrade.

The updated 6.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.0.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                           |    2 
 drivers/firmware/efi/efi.c                                         |    2 
 drivers/firmware/efi/vars.c                                        |   10 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                         |    8 
 drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_4.h |   17 +
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h                       |    2 
 drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c                  |    8 
 drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c                 |    9 
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c               |   11 +
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c               |   12 +
 drivers/gpu/drm/i915/display/intel_bios.c                          |  106 ++++------
 drivers/hid/hid-ids.h                                              |    1 
 drivers/hid/hid-playstation.c                                      |   46 +++-
 drivers/md/dm-clone-target.c                                       |    2 
 drivers/pinctrl/pinctrl-amd.c                                      |    4 
 drivers/thermal/intel/intel_powerclamp.c                           |    6 
 drivers/video/aperture.c                                           |   30 +-
 drivers/video/fbdev/core/fbmem.c                                   |   48 ----
 fs/efivarfs/vars.c                                                 |   16 -
 include/linux/efi.h                                                |    3 
 include/linux/fb.h                                                 |    2 
 include/linux/net.h                                                |    1 
 io_uring/io-wq.c                                                   |    2 
 io_uring/net.c                                                     |    2 
 kernel/gcov/gcc_4_7.c                                              |   18 +
 net/ipv4/tcp.c                                                     |    1 
 net/ipv4/udp.c                                                     |    1 
 sound/pci/hda/hda_codec.c                                          |   41 +--
 28 files changed, 228 insertions(+), 183 deletions(-)

Ard Biesheuvel (2):
      efi: efivars: Fix variable writes without query_variable_store()
      efi: ssdt: Don't free memory if ACPI table was loaded successfully

Basavaraj Natikar (1):
      pinctrl: amd: change dev_warn to dev_dbg for additional feature support

Evan Quan (3):
      drm/amd/pm: fulfill SMU13.0.7 cstate control interface
      drm/amd/pm: disable cstate feature for gpu reset scenario
      drm/amd/pm: fulfill SMU13.0.0 cstate control interface

Greg Kroah-Hartman (1):
      Linux 6.0.4

Martin Liska (1):
      gcov: support GCC 12.1 and newer compilers

Nikos Tsironis (1):
      dm clone: Fix typo in block_device format specifier

Pavel Begunkov (2):
      io_uring/net: fail zc send when unsupported by socket
      net: flag sockets supporting msghdr originated zerocopy

Rafael J. Wysocki (1):
      thermal: intel_powerclamp: Use first online CPU as control_cpu

Rafael Mendonca (1):
      io-wq: Fix memory leak in worker creation

Roderick Colenbrander (2):
      HID: playstation: stop DualSense output work on remove.
      HID: playstation: add initial DualSense Edge controller support

Takashi Iwai (1):
      Revert "ALSA: hda: Fix page fault in snd_hda_codec_shutdown()"

Thomas Zimmermann (1):
      fbdev/core: Remove remove_conflicting_pci_framebuffers()

Tim Huang (2):
      drm/amd/pm: add SMU IP v13.0.4 IF version define to V7
      drm/amd/pm: update SMU IP v13.0.4 driver interface version

Ville Syrjälä (2):
      drm/i915/bios: Validate fp_timing terminator presence
      drm/i915/bios: Use hardcoded fp_timing size for generating LFP data pointers

