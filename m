Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8A69110348
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 18:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbfLCRTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 12:19:09 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:41842 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbfLCRTJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Dec 2019 12:19:09 -0500
Received: by mail-pj1-f67.google.com with SMTP id ca19so1770435pjb.8
        for <stable@vger.kernel.org>; Tue, 03 Dec 2019 09:19:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MvGhtCxlwLUh97Cz2ry0QgTVu+ycAwIVFhXukCE3WHw=;
        b=NRAKz0WYFeSsTW7sQYsEO9cAPksmC1APLkA78GnFHzeU64EUVVMDCrMjsd/u7hrGB8
         jqv6BLcA/gAkRzmg1sLh4x848HaT6bt55YmhKvD3KBjlSz66neYY5qYfYP7RR51/wASN
         g1qzXaRqtA5+SCrEZbXtYw1jjMnOHGMFftYnS22r6DY/3FxcP+ObUasjStXQeMyfZyJB
         UcH1cL1nisAoc/NeFKR9p8NaMIDe2L2Ang3NyQjbqIcMchuAXuTEUBngrf59d12A+p2W
         rn5SQsVlOGjRNcm1KyHRVQpIXhDA2Qbj6FgTMdit0Efp+M/pBLSCl6xIUwne+wqTb7Qm
         HgZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MvGhtCxlwLUh97Cz2ry0QgTVu+ycAwIVFhXukCE3WHw=;
        b=N+q/bEdLaw23cugfKKPRM4K1YoFcQboQSvxX4+4HYk+FSnsDzL8zvZ14AP/vqqs4ZV
         ntvadwvtW5dcZBhQRM1sjgk8A8aRtvFLLiJSvkCI89kh3OSWjlUCMUpODTF/QIJkgdCk
         jNTnUMgcjp4NUhr1XEPK9GSlIX8Snk5GC0OXMk8hDVE/8R5+0XavsO8ZJG5eLE1NQ6fE
         LakpXUpe2m/3rJYrNF83cU4OUt/n0L+/MrQzwdYhmoYjkzz5At0WHK4slUqCVjXQh390
         Mi8nVQ7MdW1/8jfWgQd657kNJo5KXQd2UUqneK9WTeXdlH8yAmWEr5ETIy3EDk8yRJvu
         YZ2A==
X-Gm-Message-State: APjAAAVSPn73IJfjuMQBgBJzAIg1BThtnUSM596z3pOZ0csW/68Mbemq
        CmzpjgANbht3fblCRo6LeUtGGA2K
X-Google-Smtp-Source: APXvYqwFc2PUJx9UYGq4eyzwDy81JnlRsVXxg16uGDygWBDacxMn66NcfGmUEJqjbMPKy32W0dCnug==
X-Received: by 2002:a17:902:8c96:: with SMTP id t22mr6077956plo.288.1575393548224;
        Tue, 03 Dec 2019 09:19:08 -0800 (PST)
Received: from workstation-portable ([139.5.253.93])
        by smtp.gmail.com with ESMTPSA id v10sm4044002pgr.37.2019.12.03.09.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 09:19:07 -0800 (PST)
Date:   Tue, 3 Dec 2019 22:48:17 +0530
From:   Amol Grover <frextrite@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [STABLE TEST] 5.3.13
Message-ID: <20191203171817.GA24581@workstation-portable>
References: <20191203062503.GA3467@workstation-kernel-dev>
 <20191203064052.GA1788679@kroah.com>
 <20191203071415.GA9640@workstation-portable>
 <20191203120304.GA2126088@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191203120304.GA2126088@kroah.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 03, 2019 at 01:03:04PM +0100, Greg KH wrote:
> On Tue, Dec 03, 2019 at 12:44:15PM +0530, Amol Grover wrote:
> > On Tue, Dec 03, 2019 at 07:40:52AM +0100, Greg KH wrote:
> > > On Tue, Dec 03, 2019 at 11:55:03AM +0530, Amol Grover wrote:
> > > > Compiled, Booted, however I'm getting the following errors when running
> > > > "make kselftest"
> > > > 
> > > > sudo dmesg -l alert
> > > > 
> > > > [34381.903893] BUG: kernel NULL pointer dereference, address: 0000000000000008
> > > > [34381.903904] #PF: supervisor read access in kernel mode
> > > > [34381.903908] #PF: error_code(0x0000) - not-present page
> > > 
> > > Which test causes this problem?
> > 
> > IIRC I didn't run make kselftest with summary=1 option. Is there any
> > other way to get that information? The logs that kselftest generated
> > also don't seem to help in this.
> 
> Watch the output when you run this?  I don't know, try re-running it
> with that option.
> 

I did. The tls test under tools/testing/selftests/net seems to be the
culprit. More information below.

> > > ANd is it new in 5.3.13?
> > > 
> > 
> > I previously ran kselftest on 5.4-rc7 and 5.3.9 (default kernel shipped
> > by openSUSE), both were fine. However, a bit of backstory:
> > 
> > A day ago I used kselftest from the linux/next branch and ran it (w/o
> > sudo).  It showed me the exact same error. However, I was running a
> > modified version of 5.3.13, but those modifications were actually
> > trivial (5 lines changed) and shouldn't have resulted in this kernel
> > error. So, I switched to the vanilla 5.3.13 and ran kselftest (w/o sudo)
> > again. I ran it 3 times (w/o any errors), switched back to the modified
> > kernel and ran kselftest (w/o root) 2 more times and everything was
> > fine. Then I decided to test the vanilla one again for the 4th time, but
> > this time I ran kselftest as root where this BUG popped again.
> 
> Try a kernel.org 5.3.9 and if that works, then try 5.3.13 and if that
> fails, run 'git bisect' and try to find the offending kernel commit.
> 

After finding the test that was resulting in the BUG, I decided to check
again against 5.3.13 (= BUG). I had recently compiled 5.4.1 as well so I
decided to run this test against 5.4.1 (= BUG). After this I realized I
had 5.3.9 kernel kept away so I decided to run the test against that too
(= BUG). After 5.3.9's error something didn't feel right. Mind you I was
using kselftest from linux/next so I got suspicious about the test
it-self. I ran kselftest from 5.4.1 on kernels 5.4.1 and 5.3.13 and none
of them resulted in the BUG this time. After a bit of digging I found
out the next branch had 2 additional test cases for the tls test, and
one of them (sendmsg_fragmented) is the actual culprit that was causing
all this.

TL;DR: tools/testing/selftests/net/tls.ci:sendmsg_fragmented from the
next tree appears to be broken(?)

Thanks
Amol

> thanks,
> 
> greg k-h
