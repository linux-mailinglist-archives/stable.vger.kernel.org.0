Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF26202F70
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 07:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbgFVFTp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 01:19:45 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:41317 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbgFVFTp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 01:19:45 -0400
Received: by mail-ed1-f66.google.com with SMTP id e22so1911999edq.8;
        Sun, 21 Jun 2020 22:19:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nsl5TCh1Pt6aIu2cjGBD/bvjK/XbpvVnJjLznaTEPdk=;
        b=OXHcu5L2xGVBhPIu9UCYagTfSOqHd9MAS4mu1EZ/8Ii/piDG12ZwHfAm7O+dVFMPM3
         IzIAxoi083tAeZeiOzBrd1BUl2QL8fxfwrRl+uwiA46CS83XbOZ7fSnAzdvT8KQ8JLPn
         SNkPd5FliLmbwl5608Pd/gR0KVSgyRR2adoFKy+3nEeb4Da4VkO09RpEDektR5UHjqQl
         QLNOuRwBNgseoElnS4MLeblhsm8f3GfnpnpC/1zkqhjPLNcCIxQFWAmnnMqF5VnZEeio
         EZqtuJChmxzAyWPtYYPuz152oT0HHNDtaPco8MeH6EWT71N1tygicox1KJCDJUBqwx9o
         wzsg==
X-Gm-Message-State: AOAM5326/VA97rRJ7hNCVn6YAq7+rCdOOLZEoLC1P/FtvLmGspiqXLqf
        i9J/CKBs5raNpruzV4tg1Zk=
X-Google-Smtp-Source: ABdhPJwhkGWW5ydtKaTpIHXIfYJvNfxDRKI637/Bs03ZhoUzba/c1xO65niQPQ23tENwHXRdLfp5XA==
X-Received: by 2002:a05:6402:1c96:: with SMTP id cy22mr4328762edb.79.1592803182900;
        Sun, 21 Jun 2020 22:19:42 -0700 (PDT)
Received: from kozik-lap ([194.230.155.235])
        by smtp.googlemail.com with ESMTPSA id d6sm11936480edn.75.2020.06.21.22.19.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 21 Jun 2020 22:19:42 -0700 (PDT)
Date:   Mon, 22 Jun 2020 07:19:40 +0200
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
Message-ID: <20200622051940.GA4021@kozik-lap>
References: <20200617101259.12525-1-krzk@kernel.org>
 <20200620164049.5aa91365@archlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200620164049.5aa91365@archlinux>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 20, 2020 at 04:40:49PM +0100, Jonathan Cameron wrote:
> On Wed, 17 Jun 2020 12:12:59 +0200
> Krzysztof Kozlowski <krzk@kernel.org> wrote:
> 
> > The driver supports also BMC156B and BMM150B so document the compatibles
> > for these devices.
> > 
> > Fixes: 9d75db36df14 ("iio: magn: Add support for BMM150 magnetometer")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> > 
> > ---
> > 
> > The fixes tag is not accurate but at least offer some backporting.
> 
> I'm not sure we generally bother backporting a missing section of binding
> documentation. Particularly as this doc isn't in yaml yet so it's not
> as though any automated checking is likely to be occurring.
> 
> Rob, any views on backporting this sort of missing id addition?
> 
> One side comment here is that the devices that are magnetometers only
> should never have had the _magn prefix in their compatibles. We only
> do that for devices in incorporating several sensors in one package
> (like the bmc150) where we have multiple drivers for the different
> sensors incorporated. We are too late to fix that now though.  It
> may make sense to mark the _magn variants deprecated though and
> add the ones without the _magn postfix.

I can add proper compatibles and mark these as deprecated but actually
the driver should not have additional compatibles in first place - all
devices are just compatible with bosch,bmc150.

Therefore I can just add one new compatible: "bosch,bmc156" and mark the
last two deprecated.

Best regards,
Krzysztof


> 
> > ---
> >  .../devicetree/bindings/iio/magnetometer/bmc150_magn.txt     | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/iio/magnetometer/bmc150_magn.txt b/Documentation/devicetree/bindings/iio/magnetometer/bmc150_magn.txt
> > index fd5fca90fb39..7469073022db 100644
> > --- a/Documentation/devicetree/bindings/iio/magnetometer/bmc150_magn.txt
> > +++ b/Documentation/devicetree/bindings/iio/magnetometer/bmc150_magn.txt
> > @@ -4,7 +4,10 @@ http://ae-bst.resource.bosch.com/media/products/dokumente/bmc150/BST-BMC150-DS00
> >  
> >  Required properties:
> >  
> > -  - compatible : should be "bosch,bmc150_magn"
> > +  - compatible : should be one of:
> > +                 "bosch,bmc150_magn"
> > +                 "bosch,bmc156_magn"
> > +                 "bosch,bmm150_magn"
> >    - reg : the I2C address of the magnetometer
> >  
> >  Optional properties:
> 
