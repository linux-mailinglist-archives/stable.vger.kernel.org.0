Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 992333FE91D
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 08:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237186AbhIBGI5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 02:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbhIBGI4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Sep 2021 02:08:56 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FE7DC061575
        for <stable@vger.kernel.org>; Wed,  1 Sep 2021 23:07:58 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id n27so1693881eja.5
        for <stable@vger.kernel.org>; Wed, 01 Sep 2021 23:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SHG50PNNbVGUUEbWoPMrQ/DWcyjMdOPEpRnPQjbzHTQ=;
        b=Ay1US8LeJ+pqW1jihRyQZrgZu8OvRirJOfonmDnK5kWswLPwZzDyd9TGd5hc1/LBJS
         2SYcs8MQALvXVpkMF1xlSiJB88LgJ1aYEQ7V299JmXfvg0aYJ+uk8DZBmEslWUAfTuUL
         XpACdgddEd8gQWdHFvAE9bGSfgy/Mbg9KRkmTf6cjhicjuaAVC9XJmmawNd1A/v91KFs
         vFrVwokb64iXjlaatGA+5NYg8sK8i9sJqsXMqPuHJLrFXYVD2htLCov43nh0lquawycS
         gLW87DmqLzZhX3+2KLzGCtwcE3elRW25dqiAnKWdKf2Fm+cDjpWcCDagOMEMvzk1z1kh
         h6/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SHG50PNNbVGUUEbWoPMrQ/DWcyjMdOPEpRnPQjbzHTQ=;
        b=n2+M7MrRbdV9x5+uibC2dFVKFXGexByU22xglbSpUIz+WzgPf2o4GNLGwnCUDLqEpP
         6QVUsEAPT9D/iFh6iOy32Ceapep/NVQZDe71oup/O32E9fqtQHagbZAo3K1KuL8mmbZn
         erHKVKl6SFelY7R5UcKaGQ5fnYWpAkiI3cflYoXTR6LtxoK7eB3jWSh+T1hymlJmxa9J
         LbhV2orgJNDNyHBkxZiZnXy6DPzB6r5YOwO3xM4I1zgG0rdA3mQvBGil4sQCSI7kQbtw
         2Km7Uot3OV+70HmzpShS+lWRRsINjiF/aLptrFnRtWun/rSQiXDaT98oTQyjfSrQxQUB
         uIrA==
X-Gm-Message-State: AOAM5309NybCXIwQBenOxeev2eCGgAc8Ll7iGIcDNSc9eDSqCBLgZlL5
        why/2BKYoJgyIliT4x5LYOh8Zh6dDt66evUZcuP0pEFkJyd76Q==
X-Google-Smtp-Source: ABdhPJwRsYopIt1UMwvYK6e/mkkY+0gsjTB/R+pnvXHbiF7kgozj8wlNDFPHI+aBjL2JAie5Pb3X1K3/4cCwhri1WTk=
X-Received: by 2002:a17:906:31ca:: with SMTP id f10mr2034664ejf.73.1630562877028;
 Wed, 01 Sep 2021 23:07:57 -0700 (PDT)
MIME-Version: 1.0
References: <CAD-N9QUhebBrJ1fZG-i09PSKjC9Vat3Ym5VHoOrXGAO_tKQdpQ@mail.gmail.com>
 <YS8bvAc4XbaxSssu@kroah.com> <CAD-N9QXikdSxPnTnEsU3KUYkjXsOpKR14JQ_-+B7OEzMOnjTSA@mail.gmail.com>
 <YTBhCPBu/5UhEsxF@kroah.com>
In-Reply-To: <YTBhCPBu/5UhEsxF@kroah.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Thu, 2 Sep 2021 14:07:30 +0800
Message-ID: <CAD-N9QW43e_0dfMmZyH==tpCrgfZ=tMCjVnrc44gyJ1kUis9AA@mail.gmail.com>
Subject: Re: Linux kernel 4.19 and below misses the patch - "fbmem: add margin
 check to fb_check_caps()"
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 2, 2021 at 1:28 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Sep 02, 2021 at 09:32:32AM +0800, Dongliang Mu wrote:
> > On Wed, Sep 1, 2021 at 2:20 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Tue, Aug 31, 2021 at 02:47:22PM +0800, Dongliang Mu wrote:
> > > > Hi stable maintainers,
> > > >
> > > > It seems that Linux kernel 4.19 and below miss the patch - "fbmem: add
> > > > margin check to fb_check_caps()" [1]. Linux kernel 5.4 and up is
> > > > already merged this patch[2].
> > > >
> > > > Are there any special issues about this patch? Why do maintainers miss
> > > > such a patch?
> > >
> > > Because it does not apply to those older kernels.  If you feel it should
> > > be included there, can you please provide a working backport of the
> > > patch so that we can apply it?
> >
> > Sure, I will do that. Which mailing list or maintainers should I send to?
>
> Please read:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.

Hi gregkh,

I just sent a patch, please take a look. If there are any issues,
please let me know.

Best regards,
Dongliang Mu
