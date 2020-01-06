Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D326130F20
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 10:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbgAFJDR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 04:03:17 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:47101 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgAFJDR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jan 2020 04:03:17 -0500
Received: by mail-lj1-f194.google.com with SMTP id m26so47716680ljc.13
        for <stable@vger.kernel.org>; Mon, 06 Jan 2020 01:03:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CeH+kQ0Qe8jVFl0FEZFj+JiqWbIaJiNDGyhGbyxRwj4=;
        b=XA+w1MAQwy4oE7FoGRn4Ac2fYBZydctJDh5Jb7kz7jErQaINP0+KvyQ50gqNwiZyCS
         4YWjZcvg4tZpWZSwHneQMGnBfazen79DSAkgN8eyiVAY1xjN/hjh4bFDoEpLfHO+gOGz
         quWftU/KkRI78okF7/BNkniOzH0hjILfz5N6n1REhnkiI5Z7wygjilreH3MnhSZ7UIbo
         Sgdh+tmW1HQ+8KHtC7At5UNSnfI6RJgid3CQK8W4VdCWnulJMI8QdwTgaf8JnWZGls3z
         HiY0N45FGP3rvfektTexAH91mLX6eOivmLwuMjVfBEXsoV9eZfhkqWQEhhmamw/VwonI
         uY/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CeH+kQ0Qe8jVFl0FEZFj+JiqWbIaJiNDGyhGbyxRwj4=;
        b=KuPOYow/I+d1nzEBoAkN33axPQBA4PS6XWnjMje9g/+mcHnbNqEqYlyOwhH3KVyq41
         dsLDNm3h6stFaXu3xU91OSsnJwCKToGjtn8AjdedJYe60PiqO2AdyUZvgvpFe/z/acDD
         ccSlxLHhZPsvhhV+qbnhTIuncy9ZY4+4je3TIsXT15ub1MBSQQQGTo4nDMezJQWe0K2u
         0M894eCyFBYGeh2wy/WTc+VqEg4Rbxj0/o5FWKGQx9OAvQb9N4cMjUst2kpYyKU0hxKC
         i603Ibzarlh1AQ3+cXPE8umFyzFWCCpOmRrrDbEvREGGQOho7Xl+zLOF6eOwfHI9a03I
         c+JA==
X-Gm-Message-State: APjAAAUD7Zt1j/1VHas5vbTcRk4p5wgYQVvF8v3JLhlO18RjfbNsjWtF
        BXil496lG1mAGVVZ5+yahgoVuxspaGGhAd0UA6327A==
X-Google-Smtp-Source: APXvYqyyYyXfN4bIo8fVghXO5BARXcu9jDvUQwl48nA0BGLXNo7fhOgd419s0X2DFiqJLbTMsn07A84oMJZGJ0aGPVk=
X-Received: by 2002:a2e:5357:: with SMTP id t23mr60119946ljd.227.1578301394444;
 Mon, 06 Jan 2020 01:03:14 -0800 (PST)
MIME-Version: 1.0
References: <20200102215829.911231638@linuxfoundation.org> <CA+G9fYuPkOGKbeQ0FKKx4H0Bs-nRHALsFtwyRw0Rt5DoOCvRHg@mail.gmail.com>
 <CAK8P3a1+Srey_7cUd0xfaO8HdMv5tkUcs6DeDXzcUKkUD-DnGQ@mail.gmail.com>
 <CAK8P3a24EkUXTu-K2c-5B3w-LZwY7zNcX0dZixb3gd59vRw_Kw@mail.gmail.com>
 <20200103154518.GB1064304@kroah.com> <CAK8P3a00SpVfSE5oL8_F_8jHdg_8A5fyEKH_DWNyPToxack=zA@mail.gmail.com>
 <a2fc8b36-c512-b6dd-7349-dfb551e348b6@oracle.com> <8283b231-f6e8-876f-7094-d3265096ab9a@oracle.com>
 <CAHk-=wjvWTFn=C3mT5wA=mtOwXw44U+OHLVxk5DCe4v+7nOvKg@mail.gmail.com>
In-Reply-To: <CAHk-=wjvWTFn=C3mT5wA=mtOwXw44U+OHLVxk5DCe4v+7nOvKg@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 6 Jan 2020 14:33:02 +0530
Message-ID: <CA+G9fYvzkPz6Ewm00ie+HqBpfQHFuRGn694Av-gj8Pt8iKrDQg@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/191] 5.4.8-stable review
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Mike Kravetz <mike.kravetz@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Chengguang Xu <cgxu519@mykernel.net>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>, LTP List <ltp@lists.linux.it>,
        Jan Stancek <jstancek@redhat.com>,
        John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 4 Jan 2020 at 00:10, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Fri, Jan 3, 2020 at 9:59 AM Mike Kravetz <mike.kravetz@oracle.com> wrote:
> >
> > Before I started investigating, Jan Stancek found and fixed the issue.
> >
> > http://lkml.kernel.org/r/a14b944b6e5e207d2f84f43227c98ed1f68290a2.1578072927.git.jstancek@redhat.com
>
> Applied upstream as commit 15f0ec941f4f ("mm/hugetlbfs: fix
> for_each_hstate() loop in init_hugetlbfs_fs()").

After applying above patch.
LTP test case memfd_create04 getting PASS on mainline Linus's tree
from Jan 3rd onwards.

ref link,
https://qa-reports.linaro.org/lkft/linux-mainline-oe/tests/ltp-syscalls-tests/memfd_create04

- Naresh Kamboju
