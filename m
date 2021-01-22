Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D97F3300637
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbhAVOyr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:54:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:39964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728654AbhAVOY1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:24:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 344F423B02;
        Fri, 22 Jan 2021 14:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325126;
        bh=TrzRgvj36uja2YfiOxBMMAVfSXVN9kwQlA1jlBNCdLg=;
        h=From:To:Cc:Subject:Date:From;
        b=ZZd7xEqikiK8NK3692/gV29HvrSsvvCVkCBCcn1rtQvl5fOcMNIo0byCtCYDFVoLs
         6l7YX5n8nz2aAGwXzthPT/Gk5uhEz2dZocAKWJm7KMRgA7narTSElQOUNHG/DCOuS+
         b7VsRTqorslATxcMNI9Uc1sUbQ1KCJXxkGv9K5Sk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 5.10 00/43] 5.10.10-rc1 review
Date:   Fri, 22 Jan 2021 15:12:16 +0100
Message-Id: <20210122135735.652681690@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.10.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.10-rc1
X-KernelTest-Deadline: 2021-01-24T13:57+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.10 release.
There are 43 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 24 Jan 2021 13:57:23 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.10-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.10-rc1

Michael Hennerich <michael.hennerich@analog.com>
    spi: cadence: cache reference clock rate during probe

Christophe Leroy <christophe.leroy@csgroup.eu>
    spi: fsl: Fix driver breakage when SPI_CS_HIGH is not set in spi->mode

Ayush Sawal <ayush.sawal@chelsio.com>
    cxgb4/chtls: Fix tid stuck due to wrong update of qid

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: unbind all switches from tree when DSA master unbinds

Lorenzo Bianconi <lorenzo@kernel.org>
    mac80211: check if atf has been disabled in __ieee80211_schedule_txq

Felix Fietkau <nbd@nbd.name>
    mac80211: do not drop tx nulldata packets on encrypted links

Antonio Borneo <antonio.borneo@st.com>
    drm/panel: otm8009a: allow using non-continuous dsi clock

Qinglang Miao <miaoqinglang@huawei.com>
    can: mcp251xfd: mcp251xfd_handle_rxif_one(): fix wrong NULL pointer check

Seb Laveze <sebastien.laveze@nxp.com>
    net: stmmac: use __napi_schedule() for PREEMPT_RT

David Howells <dhowells@redhat.com>
    rxrpc: Fix handling of an unsupported token type in rxrpc_read()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: clear devlink port type before unregistering slave netdevs

Marco Felsch <m.felsch@pengutronix.de>
    net: phy: smsc: fix clk error handling

Geert Uytterhoeven <geert+renesas@glider.be>
    dt-bindings: net: renesas,etheravb: RZ/G2H needs tx-internal-delay-ps

Eric Dumazet <edumazet@google.com>
    net: avoid 32 x truesize under-estimation for tiny skbs

Yannick Vignon <yannick.vignon@nxp.com>
    net: stmmac: fix taprio configuration when base_time is in the past

Yannick Vignon <yannick.vignon@nxp.com>
    net: stmmac: fix taprio schedule configuration

Jakub Kicinski <kuba@kernel.org>
    net: sit: unregister_netdevice on newlink's error path

David Wu <david.wu@rock-chips.com>
    net: stmmac: Fixed mtu channged by cache aligned

Cristian Dumitrescu <cristian.dumitrescu@intel.com>
    i40e: fix potential NULL pointer dereferencing

Baptiste Lepers <baptiste.lepers@gmail.com>
    rxrpc: Call state should be read with READ_ONCE() under some circumstances

Petr Machata <petrm@nvidia.com>
    net: dcb: Accept RTM_GETDCB messages carrying set-like DCB commands

Petr Machata <me@pmachata.org>
    net: dcb: Validate netlink message in DCB handler

Willem de Bruijn <willemb@google.com>
    esp: avoid unneeded kmap_atomic call

Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>
    rndis_host: set proper input size for OID_GEN_PHYSICAL_MEDIUM request

Stefan Chulski <stefanc@marvell.com>
    net: mvpp2: Remove Pause and Asym_Pause support

Vadim Pasternak <vadimp@nvidia.com>
    mlxsw: core: Increase critical threshold for ASIC thermal zone

Vadim Pasternak <vadimp@nvidia.com>
    mlxsw: core: Add validation of transceiver temperature thresholds

Hoang Le <hoang.h.le@dektech.com.au>
    tipc: fix NULL deref in tipc_link_xmit()

Aya Levin <ayal@nvidia.com>
    net: ipv6: Validate GSO SKB before finish IPv6 processing

Manish Chopra <manishc@marvell.com>
    netxen_nic: fix MSI/MSI-x interrupts

