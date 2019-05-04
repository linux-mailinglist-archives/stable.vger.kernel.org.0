Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 135BB13914
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 12:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbfEDK1A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 06:27:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:36830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727318AbfEDK1A (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 May 2019 06:27:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA29F2085A;
        Sat,  4 May 2019 10:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556965619;
        bh=0frTpDyXVI2os4G/vFG4NYCHV3w8NxIMRC96qxOeHjE=;
        h=From:To:Cc:Subject:Date:From;
        b=grvTRaRcYMpLdrogtxkZb37qJgmneS19I25ibqWpFABWyMm2rJTzw+dOQtQq1JwbS
         +7g/5KYzYvGAFZgzGRGlb76drQDq96mGJ68ghzUACse8UQC7WvDAdPY/zdi/2pZhn9
         0sVsY47pwwGw1OLxBz0WeQeVOYPKc3i1N7DmDOfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.0 00/32] 5.0.13-stable review
Date:   Sat,  4 May 2019 12:24:45 +0200
Message-Id: <20190504102452.523724210@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.0.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.0.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.0.13-rc1
X-KernelTest-Deadline: 2019-05-06T10:24+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.0.13 release.
There are 32 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon 06 May 2019 10:24:23 AM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.0.13-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.0.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.0.13-rc1

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ath10k: Drop WARN_ON()s that always trigger during system resume

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    iwlwifi: mvm: properly check debugfs dentry before using it

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    ALSA: line6: use dynamic buffers

Jim Mattson <jmattson@google.com>
    KVM: nVMX: Fix size checks in vmx_set_nested_state

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Whitelist port 0x7e for pre-incrementing %rip

Jakub Kicinski <jakub.kicinski@netronome.com>
    net/tls: fix copy to fragments in reencrypt

Jakub Kicinski <jakub.kicinski@netronome.com>
    net/tls: don't copy negative amounts of data in reencrypt

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix uninitialized variable usage in bnxt_rx_pkt().

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix statistics context reservation logic.

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Pass correct extended TX port statistics size to firmware.

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix possible crash in bnxt_hwrm_ring_free() under error conditions.

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Free short FW command HWRM memory in error path in bnxt_init_one()

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Improve multicast address setup logic.

Eric Dumazet <edumazet@google.com>
    udp: fix GRO packet of death

Paolo Abeni <pabeni@redhat.com>
    udp: fix GRO reception in case of length mismatch

Eric Dumazet <edumazet@google.com>
    tcp: add sanity tests in tcp_add_backlog()

David Ahern <dsahern@gmail.com>
    selftests: fib_rule_tests: Fix icmp proto with ipv6

Willem de Bruijn <willemb@google.com>
    packet: in recvmsg msg_name return at least sizeof sockaddr_ll

Willem de Bruijn <willemb@google.com>
    packet: validate msg_namelen in send directly

Hangbin Liu <liuhangbin@gmail.com>
    selftests: fib_rule_tests: print the result and return 1 if any tests failed

Xin Long <lucien.xin@gmail.com>
    sctp: avoid running the sctp state machine recursively

David Howells <dhowells@redhat.com>
    rxrpc: Fix net namespace cleanup

Jakub Kicinski <jakub.kicinski@netronome.com>
    net/tls: avoid NULL pointer deref on nskb->sk in fallback

Andrew Lunn <andrew@lunn.ch>
    net: phy: marvell: Fix buffer overrun with stats counters

Dan Carpenter <dan.carpenter@oracle.com>
    net: dsa: bcm_sf2: fix buffer overflow doing set_rxnfc

Eric Dumazet <edumazet@google.com>
    l2tp: use rcu_dereference_sk_user_data() in l2tp_udp_encap_recv()

Eric Dumazet <edumazet@google.com>
    l2ip: fix possible use-after-free

Willem de Bruijn <willemb@google.com>
    ipv6: invert flowlabel sharing check in process and user mode

Eric Dumazet <edumazet@google.com>
    ipv6/flowlabel: wait rcu grace period before put_pid()

Eric Dumazet <edumazet@google.com>
    ipv6: fix races in ip6_dst_destroy()

Martin KaFai Lau <kafai@fb.com>
    ipv6: A few fixes on dereferencing rt->from

Shmulik Ladkani <shmulik@metanetworks.com>
    ipv4: ip_do_fragment: Preserve skb_iif during fragmentation


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/x86/include/uapi/asm/kvm.h                    |  1 +
 arch/x86/kvm/vmx/nested.c                          |  4 +-
 arch/x86/kvm/x86.c                                 | 21 +++++++-
 drivers/net/dsa/bcm_sf2_cfp.c                      |  6 +++
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          | 53 +++++++++++--------
 drivers/net/phy/marvell.c                          |  6 ++-
 drivers/net/wireless/ath/ath10k/mac.c              |  4 +-
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   |  5 ++
 include/net/sctp/command.h                         |  1 -
 net/ipv4/ip_output.c                               |  1 +
 net/ipv4/tcp_ipv4.c                                | 13 ++++-
 net/ipv4/udp_offload.c                             | 16 ++++--
 net/ipv6/ip6_fib.c                                 |  4 +-
 net/ipv6/ip6_flowlabel.c                           | 22 +++++---
 net/ipv6/route.c                                   | 47 ++++++++---------
 net/l2tp/l2tp_core.c                               | 10 ++--
 net/packet/af_packet.c                             | 37 ++++++++-----
 net/rxrpc/call_object.c                            | 32 ++++++------
 net/sctp/sm_sideeffect.c                           | 29 -----------
 net/sctp/sm_statefuns.c                            | 35 ++++++++++---
 net/tls/tls_device.c                               | 39 ++++++++++----
 net/tls/tls_device_fallback.c                      |  3 +-
 sound/usb/line6/driver.c                           | 60 +++++++++++++---------
 sound/usb/line6/podhd.c                            | 21 ++++----
 sound/usb/line6/toneport.c                         | 24 ++++++---
 tools/testing/selftests/net/fib_rule_tests.sh      | 10 +++-
 27 files changed, 309 insertions(+), 199 deletions(-)


