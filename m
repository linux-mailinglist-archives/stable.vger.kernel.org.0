Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B13363415FB
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 07:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234191AbhCSGhM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 02:37:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:57018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234009AbhCSGg6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 02:36:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C46A564F6D;
        Fri, 19 Mar 2021 06:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616135818;
        bh=cyy9Hb8IHfkVltincQuck0xU7hsl1NVD+T5diBMYcqk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yZEYFrcw/z3BUKGR89SIgkhEokS9NYWlTjS+wdYqdUAv7FJ0ak/SvbnkgPJWZIBR6
         ndyzR1xL5Saaj8wUUTw4boWTEU33UMzE7zE58ygXu/KNl/lV3i6p9G+SsOs034j/Lx
         zfIuERlNocM3cXZMCgTICmPb96MjBJYWLW2nfsB0=
Date:   Fri, 19 Mar 2021 07:36:55 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH] io_uring: Try to merge io requests only for regular files
Message-ID: <YFRGh8TJ6zVYkyJO@kroah.com>
References: <20210319052859.3220-1-dmtrmonakhov@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319052859.3220-1-dmtrmonakhov@yandex-team.ru>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 19, 2021 at 05:28:59AM +0000, Dmitry Monakhov wrote:
> Otherwise we may endup blocking on pipe or socket.
> 
> Fixes: 6d5d5ac ("io_uring: extend async work merge")
> Testcase: https://github.com/dmonakhov/liburing/commit/16d171b6ef9d68e6db66650a83d98c5c721d01f6
> Signed-off-by: Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
> ---
>  fs/io_uring.c | 3 +++
>  1 file changed, 3 insertions(+)


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
