Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01EED2F070E
	for <lists+stable@lfdr.de>; Sun, 10 Jan 2021 13:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbhAJMMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jan 2021 07:12:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:51998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726069AbhAJMMF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 10 Jan 2021 07:12:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77E42238E1;
        Sun, 10 Jan 2021 12:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610280684;
        bh=M+PPow7XoaxsisR5DK90xoirXa+JVnNJqxEQ+ul/9dY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KuYvIiOV9wXay1aafpggMy9CStjinvcP77kwxeI3WFLDd1XDokyGCv7GaeEuqchiQ
         sw1F0UtQXoTg9SIK/nbCgYpNdAE0/e1y65oNTL5t+X0JfdYDyvOeJQXJyHAgWNys5I
         No7BQwU8E56/OXFcvSUgXYUQd4bgMIOesvlpZ27Mw22Dl8jdmHFmW83xIp6xcycyFA
         M/Jg6QLfztLs39jfv7AQkQjv1ldVz6kudpfr4Hu4llSgGd65fkj0bgxH3LBTV1BhMW
         gXkjlurt1e7nmLQG1VkFBI62qH5zStpnFJ13ubRPaggIq2FYbxAMSgRAik5vWikvmg
         pEusftz/m+g6Q==
Date:   Sun, 10 Jan 2021 07:11:23 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     syphyr <syphyr@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: Bluetooth Fix for 5.4 LTS
Message-ID: <20210110121123.GI4035784@sasha-vm>
References: <6c91a7ed-a2a0-f74c-5c0c-c7abe0f783c1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <6c91a7ed-a2a0-f74c-5c0c-c7abe0f783c1@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 09, 2021 at 09:06:43PM +0100, syphyr wrote:
>Hello,
>
>
>I would like to report that bluetooth has started crashing with 5.4.87 
>kernel release because of this commit: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v5.4.88&id=18e1101b0ee9b9f2483e0efd0dcf3763b3915026. 
>The fix is this: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v5.11-rc2&id=5c3b5796866f85354a5ce76a28f8ffba0dcefc7e

I'll queue it up, thanks for reporting.

-- 
Thanks,
Sasha
