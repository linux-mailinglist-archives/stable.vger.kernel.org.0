Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC6B9A0754
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 18:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbfH1Q2F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 12:28:05 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:37102 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbfH1Q2F (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Aug 2019 12:28:05 -0400
Received: by mail-io1-f66.google.com with SMTP id q12so778624iog.4
        for <stable@vger.kernel.org>; Wed, 28 Aug 2019 09:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=DWF7e2bDSvfGCzFYsBMfho5xqWg50eDkeO/ScBoUZp0=;
        b=IU822D7TVDucd9MFxsbHUAEQCrU7kEyC724Kznm7x6lbVsTuy5UQuZOBqIa68XImB3
         MFkA/vvh4+X9ZgsRpw+DamLxMq7Uk6Vh9cBIz0fkSIy0TFHd85FU+jUPecCF/Yg+99bx
         qnVOmijT+QmKwlwZPngjUqPIskhwibOUGZZ0QH3X45jJAuUbAh4Ibe5M0d5Uw1XWA/wR
         Cw89fWVV8vPaedD9vD72b9P5I1//gY5j0aY2ZVLf/9QEiQM2ans5WNEUk7bNFvJYwY3a
         KcjzMX8mYAfOReABXhGb2tlwAg5Y96uc3j+gfY5WstFbC/uw7qTYTfdRA0iCzSh+mWkL
         Mr6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=DWF7e2bDSvfGCzFYsBMfho5xqWg50eDkeO/ScBoUZp0=;
        b=kLZv9G+9BPL9pJ2kwdvh82QnHo/SqC7QYIbcS5kvMU1tiEqOZ4+qhYMoSno1wFxZqc
         kgl7odHyDzn5l5nG7ElZVKQjJgZ9W3T+OddiZG9RhzhCUmHj2RhIdOJ8ZwuLF1uIbSek
         Wo7njml1Gsf+GcIoB59PUBuFKSiSzWDKEzd8YaCfgvOmS5Eg/WOCYhPsg4hOJXaROdTq
         NoD1VJ+MeeOqS0+ko+IAQL0MnmIjsQrQsonByimqcbfDhYKB0ZQQubnuqAWwlXEF3/4Y
         9WOK0eTr5TpaZgFJGnWTCkev/FvZGIRdxQHPDTuNHdjfo9Ofc2uls9m8BrB/QhVXnBXN
         O2VA==
X-Gm-Message-State: APjAAAUNX5NSudJY5uwAqshQg4eQOi3uVhgI0mCf2aPS/c3j/IZAZ9wx
        lY8BqVdtUAHbQOG4zX5ChVLyodMtaCs=
X-Google-Smtp-Source: APXvYqzDoH7863KYVnQupGjLzVlmLS9MP22RC3J0KxmKi3J6P4R+VvNoyyuFPvUjGTePR9wRyAprWg==
X-Received: by 2002:a05:6602:c7:: with SMTP id z7mr5677282ioe.130.1567009684373;
        Wed, 28 Aug 2019 09:28:04 -0700 (PDT)
Received: from localhost (c-75-72-120-115.hsd1.mn.comcast.net. [75.72.120.115])
        by smtp.gmail.com with ESMTPSA id w6sm2585972iob.29.2019.08.28.09.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 09:28:03 -0700 (PDT)
Date:   Wed, 28 Aug 2019 11:28:02 -0500
From:   Dan Rue <dan.rue@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Major Hayden <major@mhtx.net>
Subject: Re: [PATCH 5.2 000/162] 5.2.11-stable review
Message-ID: <20190828162802.jdbrylm3dai3kaw7@xps.therub.org>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, Shuah Khan <shuah@kernel.org>,
        patches@kernelci.org, Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Major Hayden <major@mhtx.net>
References: <20190827072738.093683223@linuxfoundation.org>
 <CA+G9fYtmHsr8XWvmSLy9QKvF37KfZ4v+T1VnRy2uhpE0HB4Ggg@mail.gmail.com>
 <20190828151608.GC9673@kroah.com>
 <20190828154718.nesaolp7gfxxh5o5@xps.therub.org>
 <20190828155252.GA3803@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190828155252.GA3803@kroah.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 28, 2019 at 05:52:52PM +0200, Greg Kroah-Hartman wrote:
> On Wed, Aug 28, 2019 at 10:47:18AM -0500, Dan Rue wrote:
> > On Wed, Aug 28, 2019 at 05:16:08PM +0200, Greg Kroah-Hartman wrote:
> > > On Wed, Aug 28, 2019 at 10:30:09AM +0530, Naresh Kamboju wrote:
> > > > On Tue, 27 Aug 2019 at 13:30, Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > >
> > > > > This is the start of the stable review cycle for the 5.2.11 release.
> > > > > There are 162 patches in this series, all will be posted as a response
> > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > let me know.
> > > > >
> > > > > Responses should be made by Thu 29 Aug 2019 07:25:02 AM UTC.
> > > > > Anything received after that time might be too late.
> > > > >
> > > > > The whole patch series can be found in one patch at:
> > > > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.11-rc1.gz
> > > > > or in the git tree and branch at:
> > > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> > > > > and the diffstat can be found below.
> > > > >
> > > > > thanks,
> > > > >
> > > > > greg k-h
> > > > 
> > > > Results from Linaro’s test farm.
> > > > No regressions on arm64, arm, x86_64, and i386.
> > > 
> > > Thanks for testing all of these and letting us know.
> > > 
> > > Also, how did you all not catch the things that the redhat ci system was
> > > catching that caused us to add another networking aptch?
> > 
> > Hi Greg -
> > 
> > I'll follow up with them off list. That said, I expect different CI
> > setups to find different issues - that's the point, after all. It would
> > be bad if we all ran the exact same things, and found the exact same
> > things, because then we'd also miss the exact same things. In the macro
> > sense, there is a lot to test, and I would rather see CI teams go after
> > areas that are weak, rather than areas that are well covered.
> 
> I totally agree, but here we actually have a known failure (for once!)
> so it would be nice to see why the very large test suite that you all
> run missed this.

OK, so it seems the following two tests failed for them[0]:

>          ❌ Networking socket: fuzz [9]
>          ❌ Networking sctp-auth: sockopts test [10]

fuzz[1] seems to be a redhat test that was added to tests-beaker on May
20th this year. Similarly, sockopts[2] was added on May 7th.

We don't run tests-beaker. Maybe we should?

Major is coming to Linaro Connect in a few weeks to talk about CKI[3].
Topics such as test coverage and test suites are on our agenda to
discuss.

Hope that helps,
Dan

[0] https://lore.kernel.org/stable/291770ce-273a-68aa-a4a2-7655cbea2bcc@mhtx.net
[1] https://github.com/CKI-project/tests-beaker/commit/a454fdeaada71f7f193ae00e505621bf4a8ed8c6
[2] https://github.com/CKI-project/tests-beaker/commit/4ebc85dae5042cc2b70c98a868f3b3501eec1e08
[3] https://linaroconnectsandiego.sched.com/event/Suco/san19-416-transforming-kernel-developer-workflows-with-cicd


> 
> thanks,
> 
> greg k-h

-- 
Linaro - Kernel Validation
