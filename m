Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDA223D508
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 03:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgHFBYF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 21:24:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbgHFBYE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Aug 2020 21:24:04 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1355822CAE;
        Thu,  6 Aug 2020 01:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596677044;
        bh=v2rG5I37WhZdUR7oe4Pa5T+kMJSW2DVD0gz2LmgeZEA=;
        h=Date:From:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=nq8h8v7UU06eivQs7rXr3IXCxyt7vL1XQbLwNjDx0u2a2k7fhd4klhrk9nSsx56iu
         xO0UkB+38PhR3flzEhjVN74ioKwBPqUpceqrCV8XRcPGwqVT1v2InBzm15if4r2zH3
         qJlGEQKAjD8a/lzZMVGATFuwf53/ZQKH2ZwY6iEk=
Date:   Thu, 06 Aug 2020 01:24:03 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Felipe Balbi <balbi@kernel.org>
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 0/3] usb: dwc3: gadget: Fix halt/clear_stall handling
In-Reply-To: <cover.1596151437.git.thinhn@synopsys.com>
References: <cover.1596151437.git.thinhn@synopsys.com>
Message-Id: <20200806012404.1355822CAE@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: cb11ea56f37a ("usb: dwc3: gadget: Properly handle ClearFeature(halt)").

The bot has tested the following trees: v5.7.11, v5.4.54.

v5.7.11: Failed to apply! Possible dependencies:
    140ca4cfea8a ("usb: dwc3: gadget: Handle stream transfers")
    2e6e9e4b2ed7 ("usb: dwc3: gadget: Refactor TRB completion handler")
    3eaecd0c2333 ("usb: dwc3: gadget: Handle XferComplete for streams")
    a42d7cef357a ("usb: dwc3: gadget: END_TRANSFER before CLEAR_STALL command")
    b6842d4938c3 ("usb: dwc3: gadget: Check for in-progress END_TRANSFER")
    d9feef974e0d ("usb: dwc3: gadget: Continue to process pending requests")
    e0d19563eb6c ("usb: dwc3: gadget: Wait for transfer completion")

v5.4.54: Failed to apply! Possible dependencies:
    140ca4cfea8a ("usb: dwc3: gadget: Handle stream transfers")
    2e6e9e4b2ed7 ("usb: dwc3: gadget: Refactor TRB completion handler")
    3eaecd0c2333 ("usb: dwc3: gadget: Handle XferComplete for streams")
    a42d7cef357a ("usb: dwc3: gadget: END_TRANSFER before CLEAR_STALL command")
    b6842d4938c3 ("usb: dwc3: gadget: Check for in-progress END_TRANSFER")
    d9feef974e0d ("usb: dwc3: gadget: Continue to process pending requests")
    e0d19563eb6c ("usb: dwc3: gadget: Wait for transfer completion")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
