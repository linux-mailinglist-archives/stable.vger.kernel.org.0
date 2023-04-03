Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3CAB6D47DA
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbjDCOXz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233213AbjDCOXx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:23:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F3042223E;
        Mon,  3 Apr 2023 07:23:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92E7261D68;
        Mon,  3 Apr 2023 14:23:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53E1EC433EF;
        Mon,  3 Apr 2023 14:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531824;
        bh=I7kg833DLd3okShOuTga8T0rvO+SHU4Q+jO55FacO7k=;
        h=From:To:Cc:Subject:Date:From;
        b=soUKBphGILTVdmawMaIQcYQGMI130IZ6H/j8OY69muu08f/sPoiP/7+jYaD9luO0n
         qkoobPkOies+2gj91+rNk73TUPHXUVnwfltYTXdq2bMukxdJdAWdutpyh1tRZFdJX4
         XbjYZi6ZtUc4tDFGZmXoewtqX0jMVu/E94GwyyLA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.10 000/173] 5.10.177-rc1 review
Date:   Mon,  3 Apr 2023 16:06:55 +0200
Message-Id: <20230403140414.174516815@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.177-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.177-rc1
X-KernelTest-Deadline: 2023-04-05T14:04+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.177 release.
There are 173 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.177-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.177-rc1

Matthieu Baerts <matthieu.baerts@tessares.net>
    hsr: ratelimit only when errors are printed

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Always check inode size of inline inodes

Ye Bin <yebin10@huawei.com>
    ext4: fix kernel BUG in 'ext4_write_inline_data_end()'

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Fix btf_dump's packed struct determination

Andrii Nakryiko <andrii@kernel.org>
    selftests/bpf: Add few corner cases to test padding handling of btf_dump

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Fix BTF-to-C converter's padding logic

Eduard Zingerman <eddyz87@gmail.com>
    selftests/bpf: Test btf dump for struct with padding only fields

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    zonefs: Fix error message in zonefs_file_dio_append()

Anand Jain <anand.jain@oracle.com>
    btrfs: scan device in non-exclusive mode

Heiko Carstens <hca@linux.ibm.com>
    s390/uaccess: add missing earlyclobber annotations to __clear_user()

Fangzhi Zuo <Jerry.Zuo@amd.com>
    drm/amd/display: Add DSC Support for Synaptics Cascaded MST Hub

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: fix reference leak when mmaping imported buffer

Douglas Raillard <douglas.raillard@arm.com>
    rcu: Fix rcu_torture_read ftrace event

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: fix KASAN report for show_stack

huangwenhui <huangwenhuia@uniontech.com>
    ALSA: hda/realtek: Add quirk for Lenovo ZhaoYang CF4620Z

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix regression on detection of Roland VS-100

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/conexant: Partial revert of a quirk for Lenovo

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix hangs when recovering open state after a server reboot

Jens Axboe <axboe@kernel.dk>
    powerpc: Don't try to copy PPR for task with NULL pt_regs

Johan Hovold <johan+linaro@kernel.org>
    pinctrl: at91-pio4: fix domain name assignment

Kornel Dulęba <korneld@chromium.org>
    pinctrl: amd: Disable and mask interrupts on resume

Josua Mayer <josua@solid-run.com>
    net: phy: dp83869: fix default value for tx-/rx-internal-delay

Juergen Gross <jgross@suse.com>
    xen/netback: don't do grant copy across page boundary

Filipe Manana <fdmanana@suse.com>
    btrfs: fix race between quota disable and quota assign ioctls

Hans de Goede <hdegoede@redhat.com>
    Input: goodix - add Lenovo Yoga Book X90F to nine_bytes_report DMI table

David Disseldorp <ddiss@suse.de>
    cifs: fix DFS traversal oops without CONFIG_CIFS_DFS_UPCALL

Paulo Alcantara <pc@manguebit.com>
    cifs: prevent infinite recursion in CIFSGetDFSRefer()

Jason A. Donenfeld <Jason@zx2c4.com>
    Input: focaltech - use explicitly signed char type

msizanoen <msizanoen@qtmlabs.xyz>
    Input: alps - fix compatibility with -funsigned-char

Horatiu Vultur <horatiu.vultur@microchip.com>
    pinctrl: ocelot: Fix alt mode for ocelot

Steffen Bätz <steffen@innosonix.de>
    net: dsa: mv88e6xxx: Enable IGMP snooping on user ports only

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Add missing 200G link speed reporting

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    bnxt_en: Fix typo in PCI id to device description string mapping

