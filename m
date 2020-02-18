Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76F9E162AD9
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 17:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgBRQl1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 11:41:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:59668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726360AbgBRQl1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 11:41:27 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8DF4208C4;
        Tue, 18 Feb 2020 16:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582044086;
        bh=Do8Ovq6qe32ZI+m7BnRvhdkf/2NyySHdZcSO22JnP18=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=z/kQjYPcjvZMSULv4aRBr0bJZF13cWn9JYChReEgEjeFszLglulwTMnlPSsv+ivU0
         pYpm746A7A9c3wvgRinObgfB9vq6pEq1Ri9CojCzntYFxRrYF1h7JvWsa1JyD/NvmK
         wkV3R16WQ9vd89Hr0HrWnOzVzY6q1UaN9fjghsWA=
Date:   Tue, 18 Feb 2020 11:41:25 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     dsterba@suse.com, anand.jain@oracle.com,
        johannes.thumshirn@wdc.com, lists@colorremedies.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] btrfs: print message when tree-log replay
 starts" failed to apply to 4.9-stable tree
Message-ID: <20200218164125.GP1734@sasha-vm>
References: <1581966528133167@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1581966528133167@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 17, 2020 at 08:08:48PM +0100, gregkh@linuxfoundation.org wrote:
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
>From e8294f2f6aa6208ed0923aa6d70cea3be178309a Mon Sep 17 00:00:00 2001
>From: David Sterba <dsterba@suse.com>
>Date: Wed, 5 Feb 2020 17:12:16 +0100
>Subject: [PATCH] btrfs: print message when tree-log replay starts
>
>There's no logged information about tree-log replay although this is
>something that points to previous unclean unmount. Other filesystems
>report that as well.
>
>Suggested-by: Chris Murphy <lists@colorremedies.com>
>CC: stable@vger.kernel.org # 4.4+
>Reviewed-by: Anand Jain <anand.jain@oracle.com>
>Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>Signed-off-by: David Sterba <dsterba@suse.com>

Context changes due to 0b246afa62b0 ("btrfs: root->fs_info cleanup, add
fs_info convenience variables"). Cleaned up and queued on 4.9 and 4.4.

-- 
Thanks,
Sasha
