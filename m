Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13259A2A8D
	for <lists+stable@lfdr.de>; Fri, 30 Aug 2019 01:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbfH2XLM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 19:11:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727826AbfH2XLM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 19:11:12 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F3D5208C2;
        Thu, 29 Aug 2019 23:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567120270;
        bh=ag0UIe0YzhQynQuCXKX36KQPqflG0cViD6Fin3LuR7w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PVREcpwizbQy+GWwZCdLcHvjGLow3aetqQLoIwjCWBKXmHDy4tKY4RbjsElKDmHsY
         5BUzfpbbFSdPADeQWT1GBYGnftSc0i5kVDUIOdKiFxYnn6zQkkc6KkkKPq8S4kRjfL
         f+3roI81jUEVpZXC+k0vmuC7z9Xs0BbyaG+W4l8E=
Date:   Thu, 29 Aug 2019 19:11:09 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mathieu Poirier <mathieu.poirier@linaro.org>
Cc:     stable@vger.kernel.org, architt@codeaurora.org,
        a.hajda@samsung.com, Laurent.pinchart@ideasonboard.com,
        airlied@linux.ie, jsarha@ti.com, tomi.valkeinen@ti.com,
        vinholikatti@gmail.com, jejb@linux.vnet.ibm.com,
        martin.petersen@oracle.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [BACKPORT 4.19.y 3/3] drm/tilcdc: Register cpufreq notifier
 after we have initialized crtc
Message-ID: <20190829231109.GR5281@sasha-vm>
References: <20190829200001.17092-1-mathieu.poirier@linaro.org>
 <20190829200001.17092-4-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190829200001.17092-4-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 29, 2019 at 02:00:01PM -0600, Mathieu Poirier wrote:
>From: Jyri Sarha <jsarha@ti.com>
>
>commit 432973fd3a20102840d5f7e61af9f1a03c217a4c upstream
>
>Register cpufreq notifier after we have initialized the crtc and
>unregister it before we remove the ctrc. Receiving a cpufreq notify
>without crtc causes a crash.
>
>Reported-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
>Signed-off-by: Jyri Sarha <jsarha@ti.com>
>Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>

I've queued this one for 4.19 and 4.14, thank you!

--
Thanks,
Sasha
