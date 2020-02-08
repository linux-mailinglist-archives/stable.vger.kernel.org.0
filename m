Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35E40156722
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbgBHSjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:39:47 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33402 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727473AbgBHS3c (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:32 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrB-0003Zm-J9; Sat, 08 Feb 2020 18:29:29 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrB-000CIP-49; Sat, 08 Feb 2020 18:29:29 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     torvalds@linux-foundation.org, Guenter Roeck <linux@roeck-us.net>,
        akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>
Date:   Sat, 08 Feb 2020 18:18:59 +0000
Message-ID: <lsq.1581185939.857586636@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 000/148] 3.16.82-rc1 review
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 3.16.82 release.
There are 148 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue Feb 11 20:00:00 UTC 2020.
Anything received after that time might be too late.

All the patches have also been committed to the linux-3.16.y-rc branch of
https://git.kernel.org/pub/scm/linux/kernel/git/bwh/linux-stable-rc.git .
A shortlog and diffstat can be found below.

Ben.

-------------

Aaro Koskinen (2):
      net: stmmac: don't stop NAPI processing when dropping a packet
         [07b3975352374c3f5ebb4a42ef0b253fe370542d]
      net: stmmac: use correct DMA buffer size in the RX descriptor
         [583e6361414903c5206258a30e5bd88cb03c0254]

Akinobu Mita (1):
      blk-mq: fix deadlock when reading cpu_list
         [60de074ba1e8f327db19bc33d8530131ac01695d]

Alan Stern (2):
      media: usbvision: Fix invalid accesses after device disconnect
         [c7a191464078262bf799136317c95824e26a222b]
      media: usbvision: Fix races among open, close, and disconnect
         [9e08117c9d4efc1e1bc6fce83dab856d9fd284b6]

Alastair D'Silva (2):
      powerpc: Allow 64bit VDSO __kernel_sync_dicache to work across ranges >4GB
         [f9ec11165301982585e5e5f606739b5bae5331f3]
      powerpc: Allow flush_icache_range to work across ranges >4GB
         [29430fae82073d39b1b881a3cd507416a56a363f]

Aleksandr Yashkin (1):
      pstore/ram: Write new dumps to start of recycled zones
         [9e5f1c19800b808a37fb9815a26d382132c26c3d]

Alex Deucher (1):
      drm/radeon: fix r1xx/r2xx register checker for POT textures
         [008037d4d972c9c47b273e40e52ae34f9d9e33e7]

Alexandru Ardelean (1):
      iio: imu: adis16480: assign bias value only if operation succeeded
         [9b742763d9d4195e823ae6ece760c9ed0500c1dc]

Arnaldo Carvalho de Melo (1):
      perf regs: Make perf_reg_name() return "unknown" instead of NULL
         [5b596e0ff0e1852197d4c82d3314db5e43126bf7]

Arnd Bergmann (3):
      ARM: ux500: remove unused regulator data
         [37dc78d9b17c971479f742d6d08f38d8f2beb688]
      compat_ioctl: handle SIOCOUTQNSD
         [9d7bf41fafa5b5ddd4c13eb39446b0045f0a8167]
      net: davinci_cpdma: use dma_addr_t for DMA address
         [84092996673211f16ef3b942a191d7952e9dfea9]

Asbjoern Sloth Toennesen (1):
      deb-pkg: remove obsolete -isp option to dpkg-gencontrol
         [4204111c028d492019e4440d12e9e3d062db4283]

Bart Van Assche (3):
      RDMA/srpt: Report the SCSI residual to the initiator
         [e88982ad1bb12db699de96fbc07096359ef6176c]
      scsi: core: scsi_trace: Use get_unaligned_be*()
         [b1335f5b0486f61fb66b123b40f8e7a98e49605d]
      scsi: tracing: Fix handling of TRANSFER LENGTH == 0 for READ(6) and WRITE(6)
         [f6b8540f40201bff91062dd64db8e29e4ddaaa9d]

Ben Hutchings (1):
      s390: Fix unmatched preempt_disable() on exit
         [8d9047f8b967ce6181fd824ae922978e1b055cc0]

Chengguang Xu (1):
      ext2: check err when partial != NULL
         [e705f4b8aa27a59f8933e8f384e9752f052c469c]

