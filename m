Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1892129B49
	for <lists+stable@lfdr.de>; Mon, 23 Dec 2019 22:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfLWVul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Dec 2019 16:50:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:56884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726817AbfLWVul (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Dec 2019 16:50:41 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D20C206CB;
        Mon, 23 Dec 2019 21:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577137840;
        bh=G8WUhHSFl38jw+UYTzHY2z3ehGf+Hxx494gLHH24Jjc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Or8LNI6YkV0yius3FINwlpwq5uLExZ8lBx8YbtPUqLC93iN4vQiZSytxufNM0XdKi
         rWbnyWW8y9tXQLjBQgc8YtME/inUZCQNbfwXQbO9nP1gGE3Rgn/euerSPHEnCMn3V/
         ZPQA6T0/UQaHlG8J+ac95Vsa9DO7Z6ef2G7KD5qY=
Date:   Mon, 23 Dec 2019 16:50:39 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     josef@toxicpanda.com, dsterba@suse.com, fdmanana@suse.com,
        jthumshirn@suse.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] btrfs: abort transaction after failed
 inode updates in" failed to apply to 4.14-stable tree
Message-ID: <20191223215039.GB17708@sasha-vm>
References: <15771212987252@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15771212987252@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 23, 2019 at 12:14:58PM -0500, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.14-stable tree.
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
>From c7e54b5102bf3614cadb9ca32d7be73bad6cecf0 Mon Sep 17 00:00:00 2001
>From: Josef Bacik <josef@toxicpanda.com>
>Date: Fri, 6 Dec 2019 09:37:15 -0500
>Subject: [PATCH] btrfs: abort transaction after failed inode updates in
> create_subvol
>
>We can just abort the transaction here, and in fact do that for every
>other failure in this function except these two cases.
>
>CC: stable@vger.kernel.org # 4.4+
>Reviewed-by: Filipe Manana <fdmanana@suse.com>
>Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
>Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>Reviewed-by: David Sterba <dsterba@suse.com>
>Signed-off-by: David Sterba <dsterba@suse.com>

Random context conflicts due to the fs_info cleanup. Fixed up and queued
for 4.14-4.4.

-- 
Thanks,
Sasha
