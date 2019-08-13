Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABD1A8ABBC
	for <lists+stable@lfdr.de>; Tue, 13 Aug 2019 02:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbfHMAEJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Aug 2019 20:04:09 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:33859 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbfHMAEJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Aug 2019 20:04:09 -0400
Received: by mail-ot1-f68.google.com with SMTP id n5so165932765otk.1
        for <stable@vger.kernel.org>; Mon, 12 Aug 2019 17:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hzo1eKAep9i0qhpDX70sNk2Pbj0GpjM4DfNd2KKwDRI=;
        b=j45DEIZLaaEgSfO1vni8mgZGeUXMdlD5ryIBWBskCuBYx967JbbQX15YUx5aqqBDD/
         uyhJ8ngOhyD8KvmZhhQPXftKLeBo4n9gaZICSkgymDrP/NleClGKrg1NWFhkCEiDBTXE
         beDhJvg0sreyQ5624oebkio+3GkaOQbJ4Xn0w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hzo1eKAep9i0qhpDX70sNk2Pbj0GpjM4DfNd2KKwDRI=;
        b=jrkMacUJtffcVyb27mZjXfMLvkkMjaqZlgeDPPoVreV5MoJK5VZzcKRo5rXznYNccM
         PYNlQ16ZcTcYY2zP4D+o+nl1yzV9NLHxHMEFFiKjbWfcuVcw5auOzGppOyFvX46R9dOX
         tYP5MZ+hKtNdws0Z8bBkPLjj5sSE1oA/eimxZSlazCbSFXfoNK1Bc8/o8dQb1osb8GSy
         6/XFY0EdxzNX6x6RXXb8QVn5c362/io8bIPOswJZuvsrl3iTfXEJvD7/mEcLW/ZSMw79
         zVyE0nry1ytIO+vFmBN5RGgdI+ydz9e3JdCWJOFdYmvxS4XEfzY3FibziCmWmD3Jwmpe
         ihMg==
X-Gm-Message-State: APjAAAU48mm7Q2jZuXkMrer/7pO+dum8s6iPBfq4Ybw6kmxtqJ4T5Amo
        4duciiYdaPS+HK5EQR+q5uEh6O7g4sg=
X-Google-Smtp-Source: APXvYqxZiB8q+VPj4LeThw8GNBEbRcmPvOzQblFe3d1172R264mMTgEzA5AhS3Q/siOfEVD/9jdCHQ==
X-Received: by 2002:aca:f08a:: with SMTP id o132mr1118111oih.101.1565654648402;
        Mon, 12 Aug 2019 17:04:08 -0700 (PDT)
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com. [209.85.210.46])
        by smtp.gmail.com with ESMTPSA id e205sm37390051oia.23.2019.08.12.17.04.07
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 17:04:07 -0700 (PDT)
Received: by mail-ot1-f46.google.com with SMTP id f17so30465880otq.4
        for <stable@vger.kernel.org>; Mon, 12 Aug 2019 17:04:07 -0700 (PDT)
X-Received: by 2002:a6b:e013:: with SMTP id z19mr10853986iog.141.1565654647521;
 Mon, 12 Aug 2019 17:04:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190805124935.819068648@linuxfoundation.org> <20190805124936.173376284@linuxfoundation.org>
 <20190805144723.GC24265@amd>
In-Reply-To: <20190805144723.GC24265@amd>
From:   Doug Anderson <dianders@chromium.org>
Date:   Mon, 12 Aug 2019 17:04:01 -0700
X-Gmail-Original-Message-ID: <CAD=FV=Vcdq+Z8NQdQrweT0LhzvBiWEd4GQ=QLDEQyGL2=b6r_Q@mail.gmail.com>
Message-ID: <CAD=FV=Vcdq+Z8NQdQrweT0LhzvBiWEd4GQ=QLDEQyGL2=b6r_Q@mail.gmail.com>
Subject: Re: [PATCH 4.19 04/74] ARM: dts: rockchip: Mark that the rk3288 timer
 might stop in suspend
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Mon, Aug 5, 2019 at 7:47 AM Pavel Machek <pavel@denx.de> wrote:
>
> On Mon 2019-08-05 15:02:17, Greg Kroah-Hartman wrote:
> > [ Upstream commit 8ef1ba39a9fa53d2205e633bc9b21840a275908e ]
> >
> > This is similar to commit e6186820a745 ("arm64: dts: rockchip: Arch
> > counter doesn't tick in system suspend").  Specifically on the rk3288
> > it can be seen that the timer stops ticking in suspend if we end up
> > running through the "osc_disable" path in rk3288_slp_mode_set().  In
> > that path the 24 MHz clock will turn off and the timer stops.
> >
> > To test this, I ran this on a Chrome OS filesystem:
> >   before=$(date); \
> >   suspend_stress_test -c1 --suspend_min=30 --suspend_max=31; \
> >   echo ${before}; date
> >
> > ...and I found that unless I plug in a device that requests USB wakeup
> > to be active that the two calls to "date" would show that fewer than
> > 30 seconds passed.
> >
> > NOTE: deep suspend (where the 24 MHz clock gets disabled) isn't
> > supported yet on upstream Linux so this was tested on a downstream
> > kernel.
>
> I guess this does no harm, but deep sleep is unlikely to be suppored
> in the stable kernels, so ... is it good idea there?

People do merge stable kernels into local trees which have extra
patches (which might enable deep sleep).  Chrome OS is an example of
this.  If the patch does no harm then merging it seems nice.

That being said: we already have this in the Chrome OS tree, so unless
someone else is also mering stable into their tree and trying to
support rk3288 with deep sleep, this patch is unlikely to matter.
...so if everyone doesn't want it then it won't bother me.

-Doug
