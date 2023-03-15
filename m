Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59EF46BB031
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbjCOMQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbjCOMQE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:16:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED14D8ABD5;
        Wed, 15 Mar 2023 05:16:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59FC0B81DF8;
        Wed, 15 Mar 2023 12:16:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F9DC433D2;
        Wed, 15 Mar 2023 12:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882559;
        bh=isJiHw7P+624z2y7JAVlWit9O/egsbTFuB99+7S24Ek=;
        h=From:To:Cc:Subject:Date:From;
        b=Mq2P+yo13g42fAPxqnyeBZVoXqQi3WCvfB/hh00Vh9O/HpJ9FwipRgASE6oXtPdug
         gxySPetjHaYXmjjSQMtssKjAvddtRhCJIMxBQelby5vuDDFlLFVLnas+/8DAZugRO5
         B5lJITFbc43fi0dpPcpgWoFN5EsCJ+NWeQEp15Vg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 4.19 00/39] 4.19.278-rc1 review
Date:   Wed, 15 Mar 2023 13:12:14 +0100
Message-Id: <20230315115721.234756306@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.278-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.278-rc1
X-KernelTest-Deadline: 2023-03-17T11:57+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.278 release.
There are 39 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.278-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.278-rc1

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    cgroup: Add missing cpus_read_lock() to cgroup_attach_task_all()

Tejun Heo <tj@kernel.org>
    cgroup: Fix threadgroup_rwsem <-> cpus_read_lock() deadlock

Juri Lelli <juri.lelli@redhat.com>
    cgroup/cpuset: Change cpuset_rwsem and hotplug lock order

John Harrison <John.C.Harrison@Intel.com>
    drm/i915: Don't use BAR mappings for ring buffers with LLC

Tung Nguyen <tung.q.nguyen@dektech.com.au>
    tipc: improve function tipc_wait_for_cond()

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

xurui <xurui@kylinos.cn>
    MIPS: Fix a compilation issue

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: mmcc-apq8084: remove spdm clocks

Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
    Revert "spi: mt7621: Fix an error message in mt7621_spi_probe()"

Bart Van Assche <bvanassche@acm.org>
    scsi: core: Remove the /proc/scsi/${proc_name} directory earlier

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: exynos: correct TMU phandle in Odroid XU3 family

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: exynos: correct TMU phandle in Odroid HC1

Marek Szyprowski <m.szyprowski@samsung.com>
    ARM: dts: exynos: Add GPU thermal zone cooling maps for Odroid XU3/XU4/HC1

Masahiro Yamada <yamada.masahiro@socionext.com>
    kbuild: generate modules.order only in directories visited by obj-y/m

Masahiro Yamada <yamada.masahiro@socionext.com>
    kbuild: fix false-positive need-builtin calculation

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: exynos: correct TMU phandle in Exynos5250

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: Override thermal by label in Exynos5250

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: Move pmu and timer nodes out of soc

Viresh Kumar <viresh.kumar@linaro.org>
    ARM: dts: exynos: Add all CPUs in cooling maps

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: exynos: correct TMU phandle in Exynos4210

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: Override thermal by label in Exynos4210

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: Fix language typo and indentation

Jan Kara <jack@suse.cz>
    udf: Detect system inodes linked into directory hierarchy

Jan Kara <jack@suse.cz>
    udf: Preserve link count of system files

Jan Kara <jack@suse.cz>
    udf: Remove pointless union in udf_inode_info

Steven J. Magnani <steve.magnani@digidescorp.com>
    udf: reduce leakage of blocks related to named streams

Jan Kara <jack@suse.cz>
    udf: Explain handling of load_nls() failure

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

Andrew Cooper <andrew.cooper3@citrix.com>
    x86/CPU/AMD: Disable XSAVES on AMD family 0x17

Theodore Ts'o <tytso@mit.edu>
    fs: prevent out-of-bounds array speculation when closing a file descriptor


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/alpha/kernel/module.c                         |   4 +-
 arch/arm/boot/dts/exynos3250-artik5.dtsi           |   6 +-
 arch/arm/boot/dts/exynos3250-monk.dts              |   6 +-
 arch/arm/boot/dts/exynos3250-rinato.dts            |   6 +-
 arch/arm/boot/dts/exynos3250.dtsi                  |  12 +-
 arch/arm/boot/dts/exynos4.dtsi                     |  12 +-
 arch/arm/boot/dts/exynos4210-trats.dts             |   4 +-
 arch/arm/boot/dts/exynos4210.dtsi                  |  39 ++-
 arch/arm/boot/dts/exynos4412-itop-scp-core.dtsi    |   8 +-
 arch/arm/boot/dts/exynos4412-midas.dtsi            |   8 +-
 arch/arm/boot/dts/exynos4412-odroid-common.dtsi    |   8 +-
 arch/arm/boot/dts/exynos4412-odroidu3.dts          |  18 +-
 arch/arm/boot/dts/exynos4412.dtsi                  |   6 +-
 arch/arm/boot/dts/exynos5250.dtsi                  |  73 +++---
 arch/arm/boot/dts/exynos5422-odroidhc1.dts         | 142 +++++++----
 arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi | 171 +++++++++----
 arch/arm/boot/dts/exynos54xx.dtsi                  |  38 +--
 arch/mips/include/asm/mach-rc32434/pci.h           |   2 +-
 arch/x86/kernel/cpu/amd.c                          |   9 +
 drivers/clk/qcom/mmcc-apq8084.c                    | 271 ---------------------
 drivers/gpu/drm/i915/intel_ringbuffer.c            |   4 +-
 drivers/macintosh/windfarm_lm75_sensor.c           |   4 +-
 drivers/macintosh/windfarm_smu_sensors.c           |   4 +-
 drivers/media/i2c/ov5640.c                         |   2 +-
 drivers/pci/quirks.c                               |   8 +
 drivers/scsi/hosts.c                               |   2 +
 drivers/staging/mt7621-spi/spi-mt7621.c            |   8 +-
 fs/ext4/fsmap.c                                    |   2 +
 fs/ext4/inline.c                                   |   1 -
 fs/ext4/inode.c                                    |   7 +-
 fs/ext4/ioctl.c                                    |   1 +
 fs/ext4/namei.c                                    |  13 +-
 fs/ext4/xattr.c                                    |   3 +
 fs/file.c                                          |   1 +
 fs/udf/directory.c                                 |   2 +-
 fs/udf/file.c                                      |   7 +-
 fs/udf/ialloc.c                                    |  14 +-
 fs/udf/inode.c                                     |  76 ++++--
 fs/udf/misc.c                                      |   6 +-
 fs/udf/namei.c                                     |   7 +-
 fs/udf/partition.c                                 |   2 +-
 fs/udf/super.c                                     |  12 +-
 fs/udf/symlink.c                                   |   2 +-
 fs/udf/udf_i.h                                     |  12 +-
 include/linux/cpuset.h                             |   8 +-
 include/linux/pci_ids.h                            |   2 +
 kernel/cgroup/cgroup-v1.c                          |   3 +
 kernel/cgroup/cgroup.c                             |  49 +++-
 kernel/cgroup/cpuset.c                             |  25 +-
 net/nfc/netlink.c                                  |   2 +-
 net/tipc/socket.c                                  |   2 +-
 scripts/Makefile.build                             |   4 +-
 53 files changed, 569 insertions(+), 573 deletions(-)


