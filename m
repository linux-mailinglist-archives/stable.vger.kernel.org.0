Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA9920F570
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 15:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727985AbgF3NLO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 09:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbgF3NLM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 09:11:12 -0400
X-Greylist: delayed 173 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 30 Jun 2020 06:11:11 PDT
Received: from mail.as201155.net (mail.as201155.net [IPv6:2a05:a1c0:f001::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7FB3C061755
        for <stable@vger.kernel.org>; Tue, 30 Jun 2020 06:11:11 -0700 (PDT)
Received: from smtps.newmedia-net.de ([2a05:a1c0:0:de::167]:53846 helo=webmail.newmedia-net.de)
        by mail.as201155.net with esmtps (TLSv1:DHE-RSA-AES256-SHA:256)
        (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <s.gottschall@dd-wrt.com>)
        id 1jqFzf-0002TD-28; Tue, 30 Jun 2020 15:08:11 +0200
X-CTCH-RefID: str=0001.0A782F26.5EFB393B.008B,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dd-wrt.com; s=mikd;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject; bh=mJX9PyIetwuEnGhmCRHKLIbcWXZ6uYql73iirKSXNho=;
        b=HTC8bfARaOoALcPaNNDrEoBUsRE5KBibBa0p0m24JBdZxi+NHPGvWvPkfkDLKeyy+ncXTXYHXRJ5ER4gO/KWtZ69CWcocUTKoFxBBihF5HLNNn9Rs+RguXMf8eJ971f8H7FIoW3KkrnbGpWQu2RajsxiKzNH/xIN4wL+J89l6cY=;
Subject: Re: [PATCH 4.14 00/78] 4.14.186-rc1 review
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org
References: <20200629153806.2494953-1-sashal@kernel.org>
From:   Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <b450ae6a-e5a3-f870-e6bd-c3af0397e7a0@dd-wrt.com>
Date:   Tue, 30 Jun 2020 15:08:08 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0
MIME-Version: 1.0
In-Reply-To: <20200629153806.2494953-1-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Received:  from [2a01:7700:8040:4d00:c41a:a2eb:6429:b0a1]
        by webmail.newmedia-net.de with esmtpsa (TLSv1:AES128-SHA:128)
        (Exim 4.72)
        (envelope-from <s.gottschall@dd-wrt.com>)
        id 1jqFzf-000FPc-0s; Tue, 30 Jun 2020 15:08:11 +0200
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

this patch is broken. 4.14.186 has been already released. the patch 
shows just conflicts

Am 29.06.2020 um 17:36 schrieb Sasha Levin:
> This is the start of the stable review cycle for the 4.14.186 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed 01 Jul 2020 03:38:04 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-4.14.y&id2=v4.14.185
>
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> --
> Thanks,
> Sasha
>
> -------------------------
>
> Pseudo-Shortlog of commits:
>
> Aaron Plattner (1):
>    ALSA: hda: Add NVIDIA codec IDs 9a & 9d through a0 to patch table
>
> Aditya Pakki (1):
>    rocker: fix incorrect error handling in dma_rings_init
>
> Al Cooper (1):
>    xhci: Fix enumeration issue when setting max packet size for FS
>      devices.
>
> Al Viro (1):
>    fix a braino in "sparc32: fix register window handling in
>      genregs32_[gs]et()"
>
> Alexander Lobakin (3):
>    net: qed: fix left elements count calculation
>    net: qed: fix NVMe login fails over VFs
>    net: qed: fix excessive QM ILT lines consumption
>
> Chuck Lever (1):
>    SUNRPC: Properly set the @subbuf parameter of xdr_buf_subsegment()
>
> Chuhong Yuan (1):
>    USB: ohci-sm501: Add missed iounmap() in remove
>
> Dan Carpenter (2):
>    usb: gadget: udc: Potential Oops in error handling code
>    Staging: rtl8723bs: prevent buffer overflow in
>      update_sta_support_rate()
>
> David Christensen (1):
>    tg3: driver sleeps indefinitely when EEH errors exceed eeh_max_freezes
>
> David Howells (2):
>    rxrpc: Fix notification call on completion of discarded calls
>    rxrpc: Fix handling of rwind from an ACK packet
>
> Denis Efremov (1):
>    drm/radeon: fix fb_div check in ni_init_smc_spll_table()
>
> Doug Berger (1):
>    net: bcmgenet: use hardware padding of runt frames
>
> Eric Dumazet (2):
>    net: be more gentle about silly gso requests coming from user
>    tcp: grow window for OOO packets only for SACK flows
>
> Fan Guo (1):
>    RDMA/mad: Fix possible memory leak in ib_mad_post_receive_mads()
>
> Filipe Manana (1):
>    btrfs: fix failure of RWF_NOWAIT write into prealloc extent beyond eof
>
> Jann Horn (1):
>    apparmor: don't try to replace stale label in ptraceme check
>
> Jeremy Kerr (1):
>    net: usb: ax88179_178a: fix packet alignment padding
>
> Jiping Ma (1):
>    arm64: perf: Report the PC value in REGS_ABI_32 mode
>
> Joakim Tjernlund (1):
>    cdc-acm: Add DISABLE_ECHO quirk for Microchip/SMSC chip
>
> Julian Scheel (1):
>    ALSA: usb-audio: uac1: Invalidate ctl on interrupt
>
> Junxiao Bi (3):
>    ocfs2: load global_inode_alloc
>    ocfs2: fix value of OCFS2_INVALID_SLOT
>    ocfs2: fix panic on nfs server over ocfs2
>
> Juri Lelli (1):
>    sched/core: Fix PI boosting between RT and DEADLINE tasks
>
> Kai-Heng Feng (1):
>    xhci: Poll for U0 after disabling USB2 LPM
>
> Longfang Liu (1):
>    USB: ehci: reopen solution for Synopsys HC bug
>
> Luis Chamberlain (1):
>    blktrace: break out of blktrace setup on concurrent calls
>
> Macpaul Lin (1):
>    usb: host: xhci-mtk: avoid runtime suspend when removing hcd
>
> Marcelo Ricardo Leitner (1):
>    sctp: Don't advertise IPv4 addresses if ipv6only is set on the socket
>
> Mark Zhang (1):
>    RDMA/cma: Protect bind_list and listen_list while finding matching cm
>      id
>
> Martin Wilck (1):
>    scsi: scsi_devinfo: handle non-terminated strings
>
> Masahiro Yamada (1):
>    kbuild: improve cc-option to clean up all temporary files
>
> Masami Hiramatsu (1):
>    tracing: Fix event trigger to accept redundant spaces
>
> Mathias Nyman (1):
>    xhci: Fix incorrect EP_STATE_MASK
>
> Matthew Hagan (1):
>    ARM: dts: NSP: Correct FA2 mailbox node
>
> Minas Harutyunyan (1):
>    usb: dwc2: Postponed gadget registration to the udc class driver
>
> Nathan Chancellor (1):
>    ACPI: sysfs: Fix pm_profile_attr type
>
> Neal Cardwell (1):
>    tcp_cubic: fix spurious HYSTART_DELAY exit upon drop in min RTT
>
> Olga Kornievskaia (1):
>    NFSv4 fix CLOSE not waiting for direct IO compeletion
>
> Qiushi Wu (2):
>    efi/esrt: Fix reference count leak in esre_create_sysfs_entry.
>    ASoC: rockchip: Fix a reference count leak.
>
> Russell King (1):
>    netfilter: ipset: fix unaligned atomic access
>
> Sasha Levin (1):
>    Linux 4.14.186-rc1
>
> Sean Christopherson (1):
>    KVM: nVMX: Plumb L2 GPA through to PML emulation
>
> Sven Schnelle (1):
>    s390/ptrace: fix setting syscall number
>
> Taehee Yoo (3):
>    ip_tunnel: fix use-after-free in ip_tunnel_lookup()
>    ip6_gre: fix use-after-free in ip6gre_tunnel_lookup()
>    net: core: reduce recursion limit value
>
> Takashi Iwai (3):
>    ALSA: usb-audio: Clean up mixer element list traverse
>    ALSA: usb-audio: Fix OOB access of mixer element list
>    ALSA: usb-audio: Fix invalid NULL check in snd_emuusb_set_samplerate()
>
> Tang Bin (1):
>    usb: host: ehci-exynos: Fix error check in exynos_ehci_probe()
>
> Tariq Toukan (1):
>    net: Do not clear the sock TX queue in sk_set_socket()
>
> Thomas Falcon (1):
>    ibmveth: Fix max MTU limit
>
> Thomas Martitz (1):
>    net: bridge: enfore alignment for ethernet address
>
> Tomasz Meresiński (1):
>    usb: add USB_QUIRK_DELAY_INIT for Logitech C922
>
> Trond Myklebust (1):
>    pNFS/flexfiles: Fix list corruption if the mirror count changes
>
> Valentin Longchamp (1):
>    net: sched: export __netdev_watchdog_up()
>
> Vasily Averin (1):
>    sunrpc: fixed rollback in rpc_gssd_dummy_populate()
>
> Waiman Long (1):
>    mm/slab: use memzero_explicit() in kzfree()
>
> Wang Hai (1):
>    mld: fix memory leak in ipv6_mc_destroy_dev()
>
> Xiaoyao Li (1):
>    KVM: X86: Fix MSR range of APIC registers in X2APIC mode
>
> Yang Yingliang (1):
>    net: fix memleak in register_netdevice()
>
> Ye Bin (1):
>    ata/libata: Fix usage of page address by page_address in
>      ata_scsi_mode_select_xlat function
>
> Yick W. Tse (1):
>    ALSA: usb-audio: add quirk for Denon DCD-1500RE
>
> Zekun Shen (1):
>    net: alx: fix race condition in alx_remove
>
> Zhang Xiaoxu (2):
>    cifs/smb3: Fix data inconsistent when punch hole
>    cifs/smb3: Fix data inconsistent when zero file range
>
> Zheng Bin (2):
>    loop: replace kill_bdev with invalidate_bdev
>    xfs: add agf freeblocks verify in xfs_agf_verify
>
> guodeqing (1):
>    net: Fix the arp error in some cases
>
> yu kuai (2):
>    block/bio-integrity: don't free 'buf' if bio_integrity_add_page()
>      failed
>    ARM: imx5: add missing put_device() call in imx_suspend_alloc_ocram()
>
>   Makefile                                      |  4 +--
>   arch/arm/boot/dts/bcm-nsp.dtsi                |  6 ++--
>   arch/arm/mach-imx/pm-imx5.c                   |  6 ++--
>   arch/arm64/kernel/perf_regs.c                 | 25 ++++++++++++--
>   arch/s390/kernel/ptrace.c                     | 31 ++++++++++++++++-
>   arch/sparc/kernel/ptrace_32.c                 |  9 +++--
>   arch/x86/include/asm/kvm_host.h               |  2 +-
>   arch/x86/kvm/mmu.c                            |  4 +--
>   arch/x86/kvm/mmu.h                            |  2 +-
>   arch/x86/kvm/paging_tmpl.h                    |  7 ++--
>   arch/x86/kvm/vmx.c                            |  5 ++-
>   arch/x86/kvm/x86.c                            |  4 +--
>   block/bio-integrity.c                         |  1 -
>   drivers/acpi/sysfs.c                          |  4 +--
>   drivers/ata/libata-scsi.c                     |  9 +++--
>   drivers/block/loop.c                          |  6 ++--
>   drivers/firmware/efi/esrt.c                   |  2 +-
>   drivers/gpu/drm/radeon/ni_dpm.c               |  2 +-
>   drivers/infiniband/core/cma.c                 | 18 ++++++++++
>   drivers/infiniband/core/mad.c                 |  1 +
>   drivers/net/ethernet/atheros/alx/main.c       |  9 ++---
>   .../net/ethernet/broadcom/genet/bcmgenet.c    |  8 ++---
>   drivers/net/ethernet/broadcom/tg3.c           |  4 +--
>   drivers/net/ethernet/ibm/ibmveth.c            |  2 +-
>   drivers/net/ethernet/qlogic/qed/qed_cxt.c     |  2 +-
>   drivers/net/ethernet/qlogic/qed/qed_vf.c      | 23 ++++++++++---
>   drivers/net/ethernet/rocker/rocker_main.c     |  4 +--
>   drivers/net/usb/ax88179_178a.c                | 11 +++---
>   drivers/scsi/scsi_devinfo.c                   |  5 +--
>   .../staging/rtl8723bs/core/rtw_wlan_util.c    |  4 ++-
>   drivers/usb/class/cdc-acm.c                   |  2 ++
>   drivers/usb/core/quirks.c                     |  3 +-
>   drivers/usb/dwc2/gadget.c                     |  6 ----
>   drivers/usb/dwc2/platform.c                   | 11 ++++++
>   drivers/usb/gadget/udc/mv_udc_core.c          |  3 +-
>   drivers/usb/host/ehci-exynos.c                |  5 ++-
>   drivers/usb/host/ehci-pci.c                   |  7 ++++
>   drivers/usb/host/ohci-sm501.c                 |  1 +
>   drivers/usb/host/xhci-mtk.c                   |  5 +--
>   drivers/usb/host/xhci.c                       |  4 +++
>   drivers/usb/host/xhci.h                       |  2 +-
>   fs/btrfs/inode.c                              |  3 --
>   fs/cifs/smb2ops.c                             | 12 +++++++
>   fs/nfs/direct.c                               | 13 ++++---
>   fs/nfs/file.c                                 |  1 +
>   fs/nfs/flexfilelayout/flexfilelayout.c        | 11 +++---
>   fs/ocfs2/ocfs2_fs.h                           |  4 +--
>   fs/ocfs2/suballoc.c                           |  9 +++--
>   fs/xfs/libxfs/xfs_alloc.c                     | 16 +++++++++
>   include/linux/netdevice.h                     |  2 +-
>   include/linux/qed/qed_chain.h                 | 26 ++++++++------
>   include/linux/virtio_net.h                    | 17 +++++-----
>   include/net/sctp/constants.h                  |  8 +++--
>   include/net/sock.h                            |  1 -
>   kernel/sched/core.c                           |  3 +-
>   kernel/trace/blktrace.c                       | 13 +++++++
>   kernel/trace/trace_events_trigger.c           | 21 ++++++++++--
>   mm/slab_common.c                              |  2 +-
>   net/bridge/br_private.h                       |  2 +-
>   net/core/dev.c                                |  7 ++++
>   net/core/sock.c                               |  2 ++
>   net/ipv4/fib_semantics.c                      |  2 +-
>   net/ipv4/ip_tunnel.c                          | 14 ++++----
>   net/ipv4/tcp_cubic.c                          |  2 ++
>   net/ipv4/tcp_input.c                          | 12 +++++--
>   net/ipv6/ip6_gre.c                            |  9 +++--
>   net/ipv6/mcast.c                              |  1 +
>   net/netfilter/ipset/ip_set_core.c             |  2 ++
>   net/rxrpc/call_accept.c                       |  7 ++++
>   net/rxrpc/input.c                             |  7 ++--
>   net/sched/sch_generic.c                       |  1 +
>   net/sctp/associola.c                          |  5 ++-
>   net/sctp/bind_addr.c                          |  1 +
>   net/sctp/protocol.c                           |  3 +-
>   net/sunrpc/rpc_pipe.c                         |  1 +
>   net/sunrpc/xdr.c                              |  4 +++
>   scripts/Kbuild.include                        | 11 +++---
>   security/apparmor/lsm.c                       |  4 +--
>   sound/pci/hda/patch_hdmi.c                    |  5 +++
>   sound/soc/rockchip/rockchip_pdm.c             |  4 ++-
>   sound/usb/mixer.c                             | 34 ++++++++++++-------
>   sound/usb/mixer.h                             | 15 ++++++--
>   sound/usb/mixer_quirks.c                      | 11 +++---
>   sound/usb/mixer_scarlett.c                    |  6 ++--
>   sound/usb/quirks.c                            |  1 +
>   85 files changed, 433 insertions(+), 171 deletions(-)
>
