Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4C2425C10A
	for <lists+stable@lfdr.de>; Thu,  3 Sep 2020 14:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728762AbgICMbn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Sep 2020 08:31:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:56064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728874AbgICMbA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Sep 2020 08:31:00 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B8AB20775;
        Thu,  3 Sep 2020 12:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599136213;
        bh=h2VXF5aZ5Htrq1L2dVtQIWCFj+IAJ7F9By0yqVTJVhE=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=oK7K3oH6qWuMYWDphLkuhWOFwt/v4G5axeElk/5GJLj3TcPC50HDEAZkQIg5xMRYO
         oMZ3yoHzo+7CvwHMzs9HHU7cxS72pj7HsZVbViiOucO0r9/wn3QIj4M3zAfnoAzVty
         2/M17BwqaN6l896PkKG5wZsfSn4SvUi9T7DBpPSk=
Date:   Thu, 03 Sep 2020 12:30:12 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Felipe Balbi <balbi@kernel.org>
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] usb: dwc3: gadget: END_TRANSFER before CLEAR_STALL command
In-Reply-To: <757d7f92950f783a4e1ec40e2f31deb9548b372f.1599096763.git.thinhn@synopsys.com>
References: <757d7f92950f783a4e1ec40e2f31deb9548b372f.1599096763.git.thinhn@synopsys.com>
Message-Id: <20200903123013.8B8AB20775@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: cb11ea56f37a ("usb: dwc3: gadget: Properly handle ClearFeature(halt)").

The bot has tested the following trees: v5.8.5, v5.4.61.

v5.8.5: Failed to apply! Possible dependencies:
    16603abf448d ("usb: dwc3: gadget: Resume pending requests after CLEAR_STALL")

v5.4.61: Failed to apply! Possible dependencies:
    140ca4cfea8a ("usb: dwc3: gadget: Handle stream transfers")
    16603abf448d ("usb: dwc3: gadget: Resume pending requests after CLEAR_STALL")
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
