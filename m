Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C015D3563BA
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 08:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345406AbhDGGKO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 02:10:14 -0400
Received: from verein.lst.de ([213.95.11.211]:57552 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230075AbhDGGKN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Apr 2021 02:10:13 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 10DD168B05; Wed,  7 Apr 2021 08:10:01 +0200 (CEST)
Date:   Wed, 7 Apr 2021 08:10:00 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ricardo Ribalda <ribalda@chromium.org>
Cc:     Tomasz Figa <tfiga@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        iommu@lists.linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH RESEND] lib/scatterlist: Fix NULL pointer deference
Message-ID: <20210407061000.GA19527@lst.de>
References: <20210406160435.206115-1-ribalda@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406160435.206115-1-ribalda@chromium.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
