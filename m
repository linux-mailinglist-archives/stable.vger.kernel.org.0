Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F32935A734
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 21:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234940AbhDITh1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 15:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234909AbhDITh1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Apr 2021 15:37:27 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4976FC061764
        for <stable@vger.kernel.org>; Fri,  9 Apr 2021 12:37:13 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id k73so1514636ybf.3
        for <stable@vger.kernel.org>; Fri, 09 Apr 2021 12:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R1/OVPtN1o6F7NiHy85jZm12iAQXmTjdYOcMRG5H5z8=;
        b=H9Jv6ncbEXaM6/C7+ee9aKWZSK/+1IvwExFPRwoyOqN6ZW1XyFCFNQpEyuBdnnOj9H
         CEldmayQUFpeaVZJvxt1TmodyDhik/6mPTm4+4vTrRmXD0rpEolOpGbrleZWbLXd17TR
         pHrOD7Cl+RI2efjYt99WdKQMPC/wdzbMi7eXq6kaGzMQpDTLwSGDCZp3MBajQqUD9bQV
         mxk3MtxXvJBVpuwfLtM4BMt89sZdF6VcJ//3oZ+HNUNQ0VSoI+eRHiiLPvIROwSkUb1l
         FRtqGvNbfhaOANAwPXq6zka4WZ7fRmfqZnSY11SRKP7zrLbMUnumUBLEUzMePjyQvt1l
         O1og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R1/OVPtN1o6F7NiHy85jZm12iAQXmTjdYOcMRG5H5z8=;
        b=IU85GmREwz7AASwpKa/Fj4EhfBiT9BU8I+yoORRa6rRdKV764mswXWIlXMziZEKpeE
         xM5rOgxSGjG+5IPAgFG9tvvauaWJBz25LSvrHYYir4bZwR2LS+foe0PCoUZjaXcC7uYj
         KBqhfydHaq1LuK4q+8YgwLm7EpmBBH0JCmIprwaEyMn7xt0v+JNyn6asbKevbd93Tt15
         oYE6XiA9VXCGKgP0zArTLYriId/0+QfviewofW4NjJjplQQvg/Y6y1WX/PCLunLdFne+
         ho6fDkyNcrdFTduYLUArqLbunov7DYMcXDSBXHIz2pSkdLAiWT36IgA2TDqHESEQ+ogK
         XFqg==
X-Gm-Message-State: AOAM531e0MZhucMuihdN/VuHQVma76ZWNLDTrp1YgMh2+BWD6WsjcI9c
        pet+02z+5MHCCuAntsmPu4STXQEqP0gw33h7yrNzlw==
X-Google-Smtp-Source: ABdhPJzaO3tSHtgjMLsj1QfG8LQ8GH0SaOQv4dVtyf3TMcwnLp4vs6u/zBz+XyfW/1p2FWpgwS3wMqRwWdxIDiijEJk=
X-Received: by 2002:a25:907:: with SMTP id 7mr20270089ybj.346.1617997032220;
 Fri, 09 Apr 2021 12:37:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210405031436.2465475-1-ilya.lipnitskiy@gmail.com>
 <20210405222540.18145-1-ilya.lipnitskiy@gmail.com> <CAGETcx-gF4r1TeY2AA4Vwb5e+5O+_O3E2ENo5tKhh=n_EOJnEQ@mail.gmail.com>
 <20210407003408.GA2551507@robh.at.kernel.org> <CAGETcx8=sSWj_OmM1GPXNiLcv3anEkJnb_C7NoO9mNwS-O0KhQ@mail.gmail.com>
 <CAL_JsqLs4c3+9WwV6Vnk9Tovb6HiyH7t+_WXYP-ZDO72mOcO+w@mail.gmail.com>
 <CAGETcx-W_K9NFV51iBvyZ-Q+1LCUM3qipMmap9yEW_eu9B7CCg@mail.gmail.com>
 <CALCv0x1qOKkMmwJu82sXEJ3L5Y2n4eQp8n+SN1HYwcgpYm6CAw@mail.gmail.com> <CAL_JsqJN5W60Cy6ec5HJxKMRag-MYO3yqkbBnWp6k_u6h85T=A@mail.gmail.com>
