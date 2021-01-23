Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9612630164D
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 16:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbhAWPWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jan 2021 10:22:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:43784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726160AbhAWPVu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 23 Jan 2021 10:21:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AAAC23437;
        Sat, 23 Jan 2021 15:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611415257;
        bh=luu6U+KX4EoWNbWpe6F98dkaij8n9XgRxy4J1PBRfYM=;
        h=From:To:Cc:Subject:Date:From;
        b=jDW5gKkLioM8o4gyUEOXpXpKnNqfLv0ubuy1mGSQJ3t5+pnVy8eqVmnYb8Y2QEu5M
         LZkrDIgirzHe2WWpbj5UrFunKgEpM2jwKsBz/gCy9WyVNI68JdKPbPqMmUd9JTl4Gf
         qMsT7UVyD9x9noz2KlTfhv/fUPAtutygI9paXL+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.10
Date:   Sat, 23 Jan 2021 16:20:51 +0100
Message-Id: <161141525137177@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.10 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/net/renesas,etheravb.yaml |    1 
 Makefile                                                    |    2 
 arch/x86/hyperv/hv_init.c                                   |   29 +++-
 crypto/asymmetric_keys/public_key.c                         |    3 
 drivers/gpu/drm/amd/display/Kconfig                         |    2 
 drivers/gpu/drm/amd/display/dc/calcs/Makefile               |    7 -
 drivers/gpu/drm/amd/display/dc/clk_mgr/Makefile             |    7 -
 drivers/gpu/drm/amd/display/dc/dcn10/Makefile               |    7 -
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_resource.c       |   81 ++++--------
 drivers/gpu/drm/amd/display/dc/dcn20/Makefile               |    4 
 drivers/gpu/drm/amd/display/dc/dcn21/Makefile               |    4 
 drivers/gpu/drm/amd/display/dc/dml/Makefile                 |   13 -
 drivers/gpu/drm/amd/display/dc/dsc/Makefile                 |    5 
 drivers/gpu/drm/amd/display/dc/os_types.h                   |    4 
 drivers/gpu/drm/panel/panel-orisetech-otm8009a.c            |    2 
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c              |    2 
 drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h                 |    7 +
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls.h    |    4 
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c |   32 ++++
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_hw.c |   41 ++++++
 drivers/net/ethernet/intel/i40e/i40e_xsk.c                  |    2 
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c             |    2 
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c          |   13 +
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c        |    7 -
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c                |   52 -------
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c           |    7 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c             |   20 ++
 drivers/net/ipa/ipa_modem.c                                 |    1 
 drivers/net/phy/smsc.c                                      |    3 
 drivers/net/usb/rndis_host.c                                |    2 
 drivers/spi/spi-cadence.c                                   |    6 
 drivers/spi/spi-fsl-spi.c                                   |    5 
 fs/nfsd/nfs3xdr.c                                           |    7 -
 kernel/bpf/cgroup.c                                         |    5 
 kernel/bpf/helpers.c                                        |    2 
 kernel/bpf/verifier.c                                       |    8 -
 net/core/skbuff.c                                           |   29 +++-
 net/core/sock_reuseport.c                                   |    2 
 net/dcb/dcbnl.c                                             |    2 
 net/dsa/dsa2.c                                              |    4 
 net/dsa/master.c                                            |   10 +
 net/ipv4/esp4.c                                             |    7 -
 net/ipv6/esp6.c                                             |    7 -
 net/ipv6/ip6_output.c                                       |   41 +++++-
 net/ipv6/sit.c                                              |    5 
 net/mac80211/tx.c                                           |    4 
 net/rxrpc/input.c                                           |    2 
 net/rxrpc/key.c                                             |    6 
 net/tipc/link.c                                             |    9 +
 scripts/kconfig/Makefile                                    |   10 +
 tools/testing/selftests/bpf/progs/profiler.inc.h            |    2 
 51 files changed, 322 insertions(+), 217 deletions(-)

Alex Deucher (1):
      drm/amdgpu/display: drop DCN support for aarch64

