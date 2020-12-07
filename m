Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 253142D0A40
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 06:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725802AbgLGFgZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 00:36:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:59754 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725681AbgLGFgZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Dec 2020 00:36:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1607319337; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SlqEwKkshET0nQ8kpRs2olYJF5K/bt1gdgtQI5Gp+F4=;
        b=nqYBqpXfgqRr+33q10Krux50tmOacjuAucpK22uUjYS0RL+dB6isCfmKuww+SPDYdXwD8C
        0of14QowTzPaWvK2t210QzCVEpfAEcfqwTBEDab27UQyEVxF2WhSKaqmqybhiHBmsnmBs8
        cEmS2KOsG7t94BJqwz/aN2wIPLrZ2zM=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6B325AC9A;
        Mon,  7 Dec 2020 05:35:37 +0000 (UTC)
Subject: Re: [PATCH] Revert "xen: add helpers to allocate unpopulated memory"
To:     =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= 
        <marmarek@invisiblethingslab.com>, xen-devel@lists.xenproject.org
Cc:     stable@vger.kernel.org,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Simon Leiner <simon@leiner.me>,
        Yan Yankovskyi <yyankovskyi@gmail.com>,
        Roger Pau Monne <roger.pau@citrix.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:DRM DRIVERS FOR XEN" <dri-devel@lists.freedesktop.org>
References: <20201206172242.1249689-1-marmarek@invisiblethingslab.com>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <e04a91c2-3e2e-7052-14fc-9915f9cf6589@suse.com>
Date:   Mon, 7 Dec 2020 06:35:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201206172242.1249689-1-marmarek@invisiblethingslab.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6ekrWC7Imvf7QM0ISrUV82GBc9sxpxUVx"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6ekrWC7Imvf7QM0ISrUV82GBc9sxpxUVx
Content-Type: multipart/mixed; boundary="eZcwrVuZPjphx6y9vxccT9GtWokI6VlsT";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?=
 <marmarek@invisiblethingslab.com>, xen-devel@lists.xenproject.org
Cc: stable@vger.kernel.org,
 Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>,
 David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Stefano Stabellini <sstabellini@kernel.org>, Simon Leiner <simon@leiner.me>,
 Yan Yankovskyi <yyankovskyi@gmail.com>,
 Roger Pau Monne <roger.pau@citrix.com>,
 Dan Carpenter <dan.carpenter@oracle.com>,
 open list <linux-kernel@vger.kernel.org>,
 "open list:DRM DRIVERS FOR XEN" <dri-devel@lists.freedesktop.org>
Message-ID: <e04a91c2-3e2e-7052-14fc-9915f9cf6589@suse.com>
Subject: Re: [PATCH] Revert "xen: add helpers to allocate unpopulated memory"
References: <20201206172242.1249689-1-marmarek@invisiblethingslab.com>
In-Reply-To: <20201206172242.1249689-1-marmarek@invisiblethingslab.com>

--eZcwrVuZPjphx6y9vxccT9GtWokI6VlsT
Content-Type: multipart/mixed;
 boundary="------------162D6435A12428CB18F39909"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------162D6435A12428CB18F39909
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 06.12.20 18:22, Marek Marczykowski-G=C3=B3recki wrote:
> This reverts commit 9e2369c06c8a181478039258a4598c1ddd2cadfa.
>=20
> On a Xen PV dom0, with NVME disk, this makes the dom0 crash when starti=
ng
> a domain. This looks like some bad interaction between xen-blkback and

xen-scsiback has the same use pattern.