In-Reply-To: <CAL_JsqJN5W60Cy6ec5HJxKMRag-MYO3yqkbBnWp6k_u6h85T=A@mail.gmail.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Fri, 9 Apr 2021 12:36:36 -0700
Message-ID: <CAGETcx_3CYxrSBtTgRkyRJUS0kdtn3ukLYpSznY-e9O6eOe+xA@mail.gmail.com>
Subject: Re: [PATCH v2] of: property: fw_devlink: do not link ".*,nr-gpios"
To:     Rob Herring <robh@kernel.org>
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 9, 2021 at 12:26 PM Rob Herring <robh@kernel.org> wrote:
>
> On Wed, Apr 7, 2021 at 3:45 PM Ilya Lipnitskiy
> <ilya.lipnitskiy@gmail.com> wrote:
> >
> > On Tue, Apr 6, 2021 at 6:24 PM Saravana Kannan <saravanak@google.com> wrote:
> > >
> > > On Tue, Apr 6, 2021 at 6:10 PM Rob Herring <robh@kernel.org> wrote:
> > > >
> > > > On Tue, Apr 6, 2021 at 7:46 PM Saravana Kannan <saravanak@google.com> wrote:
> > > > >
> > > > > On Tue, Apr 6, 2021 at 5:34 PM Rob Herring <robh@kernel.org> wrote:
> > > > > >
> > > > > > On Tue, Apr 06, 2021 at 04:09:10PM -0700, Saravana Kannan wrote:
> > > > > > > On Mon, Apr 5, 2021 at 3:26 PM Ilya Lipnitskiy
> > > > > > > <ilya.lipnitskiy@gmail.com> wrote:
> > > > > > > >
> > > > > > > > [<vendor>,]nr-gpios property is used by some GPIO drivers[0] to indicate
> > > > > > > > the number of GPIOs present on a system, not define a GPIO. nr-gpios is
> > > > > > > > not configured by #gpio-cells and can't be parsed along with other
> > > > > > > > "*-gpios" properties.
> > > > > > > >
> > > > > > > > nr-gpios without the "<vendor>," prefix is not allowed by the DT
> > > > > > > > spec[1], so only add exception for the ",nr-gpios" suffix and let the
> > > > > > > > error message continue being printed for non-compliant implementations.
> > > > > > > >
> > > > > > > > [0]: nr-gpios is referenced in Documentation/devicetree/bindings/gpio:
> > > > > > > >  - gpio-adnp.txt
> > > > > > > >  - gpio-xgene-sb.txt
> > > > > > > >  - gpio-xlp.txt
> > > > > > > >  - snps,dw-apb-gpio.yaml
> > > > > > > >
> > > > > > > > [1]:
> > > > > > > > Link: https://github.com/devicetree-org/dt-schema/blob/cb53a16a1eb3e2169ce170c071e47940845ec26e/schemas/gpio/gpio-consumer.yaml#L20
> > > > > > > >
> > > > > > > > Fixes errors such as:
> > > > > > > >   OF: /palmbus@300000/gpio@600: could not find phandle
> > > > > > > >
> > > > > > > > Fixes: 7f00be96f125 ("of: property: Add device link support for interrupt-parent, dmas and -gpio(s)")
> > > > > > > > Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
> > > > > > > > Cc: Saravana Kannan <saravanak@google.com>
> > > > > > > > Cc: <stable@vger.kernel.org> # 5.5.x
> > > > > > > > ---
> > > > > > > >  drivers/of/property.c | 11 ++++++++++-
> > > > > > > >  1 file changed, 10 insertions(+), 1 deletion(-)
> > > > > > > >
> > > > > > > > diff --git a/drivers/of/property.c b/drivers/of/property.c
> > > > > > > > index 2046ae311322..1793303e84ac 100644
> > > > > > > > --- a/drivers/of/property.c
> > > > > > > > +++ b/drivers/of/property.c
> > > > > > > > @@ -1281,7 +1281,16 @@ DEFINE_SIMPLE_PROP(pinctrl7, "pinctrl-7", NULL)
> > > > > > > >  DEFINE_SIMPLE_PROP(pinctrl8, "pinctrl-8", NULL)
> > > > > > > >  DEFINE_SUFFIX_PROP(regulators, "-supply", NULL)
> > > > > > > >  DEFINE_SUFFIX_PROP(gpio, "-gpio", "#gpio-cells")
> > > > > > > > -DEFINE_SUFFIX_PROP(gpios, "-gpios", "#gpio-cells")
> > > > > > > > +
> > > > > > > > +static struct device_node *parse_gpios(struct device_node *np,
> > > > > > > > +                                      const char *prop_name, int index)
> > > > > > > > +{
> > > > > > > > +       if (!strcmp_suffix(prop_name, ",nr-gpios"))
> > > > > > > > +               return NULL;
> > > > > > >
> > > > > > > Ah I somehow missed this patch. This gives a blanked exception for
> > > > > > > vendor,nr-gpios. I'd prefer explicit exceptions for all the instances
> > > > > > > of ",nr-gpios" we are grandfathering in. Any future additions should
> > > > > > > be rejected. Can we do that please?
> > > > > > >
> > > > > > > Rob, you okay with making this list more explicit?
> > > > > >
> > > > > > Not the kernel's job IMO. A schema is the right way to handle that.
> > > > >
> > > > > Ok, that's fine by me. Btw, let's land this in driver-core? I've made
> > > > > changes there and this might cause conflicts. Not sure.
> > > >
> > > > It merges with linux-next fine. You'll need to resend this to Greg if
> > > > you want to do that.
> > > >
> > > > Reviewed-by: Rob Herring <robh@kernel.org>
> > >
> > > Hi Greg,
> > >
> > > Can you pull this into driver-core please?
> > Do you want me to re-spin on top of driver-core? The patch is
> > currently based on dt/next in robh/linux.git
>
> I did say you need to resend the patch to Greg, but since there's no
> movement on this and I have other things to send upstream, I've
> applied it.

:'(

If it's not too late, can we please drop it? I'm sure Greg would be
okay with picking this up.

-Saravana
