Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 235A6322AD0
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 13:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbhBWMvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 07:51:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:58320 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232450AbhBWMvw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Feb 2021 07:51:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 95A99AC1D;
        Tue, 23 Feb 2021 12:51:10 +0000 (UTC)
To:     Greg KH <gregkh@linuxfoundation.org>,
        Daniel Vetter <daniel@ffwll.ch>
Cc:     Mathias Nyman <mathias.nyman@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Airlie <airlied@linux.ie>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Oliver Neukum <oneukum@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        stable <stable@vger.kernel.org>, Johan Hovold <johan@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sean Paul <sean@poorly.run>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
References: <20210223105842.27011-1-tzimmermann@suse.de>
 <YDTk3L3gNxDE3YrC@kroah.com> <YDTrDAlcFH/7/7DD@phenom.ffwll.local>
 <YDTu4ugLo23APyaM@kroah.com>
 <CAKMK7uG67eHEFOCJBJCtwFbwoUWQsER4DNBKRp6e75uywvF1pw@mail.gmail.com>
 <YDT0GIJEhWRp0w5F@kroah.com>
From:   Thomas Zimmermann <tzimmermann@suse.de>
Subject: Re: [PATCH v3] drm: Use USB controller's DMA mask when importing
 dmabufs
Message-ID: <9b1e0c9b-2337-d76b-4870-72fbe8495fd2@suse.de>
Date:   Tue, 23 Feb 2021 13:51:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YDT0GIJEhWRp0w5F@kroah.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tfVjE7CSdb8tE0A8dGE2fmdUi0IcH69xs"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tfVjE7CSdb8tE0A8dGE2fmdUi0IcH69xs
Content-Type: multipart/mixed; boundary="CeGL0T9qfviCpMOT3bw7x1MRjFdyUAkqU";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Greg KH <gregkh@linuxfoundation.org>, Daniel Vetter <daniel@ffwll.ch>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, Dave Airlie <airlied@linux.ie>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Oliver Neukum <oneukum@suse.com>, Christoph Hellwig <hch@lst.de>,
 Hans de Goede <hdegoede@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
 dri-devel <dri-devel@lists.freedesktop.org>, stable
 <stable@vger.kernel.org>, Johan Hovold <johan@kernel.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Sean Paul <sean@poorly.run>, =?UTF-8?Q?Christian_K=c3=b6nig?=
 <christian.koenig@amd.com>
Message-ID: <9b1e0c9b-2337-d76b-4870-72fbe8495fd2@suse.de>
Subject: Re: [PATCH v3] drm: Use USB controller's DMA mask when importing
 dmabufs
References: <20210223105842.27011-1-tzimmermann@suse.de>
 <YDTk3L3gNxDE3YrC@kroah.com> <YDTrDAlcFH/7/7DD@phenom.ffwll.local>
 <YDTu4ugLo23APyaM@kroah.com>
 <CAKMK7uG67eHEFOCJBJCtwFbwoUWQsER4DNBKRp6e75uywvF1pw@mail.gmail.com>
 <YDT0GIJEhWRp0w5F@kroah.com>
In-Reply-To: <YDT0GIJEhWRp0w5F@kroah.com>

--CeGL0T9qfviCpMOT3bw7x1MRjFdyUAkqU
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi

Am 23.02.21 um 13:24 schrieb Greg KH:
> On Tue, Feb 23, 2021 at 01:14:30PM +0100, Daniel Vetter wrote:
>> On Tue, Feb 23, 2021 at 1:02 PM Greg KH <gregkh@linuxfoundation.org> w=
rote:
>>>
>>> On Tue, Feb 23, 2021 at 12:46:20PM +0100, Daniel Vetter wrote:
>>>> On Tue, Feb 23, 2021 at 12:19:56PM +0100, Greg KH wrote:
>>>>> On Tue, Feb 23, 2021 at 11:58:42AM +0100, Thomas Zimmermann wrote:
>>>>>> USB devices cannot perform DMA and hence have no dma_mask set in t=
heir
>>>>>> device structure. Importing dmabuf into a USB-based driver fails, =
which
>>>>>> break joining and mirroring of display in X11.
>>>>>>
>>>>>> For USB devices, pick the associated USB controller as attachment =
device,
>>>>>> so that it can perform DMA. If the DMa controller does not support=
 DMA
