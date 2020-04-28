Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B29261BCB3F
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729682AbgD1Sbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:31:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:47026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729678AbgD1Sba (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:31:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C92420B80;
        Tue, 28 Apr 2020 18:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098687;
        bh=L/C41QQa9jM32dzN3Z+PmFnXwkUPJTPHhzzPobM+gEY=;
        h=From:To:Cc:Subject:Date:From;
        b=2S18Ph0tYHc6Hbsqa2b5naJR7U8zIK4Bh5qHlDfzrJjGD0JxW44ATZvGGYrnThrij
         HeAXpzNd6pT3rvnfOV35Kr2KcmaE+p6HsZ5QN9qYAvFT4UptsEB0ijQ/B5n4dpEQOD
         8R/zJc+aJwdo0W/3KMA74VZQ1lfkrFkLO7Fzyr48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.4 000/168] 5.4.36-rc1 review
Date:   Tue, 28 Apr 2020 20:22:54 +0200
Message-Id: <20200428182231.704304409@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.36-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.36-rc1
X-KernelTest-Deadline: 2020-04-30T18:22+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.36 release.
There are 168 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 30 Apr 2020 18:21:07 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.36-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.36-rc1

Christian Borntraeger <borntraeger@de.ibm.com>
    s390/mm: fix page table upgrade vs 2ndary address mode accesses

Arnd Bergmann <arnd@arndb.de>
    compat: ARM64: always include asm-generic/compat.h

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/mm: Fix CONFIG_PPC_KUAP_DEBUG on PPC32

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/kuap: PPC_KUAP_DEBUG should depend on PPC_KUAP

Michal Simek <michal.simek@xilinx.com>
    Revert "serial: uartps: Register own uart console and driver structures"

Michal Simek <michal.simek@xilinx.com>
    Revert "serial: uartps: Move Port ID to device data structure"

Michal Simek <michal.simek@xilinx.com>
    Revert "serial: uartps: Change uart ID port allocation"

Michal Simek <michal.simek@xilinx.com>
    Revert "serial: uartps: Do not allow use aliases >= MAX_UART_INSTANCES"

Michal Simek <michal.simek@xilinx.com>
    Revert "serial: uartps: Fix error path when alloc failed"

Michal Simek <michal.simek@xilinx.com>
    Revert "serial: uartps: Use the same dynamic major number for all ports"

Michal Simek <michal.simek@xilinx.com>
    Revert "serial: uartps: Fix uartps_major handling"

Kazuhiro Fujita <kazuhiro.fujita.jg@renesas.com>
    serial: sh-sci: Make sure status register SCxSR is read in correct sequence

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Don't clear hub TT buffer on ep0 protocol stall

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: prevent bus suspend if a roothub port detected a over-current condition

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Fix handling halted endpoint even if endpoint ring appears empty

Naoki Kiryu <naonaokiryu2@gmail.com>
    usb: typec: altmode: Fix typec_altmode_get_partner sometimes returning an invalid pointer

Badhri Jagan Sridharan <badhri@google.com>
    usb: typec: tcpm: Ignore CC and vbus changes in PORT_RESET change

Udipto Goswami <ugoswami@codeaurora.org>
    usb: f_fs: Clear OS Extended descriptor counts to zero in ffs_data_reset()

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Fix request completion check

Xu Yilun <yilun.xu@intel.com>
    fpga: dfl: pci: fix return value of cci_pci_sriov_configure

Oliver Neukum <oneukum@suse.com>
    UAS: fix deadlock in error handling and PM flushing work

Oliver Neukum <oneukum@suse.com>
    UAS: no use logging any details in case of ENODEV

Oliver Neukum <oneukum@suse.com>
    cdc-acm: introduce a cool down

Oliver Neukum <oneukum@suse.com>
    cdc-acm: close race betrween suspend() and acm_softint

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: Power save stop wake_up_count wrap around.

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: Fix pairwise key entry save.

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: Fix drivers TBTT timing counter.

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: Fix calling conditions of vnt_set_bss_mode

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: Don't set RCR_MULTICAST or RCR_BROADCAST by default.

Nicolas Pitre <nico@fluxnic.net>
    vt: don't use kmalloc() for the unicode screen buffer

