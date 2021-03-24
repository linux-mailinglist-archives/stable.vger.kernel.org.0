Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2737347166
	for <lists+stable@lfdr.de>; Wed, 24 Mar 2021 07:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233042AbhCXGGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Mar 2021 02:06:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:42276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235490AbhCXGF3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Mar 2021 02:05:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFD04601FA;
        Wed, 24 Mar 2021 06:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616565929;
        bh=K1rjhRloQq0RP1IxX1pwceUg6EHtGOdcmckaDNkjmXI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QRZztvp19LTpJff1eRqylKc9GG1nHKPvb4LfnGxt88AbPFWL//Ye+7JuccTlIpKEP
         zVtHVmWwtj7m13FtzI7PsZgNTJ8FfWdUcuK1ZB2EDvQxRtArDAbsZmYikt6ZVHL6l8
         xjb9AKFhm6CvjA8aaEpjL8UdJ68mIH9UiMehNE8g=
Date:   Wed, 24 Mar 2021 07:05:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zhen Zhao <zp_8483@163.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v1] xfs: return err code if xfs_buf_associate_memory fail
Message-ID: <YFrWpkOUWgzt3CT+@kroah.com>
References: <20210324005744.2854-1-zp_8483@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324005744.2854-1-zp_8483@163.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 23, 2021 at 08:57:43PM -0400, Zhen Zhao wrote:
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
