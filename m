Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71CE8454E9B
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 21:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbhKQUgy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 15:36:54 -0500
Received: from ofcsgdbm.dwd.de ([141.38.3.245]:42431 "EHLO ofcsgdbm.dwd.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231720AbhKQUgy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Nov 2021 15:36:54 -0500
Received: from localhost (localhost [127.0.0.1])
        by ofcsg2dn1.dwd.de (Postfix) with ESMTP id 4HvZDn4VBvz20NB
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 20:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dwd.de; h=
        content-type:content-type:mime-version:references:message-id
        :in-reply-to:subject:subject:from:from:date:date:received
        :received:received:received:received:received:received:received;
         s=dwd-csg20210107; t=1637180729; x=1638390330; bh=absRaF0AyRWFE
        rHHsQuG9VvtLc2L1whYYXeUbE+o7Nw=; b=1M+1JRYESFeBsA5nELYZl0PeERIwy
        W0LL8BUsRzJB38tILKA3vdMYvglbv5QlY4lEkG5wmSMJ9xZyjqxORuK63XBTJD0D
        OwRRjcXujHNliaLdc13eruDJc7mr/ikc+piPKTJobeR6fq6VccLoa5PpBZH+ihWE
        IHqRwCmk3LTIBz/33d+mKnBo96rdviZg2plbYlHLpVsrIE9IGEunW/8PJzLyAP1R
        pZPI6IwyFKQyEBxLYoYeJIELA2PCbpCwY1al8Ko/Ad2MOfe5WCRZ2JSthTSZmg5w
        ZmFTXadwE9UJdRgNuLVHwULvaVz2y3/Si3u/ta1/5xQ0pHtWpsvgjKhtg==
X-Virus-Scanned: by amavisd-new at csg.dwd.de
Received: from ofcsg2cteh1.dwd.de ([172.30.232.65])
        by localhost (ofcsg2dn1.dwd.de [172.30.232.24]) (amavisd-new, port 10024)
        with ESMTP id KQV4gfa4qUQV for <stable@vger.kernel.org>;
        Wed, 17 Nov 2021 20:25:29 +0000 (UTC)
Received: from ofcsg2cteh1.dwd.de (unknown [127.0.0.1])
        by DDEI (Postfix) with SMTP id 697D5C900D83
        for <root@ofcsg2dn1.dwd.de>; Wed, 17 Nov 2021 20:25:29 +0000 (UTC)
Received: from ofcsg2cteh1.dwd.de (unknown [127.0.0.1])
        by DDEI (Postfix) with ESMTP id 861C5C9025E4
        for <root@ofcsg2dn1.dwd.de>; Wed, 17 Nov 2021 20:25:13 +0000 (UTC)
X-DDEI-TLS-USAGE: Unused
Received: from ofcsgdbm.dwd.de (unknown [172.30.232.24])
        by ofcsg2cteh1.dwd.de (Postfix) with ESMTP
        for <root@ofcsg2dn1.dwd.de>; Wed, 17 Nov 2021 20:25:13 +0000 (UTC)
Received: from ofcsgdbm.dwd.de by localhost (Postfix XFORWARD proxy);
 Wed, 17 Nov 2021 20:25:13 -0000
Received: from ofcsg2dvf2.dwd.de (ofcsg2dvf2.dwd.de [172.30.232.11])
        by ofcsg2dn1.dwd.de (Postfix) with ESMTPS id 4HvZDT3PVjz1xn8;
        Wed, 17 Nov 2021 20:25:13 +0000 (UTC)
Received: from ofmailhub.dwd.de (ofmailhub.dwd.de [141.38.39.196])
        by ofcsg2dvf2.dwd.de  with ESMTP id 1AHKPCI1009217-1AHKPCI2009217;
        Wed, 17 Nov 2021 20:25:12 GMT
Received: from diagnostix.dwd.de (diagnostix.dwd.de [141.38.44.45])
        by ofmailhub.dwd.de (Postfix) with ESMTP id CA467E27A3;
        Wed, 17 Nov 2021 20:25:12 +0000 (UTC)
Date:   Wed, 17 Nov 2021 20:25:12 +0000 (GMT)
From:   Holger Kiehl <Holger.Kiehl@dwd.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 000/923] 5.15.3-rc3 review
In-Reply-To: <20211117101657.463560063@linuxfoundation.org>
Message-ID: <413ef3-c782-be14-da3-da86ed14a210@diagnostix.dwd.de>
References: <20211117101657.463560063@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-FE-Policy-ID: 2:2:1:SYSTEM
X-TMASE-Version: DDEI-5.1-8.6.1018-26536.002
X-TMASE-Result: 10--7.389900-10.000000
X-TMASE-MatchedRID: VfovoVrt/oaWfDtBOz4q26HggtOWAEvR69aS+7/zbj9lEv6AItKWF3YY
        S0IdBFk7zEIp4VT5Da6LQ60xZ6J3CUQb08eHfFUFMy+jMkhCdFZ02ZC6RJyIuLqq6rvK6xTaDNE
        KwYdREu7kLeKnzPvnhtj/F/70C6zbgl5Rdh8uTQFi8FpcLW8dYAD4keG7QhHm5k47RFlilVSETM
        jf6aTOJ0XgvWQOMaft4c9hRRd5/qT4kBiMXhevoceuFL5UpINxV447DNvw38bNmo0PmpP6e56ba
        /D5x6cp4vM1YF6AJbYUBfgS1SLQ+AtuKBGekqUpIG4YlbCDECtruV6hT84yE1iwJprBIi4pPo4F
        3xl8padOoNGWodxsd8Pw8mkzWoCMdp34Uj9JQqN+3BndfXUhXQ==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0
X-TMASE-INERTIA: 0-0;;;;
X-DDEI-PROCESSED-RESULT: Safe
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

On Wed, 17 Nov 2021, Greg Kroah-Hartman wrote:

> This is the start of the stable review cycle for the 5.15.3 release.
> There are 923 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Nov 2021 10:14:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.3-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
On a Deskmini X300 with a AMD APU 5700G this does not boot (rc1+rc2 also
do not boot). As Scott Bruce already noticed, if one removes
c3fc9d9e8f2dc518a8ce3c77f833a11b47865944 "x86: Fix __get_wchan() for
!STACKTRACE" it boots.

Holger
