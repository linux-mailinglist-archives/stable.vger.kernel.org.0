Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C671BC7E0
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728991AbgD1S12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:27:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:39634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728979AbgD1S12 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:27:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20CD520730;
        Tue, 28 Apr 2020 18:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098446;
        bh=pp/a1FsQf2tqL3wU2pn2b8FmYryZzxaXtzs51YQtSAM=;
        h=From:To:Cc:Subject:Date:From;
        b=K3ApAS7jqIDzkl+XV5HVCCHfEfuKUzG9mpBzhXUESe/pXhG3A5+uuyC7ySB2N/pof
         s/Cd8bb/qF8TVhAP86RxVGu6xiP7JIDUyU9n71IumYEPzHw0XrnspsIuo6gZxz5aEC
         9Zk6rnjmM4UNnTLD0TG8pMS71/9gLAOzaiLnyUfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.6 000/167] 5.6.8-rc1 review
Date:   Tue, 28 Apr 2020 20:22:56 +0200
Message-Id: <20200428182225.451225420@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.6.8-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.6.8-rc1
X-KernelTest-Deadline: 2020-04-30T18:22+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.6.8 release.
There are 167 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 30 Apr 2020 18:20:42 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.8-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.6.8-rc1

Christian Borntraeger <borntraeger@de.ibm.com>
    s390/mm: fix page table upgrade vs 2ndary address mode accesses

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/mm: Fix CONFIG_PPC_KUAP_DEBUG on PPC32

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/kuap: PPC_KUAP_DEBUG should depend on PPC_KUAP

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Update PMINTRMSK holding fw

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

Benjamin Lee <ben@b1c1l1.com>
    mei: me: fix irq number stored in hw struct

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

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/8xx: Fix STRICT_KERNEL_RWX startup test failure

Ahmad Fatoum <a.fatoum@pengutronix.de>
    ARM: imx: provide v7_cpu_resume() only on ARM_CPU_SUSPEND=y

Paulo Alcantara <pc@cjr.nz>
    cifs: fix uninitialised lease_key in open_shroot()

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: fix WGDS check when WRDS is disabled

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: fix inactive TID removal return value usage

Ilan Peer <ilan.peer@intel.com>
    iwlwifi: mvm: Do not declare support for ACK Enabled Aggregation

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: limit maximum queue appropriately

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: indicate correct RB size to device

Mordechay Goodstein <mordechay.goodstein@intel.com>
    iwlwifi: mvm: beacon statistics shouldn't go backwards

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: actually release queue memory in TVQM

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Fix backchannel RPC soft lockups

Gyeongtaek Lee <gt82.lee@samsung.com>
    ASoC: dapm: fixup dapm kcontrol widget

Paul Moore <paul@paul-moore.com>
    audit: check the length of userspace generated audit records

Mikita Lipski <mikita.lipski@amd.com>
    drm/dp_mst: Zero assigned PBN when releasing VCPI slots

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

Lorenzo Bianconi <lorenzo@kernel.org>
    iio: imu: st_lsm6dsx: flush hw FIFO before resetting the device

Lars Engebretsen <lars@engebretsen.ch>
    iio: core: remove extra semi-colon from devm_iio_device_register() macro

David Ahern <dsahern@gmail.com>
    libbpf: Only check mode flags in get_xdp_id

Johannes Berg <johannes.berg@intel.com>
    mac80211: populate debugfs only after cfg80211 init

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add connector notifier delegation

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add static mapping table for ALC1220-VB-based mobos

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Remove ASUS ROG Zenith from the blacklist

Waiman Long <longman@redhat.com>
    KEYS: Avoid false positive ENOMEM error on key read

Tang Bin <tangbin@cmss.chinamobile.com>
    net: ethernet: ixp4xx: Add error handling in ixp4xx_eth_probe()

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

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    tipc: Fix potential tipc_node refcnt leak in tipc_rcv

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    tipc: Fix potential tipc_aead refcnt leak in tipc_crypto_rcv

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

Christoph Hellwig <hch@lst.de>
    block: fix busy device checking in blk_drop_partitions again

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

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix lockdep error - register non-static key

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix erroneous cpu limit of 128 on I/O statistics

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

