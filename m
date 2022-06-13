Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F81C5498A2
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378866AbiFMNcM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377504AbiFMN12 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:27:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52FA6CF7A;
        Mon, 13 Jun 2022 04:24:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D592BB80D3A;
        Mon, 13 Jun 2022 11:24:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98AF0C34114;
        Mon, 13 Jun 2022 11:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119474;
        bh=joS9vfrgBCQb0mYWseOopRPYXJskTB9Hw7YT3szUrew=;
        h=From:To:Cc:Subject:Date:From;
        b=ZUj12A4FLJCjMZJ27KK3nsG9tVmkOhfTSUkHAhNSMmFIP6sj4MvvGcI4TIb9Wqac2
         sGX9Kk5EIKQMZvJPCA7bC446dXWgPGH62i7ka3xMSdT9ZpZrEO+DXi3lWolTmy/3R6
         fVGNn3VkpssBvTg9JTBVuNImESIvAzPOpci38VIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.18 000/339] 5.18.4-rc1 review
Date:   Mon, 13 Jun 2022 12:07:05 +0200
Message-Id: <20220613094926.497929857@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.4-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.18.4-rc1
X-KernelTest-Deadline: 2022-06-15T09:49+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.18.4 release.
There are 339 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 15 Jun 2022 09:47:08 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.4-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.18.4-rc1

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    zonefs: fix handling of explicit_open option on mount

Pascal Hambourg <pascal@plouf.fr.eu.org>
    md/raid0: Ignore RAID0 layout if the second zone has only one device

Jason A. Donenfeld <Jason@zx2c4.com>
    random: account for arch randomness in bits

Jason A. Donenfeld <Jason@zx2c4.com>
    random: mark bootloader randomness code as __init

Jason A. Donenfeld <Jason@zx2c4.com>
    random: avoid checking crng_ready() twice in random_init()

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/32: Fix overread/overwrite of thread_struct via ptrace

Jason Wang <jasowang@redhat.com>
    virtio-rng: make device ready before making request

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: update VCN codec support for Yellow Carp

Aurabindo Pillai <aurabindo.pillai@amd.com>
    drm/amd/display: remove stale config guards

Mohammad Zafar Ziya <Mohammadzafar.ziya@amd.com>
    drm/amdgpu/jpeg2: Add jpeg vmid update under IB submit

Brian Norris <briannorris@chromium.org>
    drm/atomic: Force bridge self-refresh-exit on CRTC switch

Brian Norris <briannorris@chromium.org>
    drm/bridge: analogix_dp: Support PSR-exit to disable transition

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdkfd:Fix fw version for 10.3.6

Michael Ellerman <mpe@ellerman.id.au>
    powerpc: Don't select HAVE_IRQ_EXIT_ON_IRQ_STACK

Matthew Wilcox (Oracle) <willy@infradead.org>
    mm/huge_memory: Fix xarray node memory leak

Peter Zijlstra <peterz@infradead.org>
    cpuidle,intel_idle: Fix CPUIDLE_FLAG_IRQ_ENABLE

Xie Yongji <xieyongji@bytedance.com>
    vduse: Fix NULL pointer dereference on sysfs access

Mathias Nyman <mathias.nyman@linux.intel.com>
    Input: bcm5974 - set missing URB_NO_TRANSFER_DMA_MAP urb flag

Olivier Matz <olivier.matz@6wind.com>
    ixgbe: fix unexpected VLAN Rx in promisc mode on VF

Olivier Matz <olivier.matz@6wind.com>
    ixgbe: fix bcast packets Rx on VF after promisc removal

Martin Faltesek <mfaltesek@google.com>
    nfc: st21nfca: fix incorrect sizing calculations in EVT_TRANSACTION

Martin Faltesek <mfaltesek@google.com>
    nfc: st21nfca: fix memory leaks in EVT_TRANSACTION handling

Martin Faltesek <mfaltesek@google.com>
    nfc: st21nfca: fix incorrect validating logic in EVT_TRANSACTION

Jchao Sun <sunjunchao2870@gmail.com>
    writeback: Fix inode->i_io_list not be protected by inode->i_lock error

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: fix misuse of the cached connection on tuple changes

Tan Tee Min <tee.min.tan@linux.intel.com>
    net: phy: dp83867: retrigger SGMII AN when link change

Adrian Hunter <adrian.hunter@intel.com>
    mmc: block: Fix CQE recovery reset success

Ben Chuang <benchuanggli@gmail.com>
    mmc: sdhci-pci-gli: Fix GL9763E runtime PM when the system resumes from suspend

Sergey Shtylyov <s.shtylyov@omp.ru>
    ata: libata-transport: fix {dma|pio|xfer}_mode sysfs files

Tyler Erickson <tyler.erickson@seagate.com>
    libata: fix translation of concurrent positioning ranges

Tyler Erickson <tyler.erickson@seagate.com>
    libata: fix reading concurrent positioning ranges log

David Safford <david.safford@gmail.com>
    KEYS: trusted: tpm2: Fix migratable logic

Matthew Wilcox (Oracle) <willy@infradead.org>
    filemap: Cache the value of vm_flags

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: SVM: fix tsc scaling cache logic

Shaoqin Huang <shaoqin.huang@intel.com>
    KVM: x86/mmu: Check every prev_roots in __kvm_mmu_free_obsolete_roots()

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Address NULL pointer dereference after starget_to_rport()

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Resolve some cleanup issues following SLI path refactoring

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Resolve some cleanup issues following abort path refactoring

Tyler Erickson <tyler.erickson@seagate.com>
    scsi: sd: Fix interpretation of VPD B9h length

Shyam Prasad N <sprasad@microsoft.com>
    cifs: populate empty hostnames for extra channels

Paulo Alcantara <pc@cjr.nz>
    cifs: fix reconnect on smb3 mount types

Shyam Prasad N <sprasad@microsoft.com>
    cifs: return errors during session setup during reconnects

Jeremy Soller <jeremy@system76.com>
    ALSA: hda/realtek: Add quirk for HP Dev One

Cameron Berkenpas <cam@neo-zeon.de>
    ALSA: hda/realtek: Fix for quirk to enable speaker output on the Lenovo Yoga DuetITL 2021

huangwenhui <huangwenhuia@uniontech.com>
    ALSA: hda/conexant - Fix loopback issue with CX20632

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Set up (implicit) sync for Saffire 6

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Skip generic sync EP parse for secondary EP

Bedant Patnaik <bedant.patnaik@gmail.com>
    platform/x86: hp-wmi: Use zero insize parameter only when supported

Jorge Lopez <jorge.lopez2@hp.com>
    platform/x86: hp-wmi: Resolve WMI query failures on some devices

Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
    scripts/gdb: change kernel config dumping method

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    platform/x86: barco-p50-gpio: Add check for platform_driver_register

Xie Yongji <xieyongji@bytedance.com>
    vringh: Fix loop descriptors check in the indirect cases

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Correct BDE type for XMIT_SEQ64_WQE in lpfc_ct_reject_event()

Kees Cook <keescook@chromium.org>
    nodemask: Fix return values to be unsigned

Yury Norov <yury.norov@gmail.com>
    drm/amd/pm: use bitmap_{from,to}_arr32 where appropriate

Steve French <stfrench@microsoft.com>
    cifs: version operations for smb20 unneeded when legacy support disabled

Christian Borntraeger <borntraeger@linux.ibm.com>
    s390/gmap: voluntarily schedule during key setting

Vincent Whitchurch <vincent.whitchurch@axis.com>
    cifs: fix potential deadlock in direct reclaim

Bjorn Helgaas <bhelgaas@google.com>
    Revert "PCI: brcmstb: Split brcm_pcie_setup() into two funcs"

Bjorn Helgaas <bhelgaas@google.com>
    Revert "PCI: brcmstb: Add mechanism to turn on subdev regulators"

Bjorn Helgaas <bhelgaas@google.com>
    Revert "PCI: brcmstb: Add control of subdevice voltage regulators"

