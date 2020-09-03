Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDBC25C118
	for <lists+stable@lfdr.de>; Thu,  3 Sep 2020 14:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728871AbgICMdi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Sep 2020 08:33:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728870AbgICMbA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Sep 2020 08:31:00 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B148206EB;
        Thu,  3 Sep 2020 12:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599136212;
        bh=eunyv/HknvHb/uAaQzyGdVLYoqaDhb6CX5U85mhlJa8=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=T0VYeiseKzH9juYe8/zSeDH+9GY9TyeVsawU4smSAd9ClhNIJnGWet6kCH13n5Pt1
         B0GnlRDhQ8i/5M8tHhQ5U9zKfzXVMORWpH9JV7DZXHZgwOxhGwXxop9HkhbdI/9V/A
         zVcQj54mRRO6GngMrIjT26Pg2kIe2w8xpWvQcIzg=
Date:   Thu, 03 Sep 2020 12:30:11 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Felipe Balbi <balbi@kernel.org>
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] usb: dwc3: gadget: Resume pending requests after CLEAR_STALL
In-Reply-To: <037e16f184c6823752635e8d9d643f69e05682ff.1599096763.git.thinhn@synopsys.com>
References: <037e16f184c6823752635e8d9d643f69e05682ff.1599096763.git.thinhn@synopsys.com>
Message-Id: <20200903123012.8B148206EB@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: cb11ea56f37a ("usb: dwc3: gadget: Properly handle ClearFeature(halt)").

The bot has tested the following trees: v5.8.5, v5.4.61.

v5.8.5: Build OK!
v5.4.61: Failed to apply! Possible dependencies:
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
