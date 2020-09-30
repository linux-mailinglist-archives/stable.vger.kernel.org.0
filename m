Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC7D27EF4D
	for <lists+stable@lfdr.de>; Wed, 30 Sep 2020 18:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730188AbgI3Qew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Sep 2020 12:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgI3Qev (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Sep 2020 12:34:51 -0400
Received: from mail-oo1-xc42.google.com (mail-oo1-xc42.google.com [IPv6:2607:f8b0:4864:20::c42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C52C061755;
        Wed, 30 Sep 2020 09:34:51 -0700 (PDT)
Received: by mail-oo1-xc42.google.com with SMTP id c4so654252oou.6;
        Wed, 30 Sep 2020 09:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=VWWAGJm9rimHcsRFoodpvDtDTUyjS3Guu3yZDjccOI0=;
        b=ovVfb3ISieuyDlTmMMwXDOXmKs73RVvNAJMp1MVbGfx/CHPT8OpNP5WP3AZj2nn5yV
         9zBXz1ZkCUkJHM1YNJFjZ/DnqXU5X4FODf5di7hdrrC/7uq7XfgFClP1IB3SpG32LGBc
         4X22SAD3gSuUYZ5pT06uU6otVhBwiMIHX1Xqyc+NWsZHlZKKdDmh0vDGXjiJg+fh4UGA
         bIe735ziO2vdRk45j2RlElPMXTMLOkAFOIjlhYIX3EUaO5CgD7d3bhJlxbCxYbE++WbL
         s0Ynl65K7EU4C0jWL7Vmx9Pugab2fQVBkst+yyS6qoXRi24EqtMQ4GAEBHtvbBxu4KR+
         jQUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=VWWAGJm9rimHcsRFoodpvDtDTUyjS3Guu3yZDjccOI0=;
        b=oLPqfacMM6wjjQYzzUSThMvpaOA3z5CqacOt7hgskPFvT89V8ZjZnAD3H6v2sjezFc
         OT+ER06Vdlok9oFqogIKorORy5El/OxAm7P/qn20ff1q2gAVapcnWgNu46oBcshtrVjf
         rPpdOH3MHNz2//KyrXqPXGZFCM/J/vLb3IOUTQB6B66s2wCBokLmBq0OVQNUwO98UOYS
         0J7gzKden/sF8kKgEylykweVDyjtDQaSSxzarL6jm4/tBaZERZxi9CAlFHgiV+bV/iHV
         e2uVTfo4fWoT+GXW088KhN0eZvBWnyMGIPvfN3E5ZdAc5nwq3vEJ6pGA8eK0WFDojboz
         RinQ==
X-Gm-Message-State: AOAM532y0LBzBt7f12HWGogL9hxplmeeyX6iddXJwHeTfAFNiVUt6ePg
        Vj0JMYJQ5RuIQWIB6rb4R5w=
X-Google-Smtp-Source: ABdhPJwDfhoBLez1J/Xuq76KiOW9S/g/WU5LnzTpfDwWEDSsgBRcd8d/pop7/bvttThEL1mEGGFZ8w==
X-Received: by 2002:a4a:dc06:: with SMTP id p6mr2586915oov.10.1601483691155;
        Wed, 30 Sep 2020 09:34:51 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u9sm508246otq.54.2020.09.30.09.34.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 30 Sep 2020 09:34:50 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 30 Sep 2020 09:34:48 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        linux- stable <stable@vger.kernel.org>
Subject: Re: [PATCH 4.19 000/244] 4.19.149-rc2 review
Message-ID: <20200930163448.GA219887@roeck-us.net>
References: <20200929142826.951084251@linuxfoundation.org>
 <CA+G9fYup1i8WnQpcg28hkq9jgQTTkuiiEfOVSnm_3wS-1sijiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYup1i8WnQpcg28hkq9jgQTTkuiiEfOVSnm_3wS-1sijiA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 30, 2020 at 09:26:48PM +0530, Naresh Kamboju wrote:
> On Tue, 29 Sep 2020 at 19:59, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.19.149 release.
> > There are 244 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 01 Oct 2020 14:27:43 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.149-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.
> 
No perf build failure ? I just tried again, with a simple

make defconfig
make tools/perf

on my test system, and it fails to build reliably with

util/evsel.c: In function ‘perf_evsel__exit’:
util/util.h:25:28: error: passing argument 1 of ‘free’ discards ‘const’ qualifier from pointer target type

as reported. The culprit is commit d22b67e7dae9 ("perf parse-events: Fix 3
use after frees found with clang ASAN"). That is not a problem upstream because
of commit 7f7c536f23e6af ("tools lib: Adopt zalloc()/zfree() from tools/perf"),
but that is just hiding a problem with commit d22b67e7dae9 (which assigns a
pointer allocated with strdup() to a const * and then frees that const *). 

Anyway, how comes that only I seem to see that problem ?

Guenter
