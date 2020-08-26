Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB8F025309A
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 15:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730569AbgHZNyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 09:54:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:33136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730508AbgHZNyN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 09:54:13 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6F4C22B4D;
        Wed, 26 Aug 2020 13:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598450053;
        bh=3cLFlijIm8TRTHu3NH/xBa21V03XKY49c3ZS1Mlrw6M=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=cWPi5SekM7emvsrjh3fjPT33ptuQQEZdkK1RBtnQe8/V/p8GXBqM3bgPEfut/p4Xz
         SclVbXWYF4nZQIABTh/nCPLuIzxBmxBlXkqYhuUuwzvv8N4Z1MJWGqF1KtkxkCaHgv
         D8MQVJIeQbjdoF2Qicr/7iKIN7n171nZV49Chdrc=
Date:   Wed, 26 Aug 2020 13:54:12 +0000
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
Message-Id: <20200826135412.E6F4C22B4D@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: d6e5a549cc4d ("usb: dwc3: simplify ZLP handling").

The bot has tested the following trees: v5.8.2, v5.7.16, v5.4.59, v4.19.140, v4.14.193.

v5.8.2: Build OK!
v5.7.16: Failed to apply! Possible dependencies:
    2e6e9e4b2ed7 ("usb: dwc3: gadget: Refactor TRB completion handler")
    3eaecd0c2333 ("usb: dwc3: gadget: Handle XferComplete for streams")
    b6842d4938c3 ("usb: dwc3: gadget: Check for in-progress END_TRANSFER")
    d9feef974e0d ("usb: dwc3: gadget: Continue to process pending requests")

v5.4.59: Failed to apply! Possible dependencies:
    2e6e9e4b2ed7 ("usb: dwc3: gadget: Refactor TRB completion handler")
    3eaecd0c2333 ("usb: dwc3: gadget: Handle XferComplete for streams")
    b6842d4938c3 ("usb: dwc3: gadget: Check for in-progress END_TRANSFER")
    d9feef974e0d ("usb: dwc3: gadget: Continue to process pending requests")

v4.19.140: Failed to apply! Possible dependencies:
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
