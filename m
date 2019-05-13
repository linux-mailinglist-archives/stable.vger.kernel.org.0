Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1A21BE66
	for <lists+stable@lfdr.de>; Mon, 13 May 2019 22:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbfEMUMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 May 2019 16:12:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:37990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726290AbfEMUMl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 May 2019 16:12:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AAD22085A;
        Mon, 13 May 2019 20:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557778360;
        bh=WCUFh+woPhcJEK6e8moOGrzwENC0TrzGg0GLcBimDv0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0z6teznxoJKK51aNl9f25UfLlJqBuG+fqDz9q1N+bcHuTieX9gqac12jWJZX1kX1Q
         kErrK5M8ptjrdBlZ0QWRonzYfS6/f6IT41vHfilgl6t1xeFwR/L7d2bCYojfQw8HTl
         V8SrCeK+7M1XF9cJzPyEkbAInQvPqGv1TJ1B0e1U=
Date:   Mon, 13 May 2019 22:12:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Raul E Rangel <rrangel@chromium.org>
Cc:     stable@vger.kernel.org, linux-mmc@vger.kernel.org,
        djkurtz@google.com, adrian.hunter@intel.com, zwisler@chromium.org,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [stable/4.14.y PATCH 2/3] mmc: Fix null pointer dereference in
 mmc_init_request
Message-ID: <20190513201235.GB17404@kroah.com>
References: <20190513175521.84955-1-rrangel@chromium.org>
 <20190513175521.84955-3-rrangel@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190513175521.84955-3-rrangel@chromium.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 13, 2019 at 11:55:20AM -0600, Raul E Rangel wrote:
> It is possible for queuedata to be cleared in mmc_cleanup_queue before
> the request has been started. This will result in dereferencing a null
> pointer.
> 
> Signed-off-by: Raul E Rangel <rrangel@chromium.org>
> ---
> 
>  drivers/mmc/core/queue.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
