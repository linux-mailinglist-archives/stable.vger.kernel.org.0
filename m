Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64D53582ABD
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235175AbiG0QXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235536AbiG0QWx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:22:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D1084D16E;
        Wed, 27 Jul 2022 09:22:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 290D5B821A6;
        Wed, 27 Jul 2022 16:22:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5204DC433C1;
        Wed, 27 Jul 2022 16:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658938956;
        bh=gaBrScAaCmUC6aNKiBmd9h4bfCdJILFqhKUgDplWUvQ=;
        h=From:To:Cc:Subject:Date:From;
        b=DCLXmZqe7JtOtz384FV+Wt0KDoGY3OIMYcbbhsDOGkFhiFTgkvKIRMsMgFxYa4MWE
         oNJmf6EjNCVaVhzqYWKoNgDqdZRsH4pMZowIZurWQMJ5R7jRtbQ/HYSDd0Ernz029a
         25lQdIwkKrll/9qc/7p6XX88cG38VW2e/5iFFNyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.9 00/26] 4.9.325-rc1 review
Date:   Wed, 27 Jul 2022 18:10:29 +0200
Message-Id: <20220727160959.122591422@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.325-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.325-rc1
X-KernelTest-Deadline: 2022-07-29T16:10+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.325 release.
There are 26 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.325-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.325-rc1

Jose Alonso <joalonsof@gmail.com>
    net: usb: ax88179_178a needs FLAG_SEND_ZLP

Jiri Slaby <jslaby@suse.cz>
    tty: use new tty_insert_flip_string_and_push_buffer() in pty_write()

Jiri Slaby <jslaby@suse.cz>
    tty: extract tty_flip_buffer_commit() from tty_flip_buffer_push()

Jiri Slaby <jslaby@suse.cz>
    tty: drop tty_schedule_flip()

Jiri Slaby <jslaby@suse.cz>
    tty: the rest, stop using tty_schedule_flip()

Jiri Slaby <jslaby@suse.cz>
    tty: drivers/tty/, stop using tty_schedule_flip()

Takashi Iwai <tiwai@suse.de>
    ALSA: memalloc: Align buffer allocations in page size

Eric Dumazet <edumazet@google.com>
    bpf: Make sure mac_header was set before using it

Wang Cheng <wanngchenng@gmail.com>
    mm/mempolicy: fix uninit-value in mpol_rebind_policy()

Jason A. Donenfeld <Jason@zx2c4.com>
    Revert "Revert "char/random: silence a lockdep splat with printk()""

Hristo Venev <hristo@venev.name>
    be2net: Fix buffer overflow in be_get_module_eeprom

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_notsent_lowat.

Kuniyuki Iwashima <kuniyu@amazon.com>
    igmp: Fix a data-race around sysctl_igmp_max_memberships.

Kuniyuki Iwashima <kuniyu@amazon.com>
    igmp: Fix data-races around sysctl_igmp_llm_reports.

Robert Hancock <robert.hancock@calian.com>
    i2c: cadence: Change large transfer count reset logic to be unconditional

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_probe_threshold.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp/dccp: Fix a data-race around sysctl_tcp_fwmark_accept.

Kuniyuki Iwashima <kuniyu@amazon.com>
    ip: Fix a data-race around sysctl_fwmark_reflect.

Peter Zijlstra <peterz@infradead.org>
    perf/core: Fix data race between perf_event_set_output() and perf_mmap_close()

Miaoqian Lin <linmq006@gmail.com>
    power/reset: arm-versatile: Fix refcount leak in versatile_reboot_probe

Hangyu Hua <hbh25y@gmail.com>
    xfrm: xfrm_policy: fix a possible double xfrm_pols_put() in xfrm_bundle_lookup()

Shuah Khan <skhan@linuxfoundation.org>
    misc: rtsx_usb: set return value in rsp_buf alloc err path

Shuah Khan <skhan@linuxfoundation.org>
    misc: rtsx_usb: use separate command and response buffers

Shuah Khan <skhan@linuxfoundation.org>
    misc: rtsx_usb: fix use of dma mapped buffer for usb bulk transfer

Demi Marie Obenour <demi@invisiblethingslab.com>
    xen/gntdev: Ignore failure to unmap INVALID_GRANT_HANDLE

Stephen Smalley <sds@tycho.nsa.gov>
    security,selinux,smack: kill security_task_wait hook


-------------

Diffstat:

 Makefile                                       |  4 +-
 arch/alpha/kernel/srmcons.c                    |  2 +-
 drivers/char/random.c                          |  4 +-
 drivers/i2c/busses/i2c-cadence.c               | 30 ++----------
 drivers/mfd/rtsx_usb.c                         | 27 +++++++----
 drivers/net/ethernet/emulex/benet/be_cmds.c    | 10 ++--
 drivers/net/ethernet/emulex/benet/be_cmds.h    |  2 +-
 drivers/net/ethernet/emulex/benet/be_ethtool.c | 31 +++++++-----
 drivers/net/usb/ax88179_178a.c                 | 14 +++---
 drivers/power/reset/arm-versatile-reboot.c     |  1 +
 drivers/s390/char/keyboard.h                   |  4 +-
 drivers/tty/cyclades.c                         |  6 +--
 drivers/tty/goldfish.c                         |  2 +-
 drivers/tty/moxa.c                             |  4 +-
 drivers/tty/pty.c                              | 14 +-----
 drivers/tty/serial/lpc32xx_hs.c                |  2 +-
 drivers/tty/tty_buffer.c                       | 66 +++++++++++++++++---------
 drivers/tty/vt/keyboard.c                      |  6 +--
 drivers/tty/vt/vt.c                            |  2 +-
 drivers/xen/gntdev.c                           |  3 +-
 include/linux/lsm_hooks.h                      |  7 ---
 include/linux/mfd/rtsx_usb.h                   |  2 -
 include/linux/security.h                       |  6 ---
 include/linux/tty_flip.h                       |  4 +-
 include/net/inet_sock.h                        |  3 +-
 include/net/ip.h                               |  2 +-
 include/net/tcp.h                              |  2 +-
 kernel/bpf/core.c                              |  8 ++--
 kernel/events/core.c                           | 45 ++++++++++++------
 kernel/exit.c                                  | 19 +-------
 mm/mempolicy.c                                 |  2 +-
 net/ipv4/igmp.c                                | 23 +++++----
 net/ipv4/tcp_output.c                          |  2 +-
 net/xfrm/xfrm_policy.c                         |  5 +-
 security/security.c                            |  6 ---
 security/selinux/hooks.c                       |  6 ---
 security/smack/smack_lsm.c                     | 20 --------
 sound/core/memalloc.c                          |  1 +
 38 files changed, 189 insertions(+), 208 deletions(-)