>>>>>> transfers, we're aout of luck and cannot import.
>>>>>>
>>>>>> Drivers should use DRM_GEM_SHMEM_DROVER_OPS_USB to initialize thei=
r
>>>>>> instance of struct drm_driver.
>>>>>>
>>>>>> Tested by joining/mirroring displays of udl and radeon un der Gnom=
e/X11.
>>>>>>
>>>>>> v3:
>>>>>>    * drop gem_create_object
>>>>>>    * use DMA mask of USB controller, if any (Daniel, Christian, No=
ralf)
>>>>>> v2:
>>>>>>    * move fix to importer side (Christian, Daniel)
>>>>>>    * update SHMEM and CMA helpers for new PRIME callbacks
>>>>>>
>>>>>> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
>>>>>> Fixes: 6eb0233ec2d0 ("usb: don't inherity DMA properties for USB d=
evices")
>>>>>> Cc: Christoph Hellwig <hch@lst.de>
>>>>>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>>>> Cc: Johan Hovold <johan@kernel.org>
>>>>>> Cc: Alan Stern <stern@rowland.harvard.edu>
>>>>>> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>>>>>> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>>>>>> Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
>>>>>> Cc: Oliver Neukum <oneukum@suse.com>
>>>>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>>>>> Cc: <stable@vger.kernel.org> # v5.10+
>>>>>> ---
>>>>>>   drivers/gpu/drm/drm_prime.c        | 36 ++++++++++++++++++++++++=
++++++
>>>>>>   drivers/gpu/drm/tiny/gm12u320.c    |  2 +-
>>>>>>   drivers/gpu/drm/udl/udl_drv.c      |  2 +-
>>>>>>   include/drm/drm_gem_shmem_helper.h | 13 +++++++++++
>>>>>>   include/drm/drm_prime.h            |  5 +++++
>>>>>>   5 files changed, 56 insertions(+), 2 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_pri=
me.c
>>>>>> index 2a54f86856af..9015850f2160 100644
>>>>>> --- a/drivers/gpu/drm/drm_prime.c
>>>>>> +++ b/drivers/gpu/drm/drm_prime.c
>>>>>> @@ -29,6 +29,7 @@
>>>>>>   #include <linux/export.h>
>>>>>>   #include <linux/dma-buf.h>
>>>>>>   #include <linux/rbtree.h>
>>>>>> +#include <linux/usb.h>
>>>>>>
>>>>>>   #include <drm/drm.h>
>>>>>>   #include <drm/drm_drv.h>
>>>>>> @@ -1055,3 +1056,38 @@ void drm_prime_gem_destroy(struct drm_gem_o=
bject *obj, struct sg_table *sg)
>>>>>>    dma_buf_put(dma_buf);
>>>>>>   }
>>>>>>   EXPORT_SYMBOL(drm_prime_gem_destroy);
>>>>>> +
>>>>>> +/**
>>>>>> + * drm_gem_prime_import_usb - helper library implementation of th=
e import callback for USB devices
>>>>>> + * @dev: drm_device to import into
>>>>>> + * @dma_buf: dma-buf object to import
>>>>>> + *
>>>>>> + * This is an implementation of drm_gem_prime_import() for USB-ba=
sed devices.
>>>>>> + * USB devices cannot perform DMA directly. This function selects=
 the USB host
>>>>>> + * controller as DMA device instead. Drivers can use this as thei=
r
>>>>>> + * &drm_driver.gem_prime_import implementation.
>>>>>> + *
>>>>>> + * See also drm_gem_prime_import().
>>>>>> + */
>>>>>> +#ifdef CONFIG_USB
>>>>>> +struct drm_gem_object *drm_gem_prime_import_usb(struct drm_device=
 *dev,
>>>>>> +                                         struct dma_buf *dma_buf)=

