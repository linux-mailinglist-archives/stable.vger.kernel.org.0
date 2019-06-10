Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 283AB3B16E
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 11:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388734AbfFJJAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 05:00:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:44012 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388190AbfFJJAy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jun 2019 05:00:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3CAF7AFDD;
        Mon, 10 Jun 2019 09:00:53 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id D8FD61E3FCB; Mon, 10 Jun 2019 11:00:52 +0200 (CEST)
Date:   Mon, 10 Jun 2019 11:00:52 +0200
From:   Jan Kara <jack@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>,
        syzbot+10007d66ca02b08f0e60@syzkaller.appspotmail.com,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 22/49] loop: Don't change loop device under
 exclusive opener
Message-ID: <20190610090052.GG12765@quack2.suse.cz>
References: <20190608114232.8731-1-sashal@kernel.org>
 <20190608114232.8731-22-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190608114232.8731-22-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat 08-06-19 07:42:03, Sasha Levin wrote:
> From: Jan Kara <jack@suse.cz>
> 
> [ Upstream commit 33ec3e53e7b1869d7851e59e126bdb0fe0bd1982 ]

The same as for 5.1 - please don't merge to stable.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
