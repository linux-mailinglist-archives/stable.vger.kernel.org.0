Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7931C1214EA
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731514AbfLPSQW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:16:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:38598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731507AbfLPSQU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:16:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57C1C206E0;
        Mon, 16 Dec 2019 18:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520179;
        bh=lkk1WaQZu2LfhLJ/w10BbhLLd60ESXLSqDWE0sSPCf0=;
        h=From:To:Cc:Subject:Date:From;
        b=CIc/a54/upp0txN6+qc/PRufmjS4e64zlz82FQc1Okv0GVP0oMoyqTZf2Ca4PYe6R
         EHGRDBuN8Hc7ilkQR8sAmcxgepyS64M+0Rg2UfWnsuZItoq2RPlALpeoiR1NqLeXom
         zrq5vBmoc5QdeL59bXeH1NuyMEt9JbKf9BbYhedQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.4 000/177] 5.4.4-stable review
Date:   Mon, 16 Dec 2019 18:47:36 +0100
Message-Id: <20191216174811.158424118@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.4-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.4-rc1
X-KernelTest-Deadline: 2019-12-18T17:48+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.4 release.
There are 177 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 18 Dec 2019 17:41:25 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.4-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.4-rc1

Jan Kara <jack@suse.cz>
    ext4: fix leak of quota reservations

yangerkun <yangerkun@huawei.com>
    ext4: fix a bug in ext4_wait_for_tail_page_commit

Darrick J. Wong <darrick.wong@oracle.com>
    splice: only read in as much information as there is pipe buffer space

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: disable uie before setting time and enable after

Andrey Konovalov <andreyknvl@google.com>
    USB: dummy-hcd: increase max number of devices to 32

Michael Ellerman <mpe@ellerman.id.au>
    powerpc: Define arch_is_kernel_initmem_freed() for lockdep

Chen Jun <chenjun102@huawei.com>
    mm/shmem.c: cast the type of unmap_start to u64

Gerald Schaefer <gerald.schaefer@de.ibm.com>
    s390/kaslr: store KASLR offset for early dumps

Heiko Carstens <heiko.carstens@de.ibm.com>
    s390/smp,vdso: fix ASCE handling

Will Deacon <will@kernel.org>
    firmware: qcom: scm: Ensure 'a0' status code is treated as signed

Theodore Ts'o <tytso@mit.edu>
    ext4: work around deleting a file with i_nlink == 0 safely

Roman Gushchin <guro@fb.com>
    mm: memcg/slab: wait for !root kmem_cache refcnt killing on root kmem_cache destruction

Daniel Schultz <d.schultz@phytec.de>
    mfd: rk808: Fix RK818 ID template

Nicolas Geoffray <ngeoffray@google.com>
    mm, memfd: fix COW issue on MAP_PRIVATE and F_SEAL_FUTURE_WRITE mappings

Vincenzo Frascino <vincenzo.frascino@arm.com>
    powerpc: Fix vDSO clock_getres()

Nathan Chancellor <natechancellor@gmail.com>
    powerpc: Avoid clang warnings around setjmp and longjmp

H. Nikolaus Schaller <hns@goldelico.com>
    omap: pdata-quirks: remove openpandora quirks for mmc3 and wl1251

H. Nikolaus Schaller <hns@goldelico.com>
    omap: pdata-quirks: revert pandora specific gpiod additions

Andrea Merello <andrea.merello@gmail.com>
    iio: ad7949: fix channels mixups

Andrea Merello <andrea.merello@gmail.com>
    iio: ad7949: kill pointless "readback"-handling code

Martin K. Petersen <martin.petersen@oracle.com>
    Revert "scsi: qla2xxx: Fix memory leak when sending I/O fails"

Bart Van Assche <bvanassche@acm.org>
    scsi: qla2xxx: Fix a dma_pool_free() call

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix SRB leak on switch command timeout

Jeff Mahoney <jeffm@suse.com>
    reiserfs: fix extended attributes on the root directory

Jan Kara <jack@suse.cz>
    ext4: Fix credit estimate for final inode freeing

Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
    quota: fix livelock in dquot_writeback_dquots

Christian Brauner <christian.brauner@ubuntu.com>
    seccomp: avoid overflow in implicit constant conversion

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

Yabin Cui <yabinc@google.com>
    coresight: Serialize enabling/disabling a link device.

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    stm class: Lose the protocol driver when dropping its reference

