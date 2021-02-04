Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A80E30EC69
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 07:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbhBDGVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 01:21:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:41372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229741AbhBDGVH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Feb 2021 01:21:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64D3A64F4A;
        Thu,  4 Feb 2021 06:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612419626;
        bh=ty/x6gWZoNcCC17mgqHv7iNMK7YrFFxujygfEoMKhEA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cjs2lnjf5rxuOoP3lHZ74znCXBvO8b3yMNydNq9oDKwclcvDpoIhnpWDtXcLAGgfl
         vBw2bWrlQtK8f1kTE40pIlP/9tSHV6cQtH2ZuSUdPMpVJrp8l6xnh5uLLi+oO5X9Ot
         11m/1jcbmoG9WEnXNSp9bXvkUOVvw8UZWn/7qQNM=
Date:   Thu, 4 Feb 2021 07:20:22 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jari Ruusu <jariruusu@protonmail.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Kernel version numbers after 4.9.255 and 4.4.255
Message-ID: <YBuSJqIG+AeqDuMl@kroah.com>
References: <7pR0YCctzN9phpuEChlL7_SS6auHOM80bZBcGBTZPuMkc6XjKw7HUXf9vZUPi-IaV2gTtsRVXgywQbja8xpzjGRDGWJsVYSGQN5sNuX1yaQ=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7pR0YCctzN9phpuEChlL7_SS6auHOM80bZBcGBTZPuMkc6XjKw7HUXf9vZUPi-IaV2gTtsRVXgywQbja8xpzjGRDGWJsVYSGQN5sNuX1yaQ=@protonmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 04, 2021 at 05:59:42AM +0000, Jari Ruusu wrote:
> Greg,
> I hope that your linux kernel release scripts are
> implemented in a way that understands that PATCHLEVEL= and
> SUBLEVEL= numbers in top-level linux Makefile are encoded
> as 8-bit numbers for LINUX_VERSION_CODE and
> KERNEL_VERSION() macros, and must stay in range 0...255.
> These 8-bit limits are hardcoded in both kernel source and
> userspace ABI.
> 
> After 4.9.255 and 4.4.255, your scripts should be
> incrementing a number in EXTRAVERSION= in top-level
> linux Makefile.

Should already be fixed in linux-next, right?

thanks,

greg k-h
