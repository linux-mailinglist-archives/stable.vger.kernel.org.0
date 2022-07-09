Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD2156C952
	for <lists+stable@lfdr.de>; Sat,  9 Jul 2022 14:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiGIMHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jul 2022 08:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiGIMHW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Jul 2022 08:07:22 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A18C1371BF
        for <stable@vger.kernel.org>; Sat,  9 Jul 2022 05:07:19 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id r18so1301417edb.9
        for <stable@vger.kernel.org>; Sat, 09 Jul 2022 05:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to
         :content-language:cc:content-transfer-encoding;
        bh=qMx1MYDxBt6bfpaOuCghb/jUGAeFMknJaccOgQFnSrk=;
        b=Hqn3+VKcE+ach9RWrUh0okc7f0NLE4+UPWTj/YJL6JdFzp0qHR/TIa+s2ijE0JC0kb
         ptrAYoyyWe9Vk9GtyDuBW4Dgay5ehg5sHfFUGbV5tuVkAH2NM9iBC1qVE0UZaD3Iv8n9
         GKPI3LAn7pIopbvl1cU/fn8NmsJciHfQP8DvOjQr1W1XoXPmQcIMlYGsvBu0N7P4tZwZ
         U6Afg848yRan/lmr6te7MhXEm3foykzMAgnE+FzA5z7rB4KVmMQS77N2LlLP5wCBjStt
         xZlf1lQZs06Ju/mV+uMHAjjMR25IY19+tGAxbMxNFETwa4pKvojiSQXnr0sar/r2s/I2
         nMRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:content-language:cc:content-transfer-encoding;
        bh=qMx1MYDxBt6bfpaOuCghb/jUGAeFMknJaccOgQFnSrk=;
        b=BFmOirHz+/KqyP661AAUZqh39oMrjT9fqpFAsdwmh/d66SvPS2oiBcdiwLqZGefh89
         Uz/Oyi7lfE2NFy4dQAfxCZ3PPmV2toGRtKB0B54+SnbzV9Gs9k+OAEtuu/vauApRdkDl
         BwNWetsNN924EPZISW2eQOD5vPGqHlNOTWVVM0IYpVWPdEQ7yECwP35S090Gf/1A39Ek
         uBKGZChIOncSQUq7gMNSKiws//6jilvg0XVhcZDUX2qyTfaru4g8x1R/inWyCfpaIf8d
         Sk8KqcwxMlFI8vta4NHfXkhYc5xVWjvka3lfKTxl7ojLwnEd0XW5uxJMVMIs9Qv0KLXm
         Vh3A==
X-Gm-Message-State: AJIora+Oe+4M2SsdRFVlXS33uZ+WcD8mCpfzNce4RnsnFezyCS3RdgPq
        XUyE0kWruQoysM29D/grrOK5H8PHnU8Bie5H
X-Google-Smtp-Source: AGRyM1tL0UHXBsZoKNzc0GCosDkZBIMOlBj1XDe55rJQiTCUkXQkoBP2CV2vsPRlwx5It695Hk7GYw==
X-Received: by 2002:a05:6402:12c2:b0:43a:276b:e54d with SMTP id k2-20020a05640212c200b0043a276be54dmr11154084edx.278.1657368438059;
        Sat, 09 Jul 2022 05:07:18 -0700 (PDT)
Received: from ?IPV6:2003:f6:af33:4400:54ed:6887:a123:7f84? (p200300f6af33440054ed6887a1237f84.dip0.t-ipconnect.de. [2003:f6:af33:4400:54ed:6887:a123:7f84])
        by smtp.gmail.com with ESMTPSA id i8-20020a170906a28800b0072b13fa5e4csm551241ejz.58.2022.07.09.05.07.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Jul 2022 05:07:17 -0700 (PDT)
Message-ID: <4230dd79-b64f-14e6-3614-02e4acb3f284@gmail.com>
Date:   Sat, 9 Jul 2022 14:07:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
From:   Alexander Grund <theflamefire89@gmail.com>
Subject: [GIT 4.9] LSM,security,selinux,smack: Backport of LSM changes
To:     stable@vger.kernel.org
Content-Language: en-US
Cc:     theflamefire89@gmail.com
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following changes since commit 445514206988935e5ef0e80588d7481aa3cd3b7b:

   Linux 4.9.322 (2022-07-07 17:30:12 +0200)

are available in the Git repository at:

   https://github.com/Flamefire/android_kernel_sony_msm8998.git lsm_hooks_backport_4.9

for you to fetch changes up to 911aa0e49633be52c7a2de8c99de87b6bf3a7604:

   LSM: Initialize security_hook_heads upon registration. (2022-07-09 12:51:42 +0200)

