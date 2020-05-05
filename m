Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2F91C6325
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 23:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbgEEVhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 17:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728584AbgEEVhX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 May 2020 17:37:23 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93EDC061A0F;
        Tue,  5 May 2020 14:37:23 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id t11so134201pgg.2;
        Tue, 05 May 2020 14:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F3cjpEcBYVPl9bnBNf68XdHTqzqq7zD5qmZWf9yJER4=;
        b=tz1+TWq5YMkt8tUz6bFYVzJpba9Z/G1z4iKbsWJXd7bFjdpUbHz53VImsRxYuRBsfd
         9fOLZuZkxUhEgGXZpajTkt13fGdmp1TBLIqXWs+U0xCU8ru4iZ2c/G/3Ng8eomF07TdH
         f20fmRXU2+x22gQhnPLa0ZQ5Cx50Fx1PfSfO2dZABxbcQ4FxzXHzsKi+6Oi6JrbaCck2
         06XtjchF0xGCSJ/BjwjyUvPp0ZhEAd6002q0nya/g9+/B1h4lFthE/0eUEfIKgilyG9n
         ShtnKeKgKFfkOK8uV7h1CIzg9Uf/MSNKSgXOoRuIsS24Sx2FC3dgIK3hxtlf0LZJS9W9
         drow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F3cjpEcBYVPl9bnBNf68XdHTqzqq7zD5qmZWf9yJER4=;
        b=pCwPgyGqCSSRdliBSRoyv/wIRolzFlcguuQbHNqcqtkIM8stv3SK1eCqnj3+OO+tUF
         Hp44LyzrvHPz57I7udvMHBVJepGw1Ad7ka2ugfjRBWDn4Pt5S88ryyT9c7elGjxtehjE
         zhhVmmWBXuLUAXxZCcs5Tf0phRSpUPISCOtizDK1+RRNOCYh4V8rU7xwSTlkvV0qXy74
         dozQguiHeEYYfOaCX22x370Yn45rKHtA3eC3vuCkUA/VCH1z9m6SSMsAmbu+9/tVxmUD
         Muocg4TG+8tyj75IsT/o70s/wazQjLl14aSlpfybuQY39cE4ZAa5Z9YpamVcmEbbEe4G
         tH0A==
X-Gm-Message-State: AGi0PuZ3YQ69BwKN/CfW7vI4QA4dKvFUNNUp0itH/dOfSaiRy2JjkZZG
        Q062c2TKAiBgdmIYohN9yv5loLsduNNv1DYt2B/5HUGTq5s=
X-Google-Smtp-Source: APiQypKjIuDFIBIdUXXDprhBrI/Tiq4fQBxeML7Is4+n+AMv/V7JwMSJnnYW2wptHSUqLoNmxawk6KXWbukrGMepYhk=
X-Received: by 2002:a62:5ec7:: with SMTP id s190mr4908701pfb.130.1588714643020;
 Tue, 05 May 2020 14:37:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200504165448.264746645@linuxfoundation.org> <20200504165451.307643203@linuxfoundation.org>
 <20200505123159.GC28722@amd> <CAHp75VeM+qwh5rHL7RDdacru0jPSB9me2aTs__jdy749dTKRng@mail.gmail.com>
 <20200505125818.GA31126@amd> <CAHp75VcKreeQpjROdL23XGqgVu+F_0eL5DsJ=5APEQUO9V69EQ@mail.gmail.com>
 <20200505133700.GA31753@amd> <CAHp75Ve+pzhamZXiKxHF+VD8yfsjRF2coattHyiD+0aa7Fy2DA@mail.gmail.com>
 <20200505153227.GI13035@sasha-vm> <20200505155734.GA10069@duo.ucw.cz>
In-Reply-To: <20200505155734.GA10069@duo.ucw.cz>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 6 May 2020 00:37:11 +0300
Message-ID: <CAHp75Vfcrji_D8tsiBhpPWQTgS=WhO9fwWWut-xeVOg2Z_FqEA@mail.gmail.com>
Subject: Re: [PATCH 4.19 28/37] dmaengine: dmatest: Fix iteration non-stop logic
To:     Pavel Machek <pavel@denx.de>
Cc:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 5, 2020 at 6:57 PM Pavel Machek <pavel@denx.de> wrote:
> On Tue 2020-05-05 11:32:27, Sasha Levin wrote:
> > On Tue, May 05, 2020 at 05:05:37PM +0300, Andy Shevchenko wrote:

...

> > I'm a bit confused about this too. Maybe it's too early in the morning,
> > so I wrote this little test program:
> >
> > #include <stdio.h>
> > #include <stdlib.h>
> >
> > int main(int argc, char *argv[])
> > {
> >        int a = atoi(argv[1]);
> >        int b = atoi(argv[2]);
> >
> >        if (!a && !b)
> >                printf("A");
> >        else
> >                printf("B");
> >
> >        if (!(a || b))
> >                printf("A");
> >        else
> >                printf("B");
> >
> >        printf("\n");
> >
> >        return 0;
> > }
> >
> > Andy, could you give an example of two values which will print something
> > other than "AA" or "BB"?
>
> The issue here is "sideffects". Does b have to be evaluated at all?
> There is no difference between
>
>       int a, b;
>       if (a && b)
>
> and
>
>         if ((!!a) & (!!b))
> .
>
> But there would be difference between
>
>       int a, b;
>         if (a && b++)
>
> and
>         if ((!!a) & (!!(b++)))
>
> But:
>
> 1) && and || behave same way w.r.t. side effects
>
> 2) in the patch we are talking about b has no important side effects

I have to admit that this seems like a luck and the real issue somewhere else.
Definitely another test should be performed.

Thank you, Pavel, for pointing this out.

-- 
With Best Regards,
Andy Shevchenko
