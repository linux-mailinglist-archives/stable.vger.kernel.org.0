Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF462EA62D
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 08:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbhAEHwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 02:52:13 -0500
Received: from verein.lst.de ([213.95.11.211]:60404 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727124AbhAEHwN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Jan 2021 02:52:13 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9AB4167373; Tue,  5 Jan 2021 08:51:31 +0100 (CET)
Date:   Tue, 5 Jan 2021 08:51:31 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org,
        syzbot+825f0f9657d4e528046e@syzkaller.appspotmail.com
Subject: Re: [PATCH] block: fix use-after-free in disk_part_iter_next
Message-ID: <20210105075131.GA30262@lst.de>
References: <20201221043335.2831589-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201221043335.2831589-1-ming.lei@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 21, 2020 at 12:33:35PM +0800, Ming Lei wrote:
> Make sure that bdgrab() is done on the 'block_device' instance before
> referring to it for avoiding use-after-free.
> 
> Cc: <stable@vger.kernel.org>
> Reported-by: syzbot+825f0f9657d4e528046e@syzkaller.appspotmail.com
> Signed-off-by: Ming Lei <ming.lei@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
