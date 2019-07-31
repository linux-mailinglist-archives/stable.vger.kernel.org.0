Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 874CE7BD9C
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 11:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfGaJrU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 05:47:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:39034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726652AbfGaJrU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 31 Jul 2019 05:47:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E916320665;
        Wed, 31 Jul 2019 09:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564566439;
        bh=lL2lo8DlwbLLdQWW3NO2uszBJC91kGckp3xrQvR1t9c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jzAuw+NUUfjH+lgnxL08F+LzTF4iTVjwkUEN3Eew2meU6uuuIR6xrcV6H1I579WqT
         +8XXWXa8HIohlMlAxlK0tVhjIXVxJbHFPLsRZVdAq6Jy+C1hmY8VDljIvzeVApPDKy
         JIJLq/dr7HSFKKinRBS3+KEyKCNsI9UdxYYocOK8=
Date:   Wed, 31 Jul 2019 11:47:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Will Deacon <will@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        "# 4 . 9+" <stable@vger.kernel.org>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] arm64: compat: Provide definition for COMPAT_SIGMINSTKSZ
Message-ID: <20190731094717.GH18269@kroah.com>
References: <20190730092547.1284-1-will@kernel.org>
 <20190730093713.GB15402@kroah.com>
 <20190730093938.bimxbvhd3alo3u37@willie-the-truck>
 <20190730094226.GA16071@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730094226.GA16071@kroah.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 30, 2019 at 11:42:26AM +0200, Greg KH wrote:
> On Tue, Jul 30, 2019 at 10:39:38AM +0100, Will Deacon wrote:
> > On Tue, Jul 30, 2019 at 11:37:13AM +0200, Greg KH wrote:
> > > On Tue, Jul 30, 2019 at 10:25:47AM +0100, Will Deacon wrote:
> > > > From: Will Deacon <will.deacon@arm.com>
> > > > 
> > > > [ Upstream commit 24951465cbd279f60b1fdc2421b3694405bcff42 ]
> > > > 
> > > > arch/arm/ defines a SIGMINSTKSZ of 2k, so we should use the same value
> > > > for compat tasks.
> > > > 
> > > > Cc: <stable@vger.kernel.org> # 4.9+
> > > > Cc: Aurelien Jarno <aurelien@aurel32.net>
> > > > Cc: Arnd Bergmann <arnd@arndb.de>
> > > > Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> > > > Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> > > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > > > Cc: Oleg Nesterov <oleg@redhat.com>
> > > > Reviewed-by: Dave Martin <Dave.Martin@arm.com>
> > > > Reported-by: Steve McIntyre <steve.mcintyre@arm.com>
> > > > Tested-by: Steve McIntyre <93sam@debian.org>
> > > > Signed-off-by: Will Deacon <will.deacon@arm.com>
> > > > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > > > ---
> > > > 
> > > > Aurelien points out that this didn't get selected for -stable despite its
> > > > counterpart (22839869f21a ("signal: Introduce COMPAT_SIGMINSTKSZ for use
> > > > in compat_sys_sigaltstack")) being backported to 4.9. Oops.
> > > 
> > > So this needs to go into 4.9.y, 4.14.y, and 4.19.y?
> > 
> > Yes, please.
> 
> Thanks, will do after this next round of kernels goes out.

Now queued up, thanks.

greg k-h
