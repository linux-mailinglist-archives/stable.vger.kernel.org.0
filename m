Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31F2F652784
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 21:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234058AbiLTUDc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 15:03:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232195AbiLTUDa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 15:03:30 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C33A91D321;
        Tue, 20 Dec 2022 12:03:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=UlAEvc5vrzcxeVoggj4bi4wq684c5KQyaWNN4gbqhuI=; b=jyIHu/BsHD4RKeUC+9/gkw5a8x
        9UhiqjxcN4ZnmrJ6qjyf6nS+b9Mor/YznV+zrh7vcDYRwGXa2T7VT1aSHMH6aA6NXsabAFn1FEkS/
        acCKvzNcVWH1MdLQFY9b7s9erGWNKtuRpI7sJTej22och5Vhabr9d0uTPRl37LqB2ApTqfhiIogDz
        llNQBcHXYalrdeRR50pXhOHjY/2oE2AVqQQuPH9VgFy92uzIw1xGVMmYy0lZxupGbJZe+a+9TxTEr
        QwiE8Os3w9fhkriWNev9KvKa2ZBpaPrj3eoCrE9zcBMo0QkRQHT3UzeO5EFRDGd8ALVHAA0FBSUQO
        8e8TA4LA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p7ipg-003fXB-Vh; Tue, 20 Dec 2022 20:03:24 +0000
Date:   Tue, 20 Dec 2022 12:03:24 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Allen Webb <allenwebb@google.com>
Cc:     Nick Alcock <nick.alcock@oracle.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>, stable@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v9 02/10] rockchip-mailbox: Fix typo
Message-ID: <Y6IVDE3NEE6teggy@bombadil.infradead.org>
References: <20221219191855.2010466-1-allenwebb@google.com>
 <20221219204619.2205248-1-allenwebb@google.com>
 <20221219204619.2205248-3-allenwebb@google.com>
 <Y6FaUynXTrYD6OYT@kroah.com>
 <CAJzde04Hbd2+s-Bqog2V81dBEeZD7WWaFCf2BkesQS4yUAKiNA@mail.gmail.com>
 <Y6H6/U0w96Z4kpDn@bombadil.infradead.org>
 <CAJzde04igO0LJ46Hsbcm-hJBFtPdqJC6svaoMkb3WBG0e1fGBw@mail.gmail.com>
 <Y6IDOwxOxZpsdtiu@bombadil.infradead.org>
 <CAJzde06q3w7CHd8FSs-bwS3EeVv6xrBzCwerQVqps49V=_voQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJzde06q3w7CHd8FSs-bwS3EeVv6xrBzCwerQVqps49V=_voQQ@mail.gmail.com>
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

On Tue, Dec 20, 2022 at 01:49:04PM -0600, Allen Webb wrote:
> I took another stab at clarifying (and also dropped the ifdev since
> the same macro works both for separate and built-in modules:
> 
> /*
>  * Creates an alias so file2alias.c can find device table.
>  *
>  * Use this in cases where a device table is used to match devices because it
>  * surfaces match-id based module aliases to userspace for:
>  *   - Automatic module loading.
>  *   - Tools like USBGuard which allow or block devices based on policy such as
>  *     which modules match a device.
>  *
>  * The module name is included in the alias for two reasons:
>  *   - It avoids creating two aliases with the same name for built-in modules.
>  *     Historically MODULE_DEVICE_TABLE was a no-op for built-in modules, so
>  *     there was nothing to stop different modules from having the same device
>  *     table name and consequently the same alias when building as a module.
>  *   - The module name is needed by files2alias.c to associate a particular
>  *     device table with its associated module for built-in modules since
>  *     files2alias would otherwise see the module name as `vmlinuz.o`.
>  */

This is still weak in light of the questions I had. It does not make it
easy for a driver developer who is going to support only built-in only
if they need to define this or not. And it seems we're still discussing
the merits of this, so I'd wait until this is fleshed out, but I think
we are on the right track finally.

> The deciding factor in whether it makes sense to remove these vs fix
> them seems to be, "How complete do we want modules.builtin.alias to
> be?"
> 
> Arguably we should just drop these in cases where there isn't an
> "authorized" sysfs attribute but following that logic there is not any
> reason to generate built-in aliases for anything except USB and
> thunderbolt.

There we go, now we have a *real* use case for this for built-in stuff
to consider. Is USBGuard effective even for built-in stuff?

Given everything discussed so far I'd like to get clarification if it
even help for built-in USB / thunderbolt. Does it? If so how? What could
userspace do with this information if the driver is already built-in?

> On the flip side, if we are going to the effort to make this a generic
> solution that covers everything, the built-in aliases are only as
> useful as they are complete, so we would want everything that defines
> a device table to call the macro correctly.

It is the ambiguity which is terrible to add. If the only use case is
for USB and Thunderbolt then we can spell it out, then only those driver
developers would care to consider it if the driver is bool. And, a
respective tooling would scrape only those drivers to verify if the
table is missing for built-in too.

> It definitely is needed for never-tristate modules that match devices
> in subsystems that surface the authorized attribute.

What is this "authorized attribute" BTW exactly? Do have some
documentation reference?

  Luis
