Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC52C461EC6
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379371AbhK2SkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:40:07 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42612 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379956AbhK2SiF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:38:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E549DB815E9;
        Mon, 29 Nov 2021 18:34:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7167C53FCD;
        Mon, 29 Nov 2021 18:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210884;
        bh=uz1ME05hE8zE7yF1gXWUEjo+og2jj8y1ZtyNk5JsBns=;
        h=From:To:Cc:Subject:Date:From;
        b=iQjfe4mkhSNBw6y1RtmzD2vXL6VUiT/x7H0dW+EoqI/rNFvtYXJqPGskQUp2/OaaS
         G8mcBvhn8hh/mrrIy8aTS8d2UQAyD8OnxUZXJDtXXBAPGD6PMnRlCj8kSrurIjIVJX
         i+7XuL9RivCjm2RfGAK4jUVS9EijsvtzYWLVxrjY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.15 000/179] 5.15.6-rc1 review
Date:   Mon, 29 Nov 2021 19:16:34 +0100
Message-Id: <20211129181718.913038547@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.6-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.6-rc1
X-KernelTest-Deadline: 2021-12-01T18:17+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.6 release.
There are 179 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 01 Dec 2021 18:16:51 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.6-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.6-rc1

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx9: switch to golden tsc registers for renoir+

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx10: add wraparound gpu counter check for APUs as well

Ming Lei <ming.lei@redhat.com>
    block: avoid to quiesce queue in elevator_init_mq

Ming Lei <ming.lei@redhat.com>
    blk-mq: cancel blk-mq dispatch work in both blk_cleanup_queue and disk_release()

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    docs: accounting: update delay-accounting.rst reference

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Fix type error in sensor protocol

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Fix type error assignment in voltage protocol

Ye Bin <yebin10@huawei.com>
    io_uring: fix soft lockup when call __io_remove_buffers

Shyam Prasad N <sprasad@microsoft.com>
    cifs: nosharesock should be set on new server

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Check pid filtering when creating events

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ksmbd: Fix an error handling path in 'smb2_sess_setup()'

Stefano Garzarella <sgarzare@redhat.com>
    vhost/vsock: fix incorrect used length reported to the guest

Longpeng <longpeng2@huawei.com>
    vdpa_sim: avoid putting an uninitialized iova_domain

Joerg Roedel <jroedel@suse.de>
    iommu/amd: Clarify AMD IOMMUv2 initialization messages

Jeff Layton <jlayton@kernel.org>
    ceph: properly handle statfs on multifs setups

Shyam Prasad N <sprasad@microsoft.com>
    cifs: nosharesock should not share socket with future sessions

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    riscv: dts: microchip: drop duplicated MMC/SDHC node

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    riscv: dts: microchip: fix board compatible

Weichao Guo <guoweichao@oppo.com>
    f2fs: set SBI_NEED_FSCK flag when inconsistent node block found

Chao Yu <chao@kernel.org>
    f2fs: quota: fix potential deadlock

Alex Williamson <alex.williamson@redhat.com>
    iommu/vt-d: Fix unmap_pages support

Alex Bee <knaerzche@gmail.com>
    iommu/rockchip: Fix PAGE_DESC_HI_MASKs for RK3568

Mark Rutland <mark.rutland@arm.com>
    sched/scs: Reset task stack state in bringup_cpu()

Marco Elver <elver@google.com>
    perf: Ignore sigtrap for tracepoints destined for other tasks

Waiman Long <longman@redhat.com>
    locking/rwsem: Make handoff bit handling more consistent

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: correctly report the timestamping RX filters in ethtool

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: don't downgrade timestamping RX filters in SIOCSHWTSTAMP

Jie Wang <wangjie125@huawei.com>
    net: hns3: fix incorrect components info of ethtool --reset command

Guangbin Huang <huangguangbin2@huawei.com>
    net: hns3: fix VF RSS failed problem after PF enable multi-TCs

Tony Lu <tonylu@linux.alibaba.com>
    net/smc: Don't call clcsock shutdown twice when smc shutdown

Ziyang Xuan <william.xuanziyang@huawei.com>
    net: vlan: fix underflow for the real_dev refcnt

Julian Wiedmann <jwi@linux.ibm.com>
    ethtool: ioctl: fix potential NULL deref in ethtool_set_coalesce()

