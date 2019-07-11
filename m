Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17D5D65FBC
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 20:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728830AbfGKStZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 14:49:25 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:40419 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbfGKStZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jul 2019 14:49:25 -0400
Received: by mail-io1-f65.google.com with SMTP id h6so14807611iom.7
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 11:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0wLNsD38TP2UA0YsU5XmnZ/H9Kw2sBDy90TLeo5o6+A=;
        b=ieaJmWkfnijk0HbcEBUGekjnj3eklJMAe/+TqhxcGi/utUp3ctFpu6Eku9nnn7R0HW
         0nMz26sXk+xBRLdmSqcmwQUWkSkR2NiHwC5XJQZy8hg1rAphOPk8URzB/0aMLSC8na6m
         q0xWn6zGZdB5sNrIdq2XlLv2wgXC9t2ZhFOfg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0wLNsD38TP2UA0YsU5XmnZ/H9Kw2sBDy90TLeo5o6+A=;
        b=CmdpJUvn+8ePcpmydxbDewDmPyTA1rZ/3cdJAdFJMN0oFKY1YrjAJpIudU69afxfVO
         8F5y6ALZieU+olJN5IxeQGCb7svqnAu0MdpZ13gKho8RgxALHTx5+gaha6wqzUE53E9C
         NOW8ZtmK+sVzBWvYelVXoz3Bowp1N9t/sdemJoplnPrekUQIuZhrxyqzzSKwoO08Xj2m
         ecrMY0gEkX6uTlIB0qdN9RdOLXt7i7oVQIuKm+ztaFi2ojITBSisDwXmFpHPSLEN5mnb
         PRuzTd70XhVE7GVE7ORkJufGlqANTq/ncs44h/yixi3Z8pY+gcgsKU38IdTmYhSrqGa6
         T2IA==
X-Gm-Message-State: APjAAAWCuP1IURYfRP6p68adwtkBu1izUgsXU6S/m0gofkiPPRR361r4
        EVIarC7sFbJVN6cG/l2xwddCcalhdr8=
X-Google-Smtp-Source: APXvYqxwCiGwRTU34q66qHyj7EbFlUcxIJCXwHoqS7T8g1gu4N9BEtu0phxGBCpnnhcMFHe1AP5gfg==
X-Received: by 2002:a6b:730f:: with SMTP id e15mr5919626ioh.74.1562870964045;
        Thu, 11 Jul 2019 11:49:24 -0700 (PDT)
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com. [209.85.166.51])
        by smtp.gmail.com with ESMTPSA id k26sm4974346ios.38.2019.07.11.11.49.23
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 11:49:23 -0700 (PDT)
Received: by mail-io1-f51.google.com with SMTP id h6so14807468iom.7
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 11:49:23 -0700 (PDT)
X-Received: by 2002:a5e:c241:: with SMTP id w1mr5666625iop.58.1562870962763;
 Thu, 11 Jul 2019 11:49:22 -0700 (PDT)
MIME-Version: 1.0
References: <1562844916142167@kroah.com> <CAD=FV=XEE1J6Kx28eV_zi8_oV68qQsmKW8Os2A3_ade1KsBFdg@mail.gmail.com>
 <20190711181723.ys6g4atsb7sxpzs4@linux.intel.com>
In-Reply-To: <20190711181723.ys6g4atsb7sxpzs4@linux.intel.com>
From:   Doug Anderson <dianders@chromium.org>
Date:   Thu, 11 Jul 2019 11:49:10 -0700
X-Gmail-Original-Message-ID: <CAD=FV=UCqRpSsMpastf8K9nZukST6h8qjn2ofAQsJU00EyW5EA@mail.gmail.com>
Message-ID: <CAD=FV=UCqRpSsMpastf8K9nZukST6h8qjn2ofAQsJU00EyW5EA@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] tpm: Fix TPM 1.2 Shutdown sequence to
 prevent future TPM" failed to apply to 4.19-stable tree
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vadim Sukhomlinov <sukhomlinov@google.com>,
        "# 4.0+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Thu, Jul 11, 2019 at 11:17 AM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> On Thu, Jul 11, 2019 at 09:30:25AM -0700, Doug Anderson wrote:
> > Hi,
> >
> > On Thu, Jul 11, 2019 at 4:35 AM <gregkh@linuxfoundation.org> wrote:
> > >
> > >
> > > The patch below does not apply to the 4.19-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> > >
> > > thanks,
> > >
> > > greg k-h
> > >
> > > ------------------ original commit in Linus's tree ------------------
> > >
> > > From db4d8cb9c9f2af71c4d087817160d866ed572cc9 Mon Sep 17 00:00:00 2001
> > > From: Vadim Sukhomlinov <sukhomlinov@google.com>
> > > Date: Mon, 10 Jun 2019 15:01:18 -0700
> > > Subject: [PATCH] tpm: Fix TPM 1.2 Shutdown sequence to prevent future TPM
> > >  operations
> >
> > Posted at:
> >
> > https://lkml.kernel.org/r/20190711162919.23813-1-dianders@chromium.org
>
> Thank you! I usually end up taking care of these myself :-) A rare
> occasion. Does this also address 4.4, 4.9 and 4.14 or do they still
> need backports of their own?

In Chrome OS we have the same solution for 4.14.

This patch will _definitely_ not apply cleanly for 4.4.  Not sure what
the best course of action is there, but in the "after the cut" notes
in my post I talk about it a little bit.

On 4.9 things look similar-ish, but I don't know quite enough to know
if it will work well there.

(all of this in the context that apparently some extra locking patches
even for 4.14 and 4.19--see the thread in response to my posted
patch).


-Doug