Chris Wilson (1):
      drm/i915/userptr: Try to acquire the page lock around set_page_dirty()
         [0d4bbe3d407f79438dc4f87943db21f7134cfc65]

Chuhong Yuan (1):
      serial: ifx6x60: add missed pm_runtime_disable
         [50b2b571c5f3df721fc81bf9a12c521dfbe019ba]

Colin Ian King (1):
      ALSA: cs4236: fix error return comparison of an unsigned integer
         [d60229d84846a8399257006af9c5444599f64361]

Dan Carpenter (6):
      Bluetooth: delete a stray unlock
         [df66499a1fab340c167250a5743931dc50d5f0fa]
      [media] usbvision-video: two use after frees
         [470a9147899500eb4898f77816520c4b4aa1a698]
      cw1200: Fix a signedness bug in cw1200_load_firmware()
         [4a50d454502f1401171ff061a5424583f91266db]
      drm/i810: Prevent underflow in ioctl
         [4f69851fbaa26b155330be35ce8ac393e93e7442]
      scsi: csiostor: Don't enable IRQs too early
         [d6c9b31ac3064fbedf8961f120a4c117daa59932]
      scsi: esas2r: unlock on error in esas2r_nvram_read_direct()
         [906ca6353ac09696c1bf0892513c8edffff5e0a6]

Dave Wysochanski (1):
      cifs: Fix cifsInodeInfo lock_sem deadlock when reconnect occurs
         [d46b0da7a33dd8c99d969834f682267a45444ab3]

Denis Efremov (2):
      ar5523: check NULL before memcpy() in ar5523_cmd()
         [315cee426f87658a6799815845788fde965ddaad]
      ath9k_hw: fix uninitialized variable data
         [80e84f36412e0c5172447b6947068dca0d04ee82]

Dmitry Monakhov (2):
      quota: Check that quota is not dirty before release
         [df4bb5d128e2c44848aeb36b7ceceba3ac85080d]
      quota: fix livelock in dquot_writeback_dquots
         [6ff33d99fc5c96797103b48b7b0902c296f09c05]

Dmitry Osipenko (1):
      ARM: tegra: Fix FLOW_CTLR_HALT register clobbering by tegra_resume()
         [d70f7d31a9e2088e8a507194354d41ea10062994]

Dmitry Torokhov (1):
      tty: vt: keyboard: reject invalid keycodes
         [b2b2dd71e0859436d4e05b2f61f86140250ed3f8]

Eric Dumazet (4):
      inet: protect against too small mtu values.
         [501a90c945103e8627406763dac418f20f3837b2]
      inetpeer: fix data-race in inet_putpeer / inet_putpeer
         [71685eb4ce80ae9c49eff82ca4dd15acab215de9]
      tcp: md5: fix potential overestimation of TCP option space
         [9424e2e7ad93ffffa88f882c9bc5023570904b55]
      tcp: syncookies: extend validity range
         [264ea103a7473f51aced838e68ed384ea2c759f5]

Fabio D'Urso (1):
      USB: serial: ftdi_sio: add device IDs for U-Blox C099-F9P
         [c1a1f273d0825774c80896b8deb1c9ea1d0b91e3]

Filipe Manana (1):
      Btrfs: fix negative subv_writers counter and data space leak after buffered write
         [a0e248bb502d5165b3314ac3819e888fdcdf7d9f]

Francesco Ruggeri (1):
      ACPI: OSL: only free map once in osl.c
         [833a426cc471b6088011b3d67f1dc4e147614647]

Giuseppe CAVALLARO (1):
      stmmac: fix oversized frame reception
         [e527c4a769d375ac0472450c52bde29087f49cd9]

Greg Kroah-Hartman (1):
      usb-serial: cp201x: support Mark-10 digital force gauge
         [347bc8cb26388791c5881a3775cb14a3f765a674]

Guillaume Nault (2):
      tcp: Protect accesses to .ts_recent_stamp with {READ,WRITE}_ONCE()
         [721c8dafad26ccfa90ff659ee19755e3377b829d]
      tcp: fix rejected syncookies due to stale timestamps
         [04d26e7b159a396372646a480f4caa166d1b6720]

