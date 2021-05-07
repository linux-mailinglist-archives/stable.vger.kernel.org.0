Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD9637640E
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 12:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235513AbhEGKsI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 06:48:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229789AbhEGKsH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 May 2021 06:48:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56A4160FF3;
        Fri,  7 May 2021 10:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620384427;
        bh=S0rvvScdZKxAg0+2tEM6w30RvKAINDq/z7sm3Q1UkI8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lpeJq149XjIYdUzimS63IIti4Zwixko3R7qBWQ8kpSnWLrAIcsvYizaP4A3NqdNfP
         pd92+5mgnkmWYpZ7MoUQzF3Vcb5+REI0F3AgyUg5cL8Y8SnlAwN9ixt5QLDwIi3opY
         qfN5rBa78ZgADQlLUnaECk2RzeF7fyD6tXCf/VAdPaXg/p0pTn1KcA8BM1rIaqRUNy
         u4WfdaMFXCQMvb0pbnYwYWrD7LQQjZxpbfd+/GvPTvWhLs6A9sNYMYAf7O5ME/QoVQ
         V2+IlJvrKwYLrkedOYFQB9+Q3nYa/A3+pvcN7DxcUWyhCJlm02GKq0CSocYK8XZBfJ
         kfD67R8gWJLcw==
Date:   Fri, 7 May 2021 06:47:06 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.12 16/79] usb: dwc3: gadget: Remove invalid
 low-speed setting
Message-ID: <YJUaqq0ZMVn2989b@sashalap>
References: <20210502140316.2718705-1-sashal@kernel.org>
 <20210502140316.2718705-16-sashal@kernel.org>
 <YI69i5JE3NdIx4Sb@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YI69i5JE3NdIx4Sb@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 02, 2021 at 04:56:11PM +0200, Greg Kroah-Hartman wrote:
>On Sun, May 02, 2021 at 10:02:13AM -0400, Sasha Levin wrote:
>> From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
>>
>> [ Upstream commit 0c59f678fcfc6dd53ba493915794636a230bc4cc ]
>>
>> None of the DWC_usb3x IPs (and all their versions) supports low-speed
>> setting in device mode. In the early days, our "Early Adopter Edition"
>> DWC_usb3 databook shows that the controller may be configured to operate
>> in low-speed, but it was revised on release. Let's remove this invalid
>> speed setting to avoid any confusion.
>>
>> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
>> Link: https://lore.kernel.org/r/258b1c7fbb966454f4c4c2c1367508998498fc30.1615509438.git.Thinh.Nguyen@synopsys.com
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  drivers/usb/dwc3/core.c   | 1 -
>>  drivers/usb/dwc3/core.h   | 2 --
>>  drivers/usb/dwc3/gadget.c | 8 --------
>>  3 files changed, 11 deletions(-)
>
>This is a "cleanup only" and does not fix or solve anything, so it can
>be dropped from all of the kernels it has been "autoselected" for.

Dropped, thanks!

-- 
Thanks,
Sasha