Radoslaw Tyl <radoslawx.tyl@intel.com>
    i40e: fix registers dump after run ethtool adapter self test

Alex Elder <elder@linaro.org>
    net: ipa: compute DMA pool size properly

Tasos Sahanidis <tasos@tasossah.com>
    ALSA: ymfpci: Fix BUG_ON in probe function

Takashi Iwai <tiwai@suse.de>
    ALSA: ymfpci: Fix assignment in if condition

Tony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: fix memory leak in vfio_ap device driver

Ivan Orlov <ivan.orlov0322@gmail.com>
    can: bcm: bcm_tx_setup(): fix KMSAN uninit-value in vfs_write

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: stmmac: don't reject VLANs when IFF_PROMISC is set

Faicker Mo <faicker.mo@ucloud.cn>
    net/net_failover: fix txq exceeding warning

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    regulator: Handle deferred clk

ChunHao Lin <hau@realtek.com>
    r8169: fix RTL8168H and RTL8107E rx crc error

SongJingyi <u201912584@hust.edu.cn>
    ptp_qoriq: fix memory leak in probe()

Tomas Henzl <thenzl@redhat.com>
    scsi: megaraid_sas: Fix crash after a double completion

Íñigo Huguet <ihuguet@redhat.com>
    sfc: ef10: don't overwrite offload features at NIC reset

Arseniy Krasnov <avkrasnov@sberdevices.ru>
    mtd: rawnand: meson: invalidate cache on polling ECC bit

Álvaro Fernández Rojas <noltari@gmail.com>
    mips: bmips: BCM6358: disable RAC flush for TP1

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    ca8210: Fix unsigned mac_len comparison with zero in ca8210_skb_tx()

Anton Gusev <aagusev@ispras.ru>
    tracing: Fix wrong return in kprobe_event_gen_test.c

Prarit Bhargava <prarit@redhat.com>
    tools/power turbostat: Fix /dev/cpu_dma_latency warnings

Wei Chen <harperchen1110@gmail.com>
    fbdev: au1200fb: Fix potential divide by zero

Wei Chen <harperchen1110@gmail.com>
    fbdev: lxfb: Fix potential divide by zero

Wei Chen <harperchen1110@gmail.com>
    fbdev: intelfb: Fix potential divide by zero

Wei Chen <harperchen1110@gmail.com>
    fbdev: nvidia: Fix potential divide by zero

Linus Torvalds <torvalds@linux-foundation.org>
    sched_getaffinity: don't assume 'cpumask_size()' is fully initialized

Wei Chen <harperchen1110@gmail.com>
    fbdev: tgafb: Fix potential divide by zero

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ALSA: hda/ca0132: fixup buffer overrun at tuning_ctl_set()

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ALSA: asihpi: check pao in control_message()

Kristian Overskeid <koverskeid@gmail.com>
    net: hsr: Don't log netdev_err message on unknown prp dst node

NeilBrown <neilb@suse.de>
    md: avoid signed overflow in slot_store()

Eric Biggers <ebiggers@google.com>
    fsverity: don't drop pagecache at end of FS_IOC_ENABLE_VERITY

Mike Snitzer <snitzer@kernel.org>
    dm crypt: avoid accessing uninitialized tasklet

Ivan Bornyakov <i.bornyakov@metrotek.ru>
    bus: imx-weim: fix branch condition evaluates to a garbage value

Johan Hovold <johan+linaro@kernel.org>
    drm/meson: fix missing component unbind on bind errors

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    drm/meson: Fix error handling when afbcd.ops->init fails

Marco Elver <elver@google.com>
    kcsan: avoid passing -g for test

Anders Roxell <anders.roxell@linaro.org>
    kernel: kcsan: kcsan_test: build without structleak plugin

Wesley Cheng <quic_wcheng@quicinc.com>
    usb: dwc3: gadget: Add 1ms delay after end transfer command without IOC

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: dwc3: gadget: move cmd_endtransfer to extra function

Dai Ngo <dai.ngo@oracle.com>
    NFSD: fix use-after-free in __nfs42_ssc_open()

Miaohe Lin <linmiaohe@huawei.com>
    KVM: fix memoryleak in kvm_init()

Brian Foster <bfoster@redhat.com>
    xfs: don't reuse busy extents on extent trim

Darrick J. Wong <djwong@kernel.org>
    xfs: shut down the filesystem if we screw up quota reservation

