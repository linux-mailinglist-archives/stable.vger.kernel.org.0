Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D182C1B341F
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 02:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgDVApl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 20:45:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:41636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726012AbgDVApk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 20:45:40 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42492206E9;
        Wed, 22 Apr 2020 00:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587516340;
        bh=swEW3LhntH58zS1oH5ogHUs1pXSXEJ8cE6H4W/ht0H8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j6AvFReahbrwT6BEOxuG9kxQO3iR6s37jfcZJt9l/P7FhFpoMmhSTLLeReODEAO+g
         KM5B3ltJeryW/tYkGuDy9kmvrTO4O1Wwykf5gTobVO1mtNvgE8ynwdISlUQ1u13t3U
         HUzR5GvdTLzx54IuDdzSwP70VGwO4TMBMAcqb2M4=
Date:   Tue, 21 Apr 2020 20:45:39 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     Tianyu.Lan@microsoft.com, mikelley@microsoft.com,
        wei.liu@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/Hyper-V: Report crash data in die()
 when panic_on_oops is" failed to apply to 4.19-stable tree
Message-ID: <20200422004539.GT1809@sasha-vm>
References: <1587489190114108@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1587489190114108@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 21, 2020 at 07:13:10PM +0200, gregkh@linuxfoundation.org wrote:
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
>From f3a99e761efa616028b255b4de58e9b5b87c5545 Mon Sep 17 00:00:00 2001
>From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>Date: Mon, 6 Apr 2020 08:53:31 -0700
>Subject: [PATCH] x86/Hyper-V: Report crash data in die() when panic_on_oops is
> set
>
>When oops happens with panic_on_oops unset, the oops
>thread is killed by die() and system continues to run.
>In such case, guest should not report crash register
>data to host since system still runs. Check panic_on_oops
>and return directly in hyperv_report_panic() when the function
>is called in the die() and panic_on_oops is unset. Fix it.
>
>Fixes: 7ed4325a44ea ("Drivers: hv: vmbus: Make panic reporting to be more useful")
>Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
>Reviewed-by: Michael Kelley <mikelley@microsoft.com>
>Link: https://lore.kernel.org/r/20200406155331.2105-7-Tianyu.Lan@microsoft.com
>Signed-off-by: Wei Liu <wei.liu@kernel.org>

The additional conflicts here are due to missing suspend/resume and
header movement due to missing arm64 support. Fixed and queued up.

-- 
Thanks,
Sasha
