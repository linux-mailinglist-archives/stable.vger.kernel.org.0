Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE6BF96BA1
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 23:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730786AbfHTVl1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 17:41:27 -0400
Received: from mail-pg1-f173.google.com ([209.85.215.173]:38122 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728283AbfHTVl1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 17:41:27 -0400
Received: by mail-pg1-f173.google.com with SMTP id e11so55699pga.5
        for <stable@vger.kernel.org>; Tue, 20 Aug 2019 14:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EQMxWkwdOfhu82/kOEFtbsA1mXaWECboj5bkdLJ8g68=;
        b=dzls+Zqvq0BMHkB78Zp0MSbDclVqzUSxx+8J1sl7qg+rXZnLb3nvMB8VHSZbXTHwsL
         rvIYOdPUyqPbFgPZsjgONHtw0PhyQ3cQpDbAZPfnvkfaEFCLp4x6q62BVqrg5WUcKs11
         NCc8xhlACAajL3dnI1AcyJrakxy9mBMwmIj9YrCKhxBHvLXknuyrjii72Jp19vB0jP43
         thrwmkLBNhWjUgqZ6Yp8ChntaFgymFscoeM070d8/U0/ByB/qzs24cL5KrhP/7lo89Xr
         zuYzTHwi8aOrek0KNPHKt5UGTDZqZGLYPd25tDcwp58yh+xwZcSyQGBhWCJW7V1SLndI
         4V4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EQMxWkwdOfhu82/kOEFtbsA1mXaWECboj5bkdLJ8g68=;
        b=Dt50bbyEbvSfmbaQg0dXJjw0OwqgLOWXB7Il0ZghVtXAyIjMygWcuUOXSslsK3Kv1c
         Zuq4AVQDpI7x/CFFisS61Wafp+4S39oiRmC9ntHvQsm64GwROBqexyXP5F4qunKPNS/H
         RyGC35RCC1BvGY13xUBkU5J4R/aChfjgay2SkRa0v+W5aRi2frpi6kQhUJZpxJXdrNkX
         t1/hSO+nVkVfU2dejmEoPrJxtC2rgU/zgvgwhYU6YP/AOxcYnRzM/QJnjeEduB4oG4sY
         JkLW1bO5QFme0LnFGCj2tGJTeVfSNPcrXfhdRb6o1Lrl6COzUPAQ899WAYY4gVAzBzNv
         Tn/A==
X-Gm-Message-State: APjAAAVrEh+ITBb9UyRX7rqxNeJ0QCJTsBWyXCpDc3dnZaS99q+jnP5e
        NYdnq8ZnGphV/z97yM8UWz6k/lsVmBpla6bQh4iLOQ==
X-Google-Smtp-Source: APXvYqzEawngvRK5CJm/UhXc0Dwm0NVhRF7hu/3626lrum+4ID6oqAqaSj0niW2jTxZjDaZ+LGQfToxEBP3dDuPhlDQ=
X-Received: by 2002:a63:61cd:: with SMTP id v196mr26924436pgb.263.1566337286095;
 Tue, 20 Aug 2019 14:41:26 -0700 (PDT)
MIME-Version: 1.0
References: <CAKwvOdm0sWCF=PiNJvKWxt7CaTXSF13cZNuYPhKC=Kq8ooi1HA@mail.gmail.com>
 <20190820210716.GA31292@kroah.com> <20190820212539.GA1581@sasha-vm> <20190820213524.GA25049@kroah.com>
In-Reply-To: <20190820213524.GA25049@kroah.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 20 Aug 2019 14:41:15 -0700
Message-ID: <CAKwvOdkp8aV9VeJhd5oxshJLTmrB3i9juea4CMo5K8o9CadOfw@mail.gmail.com>
Subject: Re: Please apply commit 0f0727d971f6 ("drm/amd/display: readd -msse2
 to prevent Clang from emitting libcalls to undefined SW FP routines") to 4.19.y
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 20, 2019 at 2:35 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Aug 20, 2019 at 05:25:39PM -0400, Sasha Levin wrote:
> > On Tue, Aug 20, 2019 at 02:07:16PM -0700, Greg KH wrote:
> > > On Tue, Aug 20, 2019 at 02:00:21PM -0700, Nick Desaulniers wrote:
> > > > Please apply commit 0f0727d971f6 ("drm/amd/display: readd -msse2 to
> > > > prevent Clang from emitting libcalls to undefined SW FP routines") to
> > > > 4.19.y.
> > > >
> > > > It will help with AMD based chromebooks for ChromeOS.
> > >
> > > That commit id is not in Linus's tree, are you sure you got it correct?
> >
> > That's a linux-next commit.
>
> Great, we can wait for it to show up in Linus's tree first :)

*checks tree*
Oh yeah, oops.  Sorry for the noise.

-- 
Thanks,
~Nick Desaulniers
