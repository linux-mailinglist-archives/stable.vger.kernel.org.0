Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5734A12F9C7
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 16:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727621AbgACPaR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 10:30:17 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:38923 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727539AbgACPaR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 10:30:17 -0500
Received: from mail-qk1-f181.google.com ([209.85.222.181]) by
 mrelayeu.kundenserver.de (mreue108 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1Ma1sQ-1jH2kT3xhs-00W0sf; Fri, 03 Jan 2020 16:30:14 +0100
Received: by mail-qk1-f181.google.com with SMTP id k6so34033646qki.5;
        Fri, 03 Jan 2020 07:30:13 -0800 (PST)
X-Gm-Message-State: APjAAAWmrT8fMg5+YbZrbE46EVZN96KN5hGJ6LdOhZLFFce8pwc7OCRC
        IilP0tSIYUG6U/+bYIo7b2benpdhUW2SOFr4kEQ=
X-Google-Smtp-Source: APXvYqwHUYXqxj/j23T+ikUyIYNwMZifF+nmQ9YLHsVb0EE95ucvNJpStysB4sIHolKlqgQ3wE0r3lfmMIjKWFkIpZ0=
X-Received: by 2002:a05:620a:a5b:: with SMTP id j27mr71961132qka.286.1578065412765;
 Fri, 03 Jan 2020 07:30:12 -0800 (PST)
MIME-Version: 1.0
References: <20200102215829.911231638@linuxfoundation.org> <CA+G9fYuPkOGKbeQ0FKKx4H0Bs-nRHALsFtwyRw0Rt5DoOCvRHg@mail.gmail.com>
 <CAK8P3a1+Srey_7cUd0xfaO8HdMv5tkUcs6DeDXzcUKkUD-DnGQ@mail.gmail.com>
In-Reply-To: <CAK8P3a1+Srey_7cUd0xfaO8HdMv5tkUcs6DeDXzcUKkUD-DnGQ@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 3 Jan 2020 16:29:56 +0100
X-Gmail-Original-Message-ID: <CAK8P3a24EkUXTu-K2c-5B3w-LZwY7zNcX0dZixb3gd59vRw_Kw@mail.gmail.com>
Message-ID: <CAK8P3a24EkUXTu-K2c-5B3w-LZwY7zNcX0dZixb3gd59vRw_Kw@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/191] 5.4.8-stable review
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Chengguang Xu <cgxu519@mykernel.net>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>, LTP List <ltp@lists.linux.it>,
        Jan Stancek <jstancek@redhat.com>,
        John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:0iu6L/RKqxi7vTMjJBy+yXMU9VNmrlt1TIpgdtuo8lYHq/vLKVZ
 Jor/f50JDK/X8PpTx3tQsnOZ0foYvp8V+c6Yztz5tCcNoGxQkz4c3tGnzOsDbYqCAfQcNdy
 JdyTyGprmQ7sOxX5fbLSl+3xn8tOjQGgqluKPtsCaYVDC235+h4axSBijyTzxXtM1mSqlN6
 4IIpzsg74q+hg8anoKvLA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:6ywwfmZGiv8=:M8u1KtULF6YaJu7Rbo9Y9V
 D7ah+Meeam9Io88ABfblXp9RAihjSgh2Cpza8/p6zaaVxphlR0c6MFd6ObMY+1lWPfqhj1FoT
 yS/k40cpFgABzDLcKA+PNTwJv7qjneppJiWekgZ3jh+yuf18r6KpChxVStzu+ffLKkvfjnWi4
 6YgVEkuCGB/bCP0qi39iPVZcbsaVYj0haVVQdhXHxXx9/aPP9DRbeF+XNo2Nuz0G7q+cCUnQ6
 HP4rC71wHokslBQqhcsEtRJ8oDZA1JgjyqLX9KfiYPlxAbKKX77iEBxYP+JxaWlXyP4+oxh+N
 uXheDSsv+Y5pssVUkXP2HESgjgWQjMzqGanjXRex42zkrL2cSgMWhf2e2kgAn7S1dR59DBxyL
 PdYmdbW4K8pu4hznWcZwrrsTBCET0mGuQN+wp7e1BIBn17RmbRxKAtFNeggti99IzI/bc96c6
 +d9U/ZYjyvXtQkjo5wGRaaT/TLiQKija3DQf8pbUeIkzbnIPzfutF0Gkb8szj2zbwZjR+lgdc
 MWclC8WOzAGXWP2SmqlpJLTJK9UCoqMB/D1c7/LFQxqCTrUqBvEtMl4cCzPAEnh507BQOMNO2
 OruFxBc+9Imm5zHf1GmqA6JiZ4cCYCssN5x2VluKrq9vW/OnhKX9U5ormH45Rkw/9if920PA8
 jy53VTsGRFVhIzacV9H9whfC6Cr2oR0fEtlV/O4QjENV6EFtNPK6cO4Ffd0hNZPHPJfWh+YyK
 rIxQKyaf6JBphFCPYIP2jrb8hY7yJm0RjTH1L6aO1qSefmiB+jf+mAPGnwPwZBZoG+OIn3KjL
 kH8xmUbbVPIe2pxsFc8dxxDznJmjbLHh6opyc8lItmIPNUbIT/ce3FVH39wHf3OBctwm6s+hW
 yHg7FDOYeS7zOHm1nzIQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 3, 2020 at 4:25 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Fri, Jan 3, 2020 at 4:03 PM Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >
> > On Fri, 3 Jan 2020 at 03:42, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
>
> -ENOENT is what you get when hugetlbfs is not mounted, so this hints to
>
> 8fc312b32b2  mm/hugetlbfs: fix error handling when setting up mounts
>
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=linux-5.4.y&id=3f549fb42a39bea3b29c0fc12afee53c4a01bec9

I see that Mike Kravetz suggested not putting this patch into stable in

https://lore.kernel.org/lkml/befca227-cb8a-8f47-617d-e3bf9972bfec@oracle.com/

but it was picked through the autosel mechanism later.

      Arnd
