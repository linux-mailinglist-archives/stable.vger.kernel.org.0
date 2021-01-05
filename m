Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB182EA74B
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 10:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbhAEJ2g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 04:28:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:48850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727881AbhAEJ2f (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Jan 2021 04:28:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B740C2255F;
        Tue,  5 Jan 2021 09:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609838874;
        bh=E5TQKBIk3buErXOP8rrGIMRzXLoNn6Wh7dWgIAPgDik=;
        h=From:To:Cc:Subject:Date:From;
        b=tbAdW64Ng+BPVXi+LD4koXyMPvaDH8XHwNHx9f1HqwyuwPh10Qm17kW9xfjACXkWP
         Bb9gv+wTfzFhNqDmfLsrbo+5qdOypzXDTwuqdKu/EDsxgDwIpcbzY9LLtQixdNZ7n3
         rcE9H0HLCaggw3TrmvgVyv++URav7qQRZaR8xGJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.19 00/29] 4.19.165-rc2 review
Date:   Tue,  5 Jan 2021 10:28:46 +0100
Message-Id: <20210105090818.518271884@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.165-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.165-rc2
X-KernelTest-Deadline: 2021-01-07T09:08+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.165 release.
There are 29 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 07 Jan 2021 09:08:03 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.165-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.165-rc2

Hyeongseok Kim <hyeongseok@gmail.com>
    dm verity: skip verity work if I/O error when system is shutting down

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Clear the full allocated memory at hw_params

Jessica Yu <jeyu@kernel.org>
    module: delay kobject uevent until after module init call

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix a pNFS layout related use-after-free race when freeing the inode

Qinglang Miao <miaoqinglang@huawei.com>
    powerpc: sysdev: add missing iounmap() on error in mpic_msgr_probe()

Jan Kara <jack@suse.cz>
    quota: Don't overflow quota file offsets

Miroslav Benes <mbenes@suse.cz>
    module: set MODULE_STATE_GOING state when a module fails to load

Dinghao Liu <dinghao.liu@zju.edu.cn>
    rtc: sun6i: Fix memleak in sun6i_rtc_clk_init

Boqun Feng <boqun.feng@gmail.com>
    fcntl: Fix potential deadlock in send_sig{io, urg}()

Takashi Iwai <tiwai@suse.de>
    ALSA: rawmidi: Access runtime->avail always in spinlock

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Use bool for snd_seq_queue internal flags

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: gp8psk: initialize stats at power control logic

Anant Thazhemadam <anant.thazhemadam@gmail.com>
    misc: vmw_vmci: fix kernel info-leak by initializing dbells in vmci_ctx_get_chkpt_doorbells()

Rustam Kovhaev <rkovhaev@gmail.com>
    reiserfs: add check for an invalid ih_entry_count

Anant Thazhemadam <anant.thazhemadam@gmail.com>
    Bluetooth: hci_h5: close serdev device and free hu in h5_close

Johan Hovold <johan@kernel.org>
    of: fix linker-section match-table corruption

Damien Le Moal <damien.lemoal@wdc.com>
    null_blk: Fix zone size initialization

Souptick Joarder <jrdr.linux@gmail.com>
    xen/gntdev.c: Mark pages as dirty

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/bitops: Fix possible undefined behaviour with fls() and fls64()

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: reinstate vendor-agnostic check on SPEC_CTRL cpuid bits

Paolo Bonzini <pbonzini@redhat.com>
    KVM: SVM: relax conditions for allowing MSR_IA32_SPEC_CTRL accesses

Petr Vorel <petr.vorel@gmail.com>
    uapi: move constants from <linux/kernel.h> to <linux/const.h>

Jan Kara <jack@suse.cz>
    ext4: don't remount read-only with errors=continue on reboot

Eric Auger <eric.auger@redhat.com>
    vfio/pci: Move dummy_resources_list init in vfio_pci_probe()

Eric Biggers <ebiggers@google.com>
    ubifs: prevent creating duplicate encrypted filenames

Eric Biggers <ebiggers@google.com>
    f2fs: prevent creating duplicate encrypted filenames

Eric Biggers <ebiggers@google.com>
    ext4: prevent creating duplicate encrypted filenames

Eric Biggers <ebiggers@google.com>
    fscrypt: add fscrypt_is_nokey_name()

Kevin Vigor <kvigor@gmail.com>
    md/raid10: initialize r10_bio->read_slot before use.


-------------

Diffstat:

 Makefile                                |  4 +--
 arch/powerpc/include/asm/bitops.h       | 23 ++++++++++++++--
 arch/powerpc/sysdev/mpic_msgr.c         |  2 +-
 arch/x86/kvm/cpuid.h                    | 14 ++++++++++
 arch/x86/kvm/svm.c                      |  9 ++----
 arch/x86/kvm/vmx.c                      |  6 ++--
 drivers/block/null_blk_zoned.c          | 20 +++++++++-----
 drivers/bluetooth/hci_h5.c              |  8 ++++--
 drivers/md/dm-verity-target.c           | 12 +++++++-
 drivers/md/raid10.c                     |  3 +-
 drivers/media/usb/dvb-usb/gp8psk.c      |  2 +-
 drivers/misc/vmw_vmci/vmci_context.c    |  2 +-
 drivers/rtc/rtc-sun6i.c                 |  8 ++++--
 drivers/vfio/pci/vfio_pci.c             |  3 +-
 drivers/xen/gntdev.c                    | 17 ++++++++----
 fs/crypto/hooks.c                       | 10 +++----
 fs/ext4/namei.c                         |  3 ++
 fs/ext4/super.c                         | 14 ++++------
 fs/f2fs/f2fs.h                          |  2 ++
 fs/fcntl.c                              | 10 ++++---
 fs/nfs/nfs4super.c                      |  2 +-
 fs/nfs/pnfs.c                           | 33 ++++++++++++++++++++--
 fs/nfs/pnfs.h                           |  5 ++++
 fs/quota/quota_tree.c                   |  8 +++---
 fs/reiserfs/stree.c                     |  6 ++++
 fs/ubifs/dir.c                          | 17 +++++++++---
 include/linux/fscrypt_notsupp.h         |  5 ++++
 include/linux/fscrypt_supp.h            | 29 +++++++++++++++++++
 include/linux/of.h                      |  1 +
 include/uapi/linux/const.h              |  5 ++++
 include/uapi/linux/ethtool.h            |  2 +-
 include/uapi/linux/kernel.h             |  9 +-----
 include/uapi/linux/lightnvm.h           |  2 +-
 include/uapi/linux/mroute6.h            |  2 +-
 include/uapi/linux/netfilter/x_tables.h |  2 +-
 include/uapi/linux/netlink.h            |  2 +-
 include/uapi/linux/sysctl.h             |  2 +-
 kernel/module.c                         |  6 ++--
 sound/core/pcm_native.c                 |  9 ++++--
 sound/core/rawmidi.c                    | 49 +++++++++++++++++++++++----------
 sound/core/seq/seq_queue.h              |  8 +++---
 41 files changed, 275 insertions(+), 101 deletions(-)


