Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90B4347165
	for <lists+stable@lfdr.de>; Wed, 24 Mar 2021 07:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232883AbhCXGGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Mar 2021 02:06:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:42414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233009AbhCXGFj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Mar 2021 02:05:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F1FE619C7;
        Wed, 24 Mar 2021 06:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616565939;
        bh=0cLXTrDk1b+lYf3QOixmM4oEPTkxeznXlAFlZMyDtRE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lu9RpE6eNiBwSO9iMBa5wW16SIaB7388PPzdw/YiDU2kTQpYlbWJmq0BKanb93djK
         L5Miluba+N1ePXqp0xwjFFhzi2bNbOwkpUfi4WaUtedxt5mm/wmSZuQ3vRS3JCrp4v
         MAf+YpVupJv8NRdVWSo2XiuUQ+7GuL9SkdYRAqR4=
Date:   Wed, 24 Mar 2021 07:05:37 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zhen Zhao <zp_8483@163.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v1] xfs: return err code if xfs_buf_associate_memory fail
Message-ID: <YFrWsWy7qfCu0BpS@kroah.com>
References: <20210324010653.3006-1-zp_8483@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324010653.3006-1-zp_8483@163.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 23, 2021 at 09:06:53PM -0400, Zhen Zhao wrote:
> In kernel 3.10, when there is no memory left in the
> system, fs_buf_associate_memory can fail, catch the
> error and return.
> 
> Signed-off-by: Zhen Zhao <zp_8483@163.com>
> ---
>  fs/xfs/xfs_log.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
