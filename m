Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBBC396DE7
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 09:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbhFAH31 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 03:29:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230326AbhFAH30 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Jun 2021 03:29:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2754760FEB;
        Tue,  1 Jun 2021 07:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622532464;
        bh=PJ7D/RBFw9RNfKt2iDHs0/zK7q7cCPQ9xq9QF0U7EOw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eQ4tR4g23xpp/PNzzT6TRUbl4CB7A+hBFBaLrip70ZcBiwvJtiN3NxuLtqfewEl17
         hxzFzFTtR86C5IcnCDxQpwyyA8VMWpt3AhpK0KglneCgtkA3yJODfIChvx/jC7DOVx
         uPgXHojj4yVNjcP2jGwdOJC5I4WHVrhDekRTEKpM=
Date:   Tue, 1 Jun 2021 09:27:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v4.14 00/10] wireless security fixes backports
Message-ID: <YLXhbpr9RrraHaws@kroah.com>
References: <20210531203135.180427-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210531203135.180427-1-johannes@sipsolutions.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 31, 2021 at 10:31:25PM +0200, Johannes Berg wrote:
> Some of these patches here were already applied since they
> applied cleanly, but I'm resending the whole set for review
> now anyway.

I've applied your updated versions just to make sure that my backports
were not somehow messed up, thank for these!

greg k-h
