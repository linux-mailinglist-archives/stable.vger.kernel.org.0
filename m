Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6C0715002E
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 01:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgBCA6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Feb 2020 19:58:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:48818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726494AbgBCA6o (ORCPT <rfc822;Stable@vger.kernel.org>);
        Sun, 2 Feb 2020 19:58:44 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0C2C205F4;
        Mon,  3 Feb 2020 00:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580691523;
        bh=ue/pvlC2tjtlhf3J+VYbPLdfjdbSGQ7uNCra0l0fUCM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WA4x3dvs9lBpCWWzBormZwKvaq2vSWF5aCjTGcyaOwJxI0lPhAv0yyf1QyvgtVO9u
         m3A1LstpvOUTIAZ9DdoeEj5MfPSXfps1Bdd5gTAl727fXZ1YTMp4yaETWXuWoGKqgN
         NKxBlk0FPWO8oMNKj2BlFuWQoGAWdo6eOYdZii6U=
Date:   Sun, 2 Feb 2020 19:58:42 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     andriy.shevchenko@linux.intel.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, leonard.crestez@nxp.com,
        lorenzo.bianconi83@gmail.com
Subject: Re: FAILED: patch "[PATCH] iio: st_gyro: Correct data for LSM9DS0
 gyro" failed to apply to 4.9-stable tree
Message-ID: <20200203005842.GH1732@sasha-vm>
References: <158037876398197@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158037876398197@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 30, 2020 at 11:06:03AM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.9-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From e825070f697abddf3b9b0a675ed0ff1884114818 Mon Sep 17 00:00:00 2001
>From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>Date: Tue, 17 Dec 2019 19:10:38 +0200
>Subject: [PATCH] iio: st_gyro: Correct data for LSM9DS0 gyro
>
>The commit 41c128cb25ce ("iio: st_gyro: Add lsm9ds0-gyro support")
>assumes that gyro in LSM9DS0 is the same as others with 0xd4 WAI ID,
>but datasheet tells slight different story, i.e. the first scale factor
>for the chip is 245 dps, and not 250 dps.
>
>Correct this by introducing a separate settings for LSM9DS0.
>
>Fixes: 41c128cb25ce ("iio: st_gyro: Add lsm9ds0-gyro support")
>Depends-on: 45a4e4220bf4 ("iio: gyro: st_gyro: fix L3GD20H support")
>Cc: Leonard Crestez <leonard.crestez@nxp.com>
>Cc: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
>Cc: <Stable@vger.kernel.org>
>Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

I've also grabbed d8594fa22a3f ("iio: gyro: st_gyro: inline per-sensor
data") for 4.9 to resolve this.

-- 
Thanks,
Sasha