Bjorn Helgaas <bhelgaas@google.com>
    Revert "PCI: brcmstb: Do not turn off WOL regulators on suspend"

Yu Kuai <yukuai3@huawei.com>
    nbd: fix io hung while disconnecting device

Yu Kuai <yukuai3@huawei.com>
    nbd: fix race between nbd_alloc_config() and module removal

Yu Kuai <yukuai3@huawei.com>
    nbd: call genl_unregister_family() first in nbd_cleanup()

Peter Zijlstra <peterz@infradead.org>
    jump_label,noinstr: Avoid instrumentation for JUMP_LABEL=n builds

Peter Zijlstra <peterz@infradead.org>
    x86/cpu: Elide KCSAN for cpu_has() and friends

Peter Zijlstra <peterz@infradead.org>
    objtool: Mark __ubsan_handle_builtin_unreachable() as noreturn

Masahiro Yamada <masahiroy@kernel.org>
    modpost: fix undefined behavior of is_arm_mapping_symbol()

Johannes Berg <johannes.berg@intel.com>
    um: line: Use separate IRQs per line

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: correct the metrics version for SMU 11.0.11/12/13

Lijo Lazar <lijo.lazar@amd.com>
    drm/amd/pm: Fix missing thermal throttler status

Gong Yuanjun <ruc_gongyuanjun@163.com>
    drm/amd/pm: fix a potential gpu_metrics_table memory leak

Gong Yuanjun <ruc_gongyuanjun@163.com>
    drm/radeon: fix a possible null pointer dereference

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Check zero planes for OTG disable W/A on clock change

David Galiffi <David.Galiffi@amd.com>
    drm/amd/display: Check if modulo is 0 before dividing.

Daniel Borkmann <daniel@iogearbox.net>
    net, neigh: Set lower cap for neigh_managed_work rearming

Xiubo Li <xiubli@redhat.com>
    ceph: fix possible deadlock when holding Fwb to get inline_data

Xiubo Li <xiubli@redhat.com>
    ceph: flush the mdlog for filesystem sync

Venky Shankar <vshankar@redhat.com>
    ceph: allow ceph.dir.rctime xattr to be updatable

Michal Kubecek <mkubecek@suse.cz>
    Revert "net: af_key: add check for pfkey_broadcast in function pfkey_process"

Oder Chiou <oder_chiou@realtek.com>
    ASoC: rt5640: Do not manipulate pin "Platform Clock" if the "Platform Clock" is not in the DAPM

Hannes Reinecke <hare@suse.de>
    scsi: myrb: Fix up null pointer access on myrb_cleanup()

Syed Saba kareem <ssabakar@amd.com>
    ASoC: SOF: amd: Fixed Build error

Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
    md: protect md_unregister_thread from reentrancy

Hyunchul Lee <hyc.lee@gmail.com>
    ksmbd: smbd: fix connection dropped issue

Liu Xinpeng <liuxp11@chinatelecom.cn>
    watchdog: wdat_wdt: Stop watchdog when rebooting the system

Hao Luo <haoluo@google.com>
    kernfs: Separate kernfs_pr_cont_buf and rename_lock.

John Ogness <john.ogness@linutronix.de>
    serial: msm_serial: disable interrupts in __msm_console_write()

Wang Cheng <wanngchenng@gmail.com>
    staging: rtl8712: fix uninit-value in r871xu_drv_init()

Wang Cheng <wanngchenng@gmail.com>
    staging: rtl8712: fix uninit-value in usb_read8() and friends

Andre Przywara <andre.przywara@arm.com>
    clocksource/drivers/sp804: Avoid error on multiple instances

bumwoo lee <bw365.lee@samsung.com>
    extcon: Modify extcon device to be created after driver data is set

Dan Carpenter <dan.carpenter@oracle.com>
    extcon: Fix extcon_get_extcon_dev() error handling

Shuah Khan <skhan@linuxfoundation.org>
    misc: rtsx: set NULL intfdata when probe fails

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    soundwire: qcom: adjust autoenumeration timeout

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Only End Transfer for ep0 data phase

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: dwc3: host: Stop setting the ACPI companion

Marek Szyprowski <m.szyprowski@samsung.com>
    usb: dwc2: gadget: don't reset gadget's driver->bus

Changbin Du <changbin.du@intel.com>
    sysrq: do not omit current cpu when showing backtrace of all active CPUs

Hangyu Hua <hbh25y@gmail.com>
    char: xillybus: fix a refcount leak in cleanup_dev()

Evan Green <evgreen@chromium.org>
    USB: hcd-pci: Fully suspend across freeze/thaw cycle

Duoming Zhou <duoming@zju.edu.cn>
    drivers: usb: host: Fix deadlock in oxu_bus_suspend()

Duoming Zhou <duoming@zju.edu.cn>
    drivers: tty: serial: Fix deadlock in sa1100_set_termios()

Zhen Ni <nizhen@uniontech.com>
    USB: host: isp116x: check return value after calling platform_get_resource()

Duoming Zhou <duoming@zju.edu.cn>
    drivers: staging: rtl8192e: Fix deadlock in rtllib_beacons_stop()

Duoming Zhou <duoming@zju.edu.cn>
    drivers: staging: rtl8192u: Fix deadlock in ieee80211_beacons_stop()

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Use different lane for second DisplayPort tunnel

Huang Guobin <huangguobin4@huawei.com>
    tty: Fix a possible resource leak in icom_probe

Zheyu Ma <zheyuma97@gmail.com>
    tty: synclink_gt: Fix null-pointer-dereference in slgt_clean()

Duoming Zhou <duoming@zju.edu.cn>
    drivers: staging: rtl8192eu: Fix deadlock in rtw_joinbss_event_prehandle

Duoming Zhou <duoming@zju.edu.cn>
    drivers: staging: rtl8192bs: Fix deadlock in rtw_joinbss_event_prehandle()

Duoming Zhou <duoming@zju.edu.cn>
    drivers: staging: rtl8723bs: Fix deadlock in rtw_surveydone_event_callback()

Kees Cook <keescook@chromium.org>
    lkdtm/usercopy: Expand size of "out of frame" object

Miquel Raynal <miquel.raynal@bootlin.com>
    iio: st_sensors: Add a local lock for protecting odr

Xiaoke Wang <xkernel.wang@foxmail.com>
    staging: rtl8712: fix a potential memory leak in r871xu_drv_init()

Xiaoke Wang <xkernel.wang@foxmail.com>
    iio: dummy: iio_simple_dummy: check the return value of kstrdup()

David Howells <dhowells@redhat.com>
    iov_iter: Fix iter_xarray_get_pages{,_alloc}()

Andrea Mayer <andrea.mayer@uniroma2.it>
    net: seg6: fix seg6_lookup_any_nexthop() to handle VRFs using flowi_l3mdev

Etienne van der Linde <etienne.vanderlinde@corigine.com>
    nfp: flower: restructure flow-key for gre+vlan combination

Linus Torvalds <torvalds@linux-foundation.org>
    drm: imx: fix compiler warning with gcc-12

Muchun Song <songmuchun@bytedance.com>
    tcp: use alloc_large_system_hash() to allocate table_perturb

Alvin Šipraga <alsi@bang-olufsen.dk>
    net: dsa: realtek: rtl8365mb: fix GMII caps for ports with internal PHY

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: use BMSR_ANEGCOMPLETE bit for filling an_complete

Miaoqian Lin <linmq006@gmail.com>
    net: altera: Fix refcount leak in altera_tse_mdio_create

Willem de Bruijn <willemb@google.com>
    ip_gre: test csum_start instead of transport header

Mark Bloch <mbloch@nvidia.com>
    net/mlx5: fs, fail conflicting actions

Feras Daoud <ferasda@nvidia.com>
    net/mlx5: Rearm the FW tracer after each tracer event

Saeed Mahameed <saeedm@nvidia.com>
    net/mlx5: Fix mlx5_get_next_dev() peer device matching

