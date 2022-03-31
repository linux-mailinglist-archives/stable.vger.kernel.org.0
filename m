Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EAE54EDD50
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 17:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239099AbiCaPk4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 11:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239679AbiCaPil (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 11:38:41 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4683622E96C
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 08:33:12 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id s8so22377335pfk.12
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 08:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yEmz/8cQT/z4or8puaY3Kz/sgiUXMKjLnb73DP8zXB4=;
        b=EUaUZPcfweDaGz+UYp+NStA0BmInTkma7npoGLJMmcEUZ2iZGKPVT0+1BPCXfIV/O8
         GHiyc4aFGoWyoq2lqSIwPwUDFYVXIcSY2xPOR5kLVOO0Nw/3hOD+cFlTZ3OSV9p7Z6/e
         VKNu4WxdQMhT7e56+GQ03nSGh5F2m6eQY0twspHOfdqpr70xwKPF+Qx/z00v+9m02tek
         T30KRjehWG7I+iyZa4TP8flH5HEiXZViIehPikpfDcxXxtUW8xeWmelVkRCIrXo9YZ5f
         qPrKlIet7jM6gLIXNY0RvIyNrR8ZOJWRcbN9ZR7H74+0VbHub/iVtv77tu8OwrAN0ek+
         FFNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yEmz/8cQT/z4or8puaY3Kz/sgiUXMKjLnb73DP8zXB4=;
        b=WeSdXnuiaQVgE3zczwms6OyJAsOftQtT9WXqfAWRXV9VENworX9elIZ7XZ7P1w6rH2
         e/0pAylu47wXbWjSgwP82Ri49HllxOEhsN6fWgy3mLDapkcMmalZlnEGnpal8DBpMZvo
         UbdQru75WikVgGzT/dGp6k+tdA2c7eeoa80EyqesJDtSpv3qligYv3sGOYILZrhUnb9S
         Y9H1EBexrU2lmsxkDSPjlWUUc2Ig203ozSdvFn0oXav8pqecas5+3Cq9ERWCWKbIilTP
         H+W7pKpaAUX4d5smL+Mp5ieycIcrT/sAaF+QLVC+SfvkGlnI/SfpV5ZHc9a1XZmNyASE
         94xQ==
X-Gm-Message-State: AOAM53065sdndjgNkoLx/AnAQgDLqy07KwSeC6Mcnf5z4x0BPPR0V2Pt
        vGY2A9nNrJDXxIr5IU/Rs7LhOQ==
X-Google-Smtp-Source: ABdhPJw0VfksheIzQpwF1rgGRvosu0Ldg1XtQsVA5AYA5VbOz1eqJHbzzU9YuQ5DQU5VooERtMGbMA==
X-Received: by 2002:a05:6a02:193:b0:375:65a5:2fcd with SMTP id bj19-20020a056a02019300b0037565a52fcdmr10929563pgb.288.1648740791608;
        Thu, 31 Mar 2022 08:33:11 -0700 (PDT)
Received: from google.com ([2620:15c:202:201:a082:a097:a7d8:d309])
        by smtp.gmail.com with ESMTPSA id z23-20020a056a001d9700b004fa8f24702csm24543241pfw.85.2022.03.31.08.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 08:33:10 -0700 (PDT)
Date:   Thu, 31 Mar 2022 08:33:03 -0700
From:   Benson Leung <bleung@google.com>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Won Chung <wonchung@google.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Benson Leung <bleung@chromium.org>,
        Prashant Malani <pmalani@chromium.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] sound/hda: Add NULL check to component match callback
 function
Message-ID: <YkXJr2KhSzHJHxRF@google.com>
References: <20220330211913.2068108-1-wonchung@google.com>
 <s5hzgl6eg48.wl-tiwai@suse.de>
 <CAOvb9yiO_n48JPZ3f0+y-fQ_YoOmuWF5c692Jt5_SKbxdA4yAw@mail.gmail.com>
 <s5hr16ieb8o.wl-tiwai@suse.de>
 <YkVzl4NEzwDAp/Zq@kuha.fi.intel.com>
 <s5hmth6eaiz.wl-tiwai@suse.de>
 <YkV1rsq1SeTNd8Ud@kuha.fi.intel.com>
 <s5hk0cae9pw.wl-tiwai@suse.de>
 <s5h7d8adzdl.wl-tiwai@suse.de>
 <s5hzgl6ciho.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qZ1ZF7vfmh9I4Bit"
Content-Disposition: inline
In-Reply-To: <s5hzgl6ciho.wl-tiwai@suse.de>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--qZ1ZF7vfmh9I4Bit
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Takashi,

