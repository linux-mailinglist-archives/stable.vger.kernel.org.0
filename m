Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91AFDF5E7D
	for <lists+stable@lfdr.de>; Sat,  9 Nov 2019 11:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbfKIKhl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 05:37:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:47298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbfKIKhk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 05:37:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C03621848;
        Sat,  9 Nov 2019 10:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573295860;
        bh=YDpiMkaLtjbG8cMf8qmhNnEFosJd+sgFBaV17ymrt0U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uuHmn0zzJmND8Wa46XUoj0dzPNGSnqeARyfA/Wz6j0NAQioUG3OGMWdFx2HsYH1Qf
         rK2k5XmRNYLJzrxgUHsZUVqE2KOqrKYeDonu2PtE6idY6N+7/Jp27H0G6ZIVnqsig+
         adixqzEpYEsr0mFE6kJlXZEobx7aiRJpgiurGjQ8=
Date:   Sat, 9 Nov 2019 11:37:36 +0100
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
Subject: Re: [PATCH 5.3 000/140] 5.3.10-stable review
Message-ID: <20191109103736.GA1303186@kroah.com>
References: <20191108174900.189064908@linuxfoundation.org>
 <CA+G9fYs_+meFv_Jbdon_Q_MoPvSB6qhv1sWM0Nr56oxSdbT8oQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYs_+meFv_Jbdon_Q_MoPvSB6qhv1sWM0Nr56oxSdbT8oQ@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 09, 2019 at 03:53:02PM +0530, Naresh Kamboju wrote:
> On Sat, 9 Nov 2019 at 00:35, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.3.10 release.
> > There are 140 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun 10 Nov 2019 05:42:11 PM UTC.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.10-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Wonderful, thanks for testing all of these and letting me know.

greg k-h
