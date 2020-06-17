Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE711FCF64
	for <lists+stable@lfdr.de>; Wed, 17 Jun 2020 16:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgFQOVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 10:21:22 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:34336 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbgFQOVW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Jun 2020 10:21:22 -0400
Received: by mail-vs1-f65.google.com with SMTP id q2so1492092vsr.1;
        Wed, 17 Jun 2020 07:21:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ERGqcQ7t8WT4ifOpQtED2cQLgSQqRg45Jtc+jpL/R/s=;
        b=toAClvRvSBV0LPW/IdJ972hNRe3Kgela9tPIBMfcBd774zNapT/ua5FCA0vvI10bpP
         jRbPiosS9NW6WSx48r48b431a2g9hqOQUluFGCeCa1tGRfdA/4bYZgj6eygGvTXmhtFt
         pDSXmWH8GOhZtmafLy7K2cyQMqVCOzYFLiLcGBJnMtp5BIO28Mh8Ui3lIOyalYOpefB9
         td+jceWWuTLm1Ompc2ngrs+aYeBaohhxAVcFD5/QAUBgwv1UAkq90/b6VEEB55WSh9C3
         BKt82uDAwz/8oNKV5d80odkqjtkiBvQcEf9wcN9FLAGDGbAA48VzntJTIUwN30+xmFcj
         J+5w==
X-Gm-Message-State: AOAM530r41Dl7gaEL5PEpKT7IJvZXrs1CoHa37BBf12DGv1Mvi9+DFna
        OtlLunI/tcxGbnpRDUWAlNIf7B5jZcrlYydNkDo=
X-Google-Smtp-Source: ABdhPJxUB28eId7C069Z9yU5wnQSTxhlhjJBmlSA6lDeLgkW8xYFy5G701t2YSWHVSEGhHywz7FhjlBV+Vo9znzTuNM=
X-Received: by 2002:a67:e90e:: with SMTP id c14mr6182478vso.185.1592403680997;
 Wed, 17 Jun 2020 07:21:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200605162518.28099-1-florian.fainelli@broadcom.com>
 <6b1f0668-572e-ae52-27e6-c897bab4204c@gmail.com> <0c0ba84e-4b2d-53ac-5092-40312ecba13b@gmail.com>
In-Reply-To: <0c0ba84e-4b2d-53ac-5092-40312ecba13b@gmail.com>
From:   Michael Ira Krufky <mkrufky@linuxtv.org>
Date:   Wed, 17 Jun 2020 10:21:08 -0400
Message-ID: <CAOcJUbxfa8tQbHa8r=vyGoaJK0+N6v8puufu8vVJKZ4NdbpWKA@mail.gmail.com>
Subject: Re: [PATCH stable 4.9 00/21] Unbreak 32-bit DVB applications on
 64-bit kernels
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jaedon Shin <jaedon.shin@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        "open list:MEDIA INPUT INFRASTRUCTURE (V4L/DVB)" 
        <linux-media@vger.kernel.org>,
        "open list:FILESYSTEMS (VFS and infrastructure)" 
        <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Florian,

Thank you for the time and effort that you put into this patch series.
I was excited to see this, when I first saw it posted a few weeks ago.
I have every intention of giving it a review, but just haven't found
the time yet.  I'm sure that Mauro would say the same.

I'm sure that he and I both will find some time, hopefully over the
next few weeks or sooner, to give this a thorough review and provide
some feedback.

Hopefully we can put this on its way for merge soon.  Please bear with us..

Thanks again for your contribution.

-Mike Krufky

On Wed, Jun 17, 2020 at 12:39 AM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 6/11/2020 9:45 PM, Florian Fainelli wrote:
> >
> >
> > On 6/5/2020 9:24 AM, Florian Fainelli wrote:
> >> Hi all,
> >>
> >> This long patch series was motivated by backporting Jaedon's changes
> >> which add a proper ioctl compatibility layer for 32-bit applications
> >> running on 64-bit kernels. We have a number of Android TV-based products
> >> currently running on the 4.9 kernel and this was broken for them.
> >>
> >> Thanks to Robert McConnell for identifying and providing the patches in
> >> their initial format.
> >>
> >> In order for Jaedon's patches to apply cleanly a number of changes were
> >> applied to support those changes. If you deem the patch series too big
> >> please let me know.
> >
> > Mauro, can you review this? I would prefer not to maintain those patches
> > in our downstream 4.9 kernel as there are quite a few of them, and this
> > is likely beneficial to other people.
>
> Hello? Anybody here?
> --
> Florian
