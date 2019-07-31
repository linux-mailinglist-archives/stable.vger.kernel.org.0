Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCFE57BE99
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 12:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387803AbfGaKpw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 06:45:52 -0400
Received: from hall.aurel32.net ([195.154.113.88]:33958 "EHLO hall.aurel32.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387800AbfGaKpw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 31 Jul 2019 06:45:52 -0400
X-Greylist: delayed 2709 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Jul 2019 06:45:51 EDT
Received: from aurel32 by hall.aurel32.net with local (Exim 4.89)
        (envelope-from <aurelien@aurel32.net>)
        id 1hslPT-0004OT-88; Wed, 31 Jul 2019 12:00:39 +0200
Date:   Wed, 31 Jul 2019 12:00:39 +0200
From:   Aurelien Jarno <aurelien@aurel32.net>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        "# 4 . 9+" <stable@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] arm64: compat: Provide definition for COMPAT_SIGMINSTKSZ
Message-ID: <20190731100039.qh6eomvbr7sx6kn5@aurel32.net>
Mail-Followup-To: Greg KH <gregkh@linuxfoundation.org>,
        Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        "# 4 . 9+" <stable@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>
References: <20190730092547.1284-1-will@kernel.org>
 <20190730093713.GB15402@kroah.com>
 <20190730093938.bimxbvhd3alo3u37@willie-the-truck>
 <20190730094226.GA16071@kroah.com>
 <20190731094717.GH18269@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731094717.GH18269@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019-07-31 11:47, Greg KH wrote:
> On Tue, Jul 30, 2019 at 11:42:26AM +0200, Greg KH wrote:
> > On Tue, Jul 30, 2019 at 10:39:38AM +0100, Will Deacon wrote:
> > > On Tue, Jul 30, 2019 at 11:37:13AM +0200, Greg KH wrote:
> > > > On Tue, Jul 30, 2019 at 10:25:47AM +0100, Will Deacon wrote:
> > > > > From: Will Deacon <will.deacon@arm.com>
> > > > > 
> > > > > [ Upstream commit 24951465cbd279f60b1fdc2421b3694405bcff42 ]
> > > > > 
> > > > > arch/arm/ defines a SIGMINSTKSZ of 2k, so we should use the same value
> > > > > for compat tasks.
> > > > > 
> > > > > Cc: <stable@vger.kernel.org> # 4.9+
> > > > > Cc: Aurelien Jarno <aurelien@aurel32.net>
> > > > > Cc: Arnd Bergmann <arnd@arndb.de>
> > > > > Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> > > > > Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> > > > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > > > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > > > > Cc: Oleg Nesterov <oleg@redhat.com>
> > > > > Reviewed-by: Dave Martin <Dave.Martin@arm.com>
> > > > > Reported-by: Steve McIntyre <steve.mcintyre@arm.com>
> > > > > Tested-by: Steve McIntyre <93sam@debian.org>
> > > > > Signed-off-by: Will Deacon <will.deacon@arm.com>
> > > > > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > > > > ---
> > > > > 
> > > > > Aurelien points out that this didn't get selected for -stable despite its
> > > > > counterpart (22839869f21a ("signal: Introduce COMPAT_SIGMINSTKSZ for use
> > > > > in compat_sys_sigaltstack")) being backported to 4.9. Oops.
> > > > 
> > > > So this needs to go into 4.9.y, 4.14.y, and 4.19.y?
> > > 
> > > Yes, please.
> > 
> > Thanks, will do after this next round of kernels goes out.
> 
> Now queued up, thanks.
> 

Thanks!

-- 
Aurelien Jarno                          GPG: 4096R/1DDD8C9B
aurelien@aurel32.net                 http://www.aurel32.net
