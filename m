Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 454BB129AF0
	for <lists+stable@lfdr.de>; Mon, 23 Dec 2019 22:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbfLWVFc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Dec 2019 16:05:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:39282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726817AbfLWVFc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Dec 2019 16:05:32 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76252206D3;
        Mon, 23 Dec 2019 21:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577135131;
        bh=zjyFZwESQZ65QJ380qJjmEUtpHbALXhVfXBYnNm7L00=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DUDwg56J8iY+JqMUpvJHMnvsWfUs5yr3TpkLGMaU19mRJQLhIRVrmmfC7wsM0vjTz
         EbZftLgaBsF3wtnDzDP42hPqJ0SKpKl+CjQS+0XzhWcQC6dG8hqML0RD+AKlrUBeh/
         fJdVVxlUFVUlDgg12qGNrEq1JBDHTUtXSMyrDwEo=
Date:   Mon, 23 Dec 2019 16:05:30 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     josef@toxicpanda.com, dsterba@suse.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] btrfs: don't double lock the subvol_sem
 for rename exchange" failed to apply to 4.9-stable tree
Message-ID: <20191223210530.GY17708@sasha-vm>
References: <1577121074171148@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1577121074171148@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 23, 2019 at 12:11:14PM -0500, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.9-stable tree.
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
>From 943eb3bf25f4a7b745dd799e031be276aa104d82 Mon Sep 17 00:00:00 2001
>From: Josef Bacik <josef@toxicpanda.com>
>Date: Tue, 19 Nov 2019 13:59:20 -0500
>Subject: [PATCH] btrfs: don't double lock the subvol_sem for rename exchange
>
>If we're rename exchanging two subvols we'll try to lock this lock
>twice, which is bad.  Just lock once if either of the ino's are subvols.
>
>Fixes: cdd1fedf8261 ("btrfs: add support for RENAME_EXCHANGE and RENAME_WHITEOUT")
>CC: stable@vger.kernel.org # 4.4+
>Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>Reviewed-by: David Sterba <dsterba@suse.com>
>Signed-off-by: David Sterba <dsterba@suse.com>

I've fixed it up and queued for 4.9. I don't think it needs to go to 4.4
as cdd1fedf8261 isn't in 4.4.

-- 
Thanks,
Sasha
