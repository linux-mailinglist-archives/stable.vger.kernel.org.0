Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB963A762A
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 06:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhFOE4j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 00:56:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:48204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229968AbhFOE4j (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 00:56:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 867FA6140C;
        Tue, 15 Jun 2021 04:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623732875;
        bh=LOUrrre8qSZUzINtpnJMg/SuDS2uZEyc8OgjEuONmRs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yg5nwCP1U+2AIZi5180GqrGZxiQygtRJ39hiJbUDPGyvmygZw69Zg2trAbzxvJaVI
         ohi7+dGvIkj5Nwnnw0dBeDuwbp7phAthXlHvR/qHf6xNyiO4/mVRD5BfJD4cq0wOye
         d6V8wqcKpNDTZ+xeL/WoWA3a/tKE50UA06NbrVt0=
Date:   Tue, 15 Jun 2021 06:54:32 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Siddharth Gupta <sidgup@codeaurora.org>
Cc:     bjorn.andersson@linaro.org, ohad@wizery.com,
        linux-remoteproc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, psodagud@codeaurora.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3 4/4] remoteproc: core: Cleanup device in case of
 failure
Message-ID: <YMgyiPzeS9XSmbrm@kroah.com>
References: <1623723671-5517-1-git-send-email-sidgup@codeaurora.org>
 <1623723671-5517-5-git-send-email-sidgup@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623723671-5517-5-git-send-email-sidgup@codeaurora.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 14, 2021 at 07:21:11PM -0700, Siddharth Gupta wrote:
> When a failure occurs in rproc_add() it returns an error, but does
> not cleanup after itself. This change adds the failure path in such
> cases.
> 
> Signed-off-by: Siddharth Gupta <sidgup@codeaurora.org>
> ---
>  drivers/remoteproc/remoteproc_core.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
