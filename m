Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 090BB6CC3A5
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233564AbjC1O4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233556AbjC1O4C (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:56:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E223CC16;
        Tue, 28 Mar 2023 07:55:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBAD361804;
        Tue, 28 Mar 2023 14:55:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B46C433EF;
        Tue, 28 Mar 2023 14:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015358;
        bh=UrRd6DDCNmDoJQPAZLT5DLPW0EaMWzQm1a6Z8JX8OSE=;
        h=From:To:Cc:Subject:Date:From;
        b=l7izq4vFfdNLELElW5mMv5E/nvGhWQTRi81e5Y/FW6TZjnyE93QmsRIbk7dKK49kD
         VWt/p4uXcWnJF+p3UMF5iZp6wM7e2PbnXcq0oGubtWN5plXicBeJ6ahKYIbXWzIz9x
         VzGPzuEfLCHr10Fy6JIhXjN1/P4qMZltwexeco4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 6.1 000/224] 6.1.22-rc1 review
Date:   Tue, 28 Mar 2023 16:39:56 +0200
Message-Id: <20230328142617.205414124@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.22-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.22-rc1
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

This is the start of the stable review cycle for the 6.1.22 release.
There are 224 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 30 Mar 2023 14:25:33 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.22-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.22-rc1

Ma Jun <Jun.Ma2@amd.com>
    drm/amdkfd: Fix the memory overrun

Yifan Zhang <yifan1.zhang@amd.com>
    drm/amdkfd: add GC 11.0.4 KFD support

Ma Jun <Jun.Ma2@amd.com>
    drm/amdkfd: Fix the warning of array-index-out-of-bounds

Prike Liang <Prike.Liang@amd.com>
    drm/amdkfd: introduce dummy cache info for property asic

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

Ivan Bornyakov <i.bornyakov@metrotek.ru>
    bus: imx-weim: fix branch condition evaluates to a garbage value

Liam R. Howlett <Liam.Howlett@oracle.com>
    mm/ksm: fix race with VMA iteration and mm_struct teardown

Abel Vesa <abel.vesa@linaro.org>
    soc: qcom: llcc: Fix slice configuration values for SC8280XP

Manivannan Sadhasivam <mani@kernel.org>
    arm64: dts: qcom: sm8150: Fix the iommu mask used for PCIe controllers

Krishna chaitanya chundru <quic_krichai@quicinc.com>
    arm64: dts: qcom: sc7280: Mark PCIe controller as cache coherent

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Fix device node validation for mailbox transport

Rijo Thomas <Rijo-john.Thomas@amd.com>
    tee: amdtee: fix race condition in amdtee_open_session

Nathan Chancellor <nathan@kernel.org>
    riscv: Handle zicsr/zifencei issues between clang and binutils

Dylan Jhong <dylan@andestech.com>
    riscv: mm: Fix incorrect ASID argument when flushing TLB

Tim Huang <tim.huang@amd.com>
    drm/amdgpu: reposition the gpu reset checking for reuse

Tim Huang <tim.huang@amd.com>
    drm/amdgpu: skip ASIC reset for APUs when go to S4

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Preserve crtc_state->inherited during state clearing

Nirmoy Das <nirmoy.das@intel.com>
    drm/i915/active: Fix missing debug object activation

Kai-Heng Feng <kai.heng.feng@canonical.com>
    drm/amdgpu/nv: Apply ASPM quirk on Intel ADL + AMD Navi

Johan Hovold <johan+linaro@kernel.org>
    drm/meson: fix missing component unbind on bind errors

Hersen Wu <hersenxs.wu@amd.com>
    drm/amd/display: fix wrong index used in dccg32_set_dpstreamclk

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
    ksmbd: don't terminate inactive sessions after a few seconds

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: set FILE_NAMED_STREAMS attribute in FS_ATTRIBUTE_INFORMATION

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix wrong signingkey creation when encryption is AES256

Liam R. Howlett <Liam.Howlett@oracle.com>
    maple_tree: fix mas_skip_node() end slot detection

Liam R. Howlett <Liam.Howlett@oracle.com>
    test_maple_tree: add more testing for mas_empty_area()

Peter Collingbourne <pcc@google.com>
    Revert "kasan: drop skip_kasan_poison variable in free_pages_prepare"

Savino Dicanosa <sd7.dev@pm.me>
    io_uring/rsrc: fix null-ptr-deref in io_file_bitmap_get()

Jens Axboe <axboe@kernel.dk>
    io_uring/net: avoid sending -ECONNABORTED on repeated connection requests