Jan Kara via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
    ocfs2: fix data corruption after failed write

Vincent Guittot <vincent.guittot@linaro.org>
    sched/fair: Sanitize vruntime of entity being migrated

Zhang Qiao <zhangqiao22@huawei.com>
    sched/fair: sanitize vruntime of entity being placed

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

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Preserve crtc_state->inherited during state clearing

Nirmoy Das <nirmoy.das@intel.com>
    drm/i915/active: Fix missing debug object activation

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix kernel-infoleak in nilfs_ioctl_wrap_copy()

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: fix qos on mesh interfaces

Hans de Goede <hdegoede@redhat.com>
    usb: ucsi: Fix NULL pointer deref in ucsi_connector_change()

Xu Yang <xu.yang_2@nxp.com>
    usb: chipidea: core: fix possible concurrent when switch role

Xu Yang <xu.yang_2@nxp.com>
    usb: chipdea: core: fix return -EINVAL if request role is the same with current role

Pawel Laszczak <pawell@cadence.com>
    usb: cdns3: Fix issue with using incorrect PCI device function

Coly Li <colyli@suse.de>
    dm thin: fix deadlock when swapping to thin device

Lin Ma <linma@zju.edu.cn>
    igb: revert rtnl_lock() that causes deadlock

Nathan Huckleberry <nhuck@google.com>
    fsverity: Remove WQ_UNBOUND from fsverity read workqueue

Alvin Šipraga <alsi@bang-olufsen.dk>
    usb: gadget: u_audio: don't let userspace block driver unbind

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    usb: dwc2: fix a devres leak in hw_enable upon suspend resume

Joel Selvaraj <joelselvaraj.oss@gmail.com>
    scsi: core: Add BLIST_SKIP_VPD_PAGES for SKhynix H28U74301AMR

Shyam Prasad N <sprasad@microsoft.com>
    cifs: empty interface list when server doesn't support query interfaces

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

Alexander Aring <aahringo@redhat.com>
    ca8210: fix mac_len negative array access

Danny Kaehn <kaehndan@gmail.com>
    HID: cp2112: Fix driver not registering GPIO IRQ chip as threaded

Alexandre Ghiti <alex@ghiti.fr>
    riscv: Bump COMMAND_LINE_SIZE value to 1024

Mario Limonciello <mario.limonciello@amd.com>
    thunderbolt: Use const qualifier for `ring_interrupt_index`

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Use scale field when allocating USB3 bandwidth

Yaroslav Furman <yaro330@gmail.com>
    uas: Add US_FL_NO_REPORT_OPCODES for JMicron JMS583Gen 2

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Perform lockless command completion in abort path

Frank Crawford <frank@crawford.emu.id.au>
    hwmon (it87): Fix voltage scaling for chips with 10.9mV ADCs

Phinex Hung <phinex@realtek.com>
    hwmon: fix potential sensor registration fail if of_node is missing

Tzung-Bi Shih <tzungbi@kernel.org>
    platform/chrome: cros_ec_chardev: fix kernel data leak from ioctl

Zheng Wang <zyytlz.wz@163.com>
    Bluetooth: btsdio: fix use after free bug in btsdio_remove due to unfinished work

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix responding with wrong PDU type

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix not checking for maximum number of DCID

Stephan Gerhold <stephan.gerhold@kernkonzept.com>
    Bluetooth: btqcomsmd: Fix command timeout after setting BD address

Liang He <windhl@126.com>
    net: mdio: thunder: Add missing fwnode_handle_put()

Arınç ÜNAL <arinc.unal@arinc9.com>
    net: dsa: mt7530: move setting ssc_delta to PHY_INTERFACE_MODE_TRGMII case

Joshua Washington <joshwash@google.com>
    gve: Cache link_speed value from device

Caleb Sander <csander@purestorage.com>
    nvme-tcp: fix nvme_tcp_term_pdu to match spec

Zhang Changzhong <zhangchangzhong@huawei.com>
    net/sonic: use dma_mapping_error() for error check

Eric Dumazet <edumazet@google.com>
    erspan: do not use skb_mac_header() in ndo_start_xmit()

Li Zetao <lizetao1@huawei.com>
    atm: idt77252: fix kmemleak when rmmod idt77252

Dan Carpenter <error27@gmail.com>
    net/mlx5: E-Switch, Fix an Oops in error handling code

Maher Sanalla <msanalla@nvidia.com>
    net/mlx5: Read the TC mapping of all priorities on ETS query

