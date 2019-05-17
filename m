Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8608521166
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 02:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbfEQAlv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 20:41:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726510AbfEQAlu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 20:41:50 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0011B2082E;
        Fri, 17 May 2019 00:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558053710;
        bh=i2+9utRlxCHn9C2roOMcf3frhGqK+t57o1CPp16OXYc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FDE+FWBNLVDtKOwNC/rFUHf+hnpSeMHmMCt72Hr68ESZ0dJfRpyOm38mybQ1XF1BX
         RsGvDy0g1h+7iYFwZEhs8kX1WOn8/EOquXyIvZg+s524E3iP2b3ABol2J8A5vNt8yj
         +KuFnZ9Nudg6k9N9pZNbn9nbSXX0bGh8MNDRa+Uw=
Date:   Thu, 16 May 2019 20:41:48 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        Michael Kelley <mikelley@microsoft.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] PCI: hv: Fix a memory leak in
 hv_eject_device_work()" failed to apply to 4.14-stable tree
Message-ID: <20190517004148.GV11972@sasha-vm>
References: <1557909270643@kroah.com>
 <PU1P153MB0169D8FF719D8718F6B3157ABF090@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <PU1P153MB0169D8FF719D8718F6B3157ABF090@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 15, 2019 at 11:18:56PM +0000, Dexuan Cui wrote:
>Hi,
>I backported the patch for linux-4.14.y.
>
>Please use the attached patch, which is [PATCH 1/3]

Hi Dexuan,

For future reference, please keep the commit message in the backported
patch same as the upstream one, unless you want to add additional
information about the backport, in which case just add it to the commit
message rather than replacing it.

I've cleaned up the commit message and queued it up for 4.14, thank you.

--
Thanks,
Sasha
