Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 374626BB015
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbjCOMPH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbjCOMPD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:15:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EB8A7DF9C;
        Wed, 15 Mar 2023 05:15:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6C1761D13;
        Wed, 15 Mar 2023 12:15:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D181DC433EF;
        Wed, 15 Mar 2023 12:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882501;
        bh=pxhJVqWJBbgiL+m3yUqsKzYrPva8CDb+w279R5bYCGc=;
        h=From:To:Cc:Subject:Date:From;
        b=avXvPJ2nVv8wPArxfcWqtsvglrJlh3foHGUBm0bOG0ElARampqc794OrXzyzYc5z/
         sOy31nw8yGBYGnCyqkp0iSmt+/I0PeTBrnK+Nf9evnPqraR9ZhZgK2T/tA+a8RIAK0
         +LbCRFBIBeg9jYT0xn6zOV8M3I8mm+7YNgSqRXIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 4.14 00/21] 4.14.310-rc1 review
Date:   Wed, 15 Mar 2023 13:12:23 +0100
Message-Id: <20230315115718.796692048@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.310-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.310-rc1
X-KernelTest-Deadline: 2023-03-17T11:57+00:00
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

This is the start of the stable review cycle for the 4.14.310 release.
There are 21 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.310-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.310-rc1

Rhythm Mahajan <rhythm.m.mahajan@oracle.com>
    x86/cpu: Fix LFENCE serialization check in init_amd()

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

Shigeru Yoshida <syoshida@redhat.com>
    net: caif: Fix use-after-free in cfusbl_device_notify()

Eric Dumazet <edumazet@google.com>
    ila: do not generate empty messages in ila_xlat_nl_cmd_get_mapping()

Kang Chen <void0red@gmail.com>
    nfc: fdp: add null check of devm_kmalloc_array in fdp_nci_i2c_read_device_properties

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

 Makefile                                 |   4 +-
 arch/alpha/kernel/module.c               |   4 +-
 arch/mips/include/asm/mach-rc32434/pci.h |   2 +-
 arch/x86/kernel/cpu/amd.c                |  11 +-
 drivers/clk/qcom/mmcc-apq8084.c          | 271 -------------------------------
 drivers/gpu/drm/i915/intel_ringbuffer.c  |   4 +-
 drivers/macintosh/windfarm_lm75_sensor.c |   4 +-
 drivers/macintosh/windfarm_smu_sensors.c |   4 +-
 drivers/media/i2c/ov5640.c               |   2 +-
 drivers/nfc/fdp/i2c.c                    |   4 +
 drivers/pci/quirks.c                     |   8 +
 fs/ext4/fsmap.c                          |   2 +
 fs/ext4/inline.c                         |   1 -
 fs/ext4/inode.c                          |   7 +-
 fs/ext4/ioctl.c                          |   1 +
 fs/ext4/namei.c                          |  13 +-
 fs/ext4/xattr.c                          |   3 +
 fs/file.c                                |   1 +
 include/linux/pci_ids.h                  |   2 +
 net/caif/caif_usb.c                      |   3 +
 net/ipv6/ila/ila_xlat.c                  |   1 +
 net/nfc/netlink.c                        |   2 +-
 net/tipc/socket.c                        |   2 +-
 23 files changed, 61 insertions(+), 295 deletions(-)