Marco Elver <elver@google.com>
    kfence: avoid passing -g for test

Muchun Song <muchun.song@linux.dev>
    mm: kfence: fix using kfence_metadata without initialization in show_object()

Hans de Goede <hdegoede@redhat.com>
    usb: ucsi_acpi: Increase the command completion timeout

Hans de Goede <hdegoede@redhat.com>
    usb: ucsi: Fix NULL pointer deref in ucsi_connector_change()

Wesley Cheng <quic_wcheng@quicinc.com>
    usb: dwc3: gadget: Add 1ms delay after end transfer command without IOC

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

Xu Yang <xu.yang_2@nxp.com>
    usb: typec: tcpm: fix create duplicate source-capabilities file

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

Min Li <lm0963hack@gmail.com>
    Bluetooth: Fix race condition in hci_cmd_sync_clear

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: fix btrfs_can_activate_zone() to support DUP profile

Alvin Šipraga <alsi@bang-olufsen.dk>
    usb: gadget: u_audio: don't let userspace block driver unbind

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    usb: dwc2: fix a devres leak in hw_enable upon suspend resume

Ziyang Huang <hzyitc@outlook.com>
    usb: dwc2: drd: fix inconsistent mode if role-switch-default-mode="host"

Alexander Stein <alexander.stein@ew.tq-group.com>
    usb: misc: onboard-hub: add support for Microchip USB2517 USB 2.0 hub

Joel Selvaraj <joelselvaraj.oss@gmail.com>
    scsi: core: Add BLIST_SKIP_VPD_PAGES for SKhynix H28U74301AMR

Chang S. Bae <chang.seok.bae@intel.com>
    selftests/x86/amx: Add a ptrace test

Chang S. Bae <chang.seok.bae@intel.com>
    x86/fpu/xstate: Prevent false-positive warning in __copy_xstate_uabi_buf()

Paulo Alcantara <pc@manguebit.com>
    cifs: fix dentry lookups in directory handle cache

Shyam Prasad N <sprasad@microsoft.com>
    cifs: print session id while listing open files

Shyam Prasad N <sprasad@microsoft.com>
    cifs: dump pending mids for all channels in DebugData

Shyam Prasad N <sprasad@microsoft.com>
    cifs: empty interface list when server doesn't support query interfaces

Shyam Prasad N <sprasad@microsoft.com>
    cifs: do not poll server interfaces too regularly

Shyam Prasad N <sprasad@microsoft.com>
    cifs: append path to open_enter trace event

Shyam Prasad N <sprasad@microsoft.com>
    cifs: lock chan_lock outside match_session

Davide Caratti <dcaratti@redhat.com>
    act_mirred: use the backlog for nested calls to mirred ingress

Davide Caratti <dcaratti@redhat.com>
    net/sched: act_mirred: better wording on protection against excessive stack growth

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Fix initialization mistake for NBIO 7.3.0

lyndonli <Lyndon.Li@amd.com>
    drm/amdgpu: Fix call trace warning and hang when removing amdgpu device

Al Viro <viro@zeniv.linux.org.uk>
    sh: sanitize the flags on sigreturn

Swapnil Patel <Swapnil.Patel@amd.com>
    drm/amd/display: Update clock table to include highest clock setting

Enrico Sau <enrico.sau@gmail.com>
    net: usb: qmi_wwan: add Telit 0x1080 composition

Enrico Sau <enrico.sau@gmail.com>
    net: usb: cdc_mbim: avoid altsetting toggling for Telit FE990

Daniel Scally <dan.scally@ideasonboard.com>
    platform/x86: int3472: Add GPIOs to Surface Go 3 Board data

Michael Kelley <mikelley@microsoft.com>
    scsi: storvsc: Handle BlockSize change in Hyper-V VHD/VHDX file

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpi3mr: Bad drive in topology results kernel crash

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpi3mr: NVMe command size greater than 8K fails

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpi3mr: Wait for diagnostic save during controller init

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpi3mr: Driver unload crashes host when enhanced logging is enabled

Jakob Koschel <jkl820.git@gmail.com>
    scsi: lpfc: Avoid usage of list iterator variable after loop

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Check kzalloc() in lpfc_sli4_cgn_params_read()

Adrien Thierry <athierry@redhat.com>
    scsi: ufs: core: Add soft dependency on governor_simpleondemand

Kang Chen <void0red@gmail.com>
    scsi: hisi_sas: Check devm_add_action() return value

