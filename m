Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C58F52BC77D
	for <lists+stable@lfdr.de>; Sun, 22 Nov 2020 18:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbgKVR2f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 12:28:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:59664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727382AbgKVR2f (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Nov 2020 12:28:35 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AA4E2075A;
        Sun, 22 Nov 2020 17:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606066115;
        bh=MzwCV85IXikmvquomiOznbMjTM8I05CMsHRCE6QnEQg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kthW4sD/mpGOr/rzJO7XBaINWnjv62A6v7PhzOQrIZ9EHoSBhKFNqGCKZ/Rc9Ua+6
         df1/E5l3MJtsDsiwwSCkvLztUaG2W8VCV6YqhmdU9siWADC/OQOYF38LQJnAtYGu0R
         jUrhBFsz9slCRJ1OC3nyboYVUdkgS/11xKqrrnns=
Date:   Sun, 22 Nov 2020 12:28:34 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Kamal Mostafa <kamal@canonical.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>
Subject: Re: [PATCH 5.9.x] usb: dwc2: Avoid leaving the error_debugfs label
 unused
Message-ID: <20201122172834.GH643756@sasha-vm>
References: <X7eAyumuMGcWBG81@kroah.com>
 <20201120164645.12542-1-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201120164645.12542-1-kamal@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 20, 2020 at 08:46:45AM -0800, Kamal Mostafa wrote:
>From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
>
>commit 190bb01b72d2d5c3654a03c42fb1ad0dc6114c79 upstream.
>
>The error_debugfs label is only used when either
>CONFIG_USB_DWC2_PERIPHERAL or CONFIG_USB_DWC2_DUAL_ROLE is enabled. Add
>the same #if to the error_debugfs label itself as the code which uses
>this label already has.
>
>This avoids the following compiler warning:
>  warning: label ‘error_debugfs’ defined but not used [-Wunused-label]
>
>Fixes: e1c08cf23172ed ("usb: dwc2: Add missing cleanups when usb_add_gadget_udc() fails")
>Acked-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
>Reported-by: kernel test robot <lkp@intel.com>
>Reported-by: Jens Axboe <axboe@kernel.dk>
>Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
>Signed-off-by: Felipe Balbi <balbi@kernel.org>
>Cc: stable@vger.kernel.org # 5.9.x
>Signed-off-by: Kamal Mostafa <kamal@canonical.com>

Queued up, thanks!

-- 
Thanks,
Sasha
