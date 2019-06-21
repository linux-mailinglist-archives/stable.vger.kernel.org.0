Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC3024F0F1
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 01:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbfFUXBa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jun 2019 19:01:30 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34735 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbfFUXBa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jun 2019 19:01:30 -0400
Received: by mail-wr1-f65.google.com with SMTP id k11so8026829wrl.1
        for <stable@vger.kernel.org>; Fri, 21 Jun 2019 16:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rMxNdlrMg84rkQr6zo6jasaNwFj5mUMNrw7TWZnqyAU=;
        b=cVMdgt7VhIm8cHp3KsqIv5v2jOFO7Eg4xBmuM1PjP/Jr8UnF1lp5N5JZbFmG9e3jSn
         mirn81TDFC213O7R07cR8nmI73RYmmnbl2yXbTUBHcS1gc+fx8ISo2Bn9CvO2NWvMbQ6
         h3kanrulW/XsYVwDiAIum5mmUSzMP/PB6sJiHYTrxHzpoEJ71t/0n7sO/KRkBLHtDBZe
         bJ0AuzJpHaDz8wCBQIOnqPwnpd6aMrQDGQ0D+omAJ+54rA1RfmVW6EXJAEW0yTV7W6xH
         uWt2VvUHcj/+mkmtFkDFOsuQGZ+z4na/Bgf4K0ZKKNYZrG9gofdvHagVkJZDhlBynEqq
         oqaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rMxNdlrMg84rkQr6zo6jasaNwFj5mUMNrw7TWZnqyAU=;
        b=c+zPGZp2QH+3VeG07S8d+/MyT9jqaO6vlkAYuTTGG3F2UQ9e0swDyBZj65u5xmvB76
         gfbQdQDSj5T3pQtDmMi8nlfuRpakUWtYcJd1h1S4Sz8emXMmDz7Tsk/pXPpHbvp7COnP
         Z7BwUBA0rVlBx3Y238oI6KYUKZJtuQJQJ+ea1byxuSuoUjKsKoLV/Z3psVtwsepo9rFP
         yu3Evj+yw53LC8pwNSPHLIOhsjxizxP3aD27WHjUSxV2jC15LXbMF/MmU/aIjVxp9xGp
         8K2fsIyG7cNKya9CqaUe+rmRfqoAaHJjuk+8LwMi6BTSd+HQ4t+LSVoct3gltG4caS2Y
         ZKpA==
X-Gm-Message-State: APjAAAXPrwIc+hU/5rHq2y+qvlryIbsHKCoBSZEPqKv1XKXrXOXwsAfK
        5g9NPTJ5Lf784G/r2crqs2CEYQX1SZXF72Z05UABDw==
X-Google-Smtp-Source: APXvYqzZipNQLnANPtITaEbeyZai7MpGZ5uGprF0WC1e0QBFL8krAkSGxcc0CNQF4oJDRSL17uAJz+/q71Thv2JeK+0=
X-Received: by 2002:a5d:4703:: with SMTP id y3mr39814927wrq.35.1561158087344;
 Fri, 21 Jun 2019 16:01:27 -0700 (PDT)
MIME-Version: 1.0
References: <1204558561.21265703.1558449611621.JavaMail.zimbra@redhat.com>
 <1667759567.21267950.1558450452057.JavaMail.zimbra@redhat.com>
 <20190605204659.npyf7wnmsdlr2bff@xps.therub.org> <CAKocOONHHuL2xSBUQx0=pw5AHMG4im=9kv3GrJLrKaH6+wguDw@mail.gmail.com>
 <CACT4Y+YFHZhm0pwoZdXSXtG4z1wHPOC9hG-RvRy=3szteEe6XA@mail.gmail.com>
In-Reply-To: <CACT4Y+YFHZhm0pwoZdXSXtG4z1wHPOC9hG-RvRy=3szteEe6XA@mail.gmail.com>
From:   Shuah Khan <shuahkhan@gmail.com>
Date:   Fri, 21 Jun 2019 17:01:16 -0600
Message-ID: <CAKocOON_dFX0DizJU9F6ZPj1vrXapy-R36uGZSo2ytxYknqbUA@mail.gmail.com>
Subject: Re: CKI hackfest @Plumbers invite
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Veronika Kabatova <vkabatov@redhat.com>,
        automated-testing@yoctoproject.org, info@kernelci.org,
        Tim Bird <Tim.Bird@sony.com>, khilamn@baylibre.org,
        syzkaller <syzkaller@googlegroups.com>, lkp@lists.01.org,
        stable <stable@vger.kernel.org>,
        Laura Abbott <labbott@redhat.com>,
        Eliska Slobodova <eslobodo@redhat.com>,
        CKI Project <cki-project@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 7, 2019 at 10:28 AM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Thu, Jun 6, 2019 at 12:00 AM Shuah Khan <shuahkhan@gmail.com> wrote:
> >
> > Hi Veronika,
> >
> > On Wed, Jun 5, 2019 at 2:47 PM Dan Rue <dan.rue@linaro.org> wrote:
> > >
> > > On Tue, May 21, 2019 at 10:54:12AM -0400, Veronika Kabatova wrote:
> > > > Hi,
> > > >
> > > > as some of you have heard, CKI Project is planning hackfest CI meetings after
> > > > Plumbers conference this year (Sept. 12-13). We would like to invite everyone
> > > > who has interest in CI for kernel to come and join us.
> > > >
> > > > The early agenda with summary is at the end of the email. If you think there's
> > > > something important missing let us know! Also let us know in case you'd want to
> > > > lead any of the sessions, we'd be happy to delegate out some work :)
> > > >
> > > >
> > > > Please send us an email as soon as you decide to come and feel free to invite
> > > > other people who should be present. We are not planning to cap the attendance
> > > > right now but need to solve the logistics based on the interest. The event is
> > > > free to attend, no additional registration except letting us know is needed.
> > > >
> >
> > I am going be there and plan to attend.
> >
> > > > Feel free to contact us if you have any questions,
> > > > Veronika
> > > > CKI Project
> > >
> > > Hi Veronika! Thanks for organizing this. I plan to attend, and I'm happy
> > > to help out.
> > >
> > > With regard to the agenda, I've been following the '[Ksummit-discuss]
> > > [MAINTAINERS SUMMIT] Squashing bugs!'[1] thread with interest, as it
> > > relates especially to 'Getting results to developers/maintainers'. This,
> > > along with result aggregation, are important areas to focus.
> > >
> > >
> > > [1] https://lists.linuxfoundation.org/pipermail/ksummit-discuss/2019-May/006389.html
> > >
> >
> > Good to know there is an overlap and it makes sense for me to attend. :)
>
> Hi Shuah,
>
> Oh, and I did not even know about
> https://lists.linuxfoundation.org/pipermail/ksummit-discuss/2019-May/006389.html
> How can I be kept in the loop/provide inputs/receive
> feedback/discussion summary?
>

Sorry didn't see this until now. You can subscribe ksummit-discuss to
follow the thread.

thanks,
-- Shuah