Daniel Wagner <dwagner@suse.de>
    scsi: qla2xxx: Add option to disable FC2 Target support

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: iscsi: Fix an error message in iscsi_check_key()

Lorenz Bauer <lorenz.bauer@isovalent.com>
    selftests/bpf: check that modifier resolves after pointer

Michael Schmitz <schmitzmic@gmail.com>
    m68k: Only force 030 bus error if PC not in exception table

Kars de Jong <jongk@linux-m68k.org>
    m68k: mm: Fix systems with memory at end of 32-bit address space

Reka Norman <rekanorman@chromium.org>
    HID: intel-ish-hid: ipc: Fix potential use-after-free in work function

Rafał Szalecki <perexist7@gmail.com>
    HID: logitech-hidpp: Add support for Logitech MX Master 3S mouse

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

Mario Limonciello <mario.limonciello@amd.com>
    ACPI: x86: Drop quirk for HP Elitebook

Duc Anh Le <lub.the.studio@gmail.com>
    ASoC: amd: yc: Add DMI entries to support HP OMEN 16-n0xxx (8A43)

Adrien Thierry <athierry@redhat.com>
    scsi: ufs: core: Initialize devfreq synchronously

Joseph Hunkeler <jhunkeler@gmail.com>
    ASoC: amd: yp: Add OMEN by HP Gaming Laptop 16z-n000 to quirks

Tom Rix <trix@redhat.com>
    thunderbolt: Rename shadowed variables bit to interrupt_bit and auto_clear_bit

Mario Limonciello <mario.limonciello@amd.com>
    thunderbolt: Use const qualifier for `ring_interrupt_index`

Gil Fine <gil.fine@linux.intel.com>
    thunderbolt: Add missing UNSET_INBOUND_SBTX for retimer access

Mario Limonciello <mario.limonciello@amd.com>
    thunderbolt: Disable interrupt auto clear for rings

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Fix memory leak in margining

Sanjay R Mehta <sanju.mehta@amd.com>
    thunderbolt: Add quirk to disable CLx

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Call tb_check_quirks() after initializing adapters

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Use scale field when allocating USB3 bandwidth

Yaroslav Furman <yaro330@gmail.com>
    uas: Add US_FL_NO_REPORT_OPCODES for JMicron JMS583Gen 2

Steve French <stfrench@microsoft.com>
    smb3: fix unusable share after force unmount failure

Steve French <stfrench@microsoft.com>
    smb3: lower default deferred close timeout to address perf regression

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

Breno Leitao <leitao@debian.org>
    perf/x86/amd/core: Always clear status for idx

Josh Poimboeuf <jpoimboe@kernel.org>
    entry: Fix noinstr warning in __enter_from_user_mode()

Tzung-Bi Shih <tzungbi@kernel.org>
    platform/chrome: cros_ec_chardev: fix kernel data leak from ioctl

Sungwoo Kim <iam@sung-woo.kim>
    Bluetooth: HCI: Fix global-out-of-bounds

Howard Chung <howardchung@google.com>
    Bluetooth: mgmt: Fix MGMT add advmon with RSSI command

Zheng Wang <zyytlz.wz@163.com>
    Bluetooth: btsdio: fix use after free bug in btsdio_remove due to unfinished work

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix responding with wrong PDU type

Stephan Gerhold <stephan.gerhold@kernkonzept.com>
    Bluetooth: btqcomsmd: Fix command timeout after setting BD address

Hersen Wu <hersenxs.wu@amd.com>
    drm/amd/display: Set dcn32 caps.seamless_odm

Liang He <windhl@126.com>
    net: mdio: thunder: Add missing fwnode_handle_put()

Arınç ÜNAL <arinc.unal@arinc9.com>
    net: dsa: mt7530: move setting ssc_delta to PHY_INTERFACE_MODE_TRGMII case

Arınç ÜNAL <arinc.unal@arinc9.com>
    net: dsa: mt7530: move lowering TRGMII driving to mt7530_setup()

Arınç ÜNAL <arinc.unal@arinc9.com>
    net: dsa: mt7530: move enabling disabling core clock to mt7530_pll_setup()

Grant Grundler <grundler@chromium.org>
    net: asix: fix modprobe "sysfs: cannot create duplicate filename"

Joshua Washington <joshwash@google.com>
    gve: Cache link_speed value from device

Brian Gix <brian.gix@gmail.com>
    Bluetooth: Remove "Power-on" check from Mesh feature

Pauli Virtanen <pav@iki.fi>
    Bluetooth: ISO: fix timestamped HCI ISO data packet parsing

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: btusb: Remove detection of ISO packets over bulk

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_core: Detect if an ACL packet is in fact an ISO packet

