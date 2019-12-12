Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B73211C980
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 10:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728440AbfLLJjd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 04:39:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:39908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728435AbfLLJjd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Dec 2019 04:39:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7BA824658;
        Thu, 12 Dec 2019 09:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576143573;
        bh=MGCNHLAUe1VQmyt+pn8CsnsKFS9qEjq4ff7GqEEdfv0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BvpI7IgCbhuzGReld5FFudFemGDNyH7QHL54oGCCPwvhspMwaoDF53IpKWXMr55j1
         YcHAXEImTU4UdRmZelJgd5LqF2Fa24EVrN0koGNIi+xtwYkglA/i3MdCj9KGJLoewV
         BdWUK2XXvL3ns8oL+MPG0S8KmHvHYVQWOT2XHeFE=
Date:   Thu, 12 Dec 2019 10:39:30 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     Sasha Levin <sashal@kernel.org>, stable <stable@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [stable] appletalk fixes
Message-ID: <20191212093930.GK1378792@kroah.com>
References: <cc141cf4643194c9a8f35370ca620e0aff4ef70e.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc141cf4643194c9a8f35370ca620e0aff4ef70e.camel@decadent.org.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 11, 2019 at 10:48:16PM +0000, Ben Hutchings wrote:
> Please pick the following for stable branches 4.4, 4.9, 4.14, 4.19:
> 
> commit 9804501fa1228048857910a6bf23e085aade37cc
> Author: YueHaibing <yuehaibing@huawei.com>
> Date:   Thu Mar 14 13:47:59 2019 +0800
> 
>     appletalk: Fix potential NULL pointer dereference in unregister_snap_client
> 
> commit c93ad1337ad06a718890a89cdd85188ff9a5a5cc
> Author: YueHaibing <yuehaibing@huawei.com>
> Date:   Tue Apr 30 19:34:08 2019 +0800
> 
>     appletalk: Set error code if register_snap_client failed
> 
> The first commit doesn't apply cleanly to 4.4, 4.9, 4.14; you can use
> the attached backport.

All now queued up, thanks.

greg k-h