> NVME driver, both using ZONE_DEVICE. Since the author is on leave now,
> revert the change until proper solution is developed.
>=20
> The specific crash message is:
>=20
>      general protection fault, probably for non-canonical address 0xdea=
d000000000100: 0000 [#1] SMP NOPTI
>      CPU: 1 PID: 134 Comm: kworker/u12:2 Not tainted 5.9.9-1.qubes.x86_=
64 #1
>      Hardware name: LENOVO 20M9CTO1WW/20M9CTO1WW, BIOS N2CET50W (1.33 )=
 01/15/2020
>      Workqueue: dm-thin do_worker [dm_thin_pool]
>      RIP: e030:nvme_map_data+0x300/0x3a0 [nvme]
>      Code: b8 fe ff ff e9 a8 fe ff ff 4c 8b 56 68 8b 5e 70 8b 76 74 49 =
8b 02 48 c1 e8 33 83 e0 07 83 f8 04 0f 85 f2 fe ff ff 49 8b 42 08 <83> b8=
 d0 00 00 00 04 0f 85 e1 fe ff ff e9 38 fd ff ff 8b 55 70 be
>      RSP: e02b:ffffc900010e7ad8 EFLAGS: 00010246
>      RAX: dead000000000100 RBX: 0000000000001000 RCX: ffff8881a58f5000
>      RDX: 0000000000001000 RSI: 0000000000000000 RDI: ffff8881a679e000
>      RBP: ffff8881a5ef4c80 R08: ffff8881a5ef4c80 R09: 0000000000000002
>      R10: ffffea0003dfff40 R11: 0000000000000008 R12: ffff8881a679e000
>      R13: ffffc900010e7b20 R14: ffff8881a70b5980 R15: ffff8881a679e000
>      FS:  0000000000000000(0000) GS:ffff8881b5440000(0000) knlGS:000000=
0000000000
>      CS:  e030 DS: 0000 ES: 0000 CR0: 0000000080050033
>      CR2: 0000000001d64408 CR3: 00000001aa2c0000 CR4: 0000000000050660
>      Call Trace:
>       nvme_queue_rq+0xa7/0x1a0 [nvme]
>       __blk_mq_try_issue_directly+0x11d/0x1e0
>       ? add_wait_queue_exclusive+0x70/0x70
>       blk_mq_try_issue_directly+0x35/0xc0l[
>       blk_mq_submit_bio+0x58f/0x660
>       __submit_bio_noacct+0x300/0x330
>       process_shared_bio+0x126/0x1b0 [dm_thin_pool]
>       process_cell+0x226/0x280 [dm_thin_pool]
>       process_thin_deferred_cells+0x185/0x320 [dm_thin_pool]
>       process_deferred_bios+0xa4/0x2a0 [dm_thin_pool]UX
>       do_worker+0xcc/0x130 [dm_thin_pool]
>       process_one_work+0x1b4/0x370
>       worker_thread+0x4c/0x310
>       ? process_one_work+0x370/0x370
>       kthread+0x11b/0x140
>       ? __kthread_bind_mask+0x60/0x60<
>       ret_from_fork+0x22/0x30
>      Modules linked in: loop snd_seq_dummy snd_hrtimer nf_tables nfnetl=
ink vfat fat snd_sof_pci snd_sof_intel_byt snd_sof_intel_ipc snd_sof_inte=
l_hda_common snd_soc_hdac_hda snd_sof_xtensa_dsp snd_sof_intel_hda snd_so=
f snd_soc_skl snd_soc_sst_
>      ipc snd_soc_sst_dsp snd_hda_ext_core snd_soc_acpi_intel_match snd_=
soc_acpi snd_soc_core snd_compress ac97_bus snd_pcm_dmaengine elan_i2c sn=
d_hda_codec_hdmi mei_hdcp iTCO_wdt intel_powerclamp intel_pmc_bxt ee1004 =
intel_rapl_msr iTCO_vendor
>      _support joydev pcspkr intel_wmi_thunderbolt wmi_bmof thunderbolt =
ucsi_acpi idma64 typec_ucsi snd_hda_codec_realtek typec snd_hda_codec_gen=
eric snd_hda_intel snd_intel_dspcfg snd_hda_codec thinkpad_acpi snd_hda_c=
ore ledtrig_audio int3403_
>      thermal snd_hwdep snd_seq snd_seq_device snd_pcm iwlwifi snd_timer=
 processor_thermal_device mei_me cfg80211 intel_rapl_common snd e1000e me=
i int3400_thermal int340x_thermal_zone i2c_i801 acpi_thermal_rel soundcor=
e intel_soc_dts_iosf i2c_s
>      mbus rfkill intel_pch_thermal xenfs
>       ip_tables dm_thin_pool dm_persistent_data dm_bio_prison dm_crypt =
nouveau rtsx_pci_sdmmc mmc_core mxm_wmi crct10dif_pclmul ttm crc32_pclmul=
 crc32c_intel i915 ghash_clmulni_intel i2c_algo_bit serio_raw nvme drm_km=
s_helper cec xhci_pci nvme
>      _core rtsx_pci xhci_pci_renesas drm xhci_hcd wmi video pinctrl_can=
nonlake pinctrl_intel xen_privcmd xen_pciback xen_blkback xen_gntalloc xe=
n_gntdev xen_evtchn uinput
>      ---[ end trace f8d47e4aa6724df4 ]---
>      RIP: e030:nvme_map_data+0x300/0x3a0 [nvme]
>      Code: b8 fe ff ff e9 a8 fe ff ff 4c 8b 56 68 8b 5e 70 8b 76 74 49 =
8b 02 48 c1 e8 33 83 e0 07 83 f8 04 0f 85 f2 fe ff ff 49 8b 42 08 <83> b8=
 d0 00 00 00 04 0f 85 e1 fe ff ff e9 38 fd ff ff 8b 55 70 be
>      RSP: e02b:ffffc900010e7ad8 EFLAGS: 00010246
>      RAX: dead000000000100 RBX: 0000000000001000 RCX: ffff8881a58f5000
>      RDX: 0000000000001000 RSI: 0000000000000000 RDI: ffff8881a679e000
>      RBP: ffff8881a5ef4c80 R08: ffff8881a5ef4c80 R09: 0000000000000002
>      R10: ffffea0003dfff40 R11: 0000000000000008 R12: ffff8881a679e000
>      R13: ffffc900010e7b20 R14: ffff8881a70b5980 R15: ffff8881a679e000
>      FS:  0000000000000000(0000) GS:ffff8881b5440000(0000) knlGS:000000=
0000000000
>      CS:  e030 DS: 0000 ES: 0000 CR0: 0000000080050033
>      CR2: 0000000001d64408 CR3: 00000001aa2c0000 CR4: 0000000000050660
>      Kernel panic - not syncing: Fatal exception
>      Kernel Offset: disabled
>=20
> Discussion at https://lore.kernel.org/xen-devel/20201205082839.ts3ju6yt=
a46cgwjn@Air-de-Roger/T
>=20
> Cc: stable@vger.kernel.org #v5.9+
> (for 5.9 it's easier to revert the original commit directly)
> Signed-off-by: Marek Marczykowski-G=C3=B3recki <marmarek@invisiblething=
slab.com>

Acked-by: Juergen Gross <jgross@suse.com>


Juergen

--------------162D6435A12428CB18F39909
Content-Type: application/pgp-keys;
 name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="OpenPGP_0xB0DE9DD628BF132F.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----

xsBNBFOMcBYBCACgGjqjoGvbEouQZw/ToiBg9W98AlM2QHV+iNHsEs7kxWhKMjrioyspZKOBy=
cWx
w3ie3j9uvg9EOB3aN4xiTv4qbnGiTr3oJhkB1gsb6ToJQZ8uxGq2kaV2KL9650I1SJvedYm8O=
f8Z
d621lSmoKOwlNClALZNew72NjJLEzTalU1OdT7/i1TXkH09XSSI8mEQ/ouNcMvIJNwQpd369y=
9bf
IhWUiVXEK7MlRgUG6MvIj6Y3Am/BBLUVbDa4+gmzDC9ezlZkTZG2t14zWPvxXP3FAp2pkW0xq=
G7/
377qptDmrk42GlSKN4z76ELnLxussxc7I2hx18NUcbP8+uty4bMxABEBAAHNHEp1ZXJnZW4gR=
3Jv
c3MgPGpnQHBmdXBmLm5ldD7CwHkEEwECACMFAlOMcBYCGwMHCwkIBwMCAQYVCAIJCgsEFgIDA=
QIe
AQIXgAAKCRCw3p3WKL8TL0KdB/93FcIZ3GCNwFU0u3EjNbNjmXBKDY4FUGNQH2lvWAUy+dnyT=
hpw
dtF/jQ6j9RwE8VP0+NXcYpGJDWlNb9/JmYqLiX2Q3TyevpB0CA3dbBQp0OW0fgCetToGIQrg0=
MbD
1C/sEOv8Mr4NAfbauXjZlvTj30H2jO0u+6WGM6nHwbh2l5O8ZiHkH32iaSTfN7Eu5RnNVUJbv=
oPH
Z8SlM4KWm8rG+lIkGurqqu5gu8q8ZMKdsdGC4bBxdQKDKHEFExLJK/nRPFmAuGlId1E3fe10v=
5QL
+qHI3EIPtyfE7i9Hz6rVwi7lWKgh7pe0ZvatAudZ+JNIlBKptb64FaiIOAWDCx1SzR9KdWVyZ=
2Vu
IEdyb3NzIDxqZ3Jvc3NAc3VzZS5jb20+wsB5BBMBAgAjBQJTjHCvAhsDBwsJCAcDAgEGFQgCC=
QoL
BBYCAwECHgECF4AACgkQsN6d1ii/Ey/HmQf/RtI7kv5A2PS4RF7HoZhPVPogNVbC4YA6lW7Dr=
Wf0
teC0RR3MzXfy6pJ+7KLgkqMlrAbN/8Dvjoz78X+5vhH/rDLa9BuZQlhFmvcGtCF8eR0T1v0nC=
/nu
AFVGy+67q2DH8As3KPu0344TBDpAvr2uYM4tSqxK4DURx5INz4ZZ0WNFHcqsfvlGJALDeE0Lh=
ITT
d9jLzdDad1pQSToCnLl6SBJZjDOX9QQcyUigZFtCXFst4dlsvddrxyqT1f17+2cFSdu7+ynLm=
XBK
7abQ3rwJY8SbRO2iRulogc5vr/RLMMlscDAiDkaFQWLoqHHOdfO9rURssHNN8WkMnQfvUewRz=
80h
SnVlcmdlbiBHcm9zcyA8amdyb3NzQG5vdmVsbC5jb20+wsB5BBMBAgAjBQJTjHDXAhsDBwsJC=
AcD
AgEGFQgCCQoLBBYCAwECHgECF4AACgkQsN6d1ii/Ey8PUQf/ehmgCI9jB9hlgexLvgOtf7PJn=
FOX
gMLdBQgBlVPO3/D9R8LtF9DBAFPNhlrsfIG/SqICoRCqUcJ96Pn3P7UUinFG/I0ECGF4EvTE1=
jnD
kfJZr6jrbjgyoZHiw/4BNwSTL9rWASyLgqlA8u1mf+c2yUwcGhgkRAd1gOwungxcwzwqgljf0=
N51
N5JfVRHRtyfwq/ge+YEkDGcTU6Y0sPOuj4Dyfm8fJzdfHNQsWq3PnczLVELStJNdapwPOoE+l=
otu
fe3AM2vAEYJ9rTz3Cki4JFUsgLkHFqGZarrPGi1eyQcXeluldO3m91NK/1xMI3/+8jbO0tsn1=
tqS
EUGIJi7ox80eSnVlcmdlbiBHcm9zcyA8amdyb3NzQHN1c2UuZGU+wsB5BBMBAgAjBQJTjHDrA=
hsD
BwsJCAcDAgEGFQgCCQoLBBYCAwECHgECF4AACgkQsN6d1ii/Ey+LhQf9GL45eU5vOowA2u5N3=
g3O
ZUEBmDHVVbqMtzwlmNC4k9Kx39r5s2vcFl4tXqW7g9/ViXYuiDXb0RfUpZiIUW89siKrkzmQ5=
dM7
wRqzgJpJwK8Bn2MIxAKArekWpiCKvBOB/Cc+3EXE78XdlxLyOi/NrmSGRIov0karw2RzMNOu5=
D+j
LRZQd1Sv27AR+IP3I8U4aqnhLpwhK7MEy9oCILlgZ1QZe49kpcumcZKORmzBTNh30FVKK1Evm=
V2x
AKDoaEOgQB4iFQLhJCdP1I5aSgM5IVFdn7v5YgEYuJYx37IoN1EblHI//x/e2AaIHpzK5h88N=
Eaw
QsaNRpNSrcfbFmAg987ATQRTjHAWAQgAyzH6AOODMBjgfWE9VeCgsrwH3exNAU32gLq2xvjpW=
nHI
s98ndPUDpnoxWQugJ6MpMncr0xSwFmHEgnSEjK/PAjppgmyc57BwKII3sV4on+gDVFJR6Y8ZR=
wgn
BC5mVM6JjQ5xDk8WRXljExRfUX9pNhdE5eBOZJrDRoLUmmjDtKzWaDhIg/+1Hzz93X4fCQkNV=
bVF
LELU9bMaLPBG/x5q4iYZ2k2ex6d47YE1ZFdMm6YBYMOljGkZKwYde5ldM9mo45mmwe0icXKLk=
pEd
IXKTZeKDO+Hdv1aqFuAcccTg9RXDQjmwhC3yEmrmcfl0+rPghO0Iv3OOImwTEe4co3c1mwARA=
QAB
wsBfBBgBAgAJBQJTjHAWAhsMAAoJELDendYovxMvQ/gH/1ha96vm4P/L+bQpJwrZ/dneZcmEw=
Tbe
8YFsw2V/Buv6Z4Mysln3nQK5ZadD534CF7TDVft7fC4tU4PONxF5D+/tvgkPfDAfF77zy2AH1=
vJz
Q1fOU8lYFpZXTXIHb+559UqvIB8AdgR3SAJGHHt4RKA0F7f5ipYBBrC6cyXJyyoprT10EMvU8=
VGi
wXvTyJz3fjoYsdFzpWPlJEBRMedCot60g5dmbdrZ5DWClAr0yau47zpWj3enf1tLWaqcsuylW=
svi
uGjKGw7KHQd3bxALOknAp4dN3QwBYCKuZ7AddY9yjynVaD5X7nF9nO5BjR/i1DG86lem3iBDX=
zXs
ZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------162D6435A12428CB18F39909--

--eZcwrVuZPjphx6y9vxccT9GtWokI6VlsT--

--6ekrWC7Imvf7QM0ISrUV82GBc9sxpxUVx
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAl/NvycFAwAAAAAACgkQsN6d1ii/Ey+X
DAf/Ug6PNIYgDFG7iWJnhxhdd9LQ1RRJqgiZKsTVO8zvyU3Bt113hUMmM3CnYFrcGEdP1jS4pu2r
9vuhfJpOAHpnwezPBJEBjlF0MlQzuxPTSUgVdOOwkjaTJU4lElMJ83DA41IZ5Iw7U0lm9W1mhs6p
hYVD5AV+m9h1WUtkKRt5ph0RTItPkbrIkOZOToKkPjKbtnyWuw9T/1NL1sKSObjX6axqyryiaW8R
Hki59QtT/AKoyNJWQETeOcrOiy8E+tR9JZI4q4E7xsXLuyztnXHUobdKJwyib/64yyjey5Dz2bf0
2uxCzz3vqy2OcDOzL2SWKFxZYvXhFHGGdIazbcW6Kw==
=xfxw
-----END PGP SIGNATURE-----

--6ekrWC7Imvf7QM0ISrUV82GBc9sxpxUVx--
