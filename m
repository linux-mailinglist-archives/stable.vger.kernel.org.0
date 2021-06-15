Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6502B3A7622
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 06:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbhFOE4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 00:56:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229968AbhFOE4U (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 00:56:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F8736140C;
        Tue, 15 Jun 2021 04:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623732855;
        bh=Hy47A6sDeDK5g7Q5O8jSY970MU9+ZwCkDct4y1d2MOQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c5luMNlXN45gsnjoT7ZAEHeSo4zvFcWP9bbHYPHa2DXxgXuwPtyM+U/2Oawme604d
         QCsuyDD/R9ZHrHa66qMInzV4pFn0ia7wc2Q5fOejGauo5+FoDRWgONUTfJWFmi4Bhr
         FB5C3UysQ1jKKZABMCKKcgh4gkX2frG+MQkR/tdM=
Date:   Tue, 15 Jun 2021 06:54:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Siddharth Gupta <sidgup@codeaurora.org>
Cc:     bjorn.andersson@linaro.org, ohad@wizery.com,
        linux-remoteproc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, psodagud@codeaurora.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3 2/4] remoteproc: core: Move validate before device add
Message-ID: <YMgydE4BOqxmxP7F@kroah.com>
References: <1623723671-5517-1-git-send-email-sidgup@codeaurora.org>
 <1623723671-5517-3-git-send-email-sidgup@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623723671-5517-3-git-send-email-sidgup@codeaurora.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 14, 2021 at 07:21:09PM -0700, Siddharth Gupta wrote:
> We can validate whether the remoteproc is correctly setup before
> making the cdev_add and device_add calls. This saves us the
> trouble of cleaning up later on.
> 
> Signed-off-by: Siddharth Gupta <sidgup@codeaurora.org>
> Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
>  drivers/remoteproc/remoteproc_core.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