Nicolas Pitre <nico@fluxnic.net>
    vt: don't hardcode the mem allocation upper bound

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    staging: comedi: Fix comedi_device refcnt leak in comedi_open

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: dt2815: fix writing hi byte of analog output

Chris Packham <chris.packham@alliedtelesis.co.nz>
    powerpc/setup_64: Set cache-line-size based on cache-block-size

Ahmad Fatoum <a.fatoum@pengutronix.de>
    ARM: imx: provide v7_cpu_resume() only on ARM_CPU_SUSPEND=y

Paulo Alcantara <pc@cjr.nz>
    cifs: fix uninitialised lease_key in open_shroot()

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: fix inactive TID removal return value usage

Ilan Peer <ilan.peer@intel.com>
    iwlwifi: mvm: Do not declare support for ACK Enabled Aggregation

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: limit maximum queue appropriately

Mordechay Goodstein <mordechay.goodstein@intel.com>
    iwlwifi: mvm: beacon statistics shouldn't go backwards

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: actually release queue memory in TVQM

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Fix backchannel RPC soft lockups

Johannes Berg <johannes.berg@intel.com>
    mac80211: populate debugfs only after cfg80211 init

Gyeongtaek Lee <gt82.lee@samsung.com>
    ASoC: dapm: fixup dapm kcontrol widget

Paul Moore <paul@paul-moore.com>
    audit: check the length of userspace generated audit records

Eric W. Biederman <ebiederm@xmission.com>
    signal: Avoid corrupting si_pid and si_uid in do_notify_parent

Alan Stern <stern@rowland.harvard.edu>
    usb-storage: Add unusual_devs entry for JMicron JMS566

Jiri Slaby <jslaby@suse.cz>
    tty: rocket, avoid OOB access

Andrew Melnychenko <andrew@daynix.com>
    tty: hvc: fix buffer overflow during hvc_alloc().

Uros Bizjak <ubizjak@gmail.com>
    KVM: VMX: Enable machine check support for 32bit targets

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: Check validity of resolved slot when searching memslots

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: s390: Return last valid slot if approx index is out-of-bounds

George Wilson <gcwilson@linux.ibm.com>
    tpm: ibmvtpm: retry on H_CLOSED in tpm_ibmvtpm_send()

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    tpm: fix wrong return value in tpm_pcr_extend

Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
    tpm/tpm_tis: Free IRQ if probing fails

Alexander Tsoy <alexander@tsoy.me>
    ALSA: usb-audio: Filter out unsupported sample rates on Focusrite devices

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    ALSA: usb-audio: Fix usb audio refcnt leak when getting spdif

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/hdmi: Add module option to disable audio component binding

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add new codec supported for ALC245

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek - Fix unexpected init_amp override

Takashi Iwai <tiwai@suse.de>
    ALSA: usx2y: Fix potential NULL dereference

Lucas Stach <l.stach@pengutronix.de>
    tools/vm: fix cross-compile build

Muchun Song <songmuchun@bytedance.com>
    mm/ksm: fix NULL pointer dereference when KSM zero page is enabled

Longpeng <longpeng2@huawei.com>
    mm/hugetlb: fix a addressing exception caused by huge_pte_offset

Sudip Mukherjee <sudipm.mukherjee@gmail.com>
    coredump: fix null pointer dereference on coredump

Luis Mendes <luis.p.mendes@gmail.com>
    staging: gasket: Fix incongruency in handling of sysfs entries creation

Jann Horn <jannh@google.com>
    vmalloc: fix remap_vmalloc_range() bounds checks

Amit Singh Tomar <amittomer25@gmail.com>
    tty: serial: owl: add "much needed" clk_prepare_enable()

Alan Stern <stern@rowland.harvard.edu>
    USB: hub: Revert commit bd0e6c9614b9 ("usb: hub: try old enumeration scheme first for high speed devices")

Alan Stern <stern@rowland.harvard.edu>
    USB: hub: Fix handling of connect changes during sleep

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Fix free-while-in-use bug in the USB S-Glibrary

Jann Horn <jannh@google.com>
    USB: early: Handle AMD's spec-compliant identifiers, too

Jonathan Cox <jonathan@jdcox.net>
    USB: Add USB_QUIRK_DELAY_CTRL_MSG and USB_QUIRK_DELAY_INIT for Corsair K70 RGB RAPIDFIRE

