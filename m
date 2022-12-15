Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2214864E045
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 19:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbiLOSL0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 13:11:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbiLOSLR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 13:11:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72BD14730A;
        Thu, 15 Dec 2022 10:11:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1008061E97;
        Thu, 15 Dec 2022 18:11:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D91C433EF;
        Thu, 15 Dec 2022 18:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671127873;
        bh=joiqiiTYyFEvkCxvbEtvnVF8t0zVSbYWt7+ZlbnuLeA=;
        h=From:To:Cc:Subject:Date:From;
        b=GMen7gg7gw0gsMLa7HxMtflrRE3BRiZTRiS97MdUHERjK36GgK1mmC4erDsbJ+ivc
         GvleQ2k8eW0bgY/gf89MPkvgmT2qw9Io9XAeHpHaFHdOA3TGtHFRBuaQoloy0vyoh5
         cb24Z4ihK0gg5sI9xJBOBiWkokxbSR9irU+HId34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.10 00/15] 5.10.160-rc1 review
Date:   Thu, 15 Dec 2022 19:10:27 +0100
Message-Id: <20221215172906.638553794@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.160-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.160-rc1
X-KernelTest-Deadline: 2022-12-17T17:29+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.160 release.
There are 15 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.160-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.160-rc1

Lei Rao <lei.rao@intel.com>
    nvme-pci: clear the prp2 field when not used

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: cs42l51: Correct PGA Volume minimum value

Yasushi SHOJI <yasushi.shoji@gmail.com>
    can: mcba_usb: Fix termination command argument

Heiko Schocher <hs@denx.de>
    can: sja1000: fix size of OCR_MODE_MASK define

Ricardo Ribalda <ribalda@chromium.org>
    pinctrl: meditatek: Startup with the IRQs disabled

Hou Tao <houtao1@huawei.com>
    libbpf: Use page size as max_entries when probing ring buffer map

Mark Brown <broonie@kernel.org>
    ASoC: ops: Check bounds for second channel in snd_soc_put_volsw_sx()

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_micfil: explicitly clear CHnF flags

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_micfil: explicitly clear software reset bit

Bing-Jhong Billy Jheng <billy@starlabs.sg>
    io_uring: add missing item types for splice request

Miklos Szeredi <mszeredi@redhat.com>
    fuse: always revalidate if exclusive create

Jialiang Wang <wangjialiang0806@163.com>
    nfp: fix use-after-free in area_cache_get()

Amir Goldstein <amir73il@gmail.com>
    vfs: fix copy_file_range() averts filesystem freeze protection

Amir Goldstein <amir73il@gmail.com>
    vfs: fix copy_file_range() regression in cross-fs copies

Paul E. McKenney <paulmck@kernel.org>
    x86/smpboot: Move rcu_cpu_starting() earlier


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/x86/kernel/cpu/mtrr/mtrr.c                    |  2 -
 arch/x86/kernel/smpboot.c                          |  1 +
 drivers/net/can/usb/mcba_usb.c                     | 10 ++-
 .../ethernet/netronome/nfp/nfpcore/nfp_cppcore.c   |  3 +-
 drivers/nvme/host/pci.c                            |  2 +
 drivers/pinctrl/mediatek/mtk-eint.c                |  9 ++-
 fs/fuse/dir.c                                      |  2 +-
 fs/io_uring.c                                      |  2 +-
 fs/nfsd/vfs.c                                      |  8 +-
 fs/read_write.c                                    | 90 +++++++++++++---------
 include/linux/can/platform/sja1000.h               |  2 +-
 include/linux/fs.h                                 |  8 ++
 sound/soc/codecs/cs42l51.c                         |  2 +-
 sound/soc/fsl/fsl_micfil.c                         | 19 +++++
 sound/soc/soc-ops.c                                |  6 ++
 tools/lib/bpf/libbpf_probes.c                      |  2 +-
 17 files changed, 120 insertions(+), 52 deletions(-)