Davide Caratti <dcaratti@redhat.com>
    net/sched: sch_ets: don't peek at classes beyond 'nbands'

Yannick Vignon <yannick.vignon@nxp.com>
    net: stmmac: Disable Tx queues when reconfiguring the interface

Jakub Kicinski <kuba@kernel.org>
    tls: fix replacing proto_ops

Jakub Kicinski <kuba@kernel.org>
    tls: splice_read: fix accessing pre-processed records

Jakub Kicinski <kuba@kernel.org>
    tls: splice_read: fix record type check

Huang Pei <huangpei@loongson.cn>
    MIPS: use 3-level pgtable for 64KB page size on MIPS_VA_BITS_48

Huang Pei <huangpei@loongson.cn>
    MIPS: loongson64: fix FTLB configuration

Jesse Brandeburg <jesse.brandeburg@intel.com>
    igb: fix netpoll exit with traffic

Maurizio Lombardi <mlombard@redhat.com>
    nvmet: use IOCB_NOWAIT only if the filesystem supports it

Guo DaXing <guodaxing@huawei.com>
    net/smc: Fix loop in smc_listen

Karsten Graul <kgraul@linux.ibm.com>
    net/smc: Fix NULL pointer dereferencing in smc_vlan_by_tcpsk()

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: phylink: Force retrigger in case of latched link-fail indicator

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: phylink: Force link down and retrigger resolve on interface change

Heiner Kallweit <hkallweit1@gmail.com>
    lan743x: fix deadlock in lan743x_phy_link_status_change()

Eric Dumazet <edumazet@google.com>
    tcp_cubic: fix spurious Hystart ACK train detections for not-cwnd-limited flows

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Set plane update flags for all planes in reset

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Fix DPIA outbox timeout after GPU reset

Thomas Zeitlhofer <thomas.zeitlhofer+lkml@ze-it.at>
    PM: hibernate: use correct mode for swsusp_close()

Kumar Thangavel <kumarthangavel.hcl@gmail.com>
    net/ncsi : Add payload to be 32-bit aligned to fix dropped packets

Mark Rutland <mark.rutland@arm.com>
    arm64: uaccess: avoid blocking within critical sections

Mohammed Gamal <mgamal@redhat.com>
    drm/hyperv: Fix device removal on Gen1 VMs

Varun Prakash <varun@chelsio.com>
    nvmet-tcp: fix incomplete data digest send

Adamos Ttofari <attofari@amazon.de>
    cpufreq: intel_pstate: Add Ice Lake server to out-of-band IDs

Marek Behún <kabel@kernel.org>
    net: marvell: mvpp2: increase MTU limit when XDP enabled

Alex Elder <elder@linaro.org>
    net: ipa: kill ipa_cmd_pipeline_clear()

Alex Elder <elder@linaro.org>
    net: ipa: separate disabling setup from modem stop

Alex Elder <elder@linaro.org>
    net: ipa: directly disable ipa-setup-ready interrupt

Amit Cohen <amcohen@nvidia.com>
    mlxsw: spectrum: Protect driver from buggy firmware

Tony Lu <tonylu@linux.alibaba.com>
    net/smc: Ensure the active closing peer first closes clcsock

Vincent Whitchurch <vincent.whitchurch@axis.com>
    i2c: virtio: disable timeout handling

Huang Jianan <huangjianan@oppo.com>
    erofs: fix deadlock when shrink erofs slab

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    scsi: scsi_debug: Zero clear zones at reset write pointer

Mike Christie <michael.christie@oracle.com>
    scsi: core: sysfs: Fix setting device state to SDEV_RUNNING

Marta Plantykow <marta.a.plantykow@intel.com>
    ice: avoid bpf_prog refcount underflow

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: fix vsi->txq_map sizing

Nikolay Aleksandrov <nikolay@nvidia.com>
    net: nexthop: release IPv6 per-cpu dsts when replacing a nexthop group

Nikolay Aleksandrov <nikolay@nvidia.com>
    net: ipv6: add fib6_nh_release_dsts stub

Holger Assmann <h.assmann@pengutronix.de>
    net: stmmac: retain PTP clock time during SIOCSHWTSTAMP ioctls

Diana Wang <na.wang@corigine.com>
    nfp: checking parameter process for rx-usecs/tx-usecs is invalid

Eric Dumazet <edumazet@google.com>
    ipv6: fix typos in __ip6_finish_output()

