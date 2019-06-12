Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99DF742676
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 14:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404447AbfFLMsz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 08:48:55 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39912 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409159AbfFLMsz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jun 2019 08:48:55 -0400
Received: by mail-wr1-f67.google.com with SMTP id x4so14122675wrt.6
        for <stable@vger.kernel.org>; Wed, 12 Jun 2019 05:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=xJU2/H18MN7+U2ogcBvPSPl5vHNLD0/uzihF5VFtkOQ=;
        b=G+BkaDrPTJM7MWQYuyi0VNLC6TFlQgNcPrfD3qNg2RCgYPiSTYm+TsrvO8IcjEYlKo
         dnygx899pv2ZaOqveDfJYHUmA7eYEIBK60XPt2A9t5qnUrnZDV4kXbtDHXY65EqyxVcQ
         cpPyxiUCsGjqlNAIh0o9YQL56BMg86ejDOvAtPMm+OqbuCpB1Squ1NwTr8bqXwTm1Wxy
         aj1BIbS9nk4r69fCp/HYGN+4FqaZ4oc8b/Y4JqFpa4S+UHNuSYwp1UNXu1JDux1/jyem
         +lrj7XKiTReL0VuzYvsWFz8E+n1EVaBcUjapBQ7I3vFcxGeYP4i2lE8H4igPtG5zIKT5
         nkeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=xJU2/H18MN7+U2ogcBvPSPl5vHNLD0/uzihF5VFtkOQ=;
        b=uhBAhk3iLm/YLHwpLg0/SqD+fqVvUF9WKfgV9sK7HZ2Cf25NYMnYAs2+oZTjT8yrMP
         Td7BRdcTEB8jktA2QnnHXQjiKbUYw+bRDQE7kaOVRHlq+ZNpVmaMVjlStKs79clGXOGA
         zxmPLJT6DrMlV2s12YcKt2M424mRzzXZmE4SjPMjAv7XidNJPlI9Un/fNd2D0xzsahTz
         WdiRygeF/Oova0eWEuY8xPJ/7WrtBMWcRJAbnVt6BsazuTEQ9NGt4i0/KnKIP1f9BDD8
         0RugBCxjCDoIjQmeQafDu2t2VHEiJw7OYv8F+zi20mnZaJgJnH1FjE9jhOkddEq82cx6
         MDSg==
X-Gm-Message-State: APjAAAWr5PiH+zADO/SHkifi7bEeABxN4A3svSTLS+bKr1Px0le47Bz3
        2wmGDDCxDu9qyU1j04pUwjitnv7zUR+b8RUgAQ0=
X-Google-Smtp-Source: APXvYqzqHgaQRZQ/3jfM6Ga9BsEMnAlgJQ7E+sgHmNx4Lq74djQw0Du826+QkQbQDt06utUMoMtKR+HVcthzgmEKdCk=
X-Received: by 2002:adf:efc8:: with SMTP id i8mr27183597wrp.220.1560343733387;
 Wed, 12 Jun 2019 05:48:53 -0700 (PDT)
MIME-Version: 1.0
References: <CA+icZUXaXhvm46tA2aHO=85Lv16Y4=DOnz7OBRyfztp=i0_a5Q@mail.gmail.com>
 <20190612101519.GM26148@MiWiFi-R3L-srv>
In-Reply-To: <20190612101519.GM26148@MiWiFi-R3L-srv>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Wed, 12 Jun 2019 14:48:42 +0200
Message-ID: <CA+icZUV78MPyLRie4MWa0PZ-UObpG33gmZhFfHD1rFsTqV7vnw@mail.gmail.com>
Subject: Re: [v5] x86/mm/KASLR: Fix the size of vmemmap section
To:     Baoquan He <bhe@redhat.com>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 12, 2019 at 12:15 PM Baoquan He <bhe@redhat.com> wrote:
>
> On 06/04/19 at 01:46pm, Sedat Dilek wrote:
> > [ CC me I am not subscribed to linux-stable ML ]
> > [ CC Greg and Sasha ]
> >
> > Hi Baoquan,
> >
> > that should be s/Fiexes/Fixes for the "Fixes tag".
> >
> > OLD: Fiexes: eedb92abb9bb ("x86/mm: Make virtual memory layout dynamic
> > for CONFIG_X86_5LEVEL=y")
> > NEW: Fixes: eedb92abb9bb ("x86/mm: Make virtual memory layout dynamic
> > for CONFIG_X86_5LEVEL=y")
> >
> > Also, you can add...
> >
> > Cc: stable@vger.kernel.org # v4.19+
> >
> > ...to catch the below.
> >
> > [ QUOTE ]
> > You can see that it was added in kernel 4.17-rc1, as above. Can we just
> > apply this patch to stable trees after 4.17?
>
> Oops, I just noticed this mail today, sorry.
>
> Boris has picked it into tip/x86/urgent. It should be in linus's tree
> very soon. Appreciate your help anyway.
>

I have applied the patch set from [0] and booted into the new kernel.

But I have set...

CONFIG_PGTABLE_LEVELS=4
# CONFIG_X86_5LEVEL is not set

To test this I need CONFIG_X86_5LEVEL=y?
Best two kernels with and without your patch.

- Sedat -

[0] https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/commit/?h=x86/urgent&id=00e5a2bbcc31d5fea853f8daeba0f06c1c88c3ff
[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/x86/x86_64/5level-paging.rst

> Thanks
> Baoquan
>
> >
> > >
> > > v5.1.4: Build OK!
> > > v5.0.18: Build OK!
> > > v4.19.45: Build OK!
> > [ /QUOTE ]
> >
> > I had an early patchset of you tested (which included this one IIRC),
> > so feel free to add my...
> >
> >    Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
> >
> > Hope this lands in tip or linux-stable Git.
> >
> > Thanks.
> >
> > Regards,
> > - Sedat -
> >
> > [1] https://lore.kernel.org/patchwork/patch/1077557/
