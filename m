Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4357D35763F
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 22:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbhDGUpQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 16:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhDGUpQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Apr 2021 16:45:16 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4052BC061760;
        Wed,  7 Apr 2021 13:45:06 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id e8so20875793iok.5;
        Wed, 07 Apr 2021 13:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5hgBZouQmreyodGv5acY2yYnV17I5RQyemsnLH3k/2E=;
        b=Egfp9GGewYQyQ0DnzymZseq4LTlkzwVzI6tn0UCY2ZYZDrL2VUZV5ZT4GeuuJMm+95
         rlL5/ves1ZLVozKs0iOGjGbZ9hAtdQkD9VMT73inxppB/FUOYcfC+ZyfZEN89Y85RGsG
         MW6u5Y+ilktggGyiqmqY/Vlgue7fpGJC1kZ4O0LsZWJBatug6pJZDceZf5027WGPUxq9
         2LQzIgcs/dcy8Lg4g36FEYeFGIPsWy+WM+ORdw9AwzYpk4gr5cDEXCnpR9NuoELHisUj
         x4oHQt2tSqoKzqgd0bGMMrjhUlSN3RftdXAxUEKkvcxDQ2J3s2OJJtzCmP1teLoXVr49
         Nehg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5hgBZouQmreyodGv5acY2yYnV17I5RQyemsnLH3k/2E=;
        b=sWC54mX4Kta4ODnZKx/GRJ5Sg5xQnd0NTVtGsrMKjY6fye23ouUnsovFLHXZgJwWZn
         30KuBUBnPoSDxFO1uAi7QDuQA5KmgIm3V2j4NiJMFMFATETPbAgr7uiP/zXdxrdk/y32
         ZlJ8sIWriorVIQgFqy8d1hgT366qtlBozPGnQSIgRszaQmM1XaZQpNA+F09KnGqh7aqW
         8wt9czQVecdZxQxuI0AbI+J4QrZ6oyLoECqqIX1X/LqvsGOgg+UAymUBx3mDcgUoC40u
         K3KssSNtucpy+LmbEf/ehLI/7RPFP2jYhpYTfWn5xe36kzMuaZB2lFTffHDw8tOz37ju
         B64w==
X-Gm-Message-State: AOAM531EFho/tVAupkrxo+Pp1hEEUkJS4OFtIV8JWKbXCfQIdnVY7jdT
        yklxXpfjOR4is0eY6WToAV/OyW5PniUuKH3GV4U=
X-Google-Smtp-Source: ABdhPJyxzOHzpmsg3BBXaiGPDtHYf2ijK+KQOm/0GkLOxcvcOm1J8Cyxqg44IZLrTaA+4ZhLLvJ7rZWGHd6gpTreeNA=
X-Received: by 2002:a02:9645:: with SMTP id c63mr5423293jai.84.1617828305765;
 Wed, 07 Apr 2021 13:45:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210405031436.2465475-1-ilya.lipnitskiy@gmail.com>
 <20210405222540.18145-1-ilya.lipnitskiy@gmail.com> <CAGETcx-gF4r1TeY2AA4Vwb5e+5O+_O3E2ENo5tKhh=n_EOJnEQ@mail.gmail.com>
 <20210407003408.GA2551507@robh.at.kernel.org> <CAGETcx8=sSWj_OmM1GPXNiLcv3anEkJnb_C7NoO9mNwS-O0KhQ@mail.gmail.com>
 <CAL_JsqLs4c3+9WwV6Vnk9Tovb6HiyH7t+_WXYP-ZDO72mOcO+w@mail.gmail.com> <CAGETcx-W_K9NFV51iBvyZ-Q+1LCUM3qipMmap9yEW_eu9B7CCg@mail.gmail.com>
