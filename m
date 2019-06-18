Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4454A3EE
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 16:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729485AbfFRO3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 10:29:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50484 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729381AbfFRO3G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jun 2019 10:29:06 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hdF6e-0007nD-4h; Tue, 18 Jun 2019 15:29:04 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hdF6d-0000HG-Bs; Tue, 18 Jun 2019 15:29:03 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     torvalds@linux-foundation.org, Guenter Roeck <linux@roeck-us.net>,
        akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>
Date:   Tue, 18 Jun 2019 15:27:59 +0100
Message-ID: <lsq.1560868079.359853905@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 00/10] 3.16.69-rc1 review
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 3.16.69 release.
There are 10 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Jun 20 14:27:59 UTC 2019.
Anything received after that time might be too late.

All the patches have also been committed to the linux-3.16.y-rc branch of
https://git.kernel.org/pub/scm/linux/kernel/git/bwh/linux-stable-rc.git .
A shortlog and diffstat can be found below.

Ben.

-------------

Dan Carpenter (1):
      drivers/virt/fsl_hypervisor.c: prevent integer overflow in ioctl
         [6a024330650e24556b8a18cc654ad00cfecf6c6c]

Eric Dumazet (4):
      tcp: add tcp_min_snd_mss sysctl
         [5f3e2bf008c2221478101ee72f5cb4654b9fc363]
      tcp: enforce tcp_min_snd_mss in tcp_mtu_probing()
         [967c05aee439e6e5d7d805e195b3a20ef5c433d6]
      tcp: limit payload size of sacked skbs
         [3b4929f65b0d8249f19a50245cd88ed1a2f78cff]
      tcp: tcp_fragment() should apply sane memory limits
         [f070ef2ac66716357066b683fb0baf55f8191a2e]

Jason Yan (1):
      scsi: megaraid_sas: return error when create DMA pool failed
         [bcf3b67d16a4c8ffae0aa79de5853435e683945c]

Jiri Kosina (1):
      mm/mincore.c: make mincore() more conservative
         [134fca9063ad4851de767d1768180e5dede9a881]

Oleg Nesterov (1):
      mm: introduce vma_is_anonymous(vma) helper
         [b5330628546616af14ff23075fbf8d4ad91f6e25]

Sriram Rajagopalan (1):
      ext4: zero out the unused memory region in the extent tree block
         [592acbf16821288ecdc4192c47e3774a4c48bb64]

Young Xiao (1):
      Bluetooth: hidp: fix buffer overflow
         [a1616a5ac99ede5d605047a9012481ce7ff18b16]

 Documentation/networking/ip-sysctl.txt    |  8 ++++++++
 Makefile                                  |  4 ++--
 drivers/scsi/megaraid/megaraid_sas_base.c |  1 +
 drivers/virt/fsl_hypervisor.c             |  3 +++
 fs/ext4/extents.c                         | 17 +++++++++++++++--
 include/linux/mm.h                        |  5 +++++
 include/linux/tcp.h                       |  3 +++
 include/net/tcp.h                         |  3 +++
 include/uapi/linux/snmp.h                 |  1 +
 mm/memory.c                               |  8 ++++----
 mm/mincore.c                              | 21 +++++++++++++++++++++
 net/bluetooth/hidp/sock.c                 |  1 +
 net/ipv4/proc.c                           |  1 +
 net/ipv4/sysctl_net_ipv4.c                | 11 +++++++++++
 net/ipv4/tcp.c                            |  1 +
 net/ipv4/tcp_input.c                      | 27 ++++++++++++++++++++++-----
 net/ipv4/tcp_output.c                     |  9 +++++++--
 net/ipv4/tcp_timer.c                      |  1 +
 18 files changed, 110 insertions(+), 15 deletions(-)

-- 
Ben Hutchings
I'm always amazed by the number of people who take up solipsism because
they heard someone else explain it. - E*Borg on alt.fan.pratchett

