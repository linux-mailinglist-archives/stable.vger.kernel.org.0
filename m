Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5194B189F30
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 16:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbgCRPJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 11:09:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:37966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727358AbgCRPJc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 11:09:32 -0400
Received: from linux-8ccs (p5B2812F9.dip0.t-ipconnect.de [91.40.18.249])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A023A2077B;
        Wed, 18 Mar 2020 15:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584544172;
        bh=aHZiDxNtkH9uKX5LTVYuL8uU5FzKPoKE0R7mstLdl4E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mgkYEWvuOawdYAWh84+SpVzCcX/RI3kv0G510cmQjtfBQwf3ypQaLo+KZ6rKe27Fh
         PZ3iZHeh3XqLrRFtv0i7nslq+nTalrGzxyp3CLSZpuoNOZuoc9t3s1h+PB5xgBq3XU
         Frxw/nJa6xdFsaOJ/fewWBmSZMaTXNYDtI+JaRnE=
Date:   Wed, 18 Mar 2020 16:09:26 +0100
From:   Jessica Yu <jeyu@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeff Vander Stoep <jeffv@google.com>,
        Kees Cook <keescook@chromium.org>, NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v3 2/5] fs/filesystems.c: downgrade user-reachable
 WARN_ONCE() to pr_warn_once()
Message-ID: <20200318150926.GA4144@linux-8ccs>
References: <20200314213426.134866-3-ebiggers@kernel.org>
 <20200317223028.6840A20738@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200317223028.6840A20738@mail.kernel.org>
X-OS:   Linux linux-8ccs 4.12.14-lp150.12.61-default x86_64
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+++ Sasha Levin [17/03/20 22:30 +0000]:
>Hi
>
>[This is an automated email]
>
>This commit has been processed because it contains a -stable tag.
>The stable tag indicates that it's relevant for the following trees: all
>
>The bot has tested the following trees: v5.5.9, v5.4.25, v4.19.109, v4.14.173, v4.9.216, v4.4.216.
>
>v5.5.9: Build OK!
>v5.4.25: Build OK!
>v4.19.109: Build OK!
>v4.14.173: Build OK!
>v4.9.216: Failed to apply! Possible dependencies:
>    41124db869b7 ("fs: warn in case userspace lied about modprobe return")
>
>v4.4.216: Failed to apply! Possible dependencies:
>    41124db869b7 ("fs: warn in case userspace lied about modprobe return")
>
>
>NOTE: The patch will not be queued to stable trees until it is upstream.
>
>How should we proceed with this patch?

Since commit 41124db869b7 was introduced v4.13, I guess we should
change the stable tag to:

Cc: stable@vger.kernel.org # v4.13+