All commits are cherry-picks/backports from mainline.
The intend was to apply the last commit ("LSM: Initialize security_hook_heads upon registration.") with as few changes as possible.
This revealed added/removed/changed hooks and related changes which seem valuable to have in 4.9 and via the CIP in 4.4 SLTS.
For additional Context: I initially backported those directly to CIPs v4.4-st14 and tested those on an ARM64 Android device from SONY. [1]

I'm open for breaking down the changes into smaller batches. If that is beneficial please advice on how/where to split this batch.
But for now I thought it would be useful to see the full set of changes intended.

References:
- https://lore.kernel.org/all/1478812710-17190-2-git-send-email-agruenba@redhat.com/T/
- https://lkml.org/lkml/2016/6/24/564
- https://patchwork.kernel.org/project/linux-hardening/patch/alpine.LRH.2.20.1702150016220.32759@namei.org/
- https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg2415740.html
- https://lkml.org/lkml/2016/6/24/564

----------------------------------------------------------------
Andreas Gruenbacher (4):
       proc: Pass file mode to proc_pid_make_inode
       selinux: Minor cleanups
       selinux: Clean up initialization of isec->sclass
       selinux: Convert isec->lock into a spinlock

Casey Schaufler (1):
       LSM: Add /sys/kernel/security/lsm

James Morris (2):
       security: introduce CONFIG_SECURITY_WRITABLE_HOOKS
       security: mark LSM hooks as __ro_after_init

Ondrej Mosnacek (1):
       selinux: drop super_block backpointer from superblock_security_struct

Paul Moore (2):
       selinux: fix inode_doinit_with_dentry() LABEL_INVALID error handling
       lsm,selinux: pass flowi_common instead of flowi to the LSM hooks

Stephen Smalley (2):
       prlimit,security,selinux: add a security hook for prlimit
       security,selinux,smack: kill security_task_wait hook

Tetsuo Handa (1):
       LSM: Initialize security_hook_heads upon registration.

Tianyue Ren (1):
       selinux: fix error initialization in inode_doinit_with_dentry()

bauen1 (1):
       selinux: allow dontauditx and auditallowx rules to take effect without allowx

  Documentation/security/LSM.txt      |   7 ++
  fs/proc/base.c                      |  23 ++--
  fs/proc/fd.c                        |   6 +-
  fs/proc/internal.h                  |   2 +-
  fs/proc/namespaces.c                |   3 +-
  include/linux/lsm_hooks.h           |  50 +++++----
  include/linux/security.h            |  42 +++++---
  include/net/flow.h                  |  10 ++
  include/net/route.h                 |   6 +-
  kernel/exit.c                       |  19 +---
  kernel/sys.c                        |  30 +++---
  net/dccp/ipv4.c                     |   2 +-
  net/dccp/ipv6.c                     |   6 +-
  net/ipv4/icmp.c                     |   4 +-
  net/ipv4/inet_connection_sock.c     |   4 +-
  net/ipv4/ip_output.c                |   2 +-
  net/ipv4/ping.c                     |   2 +-
  net/ipv4/raw.c                      |   2 +-
  net/ipv4/syncookies.c               |   2 +-
  net/ipv4/udp.c                      |   2 +-
  net/ipv6/af_inet6.c                 |   2 +-
  net/ipv6/icmp.c                     |   6 +-
  net/ipv6/inet6_connection_sock.c    |   4 +-
  net/ipv6/netfilter/ip6t_SYNPROXY.c  |   2 +-
  net/ipv6/netfilter/nf_reject_ipv6.c |   2 +-
  net/ipv6/ping.c                     |   2 +-
  net/ipv6/raw.c                      |   2 +-
  net/ipv6/syncookies.c               |   2 +-
  net/ipv6/tcp_ipv6.c                 |   4 +-
  net/ipv6/udp.c                      |   2 +-
  net/l2tp/l2tp_ip6.c                 |   2 +-
  net/xfrm/xfrm_state.c               |   6 +-
  security/Kconfig                    |   5 +
  security/apparmor/lsm.c             |   5 +-
  security/commoncap.c                |   5 +-
  security/inode.c                    |  26 ++++-
  security/security.c                 | 426 +++++++++++---------------------------------------------------------------
  security/selinux/Kconfig            |   6 ++
  security/selinux/hooks.c            | 156 +++++++++++++++++----------
  security/selinux/include/classmap.h |   2 +-
  security/selinux/include/objsec.h   |   6 +-
  security/selinux/include/xfrm.h     |   2 +-
  security/selinux/selinuxfs.c        |   4 +-
  security/selinux/ss/services.c      |   4 +-
  security/selinux/xfrm.c             |   8 +-
  security/smack/smack_lsm.c          |  24 +----
  security/tomoyo/tomoyo.c            |   4 +-
  security/yama/yama_lsm.c            |   4 +-
  48 files changed, 359 insertions(+), 588 deletions(-)