Gustavo A. R. Silva (1):
      usb: gadget: pch_udc: fix use after free
         [66d1b0c0580b7f1b1850ee4423f32ac42afa2e92]

H.J. Lu (1):
      x86: Treat R_X86_64_PLT32 as R_X86_64_PC32
         [b21ebf2fb4cde1618915a97cc773e287ff49173e]

Hans Verkuil (2):
      [media] usbvision: fix locking error
         [e2c84ccb0fbe5e524d15bb09c042a6ca634adaed]
      [media] usbvision: remove power_on_at_open and timed power off
         [62e259493d779b0e2c1a675ab733136511310821]

Hans de Goede (2):
      platform/x86: hp-wmi: Fix ACPI errors caused by passing 0 as input size
         [f3e4f3fc8ee9729c4b1b27a478c68b713df53c0c]
      platform/x86: hp-wmi: Fix ACPI errors caused by too small buffer
         [16245db1489cd9aa579506f64afeeeb13d825a93]

Hewenliang (1):
      libtraceevent: Fix memory leakage in copy_filter_type
         [10992af6bf46a2048ad964985a5b77464e5563b1]

Insu Yun (1):
      [media] usbvision: fix locking error
         [5ce625a42d6206d5a18222c6475f6b866ef68569]

James Smart (1):
      scsi: lpfc: fix: Coverity: lpfc_cmpl_els_rsp(): Null pointer dereferences
         [6c6d59e0fe5b86cf273d6d744a6a9768c4ecc756]

Jan Kara (2):
      jbd2: Fix possible overflow in jbd2_log_space_left()
         [add3efdd78b8a0478ce423bb9d4df6bd95e8b335]
      xfs: Sanity check flags of Q_XQUOTARM call
         [3dd4d40b420846dd35869ccc8f8627feef2cff32]

Jann Horn (1):
      binder: Handle start==NULL in binder_update_page_range()
         [2a9edd056ed4fbf9d2e797c3fc06335af35bccc4]

Janusz Krzysztofik (2):
      media: ov6650: Fix incorrect use of JPEG colorspace
         [12500731895ef09afc5b66b86b76c0884fb9c7bf]
      media: ov6650: Fix stored frame format not in sync with hardware
         [3143b459de4cdcce67b36827476c966e93c1cf01]

Jeffrey Hugo (1):
      tty: serial: msm_serial: Fix flow control
         [b027ce258369cbfa88401a691c23dad01deb9f9b]

Jian-Hong Pan (1):
      PCI/MSI: Fix incorrect MSI-X masking on resume
         [e045fa29e89383c717e308609edd19d2fd29e1be]

Jiangfeng Xiao (1):
      serial: serial_core: Perform NULL checks for break_ctl ops
         [7d73170e1c282576419f8b50a771f1fcd2b81a94]

Johan Hovold (3):
      USB: serial: mos7720: fix remote wakeup
         [ea422312a462696093b5db59d294439796cba4ad]
      USB: serial: mos7840: fix remote wakeup
         [92fe35fb9c70a00d8fbbf5bd6172c921dd9c7815]
      media: radio: wl1273: fix interrupt masking on release
         [1091eb830627625dcf79958d99353c2391f41708]

Johannes Berg (1):
      iwlwifi: check kasprintf() return value
         [5974fbb5e10b018fdbe3c3b81cb4cc54e1105ab9]

Josef Bacik (1):
      btrfs: check page->mapping when loading free space cache
         [3797136b626ad4b6582223660c041efdea8f26b2]

Kai-Heng Feng (2):
      usb: Allow USB device to be warm reset in suspended state
         [e76b3bf7654c3c94554c24ba15a3d105f4006c80]
      x86/PCI: Avoid AMD FCH XHCI USB PME# from D0 defect
         [7e8ce0e2b036dbc6617184317983aea4f2c52099]

Kars de Jong (1):
      rtc: msm6242: Fix reading of 10-hour digit
         [e34494c8df0cd96fc432efae121db3212c46ae48]

Konstantin Khlebnikov (1):
      ACPI / osl: speedup grace period in acpi_os_map_cleanup
         [74b51ee152b6d99e61ba329799a039453fb9438f]

