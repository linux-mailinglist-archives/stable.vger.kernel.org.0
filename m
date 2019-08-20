Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7642996264
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 16:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729851AbfHTO1Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 10:27:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:34904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728993AbfHTO1X (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 10:27:23 -0400
Received: from localhost (unknown [12.166.174.10])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B16B20673;
        Tue, 20 Aug 2019 14:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566311243;
        bh=Iwya4qZUeHZo7ltQ89CLtHgTwsaGF1egVo8XR40Ji3M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tA+RMhLM0LK0uPo3UUj60+g3qBWRRaa9rGZOdZBvkIhJPW0FdBWHtcbbpCLMVar3C
         5G/5vL/gf5JmHlL7kNQsqXxS50ztLGJyfHoROdNbZE/DxkgY8vVyQkLON5lmyfSrlQ
         dbYDUPVahaQFdOkzYUj18F4oOqr9g21bQnw8pOvE=
Date:   Tue, 20 Aug 2019 07:27:22 -0700
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Nishad Kamdar <nishadkamdar@gmail.com>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH AUTOSEL 5.2 09/44] intel_th: Use the correct style for
 SPDX License Identifier
Message-ID: <20190820142722.GA816@kroah.com>
References: <20190820134028.10829-1-sashal@kernel.org>
 <20190820134028.10829-9-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820134028.10829-9-sashal@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 20, 2019 at 09:39:53AM -0400, Sasha Levin wrote:
> From: Nishad Kamdar <nishadkamdar@gmail.com>
> 
> [ Upstream commit fac7b714c514fcc555541e1d6450c694b0a5f8d3 ]
> 
> This patch corrects the SPDX License Identifier style
> in header files related to Drivers for Intel(R) Trace Hub
> controller.
> For C header files Documentation/process/license-rules.rst
> mandates C-like comments (opposed to C source files where
> C++ style should be used)
> 
> Changes made by using a script provided by Joe Perches here:
> https://lkml.org/lkml/2019/2/7/46
> 
> Suggested-by: Joe Perches <joe@perches.com>
> Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/hwtracing/intel_th/msu.h | 2 +-
>  drivers/hwtracing/intel_th/pti.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Not really a stable patch at all, unless you want to start backporting
all SPDX changes (hint, NO we do not!)  :)

please drop this from everywhere.

And what triggered this?  It's just comment changes, shouldn't the
autobot know to ignore those?

thanks,

greg k-h
