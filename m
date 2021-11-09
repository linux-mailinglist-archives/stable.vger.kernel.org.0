Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6459F44A816
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 09:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243902AbhKIIFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 03:05:54 -0500
Received: from verein.lst.de ([213.95.11.211]:48956 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236699AbhKIIFy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 03:05:54 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2CB7467373; Tue,  9 Nov 2021 09:03:07 +0100 (CET)
Date:   Tue, 9 Nov 2021 09:03:07 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Coly Li <colyli@suse.de>
Cc:     axboe@kernel.dk, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH] bcache: Revert "bcache: use bvec_virt"
Message-ID: <20211109080307.GA28368@lst.de>
References: <20211103151041.70516-1-colyli@suse.de> <0bfbf514-4036-23ff-436a-01e0b7eba67e@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0bfbf514-4036-23ff-436a-01e0b7eba67e@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 08, 2021 at 04:16:51PM +0800, Coly Li wrote:
> Since now we don't have a better alternative patch yet, and this issue 
> should be fixed ASAP. Could you please take it firstly. And I will work 
> with Christoph for a better change (maybe large and not trivial) later for 
> next merge window?

fine with me.
