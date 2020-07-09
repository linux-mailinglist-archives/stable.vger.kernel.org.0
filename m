Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 736C521AA78
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 00:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgGIW2R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jul 2020 18:28:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726213AbgGIW2R (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Jul 2020 18:28:17 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1504B2070E;
        Thu,  9 Jul 2020 22:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594333697;
        bh=vth7oOQ5CwiMgzvmWzAb0BCz7GgvktX0waV9e0XtVoc=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=DJmyEEKSnVjzen9FvYhBmCdwG6lqyHu4BDgbKQ8uVt8Lpl3sgaoHu0pMq6zjhHXFj
         3uSN+MA8SFzj1nW1NNAgPvf1ccok2ekLcrkXjSZmyOvMT4z5G+7LSoqGydB23cwTVR
         qEG3t/NbMbswdLntV59tSOUjQZPS6DREr/PPtqPE=
Date:   Thu, 9 Jul 2020 18:28:15 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     dsterba@suse.cz, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Waiman Long <longman@redhat.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.7 11/53] btrfs: use kfree() in
 btrfs_ioctl_get_subvol_info()
Message-ID: <20200709222815.GB2722994@sasha-vm>
References: <20200702012202.2700645-1-sashal@kernel.org>
 <20200702012202.2700645-11-sashal@kernel.org>
 <20200702082558.GH27795@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200702082558.GH27795@twin.jikos.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 02, 2020 at 10:25:58AM +0200, David Sterba wrote:
>On Wed, Jul 01, 2020 at 09:21:20PM -0400, Sasha Levin wrote:
>> From: Waiman Long <longman@redhat.com>
>>
>> [ Upstream commit b091f7fede97cc64f7aaad3eeb37965aebee3082 ]
>>
>> In btrfs_ioctl_get_subvol_info(), there is a classic case where kzalloc()
>> was incorrectly paired with kzfree(). According to David Sterba, there
>> isn't any sensitive information in the subvol_info that needs to be
>> cleared before freeing. So kzfree() isn't really needed, use kfree()
>> instead.
>
>I don't think this patch is necessary for any stable tree, it's meant
>only to ease merging a tree-wide patchset to rename kzfree.  In btrfs
>code there was no point using it so it's plain kfree.

I've dropped it, thanks!

-- 
Thanks,
Sasha