Zhengping Jiang <jiangzp@google.com>
    Bluetooth: hci_sync: Resume adv with no RPA when active scan

ChenXiaoSong <chenxiaosong2@huawei.com>
    ksmbd: fix possible refcount leak in smb2_open()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: add low bound validation to FSCTL_QUERY_ALLOCATED_RANGES

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: add low bound validation to FSCTL_SET_ZERO_DATA

Roger Pau Monne <roger.pau@citrix.com>
    hvc/xen: prevent concurrent accesses to the shared ring

Ido Schimmel <idosch@nvidia.com>
    mlxsw: spectrum_fid: Fix incorrect local port type

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

Emeel Hakim <ehakim@nvidia.com>
    net/mlx5e: Overcome slow response for first macsec ASO WQE

Lama Kayal <lkayal@nvidia.com>
    net/mlx5: Fix steering rules cleanup

Gavin Li <gavinl@nvidia.com>
    net/mlx5e: Block entering switchdev mode with ns inconsistency

Gavin Li <gavinl@nvidia.com>
    net/mlx5e: Set uplink rep as NETNS_LOCAL

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Adjust insufficient default bpf_jit_limit

Radoslaw Tyl <radoslawx.tyl@intel.com>
    i40e: fix flow director packet filter programming

Stefan Assmann <sassmann@kpanic.de>
    iavf: fix hang on reboot with ice

Michal Swiatkowski <michal.swiatkowski@intel.com>
    ice: check if VF exists before mode check

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

Szymon Heidrich <szymon.heidrich@gmail.com>
    net: usb: lan78xx: Limit packet length to skb->len

Zheng Wang <zyytlz.wz@163.com>
    net: qcom/emac: Fix use after free bug in emac_remove due to race condition

Andrzej Hajda <andrzej.hajda@intel.com>
    drm/i915/gt: perform uc late init after probe error injection

John Harrison <John.C.Harrison@Intel.com>
    drm/i915/guc: Fix missing ecodes

John Harrison <John.C.Harrison@Intel.com>
    drm/i915/guc: Rename GuC register state capture node to be more obvious

Tejas Upadhyay <tejas.upadhyay@intel.com>
    drm/i915/fbdev: lock the fbdev obj before vma pin

Nirmoy Das <nirmoy.das@intel.com>
    drm/i915: Print return value on error

Ido Schimmel <idosch@nvidia.com>
    mlxsw: core_thermal: Fix fan speed in maximum cooling state

Daniel Lezcano <daniel.lezcano@linaro.org>
    thermal/drivers/mellanox: Use generic thermal_zone_get_trip() function

Jochen Henneberg <jh@henneberg-systemdesign.com>
    net: stmmac: Fix for mismatched host/device DMA address width

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

Ard Biesheuvel <ardb@kernel.org>
    efi/libstub: smbios: Use length member instead of record struct size

Szymon Heidrich <szymon.heidrich@gmail.com>
    net: usb: smsc95xx: Limit packet length to skb->len

Álvaro Fernández Rojas <noltari@gmail.com>
    net: dsa: b53: mmap: fix device tree support

Jeff Layton <jlayton@kernel.org>
    nfsd: don't replace page in rq_pages if it's a continuation of last page

Yu Kuai <yukuai3@huawei.com>
    scsi: scsi_dh_alua: Fix memleak for 'qdata' in alua_activate()

Yicong Yang <yangyicong@hisilicon.com>
    i2c: hisi: Only use the completion interrupt to finish the transfer

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    i2c: mxs: ensure that DMA buffers are safe for DMA

Alexander Stein <alexander.stein@ew.tq-group.com>
    i2c: imx-lpi2c: check only for enabled interrupt flags

AKASHI Takahiro <takahiro.akashi@linaro.org>
    igc: fix the validation logic for taprio's gate list

Akihiko Odaki <akihiko.odaki@daynix.com>
    igbvf: Regard vf reset nack as success

Gaosheng Cui <cuigaosheng1@huawei.com>
    intel/igbvf: free irq on the error path in igbvf_request_msix()

Ahmed Zaki <ahmed.zaki@intel.com>
    iavf: do not track VLAN 0 filters

Alexander Lobakin <aleksander.lobakin@intel.com>
    iavf: fix non-tunneled IPv6 UDP packet type and hashing

Alexander Lobakin <aleksander.lobakin@intel.com>
    iavf: fix inverted Rx hash condition leading to disabled hash

