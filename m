Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8559413025E
	for <lists+stable@lfdr.de>; Sat,  4 Jan 2020 13:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725861AbgADMcJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jan 2020 07:32:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:35848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725802AbgADMcJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 Jan 2020 07:32:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B5EB215A4;
        Sat,  4 Jan 2020 12:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578141128;
        bh=y8Szpqw3VJHQKNgy2LFXQVExSWcLxy1xhRanLdG/d+c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hKoxuMe04AN3/aptItP4Ze0wduSNMbK8qExzdQ6BhdvHJQxtv6NaldKyo2oKeKIFt
         DDbcVBWnZN2b/5uxu8w6dpT6bf2RgB/8XE1g8XUo8TIsSZDhcDk00FBYsBeNDYnkaV
         h54LKz5aQZKc0WIu2hKGUd+a/OGwV5eaKvfeKeCY=
Date:   Sat, 4 Jan 2020 13:32:06 +0100
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
Subject: Re: [PATCH 4.4 000/137] 4.4.208-stable review
Message-ID: <20200104123206.GD1296856@kroah.com>
References: <20200102220546.618583146@linuxfoundation.org>
 <CA+G9fYs-GnWRzSLjuja6ROyr93G3DVg_7-f2uXTOu1PBP6dxAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYs-GnWRzSLjuja6ROyr93G3DVg_7-f2uXTOu1PBP6dxAA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 04, 2020 at 10:05:27AM +0530, Naresh Kamboju wrote:
> On Fri, 3 Jan 2020 at 04:05, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.4.208 release.
> > There are 137 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 04 Jan 2020 22:02:41 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.208-rc1.gz
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
