Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFF5311FA48
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 19:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbfLOSHK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 13:07:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:49738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbfLOSHK (ORCPT <rfc822;Stable@vger.kernel.org>);
        Sun, 15 Dec 2019 13:07:10 -0500
Received: from localhost (unknown [73.61.17.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1DFC20700;
        Sun, 15 Dec 2019 18:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576433230;
        bh=Myyw5FGLCNkgYLdz3X3uMr7ubP2jEcmKntk27JHXRII=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LAU1miz7hUYH3EzJOogmRSGu5p83mH8VvvKxkFALh9UbPIOpKdLXL6Vfi9+KTyIgO
         UCEsShg7eSKt30mG3RNJ3Synxrb+sJHDQ/nPZxO7amxvV2ZE5zzkMnOrz3WlodPsGJ
         kabQoN3bb2PVkWBTzwLcKCF0pVJbDovKmYRuG8gs=
Date:   Sun, 15 Dec 2019 13:07:08 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     nuno.sa@analog.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] iio: adis16480: Add debugfs_reg_access
 entry" failed to apply to 4.14-stable tree
Message-ID: <20191215180708.GI18043@sasha-vm>
References: <15764021987748@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <15764021987748@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 15, 2019 at 10:29:58AM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.14-stable tree.
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
>From 4c35b7a51e2f291471f7221d112c6a45c63e83bc Mon Sep 17 00:00:00 2001
>From: =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>
>Date: Mon, 28 Oct 2019 17:33:49 +0100
>Subject: [PATCH] iio: adis16480: Add debugfs_reg_access entry
>MIME-Version: 1.0
>Content-Type: text/plain; charset=UTF-8
>Content-Transfer-Encoding: 8bit
>
>The driver is defining debugfs entries by calling
>`adis16480_debugfs_init()`. However, those entries are attached to the
>iio_dev debugfs entry which won't exist if no debugfs_reg_access
>callback is provided.
>
>Fixes: 2f3abe6cbb6c ("iio:imu: Add support for the ADIS16480 and similar IMUs")
>Signed-off-by: Nuno Sá <nuno.sa@analog.com>
>Cc: <Stable@vger.kernel.org>
>Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

Trivial context conflicts, I've fixed it up and queued for 4.14-4.4.

-- 
Thanks,
Sasha
