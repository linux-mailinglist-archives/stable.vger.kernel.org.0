Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C504287C3
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 09:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234192AbhJKHkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 03:40:42 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:55942 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234449AbhJKHkl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 03:40:41 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 0C48D22034;
        Mon, 11 Oct 2021 07:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1633937915;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dW7+2eJDZzMMtGdCNOgIHEUM067pLA4d6dFLRywGPD4=;
        b=WFTse2hZYIoIjFqfZjv5PAgWCWFgooCkIozWjsupLGm8SoHvXBWPHGWwh7HqUxmw80B8ka
        Bg5SDMGYYsqw468ebe5l8SDICoARIXFr63Cfek2bsTsW2LzPp68jDjW4PNbON5EXLjXKC/
        ze0L4ImmtO0CAQ56GSCSjyNUKghsQfU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1633937915;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dW7+2eJDZzMMtGdCNOgIHEUM067pLA4d6dFLRywGPD4=;
        b=61KZEbecF+I9JeDAnm9cLH1zoJ9jX5+xCpAI6DjZKezXCtQqoslXtMlRc6196AP2reGulR
        INHvCFmFFQo43eAQ==
Received: from g78 (unknown [10.163.24.38])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 0EA24A3B83;
        Mon, 11 Oct 2021 07:38:34 +0000 (UTC)
References: <20211008112714.601107695@linuxfoundation.org>
 <CA+G9fYvOK+5qPEU7RMfD1O5O3EwTfThoh3Le9Rx8GDhY3nY1Ww@mail.gmail.com>
User-agent: mu4e 1.6.5; emacs 27.2
From:   Richard Palethorpe <rpalethorpe@suse.de>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        LTP List <ltp@lists.linux.it>, Cyril Hrubis <chrubis@suse.cz>,
        Li Wang <liwang@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, mkoutny@suse.cz
Subject: Re: [PATCH 4.19 00/12] 4.19.210-rc1 review
Date:   Mon, 11 Oct 2021 08:28:31 +0100
Reply-To: rpalethorpe@suse.de
In-reply-to: <CA+G9fYvOK+5qPEU7RMfD1O5O3EwTfThoh3Le9Rx8GDhY3nY1Ww@mail.gmail.com>
Message-ID: <875yu4au4n.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Naresh,

Naresh Kamboju <naresh.kamboju@linaro.org> writes:

> On Fri, 8 Oct 2021 at 17:00, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> This is the start of the stable review cycle for the 4.19.210 release.
>> There are 12 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Sun, 10 Oct 2021 11:27:07 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch=
-4.19.210-rc1.gz
>> or in the git tree and branch at:
>>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git linux-4.19.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
>
> Results from Linaro=E2=80=99s test farm.
> No regressions on arm64, arm, x86_64, and i386.
>
> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> NOTE:
> LTP version upgrade to LTP 20210927.
> The new case "cfs_bandwidth01" found the following warning.
> Since it is a new test case that found this warning can not be considered=
 as
> regression.
> This warning is only seen on stable rc 4.19
> but not found on 4.14, 5.4, 5.10 and 5.14.
>
> Test output log:
> ----------------
> cfs_bandwidth01.c:57: TINFO: Set 'worker1/cpu.max' =3D '3000 10000'
> cfs_bandwidth01.c:57: TINFO: Set 'worker2/cpu.max' =3D '2000 10000'
> cfs_bandwidth01.c:57: TINFO: Set 'worker3/cpu.max' =3D '3000 10000'
> cfs_bandwidth01.c:118: TPASS: Scheduled bandwidth constrained workers
> cfs_bandwidth01.c:57: TINFO: Set 'level2/cpu.max' =3D '5000 10000'
> cfs_bandwidth01.c:130: TPASS: Workers exited
> cfs_bandwidth01.c:118: TPASS: Scheduled bandwidth constrained workers
> cfs_bandwidth01.c:57: TINFO: Set 'level2/cpu.max' =3D '5000 10000'
> cfs_bandwidth01.c:130: TPASS: Workers exited
> cfs_bandwidth01.c:118: TPASS: Scheduled bandwidth constrained work[
> 56.624213] ------------[ cut here ]------------
> [   56.629421] rq->tmp_alone_branch !=3D &rq->leaf_cfs_rq_list

FWIW this appears to be the bug the test is intended to
reproduce. Originally seen on a SUSE enterprise 4.12 kernel.

--=20
Thank you,
Richard.