Krzysztof Kozlowski (2):
      pinctrl: samsung: Fix device node refcount leaks in S3C24xx wakeup controller init
         [6fbbcb050802d6ea109f387e961b1dbcc3a80c96]
      pinctrl: samsung: Fix device node refcount leaks in S3C64xx wakeup controller init
         [7f028caadf6c37580d0f59c6c094ed09afc04062]

Leonard Crestez (1):
      PM / devfreq: Lock devfreq in trans_stat_show
         [2abb0d5268ae7b5ddf82099b1f8d5aa8414637d4]

Lihua Yao (1):
      ARM: dts: s3c64xx: Fix init order of clock providers
         [d60d0cff4ab01255b25375425745c3cff69558ad]

Mans Rullgard (1):
      spi: atmel: fix handling of cs_change set on non-last xfer
         [fed8d8c7a6dc2a76d7764842853d81c770b0788e]

Marian Mihailescu (1):
      clk: samsung: exynos5420: Preserve CPU clocks configuration during suspend/resume
         [e21be0d1d7bd7f78a77613f6bcb6965e72b22fc1]

Mark Brown (1):
      mmc: sdhci-s3c: Check if clk_set_rate() succeeds
         [cd0cfdd2485e6252b3c69284bf09d06c4d303116]

Masami Hiramatsu (15):
      perf probe: Filter out instances except for inlined subroutine and subprogram
         [da6cb952a89efe24bb76c4971370d485737a2d85]
      perf probe: Fix to add missed brace around if block
         [86a76027457633488b0a83d5e2bb944159885605]
      perf probe: Fix to find range-only function instance
         [b77afa1f810f37bd8a36cb1318178dfe2d7af6b6]
      perf probe: Fix to handle optimized not-inlined functions
         [e1ecbbc3fa834cc6b4b344edb1968e734d57189b]
      perf probe: Fix to list probe event with correct line number
         [3895534dd78f0fd4d3f9e05ee52b9cdd444a743e]
      perf probe: Fix to probe a function which has no entry pc
         [5d16dbcc311d91267ddb45c6da4f187be320ecee]
      perf probe: Fix to probe an inline function which has no entry pc
         [eb6933b29d20bf2c3053883d409a53f462c1a3ac]
      perf probe: Fix to show calling lines of inlined functions
         [86c0bf8539e7f46d91bd105e55eda96e0064caef]
      perf probe: Fix to show function entry line as probe-able
         [91e2f539eeda26ab00bd03fae8dc434c128c85ed]
      perf probe: Fix to show inlined function callsite without entry_pc
         [18e21eb671dc87a4f0546ba505a89ea93598a634]
      perf probe: Fix to show lines of sys_ functions correctly
         [75186a9b09e47072f442f43e292cd47180b67b5c]
      perf probe: Fix wrong address verification
         [07d369857808b7e8e471bbbbb0074a6718f89b31]
      perf probe: Skip end-of-sequence and non statement lines
         [f4d99bdfd124823a81878b44b5e8750b97f73902]
      perf probe: Skip if the function address is 0
         [0ad45b33c58dca60dec7e1fb44766753bc4a7a38]
      perf probe: Skip overlapped location on searching variables
         [dee36a2abb67c175265d49b9a8c7dfa564463d9a]

Mattijs Korpershoek (1):
      Bluetooth: hci_core: fix init for HCI_USER_CHANNEL
         [eb8c101e28496888a0dcfe16ab86a1bee369e820]

Max Filippov (1):
      xtensa: fix TLB sanity checker
         [36de10c4788efc6efe6ff9aa10d38cb7eea4c818]

Menglong Dong (1):
      macvlan: schedule bc_work even if error
         [1d7ea55668878bb350979c377fc72509dd6f5b21]

Michał Mirosław (1):
      usb: gadget: u_serial: add missing port entry locking
         [daf82bd24e308c5a83758047aff1bd81edda4f11]

Miklos Szeredi (2):
      fuse: verify attributes
         [eb59bd17d2fa6e5e84fba61a5ebdea984222e6d5]
      fuse: verify nlink
         [c634da718db9b2fac201df2ae1b1b095344ce5eb]

Ming Lei (2):
      blk-mq: avoid sysfs buffer overflow with too many CPU cores
         [8962842ca5abdcf98e22ab3b2b45a103f0408b95]
      blk-mq: make sure that line break can be printed
         [d2c9be89f8ebe7ebcc97676ac40f8dec1cf9b43a]

