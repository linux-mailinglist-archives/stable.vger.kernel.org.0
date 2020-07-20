Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA97225588
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 03:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbgGTBmQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jul 2020 21:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbgGTBmP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Jul 2020 21:42:15 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3DDDC0619D2;
        Sun, 19 Jul 2020 18:42:15 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id f23so15934747iof.6;
        Sun, 19 Jul 2020 18:42:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BghG0bhxWxmBh6VLuN4rW89/t/Sbp9UWEGt+blG5lpA=;
        b=mzeyWIfsjwH1IQyIIN4YJKNVI2eThHp+im81JcoQOIZ1moVEy+D/Y8K4rISLL6r9Go
         UK3hFVfT41JV9GqK3ZwLtQnPhfywXpgHKabxiADEfUQDQCMGRb2QjYkkdk1wo/8MXlI7
         QUybG41Drb6npsCuwg8uKVZGQ7zc89h7+MvwY39M2nKeR409auVs8rRSTVY82U3Po/Zp
         mywB+0atdCxzu7LEdbo03Qw8/EmpCqiZl0/HvpKqkBziqNSLAKzwZNjN/q57QOv8y0FP
         jqJOhFFTwQh5VTuxjg4n1KSOTKnd5VbA2Uw3T2PmqUk+x3Vqllge8MfaSA9XBsSDzio6
         nxJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BghG0bhxWxmBh6VLuN4rW89/t/Sbp9UWEGt+blG5lpA=;
        b=ZUzXA3JGq0vS8cKDi6RgrvaUmK2lU4j2ckdL7pVYIeFmpsiMt7ozvwQBlNJ3b0P9xz
         AvWb3YnaBGFcWJIhXiC3Akqguo44ENS3pWrOKamh1BG5e0liAsCsDVLL7cMNQg7rIuMq
         Ge8z2kpnHd4IWhqDwJ4uXryidVQlfPvQfPclPR0cWPyY7mK5saLSC0JpWz0RH/qQnyUG
         Jc0X1ibdD8DWD0ZeYJ3xr0JCp1Mvik3MTkRIJRFiUS2WBw7z4uE++rVZJYIvqpZV1IJU
         OA/h315wSFEYP9NrrwRke820Gkxv4CPpoElfhbg1ofmz8qNGeTxwGeCVfjakk7Njr9GR
         bLvQ==
X-Gm-Message-State: AOAM531L/DorN2flPfQRwTmVGISnfMo+2/zZ5FsLCfUgacCaaxkBaHpM
        G5BZESOdcm6bs6ajryixjMfeGPHK0dXfXE5UpDTZeZ5grlI=
X-Google-Smtp-Source: ABdhPJwjmlGa4NcywVbK4jNW6SEoxFdHHqdKUqEu0Tv0w1iyQfd566RIjz08dqDkFK5lpsAdNcDI9YKg66qYxJD8oNw=
X-Received: by 2002:a05:6638:61b:: with SMTP id g27mr23016894jar.123.1595209334713;
 Sun, 19 Jul 2020 18:42:14 -0700 (PDT)
MIME-Version: 1.0
References: <1594892369-28060-1-git-send-email-chenhc@lemote.com>
 <CAAhV-H4wdxtLCAFOJE6wgAZdg+U5mquSZjHmAL_qsDaGtENbFg@mail.gmail.com>
 <34928e81-3675-0309-b020-0cb4b402dc5c@flygoat.com> <20200719151322.GA301242@kroah.com>
In-Reply-To: <20200719151322.GA301242@kroah.com>
From:   Huacai Chen <chenhuacai@gmail.com>
Date:   Mon, 20 Jul 2020 09:42:03 +0800
Message-ID: <CAAhV-H6f0Ohx=jZL_VeC2oncW-UUMA85t5C+x84xC_NZs83jNA@mail.gmail.com>
Subject: Re: [PATCH -stable] MIPS: Fix build for LTS kernel caused by
 backporting lpj adjustment
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        "Stable # 4 . 4/4 . 9/4 . 14/4 . 19" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Greg,

On Sun, Jul 19, 2020 at 11:13 PM Greg KH <gregkh@linuxfoundation.org> wrote=
:
>
> On Sun, Jul 19, 2020 at 10:51:11PM +0800, Jiaxun Yang wrote:
> >
> > =E5=9C=A8 2020/7/19 =E4=B8=8A=E5=8D=8811:24, Huacai Chen =E5=86=99=E9=
=81=93:
> > > Hi, Serge,
> > >
> > > Could you please have a look at this patch?
> >
> >
> > + Gregkh
> >
> > This is urgent for next stable release, please take a look.
>
> Relax, it was only sent 3 days ago, we will get to this...
>
> Also, why was this not caught by any of the testing systems that we
> have?  That might be good to determine so we don't mess up again in the
> future.
I think that is because CPUFREQ is disabled by default on MIPS.

Huacai

>
> thanks,
>
> greg k-h
