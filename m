Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67ECB135B8B
	for <lists+stable@lfdr.de>; Thu,  9 Jan 2020 15:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730111AbgAIOjC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jan 2020 09:39:02 -0500
Received: from verein.lst.de ([213.95.11.211]:55040 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbgAIOjC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Jan 2020 09:39:02 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7FCE768BFE; Thu,  9 Jan 2020 15:38:59 +0100 (CET)
Date:   Thu, 9 Jan 2020 15:38:59 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Chen-Yu Tsai <wens@kernel.org>
Cc:     Russell King <linux@armlinux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Robin Murphy <robin.murphy@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH RESEND v2] ARM: dma-api: fix max_pfn off-by-one error
 in __dma_supported()
Message-ID: <20200109143859.GA22907@lst.de>
References: <20191224030239.5656-1-wens@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191224030239.5656-1-wens@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
