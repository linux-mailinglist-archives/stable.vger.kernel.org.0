Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C481811CF96
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 15:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729568AbfLLOSq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 09:18:46 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:42563 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729392AbfLLOSq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 09:18:46 -0500
Received: by mail-ed1-f68.google.com with SMTP id e10so1922251edv.9;
        Thu, 12 Dec 2019 06:18:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QORpcfpxTVun2omq37w//epuRfcr5mZBlHsi85Oa95M=;
        b=IUewxsqbsSeH2FIzex3kps6Y+7jFx2NA91RD1LaeCT+kEcf4zn4f9NcjW72luM8L0Y
         mp9M5lirJhmYGYd7gtV9U99ttRAUo8NRvZXhCY3/symEdUKudcAzcgqDHBjPyIslhrbd
         xpEoh5rrA3/UUGCoVJqyiCUG2admqbmwiSif4t/5fiyBLAPwWFVrl17B+bmBOPbKPaKW
         hlNsgoCf2PAsUck+HHQEBz3B3G5xrQ3cU1/dDzCyIsIOvcc1mWInleHuiXf1E5lWpMH7
         o9t6M+WLRiftGmY83CcfamPrA/Ks8+OYiPy0FD+xpvhsXqNDACzdg8ZZ6S5Kd2aRR2Yv
         nYFQ==
X-Gm-Message-State: APjAAAX58QbFTCQvN6oClgnbezvN1e5mr9HRhVBji0WuvZgF1+1jKaWX
        Mgra0aT3Mqjw00yNvqhwJbT3qPN90Uc=
X-Google-Smtp-Source: APXvYqwdGWOlKR4douX6oCIzSlnsAcb7BtN7h5bhf8rXp7y7dPR4MGUuWgC2J051AqKFNIdEnP2z1w==
X-Received: by 2002:a17:907:11cc:: with SMTP id va12mr9985791ejb.164.1576160324391;
        Thu, 12 Dec 2019 06:18:44 -0800 (PST)
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com. [209.85.128.53])
        by smtp.gmail.com with ESMTPSA id 11sm151005ejn.83.2019.12.12.06.18.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2019 06:18:44 -0800 (PST)
Received: by mail-wm1-f53.google.com with SMTP id t14so2694863wmi.5;
        Thu, 12 Dec 2019 06:18:43 -0800 (PST)
X-Received: by 2002:a1c:6a05:: with SMTP id f5mr6752029wmc.2.1576160323683;
 Thu, 12 Dec 2019 06:18:43 -0800 (PST)
MIME-Version: 1.0
References: <20191211150339.185439726@linuxfoundation.org> <20191211150351.658072828@linuxfoundation.org>
 <20191212133132.GA13171@amd> <20191212140241.GA1595136@kroah.com>
In-Reply-To: <20191212140241.GA1595136@kroah.com>
From:   Chen-Yu Tsai <wens@csie.org>
Date:   Thu, 12 Dec 2019 22:18:34 +0800
X-Gmail-Original-Message-ID: <CAGb2v67z5T4XVOc03LL9K0p1yP9UtiDhmLNj8kzxVnsDsr0rew@mail.gmail.com>
Message-ID: <CAGb2v67z5T4XVOc03LL9K0p1yP9UtiDhmLNj8kzxVnsDsr0rew@mail.gmail.com>
Subject: Re: [PATCH 4.19 185/243] ARM: dts: sun8i: a23/a33: Fix up RTC device node
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        Maxime Ripard <mripard@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 12, 2019 at 10:02 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Dec 12, 2019 at 02:31:32PM +0100, Pavel Machek wrote:
> > Hi!
> >
> > > The RTC module on the A23 was claimed to be the same as on the A31, when
> > > in fact it is not. The A31 does not have an RTC external clock output,
> > > and its internal RC oscillator's average clock rate is not in the same
> > > range. The A33's RTC is the same as the A23.
> > >
> > > This patch fixes the compatible string and clock properties to conform
> > > to the updated bindings. The register range is also fixed.
> >
> > No, this is not okay for v4.19. New compatible is not in
> > ./drivers/rtc/rtc-sun6i.c, so this will completely break rtc support.
>
> Good catch, I would have thought both of those would happen at the same
> time.

(Fixed Maxime's email)

Neither were marked for stable. I guess Sasha's auto selection bot is at
work here. Is there anything we can do to prevent them from being selected?
For sunxi, we pretty much don't expect things to be backported, unless
something critical was fixed.

Thanks

ChenYu

> Now dropped, thanks.
>
> greg k-h