Mark Bloch <mbloch@nvidia.com>
    net/mlx5: Lag, filter non compatible devices

Paul Blakey <paulb@nvidia.com>
    net/mlx5e: CT: Fix cleanup of CT before cleanup of TC ct rules

Masahiro Yamada <masahiroy@kernel.org>
    net: ipv6: unexport __init-annotated seg6_hmac_init()

Masahiro Yamada <masahiroy@kernel.org>
    net: xfrm: unexport __init-annotated xfrm4_protocol_init()

Masahiro Yamada <masahiroy@kernel.org>
    net: mdio: unexport __init-annotated mdio_bus_init()

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Fix the calculation of xdr->end in xdr_get_next_encode_buffer()

Christian König <christian.koenig@amd.com>
    drm/amdgpu: fix limiting AV1 to the first instance on VCN3

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    xsk: Fix handling of invalid descriptors in XSK TX batching API

Gal Pressman <gal@nvidia.com>
    net/mlx4_en: Fix wrong return value on ioctl EEPROM query failure

Miaoqian Lin <linmq006@gmail.com>
    net: dsa: lantiq_gswip: Fix refcount leak in gswip_gphy_fw_list

Eric Dumazet <edumazet@google.com>
    bpf, arm64: Clear prog->jited_len along prog->jited

Jan Beulich <jbeulich@suse.com>
    x86: drop bogus "cc" clobber from __try_cmpxchg_user_asm()

Lina Wang <lina.wang@mediatek.com>
    selftests net: fix bpf build error

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Fix a data-race in unix_dgram_peer_wake_me().

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    stmmac: intel: Fix an error handling path in intel_eth_pci_probe()

Masahiro Yamada <masahiroy@kernel.org>
    xen: unexport __init-annotated xen_xlate_map_ballooned_pages()

Miaoqian Lin <linmq006@gmail.com>
    net: ethernet: bgmac: Fix refcount leak in bcma_mdio_mii_register

Taehee Yoo <ap420073@gmail.com>
    amt: fix wrong type string definition

Taehee Yoo <ap420073@gmail.com>
    amt: fix possible null-ptr-deref in amt_rcv()

Taehee Yoo <ap420073@gmail.com>
    amt: fix wrong usage of pskb_may_pull()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: bail out early if hardware offload is not supported

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: memleak flow rule from commit path

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: release new hooks on unsupported flowtable flags

Miaoqian Lin <linmq006@gmail.com>
    ata: pata_octeon_cf: Fix refcount leak in octeon_cf_probe

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: always initialize flowtable hook list in transaction

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Trap RDMA segment overflows

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix potential use-after-free in nfsd_file_put()

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/kasan: Force thread size increase with KASAN

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: delete flowtable hooks via transaction list

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: use kfree_rcu(ptr, rcu) to release hooks in clean_net path

Florian Westphal <fw@strlen.de>
    netfilter: nat: really support inet nat without l3 address

Vaibhav Jain <vaibhav@linux.ibm.com>
    powerpc/papr_scm: don't requests stats with '0' sized stats buffer

Steven Price <steven.price@arm.com>
    drm/panfrost: Job should reference MMU not file_priv

Marek Vasut <marex@denx.de>
    drm/bridge: ti-sn65dsi83: Handle dsi_lanes == 0 as invalid

Kinglong Mee <kinglongmee@gmail.com>
    xprtrdma: treat all calls not a bcall when bc_serv is NULL

Chao Yu <chao@kernel.org>
    f2fs: fix to tag gcing flag on page during file defragment

Daniel Bristot de Oliveira <bristot@kernel.org>
    rtla/Makefile: Properly handle dependencies

Greg Ungerer <gerg@linux-m68k.org>
    m68knommu: fix undefined reference to `mach_get_rtc_pll'

Liao Chang <liaochang1@huawei.com>
    RISC-V: use memcpy for kexec_file mode

Yang Yingliang <yangyingliang@huawei.com>
    video: fbdev: pxa3xx-gcu: release the resources correctly in pxa3xx_gcu_probe/remove()

Saurabh Sengar <ssengar@linux.microsoft.com>
    video: fbdev: hyperv_fb: Allow resolutions with size > 64 MB for Gen1

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Don't hold the layoutget locks across multiple RPC calls

Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
    dmaengine: zynqmp_dma: In struct zynqmp_dma_chan fix desc_size data type

Greg Ungerer <gerg@linux-m68k.org>
    m68knommu: fix undefined reference to `_init_sp'

Greg Ungerer <gerg@linux-m68k.org>
    m68knommu: set ZERO_PAGE() to the allocated zeroed page

Lucas Tanure <tanureal@opensource.cirrus.com>
    i2c: cadence: Increase timeout per message if necessary

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: avoid infinite loop to flush node pages

Dongliang Mu <mudongliangabcd@gmail.com>
    f2fs: remove WARN_ON in f2fs_is_valid_blkaddr

Yang Yingliang <yangyingliang@huawei.com>
    iommu/arm-smmu-v3: check return value after calling platform_get_resource()

Yang Yingliang <yangyingliang@huawei.com>
    iommu/arm-smmu: fix possible null-ptr-deref in arm_smmu_device_probe()

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    i2c: mediatek: Optimize master_xfer() and avoid circular locking

Mark-PK Tsai <mark-pk.tsai@mediatek.com>
    tracing: Avoid adding tracer option before update_tracer_options

Jun Miao <jun.miao@intel.com>
    tracing: Fix sleeping function called from invalid context on RT kernel

Jeff Xie <xiehuan09@gmail.com>
    tracing: Make tp_printk work on syscall tracepoints

Masami Hiramatsu <mhiramat@kernel.org>
    bootconfig: Make the bootconfig.o as a normal object file

Gong Yuanjun <ruc_gongyuanjun@163.com>
    mips: cpc: Fix refcount leak in mips_cpc_default_phys_base

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: set DMA_INTERRUPT cap bit

Linus Torvalds <torvalds@linux-foundation.org>
    bluetooth: don't use bitmaps for random flag accesses

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sync: Fix attempting to suspend with unfiltered passive scan

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Add conditions for setting HCI_CONN_FLAG_REMOTE_WAKEUP

Leo Yan <leo.yan@linaro.org>
    perf c2c: Fix sorting in percent_rmt_hitm_cmp()

Zhengjun Xing <zhengjun.xing@linux.intel.com>
    perf record: Support sample-read topdown metric group for hybrid platforms

Kan Liang <kan.liang@linux.intel.com>
    perf parse-events: Move slots event for the hybrid platform too

Kan Liang <kan.liang@linux.intel.com>
    perf evsel: Fixes topdown events in a weak group for the hybrid platform

Saravana Kannan <saravanak@google.com>
    driver core: Fix wait_for_device_probe() & deferred_probe_timeout interaction

Hoang Le <hoang.h.le@dektech.com.au>
    tipc: check attribute length for bearer name

Fei Qin <fei.qin@corigine.com>
    nfp: remove padding in nfp_nfdk_tx_desc

Duoming Zhou <duoming@zju.edu.cn>
    ax25: Fix ax25 session cleanup problems

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    scsi: sd: Fix potential NULL pointer dereference

Kuogee Hsieh <quic_khsieh@quicinc.com>
    drm/msm/dp: Always clear mask bits to disable interrupts at dp_ctrl_reset_irq_ctrl()

David Howells <dhowells@redhat.com>
    afs: Fix infinite loop found by xfstest generic/676

Haibo Chen <haibo.chen@nxp.com>
    gpio: pca953x: use the correct register address to do regcache sync

Dan Carpenter <dan.carpenter@oracle.com>
    net/sched: act_api: fix error code in tcf_ct_flow_table_fill_tuple_ipv6()

Aya Levin <ayal@nvidia.com>
    net: ping6: Fix ping -6 with interface name

Fabien Parent <fparent@baylibre.com>
    regulator: mt6315-regulator: fix invalid allowed mode

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/mcck: isolate SIE instruction when setting CIF_MCCK_GUEST flag

