Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D395A3A3288
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 19:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhFJR5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 13:57:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229823AbhFJR5G (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Jun 2021 13:57:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D993613F5;
        Thu, 10 Jun 2021 17:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623347709;
        bh=OwrkHobkXzquMpU9PzKF3WD7+4oWRdlNoLd7KWyiLqc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L5DjSuXmkRPgL120FMIf/hG0g9k/W64y3w453XmXNzNDMBK2L2T2TWnQoi090QQ5S
         nml4NGk/gVF6pJX+qQiAyUziIcbXONFVBC7/JMmvIrBK7Xl/GffHXRCZ2YL8+tJDYs
         jAZLu+4exXeZ2ZcuXTANyEWHTlBnpLz03J+A7j0BBfFuQdv6+uUlawVAgwkMbKZtDq
         OCXdWMUV2JlvpuolAaIC8R1hRBG3ox4sPgB0jGqPqpiVVRQ+7aSzczDCS4jZu9nqMU
         cO55I/5FEUKEBVAwWWO5wGFt57Svy2fKusDBBxaxp1ZxbQ8Zf8pq3wlEP/LFL/82Sw
         O+6NXBiQTLpCQ==
Date:   Thu, 10 Jun 2021 13:55:08 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Saravana Kannan <saravanak@google.com>,
        Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.12 03/43] spi: Fix spi device unregister flow
Message-ID: <YMJR/FNCwDllHIDG@sashalap>
References: <20210603170734.3168284-1-sashal@kernel.org>
 <20210603170734.3168284-3-sashal@kernel.org>
 <20210606111028.GA20948@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210606111028.GA20948@wunner.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 06, 2021 at 01:10:28PM +0200, Lukas Wunner wrote:
>On Thu, Jun 03, 2021 at 01:06:53PM -0400, Sasha Levin wrote:
>> From: Saravana Kannan <saravanak@google.com>
>>
>> [ Upstream commit c7299fea67696db5bd09d924d1f1080d894f92ef ]
>
>This commit shouldn't be backported to stable by itself, it requires
>that the following fixups are applied on top of it:
>
>* Upstream commit 27e7db56cf3d ("spi: Don't have controller clean up spi
>  device before driver unbind")
>
>* spi.git commit 2ec6f20b33eb ("spi: Cleanup on failure of initial setup")
>  https://git.kernel.org/broonie/spi/c/2ec6f20b33eb
>
>Note that the latter is queued for v5.13, but hasn't landed there yet.
>So you probably need to back out c7299fea6769 from the stable queue and
>wait for 2ec6f20b33eb to land in upstream.
>
>Since you've applied c7299fea6769 to v5.12, v5.10, v5.4, v4.14 and v4.19
>stable trees, the two fixups listed above need to be backported to all
>of them.

I took those two patches into 5.12-5.4, but as they needed a more
complex backport for 4.14 and 4.19, I've dropped c7299fea67 from those
trees.

-- 
Thanks,
Sasha
