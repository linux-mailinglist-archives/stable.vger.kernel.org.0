Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72429417E1
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 00:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407783AbfFKWFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 18:05:54 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39839 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405693AbfFKWFy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jun 2019 18:05:54 -0400
Received: by mail-pg1-f194.google.com with SMTP id 196so7721469pgc.6;
        Tue, 11 Jun 2019 15:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7Wu3ARWeH0N7tMt1ULZZNE7ACTA3vj+7p8RwO0mXW5w=;
        b=cw/jpUmZPy5WIozptgv1dLvq21qcwEnTRtUAwOYGSm8xakqKYkhw4MzJTkpsKcdiVv
         nhnv+JQ+K9aOZv6VDKz5akN67BbsE1BVPTm4Jg11L6iSuy8FnE0r6F4AGHcQE+4OER7I
         R+V6bM/Gf++ogpksD0Lrq5FjI3Xb3o6zZZNyuYu1dYyqiroQciAdk146P4a/i3m45lK3
         Ps92NzLf88ecEIyYjEkegnubTdClKRdykwIxpfSzafscqNPJrL+vP8VBjF5dAbkld29b
         tcZb9P3fbgQcAAuxoJdeyFQ0whAYP7YSqgvLQ7IPFGGVak1Ncn6sAKs5uXOUhvyuMN9R
         8SKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7Wu3ARWeH0N7tMt1ULZZNE7ACTA3vj+7p8RwO0mXW5w=;
        b=ieYo7FSLCoF1ayByU5+5a6Eg8aIH7TRGqc/jWH7BwjaHV4gFUTaUiHc8ePRgNbQDbS
         lzX4xCWfIEfxRlH3Iwwlb89VxSzp2Os4UY7UENHEprHXxplkfTNonTEUjg4u25UwX5tL
         aQtUALGXzYP/EsB7RkWN9K6C8xXTysfbo0AK/U9GP0vgr/v6ZOxXARPUpRNWyL8vkH0F
         JnMz3J6LLP0eOwsk32nJhaQglLJOQM2kiVkRf9l8gdeA6Xjnf4miJnc7zJmU4jfC/6I9
         Ha34jRT14Oqod08gvWVpie8zo2GxQlhnYgBJDSa/+TswkfsXXTFjMOpTmx0XvxSk8QH5
         Fdaw==
X-Gm-Message-State: APjAAAWlmOTb4HXEHRILDoSuyZPFvO0AmFArm02NrR/P/4mvHgAINfwg
        kFQjW3BRE0+CpTbcPzZoHnDuT4mfBzw=
X-Google-Smtp-Source: APXvYqxK4WMjsYHhhCkb6FuyOpwZP2pK536VKANCAbkbu6AdxNgE0aALhBVcSrwVRyz3YaCCCQU0PQ==
X-Received: by 2002:a17:90a:2561:: with SMTP id j88mr29223979pje.121.1560290753643;
        Tue, 11 Jun 2019 15:05:53 -0700 (PDT)
Received: from Gentoo ([103.231.90.171])
        by smtp.gmail.com with ESMTPSA id s66sm28242812pgs.87.2019.06.11.15.05.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 15:05:52 -0700 (PDT)
Date:   Wed, 12 Jun 2019 03:35:36 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 5.1.9
Message-ID: <20190611220536.GA19727@Gentoo>
References: <20190611133418.GA17369@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
In-Reply-To: <20190611133418.GA17369@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Thanks, a bunch Greg!

