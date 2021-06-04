Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44A6739BE37
	for <lists+stable@lfdr.de>; Fri,  4 Jun 2021 19:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbhFDROJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Jun 2021 13:14:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230169AbhFDROJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Jun 2021 13:14:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78DC761359;
        Fri,  4 Jun 2021 17:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622826742;
        bh=VBjJSSW1aAs3FpYhgSdGJBjs8avxuSHdzxInARXBXPM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fRiIcpstavb2b7BS0rJu6lDNXS348QyqTBerJ9c4k61zHYk4xkBBG2a44esGy/hE9
         KclCoOhFzNVtgt/zvD/brD5PQEhku2bHINU4XydgRX2S/IODgS2h4Bdcex6BlFsVrO
         eKM9IftsyxIjGQOoPA//aS/Zt4Ys1CB24a2yJmxbXu94c6ZqrDH6UyD046AWg2W/d7
         TQhFHFEYX2sMgRR65CBFpvU7pYQbNOclxhLP10OweahcHIqJtMvjkXwZPYhe9CYYxr
         6k8zaXoKedpsGxYGNmr0+l5EYrvBohtNVC5Sq6s+wwj9yfXQJS72FGMPNdQ0SxYBjd
         RNouVLqcowLYA==
Date:   Fri, 4 Jun 2021 13:12:21 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Please apply commit ff40e0d41af ("ALSA: usb: update
 old-style...") to v4.19.y, v5.4.y
Message-ID: <YLpe9c262Xb+imaH@sashalap>
References: <20210603121039.GA3017129@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210603121039.GA3017129@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 03, 2021 at 05:10:39AM -0700, Guenter Roeck wrote:
>Hi,
>
>please apply commit ff40e0d41af1 ("ALSA: usb: update old-style static const
>declaration") to v4.19.y and to v5.4.y. It fixes commit a01df925d1bb ("ALSA:
>usb-audio: More constifications") which was applied to v5.6 and backported
>to v5.4.y and to v4.19.y.

I've queued this one up. We don't usually take W=1 warning fixes unless
they really bug someone :)

-- 
Thanks,
Sasha
