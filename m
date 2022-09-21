Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D98825C0275
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbiIUPxC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiIUPwD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:52:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8598413E04;
        Wed, 21 Sep 2022 08:49:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAE6463141;
        Wed, 21 Sep 2022 15:49:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92134C433B5;
        Wed, 21 Sep 2022 15:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775380;
        bh=yrX7I7Z0vmLA2iBpeDtqTsviZPEfKkHHYlIuu2rPgUc=;
        h=From:To:Cc:Subject:Date:From;
        b=m0ApC73GboRhn51EvTynsTS6ncsnM14nAt5Uj+/EkVddOZmMCri/4tCrOGx+FZ9jz
         vgVMbeSzldg9/88A1F2FIk5iNR0P3OVnTCGBBZkLh/T8CgTiIs9zdZ7UGGGvOh5zs0
         +1K5H1/PVS2Ah+SaQbPOInukZDFf5Malm/pzR528=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.15 00/45] 5.15.70-rc1 review
Date:   Wed, 21 Sep 2022 17:45:50 +0200
Message-Id: <20220921153646.931277075@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.70-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.70-rc1
X-KernelTest-Deadline: 2022-09-23T15:36+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.70 release.
There are 45 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 23 Sep 2022 15:36:33 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.70-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.70-rc1

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/sigmatel: Fix unused variable warning for beep power change

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    cgroup: Add missing cpus_read_lock() to cgroup_attach_task_all()

Mingwei Zhang <mizhang@google.com>
    KVM: SEV: add cache flush to solve SEV cache incoherency issues

sewookseo <sewookseo@google.com>
    net: Find dst with sk's xfrm policy not ctl_sk

Hyunwoo Kim <imv4bel@gmail.com>
    video: fbdev: pxa3xx-gcu: Fix integer overflow in pxa3xx_gcu_write

Youling Tang <tangyouling@loongson.cn>
    mksysmap: Fix the mismatch of 'L0' symbols in System.map

Clément Péron <peron.clem@gmail.com>
    drm/panfrost: devfreq: set opp to the recommended one to configure regulator

Alexander Sverdlin <alexander.sverdlin@nokia.com>
    MIPS: OCTEON: irq: Fix octeon_irq_force_ciu_mapping()

David Howells <dhowells@redhat.com>
    afs: Return -EAGAIN, not -EREMOTEIO, when a file already locked

jerry.meng <jerry-meng@foxmail.com>
    net: usb: qmi_wwan: add Quectel RM520N

Mohan Kumar <mkumard@nvidia.com>
    ALSA: hda/tegra: Align BDL entry to 4KB boundary

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/sigmatel: Keep power up while beep is enabled

Soenke Huster <soenke.huster@eknoes.de>
    wifi: mac80211_hwsim: check length for virtio packets

David Howells <dhowells@redhat.com>
    rxrpc: Fix calc of resend age

David Howells <dhowells@redhat.com>
    rxrpc: Fix local destruction being repeated

Hannes Reinecke <hare@suse.de>
    scsi: lpfc: Return DID_TRANSPORT_DISRUPTED instead of DID_REQUEUE

Xiaolei Wang <xiaolei.wang@windriver.com>
    regulator: pfuze100: Fix the global-out-of-bounds access in pfuze100_regulator_probe()

Takashi Iwai <tiwai@suse.de>
    ASoC: nau8824: Fix semaphore unbalance at error paths

Jassi Brar <jaswinder.singh@linaro.org>
    arm64: dts: juno: Add missing MHU secure-irq

Zheyu Ma <zheyuma97@gmail.com>
    video: fbdev: i740fb: Error out if 'pixclock' equals zero

Carlos Llamas <cmllamas@google.com>
    binder: remove inaccurate mmap_assert_locked()

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: move nbio sdma_doorbell_range() into sdma code for vega

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: move nbio ih_doorbell_range() into ih code for vega

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Don't enable LTR if not supported

Ben Hutchings <benh@debian.org>
    tools/include/uapi: Fix <asm/errno.h> for parisc and xtensa

Helge Deller <deller@gmx.de>
    parisc: Allow CONFIG_64BIT with ARCH=parisc

Stefan Metzmacher <metze@samba.org>
    cifs: always initialize struct msghdr smb_msg completely

Stefan Metzmacher <metze@samba.org>
    cifs: don't send down the destination address to sendmsg for a SOCK_STREAM

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: revalidate mapping when doing direct writes

Thierry Reding <treding@nvidia.com>
    of/device: Fix up of_dma_configure_id() stub

Yang Yingliang <yangyingliang@huawei.com>
    parisc: ccio-dma: Add missing iounmap in error path in ccio_probe()

Stefan Roesch <shr@fb.com>
    block: blk_queue_enter() / __bio_queue_enter() must return -EAGAIN for nowait

Stuart Menefy <stuart.menefy@mathembedded.com>
    drm/meson: Fix OSD1 RGB to YCbCr coefficient

Stuart Menefy <stuart.menefy@mathembedded.com>
    drm/meson: Correct OSD1 global alpha value

Pali Rohár <pali@kernel.org>
    gpio: mpc8xxx: Fix support for IRQ_TYPE_LEVEL_LOW flow_type in mpc85xx

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Turn off open-by-filehandle and NFS re-export for NFSv4.0