Michael Kelley <mikelley@microsoft.com>
    firmware: smccc: Fix check for ARCH_SOC_ID not implemented

Vincent Whitchurch <vincent.whitchurch@axis.com>
    af_unix: fix regression in read after shutdown

Paolo Abeni <pabeni@redhat.com>
    mptcp: use delegate action to schedule 3rd ack retrans

Eric Dumazet <edumazet@google.com>
    mptcp: fix delack timer

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ALSA: intel-dsp-config: add quirk for JSL devices based on ES8336 codec

Juergen Gross <jgross@suse.com>
    xen/pvh: add missing prototype to header

Juergen Gross <jgross@suse.com>
    x86/pvh: add prototype for xen_pvh_init()

Brett Creeley <brett.creeley@intel.com>
    iavf: Fix VLAN feature flags after VFR

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    iavf: Fix refreshing iavf adapter stats on ethtool request

Nitesh B Venkatesh <nitesh.b.venkatesh@intel.com>
    iavf: Prevent changing static ITR values if adaptive moderation is on

Claudia Pellegrino <linux@cpellegrino.de>
    HID: magicmouse: prevent division by 0 on scroll

Thomas Weißschuh <linux@weissschuh.net>
    HID: input: set usage type to key on keycode remap

Hans de Goede <hdegoede@redhat.com>
    HID: input: Fix parsing of HID_CP_CONSUMER_CONTROL fields

Volodymyr Mytnyk <vmytnyk@marvell.com>
    net: marvell: prestera: fix double free issue on err path

Volodymyr Mytnyk <vmytnyk@marvell.com>
    net: marvell: prestera: fix brige port operation

Joel Stanley <joel@jms.id.au>
    drm/aspeed: Fix vga_pw sysfs output

Dan Carpenter <dan.carpenter@oracle.com>
    drm/vc4: fix error code in vc4_create_object()

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpt3sas: Fix incorrect system timestamp

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpt3sas: Fix system going into read-only mode

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpt3sas: Fix kernel panic during drive powercycle test

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: qla2xxx: edif: Fix off by one bug in qla_edif_app_getfcinfo()

Dan Carpenter <dan.carpenter@oracle.com>
    drm/nouveau/acr: fix a couple NULL vs IS_ERR() checks

Takashi Iwai <tiwai@suse.de>
    ARM: socfpga: Fix crash with CONFIG_FORTIRY_SOURCE

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv42: Don't fail clone() unless the OP_CLONE operation failed

Olivier Moysan <olivier.moysan@foss.st.com>
    ASoC: stm32: i2s: fix 32 bits channel length without mclk

Peng Fan <peng.fan@nxp.com>
    firmware: arm_scmi: pm: Propagate return value to caller

Vincent Guittot <vincent.guittot@linaro.org>
    firmware: arm_scmi: Fix base agent discover response

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: handle iftypes as u32

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: lpass-rx-macro: fix HPHR setting CLSH mask

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: wcd934x: return error code correctly from hw_params

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: wcd938x: fix volatile register range

Takashi Iwai <tiwai@suse.de>
    ASoC: topology: Add missing rwsem around snd_ctl_remove() calls

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: qdsp6: q6asm: fix q6asm_dai_prepare error handling

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: qdsp6: q6routing: Conditionally reset FrontEnd Mixer

Florian Fainelli <f.fainelli@gmail.com>
    ARM: dts: bcm2711: Fix PCIe interrupts

Florian Fainelli <f.fainelli@gmail.com>
    ARM: dts: BCM5301X: Add interrupt properties to GPIO node

Florian Fainelli <f.fainelli@gmail.com>
    ARM: dts: BCM5301X: Fix I2C controller interrupt

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Fix null de-reference on error path

Arnd Bergmann <arnd@arndb.de>
    media: v4l2-core: fix VIDIOC_DQEVENT handling on non-x86

Will Mortensen <willmo@gmail.com>
    netfilter: flowtable: fix IPv6 tunnel addr match

yangxingwu <xingwu.yang@gmail.com>
    netfilter: ipvs: Fix reuse connection if RS weight is 0

Florent Fourcot <florent.fourcot@wifirst.fr>
    netfilter: ctnetlink: do not erase error code with EINVAL

