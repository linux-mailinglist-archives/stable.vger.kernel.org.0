Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1100B66362F
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 01:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235137AbjAJAZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 19:25:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234752AbjAJAZz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 19:25:55 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C4EC2C8;
        Mon,  9 Jan 2023 16:25:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XxI1FtEOKJucG5Qcym68EofhqpO+/9aBkz/BrBBt+SM=; b=NKH3cMK5Yu6kPQZicJqlX/w/GL
        8dsJS09R579dALKb3jocaAF0qqfpGJ/gnMz5oCSt8WsSPq99mvHMoq3CJAmQh1G/XVfbsAK1ynLig
        /sB0HMD8FTOhqKCNWVH5T5e5+VUEjLP82e4zZivHfU0EosdhLayUuNajXaGqajU1KFibqLAgx+p/D
        kkJxLeF64FJWpQUG6E0p7s5ZIcai85HrDAXOD0t6Fi0TumxH7lwGw16/oyhGbUh8upYTuaXzbasSy
        D2re3jKDQ/8DGyFpMMqgUSeKhYsU9ZsmUF4R/njlcCKOfI9PSpdHpQGqKTlO/1psBQmbhl5QilTft
        JWzU6dAg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pF2SY-004kWU-Oy; Tue, 10 Jan 2023 00:25:46 +0000
Date:   Mon, 9 Jan 2023 16:25:46 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Allen Webb <allenwebb@google.com>
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
        kernel test robot <lkp@intel.com>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Davidlohr Bueso <dave@stgolabs.net>, mcgrof@kernel.org
Subject: Re: [PATCH v9 02/10] rockchip-mailbox: Fix typo
Message-ID: <Y7ywiu1fAdrbsxt0@bombadil.infradead.org>
References: <Y6FaUynXTrYD6OYT@kroah.com>
 <CAJzde04Hbd2+s-Bqog2V81dBEeZD7WWaFCf2BkesQS4yUAKiNA@mail.gmail.com>
 <Y6H6/U0w96Z4kpDn@bombadil.infradead.org>
 <CAJzde04igO0LJ46Hsbcm-hJBFtPdqJC6svaoMkb3WBG0e1fGBw@mail.gmail.com>
 <Y6IDOwxOxZpsdtiu@bombadil.infradead.org>
 <CAJzde06q3w7CHd8FSs-bwS3EeVv6xrBzCwerQVqps49V=_voQQ@mail.gmail.com>
 <Y6IVDE3NEE6teggy@bombadil.infradead.org>
 <CAJzde07U3Y9LZfVHUA-YevRUqA7tDmS=3sBDYpEZM8FSZUTCnA@mail.gmail.com>
 <Y6JAwxvptrMrK353@bombadil.infradead.org>
 <CAJzde04UfPMTxiUaGjSYZBVMfcpVz1S9fTiGWYnCB0_yM0MaQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJzde04UfPMTxiUaGjSYZBVMfcpVz1S9fTiGWYnCB0_yM0MaQw@mail.gmail.com>
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

On Tue, Dec 27, 2022 at 11:42:36AM -0600, Allen Webb wrote:
> On Tue, Dec 20, 2022 at 5:09 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> > I think it would make sense then to be explicit about this for now, even
> > if it seems we can obsolete this. Right now the justification for having
> > this for built-in is *very* specific to this feature for USB, which
> > makes use of special USB sysfs attributes which as you explained, allows
> > to restrict probe of devices even though the respective driver is already
> > loaded.
> 
> The thing we might obsolete is limiting it to just the USB subsystem.
> I am fine with expanding the documentation and limiting the scope of
> the feature to USB/thunderbolt for now.

Great let's do that as otherwise it can leave a few folks scratchign
their head.

> > > There are sysfs attributes called  authorized and authorized_default
> > > that together can prevent devices from being fully enumerated and
> > > probed.
> >
> > Although these attributes are USB specfic today it gets me wondering if
> > other subsystems may benefit from a similar feature.
> 
> The subsystems that would likely benefit the most are ones that are
> externally reachable. 

Makes sense.

> The external ports that come to mind are USB /
> thunderbolt, firewire, PCMCIA / expresscard, eSATA, serial and
> parallel ports. Supporting PCMCIA / expresscard seems like it would
> require adding the authorized sysfs attribute to pci. eSATA would be
> covered by ata.

Makes sense, I'd personally ignore anything legacy such as PCMCIA though.

