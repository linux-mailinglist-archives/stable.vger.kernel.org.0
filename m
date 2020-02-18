Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41910162AB7
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 17:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgBRQeg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 11:34:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:57686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726463AbgBRQeg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 11:34:36 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78D0C2067D;
        Tue, 18 Feb 2020 16:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582043675;
        bh=38pIPgr0SIlILfPwKfHcOjQRVByXmIZpCbuDeUz8sxg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2EwH9TV8s8Ix8N0dcm4gT6BXaL7QobeNYKVAKKOc/CF8nakV0WK5c4A/0dMF1NhgZ
         P5eBnqzU2G3rhC+wzToL4yHr7TVfjwuRF6E+J8JQAno0kWD+CgRQQy60yJ65TBxW6C
         0wrJ0ZCCcPfDLerplttFKemLWN8AzkaLhysKABQ0=
Date:   Tue, 18 Feb 2020 11:34:34 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     jack@suse.cz, scan-admin@coverity.com, tytso@mit.edu,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ext4: simplify checking quota limits in
 ext4_statfs()" failed to apply to 5.5-stable tree
Message-ID: <20200218163434.GO1734@sasha-vm>
References: <1581966460247127@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1581966460247127@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 17, 2020 at 08:07:40PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.5-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 46d36880d1c6f9b9a0cbaf90235355ea1f4cab96 Mon Sep 17 00:00:00 2001
>From: Jan Kara <jack@suse.cz>
>Date: Thu, 30 Jan 2020 12:11:48 +0100
>Subject: [PATCH] ext4: simplify checking quota limits in ext4_statfs()
>
>Coverity reports that conditions checking quota limits in ext4_statfs()
>contain dead code. Indeed it is right and current conditions can be
>simplified.
>
>Link: https://lore.kernel.org/r/20200130111148.10766-1-jack@suse.cz
>Reported-by: Coverity <scan-admin@coverity.com>
>Signed-off-by: Jan Kara <jack@suse.cz>
>Signed-off-by: Theodore Ts'o <tytso@mit.edu>
>Cc: stable@kernel.org

I've also grabbed 57c32ea42f8e ("ext4: choose hardlimit when softlimit
is larger than hardlimit in ext4_statfs_project()") which fixes a user
visible issue and introduces the issue fixed by this patch.

Both queued for 5.5 and 5.4.

I'm not quite sure that this patch is stable material.

-- 
Thanks,
Sasha
