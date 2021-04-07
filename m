Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B024E356308
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 07:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233584AbhDGF2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 01:28:18 -0400
Received: from verein.lst.de ([213.95.11.211]:57436 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233085AbhDGF2R (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Apr 2021 01:28:17 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 666C368B02; Wed,  7 Apr 2021 07:28:06 +0200 (CEST)
Date:   Wed, 7 Apr 2021 07:28:06 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>, linux-nvme@lists.infradead.org
Subject: Re: [PATCH stable/5.4..5.8] nvme-mpath: replace
 direct_make_request with generic_make_request
Message-ID: <20210407052806.GA18573@lst.de>
References: <20210402200841.347696-1-sagi@grimberg.me> <YGgG2TAA9TNqM9S6@kroah.com> <00e36c71-9f2c-5b38-96fd-3d471382f6ac@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00e36c71-9f2c-5b38-96fd-3d471382f6ac@grimberg.me>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 06, 2021 at 06:04:09PM -0700, Sagi Grimberg wrote:
>
>>> Hence, we need to fix all the kernels that were before submit_bio_noacct was
>>> introduced.
>>
>> Why can we not just add submit_bio_noacct to the 5.4 kernel to correct
>> this?  What commit id is that?
>
> Hey Greg,
>
> submit_bio_noacct was applied as part of a rework by Christoph that I
> didn't feel was suitable as a stable candidate. The commit-id is:
> ed00aabd5eb9fb44d6aff1173234a2e911b9fead

submit_bio_noacct really is just a new name for generic_make_request,
as the old one was horribly misleading.  So this does use
submit_bio_noacct, just with its old name.
