Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDCC4B0E7
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 06:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725866AbfFSEk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 00:40:26 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:35124 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbfFSEkZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jun 2019 00:40:25 -0400
Received: by mail-lj1-f194.google.com with SMTP id x25so1853970ljh.2
        for <stable@vger.kernel.org>; Tue, 18 Jun 2019 21:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jzsAnOW0fiQKd91apGMhizgDc21BUMXc9JiZfugsWIs=;
        b=c59f8lIUe36phMpw9ATYq8C9p86NK7iNRNUtf7m7HybHY8uzb7pZGJMNCEFz5qGF4c
         25wvKBlryiyndOfi04/8SArC5wwAxbFNiK3axmQdEyVYy9xOCuhAkbYKFiglETfNZNJ6
         wPAAzH7ZH3LDckayhcEfjhRmlSJUD33EHZm3WWNLHRsORSAxAkyxS8AeOtDRg8CsYp0d
         Qwy0pqV8MQk8OMTPJj0qUDOvpZ5T8wHXjsZPRAHkdoAkl1zR6plDaehAXSrvh9CtlUlk
         pM5lr62r1gXqk4QgTK/hAHh6J0ETGjU21ggNbdakog+N1Wgy6FrHt6rAVLZz7sFhdbqi
         sUYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jzsAnOW0fiQKd91apGMhizgDc21BUMXc9JiZfugsWIs=;
        b=Fvw8l5NwEsT5CpeOkPymhLcGcEtqHt8G/ZhedXcItIxH3M98fHrLJJuz10JpHXcaLn
         fDwaZqvQcRBWr3WPAGWKqUC/2lb0Fbs/5vGCvV64D5GJiV6zsDtXS/M/oz+3IgCNAoQ/
         ybFlQGsfRBxixwP+YlNo+zyhlqDw4mQO380tWlhUYAjhNe2lsrZkiNIUP6mC5DlNLY2Y
         MEzlQkLDvCie0IfI4lcODS66R06BWFP0Zxiu/YRu0wbBhxWjGiLv8tvxahVKXEXTTT9b
         RvQMTILUIYzKKYwKXaM/pY8e56YyY6na+gqOK4kd4JlEK7506itPbWZxyLpIpRX940wD
         N5jg==
X-Gm-Message-State: APjAAAVApdJOjfAMEIPwkI/9qXhzQZiXue5haMrFF1zlLjtmHo/Dm0fQ
        9b0EEQfrgMD8AKeN8xJw0Moje67jmnJOY6E1I1YwWQ==
X-Google-Smtp-Source: APXvYqwOza7DC7cFHNRbAMh2d9YefDyLYP7euYEy2neD9yOj3NA6R+Z8Zj5AM81hpKPlb8QGZ68F4vdZ68MiYe933n4=
X-Received: by 2002:a2e:8559:: with SMTP id u25mr18237899ljj.224.1560919223720;
 Tue, 18 Jun 2019 21:40:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190617210759.929316339@linuxfoundation.org> <CA+G9fYsUmFrTDHJfS=1vYVfv4BVRZ0AByEOHV6toidAxWuDqDg@mail.gmail.com>
 <20190618133502.GA5416@kroah.com>
In-Reply-To: <20190618133502.GA5416@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 19 Jun 2019 10:10:12 +0530
Message-ID: <CA+G9fYsDG94ZjpchTqD80vioNBUdoUXH_k-tBM0L8YumefYO-w@mail.gmail.com>
Subject: Re: [PATCH 5.1 000/115] 5.1.12-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 18 Jun 2019 at 19:05, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Jun 18, 2019 at 06:04:25PM +0530, Naresh Kamboju wrote:
> > On Tue, 18 Jun 2019 at 02:50, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.1.12 release.
> > > There are 115 patches in this series, all will be posted as a respons=
e
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >
> > > Responses should be made by Wed 19 Jun 2019 09:06:21 PM UTC.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/pa=
tch-5.1.12-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git linux-5.1.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > Results from Linaro=E2=80=99s test farm.
> > No regressions on arm64, arm, x86_64, and i386.
> >
> > NOTE:
> > kernel/workqueue.c:3030 __flush_work+0x2c2/0x2d0
> > Kernel warning is been fixed by below patch.
> >
> > > John Fastabend <john.fastabend@gmail.com>
> > >     bpf: sockmap, only stop/flush strp if it was enabled at some poin=
t
>
> What is the git commit id for this patch?

     Upstream commit 014894360ec95abe868e94416b3dd6569f6e2c0c

- Naresh
