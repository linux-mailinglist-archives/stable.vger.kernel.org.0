Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 027CA4BE0CB
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345225AbiBUIxC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 03:53:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345229AbiBUIwe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 03:52:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DA70B51;
        Mon, 21 Feb 2022 00:52:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC6E76114D;
        Mon, 21 Feb 2022 08:52:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3FAEC340E9;
        Mon, 21 Feb 2022 08:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433530;
        bh=NemhTekKI50YfXIPtZR5rXL0kvDH2915eaXdY4OLlHM=;
        h=From:To:Cc:Subject:Date:From;
        b=DeXWhFHoeD+RkW7N5cQFE3NfzEX2Q+4LjdV4Sahb5MHd4ySjHH170WxSTABcU7ZZw
         Bos0GBqvsqpSTOmj97Nxxk/yWq+qF8ePt/OIRhsM250LkFDSREOSFKtl7CuOSuv+pv
         vYXJGRHS6GSeUI1z2SZ7UB0BgT4ic3RQknC59BzQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.9 00/33] 4.9.303-rc1 review
Date:   Mon, 21 Feb 2022 09:48:53 +0100
Message-Id: <20220221084908.568970525@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.303-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.303-rc1
X-KernelTest-Deadline: 2022-02-23T08:49+00:00
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

This is the start of the stable review cycle for the 4.9.303 release.
There are 33 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.303-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.303-rc1

Slark Xiao <slark_xiao@163.com>
    net: usb: qmi_wwan: Add support for Dell DW5829e

JaeSang Yoo <js.yoo.5b@gmail.com>
    tracing: Fix tp_printk option related with tp_printk_stop_on_boot

Zoltán Böszörményi <zboszor@gmail.com>
    ata: libata-core: Disable TRIM on M88V29

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Do not report writeback errors in nfs_getattr()

Jim Mattson <jmattson@google.com>
    KVM: x86/pmu: Use AMD64_RAW_EVENT_MASK for PERF_TYPE_RAW

Rafał Miłecki <rafal@milecki.pl>
    i2c: brcmstb: fix support for DSL and CM variants

Eliav Farber <farbere@amazon.com>
    EDAC: Fix calculation of returned address and next offset in edac_align_ptr()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: LOOKUP_DIRECTORY is also ok with symlinks

Mark Brown <broonie@kernel.org>
    ASoC: ops: Fix stereo change notifications in snd_soc_put_volsw_range()

Mark Brown <broonie@kernel.org>
    ASoC: ops: Fix stereo change notifications in snd_soc_put_volsw()

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Fix missing codec probe on Shenker Dock 15

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Fix regression on forced probe mask option

Kees Cook <keescook@chromium.org>
    libsubcmd: Fix use-after-free for realloc(..., 0)

Eric Dumazet <edumazet@google.com>
    drop_monitor: fix data-race in dropmon_net_event / trace_napi_poll_hit

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: fix locking when "HW not ready"

Seth Forshee <sforshee@digitalocean.com>
    vsock: remove vsock from connected table when connect is interrupted by a signal

Sunil Muthuswamy <sunilmut@microsoft.com>
    vsock: correct removal of socket from the list

Eric W. Biederman <ebiederm@xmission.com>
    taskstats: Cleanup the use of task->exit_code

Guillaume Nault <gnault@redhat.com>
    xfrm: Don't accidentally set RTO_ONLINK in decode_session4()

Nicholas Bishop <nicholasbishop@google.com>
    drm/radeon: Fix backlight control on iMac 12,1

Darrick J. Wong <djwong@kernel.org>
    quota: make dquot_quota_sync return errors from ->sync_fs

Darrick J. Wong <djwong@kernel.org>
    vfs: make freeze_super abort when sync_filesystem returns error

Duoming Zhou <duoming@zju.edu.cn>
    ax25: improve the incomplete fix to avoid UAF and NPD bugs

Yang Xu <xuyang2018.jy@fujitsu.com>
    selftests/zram: Adapt the situation that /dev/zram0 is being used

Yang Xu <xuyang2018.jy@fujitsu.com>
    selftests/zram01.sh: Fix compression ratio calculation

Yang Xu <xuyang2018.jy@fujitsu.com>
    selftests/zram: Skip max_comp_streams interface on newer kernel

Miquel Raynal <miquel.raynal@bootlin.com>
    net: ieee802154: at86rf230: Stop leaking skb's

Dāvis Mosāns <davispuh@gmail.com>
    btrfs: send: in case of IO error log it

John David Anglin <dave.anglin@bell.net>
    parisc: Fix sglist access in ccio-dma.c

John David Anglin <dave.anglin@bell.net>
    parisc: Fix data TLB miss in sba_unmap_sg

Randy Dunlap <rdunlap@infradead.org>
    serial: parisc: GSC: fix build when IOSAPIC is not set

Jann Horn <jannh@google.com>
    net: usb: ax88179_178a: Fix out-of-bounds accesses in RX fixup

Nathan Chancellor <nathan@kernel.org>
    Makefile.extrawarn: Move -Wunaligned-access to W=1


-------------

Diffstat:

 Makefile                                        |   4 +-
 arch/x86/kvm/pmu.c                              |   2 +-
 drivers/ata/libata-core.c                       |   1 +
 drivers/edac/edac_mc.c                          |   2 +-
 drivers/gpu/drm/radeon/atombios_encoders.c      |   3 +-
 drivers/i2c/busses/i2c-brcmstb.c                |   2 +-
 drivers/net/ieee802154/at86rf230.c              |  13 ++-
 drivers/net/usb/ax88179_178a.c                  |  68 +++++++-----
 drivers/net/usb/qmi_wwan.c                      |   2 +
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c |   3 +-
 drivers/parisc/ccio-dma.c                       |   3 +-
 drivers/parisc/sba_iommu.c                      |   3 +-
 drivers/tty/serial/8250/8250_gsc.c              |   2 +-
 fs/btrfs/send.c                                 |   4 +
 fs/nfs/dir.c                                    |   4 +-
 fs/nfs/inode.c                                  |   7 +-
 fs/quota/dquot.c                                |  11 +-
 fs/super.c                                      |  19 ++--
 kernel/trace/trace.c                            |   4 +
 kernel/tsacct.c                                 |   7 +-
 net/ax25/af_ax25.c                              |   9 +-
 net/core/drop_monitor.c                         |  11 +-
 net/ipv4/xfrm4_policy.c                         |   3 +-
 net/vmw_vsock/af_vsock.c                        |  39 ++-----
 scripts/Makefile.extrawarn                      |   1 +
 sound/pci/hda/hda_intel.c                       |   5 +-
 sound/soc/soc-ops.c                             |  29 +++--
 tools/lib/subcmd/subcmd-util.h                  |  11 +-
 tools/testing/selftests/zram/zram.sh            |  15 +--
 tools/testing/selftests/zram/zram01.sh          |  33 ++----
 tools/testing/selftests/zram/zram02.sh          |   1 -
 tools/testing/selftests/zram/zram_lib.sh        | 134 ++++++++++++++++--------
 32 files changed, 250 insertions(+), 205 deletions(-)


