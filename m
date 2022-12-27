Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A079656D8A
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 18:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbiL0RnD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 12:43:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232135AbiL0Rmv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 12:42:51 -0500
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF4EC757
        for <stable@vger.kernel.org>; Tue, 27 Dec 2022 09:42:49 -0800 (PST)
Received: by mail-vs1-xe30.google.com with SMTP id 3so13259024vsq.7
        for <stable@vger.kernel.org>; Tue, 27 Dec 2022 09:42:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vlA4yo04qFmJXSXSGAagY9ukYh5f25KWdaiUbu1cI5A=;
        b=E75waJvoop80bOOovEoSWJcaZjg9LEDBnf2Dznk6/piFF7d2Uau7E61fz4Mmzp5583
         m2mGJ0vDRgRFKv3u9M5NE0JjfaiPmcCZr4PSVLFZ+HMjJB+en4ycQl6E3sKwtwoG+7VC
         zWQP8TxVphT//Kgv5Ot23UKemnFiCfCMSYEOseBvn+i1QH+PkdJTzyBT34AmRR4zw2En
         fJn1GQ/EWIww2R+9UviZ0Epz6dNuK2BvRVJdEx0Oy2kcU7r9PFlDEj+OOS6NJLnvMkoE
         GklI8LJyEVA3JBMAIFY1EVcH19pPuw1hkFq5Xz7KJzks9SUYwecB8TM+2KNDMy2vlpyI
         bXfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vlA4yo04qFmJXSXSGAagY9ukYh5f25KWdaiUbu1cI5A=;
        b=xoxkD/iDtZq/qeyHoERAo869R055xV1OFEJDJNjZxdAoZ9zQtsDuzsIqtyGVTzFp6V
         KBWifTPg3DXcCeTQJg5BnxhrO7q3qq+dYtB8kMoW36jH4VjVENu2MrJSmHQMSd3FnCZs
         R7mk+kn+UIrIfBWJiTfpZH3C6nAV5yBMpTbp9pqAqw9sOiA/Nwt2T8djIHMr9fo58pzY
         LS51M4lycWi4CwID8ustvypY5KGlQO4UbkXn4dpPLOcbQOMETHxMda65JBzCgNiu2zu6
         QKgd9G/rUNgE7FsNu5SmcY9KzoxU/KnFZT2AeowQkHVyTVfzIFtRzAkPhZJiXmhd5Qqb
         avHA==
X-Gm-Message-State: AFqh2kquQsJXxVDm44F0GOquS2kpm7yavt/3WQZKcHUrYU7LsT8JrvF0
        1cv+K44MkP0LVhlVdV6S9d9U7P/vRxY+ot5D6AlQvw==
X-Google-Smtp-Source: AMrXdXsQ73pyCf49p2T/knn92cEWlG/tRX2dRLS7zp0oCuNGMzKV48WHNaDERlhslwLKYFyonSvTgwL9j/rSxxBAFNE=
X-Received: by 2002:a67:ea07:0:b0:3aa:4645:63d with SMTP id
 g7-20020a67ea07000000b003aa4645063dmr2182959vso.31.1672162968137; Tue, 27 Dec
 2022 09:42:48 -0800 (PST)
MIME-Version: 1.0
References: <20221219204619.2205248-1-allenwebb@google.com>
 <20221219204619.2205248-3-allenwebb@google.com> <Y6FaUynXTrYD6OYT@kroah.com>
 <CAJzde04Hbd2+s-Bqog2V81dBEeZD7WWaFCf2BkesQS4yUAKiNA@mail.gmail.com>
 <Y6H6/U0w96Z4kpDn@bombadil.infradead.org> <CAJzde04igO0LJ46Hsbcm-hJBFtPdqJC6svaoMkb3WBG0e1fGBw@mail.gmail.com>
 <Y6IDOwxOxZpsdtiu@bombadil.infradead.org> <CAJzde06q3w7CHd8FSs-bwS3EeVv6xrBzCwerQVqps49V=_voQQ@mail.gmail.com>
 <Y6IVDE3NEE6teggy@bombadil.infradead.org> <CAJzde07U3Y9LZfVHUA-YevRUqA7tDmS=3sBDYpEZM8FSZUTCnA@mail.gmail.com>
 <Y6JAwxvptrMrK353@bombadil.infradead.org>
