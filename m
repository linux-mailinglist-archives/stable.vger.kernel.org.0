Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0FEC30B20D
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 22:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbhBAVY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 16:24:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:52490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231426AbhBAVY7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Feb 2021 16:24:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37C0A64EC8;
        Mon,  1 Feb 2021 21:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612214658;
        bh=UUSv+SjR7K+ytKdgy5hdccbLaftxZgFExO6PCpdnyas=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=anXX4jE9Qk2f8n/EI8Yn256Ie7P9oxc1L9uulh7Saax4ZvVoVjX9qZdfocwybWwlD
         rBWJ5EAjSn8eEdb8G/13Qxg2OL78fPqux3W96dp1G02ci4cP663lGE9oaF1dy3zS56
         hs5YzXpt0TCOAJlfI/+l0XgZQfqrPbTTpy2G9AxHGhar5Sowp31fEqNRZhG1fm7lwf
         9VyA3zOEtW77P4s4k8WZIdTlirf5y4bGVNizBDRx2AyQa9fAd+9uVf/v2X1FzzUqWF
         OCONCl/J6x8WIEBJIFbWaAsH9EJjzPeyZE++6zDZcaIIjduh8EjHyUNZ2swpHdxLvn
         bOX+5ZpR7t/tQ==
Date:   Mon, 1 Feb 2021 16:24:17 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Stephen Boyd <swboyd@chromium.org>
Cc:     stable@vger.kernel.org, stable-commits@vger.kernel.org,
        Srinivasa Rao <srivasam@codeaurora.org>,
        Mark Brown <broonie@kernel.org>
Subject: Re: Patch "ASoC: qcom: Fix number of HDMI RDMA channels on sc7180"
 has been added to the 5.10-stable tree
Message-ID: <20210201212417.GS4035784@sasha-vm>
References: <20210201165232.C608864EC4@mail.kernel.org>
 <161220007749.76967.8280890350734846898@swboyd.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <161220007749.76967.8280890350734846898@swboyd.mtv.corp.google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 01, 2021 at 09:21:17AM -0800, Stephen Boyd wrote:
>Quoting Sasha Levin (2021-02-01 08:52:31)
>> This is a note to let you know that I've just added the patch titled
>>
>>     ASoC: qcom: Fix number of HDMI RDMA channels on sc7180
>>
>> to the 5.10-stable tree which can be found at:
>>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>>
>> The filename of the patch is:
>>      asoc-qcom-fix-number-of-hdmi-rdma-channels-on-sc7180.patch
>> and it can be found in the queue-5.10 subdirectory.
>>
>> If you, or anyone else, feels it should not be added to the stable tree,
>> please let <stable@vger.kernel.org> know about it.
>>
>
>Please drop this from stable queue. It will be reverted shortly and
>replaced with a proper patch. See [2] for more info.

Now dropped, thanks!

-- 
Thanks,
Sasha
