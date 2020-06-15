Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB3BC1F8F2B
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 09:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbgFOHP5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 03:15:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:53078 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728260AbgFOHP5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jun 2020 03:15:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1A63CADC1;
        Mon, 15 Jun 2020 07:16:00 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id CC6ED1E1289; Mon, 15 Jun 2020 09:15:55 +0200 (CEST)
Date:   Mon, 15 Jun 2020 09:15:55 +0200
From:   Jan Kara <jack@suse.cz>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        Martijn Coenen <maco@android.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/4] writeback: Avoid skipping inode writeback
Message-ID: <20200615071555.GC9449@quack2.suse.cz>
References: <20200611075033.1248-1-jack@suse.cz>
 <20200611081203.18161-2-jack@suse.cz>
 <20200615062733.GB26438@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200615062733.GB26438@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun 14-06-20 23:27:33, Christoph Hellwig wrote:
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks for review!

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
