Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF1AB150A48
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 16:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbgBCPw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 10:52:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:37788 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728193AbgBCPw7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 10:52:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8E723AE3F;
        Mon,  3 Feb 2020 15:52:57 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id CBB4DDA81B; Mon,  3 Feb 2020 16:52:36 +0100 (CET)
Date:   Mon, 3 Feb 2020 16:52:36 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     dsterba@suse.com, stable-commits@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: Patch "btrfs: dev-replace: remove warning for unknown return
 codes when finished" has been added to the 5.4-stable tree
Message-ID: <20200203155236.GC3929@suse.cz>
Reply-To: dsterba@suse.cz
References: <20200203151217.B722421582@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200203151217.B722421582@mail.kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 03, 2020 at 10:12:16AM -0500, Sasha Levin wrote:
> This is a note to let you know that I've just added the patch titled
> 
>     btrfs: dev-replace: remove warning for unknown return codes when finished
> 
> to the 5.4-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      btrfs-dev-replace-remove-warning-for-unknown-return-.patch
> and it can be found in the queue-5.4 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.


> commit 87058e8dca6c3ecb0ae52d1275ee0e775fac06b9
> Author: David Sterba <dsterba@suse.com>
> Date:   Sat Jan 25 12:35:38 2020 +0100
> 
>     btrfs: dev-replace: remove warning for unknown return codes when finished

Please remove the commit from stable-queue, the patch makes sense with
1bbb97b8ce7ddf3a56 ("btrfs: scrub: Require mandatory block group RO for
dev-replace") which was a regression fix in 5.5.
