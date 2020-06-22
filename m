Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCAB20437C
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 00:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730933AbgFVWUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 18:20:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731009AbgFVWUl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jun 2020 18:20:41 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8357620656;
        Mon, 22 Jun 2020 22:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592864440;
        bh=QuPhHhkFhCQD214xMOfhzbEJRo+fTHdCIiVk5hVjrQo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M9Dr1jYd8c10mzud1uPfiukuRfetSfbRvJxrfBzm9BvzTubOlI/I0LB89Ag3Gufzo
         vb9IRyPJnF+co8EYWmjSLXloba9H0dsah1TBaTOC/zSOy1A3R20DoYWldKqJb0UOXR
         VcpuAah9Cc3lEdw3KbH1DIpRtA9xxrWvzXpzy5gs=
Date:   Mon, 22 Jun 2020 18:20:39 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Milos Malik <mmalik@redhat.com>,
        Jeff Bastian <jbastian@redhat.com>,
        Major Hayden <major@redhat.com>, Xiaowu Wu <xiawu@redhat.com>,
        Rachel Sibley <rasibley@redhat.com>,
        David Arcari <darcari@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: =?utf-8?B?8J+SpSBQQU5JQ0tFRA==?= =?utf-8?Q?=3A?= Test report for
 kernel 5.7.5-d1c48db.cki (stable-queue)
Message-ID: <20200622222039.GO1931@sasha-vm>
References: <cki.F024F9B69C.ZR0DRUTWUW@redhat.com>
 <CAFqZXNtj8aBpsHNXDcPsP26Xp3Fumx9e4-=dvOdATSGw6cxV3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFqZXNtj8aBpsHNXDcPsP26Xp3Fumx9e4-=dvOdATSGw6cxV3w@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 22, 2020 at 11:23:32PM +0200, Ondrej Mosnacek wrote:
>On Mon, Jun 22, 2020 at 10:59 PM CKI Project <cki-project@redhat.com> wrote:
>> Hello,
>>
>> We ran automated tests on a recent commit from this kernel tree:
>>
>>        Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>>             Commit: d1c48dba15e7 - pinctrl: qcom: ipq6018 Add missing pins in qpic pin group
>>
>> The results of these automated tests are provided below.
>>
>>     Overall result: FAILED (see details below)
>>              Merge: OK
>>            Compile: OK
>>              Tests: PANICKED
>>
>> All kernel binaries, config files, and logs are available for download here:
>>
>>   https://cki-artifacts.s3.us-east-2.amazonaws.com/index.html?prefix=datawarehouse/2020/06/22/607452
>>
>> One or more kernel tests failed:
>>
>>     s390x:
>>       selinux-policy: serge-testsuite
>>      ❌ stress: stress-ng
>>       Podman system integration test - as root
>>
>>     ppc64le:
>>       selinux-policy: serge-testsuite
>>       Podman system integration test - as root
>>
>>     aarch64:
>>       Podman system integration test - as root
>>       selinux-policy: serge-testsuite
>>
>>     x86_64:
>>       Podman system integration test - as root
>>       selinux-policy: serge-testsuite
>
>It seems the panics are caused by this commit:
>https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/fs?h=linux-5.7.y&id=7bdb075348e33d757bd8cdf017a255a090e87b8f
>
>Apparently, the "if (flags & ~(O_ACCMODE | O_LARGEFILE))" check is
>being hit during mount(2):
>https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/tree/fs/overlayfs/util.c?h=d1c48db#n465

I'll drop it for now, thanks!

-- 
Thanks,
Sasha
