Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA934189DAF
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 15:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbgCRORw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 10:17:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726832AbgCRORw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 10:17:52 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9648320772;
        Wed, 18 Mar 2020 14:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584541071;
        bh=N0D5LeZio2aQmXspsBdMkjr6mizWCtl3HrFbXFqOHu0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BCtnZK28fmK9IPKyLn6/TaZA8Fv2ROuGB17tPw58aoZCpSP9WLiftEdzzpc47TpU8
         5C3Qvo3iqGOqaSq3EAt2DN4G4JBoG0X77sGv7aHUZTbDmpAgNDSKMSzYreuHJaW4c8
         U6ot8ztszk8zTKQ31GUl0Ju/HJTYAtIlGeNY9Gf4=
Date:   Wed, 18 Mar 2020 10:17:50 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     sven@narfation.org, hdanton@sina.com, sw@simonwunderlich.de,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] batman-adv: Don't schedule OGM for
 disabled interface" failed to apply to 4.4-stable tree
Message-ID: <20200318141750.GD4189@sasha-vm>
References: <158436631216439@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158436631216439@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 16, 2020 at 02:45:12PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.4-stable tree.
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
>From 8e8ce08198de193e3d21d42e96945216e3d9ac7f Mon Sep 17 00:00:00 2001
>From: Sven Eckelmann <sven@narfation.org>
>Date: Sun, 16 Feb 2020 13:02:06 +0100
>Subject: [PATCH] batman-adv: Don't schedule OGM for disabled interface
>
>A transmission scheduling for an interface which is currently dropped by
>batadv_iv_ogm_iface_disable could still be in progress. The B.A.T.M.A.N. V
>is simply cancelling the workqueue item in an synchronous way but this is
>not possible with B.A.T.M.A.N. IV because the OGM submissions are
>intertwined.
>
>Instead it has to stop submitting the OGM when it detect that the buffer
>pointer is set to NULL.
>
>Reported-by: syzbot+a98f2016f40b9cd3818a@syzkaller.appspotmail.com
>Reported-by: syzbot+ac36b6a33c28a491e929@syzkaller.appspotmail.com
>Fixes: c6c8fea29769 ("net: Add batman-adv meshing protocol")
>Signed-off-by: Sven Eckelmann <sven@narfation.org>
>Cc: Hillf Danton <hdanton@sina.com>
>Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>

Adjusted context and queued up for 4.4.

-- 
Thanks,
Sasha
