Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63420121812
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729225AbfLPSBx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:01:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:37276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729236AbfLPSBx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:01:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D24A4207FF;
        Mon, 16 Dec 2019 18:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519311;
        bh=2e6foPn0HBjKL36CL/gFs7cmj5KiAVxPhIVM/kjRGmM=;
        h=From:To:Cc:Subject:Date:From;
        b=zgkQGBEVsbb33p9GWFxc2IwBiPgXH/Q65CJHU2mJuYLcg+KEodyRg7re5lY8br0I1
         j+P+Ip5GNcUGwcefMX04lehEYJADaAIVqy/RCiSJMLyeMBdMU50ht0tOsSR6SzFg6d
         QLpe8+AnrZ4Ebfl52uGmI6oPYIKBIHAiQeUkz9DI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 000/140] 4.19.90-stable review
Date:   Mon, 16 Dec 2019 18:47:48 +0100
Message-Id: <20191216174747.111154704@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.90-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.90-rc1
X-KernelTest-Deadline: 2019-12-18T17:48+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.90 release.
There are 140 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 18 Dec 2019 17:41:25 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.90-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.90-rc1

Heiko Carstens <heiko.carstens@de.ibm.com>
    s390/smp,vdso: fix ASCE handling

Thomas Hellstrom <thellstrom@vmware.com>
    mm/memory.c: fix a huge pud insertion race during faulting

Michal Hocko <mhocko@suse.com>
    mm, thp, proc: report THP eligibility for each vma

Daniel Schultz <d.schultz@phytec.de>
    mfd: rk808: Fix RK818 ID template

yangerkun <yangerkun@huawei.com>
    ext4: fix a bug in ext4_wait_for_tail_page_commit

Darrick J. Wong <darrick.wong@oracle.com>
    splice: only read in as much information as there is pipe buffer space

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: disable uie before setting time and enable after

Chen Jun <chenjun102@huawei.com>
    mm/shmem.c: cast the type of unmap_start to u64

Will Deacon <will@kernel.org>
    firmware: qcom: scm: Ensure 'a0' status code is treated as signed

Theodore Ts'o <tytso@mit.edu>
    ext4: work around deleting a file with i_nlink == 0 safely

Vincenzo Frascino <vincenzo.frascino@arm.com>
    powerpc: Fix vDSO clock_getres()

Nathan Chancellor <natechancellor@gmail.com>
    powerpc: Avoid clang warnings around setjmp and longjmp

Anders Roxell <anders.roxell@linaro.org>
    regulator: 88pm800: fix warning same module names

Miaoqing Pan <miaoqing@codeaurora.org>
    ath10k: fix fw crash by moving chip reset after napi disabled

Helen Koike <helen.koike@collabora.com>
    media: vimc: fix component match compare

Ido Schimmel <idosch@mellanox.com>
    mlxsw: spectrum_router: Refresh nexthop neighbour when it becomes dead

Tony Lindgren <tony@atomide.com>
    power: supply: cpcap-battery: Fix signed counter sample register

Shirish S <Shirish.S@amd.com>
    x86/MCE/AMD: Carve out the MC4_MISC thresholding quirk

Shirish S <Shirish.S@amd.com>
    x86/MCE/AMD: Turn off MC4_MISC thresholding on all family 0x15 models

Luo Jiaxing <luojiaxing@huawei.com>
    scsi: hisi_sas: Reject setting programmed minimum linkrate > 1.5G

Xiang Chen <chenxiang66@hisilicon.com>
    scsi: hisi_sas: send primitive NOTIFY to SSP situation only

Yonglong Liu <liuyonglong@huawei.com>
    net: hns3: Check variable is valid before assigning it to another

Huazhong Tan <tanhuazhong@huawei.com>
    net: hns3: change hnae3_register_ae_dev() to int

Jian Shen <shenjian15@huawei.com>
    net: hns3: clear pci private data when unload hns3 driver

