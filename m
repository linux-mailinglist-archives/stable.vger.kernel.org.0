Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AEC03303ED
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 19:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbhCGS31 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 13:29:27 -0500
Received: from mout.gmx.net ([212.227.15.15]:57293 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230490AbhCGS2x (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Mar 2021 13:28:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1615141731;
        bh=AA3oll232oAM4NgcVd58SLTWpiQBPc298oF/ynG5yPU=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=PZXEcXA+CCotKx902NUF4f3BL5DyqOUFURRhTOz7T6aMaEDolxUVTvbZDIG88xSZf
         SkecRTXvsqzbeGmEUTtyevY9hv3Dj3q1wtk88m+gcNMcnx92Yp+l1ivZ5NpwQO8yLv
         I18AIx8o18j7idI6FsxlfhjyH+8guv25SQHxR/xI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from obelix.fritz.box ([46.142.7.203]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MyKHm-1lgFjT0YYO-00ylDT; Sun, 07
 Mar 2021 19:28:51 +0100
Subject: Re: stable kernel checksumming fails
To:     Greg KH <gregkh@linuxfoundation.org>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <d58ab27a-78ad-1119-79ac-2a1fbcd3527a@gmx.de>
 <YETm+6sQqek6kY/A@kroah.com>
 <20210307154354.qbbsy355d5zfubnf@chatter.i7.local>
 <YET1uTT61awy0X6S@kroah.com>
From:   Ronald Warsow <rwarsow@gmx.de>
Message-ID: <aecc936c-8b3e-db08-0e5b-c5a86329c496@gmx.de>
Date:   Sun, 7 Mar 2021 19:28:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <YET1uTT61awy0X6S@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:cWwBiLnWj8WSV+349nhHsaYGXVvZJFdJMnWOE9yhu/1AB5vFvwn
 yzGyZT9tYYHz6CCsdBY61+wQMCQWD0pP7vbdztJn241gzXPSDVC8+fQ6LybZ0QI0BWTZt98
 zpKEF5MNJiC0ZVQW6E5ClU5ATYfqqlv5n6fYI9mCKaMqw1REfeCsdDqHejBYJbDrruEg3zB
 Px0YoSZUNyUjxOOXpZw7w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:dBy86r2sZQA=:aHWpRExCJJn1R6WPKVstSN
 B5CmWm2iuC9J2rkaTRhblkXomPN+b2uNuiYMdc0NF3eEyJD8jM1hODkccDZW2wSEMbnNoKBMH
 J85jEA/U1mDf0i+hWvz0pFJrTjCGRTglFlnvXPGmA2J7ywOU4lMmr4EPJRpVSA97JH/e2IwWx
 dTN3zd/AWlGwQ1vR7qLew6+ww1SvMFdsZ3sBsvg5P/r7bCpdHTQoWPIEl+8/NQCapdiKrXsTW
 Y1IoxMxYATxxvxvARizbpQQAC0bWpDTkCA08witC36aIPsfbfHUk8QcKmoUdDNPCH47vZvvg3
 5sGGm2hw40qLVhpt5JykEHWnOy71NIb1DcA2OcKacKA1fZffmFgUoam/KuY12NQ5MN+UQmO+/
 OPF8wK0kenNWxuU4C0puYxiGxP0wQEImjCdyMNt/KN9MeHSpc0Rfw0DB/C3SFweeLB0m9XRMM
 zSzNJ4n4rAAFEWST7nu9K3TV/BPxaGe8Ycw57FVNwRe02z3bzspljQ1Qp7hEm7Rc+4BwmFGpQ
 nbNRK04NHih7Es1bI/XfQtnuAaC+dX7kdqPaoTq+JuRjLKuaGk0j5ZO2wW2unjqTTbB99RztU
 WJuYL1CT78gG0d9KXlnhgFIeVuyAn37eWoIB7Jm/n0p+cSiiw7nhukkFXUJVUfKrCxI6DURaX
 PMMZMJgYDiRRNfZdrWTU/ae0xR7iT1Tk3P2JuorAof0yulR+ZjZByZtSeiqKIHUoYTwPyzB7B
 mRxmoZMieYNm3kuSbG2JXOecH0HSSn3P0ugW26xbt2/N4a88ToDe/g6kjWExd3OYzlus+TM4o
 5myt7jqGUVTvN+OuGuEqNAJ3DpWHujf7zmv/SWYTDZ0MFsMzlbIvmw3zDKNs4YIBH9ij206SB
 SSIKnclrqffBpToF0uEA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07.03.21 16:48, Greg KH wrote:
> On Sun, Mar 07, 2021 at 10:43:54AM -0500, Konstantin Ryabitsev wrote:
>> On Sun, Mar 07, 2021 at 03:45:15PM +0100, Greg KH wrote:
>>>> checksumming the downloaded kernel manually gives an "Okay" though.
>>>>
...
>>
>> I think it's just cache invalidation problems. I've committed a tiny ch=
ange to
>> the script that always grabs that file from the origin servers instead =
of
>> going via the CDN.
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/mricon/korg-helpers.git=
/commit/?id=3D71e570c5f090b5740e323f98504bf38592785b49
>>
>> This should sidestep the problem.
>>
>> -K
>
> Nice, fixed it for me, thanks!
>
> Ronald, does it now work for you too?
>
> greg k-h
>

yes, all is fine again.

thanks all !

=2D-
regards

Ronald
