Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF83E3A761F
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 06:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbhFOE4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 00:56:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:47878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229463AbhFOE4H (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 00:56:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72E33613DA;
        Tue, 15 Jun 2021 04:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623732843;
        bh=fOIVqueeSvIwOOwxymxG8iFOWHtHfToeXH/xfzZ28uI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UKGeezVAF9k1Qj+Q3biPH7GSCVfzDL8wL13gj2j8wghAeH385rdx3gaG4E8l1gH6I
         s97LAabbdqXs5+f/l3HOOG7jiEISmdDKud1DuuyxK0fXVM9LeN9RYxVyQHJ8r+hjBC
         nUyapEZd9oaIzfTMamNpmLT14P+9YsS8sY7CK7cQ=
Date:   Tue, 15 Jun 2021 06:54:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Siddharth Gupta <sidgup@codeaurora.org>
Cc:     bjorn.andersson@linaro.org, ohad@wizery.com,
        linux-remoteproc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, psodagud@codeaurora.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3 1/4] remoteproc: core: Move cdev add before device add
Message-ID: <YMgyaC9k/3gP2SCW@kroah.com>
References: <1623723671-5517-1-git-send-email-sidgup@codeaurora.org>
 <1623723671-5517-2-git-send-email-sidgup@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623723671-5517-2-git-send-email-sidgup@codeaurora.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 14, 2021 at 07:21:08PM -0700, Siddharth Gupta wrote:
> When cdev_add is called after device_add has been called there is no
> way for the userspace to know about the addition of a cdev as cdev_add
> itself doesn't trigger a uevent notification, or for the kernel to
> know about the change to devt. This results in two problems:
>  - mknod is never called for the cdev and hence no cdev appears on
>    devtmpfs.
>  - sysfs links to the new cdev are not established.
> 
> The cdev needs to be added and devt assigned before device_add() is
> called in order for the relevant sysfs and devtmpfs entries to be
> created and the uevent to be properly populated.
> 
> Signed-off-by: Siddharth Gupta <sidgup@codeaurora.org>
> Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
>  drivers/remoteproc/remoteproc_core.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
