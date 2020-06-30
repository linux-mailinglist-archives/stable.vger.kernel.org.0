Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E11B120F84F
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 17:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389450AbgF3PaO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 11:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbgF3PaN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 11:30:13 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24728C03E979
        for <stable@vger.kernel.org>; Tue, 30 Jun 2020 08:30:13 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id w17so17107457oie.6
        for <stable@vger.kernel.org>; Tue, 30 Jun 2020 08:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nyUf6cfwTP6F/0sIS89vazM/K+idhf9HP+ghx//rvjg=;
        b=t/gmd6IpXKesYt9ais2sfq2kidN3prFSyVkO4dMbb+CY0Efz7hJvnO7DAmpFCV2E3q
         6hd35Rsbqg2TFJ0i44Zya5OQJbQXnV3uzfkyAIjX0v58/ifvLq0E9uiMHndxu94bN0it
         sRW5KgmBJpuL2Vm7kEnRTc0Q+eZB2rGrxJPCBC/5I5xhnIDmQiwcdma1d50eBWC6PQhA
         Wxtuc7lIVxvVctclNULIpuhfBVp8bRSY5H9XRYinxqPVXsXyNkvc3pfkgKvbvvgflxJK
         irYX64x1RAbb4V0TZRWYS4AwVcYr6MaCYj7ztUWpwpSPtpdZLfWRxRBmuz8uBaaCSAmo
         NZNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nyUf6cfwTP6F/0sIS89vazM/K+idhf9HP+ghx//rvjg=;
        b=dG7hxDBrSrvAYL9B1t+q6p2TmU0Edznyue8rQPukXjcWj33D5FeU2C27ekVPEKVAwk
         +8FtYZ9E4WHCgYB5Uycg+oB0ao4H1W/xa1L//3RcIazcuFH9i63iQI+OWt/bq4NMMWZ2
         LSHFUfgd6dM4RBiSpbN1YTBhrJpZAQ0T6wJ+0mig6pWCs+anbcwwB/TNP7POkcPdp2w0
         NEvCTke4X2w/kgYU4ZN7+pG+UdVotKGkHqgZrpIVoJSAiQ3Uguq31hdciCtotYHtz4E7
         c4ImSJpmoWsMx/0jB+v3F7nbaqVYmZBjJ4K/F3fqAmPaqhiqNGg8ZaLiPICXTEnRy7dC
         2HTg==
X-Gm-Message-State: AOAM530CeTE90JFKecoKszeDjz0cBbe1gKlkPmacqRcYRF6t5GW7QYU/
        lQCrQ2SnpDjtrGOfv+FF+LDugLuVJLw0mNXDwM8OyQ==
X-Google-Smtp-Source: ABdhPJyQGmmmDFoOPvgvYJkxPP/1pSq4974sqlsUOtnk4Nrye5czsSfSSUFDlKHjlrNaN7eDXd2BVXrtnYwyAEGaNoY=
X-Received: by 2002:aca:5fd7:: with SMTP id t206mr13859541oib.161.1593531012384;
 Tue, 30 Jun 2020 08:30:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200629151818.2493727-1-sashal@kernel.org> <42dadde8-04c0-863b-651a-1959a3d85494@linuxfoundation.org>
 <20200629231826.GT1931@sasha-vm> <20200630083845.GA637154@kroah.com> <20200630151248.GY1931@sasha-vm>
In-Reply-To: <20200630151248.GY1931@sasha-vm>
From:   =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date:   Tue, 30 Jun 2020 10:30:01 -0500
Message-ID: <CAEUSe79iN_4=QVVgjdxEJ=pGFLVO2HPXsCxdYFE54hvME7TooA@mail.gmail.com>
Subject: Re: [PATCH 5.7 000/265] 5.7.7-rc1 review
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On Tue, 30 Jun 2020 at 10:12, Sasha Levin <sashal@kernel.org> wrote:
>
> On Tue, Jun 30, 2020 at 10:38:45AM +0200, Greg Kroah-Hartman wrote:
> >On Mon, Jun 29, 2020 at 07:18:26PM -0400, Sasha Levin wrote:
> >> On Mon, Jun 29, 2020 at 02:37:53PM -0600, Shuah Khan wrote:
> >> > Hi Sasha,
> >> >
> >> > On 6/29/20 9:13 AM, Sasha Levin wrote:
> >> > >
> >> > > This is the start of the stable review cycle for the 5.7.7 release=
.
> >> > > There are 265 patches in this series, all will be posted as a resp=
onse
> >> > > to this one.  If anyone has any issues with these being applied, p=
lease
> >> > > let me know.
> >> > >
> >> > > Responses should be made by Wed 01 Jul 2020 03:14:48 PM UTC.
> >> > > Anything received after that time might be too late.
> >> > >
> >> > > The whole patch series can be found in one patch at:
> >> > >  https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git/patch/?id=3Dlinux-5.7.y&id2=3Dv5.7.6
> >> > >
> >> >
> >> > Looks like patch naming convention has changed. My scripts look
> >> > for the following convention Greg uses. Are you planning to use
> >> > the above going forward? My scripts failed looking for the usual
> >> > naming convention.
> >> >
> >> > The whole patch series can be found in one patch at:
> >> >    https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.7.6-rc1.gz
> >> > or in the git tree and branch at:
> >> >    git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.7.y
> >> > and the diffstat can be found below.
> >>
> >> Sorry for that. I was hoping to avoid using the signed upload mechanis=
m
> >> Greg was using by simply pointing the links to automatically generated
> >> patches on cgit (the git.kernel.org interface).
> >>
> >> Would it be ok to change the pattern matching here? Something like thi=
s
> >> should work for both Greg's format and my own (and whatever may come
> >> next):
> >>
> >>      grep -A1 "The whole patch series can be found in one patch at:" |=
 tail -n1 | sed 's/\t//'
> >
> >If those don't work, I can still push out -rc1 patches.
> >
> >It might be best given that the above -rc.git tree is unstable and can,
> >and will, change, and patches stored on kernel.org will not.
>
> That's a good point. Maybe we should push tags for -rc releases too?

That would be GREAT for those CI's or processes looking for a definite
trigger to use.

Greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org