Lama Kayal <lkayal@nvidia.com>
    net/mlx5: Fix steering rules cleanup

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Adjust insufficient default bpf_jit_limit

David Howells <dhowells@redhat.com>
    keys: Do not cache key in task struct if key is requested from kernel thread

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    bootconfig: Fix testcase to increase max node

Geoff Levand <geoff@infradead.org>
    net/ps3_gelic_net: Use dma_mapping_error

Geoff Levand <geoff@infradead.org>
    net/ps3_gelic_net: Fix RX sk_buff length

Zheng Wang <zyytlz.wz@163.com>
    net: qcom/emac: Fix use after free bug in emac_remove due to race condition

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

Yu Kuai <yukuai3@huawei.com>
    scsi: scsi_dh_alua: Fix memleak for 'qdata' in alua_activate()

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

Johan Hovold <johan+linaro@kernel.org>
    drm/sun4i: fix missing component unbind on bind errors

Randy Dunlap <rdunlap@infradead.org>
    serial: 8250: ASPEED_VUART: select REGMAP instead of depending on it

Geert Uytterhoeven <geert+renesas@glider.be>
    serial: 8250: SERIAL_8250_ASPEED_VUART should depend on ARCH_ASPEED

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    tty: serial: fsl_lpuart: fix race on RX DMA shutdown

Jason Wang <wangborong@cdjrlc.com>
    serial: fsl_lpuart: Fix comment typo

Sean Christopherson <seanjc@google.com>
    KVM: Register /dev/kvm as the _very_ last thing during initialization

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: Pre-allocate cpumasks for kvm_make_all_cpus_request_except()

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: Optimize kvm_make_vcpus_request_mask() a bit

Sean Christopherson <seanjc@google.com>
    KVM: KVM: Use cpumask_available() to check for NULL cpumask when kicking vCPUs

Sean Christopherson <seanjc@google.com>
    KVM: Clean up benign vcpu->cpu data races when kicking vCPUs

Corey Minyard <cminyard@mvista.com>
    ipmi:ssif: Add a timer between request retries

Corey Minyard <cminyard@mvista.com>
    ipmi:ssif: resend_msg() cannot fail

Corey Minyard <cminyard@mvista.com>
    ipmi:ssif: Increase the message retry time

