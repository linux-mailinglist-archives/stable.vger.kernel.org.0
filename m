Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27CCD8F5A7
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 22:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728283AbfHOUUH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 16:20:07 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42146 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbfHOUUH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Aug 2019 16:20:07 -0400
Received: by mail-pl1-f193.google.com with SMTP id y1so1474319plp.9;
        Thu, 15 Aug 2019 13:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=o2UWdztwplU/Oa1kfd6r7OmeKvX4UXnDDSltXMGR7mk=;
        b=HERjNASn6U/yQLL/FwhOJPOUPyzN1YZk4vPSJFbyW3I2tXxR7Izz0NTnh9d9rc/UNZ
         2MB1ZD9zV/GoEeIL3ps2/ACbf8e3uEgJTAAMmVhSQmp/mU+wRWHDH+V/my0Q+1KsH32X
         WhaeRgL/r+5MA1QFzBn1lUUmio8SfrpLZRx4IdtG3u4gAC4K7pCMYMkB5dfhq7uZtj/m
         4SRlxzjLjtLLAAxUdZiA1UbM6x7vSkNGbkjTCX1ne5Y0++3lz1JDr9EmAwoEE1k7ldea
         df2h/tXbn0DlrG+WVyTmU43wfh30BvekblVRqCP9siUJ6aR2w5SPl6TRDgIW5PSB22aP
         ZDbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=o2UWdztwplU/Oa1kfd6r7OmeKvX4UXnDDSltXMGR7mk=;
        b=mlLjZXjw0ePK+i9JdWApGvWazuq8XlnMa83JmuN53uq/m5p9Ls2lJ/SftBEz3C7VLv
         97hK2AHSLw5AucH73tAh9EZElHdKDSKkMffePiDIVB2TXFwI54Z9cpQDPzIswIUtk7Co
         xEw34RJNJsmVE9XgeJsApK3Y5/0MZV7OVxvZgJQNm3JcAGcP6hA/OlucNEXBkl71uRen
         vzvx+O6iPfXHKq+tsNtd+nUt5LOk7oZoqjmgVsEBpZ1baZCMr/8yi9F/51PuhwkT6+un
         ADijrlZFVn0RJPVwLJs75+byN5K8c0lXYX67utZ5TgHQMOUbLPmcJzwbBVQlQt3Wu5Tf
         2AuA==
X-Gm-Message-State: APjAAAVFUb575hMwhSI/ouL8AFdbrGL3UCxDA1V+c+bWYZhyxzAW9SCX
        ehizZOH591vGDn79Fk5ieCs=
X-Google-Smtp-Source: APXvYqwIUAUZiQiAkHR6XU40ULaLm+qv2NzyL1/NUZ1aKZzMP4iSpQViJ6vPFmXxL9l5MIrW8owBzg==
X-Received: by 2002:a17:902:b48c:: with SMTP id y12mr5837510plr.202.1565900406391;
        Thu, 15 Aug 2019 13:20:06 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 33sm2825038pgy.22.2019.08.15.13.20.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 13:20:05 -0700 (PDT)
Date:   Thu, 15 Aug 2019 13:20:04 -0700
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
Message-ID: <20190815202004.GA1192@roeck-us.net>
References: <20190814165748.991235624@linuxfoundation.org>
 <aa683926-3df0-6f60-841a-7ea5a5e3566d@roeck-us.net>
 <CAEUSe78A6Cvt2irKzysfRSHubVxDaEGUVaLf2UF5EHzTeiOVOw@mail.gmail.com>
 <20190815193716.GG30437@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190815193716.GG30437@kroah.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 15, 2019 at 09:37:16PM +0200, Greg Kroah-Hartman wrote:
> On Thu, Aug 15, 2019 at 08:58:55AM -0500, Daniel Díaz wrote:
> > Hello!
> > 
> > On Thu, 15 Aug 2019 at 08:29, Guenter Roeck <linux@roeck-us.net> wrote:
> > >
> > > On 8/14/19 10:00 AM, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 4.19.67 release.
> > > > There are 91 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Fri 16 Aug 2019 04:55:34 PM UTC.
> > > > Anything received after that time might be too late.
> > > >
> > >
> > > Building x86_64:tools/perf ... failed
> > > --------------
> > > Error log:
> > > Warning: arch/x86/include/asm/cpufeatures.h differs from kernel
> > > Warning: arch/x86/include/uapi/asm/kvm.h differs from kernel
> > >    PERF_VERSION = 4.9.189.ge000f87
> > > util/machine.c: In function ‘machine__create_module’:
> > > util/machine.c:1088:43: error: ‘size’ undeclared (first use in this function); did you mean ‘die’?
> > >    if (arch__fix_module_text_start(&start, &size, name) < 0)
> > >                                             ^~~~
> > >                                             die
> > > util/machine.c:1088:43: note: each undeclared identifier is reported only once for each function it appears in
> > 
> > We noticed this exact failure but not on 4.19. For us, 4.19's perf builds fine.
> > 
> > On 4.9, perf failed with the error you described, as it looks like
> > it's missing 9ad4652b66f1 ("perf record: Fix wrong size in
> > perf_record_mmap for last kernel module"), though I have not verified
> > yet.
> 
> I've queued that up now, and will push out the 4.9-rc tree, so let's see
> if that fixes it or not.
> 
I think you may have pushed the 4.19 branch. Sorry for the confusion
I caused by attributing the problem to the wrong branch.

Guenter
