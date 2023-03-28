Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 007B76CC4F6
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232542AbjC1PKx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbjC1PKu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:10:50 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EFB1E1B4;
        Tue, 28 Mar 2023 08:09:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EF48ACE1D9C;
        Tue, 28 Mar 2023 15:07:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FC4DC433EF;
        Tue, 28 Mar 2023 15:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680016022;
        bh=XBUDaOnTVErwD51mOEwD21K1CWHluvEVHp1CzsBBgsY=;
        h=From:To:Cc:Subject:Date:From;
        b=zJCXU/8WOBqf1Unwxv3HnQsR930MSZKHhrdICIykH2NRdZ1Yi6xkiFAWyVqEwxVxx
         YwhmHdKJuwcFepB4QtWbhR4kIWWKcAvPFF44C6RDwh5N/LyfT2KBulvBEVMtJEfAcy
         2RXnzMhS7WNK0dn9YujiL1WyH/aCapeIbPpBrKB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.15 000/146] 5.15.105-rc1 review
Date:   Tue, 28 Mar 2023 16:41:29 +0200
Message-Id: <20230328142602.660084725@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.105-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.105-rc1
X-KernelTest-Deadline: 2023-03-30T14:26+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.105 release.
There are 146 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 30 Mar 2023 14:25:33 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.105-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.105-rc1

Dai Ngo <dai.ngo@oracle.com>
    NFSD: fix use-after-free in __nfs42_ssc_open()

Jan Kara via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
    ocfs2: fix data corruption after failed write

Muchun Song <songmuchun@bytedance.com>
    mm: kfence: fix using kfence_metadata without initialization in show_object()

Vincent Guittot <vincent.guittot@linaro.org>
    sched/fair: Sanitize vruntime of entity being migrated

Zhang Qiao <zhangqiao22@huawei.com>
    sched/fair: sanitize vruntime of entity being placed

Mike Snitzer <snitzer@kernel.org>
    dm crypt: avoid accessing uninitialized tasklet

Mikulas Patocka <mpatocka@redhat.com>
    dm crypt: add cond_resched() to dmcrypt_write()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    dm stats: check for and propagate alloc_percpu failure

Wei Chen <harperchen1110@gmail.com>
    i2c: xgene-slimpro: Fix out-of-bounds bug in xgene_slimpro_i2c_xfer()

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Fix device node validation for mailbox transport

Rijo Thomas <Rijo-john.Thomas@amd.com>
    tee: amdtee: fix race condition in amdtee_open_session

Nathan Chancellor <nathan@kernel.org>
    riscv: Handle zicsr/zifencei issues between clang and binutils

Dylan Jhong <dylan@andestech.com>
    riscv: mm: Fix incorrect ASID argument when flushing TLB

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Preserve crtc_state->inherited during state clearing

Nirmoy Das <nirmoy.das@intel.com>
    drm/i915/active: Fix missing debug object activation

Kai-Heng Feng <kai.heng.feng@canonical.com>
    drm/amdgpu/nv: Apply ASPM quirk on Intel ADL + AMD Navi

Johan Hovold <johan+linaro@kernel.org>
    drm/meson: fix missing component unbind on bind errors

Matheus Castello <matheus.castello@toradex.com>
    drm/bridge: lt8912b: return EPROBE_DEFER if bridge is not found

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix kernel-infoleak in nilfs_ioctl_wrap_copy()

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: fix qos on mesh interfaces

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: return unsupported error on smb1 mount

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: return STATUS_NOT_SUPPORTED on unsupported smb2.0 dialect

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: set FILE_NAMED_STREAMS attribute in FS_ATTRIBUTE_INFORMATION

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: x86: hyper-v: Avoid calling kvm_make_vcpus_request_mask() with vcpu_mask==NULL

Marco Elver <elver@google.com>
    kfence: avoid passing -g for test

Hans de Goede <hdegoede@redhat.com>
    usb: ucsi: Fix NULL pointer deref in ucsi_connector_change()

Xu Yang <xu.yang_2@nxp.com>
    usb: chipidea: core: fix possible concurrent when switch role