Baptiste Lepers <baptiste.lepers@gmail.com>
    udp: Prevent reuseport_select_sock from reading uninitialized socks

Dongseok Yi <dseok.yi@samsung.com>
    net: fix use-after-free when UDP GRO with shared fraglist

Stephan Gerhold <stephan@gerhold.net>
    net: ipa: modem: add missing SET_NETDEV_DEV() for proper sysfs links

Mircea Cirjaliu <mcirjaliu@bitdefender.com>
    bpf: Fix helper bpf_map_peek_elem_proto pointing to wrong callback

Gilad Reti <gilad.reti@gmail.com>
    bpf: Support PTR_TO_MEM{,_OR_NULL} register spilling

Stanislav Fomichev <sdf@google.com>
    bpf: Don't leak memory in bpf getsockopt when optlen == 0

J. Bruce Fields <bfields@redhat.com>
    nfsd4: readdirplus shouldn't return parent of export

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    X.509: Fix crash caused by NULL pointer

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix signed_{sub,add32}_overflows type handling

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/display: drop DCN support for aarch64

Dexuan Cui <decui@microsoft.com>
    x86/hyperv: Initialize clockevents after LAPIC is initialized

Andrei Matei <andreimatei1@gmail.com>
    bpf: Fix selftest compilation on clang 11

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "kconfig: remove 'kvmconfig' and 'xenconfig' shorthands"


-------------

Diffstat:

 .../devicetree/bindings/net/renesas,etheravb.yaml  |  1 +
 Makefile                                           |  4 +-
 arch/x86/hyperv/hv_init.c                          | 29 +++++++-
 crypto/asymmetric_keys/public_key.c                |  3 +-
 drivers/gpu/drm/amd/display/Kconfig                |  2 +-
 drivers/gpu/drm/amd/display/dc/calcs/Makefile      |  7 --
 drivers/gpu/drm/amd/display/dc/clk_mgr/Makefile    |  7 --
 drivers/gpu/drm/amd/display/dc/dcn10/Makefile      |  7 --
 .../gpu/drm/amd/display/dc/dcn10/dcn10_resource.c  | 81 +++++++++-------------
 drivers/gpu/drm/amd/display/dc/dcn20/Makefile      |  4 --
 drivers/gpu/drm/amd/display/dc/dcn21/Makefile      |  4 --
 drivers/gpu/drm/amd/display/dc/dml/Makefile        | 13 ----
 drivers/gpu/drm/amd/display/dc/dsc/Makefile        |  5 --
 drivers/gpu/drm/amd/display/dc/os_types.h          |  4 --
 drivers/gpu/drm/panel/panel-orisetech-otm8009a.c   |  2 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |  2 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h        |  7 ++
 .../ethernet/chelsio/inline_crypto/chtls/chtls.h   |  4 ++
 .../chelsio/inline_crypto/chtls/chtls_cm.c         | 32 ++++++++-
 .../chelsio/inline_crypto/chtls/chtls_hw.c         | 41 +++++++++++
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |  2 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |  2 -
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c | 13 ++--
 .../net/ethernet/qlogic/netxen/netxen_nic_main.c   |  7 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c       | 52 ++------------
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  7 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    | 20 +++++-
 drivers/net/ipa/ipa_modem.c                        |  1 +
 drivers/net/phy/smsc.c                             |  3 +-
 drivers/net/usb/rndis_host.c                       |  2 +-
 drivers/spi/spi-cadence.c                          |  6 +-
 drivers/spi/spi-fsl-spi.c                          |  5 +-
 fs/nfsd/nfs3xdr.c                                  |  7 +-
 kernel/bpf/cgroup.c                                |  5 +-
 kernel/bpf/helpers.c                               |  2 +-
 kernel/bpf/verifier.c                              |  8 ++-
 net/core/skbuff.c                                  | 29 +++++++-
 net/core/sock_reuseport.c                          |  2 +-
 net/dcb/dcbnl.c                                    |  2 +
 net/dsa/dsa2.c                                     |  4 ++
 net/dsa/master.c                                   | 10 +++
 net/ipv4/esp4.c                                    |  7 +-
 net/ipv6/esp6.c                                    |  7 +-
 net/ipv6/ip6_output.c                              | 41 ++++++++++-
 net/ipv6/sit.c                                     |  5 +-
 net/mac80211/tx.c                                  |  4 +-
 net/rxrpc/input.c                                  |  2 +-
 net/rxrpc/key.c                                    |  6 +-
 net/tipc/link.c                                    |  9 ++-
 scripts/kconfig/Makefile                           | 10 +++
 tools/testing/selftests/bpf/progs/profiler.inc.h   |  2 +
 51 files changed, 323 insertions(+), 218 deletions(-)


