Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3ACE53759F
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 09:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233695AbiE3HmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 03:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232453AbiE3HmT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 03:42:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 896C118B3E;
        Mon, 30 May 2022 00:42:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A7D1B80C0A;
        Mon, 30 May 2022 07:42:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8279FC385B8;
        Mon, 30 May 2022 07:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653896535;
        bh=+TAeonrN9Usmgvcy5y9tduDfWQ1l4vjy0PzYQpsTPuw=;
        h=From:To:Cc:Subject:Date:From;
        b=hhV+TSxke5PFpoowmalTT79tl+muOCGNJ/hr25nQ7IfLrbyLNsEo5qz74bmy+HRRr
         Teiywatp1DjR5ydAzNRNqjpBVDvoKE8iGDK9X1M1Mws5IEo2b32TSG2QUq2x30Jr8B
         1qFk1mJ4oYJd/nmlF/8plTFeYZyWBy9/lnAdCdls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.18.1
Date:   Mon, 30 May 2022 09:42:11 +0200
Message-Id: <1653896512197141@kroah.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.18.1 kernel.

All users of the 5.18 kernel series must upgrade.

The updated 5.18.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.18.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/sysctl/kernel.rst |    8 
 Makefile                                    |    2 
 arch/alpha/include/asm/timex.h              |    1 
 arch/arm/include/asm/timex.h                |    1 
 arch/ia64/include/asm/timex.h               |    1 
 arch/m68k/include/asm/timex.h               |    2 
 arch/mips/include/asm/timex.h               |   17 
 arch/nios2/include/asm/timex.h              |    3 
 arch/parisc/include/asm/timex.h             |    3 
 arch/powerpc/include/asm/timex.h            |    1 
 arch/riscv/include/asm/timex.h              |    2 
 arch/s390/include/asm/timex.h               |    1 
 arch/sparc/include/asm/timex_32.h           |    4 
 arch/um/include/asm/timex.h                 |    9 
 arch/x86/include/asm/timex.h                |    9 
 arch/x86/include/asm/tsc.h                  |    7 
 arch/xtensa/include/asm/timex.h             |    6 
 drivers/acpi/sysfs.c                        |   25 
 drivers/char/random.c                       | 1213 +++++++++++-----------------
 drivers/hid/amd-sfh-hid/amd_sfh_client.c    |   11 
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c      |    7 
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.h      |    4 
 include/linux/mm.h                          |    1 
 include/linux/prandom.h                     |   23 
 include/linux/random.h                      |   92 --
 include/linux/security.h                    |    2 
 include/linux/siphash.h                     |   28 
 include/linux/timex.h                       |    8 
 init/main.c                                 |   13 
 kernel/debug/debug_core.c                   |   24 
 kernel/debug/kdb/kdb_main.c                 |   62 +
 kernel/time/timekeeping.c                   |   15 
 lib/Kconfig.debug                           |    3 
 lib/siphash.c                               |   32 
 mm/util.c                                   |   32 
 security/security.c                         |    2 
 sound/pci/ctxfi/ctatc.c                     |    2 
 sound/pci/ctxfi/cthardware.h                |    3 
 38 files changed, 820 insertions(+), 859 deletions(-)

Basavaraj Natikar (1):
      HID: amd_sfh: Add support for sensor discovery

Daniel Thompson (1):
      lockdown: also lock down previous kgdb use

Edward Matijevic (1):
      ALSA: ctxfi: Add SB046x PCI ID

Greg Kroah-Hartman (1):
      Linux 5.18.1

Jason A. Donenfeld (40):
      random: fix sysctl documentation nits
      init: call time_init() before rand_initialize()
      ia64: define get_cycles macro for arch-override
      s390: define get_cycles macro for arch-override
      parisc: define get_cycles macro for arch-override
      alpha: define get_cycles macro for arch-override
      powerpc: define get_cycles macro for arch-override
      timekeeping: Add raw clock fallback for random_get_entropy()
      m68k: use fallback for random_get_entropy() instead of zero
      riscv: use fallback for random_get_entropy() instead of zero
      mips: use fallback for random_get_entropy() instead of just c0 random
      arm: use fallback for random_get_entropy() instead of zero
      nios2: use fallback for random_get_entropy() instead of zero
      x86/tsc: Use fallback for random_get_entropy() instead of zero
      um: use fallback for random_get_entropy() instead of zero
      sparc: use fallback for random_get_entropy() instead of zero
      xtensa: use fallback for random_get_entropy() instead of zero
      random: insist on random_get_entropy() existing in order to simplify
      random: do not use batches when !crng_ready()
      random: use first 128 bits of input as fast init
      random: do not pretend to handle premature next security model
      random: order timer entropy functions below interrupt functions
      random: do not use input pool from hard IRQs
      random: help compiler out with fast_mix() by using simpler arguments
      siphash: use one source of truth for siphash permutations
      random: use symbolic constants for crng_init states
      random: avoid initializing twice in credit race
      random: move initialization out of reseeding hot path
      random: remove ratelimiting for in-kernel unseeded randomness
      random: use proper jiffies comparison macro
      random: handle latent entropy and command line from random_init()
      random: credit architectural init the exact amount
      random: use static branch for crng_ready()
      random: remove extern from functions in header
      random: use proper return types on get_random_{int,long}_wait()
      random: make consistent use of buf and len
      random: move initialization functions out of hot pages
      random: move randomize_page() into mm where it belongs
      random: unify batched entropy implementations
      random: check for signals after page of pool writes

Jens Axboe (3):
      random: convert to using fops->read_iter()
      random: convert to using fops->write_iter()
      random: wire up fops->splice_{read,write}_iter()

Lorenzo Pieralisi (1):
      ACPI: sysfs: Fix BERT error region memory mapping