Xu Yang <xu.yang_2@nxp.com>
    usb: chipdea: core: fix return -EINVAL if request role is the same with current role

Pawel Laszczak <pawell@cadence.com>
    usb: cdnsp: changes PCI Device ID to fix conflict with CNDS3 driver

Pawel Laszczak <pawell@cadence.com>
    usb: cdnsp: Fixes issue with redundant Status Stage

Pawel Laszczak <pawell@cadence.com>
    usb: cdns3: Fix issue with using incorrect PCI device function

Xu Yang <xu.yang_2@nxp.com>
    usb: typec: tcpm: fix warning when handle discover_identity message

Coly Li <colyli@suse.de>
    dm thin: fix deadlock when swapping to thin device

Lin Ma <linma@zju.edu.cn>
    igb: revert rtnl_lock() that causes deadlock

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: imx8mm-nitrogen-r2: fix WM8960 clock name

Jeff Layton <jlayton@kernel.org>
    lockd: set file_lock start and end when decoding nlm4 testargs

Nathan Huckleberry <nhuck@google.com>
    fsverity: Remove WQ_UNBOUND from fsverity read workqueue

Eric Biggers <ebiggers@google.com>
    fscrypt: destroy keyring after security_sb_delete()

Geert Uytterhoeven <geert+renesas@glider.be>
    mm/slab: Fix undefined init_cache_node_node() for NUMA and !SMP

Hans de Goede <hdegoede@redhat.com>
    efi: sysfb_efi: Fix DMI quirks not working for simpledrm

Alvin Šipraga <alsi@bang-olufsen.dk>
    usb: gadget: u_audio: don't let userspace block driver unbind

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    usb: dwc2: fix a devres leak in hw_enable upon suspend resume

Joel Selvaraj <joelselvaraj.oss@gmail.com>
    scsi: core: Add BLIST_SKIP_VPD_PAGES for SKhynix H28U74301AMR

Shyam Prasad N <sprasad@microsoft.com>
    cifs: print session id while listing open files

Shyam Prasad N <sprasad@microsoft.com>
    cifs: empty interface list when server doesn't support query interfaces

Davide Caratti <dcaratti@redhat.com>
    act_mirred: use the backlog for nested calls to mirred ingress

Davide Caratti <dcaratti@redhat.com>
    net/sched: act_mirred: better wording on protection against excessive stack growth

Al Viro <viro@zeniv.linux.org.uk>
    sh: sanitize the flags on sigreturn

Enrico Sau <enrico.sau@gmail.com>
    net: usb: qmi_wwan: add Telit 0x1080 composition

Enrico Sau <enrico.sau@gmail.com>
    net: usb: cdc_mbim: avoid altsetting toggling for Telit FE990

Michael Kelley <mikelley@microsoft.com>
    scsi: storvsc: Handle BlockSize change in Hyper-V VHD/VHDX file

Jakob Koschel <jkl820.git@gmail.com>
    scsi: lpfc: Avoid usage of list iterator variable after loop

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Check kzalloc() in lpfc_sli4_cgn_params_read()

Adrien Thierry <athierry@redhat.com>
    scsi: ufs: core: Add soft dependency on governor_simpleondemand

Kang Chen <void0red@gmail.com>
    scsi: hisi_sas: Check devm_add_action() return value

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: iscsi: Fix an error message in iscsi_check_key()

Lorenz Bauer <lorenz.bauer@isovalent.com>
    selftests/bpf: check that modifier resolves after pointer

Michael Schmitz <schmitzmic@gmail.com>
    m68k: Only force 030 bus error if PC not in exception table

Reka Norman <rekanorman@chromium.org>
    HID: intel-ish-hid: ipc: Fix potential use-after-free in work function

Alexander Aring <aahringo@redhat.com>
    ca8210: fix mac_len negative array access

Danny Kaehn <kaehndan@gmail.com>
    HID: cp2112: Fix driver not registering GPIO IRQ chip as threaded

