Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36FBF391FF
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 18:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729986AbfFGQ2L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 12:28:11 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:37102 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730459AbfFGQ2K (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jun 2019 12:28:10 -0400
Received: by mail-io1-f68.google.com with SMTP id e5so1875477iok.4
        for <stable@vger.kernel.org>; Fri, 07 Jun 2019 09:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EpFmn1nFZ0dZQ5WZgQhumGKYIchPn+/iQPxpM1BzFNE=;
        b=JLwTu3aJRP9gycJQP7ZPtZIpjmejCZj0mQQ5gEC3OgtEGZvWWCyyzKwejcjP42mSdz
         FkUrzw62J93jtqUiLcFKo6JmfwuD7+Ec34RSo27brx2qKcagn2GbMLFPwwcLFuEF3GWs
         xnxMHWP+khfuFPi2Mc1skBwFKhM7JElyipzy4iK8RhT05/ivvdzrZvy0r7tTLMHlAdfk
         pedHv+rKhk5Oovptbdmlz+LA+EPYLrumUnsOc8pHUnlNKlVhOBibXO6biG7Cey+Ue/i/
         RvDYkhpiB7y31Qt2t8vOwwQXu+En0JJ249PbqjE3PUsPA3HFiEAEDvvvQANVgpAfINbG
         ydmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EpFmn1nFZ0dZQ5WZgQhumGKYIchPn+/iQPxpM1BzFNE=;
        b=WVLWj9xtTExxmTglYeYxbAHg39HeR94xsthPuKG0Kq2PbanaiTBwkxAmhU377Fiy1u
         4InHwolPo51X0fBFx1eFMC2YHCO8/Z9DG711jml1ldj9dpuKG3BWEveWRlDSpGRKA2q2
         W9IAoAqW3vKU1qSl2dez7TrJQU5s742xqzvNItM8WXiA/uCzNXHUi/UZpvBuBycP0lAD
         Yv7NiBJQr29UHTILdqlKqCY6jJOHfywP3aOKEAD9dx5xleg6U+qvEweYtMfJlxMXzhjl
         u9eZmXJ5VfQRRRsQ6YaxH31o++zqoo032SFsgMlA7kR+SwLMl4pxfkB3stWkGoYbnsmk
         LTNw==
X-Gm-Message-State: APjAAAW5IBEmESGcV6aDDjEfEmtcBlDADd9VHM4Wg2W4EJfshw12bXt7
        SQdv1CHZFGvkfofX34X0eSI7Em96R2By7nbBlEOnWQ==
X-Google-Smtp-Source: APXvYqyQYikL4RZlDGhQBnuPmlm6VOLftCYgDGAltauOlBa43AqXFzZ9QXKqkJ2L5VHywV5Y2vB6g+k1U+zQ51wFSsg=
X-Received: by 2002:a6b:e711:: with SMTP id b17mr32766988ioh.3.1559924889193;
 Fri, 07 Jun 2019 09:28:09 -0700 (PDT)
MIME-Version: 1.0
References: <1204558561.21265703.1558449611621.JavaMail.zimbra@redhat.com>
 <1667759567.21267950.1558450452057.JavaMail.zimbra@redhat.com>
 <20190605204659.npyf7wnmsdlr2bff@xps.therub.org> <CAKocOONHHuL2xSBUQx0=pw5AHMG4im=9kv3GrJLrKaH6+wguDw@mail.gmail.com>
In-Reply-To: <CAKocOONHHuL2xSBUQx0=pw5AHMG4im=9kv3GrJLrKaH6+wguDw@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 7 Jun 2019 18:27:57 +0200
Message-ID: <CACT4Y+YFHZhm0pwoZdXSXtG4z1wHPOC9hG-RvRy=3szteEe6XA@mail.gmail.com>
Subject: Re: CKI hackfest @Plumbers invite
To:     Shuah Khan <shuahkhan@gmail.com>
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

On Thu, Jun 6, 2019 at 12:00 AM Shuah Khan <shuahkhan@gmail.com> wrote:
>
> Hi Veronika,
>
> On Wed, Jun 5, 2019 at 2:47 PM Dan Rue <dan.rue@linaro.org> wrote:
> >
> > On Tue, May 21, 2019 at 10:54:12AM -0400, Veronika Kabatova wrote:
> > > Hi,
> > >
> > > as some of you have heard, CKI Project is planning hackfest CI meetings after
> > > Plumbers conference this year (Sept. 12-13). We would like to invite everyone
> > > who has interest in CI for kernel to come and join us.
> > >
> > > The early agenda with summary is at the end of the email. If you think there's
> > > something important missing let us know! Also let us know in case you'd want to
> > > lead any of the sessions, we'd be happy to delegate out some work :)
> > >
> > >
> > > Please send us an email as soon as you decide to come and feel free to invite
> > > other people who should be present. We are not planning to cap the attendance
> > > right now but need to solve the logistics based on the interest. The event is
> > > free to attend, no additional registration except letting us know is needed.
> > >
>
> I am going be there and plan to attend.
>
> > > Feel free to contact us if you have any questions,
> > > Veronika
> > > CKI Project
> >
> > Hi Veronika! Thanks for organizing this. I plan to attend, and I'm happy
> > to help out.
> >
> > With regard to the agenda, I've been following the '[Ksummit-discuss]
> > [MAINTAINERS SUMMIT] Squashing bugs!'[1] thread with interest, as it
> > relates especially to 'Getting results to developers/maintainers'. This,
> > along with result aggregation, are important areas to focus.
> >
> >
> > [1] https://lists.linuxfoundation.org/pipermail/ksummit-discuss/2019-May/006389.html
> >
>
> Good to know there is an overlap and it makes sense for me to attend. :)

Hi Shuah,

Oh, and I did not even know about
https://lists.linuxfoundation.org/pipermail/ksummit-discuss/2019-May/006389.html
How can I be kept in the loop/provide inputs/receive
feedback/discussion summary?

Thanks