On 15:34 Tue 11 Jun , Greg KH wrote:
>I'm announcing the release of the 5.1.9 kernel.
>
>All users of the 5.1 kernel series must upgrade.
>
>The updated 5.1.y git tree can be found at:
>	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git lin=
ux-5.1.y
>and can be browsed at the normal kernel.org git web browser:
>	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3D=
summary
>
>thanks,
>
>greg k-h
>
>------------
>
> Makefile                                                          |    2
> arch/arc/mm/fault.c                                               |    9
> arch/mips/mm/mmap.c                                               |    5
> arch/mips/pistachio/Platform                                      |    1
> arch/parisc/kernel/alternative.c                                  |    3
> arch/s390/mm/fault.c                                              |    5
> arch/x86/lib/insn-eval.c                                          |   47 =
++--
> arch/x86/power/cpu.c                                              |   10 +
> arch/x86/power/hibernate.c                                        |   33 =
+++
> drivers/block/xen-blkfront.c                                      |   38 =
+--
> drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c                          |    3
> drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c                           |   19 +
> drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c                           |    4
> drivers/gpu/drm/amd/amdgpu/soc15.c                                |    5
> drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                 |    3
> drivers/gpu/drm/amd/display/include/dal_asic_id.h                 |    7
> drivers/gpu/drm/drm_atomic_helper.c                               |   22 =
+-
> drivers/gpu/drm/drm_connector.c                                   |    6
> drivers/gpu/drm/drm_edid.c                                        |   25 =
++
> drivers/gpu/drm/gma500/cdv_intel_lvds.c                           |    3
> drivers/gpu/drm/gma500/intel_bios.c                               |    3
> drivers/gpu/drm/gma500/psb_drv.h                                  |    1
> drivers/gpu/drm/i915/gvt/gtt.c                                    |    6
> drivers/gpu/drm/i915/gvt/scheduler.c                              |   19 +
> drivers/gpu/drm/i915/i915_reg.h                                   |    6
> drivers/gpu/drm/i915/intel_fbc.c                                  |    4
> drivers/gpu/drm/i915/intel_workarounds.c                          |    2
> drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c                        |    4
> drivers/gpu/drm/nouveau/Kconfig                                   |   13 +
> drivers/gpu/drm/nouveau/nouveau_drm.c                             |    7
> drivers/gpu/drm/radeon/radeon_display.c                           |    4
> drivers/gpu/drm/rockchip/rockchip_drm_vop.c                       |   51 =
++---
> drivers/gpu/drm/vc4/vc4_plane.c                                   |    2
> drivers/i2c/busses/i2c-xiic.c                                     |    5
> drivers/memstick/core/mspro_block.c                               |   13 -
> drivers/misc/genwqe/card_dev.c                                    |    2
> drivers/misc/genwqe/card_utils.c                                  |    4
> drivers/misc/habanalabs/debugfs.c                                 |   60 =
+-----
> drivers/mmc/host/sdhci_am654.c                                    |    2
> drivers/mmc/host/tmio_mmc_core.c                                  |    3
> drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c      |   14 -
> drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c |    4
> drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c                   |    4
> drivers/net/ethernet/mellanox/mlx4/en_ethtool.c                   |    4
> drivers/net/ethernet/mellanox/mlx4/port.c                         |    5
> drivers/net/ethernet/ti/cpsw.c                                    |    1
> drivers/net/phy/sfp.c                                             |   24 =
++
> drivers/nvme/host/rdma.c                                          |   99 =
++++++----
> drivers/parisc/ccio-dma.c                                         |    4
> drivers/parisc/sba_iommu.c                                        |    3
> drivers/tty/serial/serial_core.c                                  |   24 =
+-
> fs/fuse/file.c                                                    |   14 +
> fs/nfs/nfs4proc.c                                                 |   32 =
+--
> fs/pstore/platform.c                                              |    7
> fs/pstore/ram.c                                                   |   36 =
++-
> include/drm/drm_modeset_helper_vtables.h                          |    8
> include/linux/cpu.h                                               |    4
> include/linux/rcupdate.h                                          |    6
> include/net/arp.h                                                 |    8
> include/net/ip6_fib.h                                             |    3
> include/net/tls.h                                                 |    4
> include/uapi/drm/i915_drm.h                                       |    2
> kernel/cpu.c                                                      |    4
> kernel/power/hibernate.c                                          |    9
> lib/test_firmware.c                                               |   14 -
> net/core/ethtool.c                                                |    5
> net/core/fib_rules.c                                              |    6
> net/core/neighbour.c                                              |   11 +
> net/core/pktgen.c                                                 |   11 +
> net/ipv4/ipmr_base.c                                              |    3
> net/ipv4/route.c                                                  |   22 =
+-
> net/ipv4/udp.c                                                    |    3
> net/ipv6/raw.c                                                    |   25 =
+-
> net/packet/af_packet.c                                            |    2
> net/rds/ib_rdma.c                                                 |   10 -
> net/sched/cls_matchall.c                                          |    3
> net/sctp/sm_make_chunk.c                                          |   13 -
> net/sctp/sm_sideeffect.c                                          |    5
> net/sunrpc/clnt.c                                                 |   30 =
+--
> net/tls/tls_device.c                                              |   27 =
++
> scripts/Kbuild.include                                            |    7
> 81 files changed, 619 insertions(+), 362 deletions(-)
>
>Aaron Liu (1):
>      drm/amdgpu: remove ATPX_DGPU_REQ_POWER_FOR_DISPLAYS check when hotpl=
ug-in
>
>Alex Deucher (2):
>      drm/amdgpu/psp: move psp version specific function pointers to early=
_init
>      drm/amdgpu/soc15: skip reset on init
>
>Andres Rodriguez (1):
>      drm: add non-desktop quirk for Valve HMDs
>
>Chris Wilson (1):
>      drm/i915: Fix I915_EXEC_RING_MASK
>
>Christian K=F6nig (1):
>      drm/radeon: prefer lower reference dividers
>
>Dan Carpenter (3):
>      memstick: mspro_block: Fix an error code in mspro_block_issue_req()
>      genwqe: Prevent an integer overflow in the ioctl
>      test_firmware: Use correct snprintf() limit
>
>Daniel Drake (1):
>      drm/i915/fbc: disable framebuffer compression on GeminiLake
>
>Dave Airlie (1):
>      drm/nouveau: add kconfig option to turn off nouveau legacy contexts.=
 (v3)
