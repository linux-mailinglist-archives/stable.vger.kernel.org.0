Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF4091A99BD
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 11:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408493AbgDOJ6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 05:58:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:50658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405824AbgDOJ6L (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 05:58:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB40820775;
        Wed, 15 Apr 2020 09:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586944690;
        bh=qYtDQqF5lwYe6m9TiGeQq5D4MZBeie3YcIT31dNSGCc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RsBRy/UP2iunSgkJ6SAzlr95ulkmdCk7h+DeRILWDEqAzya3WVcxUzuWrW+T2bK+m
         92yGjJfLE89vxXscO7BWnqROixjji/qdYgE3b7x9tBxGPtxZBj3f2M6cP7pDXRi2xU
         HwL5Wsgt/fOEJKkVZoAit83Gi7sAp10vnc8TN+wM=
Date:   Wed, 15 Apr 2020 11:58:07 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: Patches to apply to stable releases
Message-ID: <20200415095807.GB2568572@kroah.com>
References: <20200415003148.GA114493@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415003148.GA114493@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 14, 2020 at 05:31:48PM -0700, Guenter Roeck wrote:
> Upstream commit 2e356101e72a ("KEYS: reaching the keys quotas correctly")
>     Fixes: a08bf91ce28e ("KEYS: allow reaching the keys quotas exactly")
>     in linux-4.4.y: 1e73c0aeb3ee
>     in linux-4.9.y: 6704b9d8a075
>     in linux-4.14.y: fe303ba7ab93
>     in linux-4.19.y: f812bec554d0
>     Applies to:
>         v4.4.y, v4.9.y, v4.14.y, v4.19.y

Already has a cc: stable tag, and is currently queued up.  Considering
it just came out in 5.7-rc1, you need to give me a chance to catch up on
those, I have 150+ still to go on that huge dump right now...

thanks,

greg k-h
