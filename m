Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBE219D3C4
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 18:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731490AbfHZQNo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 12:13:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:46066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729338AbfHZQNn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Aug 2019 12:13:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2703020679;
        Mon, 26 Aug 2019 16:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566836023;
        bh=MvkckrjhKUs2eKppVmumVOdx8zqnu56n0MEikqyh3Hg=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=KjPMRm7rjT7V+ZH7F3mPv4LoBcAnrwqFvZIyDCRIyqiZJOOPeeD6a2C1GI2w8rFyN
         b/rQmccl3b5UfiUsMI72+s24h7GpOnXxLaLgBBcHjq7hgQMowtsV0R6SyLRtwixMnP
         KbV0VNmPZ9QFpNisISXLWScAzK2JjJP/FTPA/DPI=
Date:   Mon, 26 Aug 2019 18:13:41 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     vbabka@suse.cz, akpm@linux-foundation.org, kirill@shutemov.name,
        mgorman@techsingularity.net, mhocko@kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org
Subject: Re: FAILED: patch "[PATCH] mm, page_owner: handle THP splits
 correctly" failed to apply to 4.19-stable tree
Message-ID: <20190826161341.GA8934@kroah.com>
References: <1566835255152129@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566835255152129@kroah.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 26, 2019 at 06:00:55PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Nevermind about these 3 rejections, I've fixed them up.

thanks,

greg k-h
