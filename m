Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E482435A717
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 21:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234970AbhDIT0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 15:26:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234785AbhDIT0t (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 15:26:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38B7461182;
        Fri,  9 Apr 2021 19:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617996396;
        bh=T5/Gk8/7t53pIA6HJOjBE7f7lEizFcgkfyEEm5DesGA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=KR5GLfVJttocQkbnBxLu4wlbH7p9gaNmBABUzwCQgqqIi1L12D53lHakc+Y5Hwgco
         SE5N2RDevq51ktjJIpefE8rHn2ARC48mTYsEP0KKpivPI+qZY4MuwYJc2nVKws1mCE
         7cSkD5CjDgODNQ2L4eE2WZpUlzDKWXiR+g5g1w/DisOPwtN6RXbP6h4+lGK4JBacQT
         3YOhY3Z2+dwPBO+TDEzaiQz0wuIkj0q/JMg7mHYdGlB5p6Jm8wZ9choz5HPSpRlhd+
         LH5fdOyP9pmWCd+eXT37ZS8RCBRM10ZEZ4K6Z8dkkynMOpCPYJfxr+fGM/xgJqH6vb
         tcBbu9Gw/+VJA==
Received: by mail-ej1-f53.google.com with SMTP id l4so10318457ejc.10;
        Fri, 09 Apr 2021 12:26:36 -0700 (PDT)
X-Gm-Message-State: AOAM530TlDKK4F+yE+n24Jv+9m8nKF97wA1uLIoRB2Tjbognb0Rv7MZw
        EhZeGaCeGjXh5x65VYCFgf2kJGzZ+0cx7Z5Acg==
X-Google-Smtp-Source: ABdhPJxLgovQljRZnzpx7dPS9KN679Jr1Pf1qV+0xUCFdy0AnkjpMqEmpWSdbJEw981NcpA8gNiAxVtEH5dU7kzp9z8=
X-Received: by 2002:a17:907:217b:: with SMTP id rl27mr9796319ejb.359.1617996394718;
 Fri, 09 Apr 2021 12:26:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210405031436.2465475-1-ilya.lipnitskiy@gmail.com>
 <20210405222540.18145-1-ilya.lipnitskiy@gmail.com> <CAGETcx-gF4r1TeY2AA4Vwb5e+5O+_O3E2ENo5tKhh=n_EOJnEQ@mail.gmail.com>
 <20210407003408.GA2551507@robh.at.kernel.org> <CAGETcx8=sSWj_OmM1GPXNiLcv3anEkJnb_C7NoO9mNwS-O0KhQ@mail.gmail.com>
 <CAL_JsqLs4c3+9WwV6Vnk9Tovb6HiyH7t+_WXYP-ZDO72mOcO+w@mail.gmail.com>
 <CAGETcx-W_K9NFV51iBvyZ-Q+1LCUM3qipMmap9yEW_eu9B7CCg@mail.gmail.com> <CALCv0x1qOKkMmwJu82sXEJ3L5Y2n4eQp8n+SN1HYwcgpYm6CAw@mail.gmail.com>
In-Reply-To: <CALCv0x1qOKkMmwJu82sXEJ3L5Y2n4eQp8n+SN1HYwcgpYm6CAw@mail.gmail.com>
From:   Rob Herring <robh@kernel.org>
Date:   Fri, 9 Apr 2021 14:26:22 -0500
X-Gmail-Original-Message-ID: <CAL_JsqJN5W60Cy6ec5HJxKMRag-MYO3yqkbBnWp6k_u6h85T=A@mail.gmail.com>
Message-ID: <CAL_JsqJN5W60Cy6ec5HJxKMRag-MYO3yqkbBnWp6k_u6h85T=A@mail.gmail.com>
Subject: Re: [PATCH v2] of: property: fw_devlink: do not link ".*,nr-gpios"
To:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc:     Saravana Kannan <saravanak@google.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 7, 2021 at 3:45 PM Ilya Lipnitskiy
<ilya.lipnitskiy@gmail.com> wrote:
>
> On Tue, Apr 6, 2021 at 6:24 PM Saravana Kannan <saravanak@google.com> wrote:
> >
> > On Tue, Apr 6, 2021 at 6:10 PM Rob Herring <robh@kernel.org> wrote:
> > >
> > > On Tue, Apr 6, 2021 at 7:46 PM Saravana Kannan <saravanak@google.com> wrote:
> > > >
> > > > On Tue, Apr 6, 2021 at 5:34 PM Rob Herring <robh@kernel.org> wrote:
> > > > >
> > > > > On Tue, Apr 06, 2021 at 04:09:10PM -0700, Saravana Kannan wrote:
> > > > > > On Mon, Apr 5, 2021 at 3:26 PM Ilya Lipnitskiy
> > > > > > <ilya.lipnitskiy@gmail.com> wrote:
> > > > > > >
> > > > > > > [<vendor>,]nr-gpios property is used by some GPIO drivers[0] to indicate
> > > > > > > the number of GPIOs present on a system, not define a GPIO. nr-gpios is
> > > > > > > not configured by #gpio-cells and can't be parsed along with other
> > > > > > > "*-gpios" properties.
> > > > > > >
> > > > > > > nr-gpios without the "<vendor>," prefix is not allowed by the DT
> > > > > > > spec[1], so only add exception for the ",nr-gpios" suffix and let the
> > > > > > > error message continue being printed for non-compliant implementations.
> > > > > > >
> > > > > > > [0]: nr-gpios is referenced in Documentation/devicetree/bindings/gpio:
> > > > > > >  - gpio-adnp.txt
> > > > > > >  - gpio-xgene-sb.txt
> > > > > > >  - gpio-xlp.txt
> > > > > > >  - snps,dw-apb-gpio.yaml
> > > > > > >
> > > > > > > [1]:
> > > > > > > Link: https://github.com/devicetree-org/dt-schema/blob/cb53a16a1eb3e2169ce170c071e47940845ec26e/schemas/gpio/gpio-consumer.yaml#L20
> > > > > > >
> > > > > > > Fixes errors such as:
> > > > > > >   OF: /palmbus@300000/gpio@600: could not find phandle
> > > > > > >
> > > > > > > Fixes: 7f00be96f125 ("of: property: Add device link support for interrupt-parent, dmas and -gpio(s)")
> > > > > > > Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
> > > > > > > Cc: Saravana Kannan <saravanak@google.com>
> > > > > > > Cc: <stable@vger.kernel.org> # 5.5.x
> > > > > > > ---
> > > > > > >  drivers/of/property.c | 11 ++++++++++-
> > > > > > >  1 file changed, 10 insertions(+), 1 deletion(-)
> > > > > > >
> > > > > > > diff --git a/drivers/of/property.c b/drivers/of/property.c
> > > > > > > index 2046ae311322..1793303e84ac 100644
> > > > > > > --- a/drivers/of/property.c
> > > > > > > +++ b/drivers/of/property.c
> > > > > > > @@ -1281,7 +1281,16 @@ DEFINE_SIMPLE_PROP(pinctrl7, "pinctrl-7", NULL)
> > > > > > >  DEFINE_SIMPLE_PROP(pinctrl8, "pinctrl-8", NULL)
> > > > > > >  DEFINE_SUFFIX_PROP(regulators, "-supply", NULL)
> > > > > > >  DEFINE_SUFFIX_PROP(gpio, "-gpio", "#gpio-cells")
> > > > > > > -DEFINE_SUFFIX_PROP(gpios, "-gpios", "#gpio-cells")
> > > > > > > +
> > > > > > > +static struct device_node *parse_gpios(struct device_node *np,
> > > > > > > +                                      const char *prop_name, int index)
> > > > > > > +{
> > > > > > > +       if (!strcmp_suffix(prop_name, ",nr-gpios"))
> > > > > > > +               return NULL;
> > > > > >
> > > > > > Ah I somehow missed this patch. This gives a blanked exception for
> > > > > > vendor,nr-gpios. I'd prefer explicit exceptions for all the instances
> > > > > > of ",nr-gpios" we are grandfathering in. Any future additions should
> > > > > > be rejected. Can we do that please?
> > > > > >
> > > > > > Rob, you okay with making this list more explicit?
> > > > >
> > > > > Not the kernel's job IMO. A schema is the right way to handle that.
> > > >
> > > > Ok, that's fine by me. Btw, let's land this in driver-core? I've made
> > > > changes there and this might cause conflicts. Not sure.
> > >
> > > It merges with linux-next fine. You'll need to resend this to Greg if
> > > you want to do that.
> > >
> > > Reviewed-by: Rob Herring <robh@kernel.org>
> >
> > Hi Greg,
> >
> > Can you pull this into driver-core please?
> Do you want me to re-spin on top of driver-core? The patch is
> currently based on dt/next in robh/linux.git

I did say you need to resend the patch to Greg, but since there's no
movement on this and I have other things to send upstream, I've
applied it.

Rob
