Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8AD3494F
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 15:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbfFDNrm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 09:47:42 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:37258 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727033AbfFDNrm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 09:47:42 -0400
Received: by mail-it1-f194.google.com with SMTP id s16so188896ita.2
        for <stable@vger.kernel.org>; Tue, 04 Jun 2019 06:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qOPJwziR6vb/zNze2ZuRlocRXRX6Om37EtqoiVNPT+I=;
        b=MldR8q1p4C4fZi4PwYD4WM2JrkXM5jmuyiXAlKvg8ZI3TZbSfozfF0QADFMmQw4woQ
         DEy5+FnfYpSCl6AUTYmmySZu4lXAZTsX54pHE7lDzbIceZQzs6JsWy24uhDe5Sehx3Mb
         lziOadmazSWURQF2EKsDCkyGU8/mhwWXx3qU+Y6etrIE+gIX7H/FFDIz9EB/+8r0ioBb
         Vtf2WAFdzM4w+0lhkuoczuZc+yY1XGHXYpj4ewkrYtvgn7C1pUy3jcfNgjlhTDAWxsn5
         LzdAcQT2reIfCduRWwflcPaFCqCIP39ekJFTLExtifu+pUzg1NKQXMyn7svwuyV8a7qQ
         fiqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qOPJwziR6vb/zNze2ZuRlocRXRX6Om37EtqoiVNPT+I=;
        b=f2lArsQTXzANf35VW/vlsKdaDXB7+Wk1OD/wW9J1ETHRvduJrzfug2XLn00F2VgI03
         KKC8OkY0WrH0VCtV1Mgcsa69YZcKp/0ajN/sdSWPK27LUCqdBWBPyS/fZXdBUapBllVO
         2OhTgs5m3gsv354QZvodGf0yYOT1FnabKO/BzwEZSEYyDSZY9w1RVa+GW4lpu82ZzO1g
         Hj6lItCV0ZUk6b8VNdQuzpDjWBFUCq4KsZ8TiVXJBYqlHcW3SWWttsIWFL3NXFeES4VM
         wecASgAyzIF2xh/DDZzYN7lQ8nn2uPMmCrA+X+sbSqDYCYuMsOh3RXTYGY4yjZZAzWv+
         9DqQ==
X-Gm-Message-State: APjAAAUY8mi/HJmZ+PtgRlXMeYbNUJySeKklGn8Q22bKwy+QFwBYxDX2
        9w7zi8fr/RQU9R86iDKCsYsg29UimHwYhQ6zEd129g==
X-Google-Smtp-Source: APXvYqy23cC9rjCjYMMiacWjwEDf2HyP5IpQxvvDCUtvc2/np011Wfxu0U3ef7DtfuTy9R8pSyVC6tuo72pDcQ54dKg=
X-Received: by 2002:a24:740f:: with SMTP id o15mr5768972itc.76.1559656061173;
 Tue, 04 Jun 2019 06:47:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190603223851.GA162395@google.com> <20190604123432.GA19996@kroah.com>
 <CAKv+Gu8a77xObE8UPhDZeqzXdm48vxHOqC4resfvRJLFPavgLQ@mail.gmail.com> <20190604134559.GA8083@kroah.com>
In-Reply-To: <20190604134559.GA8083@kroah.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 4 Jun 2019 15:47:27 +0200
Message-ID: <CAKv+Gu9u=E-a7ensvQB=ZkBfYJ9Qr2=Txi6rRP6YaqRgz-tfkA@mail.gmail.com>
Subject: Re: 4e78921ba4dd ("efi/x86/Add missing error handling to old_memmap
 1:1 mapping code")
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Zubin Mithra <zsm@chromium.org>, stable <stable@vger.kernel.org>,
        Guenter Roeck <groeck@chromium.org>,
        Gen Zhang <blackgod016574@gmail.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 4 Jun 2019 at 15:46, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Jun 04, 2019 at 03:39:15PM +0200, Ard Biesheuvel wrote:
> > On Tue, 4 Jun 2019 at 14:34, Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Mon, Jun 03, 2019 at 03:38:52PM -0700, Zubin Mithra wrote:
> > > > Hello,
> > > >
> > > > CVE-2019-12380 was fixed in the upstream linux kernel with the commit :-
> > > > * 4e78921ba4dd ("efi/x86/Add missing error handling to old_memmap 1:1 mapping code")
> > > >
> > > > Could the patch be applied in order to v4.19.y?
> > >
> > > Now queued up, thanks.
> > >
> >
> > Given the discussion leading up to this, I'm slightly surprised.
> >
> > As I alluded to in my questions to Zubin, I am concerned that the
> > testing carried out on this patch has too little coverage, given that
> > a) Chrome OS apparently does not boot in EFI mode
> > b) therefore, Chrome OS there does not use efi=old_map
> > c) Chrome OS hardware does not implement 5 level paging
> >
> > I have done all the testing I could before merging the patch, but I
> > would prefer to defer from backporting it until it hits a release. I
> > know some people argue that this still does not provide sufficient
> > coverage, but those are usually not the same people getting emails
> > when their EFI systems no longer boot without any output whatsoever
> > after upgrading from one stable kernel version to the next.
>
> Ok, I'll go drop it.  Can you please email stable@vger when it is in a
> release so that I know to queue it up then?
>

OK, thanks