> > > authorized_default gets set to 0 for the hub and any devices
> > > connected after that will show in sysfs, but not fully enumerate or
> > > probe until the device's authorized attribute is set to 1. There are
> > > some edge cases like internal devices which have some extra
> > > complexity.
> > >
> > > As for documentation, I wasn't able to find much other than:
> > > https://github.com/torvalds/linux/blob/v6.1/drivers/usb/core/hcd.c#L370
> > > /* authorized_default behaviour:
> > > * -1 is authorized for all devices except wireless (old behaviour)
> > > * 0 is unauthorized for all devices
> > > * 1 is authorized for all devices
> > > * 2 is authorized for internal devices
> > > */
> > > ...
> > > and
> > > https://github.com/torvalds/linux/blob/v6.1/Documentation/admin-guide/kernel-parameters.txt#L6424
> > > usbcore.authorized_default=
> > >    [USB] Default USB device authorization:
> > >    (default -1 = authorized except for wireless USB,
> > >    0 = not authorized, 1 = authorized, 2 = authorized
> > >    if device connected to internal port)
> > > ...
> > > The feature looks like it was originally introduced for wireless USB in:
> > > https://www.mail-archive.com/linux-usb-devel@lists.sourceforge.net/msg54289.html
> > > and later adapted for use cases like USBGuard here:
> > > https://github.com/torvalds/linux/commit/c4fc2342cb611f945fa468e742759e25984005ad
> >
> > Thanks for digging all this up. Can you extend the docs on
> > Documentation/driver-api/usb/ somewhere about this attribute as part of
> > your changes so its clear the motivation, *then* you make your changes.
> > The documentation for MODULE_DEVICE_TABLE() can just say:
> >
> > The only use-case for built-in drivers today is enable userspace to
> > prevent / allow probe for devices on certain subsystems even if the
> > driver is already loaded. An example is the USB subsystem with its
> > authorized_default sysfs attribute. For more details refer to the
> > kernel's Documentation for USB about authorized_default.
> >
> > That should be clear enough for both USB driver writers and others.
> >
> > Please also extend the docs for MODULE_DEVICE_TABLE() on
> > Documentation/driver-api/usb/writing_usb_driver.rst or where you see
> > fit for your changes. That can go into depth about the USBGuard stuff.
> >
> >   Luis
> 
> How do you feel about only having one version of the macro for both
> cases and merging the documentation so things are kept simple? Here is
> what I have locally for the macro without the ifdef and the updated
> documentation:
> 
> /*
>  * Creates an alias so file2alias.c can find device table.
>  *
>  * Use this in cases where a device table is used to match devices because it
>  * surfaces match-id based module aliases to userspace for:
>  *   - Automatic module loading through modules.alias.
>  *   - Tools like USBGuard which allow or block devices based on policy such as
                                 ^ allow to

>  *     which modules match a device.
>  *
>  * The only use-case for built-in drivers today is enable userspace to prevent /

                                                ^ is to

>  * allow probe for devices on certain subsystems even if the driver is already
>  * loaded. An example is the USB subsystem with its authorized_default sysfs
>  * attribute. For more details refer to the kernel's Documentation for USB about
>  * authorized_default.
>  *
>  * The module name is included in the alias for two reasons:
>  *   - It avoids creating two aliases with the same name for built-in modules.
>  *     Historically MODULE_DEVICE_TABLE was a no-op for built-in modules, so
>  *     there was nothing to stop different modules from having the same device
>  *     table name and consequently the same alias when building as a module.
>  *   - The module name is needed by files2alias.c to associate a particular
>  *     device table with its associated module for built-in modules since
>  *     files2alias would otherwise see the module name as `vmlinuz.o`.

Yeah sure this reads much better.

>  */
> #define MODULE_DEVICE_TABLE(type, name) \
> extern void *CONCATENATE( \
> CONCATENATE(__mod_##type##__##name##__, \
> __KBUILD_MODNAME), \
> _device_table) \
> __attribute__ ((unused, alias(__stringify(name))))
> 
> 
> Here is a draft version for an updated to
> Documentation/driver-api/usb/ (I will add the 80 char line breaks
> later) in case you have feedback:
> 
> 
> # Authorization
> 
> Authorization provides userspace a way to allow or block configuring
> devices early during enumeration before any modules are probed for the
> device. While it is possible to block a device by not loading the
> required modules, this also prevents other devices from using the
> module as well. For example someone might have an unattended computer
> downloading installation media to a USB drive. Presumably this
> computer would be locked to make it more difficult for a bad actor to
> access the computer. Since USB storage devices are not needed to
> interact with the lock screen, the authorized_default sysfs attribute
> can be set to not authorize new USB devices by default. A userspace
> tool like USBGuard can then vet the devices. Mice, keyboards, etc can
> be allowed by writing to their authorized sysfs attribute so that the
> lock screen can still be used (this important in cases like
> suspend+resume or docks) while other devices can be blocked as long as
> the lock screen is shown.
> 
> ## Sysfs Attributes
> 
> Userspace can control USB device authorization through the
> authorized_default and authorized sysfs attributes.
> 
> ### authorized_default
> 
> .. kernel-doc:: drivers/usb/core/hcd.c
>    :export:
> 
> The authorized_default sysfs attribute is only present for host
> controllers. It determines the initial state of the authorized sysfs
> attribute of USB devices newly connected to the corresponding host
> controller. It can take on the following values:
> 
> +---------------------------------------------------+
> | Value | Behavior                                  |
> +=======+===========================================+
> |    -1 | Authorize all devices except wireless USB |
> +-------+-------------------------------------------+
> |     0 | Do not authorize new devices              |
> +-------+-------------------------------------------+
> |     1 | Authorize new devices                     |
> +-------+-------------------------------------------+
> |     2 | Authorize new internal devices only       |
> +---------------------------------------------------+
> 
> Note that firmware platform code determines if a device is internal or
> not and this is reported as the connect_type sysfs attribute of the
> USB port. This is currently supported by ACPI, but device tree still
> needs an implementation. Authorizing new internal devices only can be
> useful to work around issues with devices that misbehave if there are
> delays in probing their module.
> 
> ### authorized
> 
> .. kernel-doc:: drivers/usb/core/sysfs.c
>    :export:
> 
> Every USB device has an authorized sysfs attribute which can take the
> values 0 and 1. When authorized is 0, the device still is present in
> sysfs, but none of its interfaces can be associated with drivers and
> modules will not be probed. When authorized is 1 (or set to one) a
> configuration is chosen for the device and its interfaces are
> registered allowing drivers to bind to them.

Good stuff!

  Luis
