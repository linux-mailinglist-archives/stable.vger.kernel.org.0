Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8D0565299C
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 00:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiLTXKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 18:10:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiLTXKD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 18:10:03 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A53A21F2FC;
        Tue, 20 Dec 2022 15:10:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=c7lTVhEuObh7+HTb2Ar1hHIaL2a3mkwkNRtynD/whrQ=; b=hypaAAt3AppTZfOuFVvKh7Jsy6
        RpCOaUdcy5IkXQp0u8BhK9fXJbiHKQkU2U7aaD6wzmw1nV4IkTeXRpHIy3P6oyQ2czUw718bSsd5C
        jmek9XttXhP1mwMfQjqSU/FmZkrKrOuoQxm1toC687DAZ4JLjXo81E7+wUptAgQVOFEOiVHUo07X/
        uPHpA97ZswZWLaMTK0nhkqPKqtdqlSxw5quep7vkNlHxNxGk3yARire/U6v2Z4/xP2eANCLqEMlak
        Ht/8+q9jeUyNBnWL89gA6S2lgoYwtXlJussLzyk706Qa7Zzdgt7mbIalBkw7CMuRY0d3Wdp5BGJye
        dps5duJA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p7lkC-005ghs-16; Tue, 20 Dec 2022 23:09:56 +0000
Date:   Tue, 20 Dec 2022 15:09:55 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Allen Webb <allenwebb@google.com>,
        Kees Cook <keescook@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc:     Nick Alcock <nick.alcock@oracle.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>, stable@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v9 02/10] rockchip-mailbox: Fix typo
Message-ID: <Y6JAwxvptrMrK353@bombadil.infradead.org>
References: <20221219204619.2205248-1-allenwebb@google.com>
 <20221219204619.2205248-3-allenwebb@google.com>
 <Y6FaUynXTrYD6OYT@kroah.com>
 <CAJzde04Hbd2+s-Bqog2V81dBEeZD7WWaFCf2BkesQS4yUAKiNA@mail.gmail.com>
 <Y6H6/U0w96Z4kpDn@bombadil.infradead.org>
 <CAJzde04igO0LJ46Hsbcm-hJBFtPdqJC6svaoMkb3WBG0e1fGBw@mail.gmail.com>
 <Y6IDOwxOxZpsdtiu@bombadil.infradead.org>
 <CAJzde06q3w7CHd8FSs-bwS3EeVv6xrBzCwerQVqps49V=_voQQ@mail.gmail.com>
 <Y6IVDE3NEE6teggy@bombadil.infradead.org>
 <CAJzde07U3Y9LZfVHUA-YevRUqA7tDmS=3sBDYpEZM8FSZUTCnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJzde07U3Y9LZfVHUA-YevRUqA7tDmS=3sBDYpEZM8FSZUTCnA@mail.gmail.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 20, 2022 at 03:57:57PM -0600, Allen Webb wrote:
