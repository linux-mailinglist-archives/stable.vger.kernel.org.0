Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0AF26BB05E
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbjCOMRr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbjCOMRm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:17:42 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F669008B;
        Wed, 15 Mar 2023 05:17:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5484ACE1986;
        Wed, 15 Mar 2023 12:17:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E8DC433D2;
        Wed, 15 Mar 2023 12:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882643;
        bh=cE/IufYtRz6ELTGTxLKZju/AH5kL6rLLTCzSV8arzB0=;
        h=From:To:Cc:Subject:Date:From;
        b=R62B1Zg82uQdzVFvot5DXoEMtwT/egbo9ORrPHqQYrctjGOn2gYIzKGS4a4mzW9Gc
         1YDuam5EMfnvyIGntMXADgZveYnO0b342eNfA4dmurLjY/rQaxbXzlfiUAOJbEPd/6
         WFnv/z8e4aKgl4AEqoUQmc8jeTeoBbS92vJ7hxl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.4 00/68] 5.4.237-rc1 review
Date:   Wed, 15 Mar 2023 13:11:54 +0100
Message-Id: <20230315115726.103942885@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.237-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.237-rc1
X-KernelTest-Deadline: 2023-03-17T11:57+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.237 release.
There are 68 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.237-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.237-rc1

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: add missing discipline function

Masahiro Yamada <masahiroy@kernel.org>
    UML: define RUNTIME_DISCARD_EXIT

Tom Saeger <tom.saeger@oracle.com>
    sh: define RUNTIME_DISCARD_EXIT

Masahiro Yamada <masahiroy@kernel.org>
    s390: define RUNTIME_DISCARD_EXIT to fix link error with GNU ld < 2.36

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/vmlinux.lds: Don't discard .rela* for relocatable builds

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT

Masahiro Yamada <masahiroy@kernel.org>
    arch: fix broken BuildID for arm64 and riscv

H.J. Lu <hjl.tools@gmail.com>
    x86, vmlinux.lds: Add RUNTIME_DISCARD_EXIT to generic DISCARDS

John Harrison <John.C.Harrison@Intel.com>
    drm/i915: Don't use BAR mappings for ring buffers with LLC

Corey Minyard <cminyard@mvista.com>
    ipmi:watchdog: Set panic count to proper value on a panic

Yejune Deng <yejune.deng@gmail.com>
    ipmi/watchdog: replace atomic_add() and atomic_sub()

Paul Elder <paul.elder@ideasonboard.com>
    media: ov5640: Fix analogue gain control

Alvaro Karsz <alvaro.karsz@solid-run.com>
    PCI: Avoid FLR for SolidRun SNET DPU rev 1

Alvaro Karsz <alvaro.karsz@solid-run.com>
    PCI: Add SolidRun vendor ID

Nathan Chancellor <nathan@kernel.org>
    macintosh: windfarm: Use unsigned type for 1-bit bitfields

Edward Humes <aurxenon@lunos.org>
    alpha: fix R_ALPHA_LITERAL reloc for large modules

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc: Check !irq instead of irq == NO_IRQ and remove NO_IRQ

xurui <xurui@kylinos.cn>
    MIPS: Fix a compilation issue

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: mmcc-apq8084: remove spdm clocks

Jan Kara <jack@suse.cz>
    ext4: Fix deadlock during directory rename

Alexandre Ghiti <alexghiti@rivosinc.com>
    riscv: Use READ_ONCE_NOCHECK in imprecise unwinding stack mode

D. Wythe <alibuda@linux.alibaba.com>
    net/smc: fix fallback failed while sendmsg with fastopen

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: megaraid_sas: Update max supported LD IDs to 240

Lorenz Bauer <lorenz.bauer@isovalent.com>
    btf: fix resolving BTF_KIND_VAR after ARRAY, STRUCT, UNION, PTR

Florian Westphal <fw@strlen.de>
    netfilter: tproxy: fix deadlock due to missing BH disable

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Avoid order-5 memory allocation for TPA data

Shigeru Yoshida <syoshida@redhat.com>
    net: caif: Fix use-after-free in cfusbl_device_notify()

Yuiko Oshino <yuiko.oshino@microchip.com>
    net: lan78xx: fix accessing the LAN7800's internal phy specific registers from the MAC driver

Lee Jones <lee.jones@linaro.org>
    net: usb: lan78xx: Remove lots of set but unused 'ret' variables