In-Reply-To: <Y6JAwxvptrMrK353@bombadil.infradead.org>
From:   Allen Webb <allenwebb@google.com>
Date:   Tue, 27 Dec 2022 11:42:36 -0600
Message-ID: <CAJzde04UfPMTxiUaGjSYZBVMfcpVz1S9fTiGWYnCB0_yM0MaQw@mail.gmail.com>
Subject: Re: [PATCH v9 02/10] rockchip-mailbox: Fix typo
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Nick Alcock <nick.alcock@oracle.com>,
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 20, 2022 at 5:09 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> On Tue, Dec 20, 2022 at 03:57:57PM -0600, Allen Webb wrote:
> > On Tue, Dec 20, 2022 at 2:03 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> > >
> > > On Tue, Dec 20, 2022 at 01:49:04PM -0600, Allen Webb wrote:
> > > > I took another stab at clarifying (and also dropped the ifdev since
> > > > the same macro works both for separate and built-in modules:
> > > >
> > > > /*
> > > >  * Creates an alias so file2alias.c can find device table.
> > > >  *
> > > >  * Use this in cases where a device table is used to match devices because it
> > > >  * surfaces match-id based module aliases to userspace for:
> > > >  *   - Automatic module loading.
> > > >  *   - Tools like USBGuard which allow or block devices based on policy such as
> > > >  *     which modules match a device.
> > > >  *
> > > >  * The module name is included in the alias for two reasons:
> > > >  *   - It avoids creating two aliases with the same name for built-in modules.
> > > >  *     Historically MODULE_DEVICE_TABLE was a no-op for built-in modules, so
> > > >  *     there was nothing to stop different modules from having the same device
> > > >  *     table name and consequently the same alias when building as a module.
> > > >  *   - The module name is needed by files2alias.c to associate a particular
> > > >  *     device table with its associated module for built-in modules since
> > > >  *     files2alias would otherwise see the module name as `vmlinuz.o`.
> > > >  */
> > >
> > > This is still weak in light of the questions I had. It does not make it
> > > easy for a driver developer who is going to support only built-in only
> > > if they need to define this or not. And it seems we're still discussing
> > > the merits of this, so I'd wait until this is fleshed out, but I think
> > > we are on the right track finally.
> > >
> > > > The deciding factor in whether it makes sense to remove these vs fix
> > > > them seems to be, "How complete do we want modules.builtin.alias to
> > > > be?"
> > > >
> > > > Arguably we should just drop these in cases where there isn't an
> > > > "authorized" sysfs attribute but following that logic there is not any
> > > > reason to generate built-in aliases for anything except USB and
> > > > thunderbolt.
> > >
> > > There we go, now we have a *real* use case for this for built-in stuff
> > > to consider. Is USBGuard effective even for built-in stuff?
> >
> > Yes, just because a module is loaded doesn't mean a specific device
> > has probed the driver yet.
> >
> > >
> > > Given everything discussed so far I'd like to get clarification if it
> > > even help for built-in USB / thunderbolt. Does it? If so how? What could
> > > userspace do with this information if the driver is already built-in?
> >
> > We are not trying to stop the module from being loaded (which is
> > always the case for built-in modules) and in fact it is possible to
> > have devices already using the module and still not authorize (and by
> > extension probe the module for) newly connected devices.
> >
> > For example someone might have an unattended computer downloading
> > installation media to a USB drive. Presumably this computer would be
> > locked to make it more difficult for a bad actor to access the
> > computer. Since USB storage devices are not needed to interact with
> > the lock screen, we can use the authorized_default sysfs attribute to
> > not allow new USB devices to probe modules by default and have
> > USBGuard vet the devices. Mice, keyboards, etc can be allowed so that
> > the lock screen can still be used (this important in cases like
> > suspend+resume or docks).
>
> I see thanks!
>
> > > > On the flip side, if we are going to the effort to make this a generic
> > > > solution that covers everything, the built-in aliases are only as
> > > > useful as they are complete, so we would want everything that defines
> > > > a device table to call the macro correctly.
> > >
> > > It is the ambiguity which is terrible to add. If the only use case is
> > > for USB and Thunderbolt then we can spell it out, then only those driver
> > > developers would care to consider it if the driver is bool. And, a
> > > respective tooling would scrape only those drivers to verify if the
> > > table is missing for built-in too.
> >
> > I was aiming to write it so that it wouldn't easily become obsolete by
> > later changes, so tying it to the authorized and authorized_default
> > sysfs attributes is probably the ideal deciding factor and listing USB
> > and thunderbolt as examples makes sense.
>
> I think it would make sense then to be explicit about this for now, even
> if it seems we can obsolete this. Right now the justification for having
> this for built-in is *very* specific to this feature for USB, which
> makes use of special USB sysfs attributes which as you explained, allows
> to restrict probe of devices even though the respective driver is already
> loaded.

The thing we might obsolete is limiting it to just the USB subsystem.
I am fine with expanding the documentation and limiting the scope of
the feature to USB/thunderbolt for now.

>
> > There are sysfs attributes called  authorized and authorized_default
> > that together can prevent devices from being fully enumerated and
> > probed.
>
> Although these attributes are USB specfic today it gets me wondering if
> other subsystems may benefit from a similar feature.

The subsystems that would likely benefit the most are ones that are
externally reachable. The external ports that come to mind are USB /
thunderbolt, firewire, PCMCIA / expresscard, eSATA, serial and
parallel ports. Supporting PCMCIA / expresscard seems like it would
require adding the authorized sysfs attribute to pci. eSATA would be
covered by ata.

>
> > authorized_default gets set to 0 for the hub and any devices
> > connected after that will show in sysfs, but not fully enumerate or
> > probe until the device's authorized attribute is set to 1. There are
> > some edge cases like internal devices which have some extra
> > complexity.
> >
> > As for documentation, I wasn't able to find much other than:
> > https://github.com/torvalds/linux/blob/v6.1/drivers/usb/core/hcd.c#L370
> > /* authorized_default behaviour:
> > * -1 is authorized for all devices except wireless (old behaviour)
> > * 0 is unauthorized for all devices
> > * 1 is authorized for all devices
> > * 2 is authorized for internal devices
> > */
> > ...
> > and
> > https://github.com/torvalds/linux/blob/v6.1/Documentation/admin-guide/kernel-parameters.txt#L6424
> > usbcore.authorized_default=
> >    [USB] Default USB device authorization:
> >    (default -1 = authorized except for wireless USB,
> >    0 = not authorized, 1 = authorized, 2 = authorized
> >    if device connected to internal port)
> > ...
> > The feature looks like it was originally introduced for wireless USB in:
> > https://www.mail-archive.com/linux-usb-devel@lists.sourceforge.net/msg54289.html
> > and later adapted for use cases like USBGuard here:
> > https://github.com/torvalds/linux/commit/c4fc2342cb611f945fa468e742759e25984005ad
>
> Thanks for digging all this up. Can you extend the docs on
> Documentation/driver-api/usb/ somewhere about this attribute as part of
> your changes so its clear the motivation, *then* you make your changes.
> The documentation for MODULE_DEVICE_TABLE() can just say:
>
> The only use-case for built-in drivers today is enable userspace to
> prevent / allow probe for devices on certain subsystems even if the
> driver is already loaded. An example is the USB subsystem with its
> authorized_default sysfs attribute. For more details refer to the
> kernel's Documentation for USB about authorized_default.
>
> That should be clear enough for both USB driver writers and others.
>
> Please also extend the docs for MODULE_DEVICE_TABLE() on
> Documentation/driver-api/usb/writing_usb_driver.rst or where you see
> fit for your changes. That can go into depth about the USBGuard stuff.
>
>   Luis

How do you feel about only having one version of the macro for both
cases and merging the documentation so things are kept simple? Here is
what I have locally for the macro without the ifdef and the updated
documentation:

/*
 * Creates an alias so file2alias.c can find device table.
 *
 * Use this in cases where a device table is used to match devices because it
 * surfaces match-id based module aliases to userspace for:
 *   - Automatic module loading through modules.alias.
 *   - Tools like USBGuard which allow or block devices based on policy such as
 *     which modules match a device.
 *
 * The only use-case for built-in drivers today is enable userspace to prevent /
 * allow probe for devices on certain subsystems even if the driver is already
 * loaded. An example is the USB subsystem with its authorized_default sysfs
 * attribute. For more details refer to the kernel's Documentation for USB about
 * authorized_default.
 *
 * The module name is included in the alias for two reasons:
 *   - It avoids creating two aliases with the same name for built-in modules.
 *     Historically MODULE_DEVICE_TABLE was a no-op for built-in modules, so
 *     there was nothing to stop different modules from having the same device
 *     table name and consequently the same alias when building as a module.
 *   - The module name is needed by files2alias.c to associate a particular
 *     device table with its associated module for built-in modules since
 *     files2alias would otherwise see the module name as `vmlinuz.o`.
 */
#define MODULE_DEVICE_TABLE(type, name) \
extern void *CONCATENATE( \
CONCATENATE(__mod_##type##__##name##__, \
__KBUILD_MODNAME), \
_device_table) \
__attribute__ ((unused, alias(__stringify(name))))


Here is a draft version for an updated to
Documentation/driver-api/usb/ (I will add the 80 char line breaks
later) in case you have feedback:


# Authorization

Authorization provides userspace a way to allow or block configuring
devices early during enumeration before any modules are probed for the
device. While it is possible to block a device by not loading the
required modules, this also prevents other devices from using the
module as well. For example someone might have an unattended computer
downloading installation media to a USB drive. Presumably this
computer would be locked to make it more difficult for a bad actor to
access the computer. Since USB storage devices are not needed to
interact with the lock screen, the authorized_default sysfs attribute
can be set to not authorize new USB devices by default. A userspace
tool like USBGuard can then vet the devices. Mice, keyboards, etc can
be allowed by writing to their authorized sysfs attribute so that the
lock screen can still be used (this important in cases like
suspend+resume or docks) while other devices can be blocked as long as
the lock screen is shown.

## Sysfs Attributes

Userspace can control USB device authorization through the
authorized_default and authorized sysfs attributes.

### authorized_default

.. kernel-doc:: drivers/usb/core/hcd.c
   :export:

The authorized_default sysfs attribute is only present for host
controllers. It determines the initial state of the authorized sysfs
attribute of USB devices newly connected to the corresponding host
controller. It can take on the following values:

+---------------------------------------------------+
| Value | Behavior                                  |
+=======+===========================================+
|    -1 | Authorize all devices except wireless USB |
+-------+-------------------------------------------+
|     0 | Do not authorize new devices              |
+-------+-------------------------------------------+
|     1 | Authorize new devices                     |
+-------+-------------------------------------------+
|     2 | Authorize new internal devices only       |
+---------------------------------------------------+

Note that firmware platform code determines if a device is internal or
not and this is reported as the connect_type sysfs attribute of the
USB port. This is currently supported by ACPI, but device tree still
needs an implementation. Authorizing new internal devices only can be
useful to work around issues with devices that misbehave if there are
delays in probing their module.

### authorized

.. kernel-doc:: drivers/usb/core/sysfs.c
   :export:

Every USB device has an authorized sysfs attribute which can take the
values 0 and 1. When authorized is 0, the device still is present in
sysfs, but none of its interfaces can be associated with drivers and
modules will not be probed. When authorized is 1 (or set to one) a
configuration is chosen for the device and its interfaces are
registered allowing drivers to bind to them.
