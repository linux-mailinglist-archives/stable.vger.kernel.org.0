Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 056E93FD6AE
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 11:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243507AbhIAJWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 05:22:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243622AbhIAJWr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 05:22:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DB6560243;
        Wed,  1 Sep 2021 09:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630488110;
        bh=QNWMBXZaq53UbBG19JmAu7D3qG3fLjBySENpW8cMm1c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OhHHmCU5moMGNZMkPdLmrwtoVvdTl72Y0FRqvjnk0WncgGf/RO6tW1Ozaa2/Cwmc+
         gdzYduJ1JBCDy40XNWtVg4dsBTekAh8xwbwdr93iHr6KhHjf2VGIEK6uV8xIt/48u8
         Eb/w/QZxQKDMzR3phWoz+kEjQ3nMpqahhzUOXE4o=
Date:   Wed, 1 Sep 2021 11:21:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hanjun Guo <guohanjun@huawei.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 5.10.y 0/6] Collected perf patches for stable 5.10.y
Message-ID: <YS9GJhhThtDSJ9Kq@kroah.com>
References: <1629375552-51897-1-git-send-email-guohanjun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1629375552-51897-1-git-send-email-guohanjun@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 19, 2021 at 08:19:06PM +0800, Hanjun Guo wrote:
> I collected some bugfix perf patches which are missing for 5.10.y,
> please consider to apply.

Now queued up, thanks.

greg k-h
