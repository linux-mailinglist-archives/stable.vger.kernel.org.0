Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA0E3DF594
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 21:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239878AbhHCT0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 15:26:20 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:52220 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239877AbhHCT0U (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Aug 2021 15:26:20 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id D78CD1C0B76; Tue,  3 Aug 2021 21:26:07 +0200 (CEST)
Date:   Tue, 3 Aug 2021 21:26:07 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/67] 5.10.56-rc1 review
Message-ID: <20210803192607.GA14540@duo.ucw.cz>
References: <20210802134339.023067817@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <20210802134339.023067817@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.56 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Not sure what went wrong, but 50 or so patches disappeared from the queue:

48156f3dce81b215b9d6dd524ea34f7e5e029e6b (origin/queue/5.10) btrfs: fix los=
t inode on log replay after mix of fsync, rename and inode eviction
474a423936753742c112e265b5481dddd8c02f33 btrfs: fix race causing unnecessar=
y inode logging during link and rename
2fb9fc485825505e31b634b68d4c05e193a224da Revert "drm/i915: Propagate errors=
 on awaiting already signaled fences"
b1c92988bfcb7aa46bdf8198541f305c9ff2df25 drm/i915: Revert "drm/i915/gem: As=
ynchronous cmdparser"
11fe69a17195cf58eff523f26f90de50660d0100 (tag: v5.10.55) Linux 5.10.55
984e93b8e20731f83e453dd056f8a3931b4a66e5 ipv6: ip6_finish_output2: set
sk into newly allocated nskb

Best regards,
									Pavel

> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.56=
-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-5.10.y
> and the diffstat can be found below.
>=20
> thanks,
>=20
> greg k-h
>=20
> -------------
> Pseudo-Shortlog of commits:
>=20
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 5.10.56-rc1
>=20
> Oleksij Rempel <linux@rempel-privat.de>
>     can: j1939: j1939_session_deactivate(): clarify lifetime of session o=
bject
>=20
> Lukasz Cieplicki <lukaszx.cieplicki@intel.com>
>     i40e: Add additional info to PHY type error
>=20
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     Revert "perf map: Fix dso->nsinfo refcounting"
>=20
> Srikar Dronamraju <srikar@linux.vnet.ibm.com>
>     powerpc/pseries: Fix regression while building external modules
>=20
> Steve French <stfrench@microsoft.com>
>     SMB3: fix readpage for large swap cache
>=20
> Daniel Borkmann <daniel@iogearbox.net>
>     bpf: Fix pointer arithmetic mask tightening under state pruning
>=20
> Lorenz Bauer <lmb@cloudflare.com>
>     bpf: verifier: Allocate idmap scratch in verifier env
>=20
> Daniel Borkmann <daniel@iogearbox.net>
>     bpf: Remove superfluous aux sanitation on subprog rejection
>=20
> Daniel Borkmann <daniel@iogearbox.net>
>     bpf: Fix leakage due to insufficient speculative store bypass mitigat=
ion
>=20
> Daniel Borkmann <daniel@iogearbox.net>
>     bpf: Introduce BPF nospec instruction for mitigating Spectre v4
>=20
> Dan Carpenter <dan.carpenter@oracle.com>
>     can: hi311x: fix a signedness bug in hi3110_cmd()
>=20
> Wang Hai <wanghai38@huawei.com>
>     sis900: Fix missing pci_disable_device() in probe and remove
>=20
> Wang Hai <wanghai38@huawei.com>
>     tulip: windbond-840: Fix missing pci_disable_device() in probe and re=
move
>=20
> Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
>     sctp: fix return value check in __sctp_rcv_asconf_lookup
>=20
> Dima Chumak <dchumak@nvidia.com>
>     net/mlx5e: Fix nullptr in mlx5e_hairpin_get_mdev()
>=20
> Maor Gottlieb <maorg@nvidia.com>
>     net/mlx5: Fix flow table chaining
>=20
> Cong Wang <cong.wang@bytedance.com>
>     skmsg: Make sk_psock_destroy() static
>=20
> Bjorn Andersson <bjorn.andersson@linaro.org>
>     drm/msm/dp: Initialize the INTF_CONFIG register
>=20
> Robert Foss <robert.foss@linaro.org>
>     drm/msm/dpu: Fix sm8250_mdp register length
>=20
> Pavel Skripkin <paskripkin@gmail.com>
>     net: llc: fix skb_over_panic
>=20
> Vitaly Kuznetsov <vkuznets@redhat.com>
>     KVM: x86: Check the right feature bit for MSR_KVM_ASYNC_PF_ACK access
>=20
> Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
>     mlx4: Fix missing error code in mlx4_load_one()
>=20
> Geetha sowjanya <gakula@marvell.com>
>     octeontx2-pf: Fix interface down flag on error
>=20
> Xin Long <lucien.xin@gmail.com>
>     tipc: do not write skb_shinfo frags when doing decrytion
>=20
> Shannon Nelson <snelson@pensando.io>
>     ionic: count csum_none when offload enabled
>=20
> Shannon Nelson <snelson@pensando.io>
>     ionic: fix up dim accounting for tx and rx
>=20
> Shannon Nelson <snelson@pensando.io>
>     ionic: remove intr coalesce update from napi
>=20
> Pavel Skripkin <paskripkin@gmail.com>
>     net: qrtr: fix memory leaks
>=20
> Gilad Naaman <gnaaman@drivenets.com>
>     net: Set true network header for ECN decapsulation
>=20
> Hoang Le <hoang.h.le@dektech.com.au>
>     tipc: fix sleeping in tipc accept routine
>=20
> Xin Long <lucien.xin@gmail.com>
>     tipc: fix implicit-connect for SYN+
>=20
> Jedrzej Jagielski <jedrzej.jagielski@intel.com>
>     i40e: Fix log TC creation failure when max num of queues is exceeded
>=20
> Jedrzej Jagielski <jedrzej.jagielski@intel.com>
>     i40e: Fix queue-to-TC mapping on Tx
>=20
> Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>     i40e: Fix firmware LLDP agent related warning
>=20
> Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>     i40e: Fix logic of disabling queues
>=20
> Pablo Neira Ayuso <pablo@netfilter.org>
>     netfilter: nft_nat: allow to specify layer 4 protocol NAT only
>=20
> Florian Westphal <fw@strlen.de>
>     netfilter: conntrack: adjust stop timestamp to real expiry value
>=20
> Felix Fietkau <nbd@nbd.name>
>     mac80211: fix enabling 4-address mode on a sta vif after assoc
>=20
> Lorenz Bauer <lmb@cloudflare.com>
>     bpf: Fix OOB read when printing XDP link fdinfo
>=20
> Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>
>     RDMA/bnxt_re: Fix stats counters
>=20
> Nguyen Dinh Phi <phind.uet@gmail.com>
>     cfg80211: Fix possible memory leak in function cfg80211_bss_update
>=20
> Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>     nfc: nfcsim: fix use after free during module unload
>=20
> Tejun Heo <tj@kernel.org>
>     blk-iocost: fix operation ordering in iocg_wake_fn()
>=20
> Jiri Kosina <jkosina@suse.cz>
>     drm/amdgpu: Fix resource leak on probe error path
>=20
> Jiri Kosina <jkosina@suse.cz>
>     drm/amdgpu: Avoid printing of stack contents on firmware load error
>=20
> Dale Zhao <dale.zhao@amd.com>
>     drm/amd/display: ensure dentist display clock update finished in DCN20
>=20
> Paul Jakma <paul@jakma.org>
>     NIU: fix incorrect error return, missed in previous revert
>=20
> Jason Gerecke <killertofu@gmail.com>
>     HID: wacom: Re-enable touch by default for Cintiq 24HDT / 27QHDT
>=20
> Mike Rapoport <rppt@kernel.org>
>     alpha: register early reserved memory in memblock
>=20
> Pavel Skripkin <paskripkin@gmail.com>
>     can: esd_usb2: fix memory leak
>=20
> Pavel Skripkin <paskripkin@gmail.com>
>     can: ems_usb: fix memory leak
>=20
> Pavel Skripkin <paskripkin@gmail.com>
>     can: usb_8dev: fix memory leak
>=20
> Pavel Skripkin <paskripkin@gmail.com>
>     can: mcba_usb_start(): add missing urb->transfer_dma initialization
>=20
> Stephane Grosjean <s.grosjean@peak-system.com>
>     can: peak_usb: pcan_usb_handle_bus_evt(): fix reading rxerr/txerr val=
ues
>=20
> Ziyang Xuan <william.xuanziyang@huawei.com>
>     can: raw: raw_setsockopt(): fix raw_rcv panic for sock UAF
>=20
> Zhang Changzhong <zhangchangzhong@huawei.com>
>     can: j1939: j1939_xtp_rx_dat_one(): fix rxtimer value between consecu=
tive TP.DT to 750ms
>=20
> Junxiao Bi <junxiao.bi@oracle.com>
>     ocfs2: issue zeroout to EOF blocks
>=20
> Junxiao Bi <junxiao.bi@oracle.com>
>     ocfs2: fix zero out valid data
>=20
> Paolo Bonzini <pbonzini@redhat.com>
>     KVM: add missing compat KVM_CLEAR_DIRTY_LOG
>=20
> Juergen Gross <jgross@suse.com>
>     x86/kvm: fix vcpu-id indexed array sizes
>=20
> Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
>     ACPI: DPTF: Fix reading of attributes
>=20
> Hui Wang <hui.wang@canonical.com>
>     Revert "ACPI: resources: Add checks for ACPI IRQ override"
>=20
> Goldwyn Rodrigues <rgoldwyn@suse.de>
>     btrfs: mark compressed range uptodate only if all bio succeed
>=20
> Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
>     btrfs: fix rw device counting in __btrfs_free_extra_devids
>=20
> Linus Torvalds <torvalds@linux-foundation.org>
>     pipe: make pipe writes always wake up readers
>=20
> Jan Kiszka <jan.kiszka@siemens.com>
>     x86/asm: Ensure asm/proto.h can be included stand-alone
>=20
> Yang Yingliang <yangyingliang@huawei.com>
>     io_uring: fix null-ptr-deref in io_sq_offload_start()

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYQmYTwAKCRAw5/Bqldv6
8i3VAKCPH0pMFgqpM4423295GKHGxLSGWwCcC8JkkUYEiJfdG3aRw/Q7JWvJ8p4=
=+isM
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
