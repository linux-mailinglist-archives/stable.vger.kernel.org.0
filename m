Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA39B9B5A1
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 19:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbfHWRiy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Aug 2019 13:38:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:40124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726779AbfHWRiy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Aug 2019 13:38:54 -0400
Received: from localhost (unknown [104.129.198.240])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B402E206B7;
        Fri, 23 Aug 2019 17:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566581933;
        bh=PdG66pqA9m+t+QLbU/VhuJ7aGG/vbdp1hujf9jdiBeQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gfForkdDW1AeUTVJLGQV1DckO7CvE9sBgZXFbuYFWzc3zboXo+1T1DkixF+VPcvvE
         x0QBLT4PJ8TQqgYtMhXnfSRmO7I6g4R9NCksuhLwVnvrAtsoCsY4AofzblgOMhvKWO
         Pwi97aX+n7y3kwL3BMnEBlPb362DAjTsPK3vLyMc=
Date:   Fri, 23 Aug 2019 10:38:53 -0700
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 4.4 00/78] 4.4.190-stable review
Message-ID: <20190823173853.GC1040@kroah.com>
References: <20190822171832.012773482@linuxfoundation.org>
 <CA+G9fYv90rOtmxHpvvs2_TssLj9Ngp_vJh5sjoz0nj8y+mhNzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYv90rOtmxHpvvs2_TssLj9Ngp_vJh5sjoz0nj8y+mhNzQ@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 23, 2019 at 01:56:22PM +0530, Naresh Kamboju wrote:
> On Thu, 22 Aug 2019 at 22:53, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.4.190 release.
> > There are 78 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat 24 Aug 2019 05:18:13 PM UTC.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.190-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Thanks for testing all of these and letting me know.

greg k-h
