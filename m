Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCBD3F61A9
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 17:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238205AbhHXPbk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 11:31:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:41752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237890AbhHXPbk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 11:31:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF93161165;
        Tue, 24 Aug 2021 15:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629819056;
        bh=cGj77PQIITBKOmGKbEzdPJD3D6R1lTO6GTghpbpHjSw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SpyciwO5H0x/HHExl/cGz6KvpnHnj0+E02+RgTW3vOhftxxP+VlX5AFF5hGCExuSx
         fWB7RRw2mChIRm/ibp8EvSH5P3SGde2PrQAWHCecpcJmpaTSPGgBEcfF1HYaY7Rf6c
         OLw7UeFoZHFd7KTK6WX9drFE4sv5oM1DNSm2kJdJZknkt3PE8D8kyAcDNtRIvD7PNQ
         /T8L2pPDNJQ3XUurImMle9wCv+1KaaPxrebX3PdAxEIshBZkfJKpDh12KUr2Z4UVB/
         x2Mrf36VOTNA/LCVIrmxTiEo7jsUT4aOXvAPLvjvtla3Cpn5ggCqEdFMThIuSSnkgi
         rWZUvBxh1dsHQ==
Date:   Tue, 24 Aug 2021 11:30:54 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 5.10 backport] io_uring: fix xa_alloc_cycle() error
 return value check
Message-ID: <YSUQrsFadTBvWy6c@sashalap>
References: <efdf0cfa5a2ffe1fb9e08d3e1918a9a84385384b.1629807216.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <efdf0cfa5a2ffe1fb9e08d3e1918a9a84385384b.1629807216.git.asml.silence@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 24, 2021 at 01:15:01PM +0100, Pavel Begunkov wrote:
>From: Jens Axboe <axboe@kernel.dk>
>
>[ upstream commit a30f895ad3239f45012e860d4f94c1a388b36d14 ]
>
>We currently check for ret != 0 to indicate error, but '1' is a valid
>return and just indicates that the allocation succeeded with a wrap.
>Correct the check to be for < 0, like it was before the xarray
>conversion.
>
>Cc: stable@vger.kernel.org
>Fixes: 61cf93700fe6 ("io_uring: Convert personality_idr to XArray")
>Signed-off-by: Jens Axboe <axboe@kernel.dk>
>Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Queued up, thanks!

-- 
Thanks,
Sasha