Dan Carpenter <dan.carpenter@oracle.com>
    octeontx2-af: fix error code in is_valid_offset()

Hangbin Liu <liuhangbin@gmail.com>
    bonding: guard ns_targets by CONFIG_IPV6

Jason Wang <jasowang@redhat.com>
    vdpa: ifcvf: set pci driver data in probe

Eric Dumazet <edumazet@google.com>
    tcp: tcp_rtx_synack() can be called from process context

Guoju Fang <gjfang@linux.alibaba.com>
    net: sched: add barrier to fix packet stuck problem for lockless qdisc

Maxim Mikityanskiy <maximmi@nvidia.com>
    net/mlx5e: Update netdev features after changing XDP state

Changcheng Liu <jerrliu@nvidia.com>
    net/mlx5: correct ECE offset in query qp output

Maxim Mikityanskiy <maximmi@nvidia.com>
    net/mlx5e: Disable softirq in mlx5e_activate_rq to avoid race condition

Paul Blakey <paulb@nvidia.com>
    net/mlx5: CT: Fix header-rewrite re-use for tupels

Maor Dickman <maord@nvidia.com>
    net/mlx5e: TC NIC mode, fix tc chains miss table

Leon Romanovsky <leon@kernel.org>
    net/mlx5: Don't use already freed action pointer

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    virtio: pci: Fix an error handling path in vp_modern_probe()

Eli Cohen <elic@nvidia.com>
    vdpa: Fix error logic in vdpa_nl_cmd_dev_get_doit

Weizhao Ouyang <o451686892@gmail.com>
    erofs: fix 'backmost' member of z_erofs_decompress_frontend

Hangbin Liu <liuhangbin@gmail.com>
    bonding: show NS IPv6 targets in proc master info

Viorel Suman <viorel.suman@nxp.com>
    net: phy: at803x: disable WOL at probe

Haisu Wang <haisuwang@tencent.com>
    blk-mq: do not update io_ticks with passthrough requests

Peter Zijlstra <peterz@infradead.org>
    sched/autogroup: Fix sysctl move

Jens Axboe <axboe@kernel.dk>
    block: make bioset_exit() fully resilient against being called twice

Íñigo Huguet <ihuguet@redhat.com>
    sfc: fix wrong tx channel offset with efx_separate_tx_channels

Martin Habets <habetsm.xilinx@gmail.com>
    sfc: fix considering that all channels have TX queues

Hangbin Liu <liuhangbin@gmail.com>
    bonding: NS target should accept link local address

Christoph Hellwig <hch@lst.de>
    block: use bio_queue_enter instead of blk_queue_enter in bio_poll

Yu Xiao <yu.xiao@corigine.com>
    nfp: only report pause frame configuration for physical device

Eric Dumazet <edumazet@google.com>
    tcp: add accessors to read/set tp->snd_cwnd

Guangguan Wang <guangguan.wang@linux.alibaba.com>
    net/smc: fixes for converting from "struct smc_cdc_tx_pend **" to "struct smc_wr_tx_pend_priv *"

Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
    riscv: read-only pages should not be writable

Zhang Wensheng <zhangwensheng5@huawei.com>
    nbd: fix possible overflow on 'first_minor' in nbd_dev_add()

Yu Kuai <yukuai3@huawei.com>
    nbd: don't clear 'NBD_CMD_INFLIGHT' flag if request is not completed

Christoph Hellwig <hch@lst.de>
    block: take destination bvec offsets into account in bio_copy_data_iter

Menglong Dong <imagedong@tencent.com>
    bpf: Fix probe read error in ___bpf_prog_run()

Song Liu <song@kernel.org>
    selftests/bpf: fix stacktrace_build_id with missing kprobe/urandom_read

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: ubi_create_volume: Fix use-after-free when volume creation failed

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: fastmap: Fix high cpu usage of ubi_bgt by making sure wl_pool not empty

Baokun Li <libaokun1@huawei.com>
    jffs2: fix memory leak in jffs2_do_fill_super

Genjian Zhang <zhanggenjian123@gmail.com>
    ep93xx: clock: Do not return the address of the freed memory

Christoph Hellwig <hch@lst.de>
    block, loop: support partitions without scanning

Alexander Lobakin <alexandr.lobakin@intel.com>
    modpost: fix removing numeric suffixes

Miaoqian Lin <linmq006@gmail.com>
    net: dsa: mv88e6xxx: Fix refcount leak in mv88e6xxx_mdios_register

Miaoqian Lin <linmq006@gmail.com>
    net: ethernet: ti: am65-cpsw-nuss: Fix some refcount leaks

Dan Carpenter <dan.carpenter@oracle.com>
    net: ethernet: mtk_eth_soc: out of bounds read in mtk_hwlro_get_fdir_entry()

Vincent Ray <vray@kalrayinc.com>
    net: sched: fixed barrier to prevent skbuff sticking in qdisc backlog

Michael Walle <michael@walle.cc>
    net: lan966x: check devm_of_phy_get() for -EDEFER_PROBE

Dan Carpenter <dan.carpenter@oracle.com>
    drm/amdgpu: Off by one in dm_dmub_outbox1_low_irq()

Eddie James <eajames@linux.ibm.com>
    spi: fsi: Fix spurious timeout

liuyacan <liuyacan@corp.netease.com>
    net/smc: set ini->smcrv2.ib_dev_v2 to NULL if SMC-Rv2 is unavailable

Siddharth Vadapalli <s-vadapalli@ti.com>
    net: ethernet: ti: am65-cpsw: Fix fwnode passed to phylink_create()

Taehee Yoo <ap420073@gmail.com>
    amt: fix possible memory leak in amt_rcv()

Taehee Yoo <ap420073@gmail.com>
    amt: fix return value of amt_update_handler()

Jann Horn <jannh@google.com>
    s390/crypto: fix scatterwalk_unmap() callers in AES-GCM

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    clocksource/drivers/oxnas-rps: Fix irq_of_parse_and_map() return value

Christoph Hellwig <hch@lst.de>
    scsi: sd: Don't call blk_cleanup_disk() in sd_probe()

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_sai: Fix FSL_SAI_xDR/xFR definition

Ming Lei <ming.lei@redhat.com>
    blk-mq: don't touch ->tagset in blk_mq_get_sq_hctx

Miaoqian Lin <linmq006@gmail.com>
    watchdog: ts4800_wdt: Fix refcount leak in ts4800_wdt_probe

Miaoqian Lin <linmq006@gmail.com>
    watchdog: rti-wdt: Fix pm_runtime_get_sync() error checking

Zhang Wensheng <zhangwensheng5@huawei.com>
    driver core: fix deadlock in __device_attach

Schspa Shi <schspa@gmail.com>
    driver: base: fix UAF when driver_attach failed

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Fix warnings for unbind for serial

Miaoqian Lin <linmq006@gmail.com>
    firmware: dmi-sysfs: Fix memory leak in dmi_sysfs_register_handle

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: stm32-usart: Correct CSIZE, bits, and parity

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: st-asc: Sanitize CSIZE and correct PARENB for CS7

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: sifive: Sanitize CSIZE and c_iflag

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: sh-sci: Don't allow CS5-6

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: txx9: Don't allow CS5-6

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: rda-uart: Don't allow CS5-6

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: digicolor-usart: Don't allow CS5-6

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: uartlite: Fix BRKINT clearing

YueHaibing <yuehaibing@huawei.com>
    serial: cpm_uart: Fix build error without CONFIG_SERIAL_CPM_CONSOLE

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250_fintek: Check SER_RS485_RTS_* only with RS485

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    Revert "serial: 8250_mtk: Make sure to select the right FEATURE_SEL"

John Ogness <john.ogness@linutronix.de>
    serial: meson: acquire port->lock in startup()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    staging: r8188eu: add check for kzalloc

Miaoqian Lin <linmq006@gmail.com>
    rtc: ftrtc010: Fix error handling in ftrtc010_rtc_probe

