Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C0C257D89
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 17:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729366AbgHaPi1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 11:38:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:50772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728915AbgHaPiV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 11:38:21 -0400
Received: from C02WT3WMHTD6 (unknown [199.255.45.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 587BC207EA;
        Mon, 31 Aug 2020 15:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598888301;
        bh=dRR9aUt1NjPXzfH/fGTX+Nj32yowbXOxYq5Ror+CR0s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CC7d46o+Pm+CkvVrOB6UW6BBM9rmOkPiQmp8VCMBWRsaDgBozGt3RQ+vaCsJaINAQ
         vmjiHw+dZnpdKROSf2KSQFxMBL4ATQpUvXS0jVcvdSpzcMPrHlrRZ1iLDicQUA6cjr
         tB91n7rcJZzyDW8n+usl9/e12mMS/7m/AaPHoiuU=
Date:   Mon, 31 Aug 2020 09:38:18 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>,
        linux-nvme@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.8 11/42] nvme: skip noiob for zoned devices
Message-ID: <20200831153818.GA83475@C02WT3WMHTD6>
References: <20200831152934.1023912-1-sashal@kernel.org>
 <20200831152934.1023912-11-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200831152934.1023912-11-sashal@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 31, 2020 at 11:29:03AM -0400, Sasha Levin wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> [ Upstream commit c41ad98bebb8f4f0335b3c50dbb7583a6149dce4 ]
> 
> Zoned block devices reuse the chunk_sectors queue limit to define zone
> boundaries. If a such a device happens to also report an optimal
> boundary, do not use that to define the chunk_sectors as that may
> intermittently interfere with io splitting and zone size queries.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

You can safely drop this from stable: nvme zoned devices were only introduced
to linux in 5.9.
