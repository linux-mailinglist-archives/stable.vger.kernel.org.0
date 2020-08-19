Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD55F24AA31
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 01:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgHSX5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 19:57:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:54026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726977AbgHSX5D (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 19:57:03 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC9CD208E4;
        Wed, 19 Aug 2020 23:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597881422;
        bh=kGl05GHGUK1e8HXaeOCj2vrCnE8BGtQL3EdxhlLVGXs=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=Bl0mxD/kIQAudXST99gVtz7BDczkdy85lEgJ4YLgtW1vrQ79lI3X491Wkgq2kHf8K
         bqLmReijbZts8aPy7VPVm+ti/HqqgEeJx992K1SPXKA8Cu/iOiGhDos9Ivsdn1GPPF
         j8FKSMooneMj/v4DNNdqz6+lTilN7kKTIBU/gRso=
Date:   Wed, 19 Aug 2020 23:57:02 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Felipe Balbi <balbi@kernel.org>
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 2/7] usb: dwc3: gadget: Fix handling ZLP
In-Reply-To: <14acf1f4680fbd9b8d6b60a748a17ee6a04380a8.1596767991.git.thinhn@synopsys.com>
References: <14acf1f4680fbd9b8d6b60a748a17ee6a04380a8.1596767991.git.thinhn@synopsys.com>
Message-Id: <20200819235702.BC9CD208E4@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: d6e5a549cc4d ("usb: dwc3: simplify ZLP handling").

The bot has tested the following trees: v5.8.1, v5.7.15, v5.4.58, v4.19.139, v4.14.193.

v5.8.1: Build OK!
v5.7.15: Failed to apply! Possible dependencies:
    2e6e9e4b2ed7 ("usb: dwc3: gadget: Refactor TRB completion handler")
    3eaecd0c2333 ("usb: dwc3: gadget: Handle XferComplete for streams")
    b6842d4938c3 ("usb: dwc3: gadget: Check for in-progress END_TRANSFER")
    d9feef974e0d ("usb: dwc3: gadget: Continue to process pending requests")

v5.4.58: Failed to apply! Possible dependencies:
    2e6e9e4b2ed7 ("usb: dwc3: gadget: Refactor TRB completion handler")
    3eaecd0c2333 ("usb: dwc3: gadget: Handle XferComplete for streams")
    b6842d4938c3 ("usb: dwc3: gadget: Check for in-progress END_TRANSFER")
    d9feef974e0d ("usb: dwc3: gadget: Continue to process pending requests")

v4.19.139: Failed to apply! Possible dependencies:
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

v4.14.193: Failed to apply! Possible dependencies:
    09fe1f8d7e2f ("usb: dwc3: gadget: track number of TRBs per request")
    0bd0f6d201eb ("usb: dwc3: gadget: remove allocated/queued request tracking")
    1a22ec643580 ("usb: dwc3: gadget: combine unaligned and zero flags")
    38408464aa76 ("usb: dwc3: gadget: XferNotReady is Isoc-only")
    3eaecd0c2333 ("usb: dwc3: gadget: Handle XferComplete for streams")
    502a37b98a7b ("usb: dwc3: gadget: cache frame number in struct dwc3_ep")
    66f5dd5a0379 ("usb: dwc3: gadget: rename done_trbs and done_reqs")
    7fdca766499b ("usb: dwc3: gadget: simplify __dwc3_gadget_kick_transfer() prototype")
    8f608e8ab628 ("usb: dwc3: gadget: remove unnecessary 'dwc' parameter")
    a31e63b608ff ("usb: dwc3: gadget: Correct handling of scattergather lists")
    d80fe1b6e34d ("usb: dwc3: gadget: simplify short packet event")
    e0c42ce590fe ("usb: dwc3: gadget: simplify IOC handling")
    f38e35dd84e2 ("usb: dwc3: gadget: split dwc3_gadget_ep_cleanup_completed_requests()")
    fbea935accf4 ("usb: dwc3: gadget: rename dwc3_endpoint_transfer_complete()")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
