Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C5F2C73DA
	for <lists+stable@lfdr.de>; Sat, 28 Nov 2020 23:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730844AbgK1Vtx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Nov 2020 16:49:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:50838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733004AbgK1TEw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 28 Nov 2020 14:04:52 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF2872222C;
        Sat, 28 Nov 2020 08:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606550716;
        bh=xgpytsXqKonReZKhzxLAJZZKiKMBFEPhCby0SWDwuwo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xp+aYzegVXIkxISk86zPKj9sSPj7VJY11XWZKmhgHKDHozxAWYECu5jSd9tA7y/o5
         JwaVB3LVeadt4zZwZcnPXgThXBcDvZV5Lf+X6UUX81q0LPXKwdqHry0M0Tx/JDxnLR
         bRqm5Jz6wLi8rlClQo+ulfhKtePnk5FiaScKGOm8=
Date:   Sat, 28 Nov 2020 09:06:24 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Wen Yang <wenyang@linux.alibaba.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>, stable@vger.kernel.org
Subject: Re: [PATCH] exit: fix a race in release_task when flushing the dentry
Message-ID: <X8IFADugB450PHp8@kroah.com>
References: <20201128064722.9106-1-wenyang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201128064722.9106-1-wenyang@linux.alibaba.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 28, 2020 at 02:47:22PM +0800, Wen Yang wrote:
> [ Upstream commit 7bc3e6e55acf065500a24621f3b313e7e5998acf ]

No, that is not this commit at all.

What are you wanting to have happen here?

confused,

greg k-h
