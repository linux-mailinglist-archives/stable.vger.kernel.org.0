Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3793345FE63
	for <lists+stable@lfdr.de>; Sat, 27 Nov 2021 12:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239455AbhK0MCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Nov 2021 07:02:54 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55786 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235503AbhK0MAy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Nov 2021 07:00:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C4E1B817AA
        for <stable@vger.kernel.org>; Sat, 27 Nov 2021 11:57:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABB98C53FAD;
        Sat, 27 Nov 2021 11:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638014258;
        bh=EW8LxnWqjLjRBo9tyhWqhD75MRZT1LnL0l06SlXsXBE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jP1N4ed+g5cBLgRWl14UfIION1MQ2AWQjwDeY6F4k8QiTsZjCJnnlJEMvdfMHT/Sc
         LMgzGcCxDJSlSjI3lELdKDwgMauwJ1XCrj8hUw9cuPUX2pBlJU8SvKfKmus+vXbyiG
         4RuRBuoYzxU0zE04iPfQlJLMGM4dMN6jz8u7nt8Q=
Date:   Sat, 27 Nov 2021 12:57:35 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     devel@driverdev.osuosl.org, arve@android.com,
        stable@vger.kernel.org, riandrews@android.com, labbott@redhat.com,
        sumit.semwal@linaro.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v3 1/1] staging: ion: Prevent incorrect reference
 counting behavour
Message-ID: <YaIdL9nBW6V3ADob@kroah.com>
References: <20211126103335.880816-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211126103335.880816-1-lee.jones@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 26, 2021 at 10:33:35AM +0000, Lee Jones wrote:
> Supply additional checks in order to prevent unexpected results.
> 
> Fixes: b892bf75b2034 ("ion: Switch ion to use dma-buf")
> Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
> Destined for v4.4.y and v4.9.y
> 
>  drivers/staging/android/ion/ion.c | 6 ++++++
>  1 file changed, 6 insertions(+)

Now queued up, thanks.

greg k-h