>
>David Ahern (4):
>      neighbor: Reset gc_entries counter if new entry is released before i=
nsert
>      neighbor: Call __ipv4_neigh_lookup_noref in neigh_xmit
>      ipmr_base: Do not reset index in mr_table_dump
>      ipv4: Define __ipv4_neigh_lookup_noref when CONFIG_INET is disabled
>
>Erez Alfasi (1):
>      net/mlx4_en: ethtool, Remove unsupported SFP EEPROM high pages query
>
>Eugeniy Paltsev (1):
>      ARC: mm: SIGSEGV userspace trying to access kernel virtual memory
>
>Faiz Abbas (1):
>      mmc: sdhci_am654: Fix SLOTTYPE write
>
>Gerald Schaefer (1):
>      s390/mm: fix address space detection in exception handling
>
>Greg Kroah-Hartman (1):
>      Linux 5.1.9
>
>Hangbin Liu (1):
>      Revert "fib_rules: return 0 directly if an exactly same rule exists =
when NLM_F_EXCL not supplied"
>
>Harry Wentland (1):
>      drm/amd/display: Add ASICREV_IS_PICASSO
>
>Helen Koike (5):
>      drm/rockchip: fix fb references in async update
>      drm/vc4: fix fb references in async update
>      drm/msm: fix fb references in async update
>      drm: don't block fb changes for async plane updates
>      drm/amd: fix fb references in async update
>
>Helge Deller (1):
>      parisc: Fix crash due alternative coding for NP iopdir_fdc bit
>
>Ivan Khoronzhuk (1):
>      net: ethernet: ti: cpsw_ethtool: fix ethtool ring param set
>
>Jakub Kicinski (1):
>      net/tls: replace the sleeping lock around RX resync with a bit lock
>
>Jann Horn (2):
>      habanalabs: fix debugfs code
>      x86/insn-eval: Fix use-after-free access to LDT entry
>
>Jiri Kosina (1):
>      x86/power: Fix 'nosmt' vs hibernation triple fault during resume
>
>Jiri Slaby (1):
>      TTY: serial_core, add ->install
>
>John David Anglin (1):
>      parisc: Use implicit space register selection for loading the cohere=
nce index of I/O pdirs
>
>Jonathan Corbet (1):
>      drm/i915: Maintain consistent documentation subsection ordering
>
>Kees Cook (1):
>      pstore/ram: Run without kernel crash dump region
>
>Linus Torvalds (1):
>      rcu: locking and unlocking need to always be at least barriers
>
>Louis Li (1):
>      drm/amdgpu: fix ring test failure issue during s3 in vce 3.0 (V2)
>
>Mario Kleiner (1):
>      drm: Fix timestamp docs for variable refresh properties.
>
>Masahiro Yamada (1):
>      kbuild: use more portable 'command -v' for cc-cross-prefix
>
>Matteo Croce (1):
>      cls_matchall: avoid panic when receiving a packet before filter set
>
>Maxime Chevallier (1):
>      net: mvpp2: Use strscpy to handle stat strings
>
>Miklos Szeredi (2):
>      fuse: fallocate: fix return with locked inode
>      fuse: fix copy_file_range() in the writeback case
>
>Neil Horman (1):
>      Fix memory leak in sctp_process_init
>
>Nikita Danilov (1):
>      net: aquantia: fix wol configuration not applied sometimes
>
>Olga Kornievskaia (1):
>      SUNRPC fix regression in umount of a secure mount
>
>Olivier Matz (2):
>      ipv6: use READ_ONCE() for inet->hdrincl as in ipv4
>      ipv6: fix EFAULT on sendto with icmpv6 and hdrincl
>
>Paolo Abeni (1):
>      pktgen: do not sleep with the thread lock held.
>
>Patrik Jakobsson (1):
>      drm/gma500/cdv: Check vbt config bits when detecting lvds panels
>
>Paul Burton (2):
>      MIPS: Bounds check virt_addr_valid
>      MIPS: pistachio: Build uImage.gz by default
>
>Pi-Hsun Shih (1):
>      pstore: Set tfm to NULL on free_buf_for_compression
>
>Robert Hancock (1):
>      i2c: xiic: Add max_read_len quirk
>
>Roger Pau Monne (1):
>      xen-blkfront: switch kcalloc to kvcalloc for large array allocation
>
>Russell King (1):
>      net: sfp: read eeprom in maximum 16 byte increments
>
>Ryan Pavlik (1):
>      drm: add non-desktop quirks to Sensics and OSVR headsets.
>
>Sagi Grimberg (1):
>      nvme-rdma: fix queue mapping when queue count is limited
>
>Takeshi Saito (1):
>      mmc: tmio: fix SCC error handling to avoid false positive CRC error
>
>Tim Beale (1):
>      udp: only choose unbound UDP socket for multicast when not in a VRF
>
>Tina Zhang (1):
>      drm/i915/gvt: Initialize intel_gvt_gtt_entry in stack
>
>Trond Myklebust (1):
>      SUNRPC: Fix a use after free when a server rejects the RPCSEC_GSS cr=
edential
>
>Vivien Didelot (1):
>      ethtool: fix potential userspace buffer overflow
>
>Weinan (1):
>      drm/i915/gvt: emit init breadcrumb for gvt request
>
>Willem de Bruijn (1):
>      packet: unconditionally free po->rollover
>
>Xin Long (2):
>      ipv4: not do cache for local delivery if bc_forwarding is enabled
>      ipv6: fix the check before getting the cookie in rt6_get_cookie
>
>Yihao Wu (2):
>      NFSv4.1: Again fix a race where CB_NOTIFY_LOCK fails to wake a waiter
>      NFSv4.1: Fix bug only first CB_NOTIFY_LOCK is handled
>
>Zhu Yanjun (1):
>      net: rds: fix memory leak in rds_ib_flush_mr_pool
>



--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAl0AJakACgkQsjqdtxFL
KRWDfwf8CrLg4gx6SuuxyIfXgfK/FCXEY0wD4+Ci1qD5odRgaXctm2/2WFeWAU1L
a8oNQM6RSoBcX8gQqbcU5hGNcoWzRzsrR3m1QJM6ry4+2wEQ/4QfFydE3rimIbup
EAVBBKbwwKNgatV74onCFTS3PpxNwJBzMdqmCHoRGMZdgFGU3Q3GrG1a3IEyz+mi
TFEv7opsNStsKidc9YjB0CDhiVv91H+mrIrbm5WMObHKMdQ1mmGIJmX8h1If3p4V
iurb3URV50LIZOsmgrKVwF5vHbdmrCXUQ1MNGw5CPfrMhn/EkFFMuhydVwn3DRnd
LRcZpZQl3clAC+8Dw2+LfzamXR9emw==
=RTpQ
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
