Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52A982330A
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 13:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731214AbfETLvl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 07:51:41 -0400
Received: from mail-ua1-f66.google.com ([209.85.222.66]:43036 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731954AbfETLvl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 07:51:41 -0400
Received: by mail-ua1-f66.google.com with SMTP id u4so5120666uau.10
        for <stable@vger.kernel.org>; Mon, 20 May 2019 04:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2QA4ID8DT7P795dvV4IbuNJhbEACzngsrOuQUiIzl48=;
        b=XQI1oWu2zpUYgsaQ/BKmDtFAtkL7QlwZSlhGP0jHfv4JXP9XPkOrG6AO1v7CRmmRS+
         cMoek7w39gEHsJ56mGHwS0GxqwmdiEul7wra6aJBXbGmWbdD/TEAZI+TCV7ql0FrAzvM
         qidzhvXutng3G1p3Jq5FkEc4ee6Y/GECMo9IbPSvAmVtWCiQhByyWxrjpN2qkaf54VoL
         M6mlmjMMse4h9Ej4m9sZrr0xBHGBlyilwGysTVFF/xAO2cO5jT3OlVRv9hQuqL8YkzXN
         WXiTUjzv3huNh2yChkH+AGdf9kjQWIG2fWWlLZ0QpYg2fQjS4GanOt79HNGumghs8AQT
         dJGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2QA4ID8DT7P795dvV4IbuNJhbEACzngsrOuQUiIzl48=;
        b=O8xSyWLkvgPVio+BMDvsAkWcOC9q7TeqVHBOII4rmxilpvqlsAsQdb5uToMdi7aZ+q
         ptFvwWoUTnnfeRj66nGr/tGFzViJaDdbFTerm8V0e+i5k2zpBc4DBq/GlocDQU+rXLbE
         JA86LrSgEEaRKFbyVdgzVkVtXj00wqYIPk8E4Sl5y25qKlaQG6GsvD91x0rhuETHrjDx
         vxdn+z2z/JofLjwQIO3CmRAdNNeICXhqx2VNXsEUovkiekZ8yEYhj+xImpOjaWzsN6UM
         Z1+mIvDa4AhaSpTuFjbVrsUwTjKJmCYAKLj0ryffcL2ctkwKKhR0ty4gA1hkDkj+wk8J
         ogmQ==
X-Gm-Message-State: APjAAAUdjlYDEnNkordpBwoMFRVmIm39tQDWAZ/HfwQy2ZW+t675wCjM
        tGicP3ZR6WBhxMB5GPfU0K6/l8iycGB6G+vEFtGc+w==
X-Google-Smtp-Source: APXvYqzKP1TTYuT4qKUW6lm4ts3QEzmB7qd+laniptOPwVAj7agDu/YucD9OFu9MftZ0Ks59Ey4dpklY/KrtAdCSPLM=
X-Received: by 2002:ab0:5930:: with SMTP id n45mr22358315uad.87.1558353100373;
 Mon, 20 May 2019 04:51:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190418133913.9122-1-gilad@benyossef.com> <CAOtvUMd9WUZAFgTqVH0U2ZZp8bbHXNg9Ae_ZFvGKJTSKNct8JA@mail.gmail.com>
 <20190517145235.GB10613@kroah.com> <CAOtvUMc++UtTP3fvXofuJA4JpdT86s5gbSx6WRtDK=sWnuUZrg@mail.gmail.com>
 <CAOtvUMcfXHv0UxytEEdGJG5LM-SfyyVHbnbE0RNALMfBD1zuEQ@mail.gmail.com> <20190520093008.GA4476@kroah.com>
In-Reply-To: <20190520093008.GA4476@kroah.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Mon, 20 May 2019 14:51:27 +0300
Message-ID: <CAOtvUMeiO9-U=ESWHws+kwNHMR-zS9xdeF8-HOdYYX-hk0qzZQ@mail.gmail.com>
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

Hi,

On Mon, May 20, 2019 at 12:30 PM Greg KH <gregkh@linuxfoundation.org> wrote=
:
>
> On Sun, May 19, 2019 at 11:28:05AM +0300, Gilad Ben-Yossef wrote:
> > On Sat, May 18, 2019 at 10:36 AM Gilad Ben-Yossef <gilad@benyossef.com>=
 wrote:
> > >
> > > Hi
> > >
> > > On Fri, May 17, 2019 at 5:52 PM Greg KH <gregkh@linuxfoundation.org> =
wrote:
> > > >
> > > > On Sun, Apr 21, 2019 at 11:52:55AM +0300, Gilad Ben-Yossef wrote:
> > > > > On Thu, Apr 18, 2019 at 4:39 PM Gilad Ben-Yossef <gilad@benyossef=
.com> wrote:
> > > > > >
> > > > > > A set of new features, mostly support for CryptoCell 713
> > > > > > features including protected keys, security disable mode and
> > > > > > new HW revision indetification interface alongside many bug fix=
es.
> > > > >
> > > > > FYI,
> > > > >
> > > > > A port of those patches from this patch series which have been ma=
rked
> > > > > for stable is available at
> > > > > https://github.com/gby/linux/tree/4.19-ccree
> > > >
> > > > Hm, all I seem to need are 2 patches that failed to apply.  Can you=
 just
> > > > provide backports for them?
> > >
> > > Sure, I'll send them early next week.
> >
> > hm...  I've just fetched the latest from
> > git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git,
> > rebased that branch against the linux-4.19.y branch and it all went
> > smooth.
> >
> > What am I'm missing? is there some other tree I should be doing this on=
?
>
> I do not know, can you just send the 2 patches that I said failed for
> me?  Those are the only ones that I need here.
>
> I can't use random github trees, sorry, let's stick to email for patches
> please.
>

Sure, no problem. I thought you tried the github tree and it failed.

I sent the patches now.

Gilad


--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