Miquel Raynal (1):
      mtd: spear_smi: Fix Write Burst mode
         [69c7f4618c16b4678f8a4949b6bb5ace259c0033]

Nathan Chancellor (1):
      tools/power/cpupower: Fix initializer override in hsw_ext_cstates
         [7e5705c635ecfccde559ebbbe1eaf05b5cc60529]

Nikolay Aleksandrov (1):
      net: bridge: deny dev_set_mac_address() when unregistering
         [c4b4c421857dc7b1cf0dccbd738472360ff2cd70]

Nuno Sá (1):
      iio: adis16480: Add debugfs_reg_access entry
         [4c35b7a51e2f291471f7221d112c6a45c63e83bc]

Oliver Neukum (4):
      USB: documentation: flags on usb-storage versus UAS
         [65cc8bf99349f651a0a2cee69333525fe581f306]
      USB: uas: heed CAPACITY_HEURISTICS
         [335cbbd5762d5e5c67a8ddd6e6362c2aa42a328f]
      USB: uas: honor flag to avoid CAPACITY16
         [bff000cae1eec750d62e265c4ba2db9af57b17e1]
      appledisplay: fix error handling in the scheduled work
         [91feb01596e5efc0cc922cc73f5583114dccf4d2]

Pan Bian (3):
      scsi: bnx2i: fix potential use after free
         [29d28f2b8d3736ac61c28ef7e20fda63795b74d9]
      scsi: qla4xxx: fix double free bug
         [3fe3d2428b62822b7b030577cd612790bdd8c941]
      staging: rtl8192e: fix potential use after free
         [b7aa39a2ed0112d07fc277ebd24a08a7b2368ab9]

Paolo Abeni (2):
      openvswitch: drop unneeded BUG_ON() in ovs_flow_cmd_build_info()
         [8ffeb03fbba3b599690b361467bfd2373e8c450f]
      openvswitch: remove another BUG_ON()
         [8a574f86652a4540a2433946ba826ccb87f398cc]

Paolo Bonzini (2):
      KVM: x86: do not modify masked bits of shared MSRs
         [de1fca5d6e0105c9d33924e1247e2f386efc3ece]
      KVM: x86: fix presentation of TSX feature in ARCH_CAPABILITIES
         [cbbaa2727aa3ae9e0a844803da7cef7fd3b94f2b]

Paul Osmialowski (1):
      mmc: sdhci-s3c: solve problem with sleeping in atomic context
         [017210d1c0dc2e2d3b142985cb31d90b98dc0f0f]

Pavel Löbl (1):
      USB: serial: mos7840: add USB ID to support Moxa UPort 2210
         [e696d00e65e81d46e911f24b12e441037bf11b38]

Pavel Shilovsky (3):
      CIFS: Fix NULL-pointer dereference in smb2_push_mandatory_locks
         [6f582b273ec23332074d970a7fb25bef835df71f]
      CIFS: Fix SMB2 oplock break processing
         [fa9c2362497fbd64788063288dc4e74daf977ebb]
      CIFS: Respect O_SYNC and O_DIRECT flags during reconnect
         [44805b0e62f15e90d233485420e1847133716bdc]

Pavel Tikhomirov (1):
      sunrpc: fix crash when cache_head become valid before update
         [5fcaf6982d1167f1cd9b264704f6d1ef4c505d54]

Pawel Harlozinski (1):
      ASoC: Jack: Fix NULL pointer dereference in snd_soc_jack_report
         [8f157d4ff039e03e2ed4cb602eeed2fd4687a58f]

Peng Fan (2):
      tty: serial: imx: use the sg count from dma_map_sg
         [596fd8dffb745afcebc0ec6968e17fe29f02044c]
      tty: serial: pch_uart: correct usage of dma_unmap_sg
         [74887542fdcc92ad06a48c0cca17cdf09fc8aa00]

Sam Bobroff (1):
      drm/radeon: fix bad DMA from INTERRUPT_CNTL2
         [62d91dd2851e8ae2ca552f1b090a3575a4edf759]

SeongJae Park (1):
      xen/blkback: Avoid unmapping unmapped grant pages
         [f9bd84a8a845d82f9b5a081a7ae68c98a11d2e84]

