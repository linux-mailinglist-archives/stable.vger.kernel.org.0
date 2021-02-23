Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC63322B9F
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 14:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232450AbhBWNoQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 08:44:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:41796 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232898AbhBWNn4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Feb 2021 08:43:56 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 13371AE7F;
        Tue, 23 Feb 2021 13:43:14 +0000 (UTC)
Subject: Re: [PATCH v3] drm: Use USB controller's DMA mask when importing
 dmabufs
To:     Greg KH <gregkh@linuxfoundation.org>,
        Daniel Vetter <daniel@ffwll.ch>
Cc:     Mathias Nyman <mathias.nyman@linux.intel.com>,
        Dave Airlie <airlied@linux.ie>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Oliver Neukum <oneukum@suse.com>,
        Johan Hovold <johan@kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Christoph Hellwig <hch@lst.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        stable <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sean Paul <sean@poorly.run>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
References: <20210223105842.27011-1-tzimmermann@suse.de>
 <YDTk3L3gNxDE3YrC@kroah.com> <656a49c3-018e-9188-94bf-5f1270ea61e4@suse.de>
 <YDT4sHTFdkw3g8es@kroah.com>
 <CAKMK7uHHZQ_zEi6kH0Wk=oHRVkb+sygDbTzBTdo2jZ6cyHABaA@mail.gmail.com>
 <YDT6hKde1OWQO9if@kroah.com>
From:   Thomas Zimmermann <tzimmermann@suse.de>
Message-ID: <6fe0229c-b418-030a-67d6-bf89693252aa@suse.de>
Date:   Tue, 23 Feb 2021 14:43:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YDT6hKde1OWQO9if@kroah.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="RcDYUZdT68tLyKPrWX0HX6ghFKIQsZnx0"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RcDYUZdT68tLyKPrWX0HX6ghFKIQsZnx0
Content-Type: multipart/mixed; boundary="gC8ALdgoQIfBocjxqu69tQIywH0BtTHul";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Greg KH <gregkh@linuxfoundation.org>, Daniel Vetter <daniel@ffwll.ch>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
 Dave Airlie <airlied@linux.ie>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Oliver Neukum <oneukum@suse.com>, Johan Hovold <johan@kernel.org>,
 dri-devel <dri-devel@lists.freedesktop.org>, Christoph Hellwig <hch@lst.de>,
 Hans de Goede <hdegoede@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
 stable <stable@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Sean Paul <sean@poorly.run>, =?UTF-8?Q?Christian_K=c3=b6nig?=
 <christian.koenig@amd.com>
Message-ID: <6fe0229c-b418-030a-67d6-bf89693252aa@suse.de>
Subject: Re: [PATCH v3] drm: Use USB controller's DMA mask when importing
 dmabufs
References: <20210223105842.27011-1-tzimmermann@suse.de>
 <YDTk3L3gNxDE3YrC@kroah.com> <656a49c3-018e-9188-94bf-5f1270ea61e4@suse.de>
 <YDT4sHTFdkw3g8es@kroah.com>
 <CAKMK7uHHZQ_zEi6kH0Wk=oHRVkb+sygDbTzBTdo2jZ6cyHABaA@mail.gmail.com>
 <YDT6hKde1OWQO9if@kroah.com>
In-Reply-To: <YDT6hKde1OWQO9if@kroah.com>

--gC8ALdgoQIfBocjxqu69tQIywH0BtTHul
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi

Am 23.02.21 um 13:52 schrieb Greg KH:
> On Tue, Feb 23, 2021 at 01:49:50PM +0100, Daniel Vetter wrote:
>> On Tue, Feb 23, 2021 at 1:44 PM Greg KH <gregkh@linuxfoundation.org> w=
rote:
>>>
>>> On Tue, Feb 23, 2021 at 01:37:09PM +0100, Thomas Zimmermann wrote:
>>>> Hi
>>>>
>>>> Am 23.02.21 um 12:19 schrieb Greg KH:
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
>>>>>>    drivers/gpu/drm/drm_prime.c        | 36 +++++++++++++++++++++++=
+++++++
>>>>>>    drivers/gpu/drm/tiny/gm12u320.c    |  2 +-
>>>>>>    drivers/gpu/drm/udl/udl_drv.c      |  2 +-
>>>>>>    include/drm/drm_gem_shmem_helper.h | 13 +++++++++++
>>>>>>    include/drm/drm_prime.h            |  5 +++++
>>>>>>    5 files changed, 56 insertions(+), 2 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_pri=
me.c
>>>>>> index 2a54f86856af..9015850f2160 100644
>>>>>> --- a/drivers/gpu/drm/drm_prime.c
>>>>>> +++ b/drivers/gpu/drm/drm_prime.c
>>>>>> @@ -29,6 +29,7 @@
>>>>>>    #include <linux/export.h>
>>>>>>    #include <linux/dma-buf.h>
>>>>>>    #include <linux/rbtree.h>
>>>>>> +#include <linux/usb.h>
>>>>>>
>>>>>>    #include <drm/drm.h>
>>>>>>    #include <drm/drm_drv.h>
>>>>>> @@ -1055,3 +1056,38 @@ void drm_prime_gem_destroy(struct drm_gem_o=
bject *obj, struct sg_table *sg)
>>>>>>            dma_buf_put(dma_buf);
>>>>>>    }
>>>>>>    EXPORT_SYMBOL(drm_prime_gem_destroy);
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
>>>> I don't know about vc4 or storage. My guess is that they don't call
>>>> dma_map_sgtable() for devices with dma_mask. Ideally, USB DRM device=
s
>>>> wouldn't do that either, but, as Daniel explained, DRM's PRIME frame=
work
>>>> expects a dma_mask on the importing device.
>>>>
>>>> The real fix would move this from framework to drivers, so that each=
 driver