Karsten Graul <kgraul@linux.ibm.com>
    net/smc: do not wait under send_lock

Toke Høiland-Jørgensen <toke@redhat.com>
    sch_cake: Correctly update parent qlen when splitting GSO packets

Stefano Stabellini <sstabellini@kernel.org>
    pvcalls-front: don't return error when the ring is full

YueHaibing <yuehaibing@huawei.com>
    e100: Fix passing zero to 'PTR_ERR' warning in e100_load_ucode_wait

Nathan Chancellor <natechancellor@gmail.com>
    drbd: Change drbd_request_detach_interruptible's return type to int

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Correct topology type reporting on G7 adapters

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Correct code setting non existent bits in sli4 ABORT WQE

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Cap NPIV vports to 256

H. Nikolaus Schaller <hns@goldelico.com>
    omap: pdata-quirks: remove openpandora quirks for mmc3 and wl1251

Wen Yang <wenyang@linux.alibaba.com>
    usb: typec: fix use after free in typec_register_port()

Meng Li <Meng.Li@windriver.com>
    iio: ad7949: kill pointless "readback"-handling code

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: make sure interrupts are restored to correct state

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix SRB leak on switch command timeout

Himanshu Madhani <hmadhani@marvell.com>
    scsi: qla2xxx: Fix message indicating vectors used by driver

Bart Van Assche <bvanassche@acm.org>
    scsi: qla2xxx: Always check the qla2x00_wait_for_hba_online() return value

Bart Van Assche <bvanassche@acm.org>
    scsi: qla2xxx: Fix qla24xx_process_bidir_cmd()

Bart Van Assche <bvanassche@acm.org>
    scsi: qla2xxx: Fix session lookup in qlt_abort_work()

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix hang in fcport delete path

Himanshu Madhani <hmadhani@marvell.com>
    scsi: qla2xxx: Fix DMA unmap leak

Steffen Maier <maier@linux.ibm.com>
    scsi: zfcp: trace channel log even for FCP command responses

Ming Lei <ming.lei@redhat.com>
    block: fix single range discard merge

Jeff Mahoney <jeffm@suse.com>
    reiserfs: fix extended attributes on the root directory

Jan Kara <jack@suse.cz>
    ext4: Fix credit estimate for final inode freeing

Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
    quota: fix livelock in dquot_writeback_dquots

Chengguang Xu <cgxu519@mykernel.net>
    ext2: check err when partial != NULL

Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
    quota: Check that quota is not dirty before release

Ville Syrjälä <ville.syrjala@linux.intel.com>
    video/hdmi: Fix AVI bar unpack

Cédric Le Goater <clg@kaod.org>
    powerpc/xive: Skip ioremap() of ESB pages for LSI interrupts

Alastair D'Silva <alastair@d-silva.org>
    powerpc: Allow flush_icache_range to work across ranges >4GB

Cédric Le Goater <clg@kaod.org>
    powerpc/xive: Prevent page fault issues in the machine crash handler

Alastair D'Silva <alastair@d-silva.org>
    powerpc: Allow 64bit VDSO __kernel_sync_dicache to work across ranges >4GB

Arnd Bergmann <arnd@arndb.de>
    ppdev: fix PPGETTIME/PPSETTIME ioctls

Jarkko Nikula <jarkko.nikula@bitmer.com>
    ARM: dts: omap3-tao3530: Fix incorrect MMC card detection GPIO polarity

H. Nikolaus Schaller <hns@goldelico.com>
    mmc: host: omap_hsmmc: add code for special init of wl1251 to get rid of pandora_wl1251_init_card

Krzysztof Kozlowski <krzk@kernel.org>
    pinctrl: samsung: Fix device node refcount leaks in S3C64xx wakeup controller init

Krzysztof Kozlowski <krzk@kernel.org>
    pinctrl: samsung: Fix device node refcount leaks in init code

