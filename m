Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A741B831E
	for <lists+stable@lfdr.de>; Sat, 25 Apr 2020 03:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgDYBvq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 21:51:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:48488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726032AbgDYBvq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 21:51:46 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B41AC2076C;
        Sat, 25 Apr 2020 01:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587779506;
        bh=XDiPEBu19bAqC9o2a/qJ/zX5lVJzn8ZyaUm40VOxPd8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VJ1P8j9oUM/CmYw3hTheEbEkJtaJgxLfOzk4p8nQlttAz8+t12X6kWtzkjmhy6gB3
         H05sp6knR66lxyn2JfyBDCq7oHOLT5948OBSJ2zxLxZz19OEj0ObfJOUcmTQlnCLlA
         kDU443/v7TYFoyYnbXy5moZFFnkFbWwmDlqWF1C4=
Date:   Fri, 24 Apr 2020 21:51:44 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Wolfram Sang <wsa@the-dreams.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.6 28/38] i2c: remove i2c_new_probed_device API
Message-ID: <20200425015144.GF13035@sasha-vm>
References: <20200424122237.9831-1-sashal@kernel.org>
 <20200424122237.9831-28-sashal@kernel.org>
 <20200424133635.GB4070@kunai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200424133635.GB4070@kunai>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 24, 2020 at 03:36:35PM +0200, Wolfram Sang wrote:
>On Fri, Apr 24, 2020 at 08:22:26AM -0400, Sasha Levin wrote:
>> From: Wolfram Sang <wsa+renesas@sang-engineering.com>
>>
>> [ Upstream commit 3c1d1613be80c2e17f1ddf672df1d8a8caebfd0d ]
>>
>> All in-tree users have been converted to the new i2c_new_scanned_device
>> function, so remove this deprecated one.
>>
>> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
>> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>This should not be backported. It is only since this merge window that
>all in-tree users are converted!

Uh, I'm not sure how this snuck through. I've droped it, sorry!

-- 
Thanks,
Sasha
