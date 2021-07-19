Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFDE3CD6A3
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 16:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbhGSNyp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 09:54:45 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:59952 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231618AbhGSNyo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 09:54:44 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 605C322353;
        Mon, 19 Jul 2021 14:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626705323; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BGVZLgJqWs3a00b2vv0tQcdiRENNOXJTkR9VWIdz7lw=;
        b=Nw1gBtQyF+JwTNxPsdxczOzLEKKT6WMrP4zOwqEDMbJO/TPRYRGs+56eAu3Q0lZV/DnoHs
        UooxDGDKXjdpoL8SMDCjxg1rodKLxvG7v9qVkq8hSTLuIPBGeyUD2LVkOYQbb8RyUo5DIr
        Y1Rx0NvdruKN3PN+E8lemddB8DPOngI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626705323;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BGVZLgJqWs3a00b2vv0tQcdiRENNOXJTkR9VWIdz7lw=;
        b=ELNmcz10seAzUTLbyHY5qz7jVU7We8j+nZ0j8Jx2fzq7E+WLAJVTzuZapz2Hb6BzCzb5wA
        0N6N9BfgVYSe3bCQ==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 1ADA6137F8;
        Mon, 19 Jul 2021 14:35:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id 15kcBauN9WCcBwAAGKfGzw
        (envelope-from <tzimmermann@suse.de>); Mon, 19 Jul 2021 14:35:23 +0000
Subject: Re: [PATCH 5.12 237/242] drm/ast: Remove reference to struct
 drm_device.pdev
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Xiaotian Feng <xtfeng@gmail.com>
Cc:     kernel test robot <lkp@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org,
        "Michael J. Ruhl" <michael.j.ruhl@intel.com>,
        dri-devel@lists.freedesktop.org, Dave Airlie <airlied@redhat.com>
References: <20210715182551.731989182@linuxfoundation.org>
 <20210715182634.577299401@linuxfoundation.org>
 <CAJn8CcF+gfXToErpZv=pWmBKF-i--oVWmaM=6AQ8YZCb21X=oA@mail.gmail.com>
 <YPVgtybrZLxe3XeW@kroah.com>
From:   Thomas Zimmermann <tzimmermann@suse.de>
Message-ID: <2ba3d853-f334-ba0e-3cdc-1e9a03f99b51@suse.de>
Date:   Mon, 19 Jul 2021 16:35:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YPVgtybrZLxe3XeW@kroah.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="aKGIbJWn7ki9aQLImBobZhlry4ehARXJe"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aKGIbJWn7ki9aQLImBobZhlry4ehARXJe
Content-Type: multipart/mixed; boundary="D5YOslm5qCYSUm3Ouyzc0GNFwrUZvc4ck";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Xiaotian Feng <xtfeng@gmail.com>
Cc: kernel test robot <lkp@intel.com>,
 linux-kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
 "Michael J. Ruhl" <michael.j.ruhl@intel.com>,
 dri-devel@lists.freedesktop.org, Dave Airlie <airlied@redhat.com>
Message-ID: <2ba3d853-f334-ba0e-3cdc-1e9a03f99b51@suse.de>
Subject: Re: [PATCH 5.12 237/242] drm/ast: Remove reference to struct
 drm_device.pdev
References: <20210715182551.731989182@linuxfoundation.org>
 <20210715182634.577299401@linuxfoundation.org>
 <CAJn8CcF+gfXToErpZv=pWmBKF-i--oVWmaM=6AQ8YZCb21X=oA@mail.gmail.com>
 <YPVgtybrZLxe3XeW@kroah.com>
In-Reply-To: <YPVgtybrZLxe3XeW@kroah.com>

--D5YOslm5qCYSUm3Ouyzc0GNFwrUZvc4ck
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

hi

