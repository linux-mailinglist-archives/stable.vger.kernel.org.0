Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 571F7331CCE
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 03:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbhCICRG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 21:17:06 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:34600 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229599AbhCICQj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 21:16:39 -0500
Received: from mailhost.synopsys.com (sv1-mailhost1.synopsys.com [10.205.2.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 5CC4C401BB;
        Tue,  9 Mar 2021 02:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1615256199; bh=aHjXY5KS4AS5ZC38ywNRBBXYREi/d9ECQrE9uyq+Bs8=;
        h=Date:From:Subject:To:Cc:From;
        b=Od9h5w5xujtA/pmXFLYgLnxZdRAK5bLA6EpcAfx1FT+76kAOdLIT8UxRe7ulv3R3p
         /c3Sf260dEd0syS62QF7tE3KT1VgtYuo24O1pcryaR99d0qtaBnBiYRBMPi67Ptywy
         uN2H45A7UVMYvAvKjXqSMFRMqr1i6tkGBD9fovRHs8t8apTaN5RSeLRXYfFkMCtWDN
         BS0dsUf3IiZSr/fOPZxMx53j6PHCX3unaaoal/7ToDPJnw5xGqiC3mADn8pXArefs5
         UTi6rS8SPRzIeUj5W3w/wd2llkVBxnO9ZbIndXv0mj0NQ7cJUTWp+25+Sigd+kc/Cu
         Ij651n1p/+T0A==
Received: from lab-vbox (unknown [10.205.145.68])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id DEDF2A005E;
        Tue,  9 Mar 2021 02:16:37 +0000 (UTC)
Received: by lab-vbox (sSMTP sendmail emulation); Mon, 08 Mar 2021 18:16:37 -0800
Date:   Mon, 08 Mar 2021 18:16:37 -0800
Message-Id: <cover.1615254129.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 0/2] usb: dwc3: gadget: Fix ssp speed setting
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh.Nguyen@synopsys.com, linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, <stable@vger.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix a couple of issues with setting the gadget's speed for DWC_usb32 IP. We
should not notice this issue with other IPs.


Thinh Nguyen (2):
  usb: dwc3: gadget: Set gadget_max_speed when set ssp_rate
  usb: dwc3: gadget: Use max speed if unspecified

 drivers/usb/dwc3/gadget.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


base-commit: 7f6f181b3e2c4d08f5d693eebe7901a28fab8666
-- 
2.28.0

