Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22E4212272F
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 09:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbfLQI7u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 03:59:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:34424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbfLQI7u (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 03:59:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 723D02072D;
        Tue, 17 Dec 2019 08:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576573189;
        bh=8+GCH4a4FYhU8ejV47+FBWWtU/uk2d0b3oSPUsIbLOc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UGpXFUaHoBgbjUpl9/+Vlbk3s+WxeVqIUxsqT7+D8K+iWgrHsu8PsUjMnj0fg1gxy
         M481mrJ6TDz/fAcXbKrh+LFD2IA0iBvLAbTZNtqaT1UIjK6GZY0p8Zo3IffqKG67aZ
         hLRL4293KmCeOlJpl+yrcpOpkL776t8WBp+vDID4=
Date:   Tue, 17 Dec 2019 09:59:47 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Michal Hocko <mhocko@suse.com>, Arnd Bergmann <arnd@arndb.de>,
        william.kucharski@oracle.com, bepvte@gmail.com, rppt@linux.ibm.com,
        Jan Kara <jack@suse.cz>, rientjes@google.com,
        dan.j.williams@intel.com, Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH 4.14 000/267] 4.14.159-stable review
Message-ID: <20191217085947.GB2773492@kroah.com>
References: <20191216174848.701533383@linuxfoundation.org>
 <CA+G9fYta8SH1EhzTSLshp1xx=MqmbSKPM2oXdV1qMSx=o2Tqsw@mail.gmail.com>
 <20191217075322.GE2474507@kroah.com>
 <CA+G9fYupS7hBtYPauO3A_QM-NQTPgxrOSLF=vu=dfHfdeG01Eg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYupS7hBtYPauO3A_QM-NQTPgxrOSLF=vu=dfHfdeG01Eg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 17, 2019 at 02:15:16PM +0530, Naresh Kamboju wrote:
>  >   ltp-fs-tests:
> > >     * proc01
> >
> > What does all of this mean?
> >
> > Can you bisect to find the offending patch?
> 
> Here is the offending patch,
> 
> Michal Hocko <mhocko@suse.com>
>     mm, thp, proc: report THP eligibility for each vma
> 
> FYI,
> Reverted this patch and re-validated ltp-fs-tests proc01 and now
> getting PASS on arm.

Ok, I'll go drop this.

Sasha, the backport of this patch didn't work.  Also you have two
"upstream commit" messages in the changelog, which feels odd :(

thanks,

greg k-h
