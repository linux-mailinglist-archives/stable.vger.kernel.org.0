Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3DCC15F899
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 22:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389267AbgBNVRI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 16:17:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:51048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387988AbgBNVRH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 16:17:07 -0500
Received: from localhost (unknown [65.119.211.164])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AA7E24654;
        Fri, 14 Feb 2020 21:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581715027;
        bh=acV4UmbvY0EknDqCExrCuDI4Q3EtwQSmdTmdHp6Oq4E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kzCL+Bv5y7A5KoRnZOJPG7ONuIccTJ8wNVF9KyvdiD4yJU2HOFbX7sIjTZ/HyAR7F
         nGLg7RkPE9b/T8+4aOsy3z5CykG2k2n+wytCkHlXLvWkNggqFnbuiz4EodcL7KTM5e
         g+9H81z/Ux1WoYQK5NCTadNmuiZbCHF9ouMO1XHM=
Date:   Fri, 14 Feb 2020 15:49:54 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 091/195] padata: Remove broken queue flushing
Message-ID: <20200214204954.GA4087825@kroah.com>
References: <20200210122305.731206734@linuxfoundation.org>
 <20200210122314.217904406@linuxfoundation.org>
 <5E4674BB.4020900@huawei.com>
 <20200214152128.GC3959278@kroah.com>
 <20200214201006.6qlfqillveotr47n@ca-dmjordan1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214201006.6qlfqillveotr47n@ca-dmjordan1.us.oracle.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 14, 2020 at 03:10:06PM -0500, Daniel Jordan wrote:
> On Fri, Feb 14, 2020 at 07:21:28AM -0800, Greg Kroah-Hartman wrote:
> > So this causes a problem in the 4.19-rc tree but not in Linus's tree?
> > Or am I confused?  Should it be dropped from stable or is there some
> > other fix-of-a-fix that I need to apply here?
> 
> This causes a problem in 4.19.103 and 4.19-rc but not Linus's tree.
> 
> The fix-of-a-fix is posted recently here:
> 
>     https://lore.kernel.org/lkml/20200214182821.337706-1-daniel.m.jordan@oracle.com/
> 
> For 4.14, 4.9, and 4.4, I'm posting a revised version of "Remove broken queue
> flushing" in each review thread.  4.14 is already up.  Is this what I should be
> doing?

That is exactly correct, thanks for doing this, I'll drop what is
currently in these trees and then queue your new fix up for the next
round of releases, thanks!

greg k-h
