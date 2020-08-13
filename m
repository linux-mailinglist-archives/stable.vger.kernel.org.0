Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10601243D3A
	for <lists+stable@lfdr.de>; Thu, 13 Aug 2020 18:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbgHMQZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Aug 2020 12:25:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:58138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726486AbgHMQZn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Aug 2020 12:25:43 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCA2120829;
        Thu, 13 Aug 2020 16:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597335943;
        bh=opvYev8r3pRbR52y9XY1TAxW8IPIQFpMRNGu804N+ZQ=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=Ckf7wAcyybhVIm9s3CAZGlA7u+2Hm9kIJsB/fkjdCiie5biNqBLhX1NL9z69mY14F
         u4mnha6Jq382wp31MODffmJ3MumA6BylFaDvBjhMZuS1fc40SoPDB6HYkgmxjAER1+
         XLuivxMXo8ysUl/ZjlWF2oNNtwnX9zLpz1NS4s9I=
Date:   Thu, 13 Aug 2020 16:25:42 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Felipe Balbi <balbi@kernel.org>
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/3] usb: dwc3: gadget: Resume pending requests after CLEAR_STALL
In-Reply-To: <febe1ba310b638f5013e64835c1cc4210e0b799a.1596151437.git.thinhn@synopsys.com>
References: <febe1ba310b638f5013e64835c1cc4210e0b799a.1596151437.git.thinhn@synopsys.com>
Message-Id: <20200813162542.BCA2120829@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: cb11ea56f37a ("usb: dwc3: gadget: Properly handle ClearFeature(halt)").

The bot has tested the following trees: v5.8, v5.7.14, v5.4.57.

v5.8: Build OK!
v5.7.14: Failed to apply! Possible dependencies:
    2e6e9e4b2ed7 ("usb: dwc3: gadget: Refactor TRB completion handler")
    3eaecd0c2333 ("usb: dwc3: gadget: Handle XferComplete for streams")
    b6842d4938c3 ("usb: dwc3: gadget: Check for in-progress END_TRANSFER")
    d9feef974e0d ("usb: dwc3: gadget: Continue to process pending requests")
    e0d19563eb6c ("usb: dwc3: gadget: Wait for transfer completion")

v5.4.57: Failed to apply! Possible dependencies:
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
