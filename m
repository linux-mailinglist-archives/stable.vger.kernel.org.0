Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48EE9F4D2B
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 14:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbfKHN3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 08:29:35 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40908 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbfKHN3f (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Nov 2019 08:29:35 -0500
Received: by mail-wr1-f67.google.com with SMTP id i10so7057609wrs.7
        for <stable@vger.kernel.org>; Fri, 08 Nov 2019 05:29:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s/yCUpNC7XfUqw3qRnXOOPQdfMSEXjROzZKokUlrT+4=;
        b=kQxhd6WYx4zSJ34MVdg6iu3jSnvVhqp+/NWK6UAQvh29We+u3EWGKX34Tj8fLT2GsS
         kiawqEJJtufPUT9mPd0qx1yCi6OulmnQzluuYQiOkhLMu4JUi9/Ki0vJTwgtq5N6L4id
         /IO8OL/RUiFd4oSBHvDu4+DQtoTMVJmBOKB/2hgOBDFKu21fmJK9vahHZqS7rECsZtgv
         KCwsMoPR2B6+110VX1ClgNXP5/Pa4wVGpRAsU5EcALwhWtheqKXIpWoDoUn8w2Bl6vvy
         2710ACs0Cb3CJts579X0nwSiSPETCe9G/A3tkQUwoilX8MxjfgMdgkSZKy4vIymRbj24
         Zr1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s/yCUpNC7XfUqw3qRnXOOPQdfMSEXjROzZKokUlrT+4=;
        b=JBPL0yXramkB/IU6NYfCJG8PbjeQ7iyYhNNAtYHy0hQ/uT3QcqqfLwTwJXqF5VzYLW
         LZA20q53kTk8kezvC+YHaXlvIpwL654kOwQ62BRh3xjhtpDVTYxnhIFAgc3Q69rQ9WUU
         bf7O4IzeKFAGz+wfsXdYO2Mp3ZrgJbZ/K+esX4JInYFgcpDUqfLdKKPWCFqBnrU1OUkp
         Ye1wpTmMjXVGOAnDgxlToAfXkI0hw203PYC3izyBeVg8FsyTZS7+8VZN0PlJx+ieyMx4
         rqW6wafL+O80WQ5oPSp9yQOucVO3gotbGAoilqJ+hHNmbIiePUho2YsaxIRqhCa1wO4P
         6G/w==
X-Gm-Message-State: APjAAAUICeEni1wsMoDP2AwCnhyQkMeKN5prhy9wau1+XqO02Y2P5K9v
        9S1LhhhGvY+TYeEdRLwWOIpR7m4lX47aIxNlEA2ycw==
X-Google-Smtp-Source: APXvYqzsdygW5AygGk/js0Y+Ac9hOdYUtZWBOn4vF+aoz6aDsYIRQnoaZ2mx3uRca8EavbgeKNoO98RnuPUC8ulpg+k=
X-Received: by 2002:adf:ec42:: with SMTP id w2mr8014445wrn.32.1573219773069;
 Fri, 08 Nov 2019 05:29:33 -0800 (PST)
MIME-Version: 1.0
References: <20191108123554.29004-1-ardb@kernel.org> <20191108123554.29004-9-ardb@kernel.org>
 <20191108131105.GA759061@kroah.com>
In-Reply-To: <20191108131105.GA759061@kroah.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 8 Nov 2019 14:29:21 +0100
Message-ID: <CAKv+Gu819gSLLtOOMDVwoO6UmGgy=ng8SLMzOY_UJeZMM9=sOw@mail.gmail.com>
Subject: Re: [PATCH for-stable-4.4 08/50] arm/arm64: KVM: Advertise SMCCC v1.1
To:     Greg KH <greg@kroah.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>, stable <stable@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 8 Nov 2019 at 14:11, Greg KH <greg@kroah.com> wrote:
>
> On Fri, Nov 08, 2019 at 01:35:12PM +0100, Ard Biesheuvel wrote:
> > From: Mark Rutland <mark.rutland@arm.com>
> >
> > From: Marc Zyngier <marc.zyngier@arm.com>
>
> Lots of Mar[c/k]'s :)
>
> I'll fix this up...
>

This is eactly how it appears in v4.9, so I just left it. Same for the
double 'upstream commit' that you responded to.
