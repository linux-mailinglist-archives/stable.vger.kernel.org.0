Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96ADA427D9
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 15:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408598AbfFLNl7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 09:41:59 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38229 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408476AbfFLNl6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jun 2019 09:41:58 -0400
Received: by mail-wr1-f68.google.com with SMTP id d18so16962909wrs.5
        for <stable@vger.kernel.org>; Wed, 12 Jun 2019 06:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=NYybLtq9m6yUgkNdbGZJ5+yrh+mLC51AZVXepgcsKKM=;
        b=nl8+JLo0WqM06iOKpvxn4irZjrHjATdIhZmFrCX57aBzLcUdJ0pR239n9HgaS7THbH
         Y+FR6L5fGkWg0vLDH58eXQc2SBUGhK/BWUvTFRryo6dv3F5/tWCW23iuLDxVpsYKrjGg
         cvQHOEjpFLgVdPmA3RS0o8tQy7BUuIym8n3dVJp2ucUxt3qjbHOJVjk0BEYSTqMqRsc9
         tN9tnwOWm7kxedLGemI21rw47/R1A+PydE9vS1fm774WLI6lgNCyKmoTJgs2yGcUK4P8
         gFx97CWIoGBCK29rp/52pTjAgQvoITOJO9nBR51AcCm9etekQypZCTcIwbPSZn1Jr4pQ
         dl4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=NYybLtq9m6yUgkNdbGZJ5+yrh+mLC51AZVXepgcsKKM=;
        b=dYCZoZ6X0fY0vvci/yCgOT35RsiWQOOjnZzmVf5DDYgaQsdmxqHfrRpc0YdVIlAZV6
         J8y5qYyvupZn8Z95nvcF/O+5aP65oxnxrsaF3Dfa/8wxfIGJd+EoP9uB8U03xy6mNWdW
         p4jnHSvo1uUSuoYSTpLPM6UyAcNbkxyYc547GC33jxOkuAME3R0DtIbQO0WNp4fG3DWP
         VbTFp4sE2lxyHIC+3i4Uro8y35RHY8x1fiHnDQBoYp94NVgUsFi708RlW6oZuRWq9JkL
         qHoWn8tAUC6u1577tOzwOsgk8bbhrPnAEL/Ilr1+nw9lRf+X1Aef+/c2qaquSuTNpKzB
         N2Ug==
X-Gm-Message-State: APjAAAW91WmkpUJ+jB0yRBno3tDiTCw4N+izX/eMUqjWA5UCipGTrgeN
        YaUMDVFoNTbndET62TF90QmvqNFzVDoxvHpSTdOCLci5
X-Google-Smtp-Source: APXvYqxrjX0Ikkz8FzlEI6M9ADnfxZASQs5qzH6W3P5+xhrtcW+kHZ4Ul4U9D4OktfYQ714DXYxMglgNBajn4wLGlBk=
X-Received: by 2002:adf:e9cc:: with SMTP id l12mr7583376wrn.29.1560346916449;
 Wed, 12 Jun 2019 06:41:56 -0700 (PDT)
MIME-Version: 1.0
References: <CA+icZUXaXhvm46tA2aHO=85Lv16Y4=DOnz7OBRyfztp=i0_a5Q@mail.gmail.com>
 <20190612101519.GM26148@MiWiFi-R3L-srv> <CA+icZUV78MPyLRie4MWa0PZ-UObpG33gmZhFfHD1rFsTqV7vnw@mail.gmail.com>
 <20190612131922.GO26148@MiWiFi-R3L-srv> <20190612132306.GA28802@MiWiFi-R3L-srv>
In-Reply-To: <20190612132306.GA28802@MiWiFi-R3L-srv>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Wed, 12 Jun 2019 15:41:45 +0200
Message-ID: <CA+icZUVjj=9uj77aUwJsO9haRNWWGe4xKYdyJUOscT=Dq8Y-Hw@mail.gmail.com>
Subject: Re: [v5] x86/mm/KASLR: Fix the size of vmemmap section
To:     Baoquan He <bhe@redhat.com>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 12, 2019 at 3:23 PM Baoquan He <bhe@redhat.com> wrote:
[...]
> > > I have applied the patch set from [0] and booted into the new kernel.
> > >
> > > But I have set...
> > >
> > > CONFIG_PGTABLE_LEVELS=4
> > > # CONFIG_X86_5LEVEL is not set
> > >
> > > To test this I need CONFIG_X86_5LEVEL=y?
> > > Best two kernels with and without your patch.
> >
> > Yeah, with CONFIG_X86_5LEVEL=y.
> >
> > In fact I didn't have chance to trigger the issue to reproduce, then
> > apply this patch to fix. As you know, the machine with large memory is
> > too few. This is a code bug, so I just run the level 4 kernel and level
> > 5 kernel to test the basic functionality.
> >
> > If you have machine owning RAM 64 TB, and it supports 5-level, you can
>                              ~~~~
>                             Here, I meant owning RAM larger than 64 TB
>
> > build two kernels w and w/o this patch, it's easy to reproduce.
> >

Hi Baoquan,

No, I have no 64-TB-machine here.

I have seen that the Kconfig help text [0] says...

 See Documentation/x86/x86_64/5level-paging.txt for more
 information.

That should be s/5level-paging.txt/5level-paging.rst.
I can send a patch if you like.

Can you look at the text of [1] - are the informations up2date?

Thanks.

Regards,
- Sedat -





[0] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/Kconfig#n1481
[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/x86/x86_64/5level-paging.rst

> > >
> > > - Sedat -
> > >
> > > [0] https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/commit/?h=x86/urgent&id=00e5a2bbcc31d5fea853f8daeba0f06c1c88c3ff
> > > [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/x86/x86_64/5level-paging.rst