Seung-Woo Kim (1):
      media: exynos4-is: Fix recursive locking in isp_video_release()
         [704c6c80fb471d1bb0ef0d61a94617d1d55743cd]

Steffen Liebergeld (1):
      PCI: Fix Intel ACS quirk UPDCR register address
         [d8558ac8c93d429d65d7490b512a3a67e559d0d4]

Steffen Maier (1):
      scsi: zfcp: trace channel log even for FCP command responses
         [100843f176109af94600e500da0428e21030ca7f]

Stephan Gerhold (2):
      regulator: ab8500: Remove AB8505 USB regulator
         [99c4f70df3a6446c56ca817c2d0f9c12d85d4e7c]
      regulator: ab8500: Remove SYSCLKREQ from enum ab8505_regulator_id
         [458ea3ad033fc86e291712ce50cbe60c3428cf30]

Sudarsana Reddy Kalluru (1):
      bnx2x: Enable Multi-Cos feature.
         [069e47823fff2c634b2d46a328b5096fdc8c2a0c]

Takashi Iwai (3):
      ALSA: line6: Drop superfluous snd_device for PCM
         [b45a7c565473d29bd7e02ac8ca86232a24ca247f]
      ALSA: line6: Fix memory leak at line6_init_pcm() error path
         [1bc8d18c75fef3b478dbdfef722aae09e2a9fde7]
      ALSA: pcm: oss: Avoid potential buffer overflows
         [4cc8d6505ab82db3357613d36e6c58a297f57f7c]

Tejun Heo (1):
      workqueue: Fix spurious sanity check failures in destroy_workqueue()
         [def98c84b6cdf2eeea19ec5736e90e316df5206b]

Theodore Ts'o (1):
      ext4: work around deleting a file with i_nlink == 0 safely
         [c7df4a1ecb8579838ec8c56b2bb6a6716e974f37]

Thomas Gleixner (2):
      hrtimer: Get rid of the resolution field in hrtimer_clock_base
         [398ca17fb54b212cdc9da7ff4a17a35c48dd2103]
      x86/ioapic: Prevent inconsistent state when moving an interrupt
         [df4393424af3fbdcd5c404077176082a8ce459c4]

Tony Lindgren (1):
      hwrng: omap3-rom - Call clk_disable_unprepare() on exit only if not idled
         [eaecce12f5f0d2c35d278e41e1bc4522393861ab]

Vamshi K Sthambamkadi (1):
      ACPI: bus: Fix NULL pointer check in acpi_bus_get_private_data()
         [627ead724eff33673597216f5020b72118827de4]

Vincenzo Frascino (1):
      powerpc: Fix vDSO clock_getres()
         [552263456215ada7ee8700ce022d12b0cffe4802]

Waiman Long (1):
      x86/speculation: Fix incorrect MDS/TAA mitigation status
         [64870ed1b12e235cfca3f6c6da75b542c973ff78]

Yang Tao (1):
      futex: Prevent robust futex exit race
         [ca16d5bee59807bf04deaab0a8eccecd5061528c]