Hangbin Liu <liuhangbin@gmail.com>
    selftests: nft_nat: ensuring the listening side is up before starting the client

Eric Dumazet <edumazet@google.com>
    ila: do not generate empty messages in ila_xlat_nl_cmd_get_mapping()

Kang Chen <void0red@gmail.com>
    nfc: fdp: add null check of devm_kmalloc_array in fdp_nci_i2c_read_device_properties

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/a5xx: fix setting of the CP_PREEMPT_ENABLE_LOCAL register

Jan Kara <jack@suse.cz>
    ext4: Fix possible corruption when moving a directory

Bart Van Assche <bvanassche@acm.org>
    scsi: core: Remove the /proc/scsi/${proc_name} directory earlier

Volker Lendecke <vl@samba.org>
    cifs: Fix uninitialized memory read in smb3_qfs_tcon()

Amir Goldstein <amir73il@gmail.com>
    SMB3: Backup intent flag missing from some more ops

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: exynos: correct TMU phandle in Odroid XU3 family

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: exynos: correct TMU phandle in Odroid HC1

Marek Szyprowski <m.szyprowski@samsung.com>
    ARM: dts: exynos: Add GPU thermal zone cooling maps for Odroid XU3/XU4/HC1

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: exynos: correct TMU phandle in Exynos5250

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: Override thermal by label in Exynos5250

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: exynos: correct TMU phandle in Exynos4210

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: Override thermal by label in Exynos4210

Jacob Pan <jacob.jun.pan@linux.intel.com>
    iommu/vt-d: Fix PASID directory pointer coherency

Marc Zyngier <maz@kernel.org>
    irqdomain: Fix domain registration race

Bixuan Cui <cuibixuan@huawei.com>
    irqdomain: Change the type of 'size' in __irq_domain_add() to be consistent

Corey Minyard <cminyard@mvista.com>
    ipmi:ssif: Add a timer between request retries

Corey Minyard <cminyard@mvista.com>
    ipmi:ssif: Increase the message retry time

Corey Minyard <cminyard@mvista.com>
    ipmi:ssif: Remove rtc_us_timer

Corey Minyard <cminyard@mvista.com>
    ipmi:ssif: resend_msg() cannot fail

Liguang Zhang <zhangliguang@linux.alibaba.com>
    ipmi:ssif: make ssif_i2c_send() void

Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
    iommu/amd: Add a length limitation for the ivrs_acpihid command-line parameter

Kim Phillips <kim.phillips@amd.com>
    iommu/amd: Fix ill-formed ivrs_ioapic, ivrs_hpet and ivrs_acpihid options

Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    iommu/amd: Add PCI segment support for ivrs_[ioapic/hpet/acpihid] commands

Jani Nikula <jani.nikula@intel.com>
    drm/edid: fix AVI infoframe aspect ratio handling

Wayne Lin <Wayne.Lin@amd.com>
    drm/edid: Add aspect ratios to HDMI 4K modes

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/edid: Fix HDMI VIC handling

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/edid: Extract drm_mode_cea_vic()

Fedor Pchelkin <pchelkin@ispras.ru>
    nfc: change order inside nfc_se_io error path

Zhihao Cheng <chengzhihao1@huawei.com>
    ext4: zero i_disksize when initializing the bootloader inode

Ye Bin <yebin10@huawei.com>
    ext4: fix WARNING in ext4_update_inline_data

Ye Bin <yebin10@huawei.com>
    ext4: move where set the MAY_INLINE_DATA flag is set

Darrick J. Wong <djwong@kernel.org>
    ext4: fix another off-by-one fsmap error on 1k block filesystems

Eric Whitney <enwlinux@gmail.com>
    ext4: fix RENAME_WHITEOUT handling for inline directories

Harry Wentland <harry.wentland@amd.com>
    drm/connector: print max_requested_bpc in state debugfs

Andrew Cooper <andrew.cooper3@citrix.com>
    x86/CPU/AMD: Disable XSAVES on AMD family 0x17

