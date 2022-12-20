Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 324DF65289B
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 22:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234167AbiLTV6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 16:58:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233934AbiLTV6L (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 16:58:11 -0500
Received: from mail-vk1-xa2e.google.com (mail-vk1-xa2e.google.com [IPv6:2607:f8b0:4864:20::a2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B40201057B
        for <stable@vger.kernel.org>; Tue, 20 Dec 2022 13:58:09 -0800 (PST)
Received: by mail-vk1-xa2e.google.com with SMTP id r204so6409582vkf.8
        for <stable@vger.kernel.org>; Tue, 20 Dec 2022 13:58:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iXgVKBGpWt57zpsJdkO/K65NYA6Pciqi5ly+NTuyyYc=;
        b=OyWh9JGVtHy/yQahJCs/R5ewPA6aUx31vYU0CKaplzT4gmtZ9l64/CkaX0TFzqmCJV
         xx/KPPb+xiAheF6RkRe+4sAwFNKZGVVOcd1fGLm/Q9gxUU/qAMqjFsuopJq1rG079bM5
         qb/6y9IZn+YGWLC2FpaC5c0OX9MDne068scRryorDRGyEVNq9uEIN7BDugceZxsLPvKK
         8By/dsesW9M7DQjw/Zba5M2EdLHC4zOnAXnc98OxmeIhwnOh9G1z7SDduNCT0e0WCs5x
         hchSRxiu4IiGdCD/fRcI6rTJIAENS17Os212bF9E2dQ/GrlPlwS4/HOblavYaF8C+4k0
         tmkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iXgVKBGpWt57zpsJdkO/K65NYA6Pciqi5ly+NTuyyYc=;
        b=SZgnfNkovyodPYBDw5QYdTgmNiimeCBI/cwIpXTZ1EG2GSwlHD8tQ1KUFLJhBtH3aU
         DRN1Uh0eW/KfPqIJjwMGpHRD55WUuSWFAJD1aYtlNmJOQpR8tkAdupODxGkILUlxHQrl
         vZRQxvjen9tZLa59OtyyZuIApqVyGx+jfPcHrMzHdQ1s/cqSK+/hsBrRDxGh31OjIqMV
         0r2o6g51SzhVdo0wKKh7Dn8qF/QqwvkYwmfzQ8QNOx3GZSuqfs/yUEAGAMnTC2w2MG2F
         FPKS/tj9SQwhSTYp8YFPW95443u8COtNX6HuK45K47vibbIgUAltFtPnwcvjLnl5qlga
         A5JA==
X-Gm-Message-State: ANoB5pkKbVG+ndTncpnbdxoUXEuKuUu2bTEnR5FbTLbjtDVXT55fGPBc
        6u1Hpvn9HSRZXQYo8WdXGUm1/Qr7PWAyW9P6jiSwyA==
X-Google-Smtp-Source: AA0mqf6YMIjNb5WQzM8ORZr37d6fEwt709M3mvR8G0kyOk4bKE3Dtbdv5+mmCirNFdNOzgh+BSueLXnnY26vg3bVU8M=
X-Received: by 2002:a1f:2f44:0:b0:3bd:b6da:f07d with SMTP id
 v65-20020a1f2f44000000b003bdb6daf07dmr13915086vkv.20.1671573488730; Tue, 20
 Dec 2022 13:58:08 -0800 (PST)
MIME-Version: 1.0
References: <20221219191855.2010466-1-allenwebb@google.com>
 <20221219204619.2205248-1-allenwebb@google.com> <20221219204619.2205248-3-allenwebb@google.com>
 <Y6FaUynXTrYD6OYT@kroah.com> <CAJzde04Hbd2+s-Bqog2V81dBEeZD7WWaFCf2BkesQS4yUAKiNA@mail.gmail.com>
 <Y6H6/U0w96Z4kpDn@bombadil.infradead.org> <CAJzde04igO0LJ46Hsbcm-hJBFtPdqJC6svaoMkb3WBG0e1fGBw@mail.gmail.com>
 <Y6IDOwxOxZpsdtiu@bombadil.infradead.org> <CAJzde06q3w7CHd8FSs-bwS3EeVv6xrBzCwerQVqps49V=_voQQ@mail.gmail.com>
 <Y6IVDE3NEE6teggy@bombadil.infradead.org>
In-Reply-To: <Y6IVDE3NEE6teggy@bombadil.infradead.org>
From:   Allen Webb <allenwebb@google.com>
Date:   Tue, 20 Dec 2022 15:57:57 -0600
Message-ID: <CAJzde07U3Y9LZfVHUA-YevRUqA7tDmS=3sBDYpEZM8FSZUTCnA@mail.gmail.com>
Subject: Re: [PATCH v9 02/10] rockchip-mailbox: Fix typo
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Nick Alcock <nick.alcock@oracle.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>, stable@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 20, 2022 at 2:03 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> On Tue, Dec 20, 2022 at 01:49:04PM -0600, Allen Webb wrote:
> > I took another stab at clarifying (and also dropped the ifdev since
> > the same macro works both for separate and built-in modules:
> >
> > /*
> >  * Creates an alias so file2alias.c can find device table.
> >  *
> >  * Use this in cases where a device table is used to match devices because it
> >  * surfaces match-id based module aliases to userspace for:
> >  *   - Automatic module loading.
> >  *   - Tools like USBGuard which allow or block devices based on policy such as
> >  *     which modules match a device.
> >  *
> >  * The module name is included in the alias for two reasons:
> >  *   - It avoids creating two aliases with the same name for built-in modules.
> >  *     Historically MODULE_DEVICE_TABLE was a no-op for built-in modules, so
> >  *     there was nothing to stop different modules from having the same device
> >  *     table name and consequently the same alias when building as a module.
> >  *   - The module name is needed by files2alias.c to associate a particular
> >  *     device table with its associated module for built-in modules since
> >  *     files2alias would otherwise see the module name as `vmlinuz.o`.
> >  */
>
> This is still weak in light of the questions I had. It does not make it
> easy for a driver developer who is going to support only built-in only
> if they need to define this or not. And it seems we're still discussing
> the merits of this, so I'd wait until this is fleshed out, but I think
> we are on the right track finally.
>
> > The deciding factor in whether it makes sense to remove these vs fix
> > them seems to be, "How complete do we want modules.builtin.alias to
> > be?"
> >
> > Arguably we should just drop these in cases where there isn't an
> > "authorized" sysfs attribute but following that logic there is not any
> > reason to generate built-in aliases for anything except USB and
> > thunderbolt.
>
> There we go, now we have a *real* use case for this for built-in stuff
> to consider. Is USBGuard effective even for built-in stuff?

Yes, just because a module is loaded doesn't mean a specific device
has probed the driver yet.

>
> Given everything discussed so far I'd like to get clarification if it
> even help for built-in USB / thunderbolt. Does it? If so how? What could
> userspace do with this information if the driver is already built-in?

We are not trying to stop the module from being loaded (which is
always the case for built-in modules) and in fact it is possible to
have devices already using the module and still not authorize (and by
extension probe the module for) newly connected devices.

For example someone might have an unattended computer downloading
installation media to a USB drive. Presumably this computer would be
locked to make it more difficult for a bad actor to access the
computer. Since USB storage devices are not needed to interact with
the lock screen, we can use the authorized_default sysfs attribute to
not allow new USB devices to probe modules by default and have
USBGuard vet the devices. Mice, keyboards, etc can be allowed so that
the lock screen can still be used (this important in cases like
suspend+resume or docks).

>
> > On the flip side, if we are going to the effort to make this a generic
> > solution that covers everything, the built-in aliases are only as
> > useful as they are complete, so we would want everything that defines
> > a device table to call the macro correctly.
>
> It is the ambiguity which is terrible to add. If the only use case is
> for USB and Thunderbolt then we can spell it out, then only those driver
> developers would care to consider it if the driver is bool. And, a
> respective tooling would scrape only those drivers to verify if the
> table is missing for built-in too.

I was aiming to write it so that it wouldn't easily become obsolete by
later changes, so tying it to the authorized and authorized_default
sysfs attributes is probably the ideal deciding factor and listing USB
and thunderbolt as examples makes sense.

>
> > It definitely is needed for never-tristate modules that match devices
> > in subsystems that surface the authorized attribute.
>
> What is this "authorized attribute" BTW exactly? Do have some
> documentation reference?

There are sysfs attributes called  authorized and authorized_default
that together can prevent devices from being fully enumerated and
probed. authorized_default gets set to 0 for the hub and any devices
connected after that will show in sysfs, but not fully enumerate or
probe until the device's authorized attribute is set to 1. There are
some edge cases like internal devices which have some extra
complexity.

As for documentation, I wasn't able to find much other than:
https://github.com/torvalds/linux/blob/v6.1/drivers/usb/core/hcd.c#L370
/* authorized_default behaviour:
* -1 is authorized for all devices except wireless (old behaviour)
* 0 is unauthorized for all devices
* 1 is authorized for all devices
* 2 is authorized for internal devices
*/
...
and
https://github.com/torvalds/linux/blob/v6.1/Documentation/admin-guide/kernel-parameters.txt#L6424
usbcore.authorized_default=
   [USB] Default USB device authorization:
   (default -1 = authorized except for wireless USB,
   0 = not authorized, 1 = authorized, 2 = authorized
   if device connected to internal port)
...

The feature looks like it was originally introduced for wireless USB in:
https://www.mail-archive.com/linux-usb-devel@lists.sourceforge.net/msg54289.html
and later adapted for use cases like USBGuard here:
https://github.com/torvalds/linux/commit/c4fc2342cb611f945fa468e742759e25984005ad

>
>   Luis
