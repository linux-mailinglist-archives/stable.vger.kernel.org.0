Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0BD8528E8C
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 21:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344023AbiEPTn7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346096AbiEPTmu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:42:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEFF13F898;
        Mon, 16 May 2022 12:41:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77F8FB8160F;
        Mon, 16 May 2022 19:41:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C472C385AA;
        Mon, 16 May 2022 19:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730091;
        bh=oXuVeeq+9ifI6rj7t3up4WmNiThPoj4aBSaDcwvi/IQ=;
        h=From:To:Cc:Subject:Date:From;
        b=qre+QZLGJ/uJsRXz4zBahD8nsHK9t0pPvZNkoZ4n8oO0j+RHarRMfxx+6PVRydGvR
         0hTExWSMNY+GoGO1pyLK0PgCJzzEJabqXGbi1/kxt6cshMP0jyAGFV55ot/feaSwx6
         i4GSPD98DgJdekQJIWJlTm04KKBtn7AnOpBGPcgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.19 00/32] 4.19.244-rc1 review
Date:   Mon, 16 May 2022 21:36:14 +0200
Message-Id: <20220516193614.773450018@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.244-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.244-rc1
X-KernelTest-Deadline: 2022-05-18T19:36+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.244 release.
There are 32 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 18 May 2022 19:36:02 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.244-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.244-rc1

Yang Yingliang <yangyingliang@huawei.com>
    tty/serial: digicolor: fix possible null-ptr-deref in digicolor_uart_probe()

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ping: fix address binding wrt vrf

Sudip Mukherjee <sudipm.mukherjee@gmail.com>
    MIPS: fix allmodconfig build with latest mkimage

Zack Rusin <zackr@vmware.com>
    drm/vmwgfx: Initialize drm_mode_fb_cmd2

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Remove cpus_allowed/mems_allowed setup in cpuset_init_smp()

Miaoqian Lin <linmq006@gmail.com>
    slimbus: qcom: Fix IRQ check in qcom_slim_probe

Sven Schwermer <sven.schwermer@disruptive-technologies.com>
    USB: serial: option: add Fibocom MA510 modem

Sven Schwermer <sven.schwermer@disruptive-technologies.com>
    USB: serial: option: add Fibocom L610 modem

Ethan Yang <etyang@sierrawireless.com>
    USB: serial: qcserial: add support for Sierra Wireless EM7590

Scott Chen <scott@labau.com.tw>
    USB: serial: pl2303: add device id for HP LM930 Display

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    usb: typec: tcpci: Don't skip cleanup in .remove() on error

Sergey Ryazanov <ryazanov.s.a@gmail.com>
    usb: cdc-wdm: fix reading stuck on device close

Eric Dumazet <edumazet@google.com>
    tcp: resalt the secret every 10 seconds

Sven Schnelle <svens@linux.ibm.com>
    s390: disable -Warray-bounds

Mark Brown <broonie@kernel.org>
    ASoC: ops: Validate input values in snd_soc_put_volsw_range()

Mark Brown <broonie@kernel.org>
    ASoC: max98090: Generate notifications on changes for custom control

Mark Brown <broonie@kernel.org>
    ASoC: max98090: Reject invalid values in custom control put()

Ji-Ze Hong (Peter Hong) <hpeter@gmail.com>
    hwmon: (f71882fg) Fix negative temperature

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix filesystem block deallocation for short writes

Taehee Yoo <ap420073@gmail.com>
    net: sfc: ef10: fix memory leak in efx_ef10_mtd_probe()

Guangguan Wang <guangguan.wang@linux.alibaba.com>
    net/smc: non blocking recvmsg() return -EAGAIN when no data and signal_pending

Paolo Abeni <pabeni@redhat.com>
    net/sched: act_pedit: really ensure the skb is writable

Alexandra Winter <wintera@linux.ibm.com>
    s390/lcs: fix variable dereferenced before check

Alexandra Winter <wintera@linux.ibm.com>
    s390/ctcm: fix potential memory leak

Alexandra Winter <wintera@linux.ibm.com>
    s390/ctcm: fix variable dereferenced before check

Randy Dunlap <rdunlap@infradead.org>
    hwmon: (ltq-cputemp) restrict it to SOC_XWAY

Johannes Berg <johannes.berg@intel.com>
    mac80211_hwsim: call ieee80211_tx_prepare_skb under RCU protection

Eric Dumazet <edumazet@google.com>
    netlink: do not reset transport header in netlink_recvmsg()

Lokesh Dhoundiyal <lokesh.dhoundiyal@alliedtelesis.co.nz>
    ipv4: drop dst in multicast routing path

Tariq Toukan <tariqt@nvidia.com>
    net: Fix features skip in for_each_netdev_feature()

Camel Guo <camel.guo@axis.com>
    hwmon: (tmp401) Add OF device ID table

Sven Eckelmann <sven@narfation.org>
    batman-adv: Don't skb_split skbuffs with frag_list


-------------

Diffstat:

 Makefile                                    |  4 ++--
 arch/mips/generic/board-ocelot_pcb123.its.S | 10 +++++-----
 arch/s390/Makefile                          | 10 ++++++++++
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c          |  2 +-
 drivers/hwmon/Kconfig                       |  2 +-
 drivers/hwmon/f71882fg.c                    |  5 +++--
 drivers/hwmon/tmp401.c                      | 11 +++++++++++
 drivers/net/ethernet/sfc/ef10.c             |  5 +++++
 drivers/net/wireless/mac80211_hwsim.c       |  3 +++
 drivers/s390/net/ctcm_mpc.c                 |  6 +-----
 drivers/s390/net/ctcm_sysfs.c               |  5 +++--
 drivers/s390/net/lcs.c                      |  7 ++++---
 drivers/slimbus/qcom-ctrl.c                 |  4 ++--
 drivers/tty/serial/digicolor-usart.c        |  2 +-
 drivers/usb/class/cdc-wdm.c                 |  1 +
 drivers/usb/serial/option.c                 |  4 ++++
 drivers/usb/serial/pl2303.c                 |  1 +
 drivers/usb/serial/pl2303.h                 |  1 +
 drivers/usb/serial/qcserial.c               |  2 ++
 drivers/usb/typec/tcpci.c                   |  2 +-
 fs/gfs2/bmap.c                              | 11 +++++------
 include/linux/netdev_features.h             |  4 ++--
 include/net/tc_act/tc_pedit.h               |  1 +
 kernel/cgroup/cpuset.c                      |  7 +++++--
 net/batman-adv/fragmentation.c              | 11 +++++++++++
 net/core/secure_seq.c                       | 12 +++++++++---
 net/ipv4/ping.c                             | 12 +++++++++++-
 net/ipv4/route.c                            |  1 +
 net/netlink/af_netlink.c                    |  1 -
 net/sched/act_pedit.c                       | 26 ++++++++++++++++++++++----
 net/smc/smc_rx.c                            |  4 ++--
 sound/soc/codecs/max98090.c                 |  5 ++++-
 sound/soc/soc-ops.c                         | 18 +++++++++++++++++-
 33 files changed, 152 insertions(+), 48 deletions(-)