Liguang Zhang <zhangliguang@linux.alibaba.com>
    ipmi:ssif: make ssif_i2c_send() void

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
 arch/m68k/kernel/traps.c                           |   4 +-
 arch/mips/bmips/dma.c                              |   5 +
 arch/mips/bmips/setup.c                            |   8 +
 arch/powerpc/kernel/ptrace/ptrace-view.c           |   6 +
 arch/riscv/include/uapi/asm/setup.h                |   8 +
 arch/s390/lib/uaccess.c                            |   2 +-
 arch/sh/include/asm/processor_32.h                 |   1 +
 arch/sh/kernel/signal_32.c                         |   3 +
 arch/xtensa/kernel/traps.c                         |  16 +-
 drivers/atm/idt77252.c                             |  11 ++
 drivers/bluetooth/btqcomsmd.c                      |  17 +-
 drivers/bluetooth/btsdio.c                         |   1 +
 drivers/bus/imx-weim.c                             |   2 +-
 drivers/char/ipmi/ipmi_ssif.c                      | 137 ++++++-----------
 drivers/firmware/arm_scmi/mailbox.c                |  37 +++++
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |  19 +++
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.h    |  12 ++
 drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c        |  10 +-
 drivers/gpu/drm/i915/display/intel_display.c       |   1 +
 drivers/gpu/drm/i915/i915_active.c                 |   3 +-
 drivers/gpu/drm/meson/meson_drv.c                  |  20 ++-
 drivers/gpu/drm/sun4i/sun4i_drv.c                  |   4 +-
 drivers/hid/hid-cp2112.c                           |   1 +
 drivers/hwmon/hwmon.c                              |   7 +-
 drivers/hwmon/it87.c                               |   4 +-
 drivers/i2c/busses/i2c-imx-lpi2c.c                 |   4 +
 drivers/i2c/busses/i2c-xgene-slimpro.c             |   3 +
 drivers/input/mouse/alps.c                         |  16 +-
 drivers/input/mouse/focaltech.c                    |   8 +-
 drivers/input/touchscreen/goodix.c                 |  14 +-
 drivers/interconnect/qcom/osm-l3.c                 |   2 +-
 drivers/md/dm-crypt.c                              |  16 +-
 drivers/md/dm-stats.c                              |   7 +-
 drivers/md/dm-stats.h                              |   2 +-
 drivers/md/dm-thin.c                               |   2 +
 drivers/md/dm.c                                    |   4 +-
 drivers/md/md.c                                    |   3 +
 drivers/mtd/nand/raw/meson_nand.c                  |   8 +-
 drivers/net/dsa/mt7530.c                           |   9 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |   9 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   8 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |   2 +
 drivers/net/ethernet/google/gve/gve_ethtool.c      |   5 +-
 drivers/net/ethernet/intel/i40e/i40e_diag.c        |  11 +-
 drivers/net/ethernet/intel/i40e/i40e_diag.h        |   2 +-
 drivers/net/ethernet/intel/iavf/iavf_common.c      |   2 +-
 drivers/net/ethernet/intel/iavf/iavf_txrx.c        |   2 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |   2 -
 drivers/net/ethernet/intel/igbvf/netdev.c          |   8 +-
 drivers/net/ethernet/intel/igbvf/vf.c              |  13 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |  20 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |   6 +-
 .../mellanox/mlx5/core/esw/acl/ingress_ofld.c      |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   1 +
 drivers/net/ethernet/natsemi/sonic.c               |   4 +-
 drivers/net/ethernet/qlogic/qed/qed_sriov.c        |   5 +-
 drivers/net/ethernet/qualcomm/emac/emac.c          |   6 +
 drivers/net/ethernet/realtek/r8169_phy_config.c    |   3 +
 drivers/net/ethernet/sfc/ef10.c                    |  38 +++--
 drivers/net/ethernet/sfc/efx.c                     |  17 +-
 drivers/net/ethernet/stmicro/stmmac/common.h       |   1 -
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |  61 +-------
 drivers/net/ethernet/toshiba/ps3_gelic_net.c       |  41 ++---
 drivers/net/ethernet/toshiba/ps3_gelic_net.h       |   5 +-
 drivers/net/ethernet/xircom/xirc2ps_cs.c           |   5 +
 drivers/net/ieee802154/ca8210.c                    |   5 +-
 drivers/net/ipa/gsi_trans.c                        |   2 +-
 drivers/net/mdio/mdio-thunder.c                    |   1 +
 drivers/net/mdio/of_mdio.c                         |  12 +-
 drivers/net/net_failover.c                         |   8 +-
 drivers/net/phy/dp83869.c                          |   6 +-
 drivers/net/phy/mdio_devres.c                      |  11 +-
 drivers/net/phy/phy.c                              |  23 ++-
 drivers/net/usb/cdc_mbim.c                         |   5 +
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/usb/smsc95xx.c                         |   6 +
 drivers/net/xen-netback/common.h                   |   2 +-
 drivers/net/xen-netback/netback.c                  |  25 ++-
 drivers/pinctrl/pinctrl-amd.c                      |  36 +++--
 drivers/pinctrl/pinctrl-at91-pio4.c                |   1 -
 drivers/pinctrl/pinctrl-ocelot.c                   |   2 +-
 drivers/platform/chrome/cros_ec_chardev.c          |   2 +-
 drivers/power/supply/bq24190_charger.c             |  64 +++-----
 drivers/power/supply/da9150-charger.c              |   1 +
 drivers/ptp/ptp_qoriq.c                            |   2 +-
 drivers/regulator/fixed.c                          |   2 +-
 drivers/s390/crypto/vfio_ap_drv.c                  |   3 +-
 drivers/scsi/device_handler/scsi_dh_alua.c         |   6 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |   3 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |   8 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c        |   4 +-
 drivers/scsi/qla2xxx/qla_os.c                      |  11 ++
 drivers/scsi/scsi_devinfo.c                        |   1 +
 drivers/scsi/storvsc_drv.c                         |  16 ++
 drivers/scsi/ufs/ufshcd.c                          |   1 +
 drivers/target/iscsi/iscsi_target_parameters.c     |  12 +-
 drivers/tee/amdtee/core.c                          |  29 ++--
 drivers/thunderbolt/nhi.c                          |   2 +-
 drivers/thunderbolt/usb4.c                         |  22 ++-
 drivers/tty/serial/8250/Kconfig                    |   4 +-
 drivers/tty/serial/fsl_lpuart.c                    |  13 +-
 drivers/usb/cdns3/cdns3-pci-wrap.c                 |   5 +
 drivers/usb/chipidea/ci.h                          |   2 +
 drivers/usb/chipidea/core.c                        |  11 +-
 drivers/usb/chipidea/otg.c                         |   5 +-
 drivers/usb/dwc2/platform.c                        |  16 +-
 drivers/usb/dwc3/gadget.c                          |  79 ++++++----
 drivers/usb/gadget/function/u_audio.c              |   2 +-
 drivers/usb/storage/unusual_uas.h                  |   7 +
 drivers/usb/typec/ucsi/ucsi.c                      |  11 +-
 drivers/video/fbdev/au1200fb.c                     |   3 +
 drivers/video/fbdev/geode/lxfb_core.c              |   3 +
 drivers/video/fbdev/intelfb/intelfbdrv.c           |   3 +
 drivers/video/fbdev/nvidia/nvidia.c                |   2 +
 drivers/video/fbdev/tgafb.c                        |   3 +
 fs/btrfs/ioctl.c                                   |   2 +
 fs/btrfs/qgroup.c                                  |  11 +-
 fs/btrfs/volumes.c                                 |  11 +-
 fs/cifs/cifsfs.h                                   |   5 +-
 fs/cifs/cifssmb.c                                  |   9 +-
 fs/cifs/smb2ops.c                                  |   2 +-
 fs/ext4/inode.c                                    |   3 +-
 fs/gfs2/aops.c                                     |   2 -
 fs/gfs2/bmap.c                                     |   3 -
 fs/gfs2/glops.c                                    |   3 +
 fs/nfs/nfs4proc.c                                  |   5 +-
 fs/nfsd/nfs4proc.c                                 |  22 +--
 fs/nilfs2/ioctl.c                                  |   2 +-
 fs/ocfs2/aops.c                                    |  18 ++-
 fs/verity/enable.c                                 |  24 +--
 fs/verity/verify.c                                 |  12 +-
 fs/xfs/xfs_extent_busy.c                           |  14 --
 fs/xfs/xfs_trans_dquot.c                           |  13 +-
 fs/zonefs/super.c                                  |   2 +-
 include/linux/nvme-tcp.h                           |   5 +-
 include/linux/of_mdio.h                            |  22 ++-
 include/net/bluetooth/l2cap.h                      |   1 +
 include/trace/events/rcu.h                         |   2 +-
 kernel/bpf/core.c                                  |   2 +-
 kernel/compat.c                                    |   2 +-
 kernel/events/core.c                               |   4 +-
 kernel/kcsan/Makefile                              |   3 +-
 kernel/sched/core.c                                |   7 +-
 kernel/sched/fair.c                                |  54 ++++++-
 kernel/trace/kprobe_event_gen_test.c               |   4 +-
 net/bluetooth/l2cap_core.c                         | 129 +++++++++++-----
 net/can/bcm.c                                      |  16 +-
 net/hsr/hsr_framereg.c                             |   2 +-
 net/ipv4/ip_gre.c                                  |   4 +-
 net/ipv6/ip6_gre.c                                 |   4 +-
 net/mac80211/wme.c                                 |   6 +-
 net/tls/tls_main.c                                 |   9 +-
 net/xdp/xdp_umem.c                                 |  13 +-
 security/keys/request_key.c                        |   9 +-
 sound/pci/asihpi/hpi6205.c                         |   2 +-
 sound/pci/hda/patch_ca0132.c                       |   4 +-
 sound/pci/hda/patch_conexant.c                     |   6 +-
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/pci/ymfpci/ymfpci.c                          |  71 +++++----
 sound/pci/ymfpci/ymfpci_main.c                     |  74 ++++++---
 sound/usb/format.c                                 |   8 +-
 tools/bootconfig/test-bootconfig.sh                |  12 +-
 tools/lib/bpf/btf_dump.c                           | 154 +++++++++++++------
 tools/power/x86/turbostat/turbostat.8              |   2 +
 tools/power/x86/turbostat/turbostat.c              |   2 +-
 tools/testing/selftests/bpf/prog_tests/btf.c       |  28 ++++
 .../bpf/progs/btf_dump_test_case_bitfields.c       |   2 +-
 .../bpf/progs/btf_dump_test_case_packing.c         |  80 +++++++++-
 .../bpf/progs/btf_dump_test_case_padding.c         | 171 ++++++++++++++++++---
 virt/kvm/kvm_main.c                                | 149 +++++++++++++-----
 174 files changed, 1652 insertions(+), 803 deletions(-)


