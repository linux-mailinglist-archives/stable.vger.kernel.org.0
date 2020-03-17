Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7056E18917C
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 23:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbgCQWab (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 18:30:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:38902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727232AbgCQWa3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 18:30:29 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6840A20738;
        Tue, 17 Mar 2020 22:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584484228;
        bh=69Vm+ZQ+trBq00La+Q/6ySMamY+DRfo+xpTdpnHr0Oc=;
        h=Date:From:To:To:To:To:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Subject:
         In-Reply-To:References:From;
        b=CTUc7HSF39IWepT00n+94v26NGOm7rTWCAGERCPEOdcK73rLbTqIMTxci2mUxSSU8
         wuIC7mVNpPD7zWRfvVxJZ1/x1+LFcffGrDw2ePB3ezcOjqw3eR280zNZJUYO3+nvrV
         Lt2vzX2pAz3+VSPYxndH1FjK+PMAO0jb1yosheQI=
Date:   Tue, 17 Mar 2020 22:30:27 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
To:     Eric Biggers <ebiggers@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>
Cc:     stable@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jeff Vander Stoep <jeffv@google.com>
Cc:     Jessica Yu <jeyu@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>
Cc:     NeilBrown <neilb@suse.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v3 2/5] fs/filesystems.c: downgrade user-reachable WARN_ONCE() to pr_warn_once()
In-Reply-To: <20200314213426.134866-3-ebiggers@kernel.org>
References: <20200314213426.134866-3-ebiggers@kernel.org>
Message-Id: <20200317223028.6840A20738@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.5.9, v5.4.25, v4.19.109, v4.14.173, v4.9.216, v4.4.216.

v5.5.9: Build OK!
v5.4.25: Build OK!
v4.19.109: Build OK!
v4.14.173: Build OK!
v4.9.216: Failed to apply! Possible dependencies:
    41124db869b7 ("fs: warn in case userspace lied about modprobe return")

v4.4.216: Failed to apply! Possible dependencies:
    41124db869b7 ("fs: warn in case userspace lied about modprobe return")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