Changming Liu <liu.changm@northeastern.edu>
    USB: sisusbvga: Change port variable from signed to unsigned

Lars-Peter Clausen <lars@metafoo.de>
    iio: xilinx-xadc: Make sure not exceed maximum samplerate

Lars-Peter Clausen <lars@metafoo.de>
    iio: xilinx-xadc: Fix sequencer configuration for aux channels in simultaneous mode

Lars-Peter Clausen <lars@metafoo.de>
    iio: xilinx-xadc: Fix clearing interrupt when enabling trigger

Lars-Peter Clausen <lars@metafoo.de>
    iio: xilinx-xadc: Fix ADC-B powerdown

Alexandre Belloni <alexandre.belloni@bootlin.com>
    iio: adc: ti-ads8344: properly byte swap value

Olivier Moysan <olivier.moysan@st.com>
    iio: adc: stm32-adc: fix sleep in atomic context

Lary Gibaud <yarl-baudig@mailoo.org>
    iio: st_sensors: rely on odr mask to know if odr can be set

Lars Engebretsen <lars@engebretsen.ch>
    iio: core: remove extra semi-colon from devm_iio_device_register() macro

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add connector notifier delegation

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add static mapping table for ALC1220-VB-based mobos

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Remove ASUS ROG Zenith from the blacklist

Waiman Long <longman@redhat.com>
    KEYS: Avoid false positive ENOMEM error on key read

David Ahern <dsahern@gmail.com>
    vrf: Check skb for XFRM_TRANSFORMED flag

David Ahern <dsahern@gmail.com>
    xfrm: Always set XFRM_TRANSFORMED in xfrm{4,6}_output_finish

Sabrina Dubroca <sd@queasysnail.net>
    geneve: use the correct nlattr array in NL_SET_ERR_MSG_ATTR

Sabrina Dubroca <sd@queasysnail.net>
    vxlan: use the correct nlattr array in NL_SET_ERR_MSG_ATTR

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: b53: b53_arl_rw_op() needs to select IVL or SVL

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: b53: Rework ARL bin logic

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: b53: Fix ARL register definitions

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: b53: Fix valid setting for MDB entries

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: b53: Lookup VID in ARL searches when VLAN is enabled

David Ahern <dsahern@gmail.com>
    vrf: Fix IPv6 with qdisc and xfrm

Taehee Yoo <ap420073@gmail.com>
    team: fix hang in team_mode_get()

Eric Dumazet <edumazet@google.com>
    tcp: cache line align MAX_TCP_HEADER

David Ahern <dsahern@gmail.com>
    selftests: Fix suppress test in fib_tests.sh

Eric Dumazet <edumazet@google.com>
    sched: etf: do not assume all sockets are full blown

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    net/x25: Fix x25_neigh refcnt leak when receiving frame

Marc Zyngier <maz@kernel.org>
    net: stmmac: dwmac-meson8b: Add missing boundary to RGMII TX clock array

Tonghao Zhang <xiangxia.m.yue@gmail.com>
    net: openvswitch: ovs_ct_exit to be done under ovs_lock

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    net: netrom: Fix potential nr_neigh refcnt leak in nr_add_node

Eric Dumazet <edumazet@google.com>
    net/mlx4_en: avoid indirect call in TX completion

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: correct per TX/RX ring statistics

Dan Carpenter <dan.carpenter@oracle.com>
    mlxsw: Fix some IS_ERR() vs NULL bugs

Taehee Yoo <ap420073@gmail.com>
    macvlan: fix null dereference in macvlan_device_event()

Taehee Yoo <ap420073@gmail.com>
    macsec: avoid to set wrong mtu

John Haxby <john.haxby@oracle.com>
    ipv6: fix restrict IPV6_ADDRFORM operation

David Ahern <dsahern@gmail.com>
    ipv4: Update fib_select_default to handle nexthop objects

Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
    cxgb4: fix large delays in PTP synchronization

Vishal Kulkarni <vishal@chelsio.com>
    cxgb4: fix adapter crash due to wrong MC size

Mika Westerberg <mika.westerberg@linux.intel.com>
    PCI/PM: Add missing link delays required by the PCIe spec

Heiner Kallweit <hkallweit1@gmail.com>
    PCI/ASPM: Allow re-enabling Clock PM

