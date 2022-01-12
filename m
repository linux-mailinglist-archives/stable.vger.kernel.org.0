Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7D448C0DE
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 10:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232637AbiALJTF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 04:19:05 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58970 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238432AbiALJTE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jan 2022 04:19:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95DE6B81DDD;
        Wed, 12 Jan 2022 09:19:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C2BC36AE9;
        Wed, 12 Jan 2022 09:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641979142;
        bh=RO6US7dUIfZ18yXvjEkA9PpLQg7tR79xX51uEs/Oz+M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ziPoyrEmgRCDpvQ60gNQDVTsgddVhzBhAx0Yp28kKJ+REV0sEu4O5uo1zVoJBB75J
         XJHBUo6pGqq0ZveN6sU/NqPvF9hqzOlBdT4VvsD3/EIlQSlWrLu+OTWVqc3iYQgB8S
         F+HdHJHfxqEBoXv9ll32azMzEoVC6s9egRMZYvOM=
Date:   Wed, 12 Jan 2022 10:18:57 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/14] 4.4.299-rc1 review
Message-ID: <Yd6dAUs4lKe/pilm@kroah.com>
References: <20220110071811.779189823@linuxfoundation.org>
 <20220111113439.GA11620@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220111113439.GA11620@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 11, 2022 at 12:34:39PM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 4.4.299 release.
> > There are 14 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> CIP testing did not find any problems here:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-4.4.y
> 
> Tested-by: Pavel Machek (CIP) <pavel@denx.de>
> 
> Best regards,
>                                                                 Pavel
> 
> -- 
> DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany



Thank you for testing and letting me know.

greg k-h