Arnd Bergmann <arnd@arndb.de>
    ppdev: fix PPGETTIME/PPSETTIME ioctls

Bart Van Assche <bvanassche@acm.org>
    RDMA/core: Fix ib_dma_max_seg_size()

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

Chris Brandt <chris.brandt@renesas.com>
    pinctrl: rza2: Fix gpio name typos

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: PM: Avoid attaching ACPI PM domain to certain devices

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: EC: Rework flushing of pending work

Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>
    ACPI: bus: Fix NULL pointer check in acpi_bus_get_private_data()

Francesco Ruggeri <fruggeri@arista.com>
    ACPI: OSL: only free map once in osl.c

Mika Westerberg <mika.westerberg@linux.intel.com>
    ACPI / hotplug / PCI: Allocate resources directly under the non-hotplug bridge

Hans de Goede <hdegoede@redhat.com>
    ACPI: LPSS: Add dmi quirk for skipping _DEP check for some device-links

Hans de Goede <hdegoede@redhat.com>
    ACPI: LPSS: Add LNXVIDEO -> BYT I2C1 to lpss_device_links

Hans de Goede <hdegoede@redhat.com>
    ACPI: LPSS: Add LNXVIDEO -> BYT I2C7 to lpss_device_links

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ACPI / utils: Move acpi_dev_get_first_match_dev() under CONFIG_ACPI

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/realtek - Line-out jack doesn't work on a Dell AIO

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: oxfw: fix return value in error path of isochronous resources reservation

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: fireface: fix return value in error path of isochronous resources reservation

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

Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
    powerpc/perf: Disable trace_imc pmu

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panfrost: Open/close the perfcnt BO

Leo Yan <leo.yan@linaro.org>
    perf tests: Fix out of bounds memory access

Gao Xiang <xiang@kernel.org>
    erofs: zero out when listxattr is called with no xattr

Marcelo Tosatti <mtosatti@redhat.com>
    cpuidle: use first valid target residency as poll time

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpuidle: teo: Fix "early hits" handling for disabled idle states

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpuidle: teo: Consider hits and misses metrics of disabled states

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpuidle: teo: Rename local variable in teo_select()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpuidle: teo: Ignore disabled idle states that are too deep

Zhenzhong Duan <zhenzhong.duan@oracle.com>
    cpuidle: Do not unset the driver if it is there already

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec.h: CEC_OP_REC_FLAG_ values were swapped

Johan Hovold <johan@kernel.org>
    media: radio: wl1273: fix interrupt masking on release

Johan Hovold <johan@kernel.org>
    media: bdisp: fix memleak on release

Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
    media: vimc: sen: remove unused kthread_sen field

Francois Buergisser <fbuergisser@chromium.org>
    media: hantro: Fix picture order count table enable

Francois Buergisser <fbuergisser@chromium.org>
    media: hantro: Fix motion vectors usage condition

Ezequiel Garcia <ezequiel@collabora.com>
    media: hantro: Fix s_fmt for dynamic resolution changes

Gerald Schaefer <gerald.schaefer@de.ibm.com>
    s390/mm: properly clear _PAGE_NOEXEC bit when it is not supported

Denis Efremov <efremov@linux.com>
    ar5523: check NULL before memcpy() in ar5523_cmd()

Denis Efremov <efremov@linux.com>
    wil6210: check len before memcpy() calls

Aleksa Sarai <cyphar@cyphar.com>
    cgroup: pids: use atomic64_t for pids->limit

Ming Lei <ming.lei@redhat.com>
    blk-mq: avoid sysfs buffer overflow with too many CPU cores

David Jeffery <djeffery@redhat.com>
    md: improve handling of bio with REQ_PREFLUSH in md_flush_request()

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_audmix: Add spin lock to protect tdms

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

Amir Goldstein <amir73il@gmail.com>
    ovl: fix lookup failure on multi lower squashfs

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
    btrfs: use btrfs_block_group_cache_done in update_block_group

Josef Bacik <josef@toxicpanda.com>
    btrfs: check page->mapping when loading free space cache

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: fix support for transmitting SKBs with fraglist

Wen Yang <wenyang@linux.alibaba.com>
    usb: typec: fix use after free in typec_register_port()

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    phy: renesas: rcar-gen3-usb2: Fix sysfs interface of "role"

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: ep0: Clear started flag on completion

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Clear started flag for non-IOC

