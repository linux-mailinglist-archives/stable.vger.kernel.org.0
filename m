Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A057E8F4C4
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 21:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728547AbfHOThT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 15:37:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728283AbfHOThT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Aug 2019 15:37:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F373F206C1;
        Thu, 15 Aug 2019 19:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565897838;
        bh=8dvvdp0Gy36K9ppzyUBCW8xdCX9c7dGKhzu7YsGsUt4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UVrjHPkP0CDRnalQJA2BQal0yU5qoYu7w/mhsvKchZIPpjEFFPRrrh4rqZQRdQv8V
         eq35222rGDubTD08xehGAhVjq2e3QL9DClifPZytR7uGy0tBOkQSsk9L4Vj0/EHvHb
         HwenyvggHagxTTTEpXxPULrNxX6rPUB7VV02jgCo=
Date:   Thu, 15 Aug 2019 21:37:16 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        open list <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/91] 4.19.67-stable review
Message-ID: <20190815193716.GG30437@kroah.com>
References: <20190814165748.991235624@linuxfoundation.org>
 <aa683926-3df0-6f60-841a-7ea5a5e3566d@roeck-us.net>
 <CAEUSe78A6Cvt2irKzysfRSHubVxDaEGUVaLf2UF5EHzTeiOVOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEUSe78A6Cvt2irKzysfRSHubVxDaEGUVaLf2UF5EHzTeiOVOw@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 15, 2019 at 08:58:55AM -0500, Daniel Díaz wrote:
> Hello!
> 
> On Thu, 15 Aug 2019 at 08:29, Guenter Roeck <linux@roeck-us.net> wrote:
> >
> > On 8/14/19 10:00 AM, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 4.19.67 release.
> > > There are 91 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Fri 16 Aug 2019 04:55:34 PM UTC.
> > > Anything received after that time might be too late.
> > >
> >
> > Building x86_64:tools/perf ... failed
> > --------------
> > Error log:
> > Warning: arch/x86/include/asm/cpufeatures.h differs from kernel
> > Warning: arch/x86/include/uapi/asm/kvm.h differs from kernel
> >    PERF_VERSION = 4.9.189.ge000f87
> > util/machine.c: In function ‘machine__create_module’:
> > util/machine.c:1088:43: error: ‘size’ undeclared (first use in this function); did you mean ‘die’?
> >    if (arch__fix_module_text_start(&start, &size, name) < 0)
> >                                             ^~~~
> >                                             die
> > util/machine.c:1088:43: note: each undeclared identifier is reported only once for each function it appears in
> 
> We noticed this exact failure but not on 4.19. For us, 4.19's perf builds fine.
> 
> On 4.9, perf failed with the error you described, as it looks like
> it's missing 9ad4652b66f1 ("perf record: Fix wrong size in
> perf_record_mmap for last kernel module"), though I have not verified
> yet.

I've queued that up now, and will push out the 4.9-rc tree, so let's see
if that fixes it or not.

thanks,

greg k-h
