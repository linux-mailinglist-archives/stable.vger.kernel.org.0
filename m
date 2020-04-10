Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 172371A4298
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 08:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725816AbgDJGkf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Apr 2020 02:40:35 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:34180 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbgDJGke (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Apr 2020 02:40:34 -0400
Received: by mail-oi1-f194.google.com with SMTP id d3so723725oic.1
        for <stable@vger.kernel.org>; Thu, 09 Apr 2020 23:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NSAoS9toyPmhYfkY6R5ARK3rs6pR2Bcii1AAeaa8Lm0=;
        b=mIA3G4FTs5HtWAytS3ZkCmCG9EwB44uBIf/owTiSz98CsSKn/j+h+LhOZgC/w9ojs9
         6FWrnvMj6EF4YFozGRIV5Vd7gjm/IbrCmOeWbInX74M96Eg86ZuLrzMZb1e/fwic9LhT
         2Y/3WWdenXfD4s+fdRF84HkRZr1WTbjNqqg4rDxth5+VAVxjj+rzWA9+F7bgZCA9TpNa
         BxtKGechxC/yFiUEkONXPd/j6lOiBAE9KKizuv8OLXRUVRwIOOzAcfEd+nEGZWcvubMx
         ZR99GNbJB1lYyvkRmr7OER1MFVDE3JqGHtTjzX1GVZyqfPWtiUvOeAD1NbCRgcixsFDc
         SNGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NSAoS9toyPmhYfkY6R5ARK3rs6pR2Bcii1AAeaa8Lm0=;
        b=aS4QwXugkL+sJ2Fdl/041HNVITCJVN6S+SD1fpD43R0E9kst1Kl2KAYge5KEocw0PP
         2NJmuybMT+rgfZqMn/6hqBzKngFvixPm6RjTkCP/1qvnxNjXSLGKxM6VgxhZ7z2JwQ7a
         6chuNus0AhBinufkV+vPwuIdZT2+2P8EzK9eWBJspnqrBYkeSybNfjDk617Iexu98wla
         q5f9o+TT71z8UNMCQm8bibQ9+6wGf3b2SewOAOJVfQkfywGsv2T/V+DNxD44Mh1OGJTs
         f+bZ51HZVrghLgO2ivDjAW0TECO6nLFFIGncAhjTL3XXDG3/ziAWE6Mvgzb2D8L9G4H2
         bJmQ==
X-Gm-Message-State: AGi0PuZNxJ/TDyoMkVHEc/1wK1xkx2J/EI69BusL5uAXMdbxhn9mossq
        I2D3GKPFXvfUOe8m9YZaSqUiu8xIP4Yzz8mltuKtjg==
X-Google-Smtp-Source: APiQypKfFxcWISJ4H1ctOzUL+actgjwCLINqmzsMbdEijDv+1lg6aY+i2kxW4Szt6U/Hxz1c9R7x5ZWx+YYaoa3X8qY=
X-Received: by 2002:a54:481a:: with SMTP id j26mr2386493oij.172.1586500831834;
 Thu, 09 Apr 2020 23:40:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200410034634.7731-1-sashal@kernel.org> <20200410034634.7731-14-sashal@kernel.org>
 <20200410062931.GD1663372@kroah.com>
In-Reply-To: <20200410062931.GD1663372@kroah.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Thu, 9 Apr 2020 23:39:55 -0700
Message-ID: <CAGETcx9Kp6JvuyF770XKsMTCY6=rC2zuBTG07oB18bya0owgWw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.6 14/68] driver core: Reevaluate
 dev->links.need_for_probe as suppliers are added
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 9, 2020 at 11:29 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Apr 09, 2020 at 11:45:39PM -0400, Sasha Levin wrote:
> > From: Saravana Kannan <saravanak@google.com>
> >
> > [ Upstream commit 1745d299af5b373abad08fa29bff0d31dc6aff21 ]
> >
> > A previous patch 03324507e66c ("driver core: Allow
> > fwnode_operations.add_links to differentiate errors") forgot to update
> > all call sites to fwnode_operations.add_links. This patch fixes that.
> >
> > Legend:
> > -> Denotes RHS is an optional/potential supplier for LHS
> > => Denotes RHS is a mandatory supplier for LHS
> >
> > Example:
> >
> > Device A => Device X
> > Device A -> Device Y
> >
> > Before this patch:
> > 1. Device A is added.
> > 2. Device A is marked as waiting for mandatory suppliers
> > 3. Device X is added
> > 4. Device A is left marked as waiting for mandatory suppliers
> >
> > Step 4 is wrong since all mandatory suppliers of Device A have been
> > added.
> >
> > After this patch:
> > 1. Device A is added.
> > 2. Device A is marked as waiting for mandatory suppliers
> > 3. Device X is added
> > 4. Device A is no longer considered as waiting for mandatory suppliers
> >
> > This is the correct behavior.
> >
> > Fixes: 03324507e66c ("driver core: Allow fwnode_operations.add_links to differentiate errors")
> > Signed-off-by: Saravana Kannan <saravanak@google.com>
> > Link: https://lore.kernel.org/r/20200222014038.180923-2-saravanak@google.com
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/base/core.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/base/core.c b/drivers/base/core.c
> > index dbb0f9130f42d..d32a3aefff32f 100644
> > --- a/drivers/base/core.c
> > +++ b/drivers/base/core.c
> > @@ -523,9 +523,13 @@ static void device_link_add_missing_supplier_links(void)
> >
> >       mutex_lock(&wfs_lock);
> >       list_for_each_entry_safe(dev, tmp, &wait_for_suppliers,
> > -                              links.needs_suppliers)
> > -             if (!fwnode_call_int_op(dev->fwnode, add_links, dev))
> > +                              links.needs_suppliers) {
> > +             int ret = fwnode_call_int_op(dev->fwnode, add_links, dev);
> > +             if (!ret)
> >                       list_del_init(&dev->links.needs_suppliers);
> > +             else if (ret != -ENODEV)
> > +                     dev->links.need_for_probe = false;
> > +     }
> >       mutex_unlock(&wfs_lock);
> >  }
>
> For some reason this wasn't for stable kernels, but I can't remember.

It *is* for stable kernels too. It is an actual bug that's fixable in
stable kernels. I think this might have been the one patch that I
bundled into an unrelated series, but called it out as an unrelated
bug. Maybe my wording in that email threw you off?

-Saravana