Kal Conley <kal.conley@dectris.com>
    xsk: Add missing overflow check in xdp_umem_reg

Dave Wysochanski <dwysocha@redhat.com>
    NFS: Fix /proc/PID/io read_bytes for buffered reads

Alexander Stein <alexander.stein@ew.tq-group.com>
    arm64: dts: imx93: add missing #address-cells and #size-cells to i2c nodes

Marek Vasut <marex@denx.de>
    arm64: dts: imx8mn: specify #sound-dai-cells for SAI nodes

Peng Fan <peng.fan@nxp.com>
    ARM: dts: imx6sl: tolino-shine2hd: fix usbotg1 pinctrl

Peng Fan <peng.fan@nxp.com>
    ARM: dts: imx6sll: e60k02: fix usbotg1 pinctrl

Peng Fan <peng.fan@nxp.com>
    ARM: dts: imx6sll: e70k02: fix usbotg1 pinctrl

Andrew Halaney <ahalaney@redhat.com>
    arm64: dts: imx8dxl-evk: Fix eqos phy reset gpio

Wei Fang <wei.fang@nxp.com>
    arm64: dts: imx8dxl-evk: Disable hibernation mode of AR8031 for EQOS

Zheng Wang <zyytlz.wz@163.com>
    power: supply: da9150: Fix use after free bug in da9150_charger_remove due to race condition

Zheng Wang <zyytlz.wz@163.com>
    power: supply: bq24190: Fix use after free bug in bq24190_remove due to race condition

Manivannan Sadhasivam <mani@kernel.org>
    arm64: dts: qcom: sm8450: Mark UFS controller as cache coherent

Cruise Hung <Cruise.Hung@amd.com>
    drm/amd/display: Fix DP MST sinks removal issue

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix UaF in listener shutdown

Paolo Abeni <pabeni@redhat.com>
    mptcp: use the workqueue to destroy unaccepted sockets

Paolo Abeni <pabeni@redhat.com>
    mptcp: refactor passive socket initialization

Saaem Rizvi <SyedSaaem.Rizvi@amd.com>
    drm/amd/display: Remove OTG DIV register write for Virtual signals.

Aurabindo Pillai <aurabindo.pillai@amd.com>
    drm/amd/display: fix k1 k2 divider programming for phantom streams

Eric Bernstein <eric.bernstein@amd.com>
    drm/amd/display: Include virtual signal to set k1 and k2 values

Costa Shulyupin <costa.shul@redhat.com>
    tracing/hwlat: Replace sched_setaffinity with set_cpus_allowed_ptr

Song Liu <song@kernel.org>
    perf: fix perf_event_context->time

Yang Jihong <yangjihong1@huawei.com>
    perf/core: Fix perf_output_begin parameter is incorrectly invoked in perf_event_bpf_output

