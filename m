Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79388206929
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 02:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387910AbgFXAxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 20:53:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729700AbgFXAxQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 20:53:16 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0F8C20C09;
        Wed, 24 Jun 2020 00:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592959996;
        bh=C0ZzQoE2jmzFsXsmOin9+p288RzXYByQOT+nSbFzAZA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yA9F3MCVLeC3veYmyDcK2sgTH2MM9+eHk7yg4poquGl8UjMuiATijwROlGY+1Jy/S
         f2k1RIeqsyOGjZA6OXfWABq37ix8R3SWqHbCqP2r12oxtGzoFJraE5iK2MnPTYqJp+
         LMxePt1Ljdnb3Cm6P+1INf7Wsv/zGa983gB4pSbU=
Date:   Tue, 23 Jun 2020 20:53:14 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Stephan Gerhold <stephan@gerhold.net>,
        Andi Shyti <andi@etezian.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 4.19 061/206] Input: mms114 - add extra compatible for
 mms345l
Message-ID: <20200624005314.GD1931@sasha-vm>
References: <20200623195316.864547658@linuxfoundation.org>
 <20200623195319.967295572@linuxfoundation.org>
 <20200623210952.GA4401@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200623210952.GA4401@amd>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 23, 2020 at 11:09:52PM +0200, Pavel Machek wrote:
>Hi!
>
>> MMS345L is another first generation touch screen from Melfas,
>> which uses mostly the same registers as MMS152.
>...
>> Add a separate "melfas,mms345l" compatible that avoids reading
>> from the MMS152_COMPAT_GROUP register. This might also help in case
>> there is some other device-specific quirk in the future.
>
>Compatible is not documented in the right place, and noone is using
>this binding, so this does not really change anything.
>
>I believe this should be dropped from -stable.

I've dropped it, thanks!

-- 
Thanks,
Sasha
