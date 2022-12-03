Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24C756416D5
	for <lists+stable@lfdr.de>; Sat,  3 Dec 2022 14:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiLCNU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Dec 2022 08:20:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiLCNU0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Dec 2022 08:20:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B0982FA7B;
        Sat,  3 Dec 2022 05:20:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 948A1B801B8;
        Sat,  3 Dec 2022 13:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF21C433D7;
        Sat,  3 Dec 2022 13:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670073622;
        bh=FA8wG+TmI0jjLm+PEKI6Gs91S5fGWad/75Vg32u7S3A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dQTmQRpfJR9uWmXkvVySobe663HTIbFNfmT0VE5zSj46Y02g7Vd+tMDAhUqXCef1H
         cqV75HljhlvtX03CO+cU/3CqosrcAopl7WiWnFQI5Dri4BZC5lH66XDrHe755Nzly3
         ft0QCJDOjj2VexbRVEEW+SYZ+tVY8Cl9z5eDT3wg=
Date:   Sat, 3 Dec 2022 14:20:17 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Samiullah Khawaja <skhawaja@google.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Hao Xu <haoxu@linux.alibaba.com>,
        Abaci <abaci@linux.alibaba.com>
Subject: Re: [PATCH] io_uring: don't hold uring_lock when calling
 io_run_task_work*
Message-ID: <Y4tNEQwoKN6LP1gQ@kroah.com>
References: <20221203002305.1203792-1-skhawaja@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221203002305.1203792-1-skhawaja@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 03, 2022 at 12:23:05AM +0000, Samiullah Khawaja wrote:
> From: Hao Xu <haoxu@linux.alibaba.com>
> 
> commit 8bad28d8a305b0e5ae444c8c3051e8744f5a4296 upstream.
> 
> [Backported on top of stable 5.10 since the issue was introduced into it
> with commit referred in Fixes tag below. The backport is done without
> `file` to `rsrc` refactoring since it is not in 5.10].

Now queued up, thanks.

greg k-h
