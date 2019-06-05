Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0C4D36724
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 00:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfFEWA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jun 2019 18:00:26 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:44764 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfFEWA0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jun 2019 18:00:26 -0400
Received: by mail-wr1-f49.google.com with SMTP id w13so268797wru.11
        for <stable@vger.kernel.org>; Wed, 05 Jun 2019 15:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=aNMcK0do3kPInKfONQircMSRCz2uPcIaebbt7Hl35fs=;
        b=UfL+EE8Jvw42VbzhYOy3D8GJ9792DZmr3OYCAdpYG/5Vqihvbux6PLEvg5hVtAAFdA
         9ZhsbY/4qOtG7ZKVsvTclgEguo2ZfoENjNholWRxERhW3qxD66FjWcnIR+2ayfSuhJs4
         nF3efrjtSYBIqBU9rGVufLkTqNqTJgNXmTDt+Baz4ai1Kcqzb45jTL5RQVURXY3jDiTl
         /f5rlR26pAgn1F/wTNbP++Z921trljp0dwscpxBM4NsB/7B/LURz7UcRCceB+4lfeXPJ
         H4Ob6G7VeAnxAHzgbO/a6C2YLnpJdIq6fa5dCYcFQeGTU72mfb5pq6j67ywZQbJZ/uMm
         1FxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=aNMcK0do3kPInKfONQircMSRCz2uPcIaebbt7Hl35fs=;
        b=Fw2SqqdD5WOeUQalZW9zV15R9y9uGrmYQFAz2fLGkW5tYlPYP/NeQqN80A7VHjurIh
         HQEVLjBVny+bOsNvsv8pcyqYEgU+wvekpR4bBlVVPnQjebSpy3w20Ngy5qfrACUtWZd/
         qpPtlR/NWZE20QRBHfWUDHAu5L8HG6jLYY3ArB3zVGaXgceqVg5e94AFIl2edfTwSlsU
         czWli1ZjBLDRhhr08jJ448gM2uY2HTn3n3OfvqJMjgrXe7vg45OzIhnl3ouwh6kNs6LV
         IAIRseEhl8mdjh/Iv3ukTvp4wGWqAymJrpn4gsktjpWGS/aBUCA2Qy2H0k234XNwA3xQ
         Ft0w==
X-Gm-Message-State: APjAAAVSepcXdIZcfBo5Y6U2zbJ3fy6a5c+Ae2f+S7NSC6DmelKy3+v8
        RkgQ/Er/QbCk6LEx720CRg4vcuahdjhQqb+rKjw=
X-Google-Smtp-Source: APXvYqxZHGH9IL3i6QRqyJO42xm8Q3trFKhLS+WZXaEXGf/wU5J92UOvYt+nnAyxV0W5cDTY/2DJgn7Uvs5Gg1ugGw4=
X-Received: by 2002:adf:c5c1:: with SMTP id v1mr9314283wrg.129.1559772024617;
 Wed, 05 Jun 2019 15:00:24 -0700 (PDT)
MIME-Version: 1.0
References: <1204558561.21265703.1558449611621.JavaMail.zimbra@redhat.com>
 <1667759567.21267950.1558450452057.JavaMail.zimbra@redhat.com> <20190605204659.npyf7wnmsdlr2bff@xps.therub.org>
In-Reply-To: <20190605204659.npyf7wnmsdlr2bff@xps.therub.org>
From:   Shuah Khan <shuahkhan@gmail.com>
Date:   Wed, 5 Jun 2019 16:00:13 -0600
Message-ID: <CAKocOONHHuL2xSBUQx0=pw5AHMG4im=9kv3GrJLrKaH6+wguDw@mail.gmail.com>
Subject: Re: CKI hackfest @Plumbers invite
To:     Veronika Kabatova <vkabatov@redhat.com>,
        automated-testing@yoctoproject.org, info@kernelci.org,
        Tim.Bird@sony.com, khilamn@baylibre.org,
        syzkaller@googlegroups.com, lkp@lists.01.org,
        stable <stable@vger.kernel.org>,
        Laura Abbott <labbott@redhat.com>,
        Eliska Slobodova <eslobodo@redhat.com>,
        CKI Project <cki-project@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Veronika,

On Wed, Jun 5, 2019 at 2:47 PM Dan Rue <dan.rue@linaro.org> wrote:
>
> On Tue, May 21, 2019 at 10:54:12AM -0400, Veronika Kabatova wrote:
> > Hi,
> >
> > as some of you have heard, CKI Project is planning hackfest CI meetings after
> > Plumbers conference this year (Sept. 12-13). We would like to invite everyone
> > who has interest in CI for kernel to come and join us.
> >
> > The early agenda with summary is at the end of the email. If you think there's
> > something important missing let us know! Also let us know in case you'd want to
> > lead any of the sessions, we'd be happy to delegate out some work :)
> >
> >
> > Please send us an email as soon as you decide to come and feel free to invite
> > other people who should be present. We are not planning to cap the attendance
> > right now but need to solve the logistics based on the interest. The event is
> > free to attend, no additional registration except letting us know is needed.
> >

I am going be there and plan to attend.

> > Feel free to contact us if you have any questions,
> > Veronika
> > CKI Project
>
> Hi Veronika! Thanks for organizing this. I plan to attend, and I'm happy
> to help out.
>
> With regard to the agenda, I've been following the '[Ksummit-discuss]
> [MAINTAINERS SUMMIT] Squashing bugs!'[1] thread with interest, as it
> relates especially to 'Getting results to developers/maintainers'. This,
> along with result aggregation, are important areas to focus.
>
>
> [1] https://lists.linuxfoundation.org/pipermail/ksummit-discuss/2019-May/006389.html
>

Good to know there is an overlap and it makes sense for me to attend. :)

thanks,
-- Shuah