Yang Yingliang <yangyingliang@huawei.com>
    rtc: mt6397: check return value after calling platform_get_resource()

Howard Chiu <howard_chiu@aspeedtech.com>
    ARM: dts: aspeed: ast2600-evb: Enable RX delay for MAC0/MAC1

Samuel Holland <samuel@sholland.org>
    clocksource/drivers/riscv: Events are stopped during CPU suspend

Miaoqian Lin <linmq006@gmail.com>
    soc: rockchip: Fix refcount leak in rockchip_grf_init

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    dt-bindings: remoteproc: mediatek: Make l1tcm reg exclusive to mt819x

Li Jun <jun.li@nxp.com>
    extcon: ptn5150: Add queue work sync before driver release

Xin Xiong <xiongx18@fudan.edu.cn>
    ksmbd: fix reference count leak in smb_check_perm_dacl()

Guilherme G. Piccoli <gpiccoli@igalia.com>
    coresight: cpu-debug: Replace mutex with mutex_trylock on panic notifier

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    soundwire: qcom: return error when pm_runtime_get_sync fails

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    soundwire: intel: prevent pm_runtime resume prior to system suspend

Biju Das <biju.das.jz@bp.renesas.com>
    watchdog: rzg2l_wdt: Fix reset control imbalance

Biju Das <biju.das.jz@bp.renesas.com>
    watchdog: rzg2l_wdt: Fix 'BUG: Invalid wait context'

Biju Das <biju.das.jz@bp.renesas.com>
    watchdog: rzg2l_wdt: Fix Runtime PM usage

Biju Das <biju.das.jz@bp.renesas.com>
    watchdog: rzg2l_wdt: Fix 32bit overflow issue

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    export: fix string handling of namespace in EXPORT_SYMBOL_NS

Maciej W. Rozycki <macro@orcam.me.uk>
    serial: sifive: Report actual baud base rather than fixed 115200

Linus Walleij <linus.walleij@linaro.org>
    power: supply: ab8500_fg: Allocate wq in probe

Hans de Goede <hdegoede@redhat.com>
    power: supply: axp288_fuel_gauge: Drop BIOS version check from "T3 MRD" DMI quirk

Hans de Goede <hdegoede@redhat.com>
    power: supply: axp288_fuel_gauge: Fix battery reporting on the One Mix 1

Linus Walleij <linus.walleij@linaro.org>
    power: supply: core: Initialize struct to zero

Johan Hovold <johan+linaro@kernel.org>
    phy: qcom-qmp: fix pipe-clock imbalance on power-on failure

Guilherme G. Piccoli <gpiccoli@igalia.com>
    misc/pvpanic: Convert regular spinlock into trylock on panic path

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    rpmsg: qcom_smd: Fix returning 0 if irq_of_parse_and_map() fails

Cixi Geng <cixi.geng1@unisoc.com>
    iio: adc: sc27xx: Fine tune the scale calibration values

Cixi Geng <cixi.geng1@unisoc.com>
    iio: adc: sc27xx: fix read big scale voltage not right

Miaoqian Lin <linmq006@gmail.com>
    iio: proximity: vl53l0x: Fix return value check of wait_for_completion_timeout

Miaoqian Lin <linmq006@gmail.com>
    iio: adc: stmpe-adc: Fix wait_for_completion_timeout return value check

Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
    rpmsg: virtio: Fix the unregistration of the device rpmsg_ctrl

Hangyu Hua <hbh25y@gmail.com>
    rpmsg: virtio: Fix possible double free in rpmsg_virtio_add_ctrl_dev()

Hangyu Hua <hbh25y@gmail.com>
    rpmsg: virtio: Fix possible double free in rpmsg_probe()

Bjorn Andersson <bjorn.andersson@linaro.org>
    usb: typec: mux: Check dev_set_name() return value

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    firmware: stratix10-svc: fix a missing check on list iterator

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    misc: fastrpc: fix an incorrect NULL check on list iterator

SeongJae Park <sj@kernel.org>
    scripts/get_abi: Fix wrong script file name in the help message

Zheng Yongjun <zhengyongjun3@huawei.com>
    usb: dwc3: pci: Fix pm_runtime_get_sync() error checking

Wesley Cheng <quic_wcheng@quicinc.com>
    usb: dwc3: gadget: Replace list_for_each_entry_safe() if using giveback

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    rpmsg: qcom_smd: Fix irq_of_parse_and_map() return value

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: raspberrypi-poe: Fix endianness in firmware struct

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: lp3943: Fix duty calculation in case period was clamped

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    staging: fieldbus: Fix the error handling path in anybuss_host_common_probe()

Miaoqian Lin <linmq006@gmail.com>
    usb: musb: Fix missing of_node_put() in omap2430_probe

Lin Ma <linma@zju.edu.cn>
    USB: storage: karma: fix rio_karma_init return

Niels Dossche <dossche.niels@gmail.com>
    usb: usbip: add missing device lock on tweak configuration cmd

Hangyu Hua <hbh25y@gmail.com>
    usb: usbip: fix a refcount leak in stub_probe()

Michael Straube <straube.linux@gmail.com>
    staging: r8188eu: fix struct rt_firmware_hdr

Samuel Holland <samuel@sholland.org>
    phy: rockchip-inno-usb2: Fix muxed interrupt support

Peng Fan <peng.fan@nxp.com>
    remoteproc: imx_rproc: Ignore create mem entry for resource table

Sherry Sun <sherry.sun@nxp.com>
    tty: serial: fsl_lpuart: fix potential bug when using both of_alias_get_id and ida_simple_get

Miaoqian Lin <linmq006@gmail.com>
    serial: 8250_aspeed_vuart: Fix potential NULL dereference in aspeed_vuart_probe

Daniel Gibson <daniel@gibson.sh>
    tty: n_tty: Restore EOF push handling behavior

Miaoqian Lin <linmq006@gmail.com>
    tty: serial: owl: Fix missing clk_disable_unprepare() in owl_uart_probe

Wang Weiyang <wangweiyang2@huawei.com>
    tty: goldfish: Use tty_port_destroy() to destroy port

Christophe Leroy <christophe.leroy@csgroup.eu>
    lkdtm/bugs: Don't expect thread termination without CONFIG_UBSAN_TRAP

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    lkdtm/bugs: Check for the NULL pointer after calling kmalloc

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    remoteproc: mtk_scp: Fix a potential double free

Tinghan Shen <tinghan.shen@mediatek.com>
    remoteproc: mediatek: Fix side effect of mt8195 sram power on

Dan Carpenter <dan.carpenter@oracle.com>
    soundwire: qcom: fix an error message in swrm_wait_for_frame_gen_enabled()

Alexandru Tachici <alexandru.tachici@analog.com>
    iio: adc: ad7124: Remove shift from scan_type

Jakob Koschel <jakobkoschel@gmail.com>
    staging: greybus: codecs: fix type confusion of list iterator variable

