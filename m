Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38D182EB0B2
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 17:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728256AbhAEQ5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 11:57:30 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:38580 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728245AbhAEQ5a (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 11:57:30 -0500
Received: from mailhost.synopsys.com (sv1-mailhost1.synopsys.com [10.205.2.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id C5CFF4013B;
        Tue,  5 Jan 2021 16:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1609865789; bh=QRrU39q50srAZbUyWmFfvT4wsMiR+KqiMCT+Og21EZc=;
        h=Date:From:Subject:To:Cc:From;
        b=ViUVwowhMZmJ2Yje6AjiRaESjP+nhikL4cZUB2gEhoN3nyo+bYiLrTwRQWCfKfabc
         AKjWHo1qVtyo0d2dfnWFQFDd20dj5HQ4kbepJOoMEyIX65QOTTRXLH4HimhZ0k4r8T
         8hBxpof7F9l0yHuq+CPTPzqYrpdXy+/zrUeUHiQRrl5sLyprWyQYJwPSm8vMwNiqid
         2BGZcP10MOJgdUoXusmwk1kRVRYsGAsznG37KgPP2ZX3+yCyABgTZFdJlxEeLADNJk
         ZzvWOjRG8WxTXyWiEctJvBYMftAmOqJog2vj5KNbyk5i1IzBzY06pf8MYTRg1e5cS+
         eyn8uQ29bIFlg==
Received: from te-lab16 (unknown [10.10.52.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id A3BCBA0068;
        Tue,  5 Jan 2021 16:56:28 +0000 (UTC)
Received: by te-lab16 (sSMTP sendmail emulation); Tue, 05 Jan 2021 08:56:28 -0800
Date:   Tue, 05 Jan 2021 08:56:28 -0800
Message-Id: <cover.1609865348.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 0/2] usb: dwc3: gadget: Check for multiple start/stop
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh.Nguyen@synopsys.com, linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, <stable@vger.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add some checks to avoid going through the start/stop sequence if the gadget
had already started/stopped. This series base-commit is Greg's usb-linus
branch.



Thinh Nguyen (2):
  usb: dwc3: gadget: Check if the gadget had started
  usb: dwc3: gadget: Check if the gadget had stopped

 drivers/usb/dwc3/gadget.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)


base-commit: 96ebc9c871d8a28fb22aa758dd9188a4732df482
-- 
2.28.0

