Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 628673D0F1D
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 15:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236464AbhGUMNl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 08:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233929AbhGUMNj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Jul 2021 08:13:39 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B5DC061574;
        Wed, 21 Jul 2021 05:54:15 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id t2so2212349edd.13;
        Wed, 21 Jul 2021 05:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7mDnP5x0nWVhFb4OE2Gkyco+TG5CZ1FU8ptPHTvIEwk=;
        b=tAeOG8CsUIvKjR1t/Fwst2LTgFXjNm7mbcsWnbYnIDQSnOjhAgFwY2kYxpcpbCxIrJ
         AlWF8zUxCpasb0HO5bxrJ0DFaTQWOmqqtYaY/Du9RAGnQa34AnfPOzUz0bAyZisBpkVS
         HxFxat/ZQzw8WUPKE7jsTNTFED0mfiNE5TKv+eNOsKSm1HPPQoEBldtSc03sUZYvPn/z
         961H6rnFAN1GqMKAGNK1asGfPPWOadmyjApDeXIsnUgcjW0HrkAnJ/IE6Kiti52poN/Y
         z7KU7DdfiGLaluTXl78xa4KQF5YbvmHtDDhVLnpFdV7cBpaPzxdBJEYNSn4VfgzlKaVf
         X6+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7mDnP5x0nWVhFb4OE2Gkyco+TG5CZ1FU8ptPHTvIEwk=;
        b=dU5WFQb5p2nx6mzB+9G20xoIeB5W3foFD3xri40HkSXnFctq6hWIEKxyKeToaDKusU
         3hdHSA2cDtDzfy8w/do8eAd/wY7zHvhRMxfbc6CFBdHkGiOIY8rJ7l758wxiui6hS0qD
         kTniiFWBNJNYhxBSRevpddsuCcoyuQz3NzXS1wFuKLHiaHurY/DO/GX3NLVGukBwO710
         ajrccXyPzsCQNIVj9qbWsYlVJJoyH9//biT7fIpoBmnMMMruDztqxR3yHeL2EAueb4vB
         tnxjPk7lpsMVjiZwEsyXL5m57Pmq1l2pH80wUjaE0lXQwmkNKGSbKV5sNL+SysJpK9sj
         SJzw==
X-Gm-Message-State: AOAM532gYgS1qgIRxyPN2uzUYIJJCrz50lTtbwBBDjCdtYbcDC3vtzrW
        q14tao9zasiiRtcE0jckZGylyqNNsdadWPhShGM=
X-Google-Smtp-Source: ABdhPJwESdBki1VtdQfi/G7eqpy6LzTUcGT9bF3lxKdx0NGVzmCzy+YU9sWNicwOfHdtZG2UktX4bEFYkwVKYS88Udo=
X-Received: by 2002:aa7:d397:: with SMTP id x23mr28643453edq.174.1626872053699;
 Wed, 21 Jul 2021 05:54:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210721113305.1524059-1-mudongliangabcd@gmail.com> <YPgMZBK/FWLRD1Ic@hovoldconsulting.com>
In-Reply-To: <YPgMZBK/FWLRD1Ic@hovoldconsulting.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Wed, 21 Jul 2021 20:53:47 +0800
Message-ID: <CAD-N9QVLshn_A=S+Nqemc9BRUdW432VrLJCAb=t35WaoL-C3=Q@mail.gmail.com>
Subject: Re: [PATCH v2] tty: nozomi: tty_unregister_device -> tty_port_unregister_device
To:     Johan Hovold <johan@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 21, 2021 at 8:01 PM Johan Hovold <johan@kernel.org> wrote:
>
> On Wed, Jul 21, 2021 at 07:33:04PM +0800, Dongliang Mu wrote:
> > The pairwise api invocation of tty_port_register_device should be
> > tty_port_unregister_device, other than tty_unregister_device.
>
> Are you sure about that? Please explain why you think this to be the
> case and why this change is needed.

I am sure about this.

1. From the implementation,
    tty_port_register_device -> tty_port_register_device_attr ->
tty_port_link_device; tty_register_device_attr
    tty_register_device -> tty_register_device_attr

    tty_port_unregister_device -> serdev_tty_port_unregister;
tty_unregister_device
    tty_unregister_device

    As to the functionability, tty_port_register_device pairs with
tty_port_unregister_device; meanwhile, the same to tty_register_device
and tty_unregister_device.

2. From the function naming style,

    tty_port_register_device - tty_port_unregister_device;
tty_register_device - tty_unregister_device

>
> > Fixes: a6afd9f3e819 ("tty: move a number of tty drivers from drivers/char/ to drivers/tty/")
>
> Please try a little harder, that's clearly not the commit that changed
> to the port registration helper.
>
> > Cc: stable@vger.kernel.org
>
> Why do you think this is stable material? (hint: it is not)

From the documentation, this label could make the patch automatically
go to stable tree. And stable tree is also using the incorrect api.

If I have any misunderstanding, please let me know.

>
> > Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> > ---
> >  drivers/tty/nozomi.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/tty/nozomi.c b/drivers/tty/nozomi.c
> > index 0c80f25c8c3d..08bdd82f60b5 100644
> > --- a/drivers/tty/nozomi.c
> > +++ b/drivers/tty/nozomi.c
> > @@ -1417,7 +1417,8 @@ static int nozomi_card_init(struct pci_dev *pdev,
> >
> >  err_free_tty:
> >       for (i--; i >= 0; i--) {
> > -             tty_unregister_device(ntty_driver, dc->index_start + i);
> > +             tty_port_unregister_device(&dc->port[i].port, ntty_driver,
> > +                             dc->index_start + i);
> >               tty_port_destroy(&dc->port[i].port);
> >       }
> >       free_irq(pdev->irq, dc);
>
> Johan
