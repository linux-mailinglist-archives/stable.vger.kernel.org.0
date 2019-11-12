Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87381F9E77
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 00:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfKLXuf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 18:50:35 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57290 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726954AbfKLXuf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 18:50:35 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iUfvc-0008Hy-SL; Tue, 12 Nov 2019 23:50:32 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iUfvc-00056N-B3; Tue, 12 Nov 2019 23:50:32 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     torvalds@linux-foundation.org, Guenter Roeck <linux@roeck-us.net>,
        akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>
Date:   Tue, 12 Nov 2019 23:47:57 +0000
Message-ID: <lsq.1573602477.548403712@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 00/25] 3.16.77-rc1 review
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 3.16.77 release.
There are 25 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Nov 15 00:00:00 UTC 2019.
Anything received after that time might be too late.

All the patches have also been committed to the linux-3.16.y-rc branch of
https://git.kernel.org/pub/scm/linux/kernel/git/bwh/linux-stable-rc.git .
A shortlog and diffstat can be found below.

Ben.

-------------

Ben Hutchings (1):
      KVM: Introduce kvm_get_arch_capabilities()
         [5b76a3cff011df2dcb6186c965a2e4d809a05ad4]

Hui Peng (1):
      ath6kl: fix a NULL-ptr-deref bug in ath6kl_usb_alloc_urb_from_pipe()
         [39d170b3cb62ba98567f5c4f40c27b5864b304e5]

Imre Deak (1):
      drm/i915/gen8+: Add RC6 CTX corruption WA
         [7e34f4e4aad3fd34c02b294a3cf2321adf5b4438]

Jakub Kicinski (1):
      net: netem: fix error path for corrupted GSO frames
         [a7fa12d15855904aff1716e1fc723c03ba38c5cc]

Josh Poimboeuf (1):
      x86/speculation/taa: Fix printing of TAA_MSG_SMT on  IBRS_ALL CPUs
         [012206a822a8b6ac09125bfaa210a95b9eb8f1c1]

Laura Abbott (1):
      rtlwifi: Fix potential overflow on P2P code
         [8c55dedb795be8ec0cf488f98c03a1c2176f7fb1]

Michal Hocko (1):
      x86/tsx: Add config options to set tsx=on|off|auto
         [db616173d787395787ecc93eef075fa975227b10]

Ori Nimron (5):
      appletalk: enforce CAP_NET_RAW for raw sockets
         [6cc03e8aa36c51f3b26a0d21a3c4ce2809c842ac]
      ax25: enforce CAP_NET_RAW for raw sockets
         [0614e2b73768b502fc32a75349823356d98aae2c]
      ieee802154: enforce CAP_NET_RAW for raw sockets
         [e69dbd4619e7674c1679cba49afd9dd9ac347eef]
      mISDN: enforce CAP_NET_RAW for raw sockets
         [b91ee4aa2a2199ba4d4650706c272985a5a32d80]
      nfc: enforce CAP_NET_RAW for raw sockets
         [3a359798b176183ef09efb7a3dc59abad1cc7104]

Paolo Bonzini (1):
      KVM: x86: use Intel speculation bugs and features as  derived in generic x86 code
         [0c54914d0c52a15db9954a76ce80fee32cf318f4]

Pawan Gupta (8):
      kvm/x86: Export MDS_NO=0 to guests when TSX is enabled
         [e1d38b63acd843cfdd4222bf19a26700fd5c699e]
      x86/cpu: Add a "tsx=" cmdline option with TSX disabled  by default
         [95c5824f75f3ba4c9e8e5a4b1a623c95390ac266]
      x86/cpu: Add a helper function x86_read_arch_cap_msr()
         [286836a70433fb64131d2590f4bf512097c255e1]
      x86/msr: Add the IA32_TSX_CTRL MSR
         [c2955f270a84762343000f103e0640d29c7a96f3]
      x86/speculation/taa: Add documentation for TSX Async  Abort
         [a7a248c593e4fd7a67c50b5f5318fe42a0db335e]
      x86/speculation/taa: Add mitigation for TSX Async Abort
         [1b42f017415b46c317e71d41c34ec088417a1883]
      x86/speculation/taa: Add sysfs reporting for TSX Async  Abort
         [6608b45ac5ecb56f9e171252229c39580cc85f0f]
      x86/tsx: Add "auto" option to the tsx= cmdline  parameter
         [7531a3596e3272d1f6841e0d601a614555dc6b65]

