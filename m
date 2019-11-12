Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82DCDF9113
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 14:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbfKLNw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 08:52:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:57664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbfKLNw6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 08:52:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 860B021A49;
        Tue, 12 Nov 2019 13:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573566778;
        bh=YITOsP4LWDYzahOTbwsGymlzWmlajTkv+5UVEfpQMXo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pVOafzYBNJOCkpMIOmJkuA4KbsY0jSY2txplgyFd057sOJP+WR94YOQ5m4MQM70k0
         rmDslQNoc/GXMdRurSN+HzKXvXmMa+eZVTBKCTOrTEfNQSMNoKzfxYDN0rLSVf2+YF
         Y48dzrq9pp+bEH/AoXIl5be3wpG7dV5bbwVxkOmU=
Date:   Tue, 12 Nov 2019 14:52:55 +0100
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
Subject: Re: [PATCH 5.3 000/193] 5.3.11-stable review
Message-ID: <20191112135255.GB1331422@kroah.com>
References: <20191111181459.850623879@linuxfoundation.org>
 <CA+G9fYvBckngrAhc4NEU9G-_UrE9evmJNkCz3ZP7eEZjwyHGKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYvBckngrAhc4NEU9G-_UrE9evmJNkCz3ZP7eEZjwyHGKA@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 12, 2019 at 11:12:15AM +0530, Naresh Kamboju wrote:
> On Tue, 12 Nov 2019 at 00:18, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.3.11 release.
> > There are 193 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 13 Nov 2019 18:08:44 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.11-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
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
