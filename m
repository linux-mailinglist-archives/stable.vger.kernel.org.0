Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF53211925
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 03:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728564AbgGBBbm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 21:31:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728454AbgGBBbm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 21:31:42 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB524206BE;
        Thu,  2 Jul 2020 01:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593653502;
        bh=Frcy6sa+MzBWpB+wuits0wtM20kQLV2FEPxVtpTFjyw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A/tE0N/yKkdbjU/NCoK/Xv/sWYDLcGmzCA02gRnI13H4iY2/8radIUnsJgROfN401
         b7YVBqidrRMxbBkj+XO1n4bkSF5ANl1cdwQOvmlS6OdU/Co/g0eKQKcq0M7HTxpkwi
         1M0XednmcUTpSW9pgtbqtWbQKzfRjWaHOQfArAlE=
Date:   Wed, 1 Jul 2020 21:31:40 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org, "Agarwal, Anchal" <anchalag@amazon.com>
Subject: Re: Request for patch inclusion for 5.4-stable
Message-ID: <20200702013140.GG2687961@sasha-vm>
References: <dff7fc38-d2b3-1f7c-88c6-085fb93c7f11@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <dff7fc38-d2b3-1f7c-88c6-085fb93c7f11@kernel.dk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 01, 2020 at 12:24:17PM -0600, Jens Axboe wrote:
>Hi,
>
>There's no upstream variant of this, as that would require backporting
>all the io-wq changes from 5.5 and on. Hence I made a one-off that
>ensures that we don't leak memory if we have async work items that
>need active cancelation (like socket IO).
>
>Can we get this queued up for 5.4? I've tested it and the original
>reporter has as well.

I've added the previous paragraph which explains why there is no
upstream version of this into the commit message and queued it for 5.4,
thank you!

-- 
Thanks,
Sasha
