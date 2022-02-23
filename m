Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB5D64C1256
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 13:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234367AbiBWMHR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 07:07:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232761AbiBWMHR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 07:07:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD7049683;
        Wed, 23 Feb 2022 04:06:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ABB95B80E5B;
        Wed, 23 Feb 2022 12:06:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4FB5C340E7;
        Wed, 23 Feb 2022 12:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645618006;
        bh=ooxSRUQtELh/HskwRUHM3oFrIGYQoXX8M+PQygRCPvc=;
        h=From:To:Cc:Subject:Date:From;
        b=2ukO6CilyYJ/SwrzexBTQOy/M9iuAyrbq2SoPYLpXGwteNy7QAPHkdJAs93dZT24g
         aBrOXh+tK0fm6tS9SVsX9Vn/CJHLDP+kqDguElzH8VVjxAwiSroU0UEIQKhucrTR4o
         SwWjqN5MQaueIKbgiUAJWn2tRBfdLDovrWfsQdME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.303
Date:   Wed, 23 Feb 2022 13:06:42 +0100
Message-Id: <1645618002181169@kroah.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.303 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                        |    2 
 arch/x86/kvm/pmu.c                              |    2 
 drivers/ata/libata-core.c                       |    1 
 drivers/edac/edac_mc.c                          |    2 
 drivers/gpu/drm/radeon/atombios_encoders.c      |    3 
 drivers/i2c/busses/i2c-brcmstb.c                |    2 
 drivers/net/ieee802154/at86rf230.c              |   13 +-
 drivers/net/usb/ax88179_178a.c                  |   68 ++++++------
 drivers/net/usb/qmi_wwan.c                      |    2 
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c |    3 
 drivers/parisc/ccio-dma.c                       |    3 
 drivers/parisc/sba_iommu.c                      |    3 
 drivers/tty/serial/8250/8250_gsc.c              |    2 
 fs/btrfs/send.c                                 |    4 
 fs/nfs/dir.c                                    |    4 
 fs/nfs/inode.c                                  |    9 -
 fs/quota/dquot.c                                |   11 +
 fs/super.c                                      |   19 ++-
 kernel/trace/trace.c                            |    4 
 kernel/tsacct.c                                 |    7 -
 lib/iov_iter.c                                  |    2 
 net/ax25/af_ax25.c                              |    9 +
 net/core/drop_monitor.c                         |   11 +
 net/ipv4/xfrm4_policy.c                         |    3 
 net/vmw_vsock/af_vsock.c                        |   39 +-----
 scripts/Makefile.extrawarn                      |    1 
 sound/pci/hda/hda_intel.c                       |    5 
 sound/soc/soc-ops.c                             |   29 +++--
 tools/lib/subcmd/subcmd-util.h                  |   11 -
 tools/testing/selftests/zram/zram.sh            |   15 --
 tools/testing/selftests/zram/zram01.sh          |   33 +----
 tools/testing/selftests/zram/zram02.sh          |    1 
 tools/testing/selftests/zram/zram_lib.sh        |  134 +++++++++++++++---------
 33 files changed, 252 insertions(+), 205 deletions(-)

Darrick J. Wong (2):
      vfs: make freeze_super abort when sync_filesystem returns error
      quota: make dquot_quota_sync return errors from ->sync_fs

Duoming Zhou (1):
      ax25: improve the incomplete fix to avoid UAF and NPD bugs

Dāvis Mosāns (1):
      btrfs: send: in case of IO error log it

Eliav Farber (1):
      EDAC: Fix calculation of returned address and next offset in edac_align_ptr()

Eric Dumazet (1):
      drop_monitor: fix data-race in dropmon_net_event / trace_napi_poll_hit

Eric W. Biederman (1):
      taskstats: Cleanup the use of task->exit_code

Greg Kroah-Hartman (1):
      Linux 4.9.303

Guillaume Nault (1):
      xfrm: Don't accidentally set RTO_ONLINK in decode_session4()

JaeSang Yoo (1):
      tracing: Fix tp_printk option related with tp_printk_stop_on_boot

Jann Horn (1):
      net: usb: ax88179_178a: Fix out-of-bounds accesses in RX fixup

Jim Mattson (1):
      KVM: x86/pmu: Use AMD64_RAW_EVENT_MASK for PERF_TYPE_RAW

Johannes Berg (1):
      iwlwifi: pcie: fix locking when "HW not ready"

John David Anglin (2):
      parisc: Fix data TLB miss in sba_unmap_sg
      parisc: Fix sglist access in ccio-dma.c

Kees Cook (1):
      libsubcmd: Fix use-after-free for realloc(..., 0)

Mark Brown (2):
      ASoC: ops: Fix stereo change notifications in snd_soc_put_volsw()
      ASoC: ops: Fix stereo change notifications in snd_soc_put_volsw_range()

Max Kellermann (1):
      lib/iov_iter: initialize "flags" in new pipe_buffer

Miquel Raynal (1):
      net: ieee802154: at86rf230: Stop leaking skb's

Nathan Chancellor (1):
      Makefile.extrawarn: Move -Wunaligned-access to W=1

Nicholas Bishop (1):
      drm/radeon: Fix backlight control on iMac 12,1

Rafał Miłecki (1):
      i2c: brcmstb: fix support for DSL and CM variants

Randy Dunlap (1):
      serial: parisc: GSC: fix build when IOSAPIC is not set

Seth Forshee (1):
      vsock: remove vsock from connected table when connect is interrupted by a signal

Slark Xiao (1):
      net: usb: qmi_wwan: Add support for Dell DW5829e

Sunil Muthuswamy (1):
      vsock: correct removal of socket from the list

Takashi Iwai (2):
      ALSA: hda: Fix regression on forced probe mask option
      ALSA: hda: Fix missing codec probe on Shenker Dock 15

Trond Myklebust (2):
      NFS: LOOKUP_DIRECTORY is also ok with symlinks
      NFS: Do not report writeback errors in nfs_getattr()

Yang Xu (3):
      selftests/zram: Skip max_comp_streams interface on newer kernel
      selftests/zram01.sh: Fix compression ratio calculation
      selftests/zram: Adapt the situation that /dev/zram0 is being used

Zoltán Böszörményi (1):
      ata: libata-core: Disable TRIM on M88V29

