Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA9352714C3
	for <lists+stable@lfdr.de>; Sun, 20 Sep 2020 16:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbgITOFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Sep 2020 10:05:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:33308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726267AbgITOFg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 20 Sep 2020 10:05:36 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE4F32073A;
        Sun, 20 Sep 2020 14:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600610736;
        bh=Z9d9tah8JqHOP5pL4YoUeFKHAnNfZixgM4oEIn6E09o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t1rWOtUIWoQhkhK+H8uAHB/270vd84ch2gS+q+T01vLu2Hzs4ShnDXVb38Eehh7S1
         XFOpt9uaDn+Caqd4yEVGc1R1mBZzociuhUb6HHlIHtqZS974z2SM6Z4XdMPHZwYOPF
         tKmjbC0qD0gQp3tcXanrLTgucXcmaoWVSEZ3dKik=
Date:   Sun, 20 Sep 2020 10:05:34 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH AUTOSEL 4.14 05/15] regulator: pwm: Fix machine
 constraints application
Message-ID: <20200920140534.GK2431@sasha-vm>
References: <20200914130526.1804913-1-sashal@kernel.org>
 <20200914130526.1804913-5-sashal@kernel.org>
 <20200915075508.jddoubwnptjcqtru@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200915075508.jddoubwnptjcqtru@axis.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 15, 2020 at 09:55:08AM +0200, Vincent Whitchurch wrote:
>On Mon, Sep 14, 2020 at 03:05:16PM +0200, Sasha Levin wrote:
>> From: Vincent Whitchurch <vincent.whitchurch@axis.com>
>>
>> [ Upstream commit 59ae97a7a9e1499c2070e29841d1c4be4ae2994a ]
>>
>> If the zero duty cycle doesn't correspond to any voltage in the voltage
>> table, the PWM regulator returns an -EINVAL from get_voltage_sel() which
>> results in the core erroring out with a "failed to get the current
>> voltage" and ending up not applying the machine constraints.
>>
>> Instead, return -ENOTRECOVERABLE which makes the core set the voltage
>> since it's at an unknown value.
>
>For this patch to work it needs 84b3a7c9c6befe5ab4d49070fe7 ("regulator:
>core: Allow for regulators that can't be read at bootup") which was
>merged in v4.18.  Without that this patch is not going to have any
>effect so it probably shouldn't be backported to older kernels.

Dropped for those older kernels, thanks!

-- 
Thanks,
Sasha