Theodore Ts'o <tytso@mit.edu>
    fs: prevent out-of-bounds array speculation when closing a file descriptor


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |  51 +++-
 Makefile                                           |   4 +-
 arch/alpha/kernel/module.c                         |   4 +-
 arch/arm/boot/dts/exynos4210.dtsi                  |  35 ++-
 arch/arm/boot/dts/exynos5250.dtsi                  |  38 ++-
 arch/arm/boot/dts/exynos5422-odroidhc1.dts         |  38 ++-
 arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi |  67 ++++-
 arch/mips/include/asm/mach-rc32434/pci.h           |   2 +-
 arch/powerpc/include/asm/irq.h                     |   3 -
 arch/powerpc/kernel/vmlinux.lds.S                  |   6 +-
 arch/powerpc/platforms/44x/fsp2.c                  |   2 +-
 arch/riscv/kernel/stacktrace.c                     |   2 +-
 arch/s390/kernel/vmlinux.lds.S                     |   2 +
 arch/sh/kernel/vmlinux.lds.S                       |   1 +
 arch/um/kernel/vmlinux.lds.S                       |   2 +-
 arch/x86/kernel/cpu/amd.c                          |   9 +
 arch/x86/kernel/vmlinux.lds.S                      |   2 +
 drivers/char/ipmi/ipmi_ssif.c                      | 146 ++++-------
 drivers/char/ipmi/ipmi_watchdog.c                  |   8 +-
 drivers/clk/qcom/mmcc-apq8084.c                    | 271 ---------------------
 drivers/gpu/drm/drm_atomic.c                       |   1 +
 drivers/gpu/drm/drm_edid.c                         | 130 ++++++----
 drivers/gpu/drm/i915/gt/intel_ringbuffer.c         |   4 +-
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c              |   4 +-
 drivers/iommu/amd_iommu_init.c                     | 105 ++++++--
 drivers/iommu/intel-pasid.c                        |   7 +
 drivers/macintosh/windfarm_lm75_sensor.c           |   4 +-
 drivers/macintosh/windfarm_smu_sensors.c           |   4 +-
 drivers/media/i2c/ov5640.c                         |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  23 +-
 drivers/net/phy/microchip.c                        |  32 +++
 drivers/net/usb/lan78xx.c                          | 189 ++++++--------
 drivers/nfc/fdp/i2c.c                              |   4 +
 drivers/pci/quirks.c                               |   8 +
 drivers/s390/block/dasd_diag.c                     |   7 +-
 drivers/s390/block/dasd_fba.c                      |   7 +-
 drivers/s390/block/dasd_int.h                      |   1 -
 drivers/scsi/hosts.c                               |   2 +
 drivers/scsi/megaraid/megaraid_sas.h               |   2 +
 drivers/scsi/megaraid/megaraid_sas_fp.c            |   2 +-
 fs/cifs/cifsacl.c                                  |  14 +-
 fs/cifs/cifsfs.c                                   |   2 +-
 fs/cifs/cifsglob.h                                 |   6 +-
 fs/cifs/cifsproto.h                                |   8 +
 fs/cifs/connect.c                                  |   2 +-
 fs/cifs/dir.c                                      |   5 +-
 fs/cifs/file.c                                     |  10 +-
 fs/cifs/inode.c                                    |   8 +-
 fs/cifs/ioctl.c                                    |   2 +-
 fs/cifs/link.c                                     |  18 +-
 fs/cifs/smb1ops.c                                  |  19 +-
 fs/cifs/smb2inode.c                                |   9 +-
 fs/cifs/smb2ops.c                                  |  92 +++----
 fs/cifs/smb2proto.h                                |   2 +-
 fs/ext4/fsmap.c                                    |   2 +
 fs/ext4/inline.c                                   |   1 -
 fs/ext4/inode.c                                    |   7 +-
 fs/ext4/ioctl.c                                    |   1 +
 fs/ext4/namei.c                                    |  36 ++-
 fs/ext4/xattr.c                                    |   3 +
 fs/file.c                                          |   1 +
 include/asm-generic/vmlinux.lds.h                  |  16 +-
 include/linux/irqdomain.h                          |   2 +-
 include/linux/pci_ids.h                            |   2 +
 include/net/netfilter/nf_tproxy.h                  |   7 +
 kernel/bpf/btf.c                                   |   1 +
 kernel/irq/irqdomain.c                             |  62 +++--
 net/caif/caif_usb.c                                |   3 +
 net/ipv4/netfilter/nf_tproxy_ipv4.c                |   2 +-
 net/ipv6/ila/ila_xlat.c                            |   1 +
 net/ipv6/netfilter/nf_tproxy_ipv6.c                |   2 +-
 net/nfc/netlink.c                                  |   2 +-
 net/smc/af_smc.c                                   |  13 +-
 tools/testing/selftests/netfilter/nft_nat.sh       |   2 +
 74 files changed, 783 insertions(+), 811 deletions(-)


