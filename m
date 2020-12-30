Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70FC42E788E
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 13:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbgL3Mdn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 07:33:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbgL3Mdm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Dec 2020 07:33:42 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5A4C06179B;
        Wed, 30 Dec 2020 04:33:02 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id e2so8598252plt.12;
        Wed, 30 Dec 2020 04:33:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YBq4ux2rHwtWwUj4+vJVHw4sIUUw61Ezm6PXDWr6xME=;
        b=UYFHFHRCKWRx65upsFBz+pMM1zexfhASG1/3t79EHz2mw1PeipSlREs/pS6IpDTW22
         wpeWIDe9snJd70Alh/9GrxL2scesbBK9Wyxo1eBfNTBvCawLyumVuQCbivP4E6lQhcFu
         zvC6dt72zlDzCDLqY+ixUNoptfkmmsQwtT9jc7gYlf4H/MTurTstejt1uZ1mcx+Lzftp
         fvRq/ybsbhawTgNEaZDPsFP8xT2E8YDfIiC1kiF3cX8f5PUEzs7tPg0zaItagAU+hKlf
         joLov6o/f6FAO7drkRm2/yRXk/T5B9GriA1k2LcWKryTXjV0EYFgZceQekEADRpwSOj+
         zKdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YBq4ux2rHwtWwUj4+vJVHw4sIUUw61Ezm6PXDWr6xME=;
        b=j5C32z0F1usx74K+kLHKv5jsd9oOALadP0ZB7A0YRsrzSMN3XXJNU+GCJXhhTgXKfr
         TlJjMl+5mujlqbNTMHguygqRThvonOU5RQe6ieAXHJUpS0PLLeQ+WOlTihEkIe8DzVMX
         TCh13/zmrhNEy5FVI95u2pEQm0CQm7K0ODl1wmWH7eqSeXM7zAfdV9Z9obUGLV2yKfHo
         YsSZNQSGwerohx2J9atklIDpxIc1n5aOnC7vJJnMeEmSM8SH2og81B+uqg3CyWNc0GH1
         qkz6osmBGEm2+tdtkY77SgT0NhEE5nb75+mZauMeb6lLKrbLIKPY95lU9DRoEFGy0hw3
         GizA==
X-Gm-Message-State: AOAM533PQY1sRgkIY5YUFguMO9zA2NbIQRIwAToFO2PdlwiU0eRgJ4VI
        Q0cLyxFzSL45oyAnfoep5nfCRI9hr3wRLMG+G3nlrAcnCsJtVw==
X-Google-Smtp-Source: ABdhPJzQrXyKWiB17vlUWdLeoBGcXKQl88GnFTDK/TOSG5hiNanP+u6iwGMVuCzx+fSF6CAOm9HxdAIfZ1z0tIlWwsQ=
X-Received: by 2002:a17:90a:1050:: with SMTP id y16mr8613426pjd.181.1609331582267;
 Wed, 30 Dec 2020 04:33:02 -0800 (PST)
MIME-Version: 1.0
References: <20201228125020.963311703@linuxfoundation.org> <20201228125046.214023397@linuxfoundation.org>
 <20201230122508.GA12190@duo.ucw.cz>
In-Reply-To: <20201230122508.GA12190@duo.ucw.cz>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 30 Dec 2020 14:32:46 +0200
Message-ID: <CAHp75VdFT-SUUj2LiPTs1_RJ-n97OiyQ2pF0jVbHsARkDshfwA@mail.gmail.com>
Subject: Re: [PATCH 5.10 527/717] media: ipu3-cio2: Validate mbus format in
 setting subdev format
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 30, 2020 at 2:25 PM Pavel Machek <pavel@denx.de> wrote:

> > commit a86cf9b29e8b12811cf53c4970eefe0c1d290476 upstream.
> >
> > Validate media bus code, width and height when setting the subdev format.
> >
> > This effectively reworks how setting subdev format is implemented in the
> > driver.
>
> Something is wrong here:
>
> > +     fmt->format.code = formats[0].mbus_code;
> > +     for (i = 0; i < ARRAY_SIZE(formats); i++) {

Looks like 'i = 1' should be...

> > +             if (formats[i].mbus_code == fmt->format.code) {
> > +                     fmt->format.code = mbus_code;
> > +                     break;
> > +             }
>
> This does not make sense. Loop will always exit during the first
> iteration, making the whole loop crazy/redundant.



-- 
With Best Regards,
Andy Shevchenko