Alexandr Sapozhnikov <alsp705@gmail.com>
    drm/cirrus: NULL-check pipe->plane.state->fb in cirrus_pipe_update()

Alexandre Ghiti <alex@ghiti.fr>
    riscv: Bump COMMAND_LINE_SIZE value to 1024

Mario Limonciello <mario.limonciello@amd.com>
    ACPI: x86: utils: Add Cezanne to the list for forcing StorageD3Enable

Adrien Thierry <athierry@redhat.com>
    scsi: ufs: core: Initialize devfreq synchronously

Tom Rix <trix@redhat.com>
    thunderbolt: Rename shadowed variables bit to interrupt_bit and auto_clear_bit

Mario Limonciello <mario.limonciello@amd.com>
    thunderbolt: Use const qualifier for `ring_interrupt_index`

Gil Fine <gil.fine@linux.intel.com>
    thunderbolt: Add missing UNSET_INBOUND_SBTX for retimer access

Mario Limonciello <mario.limonciello@amd.com>
    thunderbolt: Disable interrupt auto clear for rings

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Call tb_check_quirks() after initializing adapters

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Use scale field when allocating USB3 bandwidth

Yaroslav Furman <yaro330@gmail.com>
    uas: Add US_FL_NO_REPORT_OPCODES for JMicron JMS583Gen 2

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Perform lockless command completion in abort path

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Synchronize the IOCB count to be in order

Frank Crawford <frank@crawford.emu.id.au>
    hwmon (it87): Fix voltage scaling for chips with 10.9mV ADCs

Phinex Hung <phinex@realtek.com>
    hwmon: fix potential sensor registration fail if of_node is missing

Frederic Weisbecker <frederic@kernel.org>
    entry/rcu: Check TIF_RESCHED _after_ delayed RCU wake-up

Mark Rutland <mark.rutland@arm.com>
    entry: Snapshot thread flags

Mark Rutland <mark.rutland@arm.com>
    thread_info: Add helpers to snapshot thread flags

Tzung-Bi Shih <tzungbi@kernel.org>
    platform/chrome: cros_ec_chardev: fix kernel data leak from ioctl

Zheng Wang <zyytlz.wz@163.com>
    Bluetooth: btsdio: fix use after free bug in btsdio_remove due to unfinished work

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix responding with wrong PDU type

Stephan Gerhold <stephan.gerhold@kernkonzept.com>
    Bluetooth: btqcomsmd: Fix command timeout after setting BD address

Liang He <windhl@126.com>
    net: mdio: thunder: Add missing fwnode_handle_put()

Arınç ÜNAL <arinc.unal@arinc9.com>
    net: dsa: mt7530: move setting ssc_delta to PHY_INTERFACE_MODE_TRGMII case

Arınç ÜNAL <arinc.unal@arinc9.com>
    net: dsa: mt7530: move lowering TRGMII driving to mt7530_setup()

Arınç ÜNAL <arinc.unal@arinc9.com>
    net: dsa: mt7530: move enabling disabling core clock to mt7530_pll_setup()

Joshua Washington <joshwash@google.com>
    gve: Cache link_speed value from device

ChenXiaoSong <chenxiaosong2@huawei.com>
    ksmbd: fix possible refcount leak in smb2_open()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: add low bound validation to FSCTL_QUERY_ALLOCATED_RANGES

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: add low bound validation to FSCTL_SET_ZERO_DATA

Roger Pau Monne <roger.pau@citrix.com>
    hvc/xen: prevent concurrent accesses to the shared ring

Caleb Sander <csander@purestorage.com>
    nvme-tcp: fix nvme_tcp_term_pdu to match spec

Zhang Changzhong <zhangchangzhong@huawei.com>
    net/sonic: use dma_mapping_error() for error check

Eric Dumazet <edumazet@google.com>
    erspan: do not use skb_mac_header() in ndo_start_xmit()

Li Zetao <lizetao1@huawei.com>
    atm: idt77252: fix kmemleak when rmmod idt77252

Álvaro Fernández Rojas <noltari@gmail.com>
    net: dsa: tag_brcm: legacy: fix daisy-chained switches