Randy Dunlap <rdunlap@infradead.org>
    pcmcia: db1xxx_ss: restrict to MIPS_DB1XXX boards


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-ata                |  11 +-
 .../bindings/regulator/mt6315-regulator.yaml       |   4 +-
 .../devicetree/bindings/remoteproc/mtk,scp.yaml    |  44 ++--
 Documentation/tools/rtla/Makefile                  |  14 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/aspeed-ast2600-evb.dts           |   4 +-
 arch/arm/mach-ep93xx/clock.c                       |  10 +-
 arch/arm64/net/bpf_jit_comp.c                      |   1 +
 arch/m68k/Kconfig.machine                          |   1 +
 arch/m68k/include/asm/pgtable_no.h                 |   3 +-
 arch/m68k/kernel/setup_mm.c                        |   7 -
 arch/m68k/kernel/setup_no.c                        |   1 -
 arch/m68k/kernel/time.c                            |   9 +
 arch/mips/kernel/mips-cpc.c                        |   1 +
 arch/powerpc/Kconfig                               |   2 -
 arch/powerpc/include/asm/thread_info.h             |  10 +-
 arch/powerpc/kernel/ptrace/ptrace-fpu.c            |  20 +-
 arch/powerpc/kernel/ptrace/ptrace.c                |   3 +
 arch/powerpc/platforms/pseries/papr_scm.c          |   3 +
 arch/riscv/kernel/efi.c                            |   2 +-
 arch/riscv/kernel/machine_kexec.c                  |   4 +-
 arch/s390/crypto/aes_s390.c                        |   4 +-
 arch/s390/kernel/entry.S                           |   6 +-
 arch/s390/mm/gmap.c                                |  14 ++
 arch/um/drivers/chan_kern.c                        |  10 +-
 arch/um/drivers/line.c                             |  22 +-
 arch/um/drivers/line.h                             |   4 +-
 arch/um/drivers/ssl.c                              |   2 -
 arch/um/drivers/stdio_console.c                    |   2 -
 arch/um/include/asm/irq.h                          |  22 +-
 arch/x86/include/asm/cpufeature.h                  |   2 +-
 arch/x86/include/asm/uaccess.h                     |   2 +-
 arch/x86/kvm/mmu/mmu.c                             |   2 +-
 arch/x86/kvm/svm/nested.c                          |   4 +-
 arch/x86/kvm/svm/svm.c                             |  32 ++-
 arch/x86/kvm/svm/svm.h                             |   2 +-
 block/bio.c                                        |   9 +-
 block/blk-core.c                                   |   2 +-
 block/blk-mq.c                                     |  10 +-
 block/genhd.c                                      |   2 +
 drivers/ata/libata-core.c                          |  21 +-
 drivers/ata/libata-scsi.c                          |   2 +-
 drivers/ata/libata-transport.c                     |   2 +-
 drivers/ata/pata_octeon_cf.c                       |   3 +
 drivers/base/bus.c                                 |   4 +-
 drivers/base/dd.c                                  |  10 +-
 drivers/block/loop.c                               |   8 +-
 drivers/block/nbd.c                                |  78 ++++---
 drivers/bus/ti-sysc.c                              |   4 +-
 drivers/char/hw_random/virtio-rng.c                |   2 +
 drivers/char/random.c                              |  15 +-
 drivers/char/xillybus/xillyusb.c                   |   1 +
 drivers/clocksource/timer-oxnas-rps.c              |   2 +-
 drivers/clocksource/timer-riscv.c                  |   2 +-
 drivers/clocksource/timer-sp804.c                  |  10 +-
 drivers/dma/idxd/dma.c                             |   1 +
 drivers/dma/xilinx/zynqmp_dma.c                    |   5 +-
 drivers/extcon/extcon-axp288.c                     |   4 +-
 drivers/extcon/extcon-ptn5150.c                    |  11 +
 drivers/extcon/extcon.c                            |  33 +--
 drivers/firmware/dmi-sysfs.c                       |   2 +-
 drivers/firmware/stratix10-svc.c                   |  12 +-
 drivers/gpio/gpio-pca953x.c                        |  19 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c             |   6 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.h             |   1 +
 drivers/gpu/drm/amd/amdgpu/nv.c                    |   1 +
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c              |  17 +-
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |   4 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   2 +-
 .../amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c |   5 +-
 .../amd/display/dc/clk_mgr/dcn316/dcn316_clk_mgr.c |   3 +-
 .../gpu/drm/amd/display/dc/dce/dce_clock_source.c  |   9 +-
 drivers/gpu/drm/amd/display/dc/dml/dml_wrapper.c   |   2 -
 .../drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c    |  57 +++--
 drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c     |   2 +-
 drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c |   1 +
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c     |   2 +-
 .../gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c   |   3 +
 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c |  42 +++-
 drivers/gpu/drm/bridge/ti-sn65dsi83.c              |   2 +-
 drivers/gpu/drm/drm_atomic_helper.c                |  16 +-
 drivers/gpu/drm/imx/ipuv3-crtc.c                   |   2 +-
 drivers/gpu/drm/msm/dp/dp_ctrl.c                   |   9 +-
 drivers/gpu/drm/panfrost/panfrost_drv.c            |   5 +-
 drivers/gpu/drm/panfrost/panfrost_job.c            |   6 +-
 drivers/gpu/drm/panfrost/panfrost_job.h            |   2 +-
 drivers/gpu/drm/radeon/radeon_connectors.c         |   4 +
 drivers/hwtracing/coresight/coresight-cpu-debug.c  |   7 +-
 drivers/i2c/busses/i2c-cadence.c                   |  12 +-
 drivers/i2c/busses/i2c-mt65xx.c                    |  11 +-
 drivers/idle/intel_idle.c                          |  32 ++-
 drivers/iio/adc/ad7124.c                           |   1 -
 drivers/iio/adc/sc27xx_adc.c                       |  20 +-
 drivers/iio/adc/stmpe-adc.c                        |   8 +-
 drivers/iio/common/st_sensors/st_sensors_core.c    |  24 +-
 drivers/iio/dummy/iio_simple_dummy.c               |  20 +-
 drivers/iio/proximity/vl53l0x-i2c.c                |   7 +-
 drivers/input/mouse/bcm5974.c                      |   7 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |   2 +
 drivers/iommu/arm/arm-smmu/arm-smmu.c              |   5 +-
 drivers/md/md.c                                    |  15 +-
 drivers/md/raid0.c                                 |  31 +--
 drivers/misc/cardreader/rtsx_usb.c                 |   1 +
 drivers/misc/fastrpc.c                             |   9 +-
 drivers/misc/lkdtm/bugs.c                          |  10 +-
 drivers/misc/lkdtm/lkdtm.h                         |   8 +-
 drivers/misc/lkdtm/usercopy.c                      |  17 +-
 drivers/misc/pvpanic/pvpanic.c                     |  10 +-
 drivers/mmc/core/block.c                           |   3 +-
 drivers/mmc/host/sdhci-pci-gli.c                   |   3 +
 drivers/mtd/ubi/fastmap-wl.c                       |  69 ++++--
 drivers/mtd/ubi/fastmap.c                          |  11 -
 drivers/mtd/ubi/ubi.h                              |   4 +-
 drivers/mtd/ubi/vmt.c                              |   1 -
 drivers/mtd/ubi/wl.c                               |  19 +-
 drivers/net/amt.c                                  |  59 +++--
 drivers/net/bonding/bond_main.c                    |   2 +
 drivers/net/bonding/bond_netlink.c                 |   5 -
 drivers/net/bonding/bond_options.c                 |  10 +-
 drivers/net/bonding/bond_procfs.c                  |  15 ++
 drivers/net/dsa/lantiq_gswip.c                     |   4 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |   1 +
 drivers/net/dsa/mv88e6xxx/serdes.c                 |  27 +--
 drivers/net/dsa/realtek/rtl8365mb.c                |  38 +--
 drivers/net/ethernet/altera/altera_tse_main.c      |   6 +-
 drivers/net/ethernet/broadcom/bgmac-bcma-mdio.c    |   1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c     |   8 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_cpt.c    |   2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |   3 +
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/dev.c      |  72 ++++--
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   4 +
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |   1 +
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  19 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/trap.c  |   1 +
 .../net/ethernet/mellanox/mlx5/core/en/xsk/pool.c  |   1 +
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  29 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  31 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  38 ++-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  37 ++-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |  12 +-
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |   1 +
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |   9 +-
 .../net/ethernet/microchip/lan966x/lan966x_main.c  |   9 +-
 .../net/ethernet/netronome/nfp/flower/conntrack.c  |  32 +--
 drivers/net/ethernet/netronome/nfp/flower/match.c  |  16 +-
 drivers/net/ethernet/netronome/nfp/nfdk/dp.c       |  12 +-
 drivers/net/ethernet/netronome/nfp/nfdk/nfdk.h     |   3 +-
 drivers/net/ethernet/netronome/nfp/nfp_net.h       |  11 +-
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |   4 +-
 drivers/net/ethernet/sfc/efx_channels.c            |   6 +-
 drivers/net/ethernet/sfc/net_driver.h              |   2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c  |   4 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |   8 +-
 drivers/net/phy/at803x.c                           |  33 ++-
 drivers/net/phy/dp83867.c                          |  29 +++
 drivers/net/phy/mdio_bus.c                         |   1 -
 drivers/nfc/st21nfca/se.c                          |  53 +++--
 drivers/pci/controller/pcie-brcmstb.c              | 257 +++------------------
 drivers/pcmcia/Kconfig                             |   2 +-
 drivers/phy/qualcomm/phy-qcom-qmp.c                |   2 +-
 drivers/phy/rockchip/phy-rockchip-inno-usb2.c      |  10 +-
 drivers/platform/x86/barco-p50-gpio.c              |   5 +-
 drivers/platform/x86/hp-wmi.c                      |  29 ++-
 drivers/power/supply/ab8500_fg.c                   |  19 +-
 drivers/power/supply/axp288_charger.c              |  17 +-
 drivers/power/supply/axp288_fuel_gauge.c           |  41 +++-
 drivers/power/supply/charger-manager.c             |   7 +-
 drivers/power/supply/max8997_charger.c             |   8 +-
 drivers/power/supply/power_supply_core.c           |   2 +-
 drivers/pwm/pwm-lp3943.c                           |   1 +
 drivers/pwm/pwm-raspberrypi-poe.c                  |   2 +-
 drivers/remoteproc/imx_rproc.c                     |   3 +
 drivers/remoteproc/mtk_common.h                    |   2 +
 drivers/remoteproc/mtk_scp.c                       |  70 ++++--
 drivers/rpmsg/qcom_smd.c                           |   4 +-
 drivers/rpmsg/virtio_rpmsg_bus.c                   |   9 +-
 drivers/rtc/rtc-ftrtc010.c                         |  34 ++-
 drivers/rtc/rtc-mt6397.c                           |   2 +
 drivers/scsi/lpfc/lpfc_crtn.h                      |   4 +-
 drivers/scsi/lpfc/lpfc_ct.c                        |   2 +-
 drivers/scsi/lpfc/lpfc_init.c                      |   2 +-
 drivers/scsi/lpfc/lpfc_nvme.c                      |   6 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |   6 +
 drivers/scsi/lpfc/lpfc_sli.c                       |  25 +-
 drivers/scsi/myrb.c                                |  11 +-
 drivers/scsi/sd.c                                  |   5 +-
 drivers/soc/rockchip/grf.c                         |   2 +
 drivers/soundwire/intel.c                          |   3 +
 drivers/soundwire/qcom.c                           |   6 +-
 drivers/spi/spi-fsi.c                              |  12 +-
 drivers/staging/fieldbus/anybuss/host.c            |   2 +-
 drivers/staging/greybus/audio_codec.c              |   4 +-
 drivers/staging/r8188eu/core/rtw_fw.c              |   2 +-
 drivers/staging/r8188eu/core/rtw_mlme.c            |   6 +-
 drivers/staging/r8188eu/core/rtw_xmit.c            |  13 +-
 drivers/staging/r8188eu/include/rtw_xmit.h         |   2 +-
 drivers/staging/rtl8192e/rtllib_softmac.c          |   2 +-
 .../staging/rtl8192u/ieee80211/ieee80211_softmac.c |   2 +-
 drivers/staging/rtl8712/os_intfs.c                 |   1 -
 drivers/staging/rtl8712/usb_intf.c                 |  12 +-
 drivers/staging/rtl8712/usb_ops.c                  |  27 ++-
 drivers/staging/rtl8723bs/core/rtw_mlme.c          |  12 +-
 drivers/thunderbolt/tb.c                           |  19 +-
 drivers/thunderbolt/test.c                         |  16 +-
 drivers/thunderbolt/tunnel.c                       |  11 +-
 drivers/thunderbolt/tunnel.h                       |   4 +-
 drivers/tty/goldfish.c                             |   2 +
 drivers/tty/n_tty.c                                |  38 ++-
 drivers/tty/serial/8250/8250_aspeed_vuart.c        |   2 +
 drivers/tty/serial/8250/8250_fintek.c              |   8 +-
 drivers/tty/serial/8250/8250_mtk.c                 |   7 -
 drivers/tty/serial/cpm_uart/cpm_uart_core.c        |   2 +-
 drivers/tty/serial/digicolor-usart.c               |   2 +
 drivers/tty/serial/fsl_lpuart.c                    |  24 +-
 drivers/tty/serial/icom.c                          |   2 +-
 drivers/tty/serial/meson_uart.c                    |  13 ++
 drivers/tty/serial/msm_serial.c                    |   5 +
 drivers/tty/serial/owl-uart.c                      |   1 +
 drivers/tty/serial/rda-uart.c                      |   2 +
 drivers/tty/serial/sa1100.c                        |   4 +-
 drivers/tty/serial/serial_txx9.c                   |   2 +
 drivers/tty/serial/sh-sci.c                        |   6 +-
 drivers/tty/serial/sifive.c                        |   8 +-
 drivers/tty/serial/st-asc.c                        |   4 +
 drivers/tty/serial/stm32-usart.c                   |  15 +-
 drivers/tty/serial/uartlite.c                      |   3 +-
 drivers/tty/synclink_gt.c                          |   2 +
 drivers/tty/sysrq.c                                |  13 +-
 drivers/usb/core/hcd-pci.c                         |   4 +-
 drivers/usb/dwc2/gadget.c                          |   1 -
 drivers/usb/dwc3/drd.c                             |   9 +-
 drivers/usb/dwc3/dwc3-pci.c                        |   2 +-
 drivers/usb/dwc3/gadget.c                          |  31 ++-
 drivers/usb/dwc3/host.c                            |   2 -
 drivers/usb/host/isp116x-hcd.c                     |   6 +-
 drivers/usb/host/oxu210hp-hcd.c                    |   2 +
 drivers/usb/musb/omap2430.c                        |   1 +
 drivers/usb/phy/phy-omap-otg.c                     |   4 +-
 drivers/usb/storage/karma.c                        |  15 +-
 drivers/usb/typec/mux.c                            |  14 +-
 drivers/usb/typec/tcpm/fusb302.c                   |   4 +-
 drivers/usb/usbip/stub_dev.c                       |   2 +-
 drivers/usb/usbip/stub_rx.c                        |   2 +
 drivers/vdpa/ifcvf/ifcvf_main.c                    |   3 +-
 drivers/vdpa/vdpa.c                                |  13 +-
 drivers/vdpa/vdpa_user/vduse_dev.c                 |   7 +-
 drivers/vhost/vringh.c                             |  10 +-
 drivers/video/fbdev/hyperv_fb.c                    |  19 +-
 drivers/video/fbdev/pxa3xx-gcu.c                   |  12 +-
 drivers/virtio/virtio_pci_modern_dev.c             |   1 +
 drivers/watchdog/rti_wdt.c                         |   2 +-
 drivers/watchdog/rzg2l_wdt.c                       |  46 ++--
 drivers/watchdog/ts4800_wdt.c                      |   5 +-
 drivers/watchdog/wdat_wdt.c                        |   1 +
 drivers/xen/xlate_mmu.c                            |   1 -
 fs/afs/dir.c                                       |   5 +-
 fs/ceph/addr.c                                     |  33 +--
 fs/ceph/mds_client.c                               |  33 ++-
 fs/ceph/xattr.c                                    |  10 +-
 fs/cifs/cifs_swn.c                                 |   4 +-
 fs/cifs/cifsencrypt.c                              |   8 +-
 fs/cifs/cifsfs.c                                   |   2 +-
 fs/cifs/cifsfs.h                                   |   2 +-
 fs/cifs/cifsglob.h                                 |  24 +-
 fs/cifs/connect.c                                  |  30 +--
 fs/cifs/dfs_cache.c                                |   4 +-
 fs/cifs/misc.c                                     |  27 ++-
 fs/cifs/sess.c                                     |  11 +-
 fs/cifs/smb1ops.c                                  |   6 +-
 fs/cifs/smb2ops.c                                  |   7 +-
 fs/cifs/smb2pdu.c                                  |   9 +-
 fs/cifs/smbdirect.c                                |   4 +-
 fs/cifs/transport.c                                |  40 ++--
 fs/erofs/zdata.c                                   |   2 +-
 fs/f2fs/checkpoint.c                               |  12 +-
 fs/f2fs/f2fs.h                                     |  23 +-
 fs/f2fs/file.c                                     |   1 +
 fs/f2fs/node.c                                     |  23 +-
 fs/fs-writeback.c                                  |  37 ++-
 fs/inode.c                                         |   2 +-
 fs/jffs2/fs.c                                      |   1 +
 fs/kernfs/dir.c                                    |  31 ++-
 fs/ksmbd/smbacl.c                                  |   1 +
 fs/ksmbd/transport_rdma.c                          |   1 +
 fs/nfs/nfs4proc.c                                  |   4 +
 fs/nfsd/filecache.c                                |   9 +-
 fs/zonefs/super.c                                  |  11 +-
 include/linux/blkdev.h                             |   1 +
 include/linux/export.h                             |   7 +-
 include/linux/extcon.h                             |   2 +-
 include/linux/iio/common/st_sensors.h              |   3 +
 include/linux/jump_label.h                         |   4 +-
 include/linux/mlx5/mlx5_ifc.h                      |   5 +-
 include/linux/nodemask.h                           |  38 +--
 include/linux/random.h                             |   2 +-
 include/linux/xarray.h                             |   1 +
 include/net/ax25.h                                 |   1 +
 include/net/bluetooth/hci_core.h                   |  17 +-
 include/net/bonding.h                              |   6 +
 include/net/flow_offload.h                         |   1 +
 include/net/netfilter/nf_tables.h                  |   1 -
 include/net/netfilter/nf_tables_offload.h          |   2 +-
 include/net/sch_generic.h                          |  42 ++--
 include/net/tcp.h                                  |  19 +-
 include/trace/events/tcp.h                         |   2 +-
 kernel/bpf/core.c                                  |  14 +-
 kernel/sched/autogroup.c                           |   2 +-
 kernel/trace/trace.c                               |  13 +-
 kernel/trace/trace_syscalls.c                      |  35 +--
 lib/Makefile                                       |   2 +-
 lib/iov_iter.c                                     |  20 +-
 lib/nodemask.c                                     |   4 +-
 lib/xarray.c                                       |   5 +-
 mm/filemap.c                                       |   9 +-
 mm/huge_memory.c                                   |   3 +-
 net/ax25/af_ax25.c                                 |  27 ++-
 net/ax25/ax25_dev.c                                |   1 +
 net/ax25/ax25_subr.c                               |   2 +-
 net/bluetooth/hci_core.c                           |   4 +-
 net/bluetooth/hci_request.c                        |   2 +-
 net/bluetooth/hci_sync.c                           |  62 +++--
 net/bluetooth/mgmt.c                               |  45 ++--
 net/core/filter.c                                  |   2 +-
 net/core/flow_offload.c                            |   6 +
 net/core/neighbour.c                               |   2 +-
 net/ipv4/inet_hashtables.c                         |  10 +-
 net/ipv4/ip_gre.c                                  |  11 +-
 net/ipv4/tcp.c                                     |   8 +-
 net/ipv4/tcp_bbr.c                                 |  20 +-
 net/ipv4/tcp_bic.c                                 |  14 +-
 net/ipv4/tcp_cdg.c                                 |  30 +--
 net/ipv4/tcp_cong.c                                |  18 +-
 net/ipv4/tcp_cubic.c                               |  22 +-
 net/ipv4/tcp_dctcp.c                               |  11 +-
 net/ipv4/tcp_highspeed.c                           |  18 +-
 net/ipv4/tcp_htcp.c                                |  10 +-
 net/ipv4/tcp_hybla.c                               |  18 +-
 net/ipv4/tcp_illinois.c                            |  12 +-
 net/ipv4/tcp_input.c                               |  36 +--
 net/ipv4/tcp_ipv4.c                                |   2 +-
 net/ipv4/tcp_lp.c                                  |   6 +-
 net/ipv4/tcp_metrics.c                             |  12 +-
 net/ipv4/tcp_nv.c                                  |  24 +-
 net/ipv4/tcp_output.c                              |  34 +--
 net/ipv4/tcp_rate.c                                |   2 +-
 net/ipv4/tcp_scalable.c                            |   4 +-
 net/ipv4/tcp_vegas.c                               |  21 +-
 net/ipv4/tcp_veno.c                                |  24 +-
 net/ipv4/tcp_westwood.c                            |   3 +-
 net/ipv4/tcp_yeah.c                                |  30 +--
 net/ipv4/xfrm4_protocol.c                          |   1 -
 net/ipv6/ping.c                                    |   8 +-
 net/ipv6/seg6_hmac.c                               |   1 -
 net/ipv6/seg6_local.c                              |   1 +
 net/ipv6/tcp_ipv6.c                                |   2 +-
 net/key/af_key.c                                   |  10 +-
 net/netfilter/nf_tables_api.c                      |  54 ++---
 net/netfilter/nf_tables_offload.c                  |  23 +-
 net/netfilter/nft_nat.c                            |   3 +-
 net/openvswitch/actions.c                          |   6 +
 net/openvswitch/conntrack.c                        |   4 +-
 net/sched/act_ct.c                                 |   2 +-
 net/smc/af_smc.c                                   |   1 +
 net/smc/smc_cdc.c                                  |   2 +-
 net/sunrpc/xdr.c                                   |   6 +-
 net/sunrpc/xprtrdma/rpc_rdma.c                     |   5 +
 net/sunrpc/xprtrdma/svc_rdma_rw.c                  |   4 +-
 net/tipc/bearer.c                                  |   3 +-
 net/unix/af_unix.c                                 |   2 +-
 net/xdp/xsk.c                                      |   5 +-
 net/xdp/xsk_queue.h                                |   8 -
 scripts/gdb/linux/config.py                        |   6 +-
 scripts/get_abi.pl                                 |   4 +-
 scripts/mod/modpost.c                              |   5 +-
 security/keys/trusted-keys/trusted_tpm2.c          |   4 +-
 sound/pci/hda/patch_conexant.c                     |   7 +
 sound/pci/hda/patch_realtek.c                      |   2 +
 sound/soc/amd/acp/acp-pci.c                        |   1 +
 sound/soc/codecs/rt5640.c                          |  11 +-
 sound/soc/codecs/rt5640.h                          |   2 +
 sound/soc/fsl/fsl_sai.h                            |   4 +-
 sound/soc/intel/boards/bytcr_rt5640.c              |   2 +
 sound/usb/pcm.c                                    |   5 +-
 sound/usb/quirks-table.h                           |   7 +-
 tools/objtool/check.c                              |   3 +-
 tools/perf/arch/x86/util/evlist.c                  |   5 +-
 tools/perf/arch/x86/util/evsel.c                   |  24 +-
 tools/perf/arch/x86/util/evsel.h                   |   7 +
 tools/perf/arch/x86/util/topdown.c                 |  46 ++--
 tools/perf/arch/x86/util/topdown.h                 |   7 +
 tools/perf/builtin-c2c.c                           |   4 +-
 .../selftests/bpf/progs/test_stacktrace_build_id.c |   2 +-
 tools/testing/selftests/net/bpf/Makefile           |   4 +-
 tools/testing/selftests/netfilter/nft_nat.sh       |  43 ++++
 tools/tracing/rtla/Makefile                        |  35 +++
 400 files changed, 2758 insertions(+), 1806 deletions(-)


