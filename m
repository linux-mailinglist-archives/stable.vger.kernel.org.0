Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39AB043ABCE
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 07:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233909AbhJZFqW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 01:46:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:41334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231394AbhJZFqV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Oct 2021 01:46:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 133DD60E05;
        Tue, 26 Oct 2021 05:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635227038;
        bh=UDbpnH0co620NDqgT0Zs0Eur3PsLOML+kW4ge6xM5rI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a8WfuiB6GTLoCZdNCPrZJvdYcOdd6/GytvmA5Q9fooU+wug2CPCtD2YuJlmxQRPk2
         R0GviXGlAXsr+p8x61wWIrRgWhOfRlvifXgrsH+kPyi97SG1PiaGdix8xUdSOzbhp1
         n+rJpDoWYNxb+T/sNxfSfk3gUjaNpOo78uQXvdIo=
Date:   Tue, 26 Oct 2021 07:43:52 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] usbnet: sanity check for maxpacket
Message-ID: <YXeVmDtzkC1sUBCv@kroah.com>
References: <e3ae5f6e-1e96-9d7e-c126-6b4fb00f83a0@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3ae5f6e-1e96-9d7e-c126-6b4fb00f83a0@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 25, 2021 at 07:20:31PM -0700, Tadeusz Struk wrote:
> Hi,
> Upstream commit id: 397430b50a363d8b7bdda00522123f82df6adc5e
> should be applied because it fixes an Oops (divide by zero) that can be
> triggered from user space. See:
> https://syzkaller.appspot.com/bug?id=2ebf7e5eb303ac9a598e0dab2c0c8b03ead7abce
> 
> It should be applied to stable kernels: 5.14, 5.10, 5.4, 4.19, 4.14, 4.9, 4.4

It's already in the latest stable -rc releases, do you not see it there?

thanks,

greg k-h
