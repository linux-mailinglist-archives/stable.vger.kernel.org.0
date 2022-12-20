Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC9365274B
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 20:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233957AbiLTTtU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 14:49:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233594AbiLTTtT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 14:49:19 -0500
Received: from mail-vk1-xa29.google.com (mail-vk1-xa29.google.com [IPv6:2607:f8b0:4864:20::a29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E67C4D10B
        for <stable@vger.kernel.org>; Tue, 20 Dec 2022 11:49:16 -0800 (PST)
Received: by mail-vk1-xa29.google.com with SMTP id r204so6253125vkf.8
        for <stable@vger.kernel.org>; Tue, 20 Dec 2022 11:49:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RAByKZvDDrKrFssXFC2YQGR5yFY8utJq9oPxGm+d0h8=;
        b=CIdjQ1guO3BIF5PgGiJMt+aYp0uAR3A95Zy17DSW44MkkEYyzANme2V6BMEPQepNsT
         DGAEg86POl5epwrGMf6cGx+v1gIamDjQQnXDXm75voQ2iZid6+0gnin4uzA7KVzY493Y
         RceqeftXE2NnIbiDXsUY9MD++ocFX6Bvgbsf5Nw1IKvnIe+o1v1zeOcH/4HKjK06mF3F
         W9q/sjY5dkV2jz3SNfzqAUlXSyJFd+U4j3A3v2oNB/FDkr/HEcTNVFZtRIfFbin7r3Ps
         HB/AuwDCaws7QTWFBZ4LTPWsFAlSJbT1izwV37FMdDhSpMefTxrBNOGo6EQzzzr4qfr8
         oCmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RAByKZvDDrKrFssXFC2YQGR5yFY8utJq9oPxGm+d0h8=;
        b=k8UStDvcXZcmCuFsk6z0UmbsMj3yNeduMDkfOEPHjlogN//SzzjLg+fW1WLFe+dAV4
         uSWjt8b2JiCW7wBiTK+N41D/8rBo5h2wVJKQ3iOHnp7K605bChWs9KGFarl9/WdL3rDL
         hGThgdzE/boc1CrcNFIrFOlopewVngAnEozYqu6nhiCHpJXKMRGgLR9Wic2r/acXlnCF
         6hII8py5WGRrxnxAf/s0ycLbo/MwgQtYK/dybENBpaUSdKvgev7HHpD9ahalvEB6avhY
         TYuV9nxKn7PyU8OWlV01qgwxGvJsCMKOxgoie1xwhyDv73VIynYiq0U5vErZMFDDxoYQ
         dtXw==
X-Gm-Message-State: ANoB5pkW+HGp+fi5SN+8kQxIN4x3Z9ByzYUyF5VUKJPGySqzudMF8RHJ
        UA6AEMQJ+BJB/Ikd2fnfllUWpEasj0mBrBuyD/DV/Q==
X-Google-Smtp-Source: AA0mqf5pGcQirAJi9FEmLiKNkqwZjsDkyvfNeUZKhYNCWWr9WYL4NRhwpyq1yLhmvnhoaP7+0df4yLyRSk6UhFn9PZ8=
X-Received: by 2002:a1f:9b03:0:b0:3c1:780:3bfe with SMTP id
 d3-20020a1f9b03000000b003c107803bfemr4130089vke.26.1671565755794; Tue, 20 Dec
 2022 11:49:15 -0800 (PST)
MIME-Version: 1.0
References: <20221219191855.2010466-1-allenwebb@google.com>
 <20221219204619.2205248-1-allenwebb@google.com> <20221219204619.2205248-3-allenwebb@google.com>
 <Y6FaUynXTrYD6OYT@kroah.com> <CAJzde04Hbd2+s-Bqog2V81dBEeZD7WWaFCf2BkesQS4yUAKiNA@mail.gmail.com>
 <Y6H6/U0w96Z4kpDn@bombadil.infradead.org> <CAJzde04igO0LJ46Hsbcm-hJBFtPdqJC6svaoMkb3WBG0e1fGBw@mail.gmail.com>
 <Y6IDOwxOxZpsdtiu@bombadil.infradead.org>
In-Reply-To: <Y6IDOwxOxZpsdtiu@bombadil.infradead.org>
From:   Allen Webb <allenwebb@google.com>
Date:   Tue, 20 Dec 2022 13:49:04 -0600
Message-ID: <CAJzde06q3w7CHd8FSs-bwS3EeVv6xrBzCwerQVqps49V=_voQQ@mail.gmail.com>
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

On Tue, Dec 20, 2022 at 12:47 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> On Tue, Dec 20, 2022 at 12:19:49PM -0600, Allen Webb wrote:
> > On Tue, Dec 20, 2022 at 12:12 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> > >
> > > On Tue, Dec 20, 2022 at 08:58:36AM -0600, Allen Webb wrote:
> > > > As mentioned in a different sub-thread this cannot be built as a
> > > > module so I updated the commit message to:
> > > >
> > > > imx: Fix typo
> > > >
> > > > A one character difference in the name supplied to MODULE_DEVICE_TABLE
> > > > breaks compilation for SOC_IMX8M after built-in modules can generate
> > > > match-id based module aliases, so fix the typo.
> > >
> > > Are you saying that it is a typo *now* only, and fixing it does not fix
> > > compilation now, but that fixing the typo will fix a future compilation
> > > issue once your patches get merged for built-in module aliases?
> >
> > It was always a typo, it just doesn't affect the build because
> > MODULE_DEVICE_TABLE is not doing anything for built-in modules before
> > this patch series.
> >
> > >
> > > > This was not caught earlier because SOC_IMX8M can not be built as a
> > > > module and MODULE_DEVICE_TABLE is a no-op for built-in modules.
> > >
> > > Odd, so why did it use MODULE_DEVICE_TABLE then? What was the reason for
> > > the driver having MODULE_DEVICE_TABLE if it was a no-op?
> >
> > That is a good question. I can only speculate as to the answer
>
> You can use git blame to trace back to the original commit that added
> it, then  use git blame foo.c commit-id~1  on the file to keep going
> back until you get to the first commit that added that entry, check out
> that as a branch and see if the driver was still not a module then
> (tristate). If so then your speculation is very likely accurate and
> can be spelled out in the commit log message.

All three cases are bool configs.

>
> It begs the inverse question too though, you are finding uses of
> built-in-always code (never tristate) which uses MODULE_DEVICE_TABLE().
> Although today that's a no-op, after your changes this becomes useful
> information, so do you need to scrape to see what built-in-aways code
> *do* not use MODULE_DEVICE_TABLE() where after your patches it would
> have become useful?
>
> Determing if there is value to that endeavour should be easily grasped by
> reading the description you are adding to MODULE_DEVICE_TABLE() --
> in your patch 5 "module.h: MODULE_DEVICE_TABLE for built-in modules".
> Driver developers for built-in-always code should read that description
> and be able to decide if they should use it or not. But even your latest
> replies to Greg do not make that clear, *I personally gather* rather that
> this would in no way shape or form be useful. But is that true?

I took another stab at clarifying (and also dropped the ifdev since
the same macro works both for separate and built-in modules:

/*
 * Creates an alias so file2alias.c can find device table.
 *
 * Use this in cases where a device table is used to match devices because it
 * surfaces match-id based module aliases to userspace for:
 *   - Automatic module loading.
 *   - Tools like USBGuard which allow or block devices based on policy such as
 *     which modules match a device.
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

>
> So why not just remove MODULE_DEVICE_TABLE() from code we know is
> built-in-always code instead of fixing a typo just to fix a future
> compile issue?
>
> Then your commit log is not about "fix typo", but rather remove a no-op
> macro as the driver is always built-in and keeping that macro would not
> help built-in code.

The deciding factor in whether it makes sense to remove these vs fix
them seems to be, "How complete do we want modules.builtin.alias to
be?"

Arguably we should just drop these in cases where there isn't an
"authorized" sysfs attribute but following that logic there is not any
reason to generate built-in aliases for anything except USB and
thunderbolt.

On the flip side, if we are going to the effort to make this a generic
solution that covers everything, the built-in aliases are only as
useful as they are complete, so we would want everything that defines
a device table to call the macro correctly.

>
> > but it
> > is plausible people copied a common pattern and since no breakage was
> > noticed left it as is.
>
> This level of clarity is important to spell out in the commit log
> message, specially if you are suggesting it is just a typo fix. Because
> I will take it for granted that it is just that.
>
> If it fixes a future use case where the typo would be more of an issue,
> you can mention that in a secondary paragraph or sentence.
>
> > It also raises the question how many modules have device tables, but
> > do not call MODULE_DEVICE_TABLE since they are only ever built-in.
> > Maybe there should be some build time enforcement mechanism to make
> > sure that these are consistent.
>
> Definitely, Nick Alcock is doing some related work where the semantics
> of built-in modules needs to be clearer, he for instance is now removing
> a few MODULE_() macros for things which *are never* modules, and this is
> because after commit 8b41fc4454e ("kbuild: create modules.builtin
> without Makefile.modbuiltin or tristate.conf") we rely on the module
> license tag to generate the modules.builtin file. Without that commit
> we end up traversing the source tree twice. Nick's work builds on
> that work and futher clarifies these semantics by adding tooling which
> complains when something which is *never* capable of being a module
> uses module macros. The macro you are extending, MODULE_DEVICE_TABLE(),
> today is a no-op for built-in, but you are adding support to extend it
> for built-in stuff. Nick's work will help with clarifying symbol locality
> and so he may be interested in your association for the data in
> MODULE_DEVICE_TABLE and how you associate to a respective would-be
> module. His work is useful for making tracing more accurate with respect
> to symbol associations, so the data in MODULE_DEVICE_TABLE() may be
> useful as well to him.

Thanks, I will look through what I can find.

>
> You folks may want to Cc each other on your patches.
>
> If we know for certain things *will never* be used or *should not be
> used*, as in the case of the module license tag, we should certainly
> have tooling to pick up on that crap to help us tidy it up.
>
> If you determine MODULE_DEVICE_TABLE() *should* not be used for built-in
> always code (never tristate) then you and Nick likely have overlap of
> macros to tidy up and tooling to share to spot these sort of issues.

It definitely is needed for never-tristate modules that match devices
in subsystems that surface the authorized attribute.

>
>   Luis
