Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4F78F66C
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 23:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730573AbfHOVcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 17:32:08 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38538 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730302AbfHOVcI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Aug 2019 17:32:08 -0400
Received: by mail-pl1-f195.google.com with SMTP id m12so1549093plt.5;
        Thu, 15 Aug 2019 14:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=Idm/sRzCLkJoZ8POkQj4Iwvd94HkK/rVkPPXXGAJ/gM=;
        b=u56HSM/EnOPuGAMgd3co6Hm10P3MOchXfnSEoF1hUb+ke3OKHHcFEZQ25KHXFMjGuV
         a5Mrkt8noBS+ws7JcTfqZxAJZOD/qo0ChjH6S8ykJf/V6jACR+8EuBcZrY3WLdEggylE
         IvGRdpEqDPjgIDoOdQe9Y5/7qbF4SO4qrAlxZvsVZt/Gk9tTk+j07KBMUwXQtDgigHzo
         0SQ+ahsslBNYC6B/TE2ehCxHcurlQYvH+UmCbayXlBRCRK8JCj3UTAwHePkHxS+fOtRz
         16Am/xyT9K20LFzV38swneROVGRhK9QVYOvDW20JA7qjLNhtNY/tTmiweiXTr8JRUMy/
         248A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=Idm/sRzCLkJoZ8POkQj4Iwvd94HkK/rVkPPXXGAJ/gM=;
        b=YUH9GGj5RAmQyXF1xXOkgnQBKoP88plMaLC3NE6Dtoo+vqHCEPqVgVZ6v3VgYokK9E
         CiNlH2TAF8zAdrQYfMd8B8rayzIr1atsZqAHt4H80pEyd9n65cHlyNwCLzJXEFS/YdjW
         Ejy4E0fqt/3ewMWUdTk8X7WugHXF7FJF++ebkzUle/PljMT1k0g33DyBlUjqPTxtoMLi
         e87uguo+mSm09D+x2UykBuWQDieS8PW93CwSNR4hdG3/qHOdtcRxWXu2D9eyQ4kikka4
         whIH5xcUvni3OHpwd94xKGpReHxEbspisEtApmE8qxp+kNsFmnK4m26L4mDDLAqgPgl8
         WjYg==
X-Gm-Message-State: APjAAAWsai5/ypVnho4p0zCoHJ2lmMCvzkWqahKM4Q0jajb7zjAvuodF
        hmR7x6p1KjgLoFW3DykP5+o=
X-Google-Smtp-Source: APXvYqziOjk3Xl0b8pqfMGrWTSSZIcTHcdtskiYehLF7hfSEwzslPPVAR2Bzc0JrQZhYG/CN+MvTtw==
X-Received: by 2002:a17:902:8d95:: with SMTP id v21mr6207993plo.267.1565904727851;
        Thu, 15 Aug 2019 14:32:07 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x128sm4481147pfd.52.2019.08.15.14.32.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 14:32:06 -0700 (PDT)
Date:   Thu, 15 Aug 2019 14:32:05 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/91] 4.19.67-stable review
Message-ID: <20190815213205.GA11036@roeck-us.net>
References: <20190814165748.991235624@linuxfoundation.org>
 <aa683926-3df0-6f60-841a-7ea5a5e3566d@roeck-us.net>
 <CAEUSe78A6Cvt2irKzysfRSHubVxDaEGUVaLf2UF5EHzTeiOVOw@mail.gmail.com>
 <20190815193716.GG30437@kroah.com>
 <20190815202004.GA1192@roeck-us.net>
 <20190815204221.GA6782@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190815204221.GA6782@kroah.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 15, 2019 at 10:42:21PM +0200, Greg Kroah-Hartman wrote:
> On Thu, Aug 15, 2019 at 01:20:04PM -0700, Guenter Roeck wrote:
> > On Thu, Aug 15, 2019 at 09:37:16PM +0200, Greg Kroah-Hartman wrote:
> > > On Thu, Aug 15, 2019 at 08:58:55AM -0500, Daniel Díaz wrote:
> > > > Hello!
> > > > 
> > > > On Thu, 15 Aug 2019 at 08:29, Guenter Roeck <linux@roeck-us.net> wrote:
> > > > >
> > > > > On 8/14/19 10:00 AM, Greg Kroah-Hartman wrote:
> > > > > > This is the start of the stable review cycle for the 4.19.67 release.
> > > > > > There are 91 patches in this series, all will be posted as a response
> > > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > > let me know.
> > > > > >
> > > > > > Responses should be made by Fri 16 Aug 2019 04:55:34 PM UTC.
> > > > > > Anything received after that time might be too late.
> > > > > >
> > > > >
> > > > > Building x86_64:tools/perf ... failed
> > > > > --------------
> > > > > Error log:
> > > > > Warning: arch/x86/include/asm/cpufeatures.h differs from kernel
> > > > > Warning: arch/x86/include/uapi/asm/kvm.h differs from kernel
> > > > >    PERF_VERSION = 4.9.189.ge000f87
> > > > > util/machine.c: In function ‘machine__create_module’:
> > > > > util/machine.c:1088:43: error: ‘size’ undeclared (first use in this function); did you mean ‘die’?
> > > > >    if (arch__fix_module_text_start(&start, &size, name) < 0)
> > > > >                                             ^~~~
> > > > >                                             die
> > > > > util/machine.c:1088:43: note: each undeclared identifier is reported only once for each function it appears in
> > > > 
> > > > We noticed this exact failure but not on 4.19. For us, 4.19's perf builds fine.
> > > > 
> > > > On 4.9, perf failed with the error you described, as it looks like
> > > > it's missing 9ad4652b66f1 ("perf record: Fix wrong size in
> > > > perf_record_mmap for last kernel module"), though I have not verified
> > > > yet.
> > > 
> > > I've queued that up now, and will push out the 4.9-rc tree, so let's see
> > > if that fixes it or not.
> > > 
> > I think you may have pushed the 4.19 branch. Sorry for the confusion
> > I caused by attributing the problem to the wrong branch.
> 
> Ah, I did, good catch.  I've pushed the 4.9 one now.  At least I applied
> the patch to the correct branch :)
> 

Confirmed fixed with v4.9.189-42-g9a2a343109e5.

Thanks,
Guenter
