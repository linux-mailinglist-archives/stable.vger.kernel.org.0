Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1A85581E
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 21:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfFYTul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 15:50:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:54512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726274AbfFYTul (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 15:50:41 -0400
Received: from localhost (unknown [167.220.24.221])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 056532063F;
        Tue, 25 Jun 2019 19:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561492240;
        bh=KN0ZgJsc9+K9v0DVfc9fo1tn+6UOtaO/DiYm3aMs9Jc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2viJfRDaLnpOYs16A6bvDfZvt19nYfz70+O3EqWrlZFh8gTmEEw6LZcGuYM1WD+xH
         RtT4/WP12qjIm3NSNaHYAQFQpM9WBNy2Z6XB4OInSJmc5Q9/yLLAIKHF/FVZs8g4ul
         dMi0q0e4xxeTSZwBqBsR0hlA9JXXY8oAbPBlZ4Hs=
Date:   Tue, 25 Jun 2019 15:50:38 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jack Wang <jinpuwang@gmail.com>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Subject: Re: [stable-4.14 0/2] block layer fixes for silent data corruption
Message-ID: <20190625195038.GB7898@sasha-vm>
References: <20190625141725.26220-1-jinpuwang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190625141725.26220-1-jinpuwang@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 25, 2019 at 04:17:23PM +0200, Jack Wang wrote:
>A silent data corruption was introduced in v4.10-rc1 with commit
>72ecad22d9f198aafee64218512e02ffa7818671 and was fixed in v4.18-rc7
>with commit 17d51b10d7773e4618bcac64648f30f12d4078fb. It affects
>users of O_DIRECT, in our case a KVM virtual machine with drives
>which use qemu's "cache=none" option.
>
>The other 2 commits has been accepted in 4.14, but 2 are missing,
>ref: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1796542
>
>Please consider to include them in next release.

I've ended up cherry picking these two into the 4.14 tree.

--
Thanks,
Sasha
