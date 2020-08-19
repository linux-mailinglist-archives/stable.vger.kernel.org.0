Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 918D524AA57
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 01:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgHSX54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 19:57:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:53272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726854AbgHSX4j (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 19:56:39 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C45B208DB;
        Wed, 19 Aug 2020 23:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597881399;
        bh=uf6+fwWm49Q7Uog8Zl53Bg1HEB/3FfYEWWkXtWGll74=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=bYjUsV20r/s7QpUE+fZ3xHESNrjc0hA4qEmx2770KZLHmBQALQAIn5nez8huURBoQ
         64sRiOg6FMu1k/4Ka1/SaZK30j8xT/dNUXumNQftNBBh4a98aBteGLDADoKScsIYK8
         qKqNdYO/z2XuC1Mabz16NMsb8I8WBb+5q9c4ff1w=
Date:   Wed, 19 Aug 2020 23:56:38 +0000
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
Message-Id: <20200819235639.4C45B208DB@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: cb11ea56f37a ("usb: dwc3: gadget: Properly handle ClearFeature(halt)").

The bot has tested the following trees: v5.8.1, v5.7.15, v5.4.58.

v5.8.1: Build OK!
v5.7.15: Failed to apply! Possible dependencies:
    2e6e9e4b2ed7 ("usb: dwc3: gadget: Refactor TRB completion handler")
    3eaecd0c2333 ("usb: dwc3: gadget: Handle XferComplete for streams")
    b6842d4938c3 ("usb: dwc3: gadget: Check for in-progress END_TRANSFER")
    d9feef974e0d ("usb: dwc3: gadget: Continue to process pending requests")
    e0d19563eb6c ("usb: dwc3: gadget: Wait for transfer completion")

v5.4.58: Failed to apply! Possible dependencies:
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