Florent Fourcot <florent.fourcot@wifirst.fr>
    netfilter: ctnetlink: fix filtering with CTA_TUPLE_REPLY

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ASoC: SOF: Intel: hda: fix hotplug when only codec is suspended

David Hildenbrand <david@redhat.com>
    proc/vmcore: fix clearing user buffer by properly using clear_user()

Roman Li <Roman.Li@amd.com>
    drm/amd/display: Fix OLED brightness control on eDP

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix link training

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Simplify initialization of rootcap on virtual bridge

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Implement re-issuing config requests on CRS response

Marek Behún <kabel@kernel.org>
    PCI: aardvark: Deduplicate code in advk_pcie_rd_conf()

Benjamin Coddington <bcodding@redhat.com>
    NFSv42: Fix pagecache invalidation after COPY/CLONE

Andreas Gruenbacher <agruenba@redhat.com>
    iomap: Fix inline extent handling in iomap_readpage

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/32: Fix hardlockup on vmap stack overflow

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: intel_pstate: Fix active mode offline/online EPP handling

Pingfan Liu <kernelfans@gmail.com>
    arm64: mm: Fix VM_BUG_ON(mm != &init_mm) for trans_pgd

Dylan Hung <dylan_hung@aspeedtech.com>
    mdio: aspeed: Fix "Link is Down" issue

Adrian Hunter <adrian.hunter@intel.com>
    mmc: sdhci: Fix ADMA for PAGE_SIZE >= 64KiB

Tim Harvey <tharvey@gateworks.com>
    mmc: sdhci-esdhc-imx: disable CMDQ support

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Fix pid filtering when triggers are attached

Jiri Olsa <jolsa@redhat.com>
    tracing/uprobe: Fix uprobe_perf_open probes iteration

Nicholas Piggin <npiggin@gmail.com>
    KVM: PPC: Book3S HV: Prevent POWER7/8 TLB flush flushing SLB

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix memleak in get_file_stream_info()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: contain default data stream even if xattr is empty

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: downgrade addition info error msg to debug in smb2_get_info_sec()

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau: recognise GA106

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/pm: fix powerplay OD interface

Philip Yang <Philip.Yang@amd.com>
    drm/amdgpu: IH process reset count when restart

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix link traversal locking

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fail cancellation for EXITING tasks

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: correct link-list traversal locking

Stefano Stabellini <stefano.stabellini@xilinx.com>
    xen: detect uninitialized xenbus in xenbus_init

Stefano Stabellini <stefano.stabellini@xilinx.com>
    xen: don't continue xenstore initialization in case of errors

Miklos Szeredi <mszeredi@redhat.com>
    fuse: release pipe buf after last use

Dan Carpenter <dan.carpenter@oracle.com>
    staging: r8188eu: fix a memory leak in rtw_wx_read32()

Michael Straube <straube.linux@gmail.com>
    staging: r8188eu: use GFP_ATOMIC under spinlock

Larry Finger <Larry.Finger@lwfinger.net>
    staging: r8188eu: Fix breakage introduced when 5G code was removed

Fabio M. De Francesco <fmdefrancesco@gmail.com>
    staging: r8188eu: Use kzalloc() with GFP_ATOMIC in atomic context

Dan Carpenter <dan.carpenter@oracle.com>
    staging: rtl8192e: Fix use after free in _rtl92e_pci_disconnect()

Takashi Iwai <tiwai@suse.de>
    staging: greybus: Add missing rwsem around snd_ctl_remove() calls

Noralf Trønnes <noralf@tronnes.org>
    staging/fbtft: Fix backlight

Jason Gerecke <killertofu@gmail.com>
    HID: wacom: Use "Confidence" flag to prevent reporting invalid contacts

Helge Deller <deller@gmx.de>
    Revert "parisc: Fix backtrace to always include init funtion names"

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec: copy sequence field for the reply

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Fix LED on HP ProBook 435 G7

Werner Sembach <wse@tuxedocomputers.com>
    ALSA: hda/realtek: Add quirk for ASRock NUC Box 1100

Takashi Iwai <tiwai@suse.de>
    ALSA: ctxfi: Fix out-of-range access

Todd Kjos <tkjos@google.com>
    binder: fix test regression due to sender_euid change

Mathias Nyman <mathias.nyman@linux.intel.com>
    usb: hub: Fix locking issues with address0_mutex

Mathias Nyman <mathias.nyman@linux.intel.com>
    usb: hub: Fix usb enumeration issue due to address0 race

