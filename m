Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95265F7548
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 14:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfKKNre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 08:47:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:46252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726928AbfKKNre (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 08:47:34 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1A96206A3;
        Mon, 11 Nov 2019 13:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573480054;
        bh=6Bk9YPbSoRH7AooYtlsYuckf9pdnyyXK/SWjD2DzVaA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c3P6rPWjGOkVRqUDXk6oeAD6T6hOWKeNwh0JqMxHWUWbWYZeVTYP8994hBL6ebW38
         WNrHGWMZTXV9kIkML5TLf3iy1D4SYdsaIDuvqzq/JhVBLS1BCAzbnaPftKZiukiZRb
         C0TXqm3yShJ81A079Iz+mqrjlcQTONNbjgCB0APs=
Date:   Mon, 11 Nov 2019 08:47:32 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     JManeyrol@invensense.com, Jonathan.Cameron@huawei.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] iio: imu: inv_mpu6050: fix no data on
 MPU6050" failed to apply to 4.19-stable tree
Message-ID: <20191111134732.GB8496@sasha-vm>
References: <15734533311935@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15734533311935@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 11, 2019 at 07:22:11AM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
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
>From 6e82ae6b8d11b948b74e71396efd8e074c415f44 Mon Sep 17 00:00:00 2001
>From: Jean-Baptiste Maneyrol <JManeyrol@invensense.com>
>Date: Wed, 16 Oct 2019 14:43:28 +0000
>Subject: [PATCH] iio: imu: inv_mpu6050: fix no data on MPU6050
>
>Some chips have a fifo overflow bit issue where the bit is always
>set. The result is that every data is dropped.
>
>Change fifo overflow management by checking fifo count against
>a maximum value.
>
>Add fifo size in chip hardware set of values.
>
>Fixes: f5057e7b2dba ("iio: imu: inv_mpu6050: better fifo overflow handling")
>Cc: stable@vger.kernel.org
>Signed-off-by: Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>
>Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

I've resolved the conflict by also queueing up 22904bdff978 ("iio: imu:
mpu6050: Add support for the ICM 20602 IMU") on 4.19.

-- 
Thanks,
Sasha