Dan Carpenter <error27@gmail.com>
    net/mlx5: E-Switch, Fix an Oops in error handling code

Maher Sanalla <msanalla@nvidia.com>
    net/mlx5: Read the TC mapping of all priorities on ETS query

Lama Kayal <lkayal@nvidia.com>
    net/mlx5: Fix steering rules cleanup

Gavin Li <gavinl@nvidia.com>
    net/mlx5e: Set uplink rep as NETNS_LOCAL

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Adjust insufficient default bpf_jit_limit

Radoslaw Tyl <radoslawx.tyl@intel.com>
    i40e: fix flow director packet filter programming

Stefan Assmann <sassmann@kpanic.de>
    iavf: fix hang on reboot with ice

David Howells <dhowells@redhat.com>
    keys: Do not cache key in task struct if key is requested from kernel thread

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    bootconfig: Fix testcase to increase max node

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    octeontx2-vf: Add missing free for alloc_percpu

Geoff Levand <geoff@infradead.org>
    net/ps3_gelic_net: Use dma_mapping_error

Geoff Levand <geoff@infradead.org>
    net/ps3_gelic_net: Fix RX sk_buff length

Zheng Wang <zyytlz.wz@163.com>
    net: qcom/emac: Fix use after free bug in emac_remove due to race condition

Andrzej Hajda <andrzej.hajda@intel.com>
    drm/i915/gt: perform uc late init after probe error injection

Florian Fainelli <f.fainelli@gmail.com>
    net: mdio: fix owner field for mdio buses registered using ACPI

Maxime Bizon <mbizon@freebox.fr>
    net: mdio: fix owner field for mdio buses registered using device-tree

Florian Fainelli <f.fainelli@gmail.com>
    net: phy: Ensure state transitions are processed from phy_stop()

Zheng Wang <zyytlz.wz@163.com>
    xirc2ps_cs: Fix use after free bug in xirc2ps_detach

Daniil Tatianin <d-tatianin@yandex-team.ru>
    qed/qed_sriov: guard against NULL derefs from qed_iov_get_vf_info

Szymon Heidrich <szymon.heidrich@gmail.com>
    net: usb: smsc95xx: Limit packet length to skb->len

Álvaro Fernández Rojas <noltari@gmail.com>
    net: dsa: b53: mmap: fix device tree support

Yu Kuai <yukuai3@huawei.com>
    scsi: scsi_dh_alua: Fix memleak for 'qdata' in alua_activate()

Yicong Yang <yangyicong@hisilicon.com>
    i2c: hisi: Only use the completion interrupt to finish the transfer

Alexander Stein <alexander.stein@ew.tq-group.com>
    i2c: imx-lpi2c: check only for enabled interrupt flags

AKASHI Takahiro <takahiro.akashi@linaro.org>
    igc: fix the validation logic for taprio's gate list

Akihiko Odaki <akihiko.odaki@daynix.com>
    igbvf: Regard vf reset nack as success

Gaosheng Cui <cuigaosheng1@huawei.com>
    intel/igbvf: free irq on the error path in igbvf_request_msix()

Alexander Lobakin <aleksander.lobakin@intel.com>
    iavf: fix non-tunneled IPv6 UDP packet type and hashing

Alexander Lobakin <aleksander.lobakin@intel.com>
    iavf: fix inverted Rx hash condition leading to disabled hash

Kal Conley <kal.conley@dectris.com>
    xsk: Add missing overflow check in xdp_umem_reg

Marek Vasut <marex@denx.de>
    arm64: dts: imx8mn: specify #sound-dai-cells for SAI nodes

Peng Fan <peng.fan@nxp.com>
    ARM: dts: imx6sl: tolino-shine2hd: fix usbotg1 pinctrl

Peng Fan <peng.fan@nxp.com>
    ARM: dts: imx6sll: e60k02: fix usbotg1 pinctrl

Zheng Wang <zyytlz.wz@163.com>
    power: supply: da9150: Fix use after free bug in da9150_charger_remove due to race condition

