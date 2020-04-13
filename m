Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 381B91A6B47
	for <lists+stable@lfdr.de>; Mon, 13 Apr 2020 19:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732731AbgDMRTm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 13:19:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:40942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732579AbgDMRTl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Apr 2020 13:19:41 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AC812072D;
        Mon, 13 Apr 2020 17:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586798380;
        bh=yY0rQs26mjwo4CRbKLXgGHPV+jq13LwUqB+ccE+/pe0=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=uZ/ita1yPNr1a1qgXhNls0aieUWKSAAYdLNicKnjmj9eKyTlQyTZkfniKFh9d7VQO
         2ac426AbiSNfdEX10f/FGijnIrA/EgffOFLZkisvYKHVDG4edX7iSGPIF1C6sl26jV
         64dQnlAUcedSsPWRy4dYWbbT2FSScP63Z0+xC7W4=
Date:   Mon, 13 Apr 2020 13:19:39 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     dsterba@suse.cz, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.6 64/68] btrfs: hold a ref on the root in
 btrfs_recover_relocation
Message-ID: <20200413171939.GQ27528@sasha-vm>
References: <20200410034634.7731-1-sashal@kernel.org>
 <20200410034634.7731-64-sashal@kernel.org>
 <20200410100906.GH5920@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200410100906.GH5920@suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 10, 2020 at 12:09:06PM +0200, David Sterba wrote:
>On Thu, Apr 09, 2020 at 11:46:29PM -0400, Sasha Levin wrote:
>> From: Josef Bacik <josef@toxicpanda.com>
>>
>> [ Upstream commit 932fd26df8125a5b14438563c4d3e33f59ba80f7 ]
>>
>> We look up the fs root in various places in here when recovering from a
>> crashed relcoation.  Make sure we hold a ref on the root whenever we
>> look them up.
>>
>> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>> Reviewed-by: David Sterba <dsterba@suse.com>
>> Signed-off-by: David Sterba <dsterba@suse.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>Please drop this patch from all stable versions. It's part of a
>larger series that is preparatory switching from SRCU to refcounts, so
>the patch on itself does not fix anything.

I've dropped it, thanks!

-- 
Thanks,
Sasha