Kevin Barnett <kevin.barnett@microsemi.com>
    scsi: smartpqi: fix problem with unique ID for physical device

Murthy Bhat <Murthy.Bhat@microsemi.com>
    scsi: smartpqi: fix call trace in device discovery

Kevin Barnett <kevin.barnett@microsemi.com>
    scsi: smartpqi: fix controller lockup observed during force reboot

Halil Pasic <pasic@linux.ibm.com>
    virtio-blk: improve virtqueue error to BLK_STS

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing/selftests: Turn off timeout setting

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ASoC: SOF: trace: fix unconditional free in trace release

Mika Westerberg <mika.westerberg@linux.intel.com>
    PCI: pciehp: Prevent deadlock on disconnect

Aurelien Jarno <aurelien@aurel32.net>
    libbpf: Fix readelf output parsing on powerpc with recent binutils

Mika Westerberg <mika.westerberg@linux.intel.com>
    PCI/PM: Add pcie_wait_for_link_delay()

Yongqiang Sun <yongqiang.sun@amd.com>
    drm/amd/display: Not doing optimize bandwidth if flip pending.

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Finetune host initiated USB3 rootport link suspend and resume

Kai-Heng Feng <kai.heng.feng@canonical.com>
    xhci: Wait until link state trainsits to U0 after setting USB_SS_PORT_LS_U0

Kai-Heng Feng <kai.heng.feng@canonical.com>
    xhci: Ensure link state is U3 after setting USB_SS_PORT_LS_U3

František Kučera <franta-linux@frantovo.cz>
    ALSA: usb-audio: Add Pioneer DJ DJM-250MK2 quirk

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Add quirk for MPMAN MPWIN895CL tablet

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Calculate scaling ratios on every medium/full update

Jiri Olsa <jolsa@kernel.org>
    perf/core: Disable page faults when getting phys address

Florian Fainelli <f.fainelli@gmail.com>
    pwm: bcm2835: Dynamically allocate base

Geert Uytterhoeven <geert+renesas@glider.be>
    pwm: renesas-tpu: Fix late Runtime PM enablement

Nick Bowler <nbowler@draconx.ca>
    nvme: fix compat address handling in several ioctls

Ganesh Goudar <ganeshgr@linux.ibm.com>
    powerpc/pseries: Fix MCE handling on pseries

Nicholas Piggin <npiggin@gmail.com>
    Revert "powerpc/64: irq_work avoid interrupt when called with hardware irqs enabled"

Evan Green <evgreen@chromium.org>
    loop: Better discard support for block devices

Cornelia Huck <cohuck@redhat.com>
    s390/cio: avoid duplicated 'ADD' uevents

Cornelia Huck <cohuck@redhat.com>
    s390/cio: generate delayed uevent for vfio-ccw subchannels

Masahiro Yamada <masahiroy@kernel.org>
    lib/raid6/test: fix build on distros whose /bin/sh is not bash

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    kconfig: qconf: Fix a few alignment issues

Vasily Averin <vvs@virtuozzo.com>
    ipc/util.c: sysvipc_find_ipc() should increase position index

Eric Biggers <ebiggers@google.com>
    selftests: kmod: fix handling test numbers above 9

Vasily Averin <vvs@virtuozzo.com>
    kernel/gcov/fs.c: gcov_seq_next() should increase position index

Kishon Vijay Abraham I <kishon@ti.com>
    dma-direct: fix data truncation in dma_direct_get_required_mask()

Isabel Zhang <isabel.zhang@amd.com>
    drm/amd/display: Update stream adjust in dc_stream_adjust_vmin_vmax

Sagi Grimberg <sagi@grimberg.me>
    nvme: fix deadlock caused by ANA update wrong locking

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: atom: Take the drv->lock mutex before calling sst_send_slot_map()

Santosh Sivaraj <santosh@fossix.org>
    tools/test/nvdimm: Fix out of tree build

Wu Bo <wubo40@huawei.com>
    scsi: iscsi: Report unbind session event when the target has been removed

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: fix possible crash in write_zeroes processing

Geert Uytterhoeven <geert+renesas@glider.be>
    pwm: rcar: Fix late Runtime PM enablement

Yan, Zheng <zyan@redhat.com>
    ceph: don't skip updating wanted caps when cap is stale

