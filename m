Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF578162E5B
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 19:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgBRSV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 13:21:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:50530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726239AbgBRSV6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 13:21:58 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6ADA22070B;
        Tue, 18 Feb 2020 18:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582050117;
        bh=rnX6akybykBjdLmAttuKkq5bb2/+L0i7heQ8fdElRmk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cI5GCWuqfSuec2abhDGoXui0SbDBTdsRCllcm8RU2BJO9dum9Y4qmXw0Fyc1aUf+n
         BEVNbp8xhjiHIxZll/e/KfoFbQBLAtJzbQvW0xH/V6DMcIQgLzpIjR1Pq4SfAqx6ZV
         M61r6n6gf2wFWkh/dm9nQQXKpXP1svZ3r98gUQhI=
Date:   Tue, 18 Feb 2020 13:21:56 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     gregkh@linuxfoundation.org, jack@suse.cz, scan-admin@coverity.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ext4: simplify checking quota limits in
 ext4_statfs()" failed to apply to 5.5-stable tree
Message-ID: <20200218182156.GV1734@sasha-vm>
References: <1581966460247127@kroah.com>
 <20200218163434.GO1734@sasha-vm>
 <20200218170801.GD147128@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200218170801.GD147128@mit.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 18, 2020 at 12:08:01PM -0500, Theodore Y. Ts'o wrote:
>> I'm not quite sure that this patch is stable material.
>
>Yeah, that was a misfire on my part.  I think I had somehow convinced
>myself that it was a prereq for another patch that was stable
>material, but looking at it again, that's not the case.

I'll drop it, thanks.

-- 
Thanks,
Sasha