Krzysztof Kozlowski <krzk@kernel.org>
    pinctrl: samsung: Fix device node refcount leaks in S3C24xx wakeup controller init

Krzysztof Kozlowski <krzk@kernel.org>
    pinctrl: samsung: Fix device node refcount leaks in Exynos wakeup controller init

Nishka Dasgupta <nishkadg.linux@gmail.com>
    pinctrl: samsung: Add of_node_put() before return in error path

Gregory CLEMENT <gregory.clement@bootlin.com>
    pinctrl: armada-37xx: Fix irq mask access in armada_37xx_irq_set_type()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: PM: Avoid attaching ACPI PM domain to certain devices

Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>
    ACPI: bus: Fix NULL pointer check in acpi_bus_get_private_data()

Francesco Ruggeri <fruggeri@arista.com>
    ACPI: OSL: only free map once in osl.c

Mika Westerberg <mika.westerberg@linux.intel.com>
    ACPI / hotplug / PCI: Allocate resources directly under the non-hotplug bridge

John Hubbard <jhubbard@nvidia.com>
    cpufreq: powernv: fix stack bloat and hard limit on number of CPUs

Leonard Crestez <leonard.crestez@nxp.com>
    PM / devfreq: Lock devfreq in trans_stat_show

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Tiger Lake CPU support

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Ice Lake CPU support

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: Fix a double put_device() in error path

Gao Xiang <gaoxiang25@huawei.com>
    erofs: zero out when listxattr is called with no xattr

Zhenzhong Duan <zhenzhong.duan@oracle.com>
    cpuidle: Do not unset the driver if it is there already

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec.h: CEC_OP_REC_FLAG_ values were swapped

Johan Hovold <johan@kernel.org>
    media: radio: wl1273: fix interrupt masking on release

Johan Hovold <johan@kernel.org>
    media: bdisp: fix memleak on release

Gerald Schaefer <gerald.schaefer@de.ibm.com>
    s390/mm: properly clear _PAGE_NOEXEC bit when it is not supported

Denis Efremov <efremov@linux.com>
    ar5523: check NULL before memcpy() in ar5523_cmd()

Aleksa Sarai <cyphar@cyphar.com>
    cgroup: pids: use atomic64_t for pids->limit

Ming Lei <ming.lei@redhat.com>
    blk-mq: avoid sysfs buffer overflow with too many CPU cores

David Jeffery <djeffery@redhat.com>
    md: improve handling of bio with REQ_PREFLUSH in md_flush_request()

Pawel Harlozinski <pawel.harlozinski@linux.intel.com>
    ASoC: Jack: Fix NULL pointer dereference in snd_soc_jack_report

Jacob Rasmussen <jacobraz@chromium.org>
    ASoC: rt5645: Fixed typo for buddy jack support.

Jacob Rasmussen <jacobraz@chromium.org>
    ASoC: rt5645: Fixed buddy jack support.

Tejun Heo <tj@kernel.org>
    workqueue: Fix pwq ref leak in rescuer_thread()

Tejun Heo <tj@kernel.org>
    workqueue: Fix spurious sanity check failures in destroy_workqueue()

Dmitry Fomichev <dmitry.fomichev@wdc.com>
    dm zoned: reduce overhead of backing device checks

Maged Mokhtar <mmokhtar@petasan.org>
    dm writecache: handle REQ_FUA

Sumit Garg <sumit.garg@linaro.org>
    hwrng: omap - Fix RNG wait loop timeout

Amir Goldstein <amir73il@gmail.com>
    ovl: relax WARN_ON() on rename to self

Amir Goldstein <amir73il@gmail.com>
    ovl: fix corner case of non-unique st_dev;st_ino

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    lib: raid6: fix awk build warnings

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192de: Fix missing enable interrupt flag

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192de: Fix missing callback that tests for hw release of buffer

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192de: Fix missing code to retrieve RX buffer address

