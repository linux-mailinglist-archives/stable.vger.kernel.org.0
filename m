Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23EA238A003
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 10:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbhETImA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 04:42:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:40634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231208AbhETImA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 04:42:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78D51611AE;
        Thu, 20 May 2021 08:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621500038;
        bh=9gZjLxGtHvlNjDJ2xGx+hTSFXX0/yQcJauLvAJv+aD8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s43eFOXpfrrYgyGE7vKW7QAFlhfv8z/u/jfNVwHLTkcr9NiSOMjxnOJFN5EVduj+F
         eAg+KE3WxFj7tdladGXdNQtTc1WQ+Yp41ac51uJ5qtMENOX9Kv2Ex5HDo7MgiIkSVG
         CuZ/mJPukOwuTCyelyogThMNJaIiHyRE7Vqe3fYg=
Date:   Thu, 20 May 2021 10:40:35 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: Build failures in v4.9.y.queue, v4.14.y.queue
Message-ID: <YKYggzQo8iRJybiy@kroah.com>
References: <438183ba-d285-42d1-e787-c332ce83ca0b@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <438183ba-d285-42d1-e787-c332ce83ca0b@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 13, 2021 at 01:39:30PM -0700, Guenter Roeck wrote:
> Build results:
>     total: 168 pass: 168 fail: 0
> Qemu test results:
>     total: 406 pass: 405 fail: 1
> Failed tests:
> mipsel:mips32r6-generic:malta_32r6_defconfig:nocd:smp:net,pcnet:ide:rootfs
> 
> This is the same mips assembler related build failure that was also seen
> with all other release candidates.
> 
> Guenter
> 

Should be fixed now.
