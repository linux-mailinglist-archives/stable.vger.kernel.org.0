Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADDD2C7F86
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 09:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbgK3ILg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 03:11:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:57952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725972AbgK3ILg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Nov 2020 03:11:36 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AAC220731;
        Mon, 30 Nov 2020 08:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606723856;
        bh=BHjT6zH+wiQs+1wfj8IucZLbZz91d2qrAaGEyisftzM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D8rIxGkTB/pupC5KG6W4CZAVHhWyCGEQw8u8cyLweSpqn0mrcSVkKejMj7hXsUXD8
         mj6NfnxuZkt6N9A+PTtw1JUWYCDFT2jx8VfaGCUf/IpTePvtaFoS84CT9sDmDNOrOY
         ZMhzB1ydSPALb1RpQoHn5GRKBZGQU6pOF5kCpPwc=
Date:   Mon, 30 Nov 2020 09:11:59 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jack Qiu <jack.qiu@huawei.com>
Cc:     linux-f2fs-devel@lists.sourceforge.net, stable@vger.kernel.org
Subject: Re: [PATCH] f2fs: init dirty_secmap incorrectly
Message-ID: <X8SpT6J7VSDibHal@kroah.com>
References: <20201130073719.8982-1-jack.qiu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201130073719.8982-1-jack.qiu@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 30, 2020 at 03:37:19PM +0800, Jack Qiu wrote:
> section is dirty, but dirty_secmap may not set
> 
> Reported-by: Jia Yang <jiayang5@huawei.com>
> Fixes: da52f8ade40b ("f2fs: get the right gc victim section when section
> has several segments")
> 
> Signed-off-by: Jack Qiu <jack.qiu@huawei.com>
> ---
> v2:
>  - cc stable mailing list
>  fs/f2fs/segment.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
