Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3511282ABA
	for <lists+stable@lfdr.de>; Sun,  4 Oct 2020 14:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbgJDMyc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Oct 2020 08:54:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:58332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725856AbgJDMyc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Oct 2020 08:54:32 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78822206C1;
        Sun,  4 Oct 2020 12:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601816071;
        bh=j3fXHj/yGgiocWlpffObQ87hxGbFY8VMgsdEnHS+RgM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xGyKJbqy1ZzzgZQ+FZKigyr1eTqDna+upxevSXMqM0R0oEozpTa5dcH6ULDSC78Kn
         xQ31FhC8YOzLtY/hAMLsQ+yujsixctAQn8g04r6mL2HWZBpPZB7C3MAq0oCKLrU2nq
         +cB+I1q8Fv21TUqB5eCAy8amOoOSEVBFm9NSlcco=
Date:   Sun, 4 Oct 2020 08:54:29 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Charles Keepax <ckeepax@opensource.cirrus.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH AUTOSEL 5.8 14/29] regmap: debugfs: Fix handling of name
 string for debugfs init delays
Message-ID: <20201004125429.GK2415204@sasha-vm>
References: <20200929013027.2406344-1-sashal@kernel.org>
 <20200929013027.2406344-14-sashal@kernel.org>
 <20200929083334.GX10899@ediswmail.ad.cirrus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200929083334.GX10899@ediswmail.ad.cirrus.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 29, 2020 at 08:33:34AM +0000, Charles Keepax wrote:
>On Mon, Sep 28, 2020 at 09:30:11PM -0400, Sasha Levin wrote:
>> From: Charles Keepax <ckeepax@opensource.cirrus.com>
>>
>> [ Upstream commit 94cc89eb8fa5039fcb6e3e3d50f929ddcccee095 ]
>>
>> In regmap_debugfs_init the initialisation of the debugfs is delayed
>> if the root node isn't ready yet. Most callers of regmap_debugfs_init
>> pass the name from the regmap_config, which is considered temporary
>> ie. may be unallocated after the regmap_init call returns. This leads
>> to a potential use after free, where config->name has been freed by
>> the time it is used in regmap_debugfs_initcall.
>>
>
>Afraid this patch had some issues if you are back porting it you
>definitely need to take these two patches as well:
>
>commit 1d512ee861b80da63cbc501b973c53131aa22f29
>regmap: debugfs: Fix more error path regressions

Looks like 1d512ee861b is queued for the merge window even though it's a
bugfix for this release?

I'm going to drop this patch.

-- 
Thanks,
Sasha
