Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC2062530B6
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 15:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730447AbgHZNzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 09:55:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:60272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730406AbgHZNxt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 09:53:49 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D677122B47;
        Wed, 26 Aug 2020 13:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598450027;
        bh=s8bwzZM8z3KK6sKLIGTfaE70Yv5ME9nDILyw0BMCNFc=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=loP14u4KyzyElRotvbHGtikqiE5PIAf1s8HzKPJwZVt4Fp/zJQHktfklYJt8MtsgH
         b3EYYOhx677tpfOqottJD8IJuwTweQUmAvUOqHcmTuqja9PFGYST0nvNki+A5oj7+n
         1ukznYjRQqJIFAdRAX42Om+cocDD34Nx8XXAYZYg=
Date:   Wed, 26 Aug 2020 13:53:46 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Felipe Balbi <balbi@kernel.org>
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 2/3] usb: dwc3: gadget: END_TRANSFER before CLEAR_STALL command
In-Reply-To: <5c1c044097118dfa6d56e5235a746f9fb16fc8e8.1596151437.git.thinhn@synopsys.com>
References: <5c1c044097118dfa6d56e5235a746f9fb16fc8e8.1596151437.git.thinhn@synopsys.com>
Message-Id: <20200826135346.D677122B47@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: cb11ea56f37a ("usb: dwc3: gadget: Properly handle ClearFeature(halt)").

The bot has tested the following trees: v5.8.2, v5.7.16, v5.4.59.

v5.8.2: Failed to apply! Possible dependencies:
    Unable to calculate

v5.7.16: Failed to apply! Possible dependencies:
    140ca4cfea8a ("usb: dwc3: gadget: Handle stream transfers")
    2e6e9e4b2ed7 ("usb: dwc3: gadget: Refactor TRB completion handler")
    3eaecd0c2333 ("usb: dwc3: gadget: Handle XferComplete for streams")
    b6842d4938c3 ("usb: dwc3: gadget: Check for in-progress END_TRANSFER")
    d9feef974e0d ("usb: dwc3: gadget: Continue to process pending requests")
    e0d19563eb6c ("usb: dwc3: gadget: Wait for transfer completion")

v5.4.59: Failed to apply! Possible dependencies:
    140ca4cfea8a ("usb: dwc3: gadget: Handle stream transfers")
    2e6e9e4b2ed7 ("usb: dwc3: gadget: Refactor TRB completion handler")
    3eaecd0c2333 ("usb: dwc3: gadget: Handle XferComplete for streams")
    b6842d4938c3 ("usb: dwc3: gadget: Check for in-progress END_TRANSFER")
    d9feef974e0d ("usb: dwc3: gadget: Continue to process pending requests")
    e0d19563eb6c ("usb: dwc3: gadget: Wait for transfer completion")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
