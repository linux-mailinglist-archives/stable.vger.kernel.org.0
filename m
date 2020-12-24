Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3DC22E2804
	for <lists+stable@lfdr.de>; Thu, 24 Dec 2020 17:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbgLXQOB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Dec 2020 11:14:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:42416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728230AbgLXQOB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Dec 2020 11:14:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B6DA224B0;
        Thu, 24 Dec 2020 16:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608826400;
        bh=XGH1RXofRxVc18RTy81ylGTH3wYwvm/88sVMKwH/kTA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lJIgBQkPmgdfiU3ds/sfhyWLC4ut8M9seWRvhueDSpgZt80WSoSwrYH/Gj87e3sWt
         KEqYdHoA2DGgwZ6xdxvMnO7hbJWJhpQSGmtYfIsSNGXybw3enZs/RymEj0LE9EZiqM
         VMachTIEPwvNH1cPjWT3t5S4mYvune2psEhWmqYNyqAjwH4GpW2m0qICEUvCLRDm0c
         YBN3PLj0Zr2iRTjZMfu46OQ6BNXR/mv8KyYVlV0zWsIF1anMkqKUfRhNsdPYZCO3um
         tbFzcoFWwja4vrsNdZeuH5/ElBjc1FPnCk0oBu9A9TcJAZ/dNjYkq+Zzmppb9MrWir
         1zR6ZYBpVMMDQ==
Date:   Thu, 24 Dec 2020 11:13:19 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Build failures in v5.4.85-72-ge4ff6f3
Message-ID: <20201224161319.GE2790422@sasha-vm>
References: <0c8ffc37-7513-6216-4d8b-8d030b314554@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <0c8ffc37-7513-6216-4d8b-8d030b314554@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 24, 2020 at 07:40:15AM -0800, Guenter Roeck wrote:
>Build reference: v5.4.85-72-ge4ff6f3
>gcc version: aarch64-linux-gcc (GCC) 9.3.0
>
>Building arm64:allmodconfig ... failed
>--------------
>Error log:
>drivers/gpio/gpio-zynq.c: In function 'zynq_gpio_irq_reqres':
>drivers/gpio/gpio-zynq.c:559:8: error: implicit declaration of function 'pm_runtime_resume_and_get'
>
>pm_runtime_resume_and_get() is not available in v5.4.y.

I took dd8088d5a896 ("PM: runtime: Add pm_runtime_resume_and_get to deal
with usage counter") into 5.4 to fix that, thanks!

-- 
Thanks,
Sasha