Zhenzhong Duan (1):
      cpuidle: Do not unset the driver if it is there already
         [918c1fe9fbbe46fcf56837ff21f0ef96424e8b29]

 Documentation/hw-vuln/mds.rst                      |   7 +-
 Documentation/hw-vuln/tsx_async_abort.rst          |   5 +-
 Documentation/kernel-parameters.txt                |  30 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/s3c6410-mini6410.dts             |   4 +
 arch/arm/boot/dts/s3c6410-smdk6410.dts             |   4 +
 arch/arm/mach-tegra/reset-handler.S                |   6 +-
 arch/arm/mach-ux500/board-mop500-regulators.c      | 600 ---------------------
 arch/arm/mach-ux500/board-mop500-regulators.h      |   8 -
 arch/powerpc/include/asm/vdso_datapage.h           |   2 +
 arch/powerpc/kernel/asm-offsets.c                  |   2 +-
 arch/powerpc/kernel/misc_64.S                      |   4 +-
 arch/powerpc/kernel/time.c                         |   1 +
 arch/powerpc/kernel/vdso32/gettimeofday.S          |   7 +-
 arch/powerpc/kernel/vdso64/cacheflush.S            |   4 +-
 arch/powerpc/kernel/vdso64/gettimeofday.S          |   7 +-
 arch/s390/kernel/runtime_instr.c                   |   2 +-
 arch/x86/kernel/apic/io_apic.c                     |   9 +-
 arch/x86/kernel/cpu/bugs.c                         |  17 +-
 arch/x86/kernel/module.c                           |   1 +
 arch/x86/kvm/x86.c                                 |  14 +-
 arch/x86/pci/fixup.c                               |  11 +
 arch/x86/tools/relocs.c                            |   1 +
 arch/xtensa/mm/tlb.c                               |   4 +-
 block/blk-mq-sysfs.c                               |  19 +-
 block/blk-mq.c                                     |   7 +
 drivers/acpi/bus.c                                 |   2 +-
 drivers/acpi/osl.c                                 |  28 +-
 drivers/block/xen-blkback/blkback.c                |   2 +
 drivers/char/hw_random/omap3-rom-rng.c             |   3 +-
 drivers/clk/samsung/clk-exynos5420.c               |   2 +
 drivers/cpuidle/driver.c                           |  15 +-
 drivers/devfreq/devfreq.c                          |   7 +-
 drivers/gpu/drm/i810/i810_dma.c                    |   4 +-
 drivers/gpu/drm/i915/i915_gem_userptr.c            |  22 +-
 drivers/gpu/drm/radeon/cik.c                       |   4 +-
 drivers/gpu/drm/radeon/r100.c                      |   4 +-
 drivers/gpu/drm/radeon/r200.c                      |   4 +-
 drivers/gpu/drm/radeon/r600.c                      |   4 +-
 drivers/gpu/drm/radeon/si.c                        |   4 +-
 drivers/iio/imu/adis16480.c                        |   7 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |  24 +
 drivers/media/i2c/soc_camera/ov6650.c              |  21 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |   2 +-
 drivers/media/radio/radio-wl1273.c                 |   3 +-
 drivers/media/usb/usbvision/usbvision-core.c       |  50 --
 drivers/media/usb/usbvision/usbvision-video.c      | 107 ++--
 drivers/media/usb/usbvision/usbvision.h            |   5 -
 drivers/mmc/host/sdhci-s3c.c                       |  16 +-
 drivers/mtd/devices/spear_smi.c                    |  38 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |   3 +-
 drivers/net/ethernet/stmicro/stmmac/common.h       |   2 +-
 drivers/net/ethernet/stmicro/stmmac/descs_com.h    |  14 +-
 drivers/net/ethernet/stmicro/stmmac/enh_desc.c     |  10 +-
 drivers/net/ethernet/stmicro/stmmac/norm_desc.c    |  10 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  20 +-
 drivers/net/ethernet/ti/davinci_cpdma.c            |  12 +-
 drivers/net/macvlan.c                              |   3 +-
 drivers/net/wireless/ath/ar5523/ar5523.c           |   3 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |   2 +-
 drivers/net/wireless/cw1200/fwio.c                 |   6 +-
 drivers/net/wireless/iwlwifi/dvm/led.c             |   3 +
 drivers/net/wireless/iwlwifi/mvm/led.c             |   3 +
 drivers/pci/msi.c                                  |   3 +-
 drivers/pci/quirks.c                               |   2 +-
 drivers/pinctrl/pinctrl-s3c24xx.c                  |   6 +-
 drivers/pinctrl/pinctrl-s3c64xx.c                  |   3 +
 drivers/platform/x86/hp-wmi.c                      |  10 +-
 drivers/regulator/ab8500.c                         |  17 -
 drivers/rtc/rtc-msm6242.c                          |   3 +-
 drivers/s390/scsi/zfcp_dbf.c                       |   8 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c                   |   2 +-
 drivers/scsi/csiostor/csio_lnode.c                 |  15 +-
 drivers/scsi/esas2r/esas2r_flash.c                 |   1 +
 drivers/scsi/lpfc/lpfc_els.c                       |   2 +-
 drivers/scsi/qla4xxx/ql4_mbx.c                     |   3 -
 drivers/scsi/scsi_trace.c                          | 125 ++---
 drivers/spi/spi-atmel.c                            |  10 +-
 drivers/staging/android/binder.c                   |   6 +-
 drivers/staging/line6/pcm.c                        |  61 +--
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c       |   5 +-
 drivers/tty/serial/ifx6x60.c                       |   3 +
 drivers/tty/serial/imx.c                           |   2 +-
 drivers/tty/serial/msm_serial.c                    |   6 +-
 drivers/tty/serial/pch_uart.c                      |   5 +-
 drivers/tty/serial/serial_core.c                   |   2 +-
 drivers/tty/vt/keyboard.c                          |   2 +-
 drivers/usb/core/hub.c                             |   5 +-
 drivers/usb/gadget/pch_udc.c                       |   1 -
 drivers/usb/gadget/u_serial.c                      |   2 +
 drivers/usb/misc/appledisplay.c                    |   8 +-
 drivers/usb/serial/cp210x.c                        |   1 +
 drivers/usb/serial/ftdi_sio.c                      |   3 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   7 +
 drivers/usb/serial/mos7720.c                       |   4 -
 drivers/usb/serial/mos7840.c                       |  16 +-
 drivers/usb/storage/uas.c                          |  10 +
 fs/btrfs/file.c                                    |   2 +-
 fs/btrfs/free-space-cache.c                        |   6 +
 fs/cifs/cifsglob.h                                 |   5 +
 fs/cifs/cifsproto.h                                |   1 +
 fs/cifs/file.c                                     |  35 +-
 fs/cifs/smb2file.c                                 |   2 +-
 fs/cifs/smb2misc.c                                 |   7 +-
 fs/ext2/inode.c                                    |   7 +-
 fs/ext4/namei.c                                    |  13 +-
 fs/fuse/dir.c                                      |  27 +-
 fs/fuse/fuse_i.h                                   |   2 +
 fs/ocfs2/quota_global.c                            |   2 +-
 fs/pstore/ram.c                                    |  11 +
 fs/quota/dquot.c                                   |  11 +-
 fs/xfs/xfs_quotaops.c                              |   3 +
 include/linux/futex.h                              |   7 +-
 include/linux/hrtimer.h                            |   6 +-
 include/linux/jbd2.h                               |   4 +-
 include/linux/netdevice.h                          |   5 +
 include/linux/quotaops.h                           |  10 +
 include/linux/regulator/ab8500.h                   |   3 -
 include/linux/time.h                               |  12 +
 include/net/ip.h                                   |   5 +
 include/net/tcp.h                                  |  38 +-
 kernel/futex.c                                     |  49 +-
 kernel/futex_compat.c                              |   5 +-
 kernel/hrtimer.c                                   |  26 +-
 kernel/time/timer_list.c                           |   8 +-
 kernel/workqueue.c                                 |  28 +-
 net/bluetooth/hci_core.c                           |  11 +-
 net/bluetooth/l2cap_core.c                         |   4 +-
 net/bridge/br_device.c                             |   6 +
 net/core/dev.c                                     |   3 +-
 net/ipv4/devinet.c                                 |   5 -
 net/ipv4/inetpeer.c                                |  12 +-
 net/ipv4/ip_output.c                               |  14 +-
 net/ipv4/tcp_output.c                              |   5 +-
 net/openvswitch/datapath.c                         |  11 +-
 net/socket.c                                       |   1 +
 net/sunrpc/cache.c                                 |   5 -
 scripts/package/builddeb                           |   2 +-
 sound/core/oss/linear.c                            |   2 +
 sound/core/oss/mulaw.c                             |   2 +
 sound/core/oss/route.c                             |   2 +
 sound/isa/cs423x/cs4236.c                          |   3 +-
 sound/soc/soc-jack.c                               |   3 +-
 tools/lib/traceevent/parse-filter.c                |   9 +-
 tools/perf/util/dwarf-aux.c                        |  88 ++-
 tools/perf/util/dwarf-aux.h                        |   6 +
 tools/perf/util/perf_regs.h                        |   2 +-
 tools/perf/util/probe-finder.c                     |  70 ++-
 .../cpupower/utils/idle_monitor/hsw_ext_idle.c     |   1 -
 149 files changed, 988 insertions(+), 1227 deletions(-)

-- 
Ben Hutchings
It's easier to fight for one's principles than to live up to them.

