Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2692C8061E
	for <lists+stable@lfdr.de>; Sat,  3 Aug 2019 14:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390195AbfHCMKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Aug 2019 08:10:17 -0400
Received: from mail-io1-f42.google.com ([209.85.166.42]:34037 "EHLO
        mail-io1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390177AbfHCMKR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Aug 2019 08:10:17 -0400
Received: by mail-io1-f42.google.com with SMTP id k8so158180942iot.1;
        Sat, 03 Aug 2019 05:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QARTcEnNJYcFTjS0NGtQDsvVOH1su8yHM5Z2Ufcp+Io=;
        b=t39hGgavqtWu1L0frrz8UHIt66nyXefLbphJySZ+WieN5SwIkpmOopr7MHbEqsi+i7
         HXd6nSG5bQGzOZeT+CMRKh4stUW7Cy/iyrcXrwcDpUtlAoTVgvTzJcunngkbDQuCbtS7
         TL/uvy8OPNGv34ip7lqwCEu+H+PjYgCBmwnq/BsExUboIMsf2a4KRJQDg/n9IVKhJopX
         2RfnFAQRYo5cQtz7mejXVbNmPDiGL7+mWVx9ZqUrREnmH3bXnxVVY2GsDgoh8dARI7GA
         hVRcQMLvUK7VW/uXQIHz3VYhAcfUhdnaUMtCs83Cd+U0fJmLXzP3fKBbXfZ7KxIeAue7
         KUTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QARTcEnNJYcFTjS0NGtQDsvVOH1su8yHM5Z2Ufcp+Io=;
        b=U3gHg15+Cd7weedL9PgNn2tcvhsGDuTZvjSh32Y5mvLAnVqavw+Iykz2Rr87TP7IZk
         TbzhzuHwBpyimpuEq8RznJKWJFwQc4w5tanNnKNDHXMggVKGtr8K+AmNoEi2UsyhFNtM
         urV+u6aS9lMRyqrcttETtSJ1TY66vjbwHugM2MGcUijMxfNS8viI5WJW3R5iymK//XG6
         A5B0QPmUlwgsyJDUsJuhPUlpajGgSf+PLr1Q4iiEhwqVa6IMSOYT838fS+ouDb3ONhec
         ko1/m+3otEOrXvBChi5c19HmndKArXKPkSTllaJSCkUZy99e5IdSUiyBtQDt+ojDOQi5
         dP/g==
X-Gm-Message-State: APjAAAUCtXwBcnBJ08kY/b6mE+p24eMEBxGlf9l30yyQfXsP9E8yWsYO
        hhnuaiLda2fdEV6WiZ5FwlxeLKRRe/+GBb6nNLxacQ==
X-Google-Smtp-Source: APXvYqw+BfUwY07/j6HUmYJJYexUX6t94l/YCLf2O2kUY1ZYMe4GsmuUL/1vbB093RMyQj39TR8AIVg27GUVHHnO+2c=
X-Received: by 2002:a02:3f1d:: with SMTP id d29mr151417323jaa.116.1564834215948;
 Sat, 03 Aug 2019 05:10:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190802132302.13537-1-sashal@kernel.org> <20190802132302.13537-6-sashal@kernel.org>
 <CAJ1xhMWb6OG0xdBtAQZkX-T0XNmMNaMaS=ScJ4ZRwpv9eHXmCQ@mail.gmail.com> <20190803073744.39412f73@coco.lan>
In-Reply-To: <20190803073744.39412f73@coco.lan>
From:   Alexander Kapshuk <alexander.kapshuk@gmail.com>
Date:   Sat, 3 Aug 2019 15:09:38 +0300
Message-ID: <CAJ1xhMV5ub60DSZkHOqE=oKKtBUtGYA6QQxMN-R-79LGr12pQg@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.19 06/42] scripts/sphinx-pre-install: fix script
 for RHEL/CentOS
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "# 3.9+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 3, 2019 at 1:37 PM Mauro Carvalho Chehab
<mchehab+samsung@kernel.org> wrote:
>
> Em Sat, 3 Aug 2019 13:31:30 +0300
> Alexander Kapshuk <alexander.kapshuk@gmail.com> escreveu:
>
> > > -       if (! $system_release =~ /Fedora/) {
> > > +       if (!($system_release =~ /Fedora/)) {
> > >                 $map{"virtualenv"} = "python-virtualenv";
> > >         }
> >
> > The negated binding operator '!~' could be used here as well, and it
> > does not require the use of extra parenthesis.
> > Just a thought.
>
> Thanks for the tip! Never used such operator. Will start using
> next time we need to handle a pattern like that.
>
> Thanks,
> Mauro

No worries at all.
