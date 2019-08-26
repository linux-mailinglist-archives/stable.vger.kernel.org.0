Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5539F9C6FB
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 03:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728923AbfHZB3l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Aug 2019 21:29:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:43572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726509AbfHZB3l (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 25 Aug 2019 21:29:41 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94B4D20673;
        Mon, 26 Aug 2019 01:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566782980;
        bh=BgcJ9CVEz6QuxuPG8EMJbzC/ABChcwEtxrTch3OxHUE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a1d4JbYTiZyaekt9KrlDa49sQV//OKZqUd9IgilpWFHjUjZvxmEU9h7fWxIA9bEnU
         bUeszqDfZV26/7xoxt69V5VF94cYEVZsDi4dWAW/iiou1bzIKk+vj4cK3QkDCQ6DNU
         ztfJKXRTIanhiKobaSUqaR7cqHKfWQKP3TMcNUGg=
Date:   Sun, 25 Aug 2019 21:29:39 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.2] iwlwifi: mvm: disable TX-AMSDU on older NICs
Message-ID: <20190826012939.GE5281@sasha-vm>
References: <20190822180054.22422-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190822180054.22422-1-luca@coelho.fi>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 22, 2019 at 09:00:54PM +0300, Luca Coelho wrote:
>From: Johannes Berg <johannes.berg@intel.com>
>
>commit cfb21b11b891b08b79be07be57c40a85bb926668 upstream.
>
>On older NICs, we occasionally see issues with A-MSDU support,
>where the commands in the FIFO get confused and then we see an
>assert EDC because the next command in the FIFO isn't TX.
>
>We've tried to isolate this issue and understand where it comes
>from, but haven't found any errors in building the A-MSDU in
>software.
>
>At least for now, disable A-MSDU support on older hardware so
>that users can use it again without fearing the assert.
>
>This fixes https://bugzilla.kernel.org/show_bug.cgi?id=203315.
>
>Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

It applied as is from Linus's tree, so I just took it directly from
there to 5.2, thank you.

--
Thanks,
Sasha
