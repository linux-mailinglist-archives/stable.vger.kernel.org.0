Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3F39252483
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 01:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgHYX6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 19:58:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726391AbgHYX6d (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Aug 2020 19:58:33 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45DC32075F;
        Tue, 25 Aug 2020 23:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598399913;
        bh=j6Og6H7E6tMA09gTSQoWm477QKg5G+1faoMcMRsz+CQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2IRhYyJsxM8cBPSy9ZUjSSu1mhLDpmT6rZQ7JUMbucHrnh90AUnPm09eN54zeSAxj
         fu3eLA3Qqwqk2BDp8FzmvahJrBlKkm4bxB30F6x1xpz3iSPzRkDCfCjFzhPBkNwqvk
         LPjixUXa9dQzEgBwiQJXsSOWYgLhWOECK3TcAGSk=
Date:   Tue, 25 Aug 2020 19:58:32 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 4.19 09/71] btrfs: sysfs: use NOFS for device creation
Message-ID: <20200825235832.GJ8670@sasha-vm>
References: <20200824082355.848475917@linuxfoundation.org>
 <20200824082356.348762357@linuxfoundation.org>
 <20200825181930.GA989@bug>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200825181930.GA989@bug>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 25, 2020 at 08:19:30PM +0200, Pavel Machek wrote:
>Hi!
>
>> From: Josef Bacik <josef@toxicpanda.com>
>>
>> Dave hit this splat during testing btrfs/078:
>
>...
>
>> CC: stable@vger.kernel.org # 4.14+
>
>This commit is in mainline, as a47bd78d0c44621efb98b525d04d60dc4d1a79b0, but is not marked
>as such.

Fixed, thanks!

-- 
Thanks,
Sasha
