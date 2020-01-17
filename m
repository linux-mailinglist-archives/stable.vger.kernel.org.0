Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDA29140214
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 03:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729108AbgAQCnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 21:43:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:35412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729067AbgAQCnK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 21:43:10 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64FA02072B;
        Fri, 17 Jan 2020 02:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579228989;
        bh=icVIaVDWi3vTyx1vb/g5+nyxUn3QmYadK7RMizpkMvg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2H5qdGxcEvFupn1mLneikZvzAUVpctllA1nwnUE1QYY9mPT+2beJnTxKBBuhbyCUU
         wzAUXQ820y8HpILkHlloaJIyczUjAY8qHbO5FzMdnIzhJZZJSR3+Fa5bZCKTAETV91
         vVWdU8IFrCQiR6QMDTJ4Q6ugv0or+VoSbfdMdtqQ=
Date:   Thu, 16 Jan 2020 21:43:08 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Chuhong Yuan <hslester96@gmail.com>,
        Brian Masney <masneyb@onstation.org>, linux-iio@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 482/671] iio: tsl2772: Use
 devm_add_action_or_reset for tsl2772_chip_off
Message-ID: <20200117024308.GM1706@sasha-vm>
References: <20200116170509.12787-1-sashal@kernel.org>
 <20200116170509.12787-219-sashal@kernel.org>
 <20200116181618.000063c2@Huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200116181618.000063c2@Huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 16, 2020 at 06:16:18PM +0000, Jonathan Cameron wrote:
>On Thu, 16 Jan 2020 12:02:00 -0500
>Sasha Levin <sashal@kernel.org> wrote:
>
>> From: Chuhong Yuan <hslester96@gmail.com>
>>
>> [ Upstream commit 338084135aeddb103624a6841972fb8588295cc6 ]
>>
>> Use devm_add_action_or_reset to call tsl2772_chip_off
>> when the device is removed.
>> This also fixes the issue that the chip is turned off
>> before the device is unregistered.
>>
>> Not marked for stable as fairly hard to hit the bug and
>> this is in the middle of a set making other cleanups
>> to the driver.  Hence will probably need explicit backporting.
>
>Guess I was wrong and it does go on cleanly.  I took a quick
>look at current 4.19 driver and looks like it's fine on it's
>own.
>
>We need to be careful with this one in general though.
>
>Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com> for 4.19

Thanks Jonathan. I saw the comment, but it applied and built cleanly,
and looked sane enough without any related changes.

-- 
Thanks,
Sasha