Dmitry Osipenko <digetx@gmail.com>
    usb: xhci: tegra: Check padctrl interrupt presence in device tree

Ondrej Jirman <megous@megous.com>
    usb: typec: fusb302: Fix masking of comparator and bc_lvl interrupts

Dan Carpenter <dan.carpenter@oracle.com>
    usb: chipidea: ci_hdrc_imx: fix potential error pointer dereference in probe

Nikolay Aleksandrov <nikolay@nvidia.com>
    net: nexthop: fix null pointer dereference when IPv6 is not enabled

Martyn Welch <martyn.welch@collabora.com>
    net: usb: Correct PHY handling of smsc95xx

Albert Wang <albertccwang@google.com>
    usb: dwc3: gadget: Fix null pointer exception

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Check for L1/L2/U3 for Start Transfer

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Ignore NoStream after End Transfer

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: core: Revise GHWPARAMS9 offset

Fabio Aiuto <fabioaiuto83@gmail.com>
    usb: dwc3: leave default DMA for PCI devices

Nathan Chancellor <nathan@kernel.org>
    usb: dwc2: hcd_queue: Fix use of floating point literal

Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
    usb: dwc2: gadget: Fix ISOC flow for elapsed frames

Mingjie Zhang <superzmj@fibocom.com>
    USB: serial: option: add Fibocom FM101-GL variants

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit LE910S1 0x9200 composition

Johan Hovold <johan@kernel.org>
    USB: serial: pl2303: fix GC type detection

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: CPPC: Add NULL pointer check to cppc_get_perf()

Sakari Ailus <sakari.ailus@linux.intel.com>
    ACPI: Get acpi_device's parent from the parent field

Damien Le Moal <damien.lemoal@wdc.com>
    scsi: sd: Fix sd_do_mode_sense() buffer length handling


-------------

