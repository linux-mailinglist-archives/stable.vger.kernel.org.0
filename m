Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7C940D50F
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 10:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235245AbhIPIw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 04:52:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:33000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235226AbhIPIwY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 04:52:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA1396120F;
        Thu, 16 Sep 2021 08:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631782264;
        bh=NKcmBxwkV3R3tW4bY4JaBczY3HPYWnC0xy3S7LWGRSM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0HPOUTzzQeuM5ZQE4uXfcBNZXnxETW8Y+I48clm9G3Lu1sJSyxpRCAAiYEUfN6hlb
         TJyDHBn8Xl3BaeGkV8Cg/lZaeImya0yHMsytNW87XMyUMxKtyDwj1UHie9UOD9LWBH
         rxsFnwoerQzSGnnwsgvboDjHFzeWgr7h5uUBET+E=
Date:   Thu, 16 Sep 2021 10:51:01 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Alan J. Wylie" <alan@wylie.me.uk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Regression in posix-cpu-timers.c (was Re: Linux 5.14.4)
Message-ID: <YUMFdVETIYkCAmZx@kroah.com>
References: <1631693373201133@kroah.com>
 <87ilz1pwaq.fsf@wylie.me.uk>
 <YUI26QI7dfgjUioT@kroah.com>
 <24898.16666.838506.586861@wylie.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24898.16666.838506.586861@wylie.me.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 15, 2021 at 07:53:14PM +0100, Alan J. Wylie wrote:
> at 20:09 on Wed 15-Sep-2021 Greg Kroah-Hartman (gregkh@linuxfoundation.org) wrote:
> 
> > Does 5.15-rc1 also fail in this same way, or does it work ok?
> 
> It fails
> 
> # uname -a
> Linux bilbo 5.15.0-rc1 #1 SMP PREEMPT Wed Sep 15 19:19:48 BST 2021
> x86_64 AMD FX(tm)-4300 Quad-Core Processor AuthenticAMD GNU/Linux
> 
> # su apache -s /bin/bash -c "cd /var/www/htdocs/nextcloud/ && php occ maintenance:mode --off"
> PHP Fatal error: Maximum execution time of 0 seconds exceeded in
> /var/www/htdocs/nextcloud/3rdparty/symfony/console/Application.php on
> line 65

Thanks for testing this and letting us know so quickly.

I'll go drop this from all of the pending stable queues, and revert it
from the released stable trees and push out an update in a few hours.

thanks,

greg k-h
