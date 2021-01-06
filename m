Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80F3A2EC2FB
	for <lists+stable@lfdr.de>; Wed,  6 Jan 2021 19:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbhAFSKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 13:10:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:57946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbhAFSKg (ORCPT <rfc822;Stable@vger.kernel.org>);
        Wed, 6 Jan 2021 13:10:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63FEB216C4;
        Wed,  6 Jan 2021 18:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609956595;
        bh=64r93j7EUlJoxIwSF693l7qlKleIvCXujYtKspm0w+I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FHVnjN5u2fZdHit5rbeOdvOuufkLgt9GQBXPwNlbThsVb64Ye3vKTzL6SyqYilbah
         CU72iGyWOTn+7lfCofvWZwZGID0VosblYm3b0G85ENP2HADsHoLIyhH5/jJTnLDXlN
         d5H7OY9pdTAPwP8oxD6LoDMzywBPDp97SoawA66M=
Date:   Wed, 6 Jan 2021 19:11:17 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        alexandru.ardelean@analog.com, daniel.baluta@gmail.com,
        daniel.baluta@oss.nxp.com, lars@metafoo.de
Subject: Re: FAILED: patch "[PATCH] iio:imu:bmi160: Fix alignment and data
 leak issues" failed to apply to 4.9-stable tree
Message-ID: <X/X9RfHaPyPp3i+k@kroah.com>
References: <1609154067196181@kroah.com>
 <20210105191337.7pxii235rrxbsa6b@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210105191337.7pxii235rrxbsa6b@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 05, 2021 at 07:13:37PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Dec 28, 2020 at 12:14:27PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.9-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport along with:
> dd4ba3fb2223 ("iio: bmi160_core: Fix sparse warning due to incorrect type
> in assignment")
> dc7de42d6b50 ("iio:imu:bmi160: Fix too large a buffer.")
> which makes backporting easier. dc7de42d6b50 was already marked for stable
> but was missing in 4.9-stable.
> 

Thanks for all the backports, now queued up.

greg k-h
