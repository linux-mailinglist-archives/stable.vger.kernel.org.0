Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 598B23124EA
	for <lists+stable@lfdr.de>; Sun,  7 Feb 2021 16:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbhBGPG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Feb 2021 10:06:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:54478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229562AbhBGPGZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Feb 2021 10:06:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6D4764E50;
        Sun,  7 Feb 2021 15:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612710345;
        bh=HLv8wIbLu5JU70rse9lQmZAUlbV66UkkxadVo3+lbIw=;
        h=From:To:Cc:Subject:Date:From;
        b=maYLY4hNPy5RFo6j3Bnedq2ZSFFawD6VuFhjoGpfW3z28EuXjs0ibn0jRQhqEgbq3
         AVjP57UlB2J2UvVQLA9FwPoD7cGRmuZoL5+kV5g5t3U5gNY/jAj+TMf0iX83GPT2Vs
         N0NIXirBbf2rVmfZmytXywwn6XkfcqHOIUh2m/co=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.174
Date:   Sun,  7 Feb 2021 16:05:39 +0100
Message-Id: <161271033911825@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.174 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                      |    2 
 arch/x86/include/asm/msr.h                                    |    4 
 drivers/acpi/thermal.c                                        |   55 ++++++----
 drivers/net/dsa/bcm_sf2.c                                     |    8 +
 drivers/net/ethernet/ibm/ibmvnic.c                            |    6 +
 drivers/phy/motorola/phy-cpcap-usb.c                          |   19 ++-
 drivers/platform/x86/intel-vbtn.c                             |    6 +
 drivers/platform/x86/touchscreen_dmi.c                        |   18 +++
 drivers/scsi/ibmvscsi/ibmvfc.c                                |    4 
 drivers/scsi/libfc/fc_exch.c                                  |   16 ++
 drivers/scsi/scsi_transport_srp.c                             |    9 +
 include/linux/kthread.h                                       |    3 
 kernel/kthread.c                                              |   27 ++++
 kernel/smpboot.c                                              |    1 
 kernel/sysctl.c                                               |   40 +++++++
 kernel/workqueue.c                                            |    9 -
 net/core/gen_estimator.c                                      |   11 +-
 net/mac80211/rx.c                                             |    2 
 tools/objtool/elf.c                                           |    7 -
 tools/testing/selftests/powerpc/alignment/alignment_handler.c |    5 
 20 files changed, 205 insertions(+), 47 deletions(-)

Arnold Gozum (1):
      platform/x86: intel-vbtn: Support for tablet mode on Dell Inspiron 7352

Brian King (1):
      scsi: ibmvfc: Set default timeout to avoid crash during migration

Christian Brauner (1):
      sysctl: handle overflow in proc_get_long

Eric Dumazet (1):
      net_sched: gen_estimator: support large ewma log

Felix Fietkau (1):
      mac80211: fix fast-rx encryption check

Greg Kroah-Hartman (1):
      Linux 4.19.174

Hans de Goede (1):
      platform/x86: touchscreen_dmi: Add swap-x-y quirk for Goodix touchscreen on Estar Beauty HD tablet

Javed Hasan (1):
      scsi: libfc: Avoid invoking response handler twice if ep is already completed

Josh Poimboeuf (1):
      objtool: Don't fail on missing symbol table

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

Tony Lindgren (1):
      phy: cpcap-usb: Fix warning for missing regulator_disable

