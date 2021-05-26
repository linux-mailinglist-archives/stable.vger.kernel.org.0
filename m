Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75C3C390D9F
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 02:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232678AbhEZA7g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 20:59:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:51310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232651AbhEZA7f (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 May 2021 20:59:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AD38613FA;
        Wed, 26 May 2021 00:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621990684;
        bh=kD8pmqfXMnZqFiWQiqQiliQE8WnhQTkQKe9ScqcbX4Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pMYDPyhxL67F0uRMRNOOEP3Pbb9O9u9H9oWazON6OocViIQ37yms4U5UO+rRE4raP
         Yju2Y0a4jRkEnDiGjybrNTNGXeIKyHUROkjEfe+bolDK54j+p+U/vBIMIT0pujqYwT
         uhKnjZPTwxYRVxcL8vShPRQWXxMS88ulQ5qHo/virjAbQJNQgYEvuhDbknJzuxtLuo
         QjnOe3Tip5cFtI3uxpiwFvkfae247kOGWMHPgvxJpKB4gvvKLWQXCtgwnQMSozN1qc
         +UDXNdkDSMLw3gvovQCkXKbpB4+ifuNFGSgQDQT+3PkVaNbCJ6yRY4qAq3TLuA+L5r
         w71zQpgdu/i9A==
Date:   Tue, 25 May 2021 20:58:03 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kangjie Lu <kjlu@umn.edu>, alsa-devel@alsa-project.org
Subject: Re: [PATCH AUTOSEL 5.10 29/62] Revert "ASoC: rt5645: fix a NULL
 pointer dereference"
Message-ID: <YK2dGw3IJdCNSVN0@sashalap>
References: <20210524144744.2497894-1-sashal@kernel.org>
 <20210524144744.2497894-29-sashal@kernel.org>
 <YK1zgS7FwtySdeCg@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YK1zgS7FwtySdeCg@sirena.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 25, 2021 at 11:00:33PM +0100, Mark Brown wrote:
>On Mon, May 24, 2021 at 10:47:10AM -0400, Sasha Levin wrote:
>
>> Lots of things seem to be still allocated here and must be properly
>> cleaned up if an error happens here.
>
>That's not true, the core already has cleanup for everything else
>(as the followup patch in your series identified, though it was a
>bit confused as to how).
>
>>  		RT5645_HWEQ_NUM, sizeof(struct rt5645_eq_param_s),
>>  		GFP_KERNEL);
>>
>> -	if (!rt5645->eq_param)
>> -		return -ENOMEM;
>> -
>
>Without the followup patch (which I don't think is suitable for
>stable) this will just remove error checking.  It's not likely to
>happen and hence make a difference but on the other hand it
>introduces a problem, especially when backported in isolation.

I'll drop this and the follow up patch, thanks.

-- 
Thanks,
Sasha
