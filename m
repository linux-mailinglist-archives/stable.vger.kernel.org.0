Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC5E3E2335
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 08:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235850AbhHFGY5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 02:24:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:59064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229581AbhHFGY4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 02:24:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1C7B60F70;
        Fri,  6 Aug 2021 06:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628231080;
        bh=1HV2IrdN+DlusxvdKYO7bbh1fMqtld/vJ5RbTBFAhUw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NQrYKDEA97hwHmSwJsqVVzdZIpdZWU/Q3wX1VdM7qCcQ7NPFIiQ6oAiP3IXkdrALt
         j+dVO6D66UQ/b9AxUSj5oDZOsrpoeovHwUxHZLobGwM3QoNJJijf3iFoY1X5O+tgPJ
         4GxACY59fEl4IczNnQa0RBva+b9G8T1xp3HUAgRM=
Date:   Fri, 6 Aug 2021 08:24:37 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Cristian Marussi <cristian.marussi@arm.com>
Cc:     stable@vger.kernel.org, sashal@kernel.org,
        Sudeep Holla <sudeep.holla@arm.com>
Subject: Re: [PATCH] firmware: arm_scmi: Add delayed response status check
Message-ID: <YQzVpU0wtfHk0dLf@kroah.com>
References: <20210804113555.9021-1-cristian.marussi@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210804113555.9021-1-cristian.marussi@arm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 04, 2021 at 12:35:55PM +0100, Cristian Marussi wrote:
> [ Upstream commit f1748b1ee1fa0fd1a074504045b530b62f949188 ]
> 
> A successfully received delayed response could anyway report a failure at
> the protocol layer in the message status field.
> 
> Add a check also for this error condition.
> 
> Cc: <stable@vger.kernel.org> # v5.4+
> Link: https://lore.kernel.org/r/20210608103056.3388-1-cristian.marussi@arm.com
> Fixes: 58ecdf03dbb9 ("firmware: arm_scmi: Add support for asynchronous commands and delayed response")
> Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> ---
> Upstream commit f1748b1ee1fa0fd1a074504045b530b62f949188 has been already
> applied to stable/linux-5.13.y, this is a backport with conflicts resolved
> for v5.4 and v5.10 (The code fixed here was introduced after v4.19)

All now queued up, thanks.

greg k-h
