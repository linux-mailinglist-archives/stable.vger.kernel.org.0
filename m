Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B29719597B
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 16:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgC0PDl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Mar 2020 11:03:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:43918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727703AbgC0PDl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Mar 2020 11:03:41 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFAF62072F;
        Fri, 27 Mar 2020 15:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585321421;
        bh=uV30NRVjkdG37tLP6p/F0Urih0Ipm0qBMHRV6PWFXNs=;
        h=Date:From:To:To:To:Cc:CC:Cc:Subject:In-Reply-To:References:From;
        b=J+aQLcUufN3ksiS5Eco9LAviKqpk3x+16d0z9T9RE7cNyV1lZlwdk/Z+TgRXPkx2y
         j2rIxWHat8t9TYZK8fcbArDE6+XoXtb0QOoeTI6aTmQrTk6Pul0CIQGUGKdrSOrfNR
         nSvVaDT4vE6c791Hyq3GKa47+doB6XBcVYPAkQJI=
Date:   Fri, 27 Mar 2020 15:03:40 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Sriharsha Allenki <sallenki@codeaurora.org>
To:     balbi@kernel.org, gregkh@linuxfoundation.org
Cc:     peter.chen@nxp.com, stable@vger.kernel.org, mgautam@codeaurora.org
CC:     stable <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2] usb: gadget: f_fs: Fix use after free issue as part of queue failure
In-Reply-To: <20200326115620.12571-1-sallenki@codeaurora.org>
References: <20200326115620.12571-1-sallenki@codeaurora.org>
Message-Id: <20200327150340.EFAF62072F@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 2e4c7553cd6f ("usb: gadget: f_fs: add aio support").

The bot has tested the following trees: v5.5.11, v5.4.27, v4.19.112, v4.14.174, v4.9.217, v4.4.217.

v5.5.11: Build OK!
v5.4.27: Build OK!
v4.19.112: Build OK!
v4.14.174: Build OK!
v4.9.217: Build OK!
v4.4.217: Failed to apply! Possible dependencies:
    3163c79efa65 ("usb: f_fs: fix ffs_epfile_io returning success on req alloc failure")
    3de4e2056817 ("usb: f_fs: fix memory leak when ep changes during transfer")
    ae76e13477d8 ("usb: f_fs: refactor ffs_epfile_io")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