Josef Bacik <josef@toxicpanda.com>
    btrfs: record all roots for rename exchange on a subvol

Filipe Manana <fdmanana@suse.com>
    Btrfs: send, skip backreference walking for extents with many references

Qu Wenruo <wqu@suse.com>
    btrfs: Remove btrfs_bio::flags member

Tejun Heo <tj@kernel.org>
    btrfs: Avoid getting stuck during cyclic writebacks

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix negative subv_writers counter and data space leak after buffered write

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix metadata space leak on fixup worker failure to set range as delalloc

Josef Bacik <josef@toxicpanda.com>
    btrfs: use refcount_inc_not_zero in kill_all_nodes

Josef Bacik <josef@toxicpanda.com>
    btrfs: check page->mapping when loading free space cache

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    phy: renesas: rcar-gen3-usb2: Fix sysfs interface of "role"

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: ep0: Clear started flag on completion

Tejas Joglekar <Tejas.Joglekar@synopsys.com>
    usb: dwc3: gadget: Fix logical condition

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: dwc3: pci: add ID for the Intel Comet Lake -H variant

David Hildenbrand <david@redhat.com>
    virtio-balloon: fix managed page counts when migrating pages between zones

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: spear_smi: Fix Write Burst mode

Tadeusz Struk <tadeusz.struk@intel.com>
    tpm: add check after commands attribs tab allocation

Pete Zaitcev <zaitcev@redhat.com>
    usb: mon: Fix a deadlock in usbmon between mmap and read

Emiliano Ingrassia <ingrassia@epigenesys.com>
    usb: core: urb: fix URB structure initialization function

Johan Hovold <johan@kernel.org>
    USB: adutux: fix interface sanity check

Wen Yang <wenyang@linux.alibaba.com>
    usb: roles: fix a potential use after free

Johan Hovold <johan@kernel.org>
    USB: serial: io_edgeport: fix epic endpoint lookup

Johan Hovold <johan@kernel.org>
    USB: idmouse: fix interface sanity checks

Johan Hovold <johan@kernel.org>
    USB: atm: ueagle-atm: add missing endpoint check

Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>
    iio: imu: inv_mpu6050: fix temperature reporting using bad unit

Chris Lesiak <chris.lesiak@licor.com>
    iio: humidity: hdc100x: fix IIO_HUMIDITYRELATIVE channel reporting

Nuno Sá <nuno.sa@analog.com>
    iio: adis16480: Add debugfs_reg_access entry

H. Nikolaus Schaller <hns@goldelico.com>
    ARM: dts: pandora-common: define wl1251 as child node of mmc3

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: handle some XHCI_TRUST_TX_LENGTH quirks cases as default behaviour.

Kai-Heng Feng <kai.heng.feng@canonical.com>
    xhci: Increase STS_HALT timeout in xhci_suspend()

Mika Westerberg <mika.westerberg@linux.intel.com>
    xhci: Fix memory leak in xhci_add_in_port()

Henry Lin <henryl@nvidia.com>
    usb: xhci: only set D3hot for pci device

Johan Hovold <johan@kernel.org>
    staging: gigaset: add endpoint-type sanity check

Johan Hovold <johan@kernel.org>
    staging: gigaset: fix illegal free on probe errors

Johan Hovold <johan@kernel.org>
    staging: gigaset: fix general protection fault on probe

Johan Hovold <johan@kernel.org>
    staging: rtl8712: fix interface sanity check

Johan Hovold <johan@kernel.org>
    staging: rtl8188eu: fix interface sanity check

Kai-Heng Feng <kai.heng.feng@canonical.com>
    usb: Allow USB device to be warm reset in suspended state

Oliver Neukum <oneukum@suse.com>
    USB: documentation: flags on usb-storage versus UAS

Oliver Neukum <oneukum@suse.com>
    USB: uas: heed CAPACITY_HEURISTICS