Christoph Hellwig <hch@lst.de>
    block: fix busy device checking in blk_drop_partitions

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

Stephan Gerhold <stephan@gerhold.net>
    ASoC: qcom: q6asm-dai: Add SNDRV_PCM_INFO_BATCH flag

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: fix possible crash in write_zeroes processing

Geert Uytterhoeven <geert+renesas@glider.be>
    pwm: rcar: Fix late Runtime PM enablement

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: imx27: Fix clock handling in pwm_imx27_apply()

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

Dave Chinner <dchinner@redhat.com>
    xfs: correctly acount for reclaimable slabs

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix kasan slab-out-of-bounds error in lpfc_unreg_login

Tero Kristo <t-kristo@ti.com>
    watchdog: reset last_hw_keepalive time at start

Jan Kara <jack@suse.cz>
    tools/testing/nvdimm: Fix compilation failure without CONFIG_DEV_DAX_PMEM_COMPAT

Linus Torvalds <torvalds@linux-foundation.org>
    mm: check that mm is still valid in madvise()


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   3 +-
 Makefile                                           |   4 +-
 arch/arm/mach-imx/Makefile                         |   2 +
 arch/powerpc/kernel/entry_32.S                     |   2 +-
 arch/powerpc/kernel/setup_64.c                     |   2 +
 arch/powerpc/kernel/time.c                         |  44 ++---
 arch/powerpc/mm/nohash/8xx.c                       |   3 +
 arch/powerpc/platforms/Kconfig.cputype             |   2 +-
 arch/powerpc/platforms/pseries/ras.c               |  11 ++
 arch/s390/kvm/kvm-s390.c                           |   3 +
 arch/s390/lib/uaccess.c                            |   4 +
 arch/s390/mm/pgalloc.c                             |  16 +-
 arch/x86/kvm/vmx/vmx.c                             |   2 +-
 block/partition-generic.c                          |   2 +-
 drivers/block/loop.c                               |  42 ++--
 drivers/char/tpm/tpm-interface.c                   |   2 +-
 drivers/char/tpm/tpm_ibmvtpm.c                     | 136 +++++++------
 drivers/char/tpm/tpm_tis_core.c                    |   8 +-
 drivers/fpga/dfl-pci.c                             |   6 +-
 drivers/gpu/drm/amd/display/dc/core/dc.c           |  15 +-
 drivers/gpu/drm/drm_dp_mst_topology.c              |   1 +
 drivers/gpu/drm/i915/gt/intel_rps.c                |   6 +-
 drivers/iio/adc/stm32-adc.c                        |  31 ++-
 drivers/iio/adc/ti-ads8344.c                       |   6 +-
 drivers/iio/adc/xilinx-xadc-core.c                 |  95 ++++++++--
 drivers/iio/common/st_sensors/st_sensors_core.c    |   2 +-
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c       |  24 ++-
 drivers/misc/mei/pci-me.c                          |   3 +-
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
 drivers/net/ethernet/xscale/ixp4xx_eth.c           |   2 +
 drivers/net/geneve.c                               |   2 +-
 drivers/net/macsec.c                               |  12 +-
 drivers/net/macvlan.c                              |   2 +-
 drivers/net/team/team.c                            |   4 +
 drivers/net/vrf.c                                  |  10 +-
 drivers/net/vxlan.c                                |   6 +-
 drivers/net/wireless/intel/iwlegacy/3945-rs.c      |   2 +-
 drivers/net/wireless/intel/iwlegacy/4965-rs.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c        |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |   9 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/txq.h    |   6 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  25 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |  13 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |   9 +-
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   |  18 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |   3 +
 drivers/net/wireless/realtek/rtlwifi/rc.c          |   2 +-
 drivers/nvme/host/core.c                           |  27 ++-
 drivers/nvme/host/multipath.c                      |   4 +-
 drivers/nvme/host/tcp.c                            |  13 +-
 drivers/pwm/pwm-bcm2835.c                          |   1 +
 drivers/pwm/pwm-imx27.c                            |   2 +-
 drivers/pwm/pwm-rcar.c                             |  10 +-
 drivers/pwm/pwm-renesas-tpu.c                      |   9 +-
 drivers/s390/cio/device.c                          |  13 +-
 drivers/s390/cio/vfio_ccw_drv.c                    |   5 +
 drivers/scsi/libfc/fc_rport.c                      |   8 +-
 drivers/scsi/lpfc/lpfc.h                           |   9 +-
 drivers/scsi/lpfc/lpfc_debugfs.c                   | 204 ++++++++++++--------
 drivers/scsi/lpfc/lpfc_debugfs.h                   |   1 -
 drivers/scsi/lpfc/lpfc_init.c                      |  33 +++-
 drivers/scsi/lpfc/lpfc_nvme.c                      |  59 +++---
 drivers/scsi/lpfc/lpfc_nvmet.c                     |  55 +++---
 drivers/scsi/lpfc/lpfc_scsi.c                      |  23 +--
 drivers/scsi/lpfc/lpfc_sli.c                       |  13 +-
 drivers/scsi/lpfc/lpfc_sli4.h                      |  19 +-
 drivers/scsi/scsi_transport_iscsi.c                |   4 +-
 drivers/staging/comedi/comedi_fops.c               |   4 +-
 drivers/staging/comedi/drivers/dt2815.c            |   3 +
 drivers/staging/gasket/gasket_sysfs.c              |   3 +-
 drivers/staging/gasket/gasket_sysfs.h              |   4 -
 drivers/staging/vt6656/int.c                       |   3 +-
 drivers/staging/vt6656/key.c                       |  14 +-
 drivers/staging/vt6656/main_usb.c                  |  31 +--
 drivers/tty/hvc/hvc_console.c                      |  23 ++-
 drivers/tty/rocket.c                               |  25 +--
 drivers/tty/serial/owl-uart.c                      |   7 +
 drivers/tty/serial/sh-sci.c                        |  13 +-
 drivers/tty/serial/xilinx_uartps.c                 | 211 +++++----------------
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
 fs/nfsd/nfs4callback.c                             |   4 +-
 fs/proc/vmcore.c                                   |   5 +-
 fs/xfs/xfs_super.c                                 |   3 +-
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
 mm/madvise.c                                       |  18 ++
 mm/vmalloc.c                                       |  16 +-
 net/ipv4/fib_semantics.c                           |   6 +-
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
 net/tipc/crypto.c                                  |   1 +
 net/tipc/node.c                                    |   4 +-
 net/x25/x25_dev.c                                  |   4 +-
 samples/vfio-mdev/mdpy.c                           |   2 +-
 scripts/kconfig/qconf.cc                           |  13 +-
 security/keys/internal.h                           |  12 ++
 security/keys/keyctl.c                             |  58 ++++--
 sound/pci/hda/hda_intel.c                          |   1 -
 sound/pci/hda/patch_hdmi.c                         |   9 +
 sound/pci/hda/patch_realtek.c                      |  11 +-
 sound/soc/intel/atom/sst-atom-controls.c           |   2 +
 sound/soc/intel/boards/bytcr_rt5640.c              |  11 ++
 sound/soc/qcom/qdsp6/q6asm-dai.c                   |   4 +-
 sound/soc/soc-dapm.c                               |  20 +-
 sound/usb/format.c                                 |  52 +++++
 sound/usb/mixer.c                                  |  37 +++-
 sound/usb/mixer.h                                  |  10 +
 sound/usb/mixer_maps.c                             |  37 +++-
 sound/usb/mixer_quirks.c                           |  12 +-
 sound/usb/quirks-table.h                           |  56 ++++++
 sound/usb/usx2y/usbusx2yaudio.c                    |   2 +
 tools/lib/bpf/netlink.c                            |   2 +
 tools/testing/nvdimm/Kbuild                        |   4 +-
 tools/testing/nvdimm/test/Kbuild                   |   4 +-
 tools/testing/nvdimm/test/nfit.c                   |   2 +
 tools/testing/selftests/kmod/kmod.sh               |  13 +-
 tools/testing/selftests/net/fib_nexthops.sh        |  23 +++
 tools/testing/selftests/net/fib_tests.sh           |  10 +-
 tools/vm/Makefile                                  |   2 +
 181 files changed, 1766 insertions(+), 872 deletions(-)


