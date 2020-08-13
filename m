Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDAC5243D47
	for <lists+stable@lfdr.de>; Thu, 13 Aug 2020 18:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgHMQZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Aug 2020 12:25:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:58546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726192AbgHMQZu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Aug 2020 12:25:50 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EFD320658;
        Thu, 13 Aug 2020 16:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597335949;
        bh=98xDpdYCCmn2DDXLLLeEW29dekq3pp2J1pvfNcpv2Ss=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=Vbf+wlFNlX1Sbp8u1Pg1apZg9T2HPZl5jiyca8qY5+slUb8CnzyiO8v00ncksiDLr
         kTRmWacIE6J40H2jv+1odwC+4jCDVAeCiChHmOc4Q+9G62pBVmAaffZL11RMWYzU8r
         7eP4BtKuLfto6dPLHf8XHiBxXZWuoTOxHBe2wuKI=
Date:   Thu, 13 Aug 2020 16:25:48 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Felipe Balbi <balbi@kernel.org>
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 1/7] usb: dwc3: gadget: Don't setup more than requested
In-Reply-To: <c279d8bdbe0f18cdd6944a6b71265e2309c96059.1596767991.git.thinhn@synopsys.com>
References: <c279d8bdbe0f18cdd6944a6b71265e2309c96059.1596767991.git.thinhn@synopsys.com>
Message-Id: <20200813162549.7EFD320658@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: a31e63b608ff ("usb: dwc3: gadget: Correct handling of scattergather lists").

The bot has tested the following trees: v5.8, v5.7.14, v5.4.57, v4.19.138.

v5.8: Build OK!
v5.7.14: Failed to apply! Possible dependencies:
    2e6e9e4b2ed7 ("usb: dwc3: gadget: Refactor TRB completion handler")
    3eaecd0c2333 ("usb: dwc3: gadget: Handle XferComplete for streams")
    b6842d4938c3 ("usb: dwc3: gadget: Check for in-progress END_TRANSFER")
    d9feef974e0d ("usb: dwc3: gadget: Continue to process pending requests")

v5.4.57: Failed to apply! Possible dependencies:
    2e6e9e4b2ed7 ("usb: dwc3: gadget: Refactor TRB completion handler")
    3eaecd0c2333 ("usb: dwc3: gadget: Handle XferComplete for streams")
    b6842d4938c3 ("usb: dwc3: gadget: Check for in-progress END_TRANSFER")
    d9feef974e0d ("usb: dwc3: gadget: Continue to process pending requests")

v4.19.138: Failed to apply! Possible dependencies:
    2e6e9e4b2ed7 ("usb: dwc3: gadget: Refactor TRB completion handler")
    3aec99154db3 ("usb: dwc3: gadget: remove DWC3_EP_END_TRANSFER_PENDING")
    3eaecd0c2333 ("usb: dwc3: gadget: Handle XferComplete for streams")
    974a1368c33e ("usb: dwc3: gadget: don't use resource_index as a flag")
    a3af5e3ad3f1 ("usb: dwc3: gadget: add dwc3_request status tracking")
    b6842d4938c3 ("usb: dwc3: gadget: Check for in-progress END_TRANSFER")
    c58d8bfc77a2 ("usb: dwc3: gadget: Check END_TRANSFER completion")
    d3abda5a98a1 ("usb: dwc3: gadget: Clear started flag for non-IOC")
    d9feef974e0d ("usb: dwc3: gadget: Continue to process pending requests")
    da10bcdd6f70 ("usb: dwc3: gadget: Delay starting transfer")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