Michael Wu <michael@allwinnertech.com>
    pinctrl: sunxi: Fix name for A100 R_PIO

João H. Spies <jhlspies@gmail.com>
    pinctrl: rockchip: Enhance support for IRQ_TYPE_EDGE_BOTH

Molly Sophia <mollysophia379@gmail.com>
    pinctrl: qcom: sc8180x: Fix wrong pin numbers

Molly Sophia <mollysophia379@gmail.com>
    pinctrl: qcom: sc8180x: Fix gpio_wakeirq_map

Sergey Shtylyov <s.shtylyov@omp.ru>
    of: fdt: fix off-by-one error in unflatten_dt_nodes()

Sergiu Moga <sergiu.moga@microchip.com>
    tty: serial: atmel: Preserve previous USART mode if RS485 disabled

Lino Sanfilippo <LinoSanfilippo@gmx.de>
    serial: atmel: remove redundant assignment in rs485_config

Coiby Xu <coxu@redhat.com>
    arm64: kexec_file: use more system keyrings to verify kernel image signature

YueHaibing <yuehaibing@huawei.com>
    drm/tegra: vic: Fix build warning when CONFIG_PM=n


-------------

Diffstat:

 Makefile                                      |  4 ++--
 arch/arm64/boot/dts/arm/juno-base.dtsi        |  3 ++-
 arch/arm64/kernel/kexec_image.c               | 11 +----------
 arch/mips/cavium-octeon/octeon-irq.c          | 10 ++++++++++
 arch/parisc/Kconfig                           | 12 +++++++++++-
 arch/x86/include/asm/kvm-x86-ops.h            |  1 +
 arch/x86/include/asm/kvm_host.h               |  1 +
 arch/x86/kvm/svm/sev.c                        |  8 ++++++++
 arch/x86/kvm/svm/svm.c                        |  1 +
 arch/x86/kvm/svm/svm.h                        |  2 ++
 arch/x86/kvm/x86.c                            |  5 +++++
 block/blk-core.c                              |  4 ++--
 drivers/android/binder_alloc.c                |  7 -------
 drivers/gpio/gpio-mpc8xxx.c                   |  1 +
 drivers/gpio/gpio-rockchip.c                  |  4 ++--
 drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c        |  9 ++++++++-
 drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c        |  9 ++++++++-
 drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c        |  9 ++++++++-
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c        |  5 +++++
 drivers/gpu/drm/amd/amdgpu/soc15.c            | 25 -------------------------
 drivers/gpu/drm/amd/amdgpu/vega10_ih.c        |  4 ++++
 drivers/gpu/drm/amd/amdgpu/vega20_ih.c        |  4 ++++
 drivers/gpu/drm/meson/meson_plane.c           |  2 +-
 drivers/gpu/drm/meson/meson_viu.c             |  2 +-
 drivers/gpu/drm/panfrost/panfrost_devfreq.c   | 11 +++++++++++
 drivers/gpu/drm/tegra/vic.c                   |  4 ++--
 drivers/net/usb/qmi_wwan.c                    |  1 +
 drivers/net/wireless/mac80211_hwsim.c         |  7 ++++++-
 drivers/of/fdt.c                              |  2 +-
 drivers/parisc/ccio-dma.c                     |  1 +
 drivers/pinctrl/qcom/pinctrl-sc8180x.c        | 10 +++++-----
 drivers/pinctrl/sunxi/pinctrl-sun50i-a100-r.c |  2 +-
 drivers/regulator/pfuze100-regulator.c        |  2 +-
 drivers/scsi/lpfc/lpfc_scsi.c                 |  4 ++--
 drivers/tty/serial/atmel_serial.c             |  8 ++------
 drivers/video/fbdev/i740fb.c                  |  3 +++
 drivers/video/fbdev/pxa3xx-gcu.c              |  2 +-
 fs/afs/misc.c                                 |  1 +
 fs/cifs/connect.c                             | 11 +++--------
 fs/cifs/file.c                                |  3 +++
 fs/cifs/transport.c                           |  6 +-----
 fs/nfs/super.c                                | 27 ++++++++++++++++++---------
 include/linux/kvm_host.h                      |  2 ++
 include/linux/of_device.h                     |  5 +++--
 include/net/xfrm.h                            |  2 ++
 kernel/cgroup/cgroup-v1.c                     |  2 ++
 net/ipv4/ip_output.c                          |  2 +-
 net/ipv4/tcp_ipv4.c                           |  2 ++
 net/ipv6/tcp_ipv6.c                           |  5 ++++-
 net/rxrpc/call_event.c                        |  2 +-
 net/rxrpc/local_object.c                      |  3 +++
 scripts/mksysmap                              |  2 +-
 sound/pci/hda/hda_tegra.c                     |  3 ++-
 sound/pci/hda/patch_sigmatel.c                | 24 ++++++++++++++++++++++++
 sound/soc/codecs/nau8824.c                    | 17 ++++++++++-------
 tools/include/uapi/asm/errno.h                |  4 ++--
 virt/kvm/kvm_main.c                           | 27 ++++++++++++++++++++++++---
 57 files changed, 234 insertions(+), 116 deletions(-)


