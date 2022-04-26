Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB9D850F3C2
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344545AbiDZI2a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344820AbiDZI1o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:27:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02F43AA7A;
        Tue, 26 Apr 2022 01:23:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53C86B81CFA;
        Tue, 26 Apr 2022 08:23:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D025C385AF;
        Tue, 26 Apr 2022 08:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961429;
        bh=/mg3OaJxQb1kJo3emwMgAR5Qqau7hwdAZDdxhKt2HpE=;
        h=From:To:Cc:Subject:Date:From;
        b=Mf9uoUGCRWcdO3YSpoaa8gs/Yhm/ZUVD4+GhjUl6fUaVDTe2cNv0ds8OFgCr5i+DX
         YfalHJkF2Bt+FdXlb3BpXczmI5ARYiX1Iclv83muITqUEntQZxlXt98sMzHDKrXJnt
         L9YoCy6TUjilfI+zbeal4zrUa032XKdSvx5QA0fA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.9 00/24] 4.9.312-rc1 review
Date:   Tue, 26 Apr 2022 10:20:54 +0200
Message-Id: <20220426081731.370823950@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.312-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.312-rc1
X-KernelTest-Deadline: 2022-04-28T08:17+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.312 release.
There are 24 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.312-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.312-rc1

Khazhismel Kumykov <khazhy@google.com>
    block/compat_ioctl: fix range check in BLKGETSIZE

Theodore Ts'o <tytso@mit.edu>
    ext4: force overhead calculation if the s_overhead_cluster makes no sense

Theodore Ts'o <tytso@mit.edu>
    ext4: fix overhead calculation to account for the reserved gdt blocks

Tadeusz Struk <tadeusz.struk@linaro.org>
    ext4: limit length to bitmap_maxbytes - blocksize in punch_hole

Sergey Matyukevich <sergey.matyukevich@synopsys.com>
    ARC: entry: fix syscall_trace_exit argument

Sasha Neftin <sasha.neftin@intel.com>
    e1000e: Fix possible overflow in LTR decoding

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    ASoC: soc-dapm: fix two incorrect uses of list iterator

Paolo Valerio <pvalerio@redhat.com>
    openvswitch: fix OOB access in reserve_sfa_size()

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    dma: at_xdmac: fix a missing check on list iterator

Zheyu Ma <zheyuma97@gmail.com>
    ata: pata_marvell: Check the 'bmdma_addr' beforing reading

Xiaoke Wang <xkernel.wang@foxmail.com>
    drm/msm/mdp5: check the return of kzalloc()

Borislav Petkov <bp@alien8.de>
    brcmfmac: sdio: Fix undefined behavior due to shift overflowing the constant

David Howells <dhowells@redhat.com>
    cifs: Check the IOCB_DIRECT flag, not O_DIRECT

Hongbin Wang <wh_bin@126.com>
    vxlan: fix error return code in vxlan_fdb_append

Borislav Petkov <bp@suse.de>
    ALSA: usb-audio: Fix undefined behavior due to shift overflowing the constant

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    platform/x86: samsung-laptop: Fix an unsigned comparison which can never be negative

Kees Cook <keescook@chromium.org>
    ARM: vexpress/spc: Avoid negative array index when !SMP

Eric Dumazet <edumazet@google.com>
    netlink: reset network and mac headers in netlink_dump()

Hangbin Liu <liuhangbin@gmail.com>
    net/packet: fix packet_sock xmit return value checking

Miaoqian Lin <linmq006@gmail.com>
    dmaengine: imx-sdma: Fix error checking in sdma_event_remap

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Clear MIDI port active flag after draining

Bob Peterson <rpeterso@redhat.com>
    gfs2: assign rgrp glock before compute_bitstructs

Xiongwei Song <sxwjean@gmail.com>
    mm: page_alloc: fix building error on -Werror=array-compare

Kees Cook <keescook@chromium.org>
    etherdevice: Adjust ether_addr* prototypes to silence -Wstringop-overead


-------------

Diffstat:

 Makefile                                              |  4 ++--
 arch/arc/kernel/entry.S                               |  1 +
 arch/arm/mach-vexpress/spc.c                          |  2 +-
 block/compat_ioctl.c                                  |  2 +-
 drivers/ata/pata_marvell.c                            |  2 ++
 drivers/dma/at_xdmac.c                                | 12 +++++++-----
 drivers/dma/imx-sdma.c                                |  4 ++--
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_plane.c             |  3 +++
 drivers/net/ethernet/intel/e1000e/ich8lan.c           |  4 ++--
 drivers/net/vxlan.c                                   |  4 ++--
 .../net/wireless/broadcom/brcm80211/brcmfmac/sdio.c   |  2 +-
 drivers/platform/x86/samsung-laptop.c                 |  2 --
 fs/cifs/cifsfs.c                                      |  2 +-
 fs/ext4/inode.c                                       | 11 ++++++++++-
 fs/ext4/super.c                                       | 19 +++++++++++++++----
 fs/gfs2/rgrp.c                                        |  9 +++++----
 include/linux/etherdevice.h                           |  5 ++---
 mm/page_alloc.c                                       |  2 +-
 net/netlink/af_netlink.c                              |  7 +++++++
 net/openvswitch/flow_netlink.c                        |  2 +-
 net/packet/af_packet.c                                | 13 +++++++++----
 sound/soc/soc-dapm.c                                  |  6 ++----
 sound/usb/midi.c                                      |  1 +
 sound/usb/usbaudio.h                                  |  2 +-
 24 files changed, 79 insertions(+), 42 deletions(-)