Zheng Wang <zyytlz.wz@163.com>
    power: supply: bq24190: Fix use after free bug in bq24190_remove due to race condition

Minghao Chi <chi.minghao@zte.com.cn>
    power: supply: bq24190_charger: using pm_runtime_resume_and_get instead of pm_runtime_get_sync

Hangyu Hua <hbh25y@gmail.com>
    net: tls: fix possible race condition between do_tls_getsockopt_conf() and do_tls_setsockopt_conf()

Tero Kristo <tero.kristo@linux.intel.com>
    trace/hwlat: Do not start per-cpu thread if it is already running

Cai Huoqing <caihuoqing@baidu.com>
    trace/hwlat: make use of the helper function kthread_run_on_cpu()

Cai Huoqing <caihuoqing@baidu.com>
    kthread: add the helper function kthread_run_on_cpu()

Randy Dunlap <rdunlap@infradead.org>
    serial: 8250: ASPEED_VUART: select REGMAP instead of depending on it

Geert Uytterhoeven <geert+renesas@glider.be>
    serial: 8250: SERIAL_8250_ASPEED_VUART should depend on ARCH_ASPEED

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    tty: serial: fsl_lpuart: fix race on RX DMA shutdown

Sherry Sun <sherry.sun@nxp.com>
    tty: serial: fsl_lpuart: switch to new dmaengine_terminate_* API

Jason Wang <wangborong@cdjrlc.com>
    serial: fsl_lpuart: Fix comment typo

Costa Shulyupin <costa.shul@redhat.com>
    tracing/hwlat: Replace sched_setaffinity with set_cpus_allowed_ptr

Song Liu <song@kernel.org>
    perf: fix perf_event_context->time

