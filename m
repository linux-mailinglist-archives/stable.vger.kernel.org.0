Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64E8D134A71
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 19:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729187AbgAHS0E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 13:26:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:55006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727169AbgAHS0E (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jan 2020 13:26:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF25F20705;
        Wed,  8 Jan 2020 18:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578507964;
        bh=VEJd0lbqV7o/Vx/f4wGgyYUhD2rdodh6xlpE92Ogm5I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0+kerRgFvq/wExQh+wfGtS/Ri9grPees+pWx51FJLDQOjtKhHPnueGeF64V1GeDxr
         xHltIeTQ8BFz+vIIwJsjbWJVVcFIRw1kjAvoEsaqUyN280i8w4eop7S0kCOhFdgPpx
         rYXs08Z7aVcWW93ob3YT/rutlfb4AkYkRYQyW83o=
Date:   Wed, 8 Jan 2020 19:26:02 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/191] 5.4.9-stable review
Message-ID: <20200108182602.GD2547623@kroah.com>
References: <20200107205332.984228665@linuxfoundation.org>
 <20200107212436.GA18475@roeck-us.net>
 <20200108064251.GC2278146@kroah.com>
 <CA+G9fYt8hN=4NnnAO01JXmEQehcZ-csM5cT5AKa8i_BvzJ6-7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYt8hN=4NnnAO01JXmEQehcZ-csM5cT5AKa8i_BvzJ6-7A@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 08, 2020 at 10:04:23PM +0530, Naresh Kamboju wrote:
> On Wed, 8 Jan 2020 at 16:47, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > Thanks for letting me know, Jens also pointed this out and I've now
> > dropped it and will push out a -rc2 in a few minutes with it removed.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Wonderful, thanks for testing these and letting me know.

greg k-h
