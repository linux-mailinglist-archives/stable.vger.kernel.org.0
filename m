Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5168F6C2
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 00:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731811AbfHOWGV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 18:06:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:58342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731709AbfHOWGV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Aug 2019 18:06:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C08AB2084D;
        Thu, 15 Aug 2019 22:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565906780;
        bh=JRVBU2lBRgwV3098fyFCphIm9jw8AlXvgcZJOCDaySw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WRFhSz7rboh0PyCNEGSUGrjtBQe6rmL3TEZpkQXBlnXiscba2F5wlIJI9LA87uRVo
         xCJ+srrdn4AyhfK2B2hX2owi2A9TN4R6z3xZWye9OoH+eLKXKG6/e7HS0VbrTF4JLQ
         N+8goAx9PP0Tc2tvGu5aVmmga/0qDl1nVMyBdoKE=
Date:   Fri, 16 Aug 2019 00:06:18 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/91] 4.19.67-stable review
Message-ID: <20190815220618.GA22860@kroah.com>
References: <20190814165748.991235624@linuxfoundation.org>
 <aa683926-3df0-6f60-841a-7ea5a5e3566d@roeck-us.net>
 <CAEUSe78A6Cvt2irKzysfRSHubVxDaEGUVaLf2UF5EHzTeiOVOw@mail.gmail.com>
 <20190815193716.GG30437@kroah.com>
 <20190815202004.GA1192@roeck-us.net>
 <20190815204221.GA6782@kroah.com>
 <20190815213205.GA11036@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190815213205.GA11036@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 15, 2019 at 02:32:05PM -0700, Guenter Roeck wrote:
> On Thu, Aug 15, 2019 at 10:42:21PM +0200, Greg Kroah-Hartman wrote:
> > On Thu, Aug 15, 2019 at 01:20:04PM -0700, Guenter Roeck wrote:
> > > On Thu, Aug 15, 2019 at 09:37:16PM +0200, Greg Kroah-Hartman wrote:
> > > > On Thu, Aug 15, 2019 at 08:58:55AM -0500, Daniel Díaz wrote:
> > > > > Hello!
> > > > > 
> > > > > On Thu, 15 Aug 2019 at 08:29, Guenter Roeck <linux@roeck-us.net> wrote:
> > > > > >
> > > > > > On 8/14/19 10:00 AM, Greg Kroah-Hartman wrote:
> > > > > > > This is the start of the stable review cycle for the 4.19.67 release.
> > > > > > > There are 91 patches in this series, all will be posted as a response
> > > > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > > > let me know.
> > > > > > >
> > > > > > > Responses should be made by Fri 16 Aug 2019 04:55:34 PM UTC.
> > > > > > > Anything received after that time might be too late.
> > > > > > >
> > > > > >
> > > > > > Building x86_64:tools/perf ... failed
> > > > > > --------------
> > > > > > Error log:
> > > > > > Warning: arch/x86/include/asm/cpufeatures.h differs from kernel
> > > > > > Warning: arch/x86/include/uapi/asm/kvm.h differs from kernel
> > > > > >    PERF_VERSION = 4.9.189.ge000f87
> > > > > > util/machine.c: In function ‘machine__create_module’:
> > > > > > util/machine.c:1088:43: error: ‘size’ undeclared (first use in this function); did you mean ‘die’?
> > > > > >    if (arch__fix_module_text_start(&start, &size, name) < 0)
> > > > > >                                             ^~~~
> > > > > >                                             die
> > > > > > util/machine.c:1088:43: note: each undeclared identifier is reported only once for each function it appears in
> > > > > 
> > > > > We noticed this exact failure but not on 4.19. For us, 4.19's perf builds fine.
> > > > > 
> > > > > On 4.9, perf failed with the error you described, as it looks like
> > > > > it's missing 9ad4652b66f1 ("perf record: Fix wrong size in
> > > > > perf_record_mmap for last kernel module"), though I have not verified
> > > > > yet.
> > > > 
> > > > I've queued that up now, and will push out the 4.9-rc tree, so let's see
> > > > if that fixes it or not.
> > > > 
> > > I think you may have pushed the 4.19 branch. Sorry for the confusion
> > > I caused by attributing the problem to the wrong branch.
> > 
> > Ah, I did, good catch.  I've pushed the 4.9 one now.  At least I applied
> > the patch to the correct branch :)
> > 
> 
> Confirmed fixed with v4.9.189-42-g9a2a343109e5.

Great, thanks for testing and letting me know.

greg k-h
