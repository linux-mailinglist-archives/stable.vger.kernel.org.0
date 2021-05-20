Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA0038A006
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 10:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbhETInP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 04:43:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:41386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230509AbhETInO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 04:43:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77A8561184;
        Thu, 20 May 2021 08:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621500113;
        bh=JjUw1ywlQJ2MSOUaCl3O+3O92uaGZsUtnMa7V0amtBw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MQ3Ksscj5IZD0QBa8OBcQj8cPVooSR9WYFzWhsH7ypWgMm9GlwD5uzDZgDMLPr+Tx
         g8mYZKTaNK4hUeFOmKaY0t+7F2y4Wtcsg05oNmWe9ojMtM52RXIQKKl13BXspaMdTl
         2hsTurt7/ok12GbfEDETG74LsFxGGjS8Zmym12To=
Date:   Thu, 20 May 2021 10:41:35 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: Build failures in v4.19.y.queue
Message-ID: <YKYgv0wXweV1ZNGG@kroah.com>
References: <d2f28d84-424d-6f8e-973f-88f5975eafdd@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d2f28d84-424d-6f8e-973f-88f5975eafdd@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 13, 2021 at 01:37:29PM -0700, Guenter Roeck wrote:
> Build results:
>     total: 155 pass: 153 fail: 2
> Failed builds:
>     arm:allmodconfig
>     arm:axm55xx_defconfig
> Qemu test results:
>     total: 424 pass: 423 fail: 1
> Failed tests:
> mipsel:mips32r6-generic:malta_32r6_defconfig:nocd:smp:net,pcnet:ide:rootfs
> 
> Failures are similar to the build failures in v5.4.y, plus:
> 
> drivers/crypto/omap-aes.c: In function 'omap_aes_hw_init':
> drivers/crypto/omap-aes.c:110:8: error: implicit declaration of function 'pm_runtime_resume_and_get'

Now deleted the offending patch, thanks.

greg k-h
