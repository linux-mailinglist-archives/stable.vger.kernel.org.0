Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDE5A7522
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 22:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfICUoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 16:44:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:33640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725994AbfICUoa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 16:44:30 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00B902168B;
        Tue,  3 Sep 2019 20:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567543469;
        bh=OGREBKHWAyb2ggaOOl1z7JUg/8BlPs75VTBr5PRwMi4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=trKYKtOBArKjpRwS9fLcPK9YoXOedmXlrwnR8Amgnhl7UXnc51r5UG8WOeGrkGq1D
         mhPZTnSVZPewmZQtMnCqumfhLex7Jm/kMbL3c+OcJr1XfgidTP9IjJ6aqa2BxC0EEg
         AnsHUnnapzHl5svf18RUHosTfxWatcOTwVOjjdck=
Date:   Tue, 3 Sep 2019 16:44:27 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     chunyan.zhang@unisoc.com, baolin.wang@linaro.org,
        ulf.hansson@linaro.org, zhang.lyra@gmail.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] mmc: sdhci-sprd: add get_ro hook
 function" failed to apply to 5.2-stable tree
Message-ID: <20190903204427.GO5281@sasha-vm>
References: <1567536830154206@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1567536830154206@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 03, 2019 at 08:53:50PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.2-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.

I've fixed it up for 5.2, it's not needed on older kernels. Contextual
conflict due to missing 7486831d7d6ae (mmc: sdhci-sprd: Implement the
get_max_timeout_count() interface), I just took 7486831d7d6ae as well.

--
Thanks,
Sasha
