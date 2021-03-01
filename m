Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77537328094
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 15:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232807AbhCAOUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 09:20:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:52042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233025AbhCAOUu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 09:20:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CF6D64DF5;
        Mon,  1 Mar 2021 14:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614608410;
        bh=HE4Gooagt/0KTn+HjhxgeDNEyXO5uhQmcu4wCWXCHWY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y+S1cCb6ngDbVFrIDWgeFgb1SYZig35wkbdcalb/et4kp58Ygqzc9IafITqJRa6J0
         iKtnr1sAISZJ1U064LhXDCisbJ1KMXekNJqhd4uvVY3IIOH3axPMJLzaFm0/MrScvE
         FnOpzQsOMsOHi5U3PDiOL98WU7s7fduDZM7yuwWc=
Date:   Mon, 1 Mar 2021 15:20:07 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yunlei He <heyunlei@hihonor.com>
Cc:     stable@vger.kernel.org
Subject: Re: [f2fs-dev][PATCH v2] f2fs: fsverity: Truncate cache pages if set
 verity failed
Message-ID: <YDz4Fx1+9Apd3yWP@kroah.com>
References: <20210301140436.5562-1-heyunlei@hihonor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210301140436.5562-1-heyunlei@hihonor.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 01, 2021 at 10:04:36PM +0800, Yunlei He wrote:
> If file enable verity failed, should truncate anything wrote
> past i_size, including cache pages.
> 
> Fixes: 95ae251fe828 ("f2fs: add fs-verity support")
> Cc: <stable@vger.kernel.org> # v5.4+
> Signed-off-by: Yunlei He <heyunlei@hihonor.com>
> ---
>  fs/f2fs/verity.c | 47 +++++++++++++++++++++++++----------------------
>  1 file changed, 25 insertions(+), 22 deletions(-)
> 


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
