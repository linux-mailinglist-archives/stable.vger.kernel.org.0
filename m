Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70E662604CD
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 20:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbgIGSnS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 14:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728343AbgIGSnS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Sep 2020 14:43:18 -0400
Received: from mail-vk1-xa43.google.com (mail-vk1-xa43.google.com [IPv6:2607:f8b0:4864:20::a43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A20ABC061573
        for <stable@vger.kernel.org>; Mon,  7 Sep 2020 11:43:17 -0700 (PDT)
Received: by mail-vk1-xa43.google.com with SMTP id d2so1004627vkd.13
        for <stable@vger.kernel.org>; Mon, 07 Sep 2020 11:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Z/QiT8wvjsDBITdA5cxTL7/NMWaaQtV0JaXo6EfJo0M=;
        b=fv6rSZmZXOyuBp+WiBVzVrtpBja7mm553SPpz6V3NCAnR12OBtHrQJPd9JtgSgdHLW
         JURNU25V4/UlnME2iNxKR8EmW8pfFTks7O2C0IA//49RGI23C5BRPHNTyUVPIbCHhJvc
         OJYenIvA646CKylDL7biWCopBb1cSc4WUyVx/MTtBfdB+Zz2EJ0MzoZlxSVAiupvqbhg
         NNCJ+CIKcZk5FOhIWEc3wHCi6QSrHw+zvrFKFsVy1yvtQjUrdQY0EG4o5+6r98GCqb4R
         G35viC7RC0nJrO+R3mUP7wB2LENk5M/3yTzqMUUHvm9XOqwUh0K2Hf13esqbhVsI370K
         H1dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Z/QiT8wvjsDBITdA5cxTL7/NMWaaQtV0JaXo6EfJo0M=;
        b=lUJA0Fqey86R8LKZjuGFvlVLIm9h9EWaR1FROK43NMgXKcicS9QxuFgNRqkGXUw5+8
         qB5mkt4Ic1stAHs8edZbZ8Zxvlxid9jUkQEO/vLj/vBuYqqWt9t/lkXla9zDPPJCzEbv
         07pMnzzogjGYtmW3Zpaac9jawGY3Fxc+PukmikKhioZMIfklrYfYP5EnoKxhcSBI/pK0
         iH3Hr949Xne1ZLZVsq2BuUTFgp/BH1wTJYhlusqCKb7aN9C7v3MGIPxfDOvgyOOZ40we
         iPqHDxlMDi0X/Ulu3/B15+9cZi3gISrmmIubvkojLKerJvfcyRrCgbPe9U31Z0SRWIxw
         LIFA==
X-Gm-Message-State: AOAM53117Dpci4F2Gk7qRSY+KqPl6uDQeMfzHt8QY+aLeIGa/RtvSX67
        fIwnhp2ak22Q/kTaPwbx3TwWgQNai5NglJ/qmU8=
X-Google-Smtp-Source: ABdhPJzwpAKkVYhJJlw8KDPLLiadWFRNtNiDtvP8FpyHn7hntfSOFwEQG5t7jBrkEGnCZW8DCTcR/8H5Hb0aFeQ6/V0=
X-Received: by 2002:a1f:988f:: with SMTP id a137mr12424487vke.8.1599504194864;
 Mon, 07 Sep 2020 11:43:14 -0700 (PDT)
MIME-Version: 1.0
References: <CADBnMvh6gODocz8=fNE0wVcv71SdHKNtee7hAZev6OdZ7EZcAw@mail.gmail.com>
 <788f9aa0-f03d-c736-a8a1-9a989f2e9c6e@microchip.com> <20200907173154.GA1016021@kroah.com>
 <20200907182957.GO8670@sasha-vm>
In-Reply-To: <20200907182957.GO8670@sasha-vm>
From:   Kristof Havasi <havasiefr@gmail.com>
Date:   Mon, 7 Sep 2020 20:43:37 +0200
Message-ID: <CADBnMvg3q_1oVg1uZ-h1dwy-J6fikLQJkwE6-xYms4EvW=mpOw@mail.gmail.com>
Subject: Re: duplicated patch in 5.4
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Codrin.Ciubotariu@microchip.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 7 Sep 2020 at 20:29, Sasha Levin <sashal@kernel.org> wrote:
>
> On Mon, Sep 07, 2020 at 07:31:54PM +0200, Greg KH wrote:
> >On Mon, Sep 07, 2020 at 05:15:49PM +0000, Codrin.Ciubotariu@microchip.co=
m wrote:
> >> On 07.09.2020 17:24, Kristof Havasi wrote:
> >> > Dear Ciubatariu,
> >> >
> >> > as I am not familiar with the linux development workflow, I am
> >> > contacting you directly as the author of the upstream patch:
> >> > af199a1a9cb02ec0194804bd46c174b6db262075
> >> >
> >> > I noticed that your addition there was applied twice into 5.4 [1]
> >> >
> >> > d9b8206e5323ae3c9b5b4177478a1224108642f7    v5.4.51-45-gd9b8206e5323
> >> > d55dad8b1d893fae0c4e778abf2ace048bcbad86     v5.4.52-13-gd55dad8b1d8=
9
> >> >
> >> > resulting in a non-harmful, but unnecessary double setting of the va=
riable.
> >> >
> >> > /* set the real number of ports */
> >> > dev->ds->num_ports =3D dev->port_cnt;
> >> >
> >> > /* set the real number of ports */
> >> > dev->ds->num_ports =3D dev->port_cnt;
> >> >
> >> > return 0;
> >> >
> >> > Could you notify the stable maintainers to apply your patch correctl=
y?
> >> >
> >> > Best regards,
> >> > Krist=C3=B3f Havasi
> >> >
> >> >
> >> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git=
/tree/drivers/net/dsa/microchip/ksz8795.c?h=3Dv5.4.63#n1274
> >> >
> >>
> >> Hello,
> >>
> >> Krist=C3=B3f discovered that one patch of mine was applied twice. What=
 is the
> >> best way to address this?
> >
> >Send us a revert would be best.
>
> I'll queue up a revert, nothing else is required on your end, thanks for
> reporting!
>
> --
> Thanks,
> Sasha

Honestly, I am impressed how responsive this community is!
Thank you for your responses!