Am 19.07.21 um 13:23 schrieb Greg Kroah-Hartman:
> On Mon, Jul 19, 2021 at 05:57:30PM +0800, Xiaotian Feng wrote:
>> On Fri, Jul 16, 2021 at 5:13 AM Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>>>
>>> From: Thomas Zimmermann <tzimmermann@suse.de>
>>>
>>> commit 0ecb51824e838372e01330752503ddf9c0430ef7 upstream.
>>>
>>> Using struct drm_device.pdev is deprecated. Upcast with to_pci_dev()
>>> from struct drm_device.dev to get the PCI device structure.
>>>
>>> v9:
>>>          * fix remaining pdev references
>>>
>>> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
>>> Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
>>> Fixes: ba4e0339a6a3 ("drm/ast: Fixed CVE for DP501")
>>> Cc: KuoHsiang Chou <kuohsiang_chou@aspeedtech.com>
>>> Cc: kernel test robot <lkp@intel.com>
>>> Cc: Thomas Zimmermann <tzimmermann@suse.de>
>>> Cc: Dave Airlie <airlied@redhat.com>
>>> Cc: dri-devel@lists.freedesktop.org
>>> Link: https://patchwork.freedesktop.org/patch/msgid/20210429105101.25=
667-2-tzimmermann@suse.de
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> ---
>>>   drivers/gpu/drm/ast/ast_main.c |    5 ++---
>>>   1 file changed, 2 insertions(+), 3 deletions(-)
>>>
>>> --- a/drivers/gpu/drm/ast/ast_main.c
>>> +++ b/drivers/gpu/drm/ast/ast_main.c
>>> @@ -411,7 +411,6 @@ struct ast_private *ast_device_create(co
>>>                  return ast;
>>>          dev =3D &ast->base;
>>>
>>> -       dev->pdev =3D pdev;
>>>          pci_set_drvdata(pdev, dev);
>>>
>>>          ast->regs =3D pcim_iomap(pdev, 1, 0);
>>> @@ -453,8 +452,8 @@ struct ast_private *ast_device_create(co
>>>
>>>          /* map reserved buffer */
>>>          ast->dp501_fw_buf =3D NULL;
>>> -       if (dev->vram_mm->vram_size < pci_resource_len(dev->pdev, 0))=
 {
>>> -               ast->dp501_fw_buf =3D pci_iomap_range(dev->pdev, 0, d=
ev->vram_mm->vram_size, 0);
>>> +       if (dev->vram_mm->vram_size < pci_resource_len(pdev, 0)) {
>>> +               ast->dp501_fw_buf =3D pci_iomap_range(pdev, 0, dev->v=
ram_mm->vram_size, 0);
>>>                  if (!ast->dp501_fw_buf)
>>>                          drm_info(dev, "failed to map reserved buffer=
!\n");
>>>          }
>>>
>>
>> Hi Greg,
>>
>>       This backport is incomplete for 5.10 kernel,  kernel is panicked=

>> on RIP: ast_device_create+0x7d.  When I look into the crash code, I
>> found
>>
>> struct ast_private *ast_device_create(struct drm_driver *drv,
>>                                        struct pci_dev *pdev,
>>                                        unsigned long flags)
>> {
>> .......
>>          dev->pdev =3D pdev;  // This is removed
>>          pci_set_drvdata(pdev, dev);
>>
>>          ast->regs =3D pcim_iomap(pdev, 1, 0);
>>          if (!ast->regs)
>>                  return ERR_PTR(-EIO);
>>
>>          /*
>>           * If we don't have IO space at all, use MMIO now and
>>           * assume the chip has MMIO enabled by default (rev 0x20
>>           * and higher).
>>           */
>>          if (!(pci_resource_flags(dev->pdev, 2) & IORESOURCE_IO)) { //=

>> dev->pdev is in used here.
>>                  drm_info(dev, "platform has no IO space, trying MMIO\=
n");
>>                  ast->ioregs =3D ast->regs + AST_IO_MM_OFFSET;
>>          }
>>
>>          That's because commit 46fb883c3d0d8a823ef995ddb1f9b0817dea688=
2
>> is not backported to 5.10 kernel.
>=20
> So what should I do here?  Backport that commit (was was not called
> out), or just revert this?

Best drop all these 'remove pdev' patches from stable. They are no bugfix=
es.

Best regards
Thomas

>=20
> thanks,
>=20
> greg k-h
>=20

--=20
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
(HRB 36809, AG N=C3=BCrnberg)
Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6rffer


--D5YOslm5qCYSUm3Ouyzc0GNFwrUZvc4ck--

--aKGIbJWn7ki9aQLImBobZhlry4ehARXJe
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmD1jakFAwAAAAAACgkQlh/E3EQov+By
ThAAgJpRz0bpcIRmMDyuqdNuSV9EoNk9bWeTAuWDUMUAP67pdddb85g/khOcUJpwKcKtMBcEpOVk
uJlRQgNRxV8yVsSI9MlxRVkUrJHzncFn9AwTl5C1nDeHk/tM5UpvTkSQGjnbqHDpJByhwUBcHrZd
fmUelaf5bA/TJyL+KTHQDba1HJMTaJnYUPUtxX2OzhexJf1iIq5tAQDwpfqtQZn6mIXU2mL66BVD
gFvC3kBNgFPvtFpNVE4BRxTn7lF0nHBMMtlzVOWznkOXxi9PzLvUEs+6PV48wvyk1poTjr1cSLoA
sX00NKA3mF0wsXu3p9OpKbEjRlltXpwRqsuPLilv0rXCtdc39+hxtqujT9YMNYl0fAU3vW3b5GZ/
brymrko321EWv6fIswClIdpR+SR8e3iiZLc2npB1TJHRk+WN7Wtf5UxW+rBvU/ySzBE7Bp/OcrWw
jlW3vw6ONeRc/g+d2SRLXrYoioAlh5kwlLL4/NtYDJVrXWtoMvuP9DUPOy7RBIzhFUUS+5FD9zMU
vWsB6wdqimeuAUab3Ppids+pr7SK1caX5en07IssFYlZrmgMVRaMEXMrPctcmTUn6fQldxZHh9Db
MM61n5krHHNhma5iq5IQhMxB1Rhpypi11xG88ZFR8Y4kEuP2L69i6fMaRNdGE2zCkTAKaJKjVzgP
PMw=
=uvP3
-----END PGP SIGNATURE-----

--aKGIbJWn7ki9aQLImBobZhlry4ehARXJe--
