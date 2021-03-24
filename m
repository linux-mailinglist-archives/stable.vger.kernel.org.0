Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65947347167
	for <lists+stable@lfdr.de>; Wed, 24 Mar 2021 07:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233009AbhCXGGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Mar 2021 02:06:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:42574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233023AbhCXGFt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Mar 2021 02:05:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8538601FA;
        Wed, 24 Mar 2021 06:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616565949;
        bh=xjHQ5hZJ04a5+3WM0c8CI8tsI6YxRs7Huh6DBMo7uKE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F/I5kZRQVxmAMnMATSu1zjStW2vp9+/m9Wbr4o3KGmjJV3hODa1e9Pk2V7GzMG2Xu
         L9Mw5RumB1mXyrYXyFXMayAOGUlUASHa3s5vYSWuCOcO2bfIz2DIWz0CCaDRbmrr6/
         CBWLUK8uW4P1Ml+JmfqH6TX68WeYPiQKJ7wl+pV4=
Date:   Wed, 24 Mar 2021 07:05:46 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zhen Zhao <zp_8483@163.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v1] xfs: return err code if xfs_buf_associate_memory fail
Message-ID: <YFrWugXTxv80A7i5@kroah.com>
References: <20210324021251.3324-1-zp_8483@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324021251.3324-1-zp_8483@163.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 23, 2021 at 10:12:51PM -0400, Zhen Zhao wrote:
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
