Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91800E0AB4
	for <lists+stable@lfdr.de>; Tue, 22 Oct 2019 19:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730432AbfJVRah (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Oct 2019 13:30:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730363AbfJVRag (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Oct 2019 13:30:36 -0400
Received: from localhost (mobile-166-172-186-56.mycingular.net [166.172.186.56])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA683214E0;
        Tue, 22 Oct 2019 17:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571765436;
        bh=/Qi9Ddplq+ThOzoxz8MXfVI7wTIN23upnkeFhKU4goM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hf5wf+rPgbt5cD4IOfGfJD03wEMdk76mQUZ/DLxMi/LMLb2Js1/8oGgcMZtLOYEtr
         Ns7JsXTyw5cAWvJgSSRxkGhMg7BqnXGXkWSkVBk1++AY/xt4D0baTMG+F3TRqKBF6d
         94dGiaoPQm/llg4fqYy07SGSiYMlB+Yi1HEoDFlQ=
Date:   Tue, 22 Oct 2019 13:30:33 -0400
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jean-Baptiste Maneyrol <JManeyrol@invensense.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "jic23@kernel.org" <jic23@kernel.org>
Subject: Re: [PATCH 4.19] iio: imu: inv_mpu6050: fix no data on MPU6050
Message-ID: <20191022173033.GB230934@kroah.com>
References: <20191022131239.13847-1-jmaneyrol@invensense.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191022131239.13847-1-jmaneyrol@invensense.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 22, 2019 at 01:13:07PM +0000, Jean-Baptiste Maneyrol wrote:
> Some chips have a fifo overflow bit issue where the bit is always
> set. The result is that every data is dropped.
> 
> Change fifo overflow management by checking fifo count against
> a maximum value.
> 
> Add fifo size in chip hardware set of values.
> 
> Fixes: f5057e7b2dba ("iio: imu: inv_mpu6050: better fifo overflow handling")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>
> ---
>  drivers/iio/imu/inv_mpu6050/inv_mpu_core.c |  8 ++++++++
>  drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h  |  2 ++
>  drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c | 15 ++++++++++++---
>  3 files changed, 22 insertions(+), 3 deletions(-)

What is the git commit id of this patch in Linus's tree?

thanks,

greg k-h
