Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38FE220E1F4
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732279AbgF2VBO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731194AbgF2TM5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jun 2020 15:12:57 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A3BC08EC10;
        Sun, 28 Jun 2020 23:49:30 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id i14so15404630ejr.9;
        Sun, 28 Jun 2020 23:49:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TKwtdoMLrftBw60aqwE/HJ7d+xVc1MlrSqukfHqaiKs=;
        b=UWgpYyJEbr4N8zXRK13WZy/tUvJMtbfOUekjNMHFmwfJ/soRso//841nXY0LQR6DYA
         xXL+6rVvCRE//21iNgN2bPGhKpH+BSZ8kDqfxPE9hIbxIv7agzh0esjiazmBeDh4wQHE
         zBN6pjs8Kgru3mWxD9RhlG/otTjlIN3SdGFgk0vEhhxCwMA3+T6k5LLwfjwxm4lfCVfn
         +7XId92ZB/Pasxk1U3lyEet6gZS3UQxBmWqaaxyCoj+a9qdg5A2jxSpDd8TecieQWif3
         PRhFI5rPQ/BMNgtv6bEEQ/Fkqe/yxY+GWf+4p4B8HeDRdZdE8YwsIpq21V4ezVVXpyG5
         bKQg==
X-Gm-Message-State: AOAM531QXUskNPjvHRc0mKFJE/ojsBu5he/hA3Hyh8/ag0Jkd4SagqjY
        eLrdb4TSI7ZmeIbId2haebc=
X-Google-Smtp-Source: ABdhPJzXl7soEl0o86brPX6M1qQlUE37P3YFwoNS0PcuQCOlQOznanTfQcYMHYD9r9X7IdwabM3H7w==
X-Received: by 2002:a17:906:e299:: with SMTP id gg25mr12372085ejb.160.1593413369113;
        Sun, 28 Jun 2020 23:49:29 -0700 (PDT)
Received: from kozik-lap ([194.230.155.195])
        by smtp.googlemail.com with ESMTPSA id o14sm13662343eja.121.2020.06.28.23.49.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 28 Jun 2020 23:49:28 -0700 (PDT)
Date:   Mon, 29 Jun 2020 08:49:25 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Jonathan Cameron <jic23@kernel.org>
Cc:     Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Rob Herring <robh+dt@kernel.org>, linux-iio@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: iio: bmc150_magn: Document missing
 compatibles
Message-ID: <20200629064925.GA5879@kozik-lap>
References: <20200617101259.12525-1-krzk@kernel.org>
 <20200620164049.5aa91365@archlinux>
 <20200622051940.GA4021@kozik-lap>
 <20200627155714.15478f60@archlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200627155714.15478f60@archlinux>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 27, 2020 at 03:57:14PM +0100, Jonathan Cameron wrote:
> On Mon, 22 Jun 2020 07:19:40 +0200
> Krzysztof Kozlowski <krzk@kernel.org> wrote:
> 
> > On Sat, Jun 20, 2020 at 04:40:49PM +0100, Jonathan Cameron wrote:
> > > On Wed, 17 Jun 2020 12:12:59 +0200
> > > Krzysztof Kozlowski <krzk@kernel.org> wrote:
> > >   
> > > > The driver supports also BMC156B and BMM150B so document the compatibles
> > > > for these devices.
> > > > 
> > > > Fixes: 9d75db36df14 ("iio: magn: Add support for BMM150 magnetometer")
> > > > Cc: <stable@vger.kernel.org>
> > > > Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> > > > 
> > > > ---
> > > > 
> > > > The fixes tag is not accurate but at least offer some backporting.  
> > > 
> > > I'm not sure we generally bother backporting a missing section of binding
> > > documentation. Particularly as this doc isn't in yaml yet so it's not
> > > as though any automated checking is likely to be occurring.
> > > 
> > > Rob, any views on backporting this sort of missing id addition?
> > > 
> > > One side comment here is that the devices that are magnetometers only
> > > should never have had the _magn prefix in their compatibles. We only
> > > do that for devices in incorporating several sensors in one package
> > > (like the bmc150) where we have multiple drivers for the different
> > > sensors incorporated. We are too late to fix that now though.  It
> > > may make sense to mark the _magn variants deprecated though and
> > > add the ones without the _magn postfix.  
> > 
> > I can add proper compatibles and mark these as deprecated but actually
> > the driver should not have additional compatibles in first place - all
> > devices are just compatible with bosch,bmc150.
> 
> Why not?  Whilst the devices may be compatible in theory, it's not unusual
> for subtle differences to emerge later.   As such we tend to at least
> support the most specific compatible possible for a part - though we
> can use fallback compatibles.

It does not strictly harm but have in mind that adding is always
possible (when you spot the difference between devices). But it is
entirely different with removal - it takes time to deprecate one and to
remove it.

There is just no benefit for adding new compatibles for really
compatible devices. The module device table just grows. It makes sense
however to document in bindings that given compatible serves family of
devices.

Somehow driver developers got impression that they need to make a commit
like "Add support for xyz123 device" adding only compatible, to bring
support for new device. But the support was already there so just
document that xyz001 is compatible with xyz123.

Best regards,
Krzysztof