Tejas Joglekar <Tejas.Joglekar@synopsys.com>
    usb: dwc3: gadget: Fix logical condition

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: dwc3: pci: add ID for the Intel Comet Lake -H variant

David Hildenbrand <david@redhat.com>
    virtio-balloon: fix managed page counts when migrating pages between zones

Taehee Yoo <ap420073@gmail.com>
    virt_wifi: fix use-after-free in virt_wifi_newlink()

Piotr Sroka <piotrs@cadence.com>
    mtd: rawnand: Change calculating of position page containing BBM

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: spear_smi: Fix Write Burst mode

Rafał Miłecki <rafal@milecki.pl>
    brcmfmac: disable PCIe interrupts before bus reset

Meng Li <Meng.Li@windriver.com>
    EDAC/altera: Use fast register IO for S10 IRQs

Hans de Goede <hdegoede@redhat.com>
    tpm: Switch to platform_get_irq_optional()

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

Mircea Caprioru <mircea.caprioru@analog.com>
    iio: adc: ad7124: Enable internal reference

Beniamin Bia <beniamin.bia@analog.com>
    iio: adc: ad7606: fix reading unnecessary data from device

Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>
    iio: imu: inv_mpu6050: fix temperature reporting using bad unit

Chris Lesiak <chris.lesiak@licor.com>
    iio: humidity: hdc100x: fix IIO_HUMIDITYRELATIVE channel reporting

Nuno Sá <nuno.sa@analog.com>
    iio: adis16480: Fix scales factors

Lorenzo Bianconi <lorenzo@kernel.org>
    iio: imu: st_lsm6dsx: fix ODR check in st_lsm6dsx_write_raw

Nuno Sá <nuno.sa@analog.com>
    iio: adis16480: Add debugfs_reg_access entry

H. Nikolaus Schaller <hns@goldelico.com>
    ARM: dts: pandora-common: define wl1251 as child node of mmc3

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    usb: common: usb-conn-gpio: Don't log an error on probe deferral

Georgi Djakov <georgi.djakov@linaro.org>
    interconnect: qcom: qcs404: Walk the list safely on node removal

Georgi Djakov <georgi.djakov@linaro.org>
    interconnect: qcom: sdm845: Walk the list safely on node removal

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: make sure interrupts are restored to correct state

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: handle some XHCI_TRUST_TX_LENGTH quirks cases as default behaviour.

Kai-Heng Feng <kai.heng.feng@canonical.com>
    xhci: Increase STS_HALT timeout in xhci_suspend()

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: fix USB3 device initiated resume race with roothub autosuspend

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

Marcelo Diop-Gonzalez <marcgonzalez@google.com>
    staging: vchiq: call unregister_chrdev_region() when driver registration fails

Johan Hovold <johan@kernel.org>
    staging: rtl8712: fix interface sanity check

Johan Hovold <johan@kernel.org>
    staging: rtl8188eu: fix interface sanity check

