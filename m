Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 219111C9A4C
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 21:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgEGTBi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 15:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726320AbgEGTBi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 15:01:38 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E72C05BD43;
        Thu,  7 May 2020 12:01:37 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWllz-0039PB-Sr; Thu, 07 May 2020 19:01:32 +0000
Date:   Thu, 7 May 2020 20:01:31 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Max Kellermann <mk@cm4all.com>
Cc:     axboe@kernel.dk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] fs/io_uring: fix O_PATH fds in openat, openat2, statx
Message-ID: <20200507190131.GF23230@ZenIV.linux.org.uk>
References: <20200507185725.15840-1-mk@cm4all.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200507185725.15840-1-mk@cm4all.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 07, 2020 at 08:57:25PM +0200, Max Kellermann wrote:
> If an operation's flag `needs_file` is set, the function
> io_req_set_file() calls io_file_get() to obtain a `struct file*`.
> 
> This fails for `O_PATH` file descriptors, because those have no
> `struct file*`

O_PATH descriptors most certainly *do* have that.  What the hell
are you talking about?