Andrei Matei (1):
      bpf: Fix selftest compilation on clang 11

Andrey Zhizhikin (1):
      rndis_host: set proper input size for OID_GEN_PHYSICAL_MEDIUM request

Antonio Borneo (1):
      drm/panel: otm8009a: allow using non-continuous dsi clock

Aya Levin (1):
      net: ipv6: Validate GSO SKB before finish IPv6 processing

Ayush Sawal (1):
      cxgb4/chtls: Fix tid stuck due to wrong update of qid

Baptiste Lepers (2):
      udp: Prevent reuseport_select_sock from reading uninitialized socks
      rxrpc: Call state should be read with READ_ONCE() under some circumstances

Christophe Leroy (1):
      spi: fsl: Fix driver breakage when SPI_CS_HIGH is not set in spi->mode

Cristian Dumitrescu (1):
      i40e: fix potential NULL pointer dereferencing

Daniel Borkmann (1):
      bpf: Fix signed_{sub,add32}_overflows type handling

David Howells (1):
      rxrpc: Fix handling of an unsupported token type in rxrpc_read()

David Wu (1):
      net: stmmac: Fixed mtu channged by cache aligned

Dexuan Cui (1):
      x86/hyperv: Initialize clockevents after LAPIC is initialized

Dongseok Yi (1):
      net: fix use-after-free when UDP GRO with shared fraglist

Eric Dumazet (1):
      net: avoid 32 x truesize under-estimation for tiny skbs

Felix Fietkau (1):
      mac80211: do not drop tx nulldata packets on encrypted links

Geert Uytterhoeven (1):
      dt-bindings: net: renesas,etheravb: RZ/G2H needs tx-internal-delay-ps

Gilad Reti (1):
      bpf: Support PTR_TO_MEM{,_OR_NULL} register spilling

Greg Kroah-Hartman (2):
      Revert "kconfig: remove 'kvmconfig' and 'xenconfig' shorthands"
      Linux 5.10.10

Hoang Le (1):
      tipc: fix NULL deref in tipc_link_xmit()

J. Bruce Fields (1):
      nfsd4: readdirplus shouldn't return parent of export

Jakub Kicinski (1):
      net: sit: unregister_netdevice on newlink's error path

Lorenzo Bianconi (1):
      mac80211: check if atf has been disabled in __ieee80211_schedule_txq

Manish Chopra (1):
      netxen_nic: fix MSI/MSI-x interrupts

Marco Felsch (1):
      net: phy: smsc: fix clk error handling

Michael Hennerich (1):
      spi: cadence: cache reference clock rate during probe

Mircea Cirjaliu (1):
      bpf: Fix helper bpf_map_peek_elem_proto pointing to wrong callback

Petr Machata (2):
      net: dcb: Validate netlink message in DCB handler
      net: dcb: Accept RTM_GETDCB messages carrying set-like DCB commands

Qinglang Miao (1):
      can: mcp251xfd: mcp251xfd_handle_rxif_one(): fix wrong NULL pointer check

Seb Laveze (1):
      net: stmmac: use __napi_schedule() for PREEMPT_RT

Stanislav Fomichev (1):
      bpf: Don't leak memory in bpf getsockopt when optlen == 0

Stefan Chulski (1):
      net: mvpp2: Remove Pause and Asym_Pause support

Stephan Gerhold (1):
      net: ipa: modem: add missing SET_NETDEV_DEV() for proper sysfs links

Tianjia Zhang (1):
      X.509: Fix crash caused by NULL pointer

Vadim Pasternak (2):
      mlxsw: core: Add validation of transceiver temperature thresholds
      mlxsw: core: Increase critical threshold for ASIC thermal zone

Vladimir Oltean (2):
      net: dsa: clear devlink port type before unregistering slave netdevs
      net: dsa: unbind all switches from tree when DSA master unbinds

Willem de Bruijn (1):
      esp: avoid unneeded kmap_atomic call

Yannick Vignon (2):
      net: stmmac: fix taprio schedule configuration
      net: stmmac: fix taprio configuration when base_time is in the past