Konrad Dybcio <konrad.dybcio@linaro.org>
    interconnect: qcom: qcm2290: Fix MASTER_SNOC_BIMC_NRT

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    interconnect: qcom: sm8450: switch to qcom_icc_rpmh_* function

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    interconnect: qcom: osm-l3: fix icc_onecell_data allocation


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/e60k02.dtsi                      |   1 +
 arch/arm/boot/dts/e70k02.dtsi                      |   1 +
 arch/arm/boot/dts/imx6sl-tolino-shine2hd.dts       |   1 +
 arch/arm64/boot/dts/freescale/imx8dxl-evk.dts      |   6 +-
 .../boot/dts/freescale/imx8mm-nitrogen-r2.dts      |   2 +-
 arch/arm64/boot/dts/freescale/imx8mn.dtsi          |   5 +
 arch/arm64/boot/dts/freescale/imx93.dtsi           |  16 +
 arch/arm64/boot/dts/qcom/sc7280.dtsi               |   2 +
 arch/arm64/boot/dts/qcom/sm8150.dtsi               |   4 +-
 arch/arm64/boot/dts/qcom/sm8450.dtsi               |   1 +
 arch/m68k/kernel/traps.c                           |   4 +-
 arch/m68k/mm/motorola.c                            |  10 +-
 arch/riscv/Kconfig                                 |  22 ++
 arch/riscv/Makefile                                |  10 +-
 arch/riscv/include/asm/tlbflush.h                  |   2 +
 arch/riscv/include/uapi/asm/setup.h                |   8 +
 arch/riscv/mm/context.c                            |   2 +-
 arch/riscv/mm/tlbflush.c                           |   2 +-
 arch/sh/include/asm/processor_32.h                 |   1 +
 arch/sh/kernel/signal_32.c                         |   3 +
 arch/x86/events/amd/core.c                         |   3 +-
 arch/x86/kernel/fpu/xstate.c                       |  30 +-
 drivers/acpi/x86/s2idle.c                          |  24 --
 drivers/acpi/x86/utils.c                           |  37 +--
 drivers/atm/idt77252.c                             |  11 +
 drivers/bluetooth/btqcomsmd.c                      |  17 +-
 drivers/bluetooth/btsdio.c                         |   1 +
 drivers/bluetooth/btusb.c                          |  10 -
 drivers/bus/imx-weim.c                             |   2 +-
 drivers/firmware/arm_scmi/mailbox.c                |  37 +++
 drivers/firmware/efi/libstub/smbios.c              |   2 +-
 drivers/firmware/efi/sysfb_efi.c                   |   5 +-
 drivers/firmware/sysfb.c                           |   4 +-
 drivers/firmware/sysfb_simplefb.c                  |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c           |  41 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  15 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c         |   2 +-
 drivers/gpu/drm/amd/amdgpu/nbio_v7_2.c             |  14 +-
 drivers/gpu/drm/amd/amdgpu/nv.c                    |   2 +-
 drivers/gpu/drm/amd/amdgpu/vi.c                    |  17 +-
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c              | 364 +++++----------------
 drivers/gpu/drm/amd/amdkfd/kfd_crat.h              |  12 +
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |   2 +
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c          | 245 +++++++++++++-
 drivers/gpu/drm/amd/amdkfd/kfd_topology.h          |   5 +-
 .../drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c |  19 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link.c      |   9 +
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.c  |   3 +-
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c |   4 +-
 .../gpu/drm/amd/display/dc/dcn32/dcn32_resource.c  |   1 +
 drivers/gpu/drm/bridge/lontium-lt8912b.c           |   4 +-
 drivers/gpu/drm/i915/display/intel_display.c       |   1 +
 drivers/gpu/drm/i915/display/intel_fbdev.c         |  28 +-
 drivers/gpu/drm/i915/gt/intel_gt.c                 |   4 +-
 drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c     |  30 +-
 drivers/gpu/drm/i915/i915_active.c                 |   3 +-
 drivers/gpu/drm/i915/i915_gpu_error.h              |   2 +-
 drivers/gpu/drm/meson/meson_drv.c                  |  13 +-
 drivers/gpu/drm/tiny/cirrus.c                      |   2 +-
 drivers/hid/hid-cp2112.c                           |   1 +
 drivers/hid/hid-logitech-hidpp.c                   |   2 +
 drivers/hid/intel-ish-hid/ipc/ipc.c                |   9 +-
 drivers/hwmon/hwmon.c                              |   7 +-
 drivers/hwmon/it87.c                               |   4 +-
 drivers/i2c/busses/i2c-hisi.c                      |   6 +-
 drivers/i2c/busses/i2c-imx-lpi2c.c                 |   4 +
 drivers/i2c/busses/i2c-mxs.c                       |  18 +-
 drivers/i2c/busses/i2c-xgene-slimpro.c             |   3 +
 drivers/interconnect/qcom/osm-l3.c                 |   2 +-
 drivers/interconnect/qcom/qcm2290.c                |   4 +-
 drivers/interconnect/qcom/sm8450.c                 |  98 +-----
 drivers/md/dm-crypt.c                              |  16 +-
 drivers/md/dm-stats.c                              |   7 +-
 drivers/md/dm-stats.h                              |   2 +-
 drivers/md/dm-thin.c                               |   2 +
 drivers/md/dm.c                                    |   4 +-
 drivers/net/dsa/b53/b53_mmap.c                     |   2 +-
 drivers/net/dsa/mt7530.c                           |  49 +--
 drivers/net/ethernet/google/gve/gve_ethtool.c      |   5 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |   8 +-
 drivers/net/ethernet/intel/iavf/iavf_common.c      |   2 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  13 +
 drivers/net/ethernet/intel/iavf/iavf_txrx.c        |   2 +-
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    |   2 -
 drivers/net/ethernet/intel/ice/ice_sriov.c         |   8 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |   2 -
 drivers/net/ethernet/intel/igbvf/netdev.c          |   8 +-
 drivers/net/ethernet/intel/igbvf/vf.c              |  13 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |  20 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |   2 +
 .../ethernet/mellanox/mlx5/core/en_accel/macsec.c  |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   6 +-
 .../mellanox/mlx5/core/esw/acl/ingress_ofld.c      |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   1 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  19 ++
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c | 216 +++---------
 drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c |   4 +-
 drivers/net/ethernet/natsemi/sonic.c               |   4 +-
 drivers/net/ethernet/qlogic/qed/qed_sriov.c        |   5 +-
 drivers/net/ethernet/qualcomm/emac/emac.c          |   6 +
 drivers/net/ethernet/stmicro/stmmac/common.h       |   1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c    |   2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c  |   4 +-
 .../net/ethernet/stmicro/stmmac/dwmac-mediatek.c   |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  30 +-
 drivers/net/ethernet/toshiba/ps3_gelic_net.c       |  41 +--
 drivers/net/ethernet/toshiba/ps3_gelic_net.h       |   5 +-
 drivers/net/ethernet/xircom/xirc2ps_cs.c           |   5 +
 drivers/net/ieee802154/ca8210.c                    |   2 +
 drivers/net/mdio/acpi_mdio.c                       |  10 +-
 drivers/net/mdio/mdio-thunder.c                    |   1 +
 drivers/net/mdio/of_mdio.c                         |  12 +-
 drivers/net/phy/mdio_devres.c                      |  11 +-
 drivers/net/phy/phy.c                              |  23 +-
 drivers/net/usb/asix_devices.c                     |  32 +-
 drivers/net/usb/cdc_mbim.c                         |   5 +
 drivers/net/usb/lan78xx.c                          |  18 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/usb/smsc95xx.c                         |   6 +
 drivers/platform/chrome/cros_ec_chardev.c          |   2 +-
 .../x86/intel/int3472/tps68470_board_data.c        |   5 +-
 drivers/power/supply/bq24190_charger.c             |   1 +
 drivers/power/supply/da9150-charger.c              |   1 +
 drivers/scsi/device_handler/scsi_dh_alua.c         |   6 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |   3 +-
 drivers/scsi/lpfc/lpfc_init.c                      |   2 +
 drivers/scsi/lpfc/lpfc_sli.c                       |  12 +-
 drivers/scsi/mpi3mr/mpi3mr_app.c                   |   4 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c                    |  19 +-
 drivers/scsi/mpi3mr/mpi3mr_transport.c             |  15 +-
 drivers/scsi/qla2xxx/qla_gbl.h                     |   1 +
 drivers/scsi/qla2xxx/qla_init.c                    |   3 +-
 drivers/scsi/qla2xxx/qla_isr.c                     |   3 +-
 drivers/scsi/qla2xxx/qla_os.c                      |  21 +-
 drivers/scsi/scsi_devinfo.c                        |   1 +
 drivers/scsi/storvsc_drv.c                         |  16 +
 drivers/soc/qcom/llcc-qcom.c                       |   6 +-
 drivers/target/iscsi/iscsi_target_parameters.c     |  12 +-
 drivers/tee/amdtee/core.c                          |  29 +-
 drivers/thunderbolt/debugfs.c                      |  12 +-
 drivers/thunderbolt/nhi.c                          |  49 +--
 drivers/thunderbolt/nhi_regs.h                     |   6 +-
 drivers/thunderbolt/quirks.c                       |  13 +
 drivers/thunderbolt/retimer.c                      |  23 +-
 drivers/thunderbolt/sb_regs.h                      |   1 +
 drivers/thunderbolt/switch.c                       |   4 +-
 drivers/thunderbolt/tb.h                           |  12 +-
 drivers/thunderbolt/usb4.c                         |  36 +-
 drivers/tty/hvc/hvc_xen.c                          |  19 +-
 drivers/ufs/core/ufshcd.c                          |  48 ++-
 drivers/usb/cdns3/cdns3-pci-wrap.c                 |   5 +
 drivers/usb/cdns3/cdnsp-ep0.c                      |  19 +-
 drivers/usb/cdns3/cdnsp-pci.c                      |  27 +-
 drivers/usb/chipidea/ci.h                          |   2 +
 drivers/usb/chipidea/core.c                        |  11 +-
 drivers/usb/chipidea/otg.c                         |   5 +-
 drivers/usb/dwc2/drd.c                             |   3 +-
 drivers/usb/dwc2/platform.c                        |  16 +-
 drivers/usb/dwc3/gadget.c                          |  14 +-
 drivers/usb/gadget/function/u_audio.c              |   2 +-
 drivers/usb/misc/onboard_usb_hub.c                 |   1 +
 drivers/usb/misc/onboard_usb_hub.h                 |   1 +
 drivers/usb/storage/unusual_uas.h                  |   7 +
 drivers/usb/typec/tcpm/tcpm.c                      |  28 +-
 drivers/usb/typec/ucsi/ucsi.c                      |  11 +-
 drivers/usb/typec/ucsi/ucsi_acpi.c                 |   2 +-
 fs/btrfs/zoned.c                                   |  14 +-
 fs/cifs/cached_dir.c                               |  37 ++-
 fs/cifs/cifs_debug.c                               |  46 ++-
 fs/cifs/cifsfs.c                                   |   9 +-
 fs/cifs/cifssmb.c                                  |   6 +-
 fs/cifs/connect.c                                  |  14 +-
 fs/cifs/fs_context.h                               |   2 +-
 fs/cifs/link.c                                     |   2 +
 fs/cifs/smb2inode.c                                |   1 +
 fs/cifs/smb2ops.c                                  |  27 +-
 fs/cifs/smb2pdu.c                                  |  12 +-
 fs/cifs/trace.h                                    |  12 +-
 fs/ksmbd/auth.c                                    |   5 +-
 fs/ksmbd/connection.c                              |  11 +-
 fs/ksmbd/connection.h                              |   3 +-
 fs/ksmbd/smb2pdu.c                                 |  20 +-
 fs/ksmbd/smb_common.c                              |  27 +-
 fs/ksmbd/smb_common.h                              |  30 +-
 fs/ksmbd/transport_rdma.c                          |   2 +-
 fs/ksmbd/transport_tcp.c                           |  35 +-
 fs/lockd/clnt4xdr.c                                |   9 +-
 fs/lockd/xdr4.c                                    |  13 +-
 fs/nfs/read.c                                      |   3 +
 fs/nfsd/vfs.c                                      |   9 +-
 fs/nilfs2/ioctl.c                                  |   2 +-
 fs/super.c                                         |  15 +-
 fs/verity/verify.c                                 |  12 +-
 include/linux/acpi_mdio.h                          |   9 +-
 include/linux/context_tracking.h                   |   1 +
 include/linux/context_tracking_state.h             |   2 +
 include/linux/lockd/xdr4.h                         |   1 +
 include/linux/nvme-tcp.h                           |   5 +-
 include/linux/of_mdio.h                            |  22 +-
 include/linux/stmmac.h                             |   2 +-
 include/linux/sysfb.h                              |   9 +-
 include/ufs/ufshcd.h                               |   1 +
 io_uring/filetable.c                               |   3 +
 io_uring/net.c                                     |  25 +-
 io_uring/rsrc.c                                    |   1 +
 kernel/bpf/core.c                                  |   2 +-
 kernel/entry/common.c                              |   5 +-
 kernel/events/core.c                               |   4 +-
 kernel/sched/core.c                                |   3 +
 kernel/sched/fair.c                                |  54 ++-
 kernel/trace/trace_hwlat.c                         |   4 +-
 lib/maple_tree.c                                   |  24 +-
 lib/test_maple_tree.c                              |  48 +++
 mm/kfence/Makefile                                 |   2 +-
 mm/kfence/core.c                                   |  10 +-
 mm/ksm.c                                           |  11 +-
 mm/page_alloc.c                                    |   3 +-
 mm/slab.c                                          |   2 +-
 net/bluetooth/hci_core.c                           |  23 +-
 net/bluetooth/hci_sync.c                           |  68 ++--
 net/bluetooth/iso.c                                |   9 +-
 net/bluetooth/l2cap_core.c                         | 117 ++++---
 net/bluetooth/mgmt.c                               |   9 +-
 net/dsa/tag_brcm.c                                 |  10 +-
 net/ipv4/ip_gre.c                                  |   4 +-
 net/ipv6/ip6_gre.c                                 |   4 +-
 net/mac80211/wme.c                                 |   6 +-
 net/mptcp/protocol.c                               |  63 ++--
 net/mptcp/protocol.h                               |   6 +-
 net/mptcp/subflow.c                                | 116 ++-----
 net/sched/act_mirred.c                             |  23 +-
 net/xdp/xdp_umem.c                                 |  13 +-
 security/keys/request_key.c                        |   9 +-
 sound/soc/amd/yc/acp6x-mach.c                      |  14 +
 tools/bootconfig/test-bootconfig.sh                |  12 +-
 tools/testing/selftests/bpf/prog_tests/btf.c       |  28 ++
 .../testing/selftests/net/forwarding/tc_actions.sh |  49 ++-
 tools/testing/selftests/x86/amx.c                  | 108 +++++-
 242 files changed, 2367 insertions(+), 1453 deletions(-)