Yang Jihong <yangjihong1@huawei.com>
    perf/core: Fix perf_output_begin parameter is incorrectly invoked in perf_event_bpf_output

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    interconnect: qcom: osm-l3: fix icc_onecell_data allocation


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/e60k02.dtsi                      |   1 +
 arch/arm/boot/dts/imx6sl-tolino-shine2hd.dts       |   1 +
 .../boot/dts/freescale/imx8mm-nitrogen-r2.dts      |   2 +-
 arch/arm64/boot/dts/freescale/imx8mn.dtsi          |   5 +
 arch/m68k/kernel/traps.c                           |   4 +-
 arch/riscv/Kconfig                                 |  22 ++++
 arch/riscv/Makefile                                |  10 +-
 arch/riscv/include/asm/tlbflush.h                  |   2 +
 arch/riscv/include/uapi/asm/setup.h                |   8 ++
 arch/riscv/mm/context.c                            |   2 +-
 arch/riscv/mm/tlbflush.c                           |   2 +-
 arch/sh/include/asm/processor_32.h                 |   1 +
 arch/sh/kernel/signal_32.c                         |   3 +
 arch/x86/kvm/hyperv.c                              |  15 +--
 drivers/acpi/x86/utils.c                           |  37 +++----
 drivers/atm/idt77252.c                             |  11 ++
 drivers/bluetooth/btqcomsmd.c                      |  17 ++-
 drivers/bluetooth/btsdio.c                         |   1 +
 drivers/firmware/arm_scmi/mailbox.c                |  37 +++++++
 drivers/firmware/efi/sysfb_efi.c                   |   5 +-
 drivers/firmware/sysfb.c                           |   4 +-
 drivers/firmware/sysfb_simplefb.c                  |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  15 +++
 drivers/gpu/drm/amd/amdgpu/nv.c                    |   2 +-
 drivers/gpu/drm/amd/amdgpu/vi.c                    |  17 +--
 drivers/gpu/drm/bridge/lontium-lt8912b.c           |   4 +-
 drivers/gpu/drm/i915/display/intel_display.c       |   1 +
 drivers/gpu/drm/i915/gt/intel_gt.c                 |   4 +-
 drivers/gpu/drm/i915/i915_active.c                 |   3 +-
 drivers/gpu/drm/meson/meson_drv.c                  |  13 ++-
 drivers/gpu/drm/tiny/cirrus.c                      |   2 +-
 drivers/hid/hid-cp2112.c                           |   1 +
 drivers/hid/intel-ish-hid/ipc/ipc.c                |   9 +-
 drivers/hwmon/hwmon.c                              |   7 +-
 drivers/hwmon/it87.c                               |   4 +-
 drivers/i2c/busses/i2c-hisi.c                      |   6 +-
 drivers/i2c/busses/i2c-imx-lpi2c.c                 |   4 +
 drivers/i2c/busses/i2c-xgene-slimpro.c             |   3 +
 drivers/interconnect/qcom/osm-l3.c                 |   2 +-
 drivers/md/dm-crypt.c                              |  16 +--
 drivers/md/dm-stats.c                              |   7 +-
 drivers/md/dm-stats.h                              |   2 +-
 drivers/md/dm-thin.c                               |   2 +
 drivers/md/dm.c                                    |   4 +-
 drivers/net/dsa/b53/b53_mmap.c                     |   2 +-
 drivers/net/dsa/mt7530.c                           |  49 +++++----
 drivers/net/ethernet/google/gve/gve_ethtool.c      |   5 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |   8 +-
 drivers/net/ethernet/intel/iavf/iavf_common.c      |   2 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |   5 +
 drivers/net/ethernet/intel/iavf/iavf_txrx.c        |   2 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |   2 -
 drivers/net/ethernet/intel/igbvf/netdev.c          |   8 +-
 drivers/net/ethernet/intel/igbvf/vf.c              |  13 ++-
 drivers/net/ethernet/intel/igc/igc_main.c          |  20 ++--
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   6 +-
 .../mellanox/mlx5/core/esw/acl/ingress_ofld.c      |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   1 +
 drivers/net/ethernet/natsemi/sonic.c               |   4 +-
 drivers/net/ethernet/qlogic/qed/qed_sriov.c        |   5 +-
 drivers/net/ethernet/qualcomm/emac/emac.c          |   6 ++
 drivers/net/ethernet/toshiba/ps3_gelic_net.c       |  41 ++++----
 drivers/net/ethernet/toshiba/ps3_gelic_net.h       |   5 +-
 drivers/net/ethernet/xircom/xirc2ps_cs.c           |   5 +
 drivers/net/ieee802154/ca8210.c                    |   2 +
 drivers/net/mdio/acpi_mdio.c                       |  10 +-
 drivers/net/mdio/mdio-thunder.c                    |   1 +
 drivers/net/mdio/of_mdio.c                         |  12 ++-
 drivers/net/phy/mdio_devres.c                      |  11 +-
 drivers/net/phy/phy.c                              |  23 ++--
 drivers/net/usb/cdc_mbim.c                         |   5 +
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/usb/smsc95xx.c                         |   6 ++
 drivers/platform/chrome/cros_ec_chardev.c          |   2 +-
 drivers/power/supply/bq24190_charger.c             |  64 ++++-------
 drivers/power/supply/da9150-charger.c              |   1 +
 drivers/scsi/device_handler/scsi_dh_alua.c         |   6 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |   3 +-
 drivers/scsi/lpfc/lpfc_init.c                      |   2 +
 drivers/scsi/lpfc/lpfc_sli.c                       |  12 +--
 drivers/scsi/qla2xxx/qla_isr.c                     |   3 +-
 drivers/scsi/qla2xxx/qla_os.c                      |  11 ++
 drivers/scsi/scsi_devinfo.c                        |   1 +
 drivers/scsi/storvsc_drv.c                         |  16 +++
 drivers/scsi/ufs/ufshcd.c                          |  48 ++++++---
 drivers/scsi/ufs/ufshcd.h                          |   1 +
 drivers/target/iscsi/iscsi_target_parameters.c     |  12 ++-
 drivers/tee/amdtee/core.c                          |  29 +++--
 drivers/thunderbolt/nhi.c                          |  49 +++++----
 drivers/thunderbolt/nhi_regs.h                     |   6 +-
 drivers/thunderbolt/retimer.c                      |  23 +++-
 drivers/thunderbolt/sb_regs.h                      |   1 +
 drivers/thunderbolt/switch.c                       |   4 +-
 drivers/thunderbolt/tb.h                           |   1 +
 drivers/thunderbolt/usb4.c                         |  36 ++++++-
 drivers/tty/hvc/hvc_xen.c                          |  19 +++-
 drivers/tty/serial/8250/Kconfig                    |   4 +-
 drivers/tty/serial/fsl_lpuart.c                    |  19 ++--
 drivers/usb/cdns3/cdns3-pci-wrap.c                 |   5 +
 drivers/usb/cdns3/cdnsp-ep0.c                      |  19 +---
 drivers/usb/cdns3/cdnsp-pci.c                      |  27 ++---
 drivers/usb/chipidea/ci.h                          |   2 +
 drivers/usb/chipidea/core.c                        |  11 +-
 drivers/usb/chipidea/otg.c                         |   5 +-
 drivers/usb/dwc2/platform.c                        |  16 +--
 drivers/usb/gadget/function/u_audio.c              |   2 +-
 drivers/usb/storage/unusual_uas.h                  |   7 ++
 drivers/usb/typec/tcpm/tcpm.c                      |  19 +++-
 drivers/usb/typec/ucsi/ucsi.c                      |  11 +-
 fs/cifs/cifs_debug.c                               |   5 +-
 fs/cifs/smb2ops.c                                  |   2 +-
 fs/ksmbd/connection.c                              |   7 +-
 fs/ksmbd/smb2pdu.c                                 |  20 +++-
 fs/ksmbd/smb_common.c                              |  27 ++++-
 fs/ksmbd/smb_common.h                              |  30 ++----
 fs/lockd/clnt4xdr.c                                |   9 +-
 fs/lockd/xdr4.c                                    |  13 ++-
 fs/nfsd/nfs4proc.c                                 |  22 ++--
 fs/nilfs2/ioctl.c                                  |   2 +-
 fs/ocfs2/aops.c                                    |  18 +++-
 fs/super.c                                         |  15 ++-
 fs/verity/verify.c                                 |  12 +--
 include/linux/acpi_mdio.h                          |   9 +-
 include/linux/entry-kvm.h                          |   2 +-
 include/linux/kthread.h                            |  25 +++++
 include/linux/lockd/xdr4.h                         |   1 +
 include/linux/nvme-tcp.h                           |   5 +-
 include/linux/of_mdio.h                            |  22 +++-
 include/linux/sysfb.h                              |   9 +-
 include/linux/thread_info.h                        |  14 +++
 kernel/bpf/core.c                                  |   2 +-
 kernel/entry/common.c                              |   5 +-
 kernel/entry/kvm.c                                 |   4 +-
 kernel/events/core.c                               |   4 +-
 kernel/kthread.c                                   |   1 +
 kernel/sched/core.c                                |   3 +
 kernel/sched/fair.c                                |  54 +++++++++-
 kernel/trace/trace_hwlat.c                         |  12 +--
 mm/kfence/Makefile                                 |   2 +-
 mm/kfence/core.c                                   |   8 +-
 mm/slab.c                                          |   2 +-
 net/bluetooth/l2cap_core.c                         | 117 ++++++++++++++-------
 net/dsa/tag_brcm.c                                 |  10 +-
 net/ipv4/ip_gre.c                                  |   4 +-
 net/ipv6/ip6_gre.c                                 |   4 +-
 net/mac80211/wme.c                                 |   6 +-
 net/sched/act_mirred.c                             |  23 ++--
 net/tls/tls_main.c                                 |   9 +-
 net/xdp/xdp_umem.c                                 |  13 +--
 security/keys/request_key.c                        |   9 +-
 tools/bootconfig/test-bootconfig.sh                |  12 ++-
 tools/testing/selftests/bpf/prog_tests/btf.c       |  28 +++++
 .../testing/selftests/net/forwarding/tc_actions.sh |  49 ++++++++-
 157 files changed, 1181 insertions(+), 562 deletions(-)