On Thu, Mar 31, 2022 at 04:19:15PM +0200, Takashi Iwai wrote:
> On Thu, 31 Mar 2022 15:29:10 +0200,
> Takashi Iwai wrote:
> >=20
> > On Thu, 31 Mar 2022 11:45:47 +0200,
> > Takashi Iwai wrote:
> > >=20
> > > On Thu, 31 Mar 2022 11:34:38 +0200,
> > > Heikki Krogerus wrote:
> > > >=20
> > > > On Thu, Mar 31, 2022 at 11:28:20AM +0200, Takashi Iwai wrote:
> > > > > On Thu, 31 Mar 2022 11:25:43 +0200,
> > > > > Heikki Krogerus wrote:
> > > > > >=20
> > > > > > On Thu, Mar 31, 2022 at 11:12:55AM +0200, Takashi Iwai wrote:
> > > > > > > > > > -     if (!strcmp(dev->driver->name, "i915") &&
> > > > > > > > > > +     if (dev->driver && !strcmp(dev->driver->name, "i9=
15") &&
> > > > > > > > >
> > > > > > > > > Can NULL dev->driver be really seen?  I thought the compo=
nents are
> > > > > > > > > added by the drivers, hence they ought to have the driver=
 field set.
> > > > > > > > > But there can be corner cases I overlooked.
> > > > > > > > >
> > > > > > > > >
> > > > > > > > > thanks,
> > > > > > > > >
> > > > > > > > > Takashi
> > > > > > > >=20
> > > > > > > > Hi Takashi,
> > > > > > > >=20
> > > > > > > > When I try using component_add in a different driver (usb4 =
in my
> > > > > > > > case), I think dev->driver here is NULL because the i915 dr=
ivers do
> > > > > > > > not have their component master fully bound when this new c=
omponent is
> > > > > > > > registered. When I test it, it seems to be causing a crash.
> > > > > > >=20
> > > > > > > Hm, from where component_add*() is called?  Basically dev->dr=
iver must
> > > > > > > be already set before the corresponding driver gets bound at
> > > > > > > __driver_probe_deviec().  So, if the device is added to compo=
nent from
> > > > > > > the corresponding driver's probe, dev->driver must be non-NUL=
L.
> > > > > >=20
> > > > > > The code that declares a device as component does not have to b=
e the
> > > > > > driver of that device.
> > > > > >=20
> > > > > > In our case the components are USB ports, and they are devices =
that
> > > > > > are actually never bind to any drivers: drivers/usb/core/port.c
> > > > >=20
> > > > > OK, that's what I wanted to know.  It'd be helpful if it's more
> > > > > clearly mentioned in the commit log.
> > > >=20
> > > > Agree.
> > > >=20
> > > > > BTW, the same problem must be seen in MEI drivers, too.
> > > >=20
> > > > Wasn't there a patch for those too? I lost track...
> > >=20
> > > I don't know, I just checked the latest Linus tree.
> > >=20
> > > And, looking at the HD-audio code, I still wonder how NULL dev->driver
> > > can reach there.  Is there any PCI device that is added to component
> > > without binding to a driver?  We have dev_is_pci() check at the
> > > beginning, so non-PCI devices should bail out there...
> >=20
> > Further reading on, I'm really confused.  How data=3DNULL can be passed
> > to this function?  The data argument is the value passed from the
> > component_match_add_typed() call in HD-audio driver, hence it must be
> > always the snd_hdac_bus object.
> >=20
> > And, I guess the i915 string check can be omitted completely, at
> > least, for HD-audio driver.  It already have a check of the parent of
> > the device and that should be enough.
>=20
> That said, something like below (supposing data NULL check being
> superfluous), instead.
>=20
>=20
> Takashi
>=20
> --- a/sound/hda/hdac_i915.c
> +++ b/sound/hda/hdac_i915.c
> @@ -102,18 +102,13 @@ static int i915_component_master_match(struct devic=
e *dev, int subcomponent,
>  	struct pci_dev *hdac_pci, *i915_pci;
>  	struct hdac_bus *bus =3D data;
> =20
> -	if (!dev_is_pci(dev))
> +	if (subcomponent !=3D I915_COMPONENT_AUDIO || !dev_is_pci(dev))
>  		return 0;
> =20

If I recall this bug correctly, it's not the usb port perse that is falling
through this !dev_is_pci(dev) check, it's actually the usb4-port in a new
proposed patch by Heikki and Mika to extend the usb type-c component to
encompass the usb4 specific pieces too. Is it possible usb4 ports are consi=
dered
pci devices, and that's how we got into this situation?

Also, a little more background information: This crash happens because in
our kernel configs, we config'd the usb4 driver as =3Dy (built in) instead =
of
=3Dm module, which meant that the usb4 port's driver was adding a component
likely much earlier than hdac_i915.

Thanks,
Benson

>  	hdac_pci =3D to_pci_dev(bus->dev);
>  	i915_pci =3D to_pci_dev(dev);
> =20
> -	if (!strcmp(dev->driver->name, "i915") &&
> -	    subcomponent =3D=3D I915_COMPONENT_AUDIO &&
> -	    connectivity_check(i915_pci, hdac_pci))
> -		return 1;
> -
> -	return 0;
> +	return connectivity_check(i915_pci, hdac_pci);
>  }
> =20
>  /* check whether intel graphics is present */
>=20

--=20
Benson Leung
Staff Software Engineer
Chrome OS Kernel
Google Inc.
bleung@google.com
Chromium OS Project
bleung@chromium.org

--qZ1ZF7vfmh9I4Bit
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQCtZK6p/AktxXfkOlzbaomhzOwwgUCYkXJrwAKCRBzbaomhzOw
wpDWAP4u9qZ1yLO4Vtblx/ZmitMRfRXqpqZ1xkZTr3wjUV3NXgD8DQBQxF/RIz2w
F727wkBDJO7uAqp8N1cVAtvwIUCSSg4=
=Nqgb
-----END PGP SIGNATURE-----

--qZ1ZF7vfmh9I4Bit--