Oliver Neukum <oneukum@suse.com>
    USB: uas: honor flag to avoid CAPACITY16

Arnd Bergmann <arnd@arndb.de>
    media: venus: remove invalid compat_ioctl32 handler

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix driver unload hang

Gustavo A. R. Silva <gustavo@embeddedor.com>
    usb: gadget: pch_udc: fix use after free

Wei Yongjun <weiyongjun1@huawei.com>
    usb: gadget: configfs: Fix missing spin_lock_init()


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    | 22 ++---
 Documentation/filesystems/proc.txt                 |  3 +
 Makefile                                           |  4 +-
 arch/arm/boot/dts/omap3-pandora-common.dtsi        | 36 ++++++++-
 arch/arm/boot/dts/omap3-tao3530.dtsi               |  2 +-
 arch/arm/mach-omap2/pdata-quirks.c                 | 93 ----------------------
 arch/powerpc/include/asm/vdso_datapage.h           |  2 +
 arch/powerpc/kernel/Makefile                       |  4 +-
 arch/powerpc/kernel/asm-offsets.c                  |  2 +-
 arch/powerpc/kernel/misc_64.S                      |  4 +-
 arch/powerpc/kernel/time.c                         |  1 +
 arch/powerpc/kernel/vdso32/gettimeofday.S          |  7 +-
 arch/powerpc/kernel/vdso64/cacheflush.S            |  4 +-
 arch/powerpc/kernel/vdso64/gettimeofday.S          |  7 +-
 arch/powerpc/sysdev/xive/common.c                  |  9 +++
 arch/powerpc/sysdev/xive/spapr.c                   | 12 ++-
 arch/powerpc/xmon/Makefile                         |  4 +-
 arch/s390/include/asm/pgtable.h                    |  4 +-
 arch/s390/kernel/smp.c                             |  5 ++
 arch/x86/kernel/cpu/mcheck/mce.c                   | 30 -------
 arch/x86/kernel/cpu/mcheck/mce_amd.c               | 36 +++++++++
 block/blk-merge.c                                  |  2 +-
 block/blk-mq-sysfs.c                               | 15 ++--
 drivers/acpi/bus.c                                 |  2 +-
 drivers/acpi/device_pm.c                           | 12 ++-
 drivers/acpi/osl.c                                 | 28 ++++---
 drivers/block/drbd/drbd_state.c                    |  6 +-
 drivers/block/drbd/drbd_state.h                    |  3 +-
 drivers/char/hw_random/omap-rng.c                  |  9 ++-
 drivers/char/ppdev.c                               | 16 +++-
 drivers/char/tpm/tpm2-cmd.c                        |  4 +
 drivers/cpufreq/powernv-cpufreq.c                  | 17 +++-
 drivers/cpuidle/driver.c                           | 15 ++--
 drivers/devfreq/devfreq.c                          | 12 ++-
 drivers/edac/altera_edac.c                         |  1 +
 drivers/firmware/qcom_scm-64.c                     |  2 +-
 drivers/hwtracing/intel_th/core.c                  |  8 +-
 drivers/hwtracing/intel_th/pci.c                   | 10 +++
 drivers/iio/humidity/hdc100x.c                     |  2 +-
 drivers/iio/imu/adis16480.c                        |  1 +
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c         | 23 +++---
 drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h          | 16 +++-
 drivers/isdn/gigaset/usb-gigaset.c                 | 23 ++++--
 drivers/md/dm-writecache.c                         |  3 +-
 drivers/md/dm-zoned-metadata.c                     | 29 ++++---
 drivers/md/dm-zoned-reclaim.c                      |  8 +-
 drivers/md/dm-zoned-target.c                       | 54 +++++++++----
 drivers/md/dm-zoned.h                              |  2 +
 drivers/md/md-linear.c                             |  5 +-
 drivers/md/md-multipath.c                          |  5 +-
 drivers/md/md.c                                    | 11 ++-
 drivers/md/md.h                                    |  4 +-
 drivers/md/raid0.c                                 |  5 +-
 drivers/md/raid1.c                                 |  5 +-
 drivers/md/raid10.c                                |  5 +-
 drivers/md/raid5.c                                 |  4 +-
 drivers/media/platform/qcom/venus/vdec.c           |  3 -
 drivers/media/platform/qcom/venus/venc.c           |  3 -
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c      |  3 +-
 drivers/media/platform/vimc/vimc-core.c            |  7 +-
 drivers/media/radio/radio-wl1273.c                 |  3 +-
 drivers/mmc/host/omap_hsmmc.c                      | 30 +++++++
 drivers/mtd/devices/spear_smi.c                    | 38 ++++++++-
 drivers/net/ethernet/hisilicon/hns3/hnae3.c        | 26 ++++--
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  9 ++-
 drivers/net/ethernet/intel/e100.c                  |  4 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  | 73 ++++++++++++++++-
 drivers/net/wireless/ath/ar5523/ar5523.c           |  3 +-
 drivers/net/wireless/ath/ath10k/pci.c              |  9 ++-
 .../net/wireless/realtek/rtlwifi/rtl8192de/hw.c    |  9 ++-
 .../net/wireless/realtek/rtlwifi/rtl8192de/sw.c    |  1 +
 .../net/wireless/realtek/rtlwifi/rtl8192de/trx.c   | 25 +++++-
 .../net/wireless/realtek/rtlwifi/rtl8192de/trx.h   |  2 +
 drivers/pci/hotplug/acpiphp_glue.c                 | 12 ++-
 drivers/phy/renesas/phy-rcar-gen3-usb2.c           |  5 +-
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c        |  6 +-
 drivers/pinctrl/samsung/pinctrl-exynos.c           | 14 +++-
 drivers/pinctrl/samsung/pinctrl-s3c24xx.c          |  6 +-
 drivers/pinctrl/samsung/pinctrl-s3c64xx.c          |  6 +-
 drivers/pinctrl/samsung/pinctrl-samsung.c          | 10 ++-
 drivers/power/supply/cpcap-battery.c               | 11 +--
 .../regulator/{88pm800.c => 88pm800-regulator.c}   |  0
 drivers/regulator/Makefile                         |  2 +-
 drivers/rtc/interface.c                            | 19 ++++-
 drivers/s390/scsi/zfcp_dbf.c                       |  8 +-
 drivers/scsi/hisi_sas/hisi_sas.h                   |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c              | 15 ++--
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c             |  4 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c             |  4 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |  4 +-
 drivers/scsi/lpfc/lpfc.h                           |  3 +-
 drivers/scsi/lpfc/lpfc_attr.c                      | 17 +++-
 drivers/scsi/lpfc/lpfc_init.c                      |  3 +
 drivers/scsi/lpfc/lpfc_mbox.c                      |  6 +-
 drivers/scsi/lpfc/lpfc_nvme.c                      |  2 -
 drivers/scsi/lpfc/lpfc_sli.c                       | 14 +---
 drivers/scsi/qla2xxx/qla_attr.c                    |  3 +-
 drivers/scsi/qla2xxx/qla_bsg.c                     | 15 ++--
 drivers/scsi/qla2xxx/qla_gs.c                      |  2 +-
 drivers/scsi/qla2xxx/qla_init.c                    | 16 ++--
 drivers/scsi/qla2xxx/qla_isr.c                     |  6 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |  4 -
 drivers/scsi/qla2xxx/qla_mid.c                     | 11 +--
 drivers/scsi/qla2xxx/qla_os.c                      |  7 +-
 drivers/scsi/qla2xxx/qla_target.c                  | 11 +--
 drivers/staging/erofs/xattr.c                      |  2 +
 drivers/staging/rtl8188eu/os_dep/usb_intf.c        |  2 +-
 drivers/staging/rtl8712/usb_intf.c                 |  2 +-
 drivers/usb/atm/ueagle-atm.c                       | 18 +++--
 drivers/usb/core/hub.c                             |  5 +-
 drivers/usb/core/urb.c                             |  1 +
 drivers/usb/dwc3/dwc3-pci.c                        |  6 +-
 drivers/usb/dwc3/ep0.c                             |  8 ++
 drivers/usb/dwc3/gadget.c                          |  2 +-
 drivers/usb/gadget/configfs.c                      |  1 +
 drivers/usb/gadget/udc/pch_udc.c                   |  1 -
 drivers/usb/host/xhci-hub.c                        |  8 +-
 drivers/usb/host/xhci-mem.c                        |  4 +
 drivers/usb/host/xhci-pci.c                        | 13 +++
 drivers/usb/host/xhci-ring.c                       |  3 +-
 drivers/usb/host/xhci.c                            |  9 +--
 drivers/usb/host/xhci.h                            |  1 +
 drivers/usb/misc/adutux.c                          |  2 +-
 drivers/usb/misc/idmouse.c                         |  2 +-
 drivers/usb/mon/mon_bin.c                          | 32 +++++---
 drivers/usb/roles/class.c                          |  2 +-
 drivers/usb/serial/io_edgeport.c                   | 10 ++-
 drivers/usb/storage/uas.c                          | 10 +++
 drivers/usb/typec/class.c                          |  6 +-
 drivers/video/hdmi.c                               |  8 +-
 drivers/virtio/virtio_balloon.c                    | 11 +++
 drivers/xen/pvcalls-front.c                        |  4 +-
 fs/btrfs/delayed-inode.c                           | 13 ++-
 fs/btrfs/extent_io.c                               | 12 +--
 fs/btrfs/file.c                                    |  2 +-
 fs/btrfs/free-space-cache.c                        |  6 ++
 fs/btrfs/inode.c                                   |  9 ++-
 fs/btrfs/send.c                                    | 25 +++++-
 fs/btrfs/volumes.h                                 |  1 -
 fs/ext2/inode.c                                    |  7 +-
 fs/ext4/inode.c                                    | 25 ++++--
 fs/ext4/namei.c                                    | 11 ++-
 fs/ocfs2/quota_global.c                            |  2 +-
 fs/overlayfs/dir.c                                 |  2 +-
 fs/overlayfs/inode.c                               |  8 +-
 fs/proc/task_mmu.c                                 |  2 +
 fs/quota/dquot.c                                   | 11 +--
 fs/reiserfs/inode.c                                | 12 ++-
 fs/reiserfs/namei.c                                |  7 +-
 fs/reiserfs/reiserfs.h                             |  2 +
 fs/reiserfs/super.c                                |  2 +
 fs/reiserfs/xattr.c                                | 19 +++--
 fs/reiserfs/xattr_acl.c                            |  4 +-
 fs/splice.c                                        | 14 +++-
 include/asm-generic/pgtable.h                      | 25 ++++++
 include/linux/huge_mm.h                            | 13 ++-
 include/linux/mfd/rk808.h                          |  2 +-
 include/linux/quotaops.h                           | 10 +++
 include/uapi/linux/cec.h                           |  4 +-
 kernel/cgroup/pids.c                               | 11 +--
 kernel/workqueue.c                                 | 37 +++++++--
 lib/raid6/unroll.awk                               |  2 +-
 mm/huge_memory.c                                   | 12 ++-
 mm/memory.c                                        | 10 ++-
 mm/shmem.c                                         |  2 +-
 net/sched/sch_cake.c                               |  5 +-
 net/smc/smc_tx.c                                   | 10 +--
 sound/soc/codecs/rt5645.c                          |  6 +-
 sound/soc/soc-jack.c                               |  3 +-
 170 files changed, 1112 insertions(+), 565 deletions(-)