In-Reply-To: <CAGETcx-W_K9NFV51iBvyZ-Q+1LCUM3qipMmap9yEW_eu9B7CCg@mail.gmail.com>
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Date:   Wed, 7 Apr 2021 13:44:54 -0700
Message-ID: <CALCv0x1qOKkMmwJu82sXEJ3L5Y2n4eQp8n+SN1HYwcgpYm6CAw@mail.gmail.com>
Subject: Re: [PATCH v2] of: property: fw_devlink: do not link ".*,nr-gpios"
To:     Saravana Kannan <saravanak@google.com>
Cc:     Rob Herring <robh@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 6, 2021 at 6:24 PM Saravana Kannan <saravanak@google.com> wrote:
>
> On Tue, Apr 6, 2021 at 6:10 PM Rob Herring <robh@kernel.org> wrote:
> >
> > On Tue, Apr 6, 2021 at 7:46 PM Saravana Kannan <saravanak@google.com> wrote:
> > >
> > > On Tue, Apr 6, 2021 at 5:34 PM Rob Herring <robh@kernel.org> wrote:
> > > >
> > > > On Tue, Apr 06, 2021 at 04:09:10PM -0700, Saravana Kannan wrote:
> > > > > On Mon, Apr 5, 2021 at 3:26 PM Ilya Lipnitskiy
> > > > > <ilya.lipnitskiy@gmail.com> wrote:
> > > > > >
> > > > > > [<vendor>,]nr-gpios property is used by some GPIO drivers[0] to indicate
> > > > > > the number of GPIOs present on a system, not define a GPIO. nr-gpios is
> > > > > > not configured by #gpio-cells and can't be parsed along with other
> > > > > > "*-gpios" properties.
> > > > > >
> > > > > > nr-gpios without the "<vendor>," prefix is not allowed by the DT
> > > > > > spec[1], so only add exception for the ",nr-gpios" suffix and let the
> > > > > > error message continue being printed for non-compliant implementations.
> > > > > >
> > > > > > [0]: nr-gpios is referenced in Documentation/devicetree/bindings/gpio:
> > > > > >  - gpio-adnp.txt
> > > > > >  - gpio-xgene-sb.txt
> > > > > >  - gpio-xlp.txt
> > > > > >  - snps,dw-apb-gpio.yaml
> > > > > >
> > > > > > [1]:
> > > > > > Link: https://github.com/devicetree-org/dt-schema/blob/cb53a16a1eb3e2169ce170c071e47940845ec26e/schemas/gpio/gpio-consumer.yaml#L20
> > > > > >
> > > > > > Fixes errors such as:
> > > > > >   OF: /palmbus@300000/gpio@600: could not find phandle
> > > > > >
> > > > > > Fixes: 7f00be96f125 ("of: property: Add device link support for interrupt-parent, dmas and -gpio(s)")
> > > > > > Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
> > > > > > Cc: Saravana Kannan <saravanak@google.com>
> > > > > > Cc: <stable@vger.kernel.org> # 5.5.x
> > > > > > ---
> > > > > >  drivers/of/property.c | 11 ++++++++++-
> > > > > >  1 file changed, 10 insertions(+), 1 deletion(-)
> > > > > >
> > > > > > diff --git a/drivers/of/property.c b/drivers/of/property.c
> > > > > > index 2046ae311322..1793303e84ac 100644
> > > > > > --- a/drivers/of/property.c
> > > > > > +++ b/drivers/of/property.c
> > > > > > @@ -1281,7 +1281,16 @@ DEFINE_SIMPLE_PROP(pinctrl7, "pinctrl-7", NULL)
> > > > > >  DEFINE_SIMPLE_PROP(pinctrl8, "pinctrl-8", NULL)
> > > > > >  DEFINE_SUFFIX_PROP(regulators, "-supply", NULL)
> > > > > >  DEFINE_SUFFIX_PROP(gpio, "-gpio", "#gpio-cells")
> > > > > > -DEFINE_SUFFIX_PROP(gpios, "-gpios", "#gpio-cells")
> > > > > > +
> > > > > > +static struct device_node *parse_gpios(struct device_node *np,
> > > > > > +                                      const char *prop_name, int index)
> > > > > > +{
> > > > > > +       if (!strcmp_suffix(prop_name, ",nr-gpios"))
> > > > > > +               return NULL;
> > > > >
> > > > > Ah I somehow missed this patch. This gives a blanked exception for
> > > > > vendor,nr-gpios. I'd prefer explicit exceptions for all the instances
> > > > > of ",nr-gpios" we are grandfathering in. Any future additions should
> > > > > be rejected. Can we do that please?
> > > > >
> > > > > Rob, you okay with making this list more explicit?
> > > >
> > > > Not the kernel's job IMO. A schema is the right way to handle that.
> > >
> > > Ok, that's fine by me. Btw, let's land this in driver-core? I've made
> > > changes there and this might cause conflicts. Not sure.
> >
> > It merges with linux-next fine. You'll need to resend this to Greg if
> > you want to do that.
> >
> > Reviewed-by: Rob Herring <robh@kernel.org>
>
> Hi Greg,
>
> Can you pull this into driver-core please?
Do you want me to re-spin on top of driver-core? The patch is
currently based on dt/next in robh/linux.git

Ilya