> On Tue, Dec 20, 2022 at 2:03 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> >
> > On Tue, Dec 20, 2022 at 01:49:04PM -0600, Allen Webb wrote:
> > > I took another stab at clarifying (and also dropped the ifdev since
> > > the same macro works both for separate and built-in modules:
> > >
> > > /*
> > >  * Creates an alias so file2alias.c can find device table.
> > >  *
> > >  * Use this in cases where a device table is used to match devices because it
> > >  * surfaces match-id based module aliases to userspace for:
> > >  *   - Automatic module loading.
> > >  *   - Tools like USBGuard which allow or block devices based on policy such as
> > >  *     which modules match a device.
> > >  *
> > >  * The module name is included in the alias for two reasons:
> > >  *   - It avoids creating two aliases with the same name for built-in modules.
> > >  *     Historically MODULE_DEVICE_TABLE was a no-op for built-in modules, so
> > >  *     there was nothing to stop different modules from having the same device
> > >  *     table name and consequently the same alias when building as a module.
> > >  *   - The module name is needed by files2alias.c to associate a particular
> > >  *     device table with its associated module for built-in modules since
> > >  *     files2alias would otherwise see the module name as `vmlinuz.o`.
> > >  */
> >
> > This is still weak in light of the questions I had. It does not make it
> > easy for a driver developer who is going to support only built-in only
> > if they need to define this or not. And it seems we're still discussing
> > the merits of this, so I'd wait until this is fleshed out, but I think
> > we are on the right track finally.
> >
> > > The deciding factor in whether it makes sense to remove these vs fix
> > > them seems to be, "How complete do we want modules.builtin.alias to
> > > be?"
> > >
> > > Arguably we should just drop these in cases where there isn't an
> > > "authorized" sysfs attribute but following that logic there is not any
> > > reason to generate built-in aliases for anything except USB and
> > > thunderbolt.
> >
> > There we go, now we have a *real* use case for this for built-in stuff
> > to consider. Is USBGuard effective even for built-in stuff?
> 
> Yes, just because a module is loaded doesn't mean a specific device
> has probed the driver yet.
> 
> >
> > Given everything discussed so far I'd like to get clarification if it
> > even help for built-in USB / thunderbolt. Does it? If so how? What could
> > userspace do with this information if the driver is already built-in?
> 
> We are not trying to stop the module from being loaded (which is
> always the case for built-in modules) and in fact it is possible to
> have devices already using the module and still not authorize (and by
> extension probe the module for) newly connected devices.
> 
> For example someone might have an unattended computer downloading
> installation media to a USB drive. Presumably this computer would be
> locked to make it more difficult for a bad actor to access the
> computer. Since USB storage devices are not needed to interact with
> the lock screen, we can use the authorized_default sysfs attribute to
> not allow new USB devices to probe modules by default and have
> USBGuard vet the devices. Mice, keyboards, etc can be allowed so that
> the lock screen can still be used (this important in cases like
> suspend+resume or docks).

I see thanks!

> > > On the flip side, if we are going to the effort to make this a generic
> > > solution that covers everything, the built-in aliases are only as
> > > useful as they are complete, so we would want everything that defines
> > > a device table to call the macro correctly.
> >
> > It is the ambiguity which is terrible to add. If the only use case is
> > for USB and Thunderbolt then we can spell it out, then only those driver
> > developers would care to consider it if the driver is bool. And, a
> > respective tooling would scrape only those drivers to verify if the
> > table is missing for built-in too.
> 
> I was aiming to write it so that it wouldn't easily become obsolete by
> later changes, so tying it to the authorized and authorized_default
> sysfs attributes is probably the ideal deciding factor and listing USB
> and thunderbolt as examples makes sense.

I think it would make sense then to be explicit about this for now, even
if it seems we can obsolete this. Right now the justification for having
this for built-in is *very* specific to this feature for USB, which
makes use of special USB sysfs attributes which as you explained, allows
to restrict probe of devices even though the respective driver is already
loaded.

> There are sysfs attributes called  authorized and authorized_default
> that together can prevent devices from being fully enumerated and
> probed.

Although these attributes are USB specfic today it gets me wondering if
other subsystems may benefit from a similar feature.

> authorized_default gets set to 0 for the hub and any devices
> connected after that will show in sysfs, but not fully enumerate or
> probe until the device's authorized attribute is set to 1. There are
> some edge cases like internal devices which have some extra
> complexity.
> 
> As for documentation, I wasn't able to find much other than:
> https://github.com/torvalds/linux/blob/v6.1/drivers/usb/core/hcd.c#L370
> /* authorized_default behaviour:
> * -1 is authorized for all devices except wireless (old behaviour)
> * 0 is unauthorized for all devices
> * 1 is authorized for all devices
> * 2 is authorized for internal devices
> */
> ...
> and
> https://github.com/torvalds/linux/blob/v6.1/Documentation/admin-guide/kernel-parameters.txt#L6424
> usbcore.authorized_default=
>    [USB] Default USB device authorization:
>    (default -1 = authorized except for wireless USB,
>    0 = not authorized, 1 = authorized, 2 = authorized
>    if device connected to internal port)
> ...
> The feature looks like it was originally introduced for wireless USB in:
> https://www.mail-archive.com/linux-usb-devel@lists.sourceforge.net/msg54289.html
> and later adapted for use cases like USBGuard here:
> https://github.com/torvalds/linux/commit/c4fc2342cb611f945fa468e742759e25984005ad

Thanks for digging all this up. Can you extend the docs on
Documentation/driver-api/usb/ somewhere about this attribute as part of
your changes so its clear the motivation, *then* you make your changes.
The documentation for MODULE_DEVICE_TABLE() can just say:

The only use-case for built-in drivers today is enable userspace to
prevent / allow probe for devices on certain subsystems even if the
driver is already loaded. An example is the USB subsystem with its
authorized_default sysfs attribute. For more details refer to the
kernel's Documentation for USB about authorized_default.

That should be clear enough for both USB driver writers and others.

Please also extend the docs for MODULE_DEVICE_TABLE() on
Documentation/driver-api/usb/writing_usb_driver.rst or where you see
fit for your changes. That can go into depth about the USBGuard stuff.

  Luis
