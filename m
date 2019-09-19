Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9CBB8128
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 21:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392198AbfISTEZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 15:04:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:52190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392196AbfISTEY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 15:04:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 084BD2067B;
        Thu, 19 Sep 2019 19:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568919862;
        bh=Rmn1JiN1N4HM/Q7+e5y+1ogOJoUuotKY8vvho2xkxts=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eSrDCgE1dQTDYfB+9cjq89fjEwNY4Ot8tZKpKMlb1Zq3WM469h5+yAuLQxIlKAqcs
         K1LyMZ1tprjQhK5amJffqEjxNxKOzkLq95Yk8c3IfyhBSF4JTnr8wsymoTMbSZc5tq
         y0/cajf0K4A9MXjL5rK7dCEFWxV215yS6DzqYNB8=
Date:   Thu, 19 Sep 2019 21:04:20 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        stable <stable@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] ovl: support the FS_IOC_FS[SG]ETXATTR
 ioctls" failed to apply to 5.1-stable tree
Message-ID: <20190919190420.GA4183040@kroah.com>
References: <1560073529193139@kroah.com>
 <CAOQ4uxiTrsOs3KWOxedZicXNMJJharmWo=TDXDnxSC1XMNVKBg@mail.gmail.com>
 <CAOQ4uxiTTuOESvZ2Y5cSebqKs+qeU3q6ZMReBDro0Qv7aRBhpw@mail.gmail.com>
 <20190623010345.GJ2226@sasha-vm>
 <20190623202916.GA10957@kroah.com>
 <20190624003409.GO2226@sasha-vm>
 <CAOQ4uxiz5CkGojr5yquUd__TS_eae+ZapqyGaojiOUGniFPMsg@mail.gmail.com>
 <20190724115714.GA3244@kroah.com>
 <CAOQ4uxiEVsBp6qojO9K1TqzpETtdqDPzqTaFQGjr8woJ2WQP=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiEVsBp6qojO9K1TqzpETtdqDPzqTaFQGjr8woJ2WQP=g@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 24, 2019 at 04:46:36PM +0300, Amir Goldstein wrote:
> > > I don't think syzkaller ones are more relevant to 5.1 then the rest of
> > > the patches applied to 4.19. If anything, its the other way around.
> > > According to syzbot dashboard, it is being run on LTS kernels, not on
> > > latest stable.
> > >
> > > Please forgive me if my language caused confusion, when I said
> > > "please apply to 4.19" I meant 4.19+.
> >
> > So is anything else needed to be done here, or are we all caught up and
> > everything merged properly?
> >
> 
> All the needed patches have been merged, but
> Upstream commit 146d62e5a5867fbf84490d82455718bfb10fe824
> ("ovl: detect overlapping layers") did introduce a regression to
> docker and friends into stable kernels :-/
> 
> The fix commit is already tested and waiting in linux-next:
> 0be0bfd2de9d ("ovl: fix regression caused by overlapping layers detection")
> but did not hit upstream yet. When it does, will need to apply it to v4.19+

That is now in Linus's tree and I've queued it up now.

thanks,

greg k-h
