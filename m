Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66C4F3E2361
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 08:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243391AbhHFGlm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 02:41:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:38640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229625AbhHFGll (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 02:41:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11FBD611B0;
        Fri,  6 Aug 2021 06:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628232085;
        bh=iuGbdZGYxA9aBjWOoujin9mNkUt7jmXvTheOfTYXCcQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r1m5rb1vWawHqiDT6Ol7HjLFTwjprnlRlUqniSZX16DkggMREEI4wyMmyHKncTbEH
         XWl+TqkPWwyulEV9fCUTg8Ksvn5GGZ15zmwdVJOxK457KFiJQWTzToM+fMRFvR4uuT
         wZuRuQdv+VT2o6H7DTkFg0GlaKAyA0CbF29oWbdU=
Date:   Fri, 6 Aug 2021 08:41:22 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
        linux-stable <stable@vger.kernel.org>,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: Re: [PATCH stable 4.4 4.9] can: raw: raw_setsockopt(): fix raw_rcv
 panic for sock UAF
Message-ID: <YQzZkjg20mPXHUqK@kroah.com>
References: <20210803112241.3253-1-socketcan@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210803112241.3253-1-socketcan@hartkopp.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 03, 2021 at 01:22:41PM +0200, Oliver Hartkopp wrote:
> From: Ziyang Xuan <william.xuanziyang@huawei.com>
> 
> commit 54f93336d000229f72c26d8a3f69dd256b744528 upstream.
> 
> We get a bug during ltp can_filter test as following.

thanks for the backport.

greg k-h
