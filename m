Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1742B1FD7
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388429AbfIMNJL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:09:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:33640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388444AbfIMNJK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:09:10 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBF142089F;
        Fri, 13 Sep 2019 13:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380148;
        bh=ydzIOBiXIBgdpbpgmY1JCyGV9IWLVPXAs6DNBpZ7IhM=;
        h=From:To:Cc:Subject:Date:From;
        b=rqfh+To34JjPq/87DRgpkabgsxlcx13sG3hb0avcaLtJnNWACqMNVqR0rCQLOuCKv
         ncZdQhNgcJdL53Dw9RItnqidhyd02ou17m/+7edDfg2zY3q+yxBfu67IzNGzFVHRpf
         aY3SZwiZK+DVgR6wl3nTODxIti1IKNmxHSVctEeE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 00/14] 4.9.193-stable review
Date:   Fri, 13 Sep 2019 14:06:53 +0100
Message-Id: <20190913130440.264749443@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.193-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.193-rc1
X-KernelTest-Deadline: 2019-09-15T13:04+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.193 release.
There are 14 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun 15 Sep 2019 01:03:32 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.193-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.193-rc1

yongduan <yongduan@tencent.com>
    vhost: make sure log_num < in_num

Michael S. Tsirkin <mst@redhat.com>
    vhost: block speculation of translated descriptors

Nathan Chancellor <natechancellor@gmail.com>
    clk: s2mps11: Add used attribute to s2mps11_dt_match

Nicolas Boichat <drinkcat@chromium.org>
    scripts/decode_stacktrace: match basepath using shell prefix operator, not regex

Sven Eckelmann <sven@narfation.org>
    batman-adv: Only read OGM tvlv_len after buffer len check

Eric Dumazet <edumazet@google.com>
    batman-adv: fix uninit-value in batadv_netlink_get_ifindex()

Tiwei Bie <tiwei.bie@intel.com>
    vhost/test: fix build for vhost test

Eric Dumazet <edumazet@google.com>
    ip6: fix skb leak in ip6frag_expire_frag_queue()

Cong Wang <xiyou.wangcong@gmail.com>
    xfrm: clean up xfrm protocol checks

Gustavo Romero <gromero@linux.ibm.com>
    powerpc/tm: Fix FP/VMX unavailable exceptions inside a transaction

Dan Carpenter <dan.carpenter@oracle.com>
    drm/vmwgfx: Fix double free in vmw_recv_msg()

Liangyan <liangyan.peng@linux.alibaba.com>
    sched/fair: Don't assign runtime for throttled cfs_rq

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek - Fix overridden device-specific initialization

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix potential endless loop at applying quirks


-------------

Diffstat:

 Makefile                            |  4 ++--
 arch/powerpc/kernel/process.c       |  3 ++-
 drivers/clk/clk-s2mps11.c           |  2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_msg.c |  8 +++-----
 drivers/vhost/test.c                | 13 +++++++++----
 drivers/vhost/vhost.c               | 10 ++++++----
 include/net/ipv6_frag.h             |  1 -
 include/net/xfrm.h                  | 17 +++++++++++++++++
 kernel/sched/fair.c                 |  5 +++++
 net/batman-adv/bat_iv_ogm.c         | 20 +++++++++++++-------
 net/batman-adv/netlink.c            |  2 +-
 net/key/af_key.c                    |  4 +++-
 net/xfrm/xfrm_state.c               |  2 +-
 net/xfrm/xfrm_user.c                | 14 +-------------
 scripts/decode_stacktrace.sh        |  2 +-
 sound/pci/hda/hda_auto_parser.c     |  4 ++--
 sound/pci/hda/hda_generic.c         |  3 ++-
 sound/pci/hda/hda_generic.h         |  1 +
 sound/pci/hda/patch_realtek.c       |  2 ++
 19 files changed, 72 insertions(+), 45 deletions(-)


