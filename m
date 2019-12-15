Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2092311FA5A
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 19:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbfLOSKz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 13:10:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:51274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726192AbfLOSKz (ORCPT <rfc822;Stable@vger.kernel.org>);
        Sun, 15 Dec 2019 13:10:55 -0500
Received: from localhost (unknown [73.61.17.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 535E920700;
        Sun, 15 Dec 2019 18:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576433454;
        bh=mILHAfKfrme4HvK0A0c8f86UB7VxsVNiFOyZYjFzbLM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n99YyyTFJ4Eb0tAnre9G5nXvfWjgNGytNuSUEGEqn1Nl48aYH5MVoUqVB0x0b8HQg
         7RpYmy6+pIchRhOJspzr3p0GRi7wPzYmsu6anVI2DyDs8XLuTlJMkgd+4Ad8cy/or1
         OFcdvIpXDKhyZzNXdDcGSEP3aLzfBQICy0SEsDm8=
Date:   Sun, 15 Dec 2019 13:10:53 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     lorenzo@kernel.org, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] iio: imu: st_lsm6dsx: fix ODR check in
 st_lsm6dsx_write_raw" failed to apply to 5.3-stable tree
Message-ID: <20191215181053.GJ18043@sasha-vm>
References: <157640221818196@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <157640221818196@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 15, 2019 at 10:30:18AM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.3-stable tree.
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
>From fc3f6ad7f5dc6c899fbda0255865737bac88c2e0 Mon Sep 17 00:00:00 2001
>From: Lorenzo Bianconi <lorenzo@kernel.org>
>Date: Sun, 27 Oct 2019 19:02:30 +0100
>Subject: [PATCH] iio: imu: st_lsm6dsx: fix ODR check in st_lsm6dsx_write_raw
>
>Since st_lsm6dsx i2c master controller relies on accel device as trigger
>and slave devices can run at different ODRs we must select an accel_odr >=
>slave_odr. Report real accel ODR in st_lsm6dsx_check_odr() in order to
>properly set sensor frequency in st_lsm6dsx_write_raw and avoid to
>report unsupported frequency
>
>Fixes: 6ffb55e5009ff ("iio: imu: st_lsm6dsx: introduce ST_LSM6DSX_ID_EXT sensor ids")
>Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>Cc: <Stable@vger.kernel.org>
>Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

I took in the following as a dependency and queued for 5.3:

	40dd73438977 ("iio: imu: st_lsm6dsx: move odr_table in st_lsm6dsx_sensor_settings")

-- 
Thanks,
Sasha
