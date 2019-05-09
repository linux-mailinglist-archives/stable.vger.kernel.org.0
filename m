Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0314C18B56
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 16:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfEIONL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 10:13:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46918 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726653AbfEIONK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 10:13:10 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hOjnI-000121-Ek; Thu, 09 May 2019 15:13:08 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hOjnI-0006Lo-8Y; Thu, 09 May 2019 15:13:08 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     torvalds@linux-foundation.org, Guenter Roeck <linux@roeck-us.net>,
        akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>
Date:   Thu, 09 May 2019 15:08:16 +0100
Message-ID: <lsq.1557410896.171359878@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 00/10] 3.16.67-rc1 review
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 3.16.67 release.
There are 10 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat May 11 14:08:16 UTC 2019.
Anything received after that time might be too late.

All the patches have also been committed to the linux-3.16.y-rc branch of
https://git.kernel.org/pub/scm/linux/kernel/git/bwh/linux-stable-rc.git .
A shortlog and diffstat can be found below.

Ben.

-------------

Amit Klein (1):
      inet: update the IP ID generation algorithm to higher standards.
         [355b98553789b646ed97ad801a619ff898471b92]

Arend Van Spriel (1):
      brcmfmac: add length checks in scheduled scan result handler
         [4835f37e3bafc138f8bfa3cbed2920dd56fed283]

Ben Hutchings (3):
      Revert "brcmfmac: assure SSID length from firmware is limited"
         [not upstream; reverts incorrect backport]
      timer/debug: Change /proc/timer_stats from 0644 to 0600
         [not upstream; code was removed upstream]
      vxlan: Fix big-endian declaration of VNI
         [54bfd872bf16d40b61bd0cd9b769b2fef67dd272]

David Herrmann (1):
      fork: record start_time late
         [7b55851367136b1efd84d98fea81ba57a98304cf]

Eric Dumazet (1):
      ipv4: fix a race in update_or_create_fnhe()
         [caa415270c732505240bb60171c44a7838c555e8]

Joerg Roedel (1):
      KVM: VMX: Fix x2apic check in  vmx_msr_bitmap_mode()
         [not upstream; fixes incorrect backport]

Matteo Croce (1):
      percpu: stop printing kernel addresses
         [00206a69ee32f03e6f40837684dcbe475ea02266]

Nick Krause (1):
      spi: omap-100k: Remove unused definitions
         [9f5b8b4f56dd194fd33021810636879036d2acdd]

 Makefile                                              |  4 ++--
 arch/x86/kvm/vmx.c                                    |  4 +++-
 drivers/net/vxlan.c                                   |  2 +-
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c | 16 +++++++++++-----
 drivers/spi/spi-omap-100k.c                           |  4 ----
 include/net/ip_fib.h                                  |  2 +-
 kernel/fork.c                                         | 15 ++++++++++++---
 kernel/time/timer_stats.c                             |  2 +-
 mm/percpu.c                                           |  8 ++++----
 net/ipv4/fib_semantics.c                              |  8 +++++---
 net/ipv4/route.c                                      | 10 ++++++----
 net/ipv6/ip6_output.c                                 |  3 +++
 12 files changed, 49 insertions(+), 29 deletions(-)

-- 
Ben Hutchings
Any sufficiently advanced bug is indistinguishable from a feature.

