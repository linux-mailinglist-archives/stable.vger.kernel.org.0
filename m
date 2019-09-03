Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED56A751D
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 22:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbfICUmA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 16:42:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:33080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725953AbfICUmA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 16:42:00 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E8EA21897;
        Tue,  3 Sep 2019 20:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567543319;
        bh=hacBga48Uc3LJOoZFb92m9QP4Dp3i3Joebu1u7hIPJw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=noD2YVZMFzLRblxzHtyodU2l1fv0ywlOfkVsW7hb8hD8b5M2RBtYZjJUIUQ7T24Z2
         4NbYuL02sfIYg5WD841Wjs2l+vCqbrrHLbAZNbHsolsDcrkNWL43W3SvjiY1BjchLZ
         rXpYUo2vLgU4hmWKURCOBSFNMumym/bVZD5ysVqI=
Date:   Tue, 3 Sep 2019 16:41:58 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     chunyan.zhang@unisoc.com, baolin.wang@linaro.org,
        ulf.hansson@linaro.org, zhang.lyra@gmail.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] mmc: sdhci-sprd: clear the UHS-I modes
 read from registers" failed to apply to 5.2-stable tree
Message-ID: <20190903204158.GN5281@sasha-vm>
References: <15675368231148@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15675368231148@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 03, 2019 at 08:53:43PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.2-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.

I've fixed it up and queued it up for 5.2, it's not needed on older
kernels. No real conflicts, the code just moved around a bit in
drivers/mmc/host/sdhci-sprd.c .

--
Thanks,
Sasha