Brendan Higgins <brendanhiggins@google.com>
    staging: exfat: fix multiple definition error of `rename_file'

Todd Kjos <tkjos@android.com>
    binder: fix incorrect calculation for num_valid

Nagarjuna Kristam <nkristam@nvidia.com>
    usb: host: xhci-tegra: Correct phy enable sequence

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

Arnd Bergmann <arnd@arndb.de>
    ceph: fix compat_ioctl for ceph_dir_operations

Arnd Bergmann <arnd@arndb.de>
    compat_ioctl: add compat_ptr_ioctl()

Arun Easi <aeasi@marvell.com>
    scsi: qla2xxx: Fix memory leak when sending I/O fails

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix double scsi_done for abort path

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix driver unload hang

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Do command completion on abort timeout

Steffen Maier <maier@linux.ibm.com>
    scsi: zfcp: trace channel log even for FCP command responses

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix bad ndlp ptr in xri aborted handling

Jian-Hong Pan <jian-hong@endlessm.com>
    Revert "nvme: Add quirk for Kingston NVME SSD running FW E8FK11.T"

Keith Busch <kbusch@kernel.org>
    nvme: Namepace identification descriptor list is optional

Gustavo A. R. Silva <gustavo@embeddedor.com>
    usb: gadget: pch_udc: fix use after free

Wei Yongjun <weiyongjun1@huawei.com>
    usb: gadget: configfs: Fix missing spin_lock_init()


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |  22 ++--
 Makefile                                           |   4 +-
 arch/arm/boot/dts/omap3-pandora-common.dtsi        |  36 +++++-
 arch/arm/boot/dts/omap3-tao3530.dtsi               |   2 +-
 arch/arm/mach-omap2/pdata-quirks.c                 | 104 -----------------
 arch/powerpc/include/asm/sections.h                |  14 +++
 arch/powerpc/include/asm/vdso_datapage.h           |   2 +
 arch/powerpc/kernel/Makefile                       |   4 +-
 arch/powerpc/kernel/asm-offsets.c                  |   2 +-
 arch/powerpc/kernel/misc_64.S                      |   4 +-
 arch/powerpc/kernel/time.c                         |   1 +
 arch/powerpc/kernel/vdso32/gettimeofday.S          |   7 +-
 arch/powerpc/kernel/vdso64/cacheflush.S            |   4 +-
 arch/powerpc/kernel/vdso64/gettimeofday.S          |   7 +-
 arch/powerpc/platforms/powernv/opal-imc.c          |   9 +-
 arch/powerpc/sysdev/xive/common.c                  |   9 ++
 arch/powerpc/sysdev/xive/spapr.c                   |  12 +-
 arch/powerpc/xmon/Makefile                         |   4 +-
 arch/s390/boot/startup.c                           |   5 +
 arch/s390/include/asm/pgtable.h                    |   4 +-
 arch/s390/kernel/machine_kexec.c                   |   2 +-
 arch/s390/kernel/smp.c                             |   5 +
 block/blk-mq-sysfs.c                               |  15 ++-
 drivers/acpi/acpi_lpss.c                           |  27 ++++-
 drivers/acpi/bus.c                                 |   2 +-
 drivers/acpi/device_pm.c                           |  12 +-
 drivers/acpi/ec.c                                  |  36 +++---
 drivers/acpi/osl.c                                 |  28 +++--
 drivers/android/binder.c                           |   4 +-
 drivers/char/hw_random/omap-rng.c                  |   9 +-
 drivers/char/ppdev.c                               |  16 ++-
 drivers/char/tpm/tpm2-cmd.c                        |   4 +
 drivers/char/tpm/tpm_tis.c                         |   2 +-
 drivers/cpufreq/powernv-cpufreq.c                  |  17 ++-
 drivers/cpuidle/cpuidle.c                          |   1 +
 drivers/cpuidle/driver.c                           |  15 ++-
 drivers/cpuidle/governors/teo.c                    |  78 ++++++++++---
 drivers/devfreq/devfreq.c                          |  12 +-
 drivers/edac/altera_edac.c                         |   1 +
 drivers/firmware/qcom_scm-64.c                     |   2 +-
 drivers/gpu/drm/panfrost/panfrost_drv.c            |   2 +-
 drivers/gpu/drm/panfrost/panfrost_gem.c            |   4 +-
 drivers/gpu/drm/panfrost/panfrost_gem.h            |   4 +
 drivers/gpu/drm/panfrost/panfrost_perfcnt.c        |  23 ++--
 drivers/gpu/drm/panfrost/panfrost_perfcnt.h        |   2 +-
 drivers/hwtracing/coresight/coresight-funnel.c     |  36 ++++--
 drivers/hwtracing/coresight/coresight-replicator.c |  35 +++++-
 drivers/hwtracing/coresight/coresight-tmc-etf.c    |  26 +++--
 drivers/hwtracing/coresight/coresight.c            |  45 +++-----
 drivers/hwtracing/intel_th/core.c                  |   8 +-
 drivers/hwtracing/intel_th/pci.c                   |  10 ++
 drivers/hwtracing/stm/policy.c                     |   4 +
 drivers/iio/adc/ad7124.c                           |   7 +-
 drivers/iio/adc/ad7606.c                           |   2 +-
 drivers/iio/adc/ad7949.c                           |  49 ++++----
 drivers/iio/humidity/hdc100x.c                     |   2 +-
 drivers/iio/imu/adis16480.c                        |  78 +++++++------
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c         |  23 ++--
 drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h          |  16 ++-
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c       |   9 +-
 drivers/interconnect/qcom/qcs404.c                 |   8 +-
 drivers/interconnect/qcom/sdm845.c                 |   4 +-
 drivers/md/dm-writecache.c                         |   3 +-
 drivers/md/dm-zoned-metadata.c                     |  29 +++--
 drivers/md/dm-zoned-reclaim.c                      |   8 +-
 drivers/md/dm-zoned-target.c                       |  54 ++++++---
 drivers/md/dm-zoned.h                              |   2 +
 drivers/md/md-linear.c                             |   5 +-
 drivers/md/md-multipath.c                          |   5 +-
 drivers/md/md.c                                    |  11 +-
 drivers/md/md.h                                    |   4 +-
 drivers/md/raid0.c                                 |   5 +-
 drivers/md/raid1.c                                 |   5 +-
 drivers/md/raid10.c                                |   5 +-
 drivers/md/raid5.c                                 |   4 +-
 drivers/media/platform/qcom/venus/vdec.c           |   3 -
 drivers/media/platform/qcom/venus/venc.c           |   3 -
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c      |   3 +-
 drivers/media/platform/vimc/vimc-sensor.c          |   5 -
 drivers/media/radio/radio-wl1273.c                 |   3 +-
 drivers/mmc/host/omap_hsmmc.c                      |  30 +++++
 drivers/mtd/devices/spear_smi.c                    |  38 +++++-
 drivers/mtd/nand/raw/nand_base.c                   |   8 +-
 drivers/mtd/nand/raw/nand_micron.c                 |   4 +-
 drivers/net/wireless/ath/ar5523/ar5523.c           |   3 +-
 drivers/net/wireless/ath/wil6210/wmi.c             |   6 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |   2 +
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |  14 +++
 .../net/wireless/realtek/rtlwifi/rtl8192de/hw.c    |   9 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/sw.c    |   1 +
 .../net/wireless/realtek/rtlwifi/rtl8192de/trx.c   |  25 +++-
 .../net/wireless/realtek/rtlwifi/rtl8192de/trx.h   |   2 +
 drivers/net/wireless/virt_wifi.c                   |   4 +-
 drivers/nvme/host/core.c                           |  12 +-
 drivers/pci/hotplug/acpiphp_glue.c                 |  12 +-
 drivers/phy/renesas/phy-rcar-gen3-usb2.c           |   5 +-
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c        |   6 +-
 drivers/pinctrl/pinctrl-rza2.c                     |   4 +-
 drivers/pinctrl/samsung/pinctrl-exynos.c           |  14 ++-
 drivers/pinctrl/samsung/pinctrl-s3c24xx.c          |   6 +-
 drivers/pinctrl/samsung/pinctrl-s3c64xx.c          |   6 +-
 drivers/pinctrl/samsung/pinctrl-samsung.c          |  10 +-
 drivers/rtc/interface.c                            |  19 ++-
 drivers/s390/scsi/zfcp_dbf.c                       |   8 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |  11 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |   5 +-
 drivers/scsi/lpfc/lpfc_sli.h                       |   3 +-
 drivers/scsi/qla2xxx/qla_def.h                     |   6 +-
 drivers/scsi/qla2xxx/qla_gs.c                      |   2 +-
 drivers/scsi/qla2xxx/qla_init.c                    |  31 +++--
 drivers/scsi/qla2xxx/qla_isr.c                     |   5 +
 drivers/scsi/qla2xxx/qla_mbx.c                     |   4 -
 drivers/scsi/qla2xxx/qla_mid.c                     |  11 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |   4 +-
 drivers/scsi/qla2xxx/qla_os.c                      | 127 +++++++++++----------
 drivers/staging/exfat/exfat.h                      |   4 +-
 drivers/staging/exfat/exfat_core.c                 |   4 +-
 drivers/staging/exfat/exfat_super.c                |   4 +-
 drivers/staging/isdn/gigaset/usb-gigaset.c         |  23 +++-
 drivers/staging/media/hantro/hantro_g1_h264_dec.c  |  10 +-
 drivers/staging/media/hantro/hantro_v4l2.c         |  28 +++--
 drivers/staging/rtl8188eu/os_dep/usb_intf.c        |   2 +-
 drivers/staging/rtl8712/usb_intf.c                 |   2 +-
 .../vc04_services/interface/vchiq_arm/vchiq_arm.c  |   2 +-
 drivers/usb/atm/ueagle-atm.c                       |  18 ++-
 drivers/usb/common/usb-conn-gpio.c                 |   3 +-
 drivers/usb/core/hub.c                             |   5 +-
 drivers/usb/core/urb.c                             |   1 +
 drivers/usb/dwc3/dwc3-pci.c                        |   6 +-
 drivers/usb/dwc3/ep0.c                             |   8 ++
 drivers/usb/dwc3/gadget.c                          |   5 +-
 drivers/usb/gadget/configfs.c                      |   1 +
 drivers/usb/gadget/udc/dummy_hcd.c                 |   2 +-
 drivers/usb/gadget/udc/pch_udc.c                   |   1 -
 drivers/usb/host/xhci-hub.c                        |  22 +++-
 drivers/usb/host/xhci-mem.c                        |   4 +
 drivers/usb/host/xhci-pci.c                        |  13 +++
 drivers/usb/host/xhci-ring.c                       |   6 +-
 drivers/usb/host/xhci-tegra.c                      |  25 ++--
 drivers/usb/host/xhci.c                            |   9 +-
 drivers/usb/host/xhci.h                            |   1 +
 drivers/usb/misc/adutux.c                          |   2 +-
 drivers/usb/misc/idmouse.c                         |   2 +-
 drivers/usb/mon/mon_bin.c                          |  32 ++++--
 drivers/usb/roles/class.c                          |   2 +-
 drivers/usb/serial/io_edgeport.c                   |  10 +-
 drivers/usb/storage/uas.c                          |  10 ++
 drivers/usb/typec/class.c                          |   6 +-
 drivers/video/hdmi.c                               |   8 +-
 drivers/virtio/virtio_balloon.c                    |  11 ++
 fs/btrfs/block-group.c                             |   2 +-
 fs/btrfs/delayed-inode.c                           |  13 ++-
 fs/btrfs/extent_io.c                               |  12 +-
 fs/btrfs/file.c                                    |   2 +-
 fs/btrfs/free-space-cache.c                        |   6 +
 fs/btrfs/inode.c                                   |   9 +-
 fs/btrfs/send.c                                    |  25 +++-
 fs/btrfs/volumes.h                                 |   1 -
 fs/ceph/dir.c                                      |   1 +
 fs/ceph/file.c                                     |   2 +-
 fs/erofs/xattr.c                                   |   2 +
 fs/ext2/inode.c                                    |   7 +-
 fs/ext4/ialloc.c                                   |   5 -
 fs/ext4/inode.c                                    |  25 +++-
 fs/ext4/namei.c                                    |  11 +-
 fs/ext4/super.c                                    |   2 +-
 fs/ioctl.c                                         |  35 ++++++
 fs/ocfs2/quota_global.c                            |   2 +-
 fs/overlayfs/dir.c                                 |   2 +-
 fs/overlayfs/inode.c                               |   8 +-
 fs/overlayfs/namei.c                               |   8 ++
 fs/overlayfs/ovl_entry.h                           |   2 +
 fs/overlayfs/super.c                               |  24 ++--
 fs/quota/dquot.c                                   |  11 +-
 fs/reiserfs/inode.c                                |  12 +-
 fs/reiserfs/namei.c                                |   7 +-
 fs/reiserfs/reiserfs.h                             |   2 +
 fs/reiserfs/super.c                                |   2 +
 fs/reiserfs/xattr.c                                |  19 +--
 fs/reiserfs/xattr_acl.c                            |   4 +-
 fs/splice.c                                        |  14 ++-
 include/acpi/acpi_bus.h                            |   6 +-
 include/linux/fs.h                                 |   7 ++
 include/linux/mfd/rk808.h                          |   2 +-
 include/linux/quotaops.h                           |  10 ++
 include/rdma/ib_verbs.h                            |   4 +-
 include/uapi/linux/cec.h                           |   4 +-
 kernel/cgroup/pids.c                               |  11 +-
 kernel/workqueue.c                                 |  37 ++++--
 lib/raid6/unroll.awk                               |   2 +-
 mm/shmem.c                                         |  13 ++-
 mm/slab_common.c                                   |  12 ++
 sound/firewire/fireface/ff-pcm.c                   |   2 +-
 sound/firewire/oxfw/oxfw-pcm.c                     |   2 +-
 sound/pci/hda/patch_realtek.c                      |   8 +-
 sound/soc/codecs/rt5645.c                          |   6 +-
 sound/soc/fsl/fsl_audmix.c                         |   6 +
 sound/soc/fsl/fsl_audmix.h                         |   1 +
 sound/soc/soc-jack.c                               |   3 +-
 tools/perf/tests/backward-ring-buffer.c            |   9 ++
 tools/testing/selftests/seccomp/seccomp_bpf.c      |   3 +-
 201 files changed, 1475 insertions(+), 797 deletions(-)


