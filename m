Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F24BB3CC714
	for <lists+stable@lfdr.de>; Sun, 18 Jul 2021 02:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbhGRAqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Jul 2021 20:46:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:35428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230259AbhGRAqt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 17 Jul 2021 20:46:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AAF961153;
        Sun, 18 Jul 2021 00:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626569032;
        bh=h07DsXaBa/McpHTUbntejTexB77iFAVEsJ/ZfXV9C4k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dk4407QbwEzaVEGFytZ7lHwWBHzyfcqoSPKWAD0sqwccp+AQHeatbm/FRto8Fd2JR
         TQn0T7PwqvYyws1V0SZrcX7RgnvFsV+ByYnhSpGQZapYvLsIB8WlgjrSvg7Pmp5DBr
         iAN1fdM4aXpVc4Dr0PFSnBP1xiN3tcrZwE+p4AvanRlqN6KtjBlhWM6Mt9sBp52MNq
         s5c7JGtdQfcpzHXxMcnKmlDORpK98RF/A9rgqnkIW9z22WscLj+zfhR00Gqlf840ka
         ceF/czjKG4YAY1FLcsFbPWPShmLcVgtHfiXbl/2V5uYhzpuBrj/WhldRn+mNQllSew
         o+UJ7VPvbeUnQ==
Date:   Sat, 17 Jul 2021 20:43:51 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Eli Billauer <eli.billauer@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH AUTOSEL 5.13 053/114] char: xillybus: Fix condition for
 invoking the xillybus/ subdirectory
Message-ID: <YPN5R4FJ9ZePQ293@sashalap>
References: <20210710021748.3167666-1-sashal@kernel.org>
 <20210710021748.3167666-53-sashal@kernel.org>
 <60E92D53.50704@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <60E92D53.50704@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 10, 2021 at 08:17:07AM +0300, Eli Billauer wrote:
>Hello Sasha,
>
>Thanks for trying, but this is a NACK.
>
>On 10/07/21 05:16, Sasha Levin wrote:
>>diff --git a/drivers/char/Makefile b/drivers/char/Makefile
>>index ffce287ef415..c7e4fc733a37 100644
>>--- a/drivers/char/Makefile
>>+++ b/drivers/char/Makefile
>>@@ -44,6 +44,6 @@ obj-$(CONFIG_TCG_TPM)		+= tpm/
>>
>>  obj-$(CONFIG_PS3_FLASH)		+= ps3flash.o
>>
>>-obj-$(CONFIG_XILLYBUS)		+= xillybus/
>>+obj-$(CONFIG_XILLYBUS_CLASS)	+= xillybus/
>>  obj-$(CONFIG_POWERNV_OP_PANEL)	+= powernv-op-panel.o
>CONFIG_XILLYBUS_CLASS will be introduced in v5.14, so backporting this 
>commit will break the kernel's build.
>
>Since this patch was created for three kernel versions, I'm repeating 
>this response on all three, just be sure. Hope I'm not being annoying.

I'll drop it everywhere, thanks!

-- 
Thanks,
Sasha
