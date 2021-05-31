Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02A3439695F
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 23:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbhEaVpQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 17:45:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:34438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231240AbhEaVpQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 17:45:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A62126101C;
        Mon, 31 May 2021 21:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622497415;
        bh=aHv7QV3IRkfOf+qSY86/pSGzyLbDLj/1IRy//k5oLC0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o/mc+eHr/GeoHHSA9ZuiWJLdYPViTLGFprbpQR6jmR97m3cmfbERYb/rZ3soz/LZX
         SvYMQXRod7ZeBvjtRbhHxmdMC5kXzQwxN7ug8EDOBW4AMrMGM/ZZYTXmLLyn2ABQ7b
         toMtPWER2AvsxKPnnDCqZ/16PB0hZ9TZCjXr8AfEZQTbRhthBcreT2e+WJQKo8YoFQ
         McGFA4+EuxIOntjzIndYz0+CUkl2bAoiTeF1paHPyv6hky/8Hfr6GfmVuuVs+p4FHE
         Z2fHXEp4yojrK+tYD1mbQ8OXoSjMcMh/Tujc2f0OdZsXVbT96HLoyCfdRguFTUPlU9
         8cAByweDmsuYA==
Date:   Mon, 31 May 2021 17:43:34 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>,
        Atul Gopinathan <atulgopinathan@gmail.com>
Subject: Re: [PATCH 4.4 35/54] ALSA: sb8: Add a comment note regarding an
 unused pointer
Message-ID: <YLVYhlUl7coKfECd@sashalap>
References: <20210531130635.070310929@linuxfoundation.org>
 <20210531130636.180684287@linuxfoundation.org>
 <20210531203638.GA19276@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210531203638.GA19276@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 31, 2021 at 10:36:38PM +0200, Pavel Machek wrote:
>Hi!
>
>> [ Upstream commit a28591f61b60fac820c6de59826ffa710e5e314e ]
>>
>> The field "fm_res" of "struct snd_sb8" is never used/dereferenced
>> throughout the sb8.c code. Therefore there is no need for any null value
>> check after the "request_region()".
>>
>> Add a comment note to make developers know about this and prevent any
>> "NULL check" patches on this part of code.
>>
>> Cc: Takashi Iwai <tiwai@suse.de>
>> Signed-off-by: Atul Gopinathan <atulgopinathan@gmail.com>
>> Link: https://lore.kernel.org/r/20210503115736.2104747-36-gregkh@linuxfoundation.org
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>This simply adds a comment... As I'm pretty sure anyone trying to
>"fix" this will try that on mainline, it is even very useful comment.
>
>That's something our documentation says we don't do in stable. I'd
>prefer it not to be in.

Now dropped, thanks!

-- 
Thanks,
Sasha
