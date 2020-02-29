Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF71B1744D1
	for <lists+stable@lfdr.de>; Sat, 29 Feb 2020 04:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgB2D7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 22:59:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:38458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbgB2D7G (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Feb 2020 22:59:06 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94AB7246AE;
        Sat, 29 Feb 2020 03:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582948745;
        bh=Qdv3bK/WoCDERq/riw4r7VNsO/NCekTz4RBMozCRqqM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NDdaUjQKVAkWlYcL6glS2nrqi0Z8mIsqJP/3KkcQdSFSZ8PYOvS8Nmaj5L4HH+/2y
         zou+rpOihPZkVrqJFHdZwmviDXU1V66LxBJLUSAFVttPBEIm8aPp29ln0n3h3oSIhM
         SiuWEGxWzic+/44767uZZ8bLZg1vKfbjTBrKyXE8=
Date:   Fri, 28 Feb 2020 22:59:04 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Suraj Jitindar Singh <surajjs@amazon.com>
Cc:     stable@vger.kernel.org, tytso@mit.edu, stable@kernel.org
Subject: Re: [PATCH 4.14.x 1/3] ext4: fix potential race between online
 resizing and write operations
Message-ID: <20200229035904.GI21491@sasha-vm>
References: <1582790918190214@kroah.com>
 <20200229004817.13283-1-surajjs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200229004817.13283-1-surajjs@amazon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 28, 2020 at 04:48:15PM -0800, Suraj Jitindar Singh wrote:
>From: Theodore Ts'o <tytso@mit.edu>
>
>commit 1d0c3924a92e69bfa91163bda83c12a994b4d106 upstream.
>
>During an online resize an array of pointers to buffer heads gets
>replaced so it can get enlarged.  If there is a racing block
>allocation or deallocation which uses the old array, and the old array
>has gotten reused this can lead to a GPF or some other random kernel
>memory getting modified.
>
>Link: https://bugzilla.kernel.org/show_bug.cgi?id=206443
>Link: https://lore.kernel.org/r/20200221053458.730016-2-tytso@mit.edu
>Reported-by: Suraj Jitindar Singh <surajjs@amazon.com>
>Signed-off-by: Theodore Ts'o <tytso@mit.edu>
>Cc: stable@kernel.org # 4.14.x

I've applied this and the 4.9 and 4.4 series.

Note that patch 2 in all of your serieses didn't apply cleanly for me,
but cherry picking the upstream commit directly worked so I did that.

-- 
Thanks,
Sasha
