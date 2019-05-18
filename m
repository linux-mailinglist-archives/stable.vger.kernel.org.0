Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5BB22218
	for <lists+stable@lfdr.de>; Sat, 18 May 2019 09:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727544AbfERHgZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 May 2019 03:36:25 -0400
Received: from mail-ua1-f67.google.com ([209.85.222.67]:33863 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbfERHgZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 May 2019 03:36:25 -0400
Received: by mail-ua1-f67.google.com with SMTP id 7so3604972uah.1
        for <stable@vger.kernel.org>; Sat, 18 May 2019 00:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=A5RwhDAP7/J1pDvTAiUDBR+MHgpw4LlKX0b6CEjmItY=;
        b=vIa7qd4so/Vd21TmmtOdwuMHc3kXNhGCSCPFnGLt8oHHd6zkIXgQGmuQRaLELWbU3q
         Wg702o/CWej3i12w0EGiMyO6YyJEt2qbM4pyTV0Q5FOG5WlKLlbybEd0DMnrOVcWS8fp
         DuzJECGhlpP5RykRyvIx/LwIPn3buQd8dt1QTeUIZQ9KRHdMrztYgAePkFE1bhKTieCw
         wUgeCC/BOoSImurLRiQ8ST0/pmSL8zlgoZ+q9LqqPH0Cj7/KIXixUrLtz9XRl4e+69xr
         9OdRSxVxrJBxaW5PMZ0appMng0Hkv5m4evgETN+YLvibsg0mcQRAFmHhSH5zrK3Al1N2
         dmzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=A5RwhDAP7/J1pDvTAiUDBR+MHgpw4LlKX0b6CEjmItY=;
        b=nS2P3y6TkOoDVF/Oaa5n69QgsJRXJlMgGthYeUJRAuW3GCxra0swm3jgmSKDRPYJrW
         jQszeI9QCK1SxTDWaB+o0B8aQOohw/LQyYz/9jZEgyO4P0MKFPpe0V5K42WbvNK3rMl9
         us0ktqzhlXgLdvlLnfOoMdTThVjOof3itEHaTi723Chb+zsAq0yn49xOBGN8mN002PDz
         bKRQFx929lJ7kc4kd5HY+V1ytEYUWGZhyPwVGedVDLz18vBk+dxHgGCvhHlsDHMpl4Tn
         AwN5wAzQlKPvJgw10mBgFdbXE/f6tNwGkSeiGr5h5hQJvg2OtWQC8YV/1LOP0XM1Q8n4
         BM+w==
X-Gm-Message-State: APjAAAUDND1kielo30bNWdillsB7sfGdkeJ7Ip5V+ZZZEFsIukqVhfcU
        V4Lrf0hkjTkbetpfyuBKdi9nMqIx0r49UEvaWOR4jw==
X-Google-Smtp-Source: APXvYqyQ3Z9FjlYf6e3EPpIIi/tS6QFWFUTVOX/BEDU6KhGJZajaaWWHlUvyLoVOQlW3V24I5M8CcgwGTrjbgRPwPfg=
X-Received: by 2002:ab0:5930:: with SMTP id n45mr17287080uad.87.1558164983986;
 Sat, 18 May 2019 00:36:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190418133913.9122-1-gilad@benyossef.com> <CAOtvUMd9WUZAFgTqVH0U2ZZp8bbHXNg9Ae_ZFvGKJTSKNct8JA@mail.gmail.com>
 <20190517145235.GB10613@kroah.com>
In-Reply-To: <20190517145235.GB10613@kroah.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Sat, 18 May 2019 10:36:11 +0300
Message-ID: <CAOtvUMc++UtTP3fvXofuJA4JpdT86s5gbSx6WRtDK=sWnuUZrg@mail.gmail.com>
Subject: Re: [PATCH 00/35] crypto: ccree: features and bug fixes for 5.2
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org,
        Ofir Drang <ofir.drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

On Fri, May 17, 2019 at 5:52 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Sun, Apr 21, 2019 at 11:52:55AM +0300, Gilad Ben-Yossef wrote:
> > On Thu, Apr 18, 2019 at 4:39 PM Gilad Ben-Yossef <gilad@benyossef.com> =
wrote:
> > >
> > > A set of new features, mostly support for CryptoCell 713
> > > features including protected keys, security disable mode and
> > > new HW revision indetification interface alongside many bug fixes.
> >
> > FYI,
> >
> > A port of those patches from this patch series which have been marked
> > for stable is available at
> > https://github.com/gby/linux/tree/4.19-ccree
>
> Hm, all I seem to need are 2 patches that failed to apply.  Can you just
> provide backports for them?

Sure, I'll send them early next week.

Thanks,
Gilad

--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