>>>> can import the dmabuf according to its capabilities. I tried to do t=
his with
>>>> v2 of this patch, but I was not feasible at this time.
>>>>
>>>> For this to work, we'd have rework at least 3 drivers, the PRIME fra=
mework
>>>> and the dmabuf framework. I don't think the stable maintainer would =
be keen
>>>> on merging that. ;)
>>>
>>> Why not?  If it fixes an issue that has been reported, we've taken
>>> bigger for smaller bugs :)
>>
>> The problem is also that I can't just invent a bunch of people out of
>> thin are to make it happen. If you have them, please send them over,
>> there's lots to do here :-)
>>
>>>> Wrt your question about the USB core: what we do here is a workaroun=
d for
>>>> dmabuf importing. The DRM USB drivers don't even use the resulting p=
age
>>>> mapping directly. Putting the workaround into the USB core is maybe =
not
>>>> useful. If we ever use DMA directly for streaming framebuffers to th=
e
>>>> device, thinks might be different.
>>>
>>> Then I really do not understand the issue here.  Why are you wanting =
to
>>> grab a "naked" reference to the usb host controller device here?  Wha=
t
>>> ensures that it is correct (hint, lots of host controllers do not han=
dle
>>> dma), and what prevents it from going away underneath you?
>>
>> We know it's not correct, it's just a hack. We never use this even,
>> it's just there to not have to rewrite/audit large chunks of drm code.=

>=20
> If you don't need the device, then why do you need a pointer to it?
>=20
> Now I'm totally lost and confused what this patch is even supposed to b=
e
> doing in the first place :(
>=20
> Is all you need that magic "mask"?  Something else?

We only need the dma_mask field. importing currently fails at [1]. As=20
the driver doesn't use DMA, it really doesn't matter which device=20
provides it.

>=20
> Again, passing around "naked" pointers is going to cause problems, what=

> happens when the bus is removed from the system?

If this requires locks, we can certainly hold them while being in the=20
new helper function. After we completed the import, we don't have to=20
care any longer about the devices involved.

Best regards
Thomas

[1] https://elixir.bootlin.com/linux/v5.11/source/kernel/dma/mapping.c#L1=
90
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


--gC8ALdgoQIfBocjxqu69tQIywH0BtTHul--

--RcDYUZdT68tLyKPrWX0HX6ghFKIQsZnx0
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmA1BnAFAwAAAAAACgkQlh/E3EQov+BW
hA//YEI1ZWk9H2zblIw0nM5swVeJ0zH4gYq0g+1b3x6n5ZZSejDhJKvKjwoFo0kFVgHWdAARwihz
WyV9BhdP2U5tSrpZKocegVPbF3Fpy8wZPlQ2f7siENcjWf5ji6ceejzPv0Dv+XrCI7hRtSPzzzWx
0D/hg/hELP7t4rmHa2aaCQ2FKMO9mgrNrzuXsCsPc8nKOk+ZrRGr7QM1rucEeQIIZVUeOzf1gjKn
5ZD/HuU1gknd/e+i46E5Da/vQgtiOBV4gFemWcPftWkdNrFftbPZ6Cf+9y6/9dLnVS8uUGhSbLFQ
Thhl6w8FRcczLzNhXeC68AZ++FGHHH6WOaj5cYhONi7/ZiZXUrE159Lb4afAdRCZbrk6pRb2D6af
ZtH/qieRboW7wMv0goLkXpK/p2FwBEcms+cs0QmaiWQNf5VOSLaakhxuuUN/dETT04i6i6yDMKnZ
JWHdPEpa1mGRhlNlNSr3wAKNEcr7eDUVOT3G5r1AtjC4VsRtXzQ4kJvk9bNZJcaMQ6zBXL1/dtze
mhTM3bmB9UFmJdpgRrhmQ+WMjHmnm9OAr0C+R1HZUnXAcLDjrpaxUtHiNvkYxsws8lE9EqOyzgaR
X/XNPpOjE0rs0rxaBcIQTOtJRDqR6JDEsMSeTeSMiBGnitd5a5f559Pp65TxB2WmRkUyZaJwifkU
3Cc=
=31xV
-----END PGP SIGNATURE-----

--RcDYUZdT68tLyKPrWX0HX6ghFKIQsZnx0--