Qiujun Huang <hqjagain@gmail.com>
    ceph: return ceph_mdsc_do_request() errors from __get_parent()

Javed Hasan <jhasan@marvell.com>
    scsi: libfc: If PRLI rejected, move rport to PLOGI state

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix crash in target side cable pulls hitting WAIT_FOR_UNREG

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix crash after handling a pci error

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix kasan slab-out-of-bounds error in lpfc_unreg_login

Tero Kristo <t-kristo@ti.com>
    watchdog: reset last_hw_keepalive time at start

Jan Kara <jack@suse.cz>
    tools/testing/nvdimm: Fix compilation failure without CONFIG_DEV_DAX_PMEM_COMPAT

Catalin Marinas <catalin.marinas@arm.com>
    arm64: Silence clang warning on mismatched value/register sizes

James Morse <james.morse@arm.com>
    arm64: compat: Workaround Neoverse-N1 #1542419 for compat user-space

James Morse <james.morse@arm.com>
    arm64: Fake the IminLine size on systems affected by Neoverse-N1 #1542419

James Morse <james.morse@arm.com>
    arm64: errata: Hide CTR_EL0.DIC on systems affected by Neoverse-N1 #1542419

William Dauchy <w.dauchy@criteo.com>
    net, ip_tunnel: fix interface lookup with no key

Randall Huang <huangrandall@google.com>
    f2fs: fix to avoid memory leakage in f2fs_listxattr

