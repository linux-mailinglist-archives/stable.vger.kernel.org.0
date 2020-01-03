Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29F3F12FCAD
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 19:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728331AbgACSlC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 13:41:02 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:44287 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728279AbgACSlC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 13:41:02 -0500
Received: by mail-lf1-f65.google.com with SMTP id v201so32399877lfa.11
        for <stable@vger.kernel.org>; Fri, 03 Jan 2020 10:41:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=09Fhb5KJtdVXpuTOxj9n6AxgCLlTa7iHkIeQIqz8ZXQ=;
        b=gQn987UynqGEaSDi7PzqcZnNE24GYhuSwEuB8jnz/K2ht/y/6Y4Eaq+5ZrqWLDJKFm
         DLfYiRceU9rAJ/iKZ+Kcq3FhJfAejLiEOsXP6+apzeqFfjISklQkC5r1Z/2//zpdza/L
         28M2GzAciQMj90SjWNUCeoNq+D6s1/JuCsIig=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=09Fhb5KJtdVXpuTOxj9n6AxgCLlTa7iHkIeQIqz8ZXQ=;
        b=PZJdXy94u1WA3XcD0N+iPHwV6r3IsbpaQwCUYH0YuTIzwrn2rfhhcmvZUQQF0dMkiX
         KnMAmqwBrGqQgXem6WZuZnzUsDgK3hBziim/NGvAytNCbOB2w8VA0s0OAbyhy7IehlII
         DQUDw6WlOYANnlB1P0SLsZZSXKpLxbY0/dEgpisAjDt4CAADPcIQZqaZUaOEKL2zLaaT
         aiCJnOH8xu12SsZOZiZj+67pNnitKZW1qezJx0FTO3XrVVpcav7qmyexUR362ax4kJA5
         oeQLRHpBkyWj52TsgYtMoIHMisGHT3R0/1h0FsdBT/40ZB5cXYyjsvpFztOXkRsQDMPd
         cDXA==
X-Gm-Message-State: APjAAAXMrtQm/S2EasO1/VLt4ln5zn0eTojvU0p4eFehj7ld42KTwtjT
        aXVUmGI/0DlWrfC0yc+NOBkdojoPy70=
X-Google-Smtp-Source: APXvYqyVHj+pf8aff10AXnigBmpbAyZsq2DK2rMvfgyxmyO8h+u6gLjZxmbvWzwMzVlTqPOpHcbDBw==
X-Received: by 2002:ac2:5088:: with SMTP id f8mr50754686lfm.163.1578076858460;
        Fri, 03 Jan 2020 10:40:58 -0800 (PST)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id t10sm22981664lji.61.2020.01.03.10.40.56
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jan 2020 10:40:57 -0800 (PST)
Received: by mail-lj1-f182.google.com with SMTP id m26so42297511ljc.13
        for <stable@vger.kernel.org>; Fri, 03 Jan 2020 10:40:56 -0800 (PST)
X-Received: by 2002:a2e:9ad8:: with SMTP id p24mr53118229ljj.148.1578076856282;
 Fri, 03 Jan 2020 10:40:56 -0800 (PST)
MIME-Version: 1.0
References: <20200102215829.911231638@linuxfoundation.org> <CA+G9fYuPkOGKbeQ0FKKx4H0Bs-nRHALsFtwyRw0Rt5DoOCvRHg@mail.gmail.com>
 <CAK8P3a1+Srey_7cUd0xfaO8HdMv5tkUcs6DeDXzcUKkUD-DnGQ@mail.gmail.com>
 <CAK8P3a24EkUXTu-K2c-5B3w-LZwY7zNcX0dZixb3gd59vRw_Kw@mail.gmail.com>
 <20200103154518.GB1064304@kroah.com> <CAK8P3a00SpVfSE5oL8_F_8jHdg_8A5fyEKH_DWNyPToxack=zA@mail.gmail.com>
 <a2fc8b36-c512-b6dd-7349-dfb551e348b6@oracle.com> <8283b231-f6e8-876f-7094-d3265096ab9a@oracle.com>
In-Reply-To: <8283b231-f6e8-876f-7094-d3265096ab9a@oracle.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 3 Jan 2020 10:40:40 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjvWTFn=C3mT5wA=mtOwXw44U+OHLVxk5DCe4v+7nOvKg@mail.gmail.com>
Message-ID: <CAHk-=wjvWTFn=C3mT5wA=mtOwXw44U+OHLVxk5DCe4v+7nOvKg@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/191] 5.4.8-stable review
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
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

On Fri, Jan 3, 2020 at 9:59 AM Mike Kravetz <mike.kravetz@oracle.com> wrote:
>
> Before I started investigating, Jan Stancek found and fixed the issue.
>
> http://lkml.kernel.org/r/a14b944b6e5e207d2f84f43227c98ed1f68290a2.1578072927.git.jstancek@redhat.com

Applied upstream as commit 15f0ec941f4f ("mm/hugetlbfs: fix
for_each_hstate() loop in init_hugetlbfs_fs()").

I didn't add a cc: stable, because the original didn't have one, and
the "Fixes:" tag should make it happen.

               Linus
