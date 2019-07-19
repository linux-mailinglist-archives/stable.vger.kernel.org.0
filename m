Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 867E96D975
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 05:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbfGSDqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 23:46:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:54314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbfGSDqV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 23:46:21 -0400
Received: from localhost (p91006-ipngnfx01marunouchi.tokyo.ocn.ne.jp [153.156.43.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E61832173B;
        Fri, 19 Jul 2019 03:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563507980;
        bh=SwMD6+/cj1yolV8kd0YVf3nZtjqo9EnuU1iriUtY5ok=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i26LvF+0yy/DNWBELjJsweXoZTmccpsFzjlZMUIjdy+g7PM2gvNjnB7yQauv/qhXc
         gEx4XzrQZ37ACMwMoOpWNlmiVCSnIiZm1H+MjtqnFjyl6bTnU1arpBf7ZYaZKx8wSb
         fJpArHgdj9AwJyi6XwZG/S/yYDGs3wHRewlLtg8Q=
Date:   Fri, 19 Jul 2019 12:46:18 +0900
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5.2 00/21] 5.2.2-stable review
Message-ID: <20190719034618.GA8184@kroah.com>
References: <20190718030030.456918453@linuxfoundation.org>
 <CA+G9fYvXydEVdXBhLdagzj5gvxmdZgUkDQ8UFToRtb0UwH672g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYvXydEVdXBhLdagzj5gvxmdZgUkDQ8UFToRtb0UwH672g@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 18, 2019 at 06:12:34PM +0530, Naresh Kamboju wrote:
> On Thu, 18 Jul 2019 at 08:33, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.2.2 release.
> > There are 21 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat 20 Jul 2019 02:59:27 AM UTC.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.2-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
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