>>>>>> +{
>>>>>> + struct usb_device *udev;
>>>>>> + struct device *usbhost;
>>>>>> +
>>>>>> + if (dev->dev->bus !=3D &usb_bus_type)
>>>>>> +         return ERR_PTR(-ENODEV);
>>>>>> +
>>>>>> + udev =3D interface_to_usbdev(to_usb_interface(dev->dev));
>>>>>> + if (!udev->bus)
>>>>>> +         return ERR_PTR(-ENODEV);
>>>>>> +
>>>>>> + usbhost =3D udev->bus->controller;
>>>>>> + if (!usbhost || !usbhost->dma_mask)
>>>>>> +         return ERR_PTR(-ENODEV);
>>>>>
>>>>> If individual USB drivers need access to this type of thing, should=
n't
>>>>> that be done in the USB core itself?
>>>>>
>>>>> {hint, yes}
>>>>>
>>>>> There shouldn't be anything "special" about a DRM driver that needs=
 this
>>>>> vs. any other driver that might want to know about DMA things relat=
ed to
>>>>> a specific USB device.  Why isn't this an issue with the existing
>>>>> storage or v4l USB devices?
>>>>
>>>> The trouble is that this is a regression fix for 5.9, because the dm=
a-api
>>>> got more opinionated about what it allows. The proper fix is a lot m=
ore
>>>> invasive (we essentially need to rework the drm_prime.c to allow dma=
-buf
>>>> importing for just cpu access), and that's a ton more invasive than =
just a
>>>> small patch with can stuff into stable kernels.
>>>>
>>>> This here is ugly, but it should at least get rid of black screens a=
gain.
>>>>
>>>> I think solid FIXME comment explaining the situation would be good.
>>>
>>> Why can't I take a USB patch for a regression fix?  Is drm somehow
>>> stand-alone that you make changes here that should belong in other
>>> subsystems?
>>>
>>> {hint, it shouldn't be}
>>>
>>> When you start poking in the internals of usb controller structures,
>>> that logic belongs in the USB core for all drivers to use, not in a
>>> random tiny subsystem where no USB developer will ever notice it?  :)=

>>
>> Because the usb fix isn't the right fix here, it's just the duct-tape.=

>> We don't want to dig around in these internals, it's just a convenient=

>> way to shut up the dma-api until drm has sorted out its confusion.
>>
>> We can polish the turd if you want, but the thing is, it's still a tur=
d ...
>>
>> The right fix is to change drm_prime.c code to not call dma_map_sg
>> when we don't need it. The problem is that roughly 3 layers of code
>> (drm_prime, dma-buf, gem shmem helpers) are involved. Plus, since
>> drm_prime is shared by all drm drivers, all other drm drivers are
>> impacted too. We're not going to be able to cc: stable that kind of
>> stuff. Thomas actually started with that series, until I pointed out
>> how bad things really are.
>>
>> And before you ask: The dma-api change makes sense, and dma-api vs drm=

>> relations are strained since years, so we're not going ask for some
>> hack there for our abuse to paper over the regression. I've been in
>> way too many of those threads, only result is shouting and failed
>> anger management.
>=20
> Let's do it right.  If this is a regression from 5.9, it isn't a huge
> one as that kernel was released last October.  I don't like to see this=

> messing around with USB internals in non-USB-core code please.

I get

  > git tag --contains 6eb0233ec2d0
  ...
  v5.10-rc1
  ...

as the first upstream release. The regression is only now hitting=20
bleeding-edge distros. And those USB adapters are used as secondary,=20
additional graphics cards, so it's not like most users will see the=20
issue immediately after upgrading.

Display mirroring/joining is the typical way of using these adapters.=20
Their main use case is now broken.

Best regards
Thomas

>=20
> thanks,
>=20
> greg k-h
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
>=20

--=20
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
(HRB 36809, AG N=C3=BCrnberg)
Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6rffer


--CeGL0T9qfviCpMOT3bw7x1MRjFdyUAkqU--

--tfVjE7CSdb8tE0A8dGE2fmdUi0IcH69xs
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmA0+j0FAwAAAAAACgkQlh/E3EQov+Df
iBAApexBpf3cXImeRbhEzOMyth+zpxFqbvf90vhKR3/MYD3lQUPOVKrTUmtrRh6HCbgh81Yx2n5t
n6PActFKzrkAmwNzgw/FmtXKxLTA+p0hsea7fVDutrmY7C/bR+qhWU3YHMVDTJf+Nh6WVyXWCxpE
BXwZ66SH8QVUFLII+rsHBiZrPGkh6cuPg6dXYJIMUXwZ+mQeGyGpLi0BI8S7ggHxHkC3nzhC2Umk
HvROXToYXao5b1CB4BsuyZ1FH6xIjVcxD7B3VDehF5Fun3aJKSpqXk9sAcbou5bf+BQ0D06R7R6Q
d+HwkG8TcbcUddZ0nYdYrCCx1hxf+ody31QSVIMpNYJ9hxCibqNv0lXttdWOKPiw8Jppa4qFcHp2
kysdTaaQ/+7UFI/rd9AE1pGeD6yAjA+bxF4yRL6doQKy9+7wzCFMr163gLkK2fviLDm+N0p9zdn9
TpGib3EPKxSvZlCnZxbL94PrwBAo1FUY0/w4NQrC/eRtQYKOiWS/keozSZt+A9WN1xEXaX4NYHsg
9sG/o3oLFRCOL7ZTicj++cF1SsBJa1h7TThj0U+rNzC/GigjgLim+QuamVucPhuyVGh53W60ZV0N
V88ir8ntrdGLkyYw+C3TvECHKNg06hRLEXE0jJLqtVfISmoLYvH9GgtjIV/Azm7dCCafyRRR+L/B
keY=
=wYK8
-----END PGP SIGNATURE-----

--tfVjE7CSdb8tE0A8dGE2fmdUi0IcH69xs--
