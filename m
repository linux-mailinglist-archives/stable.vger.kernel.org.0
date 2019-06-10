Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC67E3B168
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 11:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388604AbfFJJAP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 05:00:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:43910 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388190AbfFJJAP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jun 2019 05:00:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 624E1AFDB;
        Mon, 10 Jun 2019 09:00:14 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 2B0051E3FCB; Mon, 10 Jun 2019 11:00:13 +0200 (CEST)
Date:   Mon, 10 Jun 2019 11:00:13 +0200
From:   Jan Kara <jack@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>,
        syzbot+10007d66ca02b08f0e60@syzkaller.appspotmail.com,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.1 35/70] loop: Don't change loop device under
 exclusive opener
Message-ID: <20190610090013.GF12765@quack2.suse.cz>
References: <20190608113950.8033-1-sashal@kernel.org>
 <20190608113950.8033-35-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190608113950.8033-35-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat 08-06-19 07:39:14, Sasha Levin wrote:
> From: Jan Kara <jack@suse.cz>
> 
> [ Upstream commit 33ec3e53e7b1869d7851e59e126bdb0fe0bd1982 ]

Please don't push this to stable kernels because...

> [Deliberately chosen not to CC stable as a user with priviledges to
> trigger this race has other means of taking the system down and this
> has a potential of breaking some weird userspace setup]

... of this. Thanks!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