Diffstat:

 Documentation/admin-guide/sysctl/kernel.rst        |   2 +-
 Documentation/networking/ipvs-sysctl.rst           |   3 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/bcm2711.dtsi                     |   8 +-
 arch/arm/boot/dts/bcm5301x.dtsi                    |   4 +-
 arch/arm/mach-socfpga/core.h                       |   2 +-
 arch/arm/mach-socfpga/platsmp.c                    |   8 +-
 arch/arm64/include/asm/pgalloc.h                   |   2 +-
 arch/arm64/include/asm/uaccess.h                   |  48 +++-
 arch/mips/Kconfig                                  |   2 +-
 arch/mips/kernel/cpu-probe.c                       |   4 +-
 arch/parisc/kernel/vmlinux.lds.S                   |   3 +-
 arch/powerpc/kernel/head_32.h                      |   6 +-
 arch/powerpc/kvm/book3s_hv_builtin.c               |   5 +-
 .../dts/microchip/microchip-mpfs-icicle-kit.dts    |  13 +-
 arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi  |  33 +--
 arch/x86/include/asm/xen/hypervisor.h              |   5 +
 block/blk-core.c                                   |   4 +-
 block/blk-mq.c                                     |  13 ++
 block/blk-mq.h                                     |   2 +
 block/blk-sysfs.c                                  |  10 -
 block/elevator.c                                   |  10 +-
 block/genhd.c                                      |   2 +
 drivers/acpi/cppc_acpi.c                           |   9 +-
 drivers/acpi/property.c                            |  11 +-
 drivers/android/binder.c                           |   2 +-
 drivers/cpufreq/intel_pstate.c                     |   7 +
 drivers/firmware/arm_scmi/base.c                   |  15 +-
 drivers/firmware/arm_scmi/scmi_pm_domain.c         |   4 +-
 drivers/firmware/arm_scmi/sensors.c                |   2 +-
 drivers/firmware/arm_scmi/virtio.c                 |  10 +-
 drivers/firmware/arm_scmi/voltage.c                |   2 +-
 drivers/firmware/smccc/soc_id.c                    |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ih.c             |   3 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |  15 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |  46 +++-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   9 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c   |  20 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c    |  24 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu8_hwmgr.c    |   6 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c  |  28 ++-
 .../gpu/drm/amd/pm/powerplay/hwmgr/vega12_hwmgr.c  |  10 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c  |  58 +++--
 drivers/gpu/drm/aspeed/aspeed_gfx_drv.c            |   2 +-
 drivers/gpu/drm/hyperv/hyperv_drm_drv.c            |  19 +-
 drivers/gpu/drm/nouveau/nvkm/engine/device/base.c  |  22 ++
 drivers/gpu/drm/nouveau/nvkm/subdev/acr/gm200.c    |   6 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/acr/gp102.c    |   6 +-
 drivers/gpu/drm/vc4/vc4_bo.c                       |   2 +-
 drivers/hid/hid-input.c                            |   6 +-
 drivers/hid/hid-magicmouse.c                       |   7 +-
 drivers/hid/wacom_wac.c                            |   8 +-
 drivers/hid/wacom_wac.h                            |   1 +
 drivers/i2c/busses/i2c-virtio.c                    |  14 +-
 drivers/iommu/amd/iommu_v2.c                       |   6 +-
 drivers/iommu/intel/iommu.c                        |   6 +-
 drivers/iommu/rockchip-iommu.c                     |   4 +-
 drivers/media/cec/core/cec-adap.c                  |   1 +
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |  41 ++--
 drivers/mmc/host/sdhci-esdhc-imx.c                 |   2 -
 drivers/mmc/host/sdhci.c                           |  21 +-
 drivers/mmc/host/sdhci.h                           |   4 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   4 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   4 +-
 drivers/net/ethernet/intel/iavf/iavf.h             |   3 +
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c     |  33 ++-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  51 +++--
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    |  47 +++-
 drivers/net/ethernet/intel/ice/ice_lib.c           |   9 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  18 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |   2 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |  14 +-
 .../ethernet/marvell/prestera/prestera_switchdev.c |   8 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |   2 +-
 drivers/net/ethernet/microchip/lan743x_main.c      |  12 +-
 drivers/net/ethernet/mscc/ocelot.c                 |  11 +-
 drivers/net/ethernet/netronome/nfp/nfp_net.h       |   3 -
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |   1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 127 +++++++----
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |   2 +-
 drivers/net/ipa/ipa_cmd.c                          |  16 --
 drivers/net/ipa/ipa_cmd.h                          |   6 -
 drivers/net/ipa/ipa_endpoint.c                     |   2 -
 drivers/net/ipa/ipa_main.c                         |   6 +
 drivers/net/ipa/ipa_modem.c                        |   6 +-
 drivers/net/ipa/ipa_smp2p.c                        |  21 +-
 drivers/net/ipa/ipa_smp2p.h                        |   7 +-
 drivers/net/mdio/mdio-aspeed.c                     |   7 +
 drivers/net/phy/phylink.c                          |  26 ++-
 drivers/net/usb/smsc95xx.c                         |  55 +++--
 drivers/nvme/target/io-cmd-file.c                  |   4 +-
 drivers/nvme/target/tcp.c                          |   7 +-
 drivers/pci/controller/pci-aardvark.c              | 242 +++++++++------------
 drivers/scsi/mpt3sas/mpt3sas_base.c                |   4 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h                |   4 +
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |  59 ++++-
 drivers/scsi/qla2xxx/qla_edif.c                    |   2 +-
 drivers/scsi/scsi_debug.c                          |   5 +
 drivers/scsi/scsi_sysfs.c                          |   2 +-
 drivers/scsi/sd.c                                  |   7 +
 drivers/staging/fbtft/fb_ssd1351.c                 |   4 -
 drivers/staging/fbtft/fbtft-core.c                 |   9 +-
 drivers/staging/greybus/audio_helper.c             |   8 +-
 drivers/staging/r8188eu/core/rtw_mlme_ext.c        |   6 +-
 drivers/staging/r8188eu/os_dep/ioctl_linux.c       |   8 +-
 drivers/staging/r8188eu/os_dep/mlme_linux.c        |   2 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c       |   3 +-
 drivers/usb/chipidea/ci_hdrc_imx.c                 |  18 +-
 drivers/usb/core/hub.c                             |  24 +-
 drivers/usb/dwc2/gadget.c                          |  17 +-
 drivers/usb/dwc2/hcd_queue.c                       |   2 +-
 drivers/usb/dwc3/core.c                            |   8 +-
 drivers/usb/dwc3/core.h                            |   2 +-
 drivers/usb/dwc3/gadget.c                          |  39 +++-
 drivers/usb/host/xhci-tegra.c                      |  41 +++-
 drivers/usb/serial/option.c                        |   5 +
 drivers/usb/serial/pl2303.c                        |   1 +
 drivers/usb/typec/tcpm/fusb302.c                   |   6 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c                   |   7 +-
 drivers/vhost/vsock.c                              |   2 +-
 drivers/xen/xenbus/xenbus_probe.c                  |  27 ++-
 fs/ceph/super.c                                    |  11 +-
 fs/cifs/cifs_debug.c                               |   2 +
 fs/cifs/cifsglob.h                                 |   1 +
 fs/cifs/connect.c                                  |   7 +
 fs/erofs/utils.c                                   |   8 +-
 fs/f2fs/checkpoint.c                               |   3 +-
 fs/f2fs/node.c                                     |   1 +
 fs/fuse/dev.c                                      |  10 +-
 fs/io_uring.c                                      |  70 ++++--
 fs/iomap/buffered-io.c                             |  11 +-
 fs/ksmbd/smb2pdu.c                                 |  30 +--
 fs/nfs/nfs42proc.c                                 |   4 +-
 fs/nfs/nfs42xdr.c                                  |   3 +-
 fs/proc/vmcore.c                                   |  16 +-
 include/net/ip6_fib.h                              |   1 +
 include/net/ipv6_stubs.h                           |   1 +
 include/net/nl802154.h                             |   7 +-
 kernel/cpu.c                                       |   7 +
 kernel/events/core.c                               |   3 +
 kernel/locking/rwsem.c                             | 171 ++++++++-------
 kernel/power/hibernate.c                           |   6 +-
 kernel/sched/core.c                                |   4 -
 kernel/trace/trace.h                               |  24 +-
 kernel/trace/trace_events.c                        |  10 +
 kernel/trace/trace_uprobe.c                        |   1 +
 net/8021q/vlan.c                                   |   3 -
 net/8021q/vlan_dev.c                               |   3 +
 net/ethtool/ioctl.c                                |   2 +-
 net/ipv4/nexthop.c                                 |  35 ++-
 net/ipv4/tcp_cubic.c                               |   5 +-
 net/ipv6/af_inet6.c                                |   1 +
 net/ipv6/ip6_output.c                              |   2 +-
 net/ipv6/route.c                                   |  19 ++
 net/mptcp/options.c                                |  32 +--
 net/mptcp/protocol.c                               |  51 ++++-
 net/mptcp/protocol.h                               |  17 +-
 net/ncsi/ncsi-cmd.c                                |  24 +-
 net/netfilter/ipvs/ip_vs_core.c                    |   8 +-
 net/netfilter/nf_conntrack_netlink.c               |   6 +-
 net/netfilter/nf_flow_table_offload.c              |   4 +-
 net/sched/sch_ets.c                                |   8 +-
 net/smc/af_smc.c                                   |  12 +-
 net/smc/smc_close.c                                |   6 +
 net/smc/smc_core.c                                 |  35 +--
 net/tls/tls_main.c                                 |  47 +++-
 net/tls/tls_sw.c                                   |  40 ++--
 net/unix/af_unix.c                                 |   3 -
 sound/hda/intel-dsp-config.c                       |   9 +
 sound/pci/ctxfi/ctamixer.c                         |  14 +-
 sound/pci/ctxfi/ctdaio.c                           |  16 +-
 sound/pci/ctxfi/ctresource.c                       |   7 +-
 sound/pci/ctxfi/ctresource.h                       |   4 +-
 sound/pci/ctxfi/ctsrc.c                            |   7 +-
 sound/pci/hda/patch_realtek.c                      |  28 +++
 sound/soc/codecs/lpass-rx-macro.c                  |   2 +-
 sound/soc/codecs/wcd934x.c                         |   3 +-
 sound/soc/codecs/wcd938x.c                         |   3 +
 sound/soc/qcom/qdsp6/q6asm-dai.c                   |  19 +-
 sound/soc/qcom/qdsp6/q6routing.c                   |   6 +-
 sound/soc/soc-topology.c                           |   3 +
 sound/soc/sof/intel/hda-bus.c                      |  17 ++
 sound/soc/sof/intel/hda-dsp.c                      |   3 +-
 sound/soc/sof/intel/hda.c                          |  16 ++
 sound/soc/stm/stm32_i2s.c                          |   2 +-
 186 files changed, 1695 insertions(+), 973 deletions(-)


