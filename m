Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C70A02BA4B6
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 09:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbgKTIdm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 03:33:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:56532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725824AbgKTIdl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 03:33:41 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D243022249;
        Fri, 20 Nov 2020 08:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605861220;
        bh=UeYIzb157e5iA+u4+qvzLdxYa+xTAv7xFFcm6TmhAqg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XFkcW9URQ7TGMkVUqAFscZ3wM+6CheJ/GiDdJTic8PYCMWDfBNItrJt+GhlYAFfMi
         GGhHEs4VXWfqzPltundg7O4IJjkdnAhBfoKbhnisAaFYNT690jXwoVUWbRkJmIDZ9N
         +Du4NAuwVjiJJmBBgh2fkwL2w5sDjnzx0xZVJwSs=
Date:   Fri, 20 Nov 2020 09:34:20 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org
Subject: Re: patch for mips build failure in 5.4-stable
Message-ID: <X7d/jEoEm6yEUpPZ@kroah.com>
References: <20201119103911.rbqxmssqe2pqnli2@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201119103911.rbqxmssqe2pqnli2@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 19, 2020 at 10:39:11AM +0000, Sudip Mukherjee wrote:
> Hi Greg, Sasha,
> 
> While backporting 37640adbefd6 ("MIPS: PCI: remember nasid changed by
> set interrupt affinity") something went wrong and an extra 'n' was added.
> So 'data->nasid' became 'data->nnasid' and the MIPS builds started failing.
> 
> Since v5.4.78 is already released I assumed you will need a patch to
> fix it. Please consider applying the attached patch, this is only needed
> for 5.4-stable tree.

Now applied, thanks!

greg k-h
