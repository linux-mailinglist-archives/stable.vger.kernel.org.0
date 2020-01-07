Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 419EB132D52
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 18:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728451AbgAGRou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 12:44:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:32858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728344AbgAGRou (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 12:44:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BD6920715;
        Tue,  7 Jan 2020 17:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578419089;
        bh=hTKIxt5cYGZclecoS0yI1vR7UHjtafutGba7sSR3efk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j3iecNHWIE/lPlKwDWGEhgB9oc+IS/bBMyOs7ws0G2IwLqknhWWX0n2x+4GoKUth5
         fqzpzD9FwyW8PTKXR7hpLLklxrWZsHgsuXCR4ecRcbdDbYtM17m5oRLQS4RTvhwieA
         bOzNg4MRiyeWH1bmKV7C+7mLjyov3S5BbqIDpuFw=
Date:   Tue, 7 Jan 2020 18:44:46 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jan Kara <jack@suse.cz>
Cc:     stable@vger.kernel.org, Philipp Matthias Hahn <pmhahn@pmhahn.de>
Subject: Re: Include DVD reading fixes
Message-ID: <20200107174446.GA2011915@kroah.com>
References: <20200107155118.GH25547@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200107155118.GH25547@quack2.suse.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 07, 2020 at 04:51:18PM +0100, Jan Kara wrote:
> Hello!
> 
> Phillipp has asked me whether I could send commits:
> 
> cba22d86e0a1 bdev: Refresh bdev size for disks without partitioning
> 731dc4868311 bdev: Factor out bdev revalidation into a common helper
> 
> for inclusion into stable. I've noticed they are already in 5.4-stable but
> they didn't seem to propagate into say 4.19-stable although they apply just
> fine there. Any reason for that?

We were asked by Laura to include it as Fedora hit the issue and I don't
think they care about old/obsolete kernels like 4.19 :)

I've now queued them both up, thanks!

greg k-h