Dmitry Monakhov <dmonakhov@gmail.com>
    ext4: fix extent_status fragmentation for plain files


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   3 +-
 Documentation/arm64/silicon-errata.rst             |   2 +
 Makefile                                           |   4 +-
 arch/arm/mach-imx/Makefile                         |   2 +
 arch/arm64/Kconfig                                 |  16 ++
 arch/arm64/include/asm/cache.h                     |   3 +-
 arch/arm64/include/asm/compat.h                    |   5 +-
 arch/arm64/include/asm/cpucaps.h                   |   3 +-
 arch/arm64/kernel/cpu_errata.c                     |  32 ++-
 arch/arm64/kernel/sys_compat.c                     |  11 +
 arch/arm64/kernel/traps.c                          |   9 +
 arch/powerpc/kernel/entry_32.S                     |   2 +-
 arch/powerpc/kernel/setup_64.c                     |   2 +
 arch/powerpc/kernel/time.c                         |  44 ++--
 arch/powerpc/platforms/Kconfig.cputype             |   2 +-
 arch/powerpc/platforms/pseries/ras.c               |  11 +
 arch/s390/kvm/kvm-s390.c                           |   3 +
 arch/s390/lib/uaccess.c                            |   4 +
 arch/s390/mm/pgalloc.c                             |  16 +-
 arch/x86/kvm/vmx/vmx.c                             |   2 +-
 drivers/block/loop.c                               |  42 +++-
 drivers/block/virtio_blk.c                         |   9 +-
 drivers/char/tpm/tpm-interface.c                   |   2 +-
 drivers/char/tpm/tpm_ibmvtpm.c                     | 136 +++++++------
 drivers/char/tpm/tpm_tis_core.c                    |   8 +-
 drivers/fpga/dfl-pci.c                             |   6 +-
 drivers/gpu/drm/amd/display/dc/core/dc.c           |  38 +++-
 drivers/iio/adc/stm32-adc.c                        |  31 ++-
 drivers/iio/adc/ti-ads8344.c                       |   6 +-
 drivers/iio/adc/xilinx-xadc-core.c                 |  95 +++++++--
 drivers/iio/common/st_sensors/st_sensors_core.c    |   2 +-
 drivers/net/dsa/b53/b53_common.c                   |  38 +++-
 drivers/net/dsa/b53/b53_regs.h                     |   8 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   3 +
 drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c     |  27 ++-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c     |  27 +--
 drivers/net/ethernet/chelsio/cxgb4/t4_regs.h       |   3 +
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |  14 +-
 .../mellanox/mlxsw/core_acl_flex_actions.c         |   4 +-
 .../ethernet/mellanox/mlxsw/spectrum2_acl_tcam.c   |   4 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c |   2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_mr_tcam.c |   4 +-
 .../net/ethernet/stmicro/stmmac/dwmac-meson8b.c    |   1 +
 drivers/net/geneve.c                               |   2 +-
 drivers/net/macsec.c                               |  12 +-
 drivers/net/macvlan.c                              |   2 +-
 drivers/net/team/team.c                            |   4 +
 drivers/net/vrf.c                                  |  10 +-
 drivers/net/vxlan.c                                |   6 +-
 drivers/net/wireless/intel/iwlegacy/3945-rs.c      |   2 +-
 drivers/net/wireless/intel/iwlegacy/4965-rs.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c        |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/txq.h    |   6 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |  13 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |   9 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |   3 +
 drivers/net/wireless/realtek/rtlwifi/rc.c          |   2 +-
 drivers/nvme/host/core.c                           |  27 ++-
 drivers/nvme/host/multipath.c                      |   4 +-
 drivers/nvme/host/tcp.c                            |  13 +-
 drivers/pci/hotplug/pciehp.h                       |   6 +-
 drivers/pci/hotplug/pciehp_core.c                  |  11 +-
 drivers/pci/hotplug/pciehp_ctrl.c                  |   4 +-
 drivers/pci/hotplug/pciehp_hpc.c                   |  59 +++++-
 drivers/pci/pci-driver.c                           |  11 +-
 drivers/pci/pci.c                                  | 142 ++++++++++++-
 drivers/pci/pci.h                                  |   1 +
 drivers/pci/pcie/aspm.c                            |  18 +-
 drivers/pwm/pwm-bcm2835.c                          |   1 +
 drivers/pwm/pwm-rcar.c                             |  10 +-
 drivers/pwm/pwm-renesas-tpu.c                      |   9 +-
 drivers/s390/cio/device.c                          |  13 +-
 drivers/s390/cio/vfio_ccw_drv.c                    |   5 +
 drivers/scsi/libfc/fc_rport.c                      |   8 +-
 drivers/scsi/lpfc/lpfc_nvme.c                      |  14 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |   7 +
 drivers/scsi/scsi_transport_iscsi.c                |   4 +-
 drivers/scsi/smartpqi/smartpqi.h                   |  10 +-
 drivers/scsi/smartpqi/smartpqi_init.c              | 225 +++++++++++----------
 drivers/scsi/smartpqi/smartpqi_sas_transport.c     |   2 +-
 drivers/staging/comedi/comedi_fops.c               |   4 +-
 drivers/staging/comedi/drivers/dt2815.c            |   3 +
 drivers/staging/gasket/gasket_sysfs.c              |   3 +-
 drivers/staging/gasket/gasket_sysfs.h              |   4 -
 drivers/staging/vt6656/int.c                       |   3 +-
 drivers/staging/vt6656/key.c                       |  14 +-
 drivers/staging/vt6656/main_usb.c                  |  31 +--
 drivers/tty/hvc/hvc_console.c                      |  23 ++-
 drivers/tty/rocket.c                               |  25 ++-
 drivers/tty/serial/owl-uart.c                      |   7 +
 drivers/tty/serial/sh-sci.c                        |  13 +-
 drivers/tty/serial/xilinx_uartps.c                 | 211 +++++--------------
 drivers/tty/vt/vt.c                                |   7 +-
 drivers/usb/class/cdc-acm.c                        |  36 +++-
 drivers/usb/class/cdc-acm.h                        |   5 +-
 drivers/usb/core/hub.c                             |  18 +-
 drivers/usb/core/message.c                         |   9 +-
 drivers/usb/core/quirks.c                          |   4 +
 drivers/usb/dwc3/gadget.c                          |  12 +-
 drivers/usb/early/xhci-dbc.c                       |   8 +-
 drivers/usb/early/xhci-dbc.h                       |  18 +-
 drivers/usb/gadget/function/f_fs.c                 |   4 +
 drivers/usb/host/xhci-hub.c                        |  70 ++++++-
 drivers/usb/host/xhci-mem.c                        |   1 +
 drivers/usb/host/xhci-ring.c                       |  47 ++++-
 drivers/usb/host/xhci.c                            |  14 +-
 drivers/usb/host/xhci.h                            |   6 +-
 drivers/usb/misc/sisusbvga/sisusb.c                |  20 +-
 drivers/usb/misc/sisusbvga/sisusb_init.h           |  14 +-
 drivers/usb/storage/uas.c                          |  46 ++++-
 drivers/usb/storage/unusual_devs.h                 |   7 +
 drivers/usb/typec/bus.c                            |   5 +-
 drivers/usb/typec/tcpm/tcpm.c                      |  26 +++
 drivers/watchdog/watchdog_dev.c                    |   1 +
 fs/ceph/caps.c                                     |   8 +-
 fs/ceph/export.c                                   |   5 +
 fs/cifs/smb2ops.c                                  |   5 +
 fs/coredump.c                                      |   2 +
 fs/ext4/extents.c                                  |  47 +++--
 fs/f2fs/xattr.c                                    |  14 +-
 fs/nfsd/nfs4callback.c                             |   4 +-
 fs/proc/vmcore.c                                   |   5 +-
 include/linux/iio/iio.h                            |   2 +-
 include/linux/kvm_host.h                           |   2 +-
 include/linux/vmalloc.h                            |   2 +-
 include/net/mac80211.h                             |   4 +-
 include/net/tcp.h                                  |   2 +-
 ipc/util.c                                         |   2 +-
 kernel/audit.c                                     |   3 +
 kernel/dma/direct.c                                |   3 +-
 kernel/events/core.c                               |   9 +-
 kernel/gcov/fs.c                                   |   2 +-
 kernel/signal.c                                    |   6 +-
 lib/raid6/test/Makefile                            |   6 +-
 mm/hugetlb.c                                       |  14 +-
 mm/ksm.c                                           |  12 +-
 mm/vmalloc.c                                       |  16 +-
 net/ipv4/fib_semantics.c                           |   6 +-
 net/ipv4/ip_tunnel.c                               |   6 +-
 net/ipv4/xfrm4_output.c                            |   2 -
 net/ipv6/ipv6_sockglue.c                           |  13 +-
 net/ipv6/xfrm6_output.c                            |   2 -
 net/mac80211/main.c                                |   5 +-
 net/mac80211/rate.c                                |  15 +-
 net/mac80211/rate.h                                |  23 +++
 net/mac80211/rc80211_minstrel_ht.c                 |  19 +-
 net/netrom/nr_route.c                              |   1 +
 net/openvswitch/conntrack.c                        |   3 +-
 net/openvswitch/datapath.c                         |   4 +-
 net/sched/sch_etf.c                                |   7 +-
 net/sunrpc/svc_xprt.c                              |   2 +
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c         |   2 +
 net/sunrpc/xprtsock.c                              |   1 +
 net/x25/x25_dev.c                                  |   4 +-
 samples/vfio-mdev/mdpy.c                           |   2 +-
 scripts/kconfig/qconf.cc                           |  13 +-
 security/keys/internal.h                           |  12 ++
 security/keys/keyctl.c                             |  58 ++++--
 sound/pci/hda/hda_intel.c                          |   1 -
 sound/pci/hda/patch_hdmi.c                         |   9 +
 sound/pci/hda/patch_realtek.c                      |  11 +-
 sound/soc/intel/atom/sst-atom-controls.c           |   2 +
 sound/soc/intel/boards/bytcr_rt5640.c              |  11 +
 sound/soc/soc-dapm.c                               |  20 +-
 sound/soc/sof/trace.c                              |   7 +-
 sound/usb/format.c                                 |  52 +++++
 sound/usb/mixer.c                                  |  37 +++-
 sound/usb/mixer.h                                  |  10 +
 sound/usb/mixer_maps.c                             |  37 +++-
 sound/usb/mixer_quirks.c                           |  12 +-
 sound/usb/quirks-table.h                           |  56 +++++
 sound/usb/usx2y/usbusx2yaudio.c                    |   2 +
 tools/lib/bpf/Makefile                             |   4 +-
 tools/testing/nvdimm/Kbuild                        |   4 +-
 tools/testing/nvdimm/test/Kbuild                   |   4 +-
 tools/testing/nvdimm/test/nfit.c                   |   2 +
 tools/testing/selftests/ftrace/settings            |   1 +
 tools/testing/selftests/kmod/kmod.sh               |  13 +-
 tools/testing/selftests/net/fib_nexthops.sh        |  23 +++
 tools/testing/selftests/net/fib_tests.sh           |  10 +-
 tools/vm/Makefile                                  |   2 +
 183 files changed, 1953 insertions(+), 844 deletions(-)


