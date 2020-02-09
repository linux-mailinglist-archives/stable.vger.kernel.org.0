Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93A86156BFC
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 19:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbgBISNw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 13:13:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:51932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727408AbgBISNw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Feb 2020 13:13:52 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DF2220715;
        Sun,  9 Feb 2020 18:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581272031;
        bh=PIc1GhBwod0iAueVIQMABnvvYhdDYxJVRZ6Ysyc7I74=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cH+eRemuZ/hwiHeVMVCnizd+gF6+I1sNkSUuEA3Zbo1ToW8cHSNmi3NB50jLV13uc
         /c4mPY/Cys6QDGucRFo9SBbxnGQWzuYal92mdM6qyul3ztzOcjBXQqnV5a3Tjh0sYQ
         1izVGXiLOCbVEI1MoP1ts1Tu33jduD06C97QU7sg=
Date:   Sun, 9 Feb 2020 13:13:50 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     hverkuil-cisco@xs4all.nl, mchehab+huawei@kernel.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] media: cec: CEC 2.0-only bcast messages
 were ignored" failed to apply to 5.5-stable tree
Message-ID: <20200209181350.GL3584@sasha-vm>
References: <1581248809208186@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1581248809208186@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 09, 2020 at 12:46:49PM +0100, gregkh@linuxfoundation.org wrote:
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
>From 01d4fb115470e9f88a58975fe157a9e8b214dfe5 Mon Sep 17 00:00:00 2001
>From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>Date: Wed, 4 Dec 2019 08:52:08 +0100
>Subject: [PATCH] media: cec: CEC 2.0-only bcast messages were ignored
>
>Some messages are allowed to be a broadcast message in CEC 2.0
>only, and should be ignored by CEC 1.4 devices.
>
>Unfortunately, the check was wrong, causing such messages to be
>marked as invalid under CEC 2.0.
>
>Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>Cc: <stable@vger.kernel.org>      # for v4.10 and up
>Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

Looks like we somehow ended up with duplicate commits upstream:

cec935ce69fc ("media: cec: CEC 2.0-only bcast messages were ignored")
01d4fb115470 ("media: cec: CEC 2.0-only bcast messages were ignored")

cec935ce69fc is already queued for all relevant trees, so nothing to do
here.

-- 
Thanks,
Sasha
