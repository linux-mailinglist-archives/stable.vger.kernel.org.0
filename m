Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4A7D3D0F9D
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 15:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235419AbhGUM5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 08:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238159AbhGUMzi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Jul 2021 08:55:38 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D862FC061762;
        Wed, 21 Jul 2021 06:35:58 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id oz7so3309012ejc.2;
        Wed, 21 Jul 2021 06:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iv3GrYGJUQgZ0uDNyTImICR6X15wuHMecLC2T1/RMXo=;
        b=hTH2xDXFTP8YJSxGbXerdWTQWBygjFRpRwTlnBK48BtxbHmHiD86/vC3vzlDTYCYv2
         4ylYGWVajaCRpMFqa0yC8bHEJDxD78w3Z9xAcrpWFAqPmBUWqVj4r/kz15KNHQetfrcv
         7GXuGvpQR73Okplia/PqeLidI7Bc9eDhA6TnrSV4N5QDmY+4r8hLOyUdI99hB/lwRAnw
         1KjdKpYl6z5CkhcDA47andrc+Wu1athTpClVRB5baJn4T9bUf9XBqQcxTG7WHhDHFjgK
         Zii2YwvXt1VtHRA1KiRGzcCpzcvDfH74idQ3D6+mqAGquzvTY9lbzZaVrPOBov4iYyuz
         P+6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iv3GrYGJUQgZ0uDNyTImICR6X15wuHMecLC2T1/RMXo=;
        b=X/W3gKmhdpk0QEO+SqBf6jrPZUjCt5zN93cbXN4RiFrgRU7UQfmo8mdywowibBwRcJ
         cttKNvSS9apKmWl8CPrZqweuXZLZe80mBo7nrXOoNS9ErAk+DVAJ4Yjsvcg1iyqb/ZS6
         uYNCmT4vpzC7eMnAtI5/9+x437TiN7UdGnfbCmXht/L1dP6Pbjy+YVH8ZrdH/jcJexvl
         ie9A3eamJICgAV6hCkIdwkwSwCYvPXvUM/FD+HVyVioT78jvTMaZ9NifhL2jgyDDS+XX
         lKE6o4WjyQJceBHjKE33+18Nh+PbmD6bBxS9cZDYdyFAZOGcQOGte18xN6ysYSklnmJc
         U0oQ==
X-Gm-Message-State: AOAM531tLMeXJQvXNUTbYr7UvdlghRbNe6QCZCwWjJZ+ainPvUQwJ92C
        Wbs8Jebi6j3hLF3uCFCxPOAomJFpJC6usisbPLw=
X-Google-Smtp-Source: ABdhPJxPxFk89NLNHuFUCmT2mj0lRhzLQo0wbpb1Hy57bNkodaPR+nEzdQnqwqvd1BvQ6RVunyonVwdW+kv8vGpVGcE=
X-Received: by 2002:a17:906:eda7:: with SMTP id sa7mr38847584ejb.135.1626874557379;
 Wed, 21 Jul 2021 06:35:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210721113305.1524059-1-mudongliangabcd@gmail.com>
 <YPgMZBK/FWLRD1Ic@hovoldconsulting.com> <CAD-N9QVLshn_A=S+Nqemc9BRUdW432VrLJCAb=t35WaoL-C3=Q@mail.gmail.com>
 <YPgcgahQ458ndT1j@hovoldconsulting.com>
In-Reply-To: <YPgcgahQ458ndT1j@hovoldconsulting.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Wed, 21 Jul 2021 21:35:31 +0800
Message-ID: <CAD-N9QXD85YthmKp_AGjVzXL4=NstCvicEdVO_zu=TSj0kMSZw@mail.gmail.com>
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

On Wed, Jul 21, 2021 at 9:09 PM Johan Hovold <johan@kernel.org> wrote:
>
> On Wed, Jul 21, 2021 at 08:53:47PM +0800, Dongliang Mu wrote:
> > On Wed, Jul 21, 2021 at 8:01 PM Johan Hovold <johan@kernel.org> wrote:
> > >
> > > On Wed, Jul 21, 2021 at 07:33:04PM +0800, Dongliang Mu wrote:
> > > > The pairwise api invocation of tty_port_register_device should be
> > > > tty_port_unregister_device, other than tty_unregister_device.
> > >
> > > Are you sure about that? Please explain why you think this to be the
> > > case and why this change is needed.
> >
> > I am sure about this.
>
> I'm afraid you are mistaken. There is a bit of inconsistency in the API,
> but it is *not* a requirement to use the port helper for deregistration
> here.
>
> > 1. From the implementation,
> >     tty_port_register_device -> tty_port_register_device_attr ->
> > tty_port_link_device; tty_register_device_attr
> >     tty_register_device -> tty_register_device_attr
> >
> >     tty_port_unregister_device -> serdev_tty_port_unregister;
> > tty_unregister_device
> >     tty_unregister_device
>
> >     As to the functionability, tty_port_register_device pairs with
> > tty_port_unregister_device; meanwhile, the same to tty_register_device
> > and tty_unregister_device.
>
> Again, this is not an explanation. Why do think it is needed? What could
> possibly go wrong if you don't change the code like you propose?
>
> > 2. From the function naming style,
> >
> >     tty_port_register_device - tty_port_unregister_device;
> > tty_register_device - tty_unregister_device
>
> Yes, the naming suggests you should be using the port helper and it is
> ok to do so, but again, it is not a requirement (unless you're using the
> serdev variant).

OK, I see. Thanks for your information.

Next time I will double-check the underlying details of each function
to verify if they are in pairs.

>
> > > > Fixes: a6afd9f3e819 ("tty: move a number of tty drivers from drivers/char/ to drivers/tty/")
> > >
> > > Please try a little harder, that's clearly not the commit that changed
> > > to the port registration helper.
> > >
> > > > Cc: stable@vger.kernel.org
> > >
> > > Why do you think this is stable material? (hint: it is not)
> >
> > From the documentation, this label could make the patch automatically
> > go to stable tree. And stable tree is also using the incorrect api.
>
> No, it is not using an "incorrect api". There is nothing wrong with
> current code. And it certainly does not need to be changed in stable.
>
> Johan
