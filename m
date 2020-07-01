Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13B36210274
	for <lists+stable@lfdr.de>; Wed,  1 Jul 2020 05:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbgGADVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 23:21:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:57866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgGADVG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Jun 2020 23:21:06 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49DE1206EB;
        Wed,  1 Jul 2020 03:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593573665;
        bh=HVE3zk0axge7bEVB9R3MN+tHjgbSu5Z3EnQtCZ/J3is=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aX3rxSXN3aYlH5qoFY36iOZXR74Osz9lgGNdE6uwg4XfUaR9viS8H7HGAWlNz31Fj
         UYNXzg92YOIzRSG0Do8iJ7cIbXh0svi4qHle5ryNWHfJHwIEuedxxkFt6UC5XJk0X7
         wE9HmmCets02jlHkYsmRfMxuxrobQeJya5T7PUJc=
Date:   Tue, 30 Jun 2020 23:21:04 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH 4.19 011/131] btrfs: make caching_thread use
 btrfs_find_next_key
Message-ID: <20200701032104.GA1931@sasha-vm>
References: <20200629153502.2494656-1-sashal@kernel.org>
 <20200629153502.2494656-12-sashal@kernel.org>
 <20200630210921.GA2728@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200630210921.GA2728@duo.ucw.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 30, 2020 at 11:09:21PM +0200, Pavel Machek wrote:
>On Mon 2020-06-29 11:33:02, Sasha Levin wrote:
>> From: Josef Bacik <josef@toxicpanda.com>
>>
>> [ Upstream commit 6a9fb468f1152d6254f49fee6ac28c3cfa3367e5 ]
>>
>> extent-tree.c has a find_next_key that just walks up the path to find
>> the next key, but it is used for both the caching stuff and the snapshot
>> delete stuff.  The snapshot deletion stuff is special so it can't really
>> use btrfs_find_next_key, but the caching thread stuff can.  We just need
>> to fix btrfs_find_next_key to deal with ->skip_locking and then it works
>> exactly the same as the private find_next_key helper.
>>
>> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>> Signed-off-by: David Sterba <dsterba@suse.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>According to changelog, this is not known to fix a bug. Why is it
>needed in stable?

Right. I've dropped it, thanks!


-- 
Thanks,
Sasha
