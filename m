Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ACC9A5F92
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 05:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725839AbfICDOq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Sep 2019 23:14:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725823AbfICDOq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Sep 2019 23:14:46 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F941217F5;
        Tue,  3 Sep 2019 03:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567480485;
        bh=84SSkUbVWZFjue21umugkgah+QJnHOj6thjv3m9m9so=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uEBz6+ZTdXNw7z6yvye28JN+LYPbnrsmEWSVH+W72JoXoQFRyDlLbfP/k2hTEcVbn
         YJdg58PpBY6Lh6RvYJfa18oImeKc36tGQh/6Rzl4CI9lsHtwF4Ryi/Fv5dslr9090N
         q+DFGDUkKvzw5DKhvGCv8Awb3iGFHpk191lX0NQI=
Date:   Mon, 2 Sep 2019 23:14:44 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     henryburns@google.com, akpm@linux-foundation.org,
        henrywolfeburns@gmail.com, jwadams@google.com, minchan@kernel.org,
        sergey.senozhatsky@gmail.com, shakeelb@google.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: FAILED: patch "[PATCH] mm/zsmalloc.c: fix race condition in
 zs_destroy_pool" failed to apply to 4.9-stable tree
Message-ID: <20190903031444.GE5281@sasha-vm>
References: <156684443123212@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <156684443123212@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 26, 2019 at 08:33:51PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.9-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.

I've backported it to 4.9, it is not needed on 4.4.

--
Thanks,
Sasha