Sean Young (1):
      media: technisat-usb2: break out of loop at end of buffer
         [0c4df39e504bf925ab666132ac3c98d6cbbe380b]

Vandana BN (1):
      media: usb:zr364xx:Fix KASAN:null-ptr-deref Read in zr364xx_vidioc_querycap
         [5d2e73a5f80a5b5aff3caf1ec6d39b5b3f54b26e]

Vineela Tummalapalli (1):
      x86/bugs: Add ITLB_MULTIHIT bug infrastructure
         [db4d30fbb71b47e4ecb11c4efa5d8aad4b03dfae]

Will Deacon (1):
      cfg80211: wext: avoid copying malformed SSIDs
         [4ac2813cc867ae563a1ba5a9414bfb554e5796fa]

 Documentation/ABI/testing/sysfs-devices-system-cpu |   2 +
 Documentation/hw-vuln/tsx_async_abort.rst          | 268 +++++++++++++++++++++
 Documentation/kernel-parameters.txt                |  62 +++++
 Documentation/x86/tsx_async_abort.rst              | 117 +++++++++
 Makefile                                           |   4 +-
 arch/x86/Kconfig                                   |  45 ++++
 arch/x86/include/asm/cpufeatures.h                 |   2 +
 arch/x86/include/asm/kvm_host.h                    |   1 +
 arch/x86/include/asm/nospec-branch.h               |   4 +-
 arch/x86/include/asm/processor.h                   |   7 +
 arch/x86/include/uapi/asm/msr-index.h              |  16 ++
 arch/x86/kernel/cpu/Makefile                       |   2 +-
 arch/x86/kernel/cpu/bugs.c                         | 143 ++++++++++-
 arch/x86/kernel/cpu/common.c                       |  93 ++++---
 arch/x86/kernel/cpu/cpu.h                          |  18 ++
 arch/x86/kernel/cpu/intel.c                        |   5 +
 arch/x86/kernel/cpu/tsx.c                          | 140 +++++++++++
 arch/x86/kvm/cpuid.c                               |   7 +
 arch/x86/kvm/x86.c                                 |  40 ++-
 drivers/base/cpu.c                                 |  17 ++
 drivers/gpu/drm/i915/i915_drv.c                    |   4 +
 drivers/gpu/drm/i915/i915_drv.h                    |   5 +
 drivers/gpu/drm/i915/i915_reg.h                    |   2 +
 drivers/gpu/drm/i915/intel_display.c               |   9 +
 drivers/gpu/drm/i915/intel_drv.h                   |   3 +
 drivers/gpu/drm/i915/intel_pm.c                    | 146 ++++++++++-
 drivers/isdn/mISDN/socket.c                        |   2 +
 drivers/media/usb/dvb-usb/technisat-usb2.c         |  21 +-
 drivers/media/usb/zr364xx/zr364xx.c                |   3 +-
 drivers/net/wireless/ath/ath6kl/usb.c              |   8 +
 drivers/net/wireless/rtlwifi/ps.c                  |   6 +
 include/linux/cpu.h                                |   5 +
 net/appletalk/ddp.c                                |   5 +
 net/ax25/af_ax25.c                                 |   2 +
 net/ieee802154/af_ieee802154.c                     |   3 +
 net/nfc/llcp_sock.c                                |   7 +-
 net/sched/sch_netem.c                              |   9 +-
 net/wireless/wext-sme.c                            |   8 +-
 38 files changed, 1172 insertions(+), 69 deletions(-)

-- 
Ben Hutchings
I'm not a reverse psychological virus.
Please don't copy me into your signature.

