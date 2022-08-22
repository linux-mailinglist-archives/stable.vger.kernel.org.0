Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A42159B835
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 06:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbiHVEH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 00:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbiHVEH0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 00:07:26 -0400
X-Greylist: delayed 384 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 21 Aug 2022 21:07:24 PDT
Received: from gw.atmark-techno.com (gw.atmark-techno.com [13.115.124.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9536620F4E
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 21:07:24 -0700 (PDT)
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
        by gw.atmark-techno.com (Postfix) with ESMTPS id A87C561BDF
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 13:00:59 +0900 (JST)
Received: by mail-pj1-f71.google.com with SMTP id oo12-20020a17090b1c8c00b001faa0b549caso8943011pjb.0
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 21:00:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc;
        bh=DQxh0MwUfh2ZTk23/KcBcsAnm1po7PSzlQSQYwwgR9w=;
        b=SEPxfHiVuarKOpuk62fEAlw4+YpOFB9QQLFbhFK/ItJ7cuU3vFn4b7qkbcvuJyfHWg
         LbU3pD5hpAXqGcpwm2HpsOz6+rrslpQSGoS5hU5+6mRt9oG/j/TxbFgSAvhYK2GpUoji
         6lGF6Sy1bUbYuVWcAs7KKiyqYKHG9WLdj5D6SPBTidxDTK3g14ad6JRuaKx3ejv1caK/
         4Rnh7q774opWoQ/z6S82kTh65AUm+l3b9Waq9cQlSSFTGktwEzPNtukxn8mkKVR0DAAf
         8x0gLkSaZwjJh29bLC74TYAwlBpUlGqUXH5crLotpxVmPEjtlRl4sqC3y+vFk/EMGywS
         ZOBw==
X-Gm-Message-State: ACgBeo2JKTxQwSs/7O2WSz0ZdwFyiHS6uuLjfhCEP72eeQnpuQi9V3wL
        TgKGAeyNQcA+NPeNl+tXTOezZd+S1F6vjOqusgJj8i7YGb5DStQWk/Zhpjbm4k1m8ITrdRBeUrS
        izdxsZpzwTuGPKtfp/Gyt
X-Received: by 2002:a17:902:b697:b0:172:65f9:d681 with SMTP id c23-20020a170902b69700b0017265f9d681mr18184747pls.137.1661140858643;
        Sun, 21 Aug 2022 21:00:58 -0700 (PDT)
X-Google-Smtp-Source: AA6agR56XsCJxhYfrqqudJBoKUoZ+ZJoanVEi+UGapCseoCGveY2D2CSCSCEIWhxb+W4d1Ga7XlW+g==
X-Received: by 2002:a17:902:b697:b0:172:65f9:d681 with SMTP id c23-20020a170902b69700b0017265f9d681mr18184724pls.137.1661140858311;
        Sun, 21 Aug 2022 21:00:58 -0700 (PDT)
Received: from pc-zest.atmarktech (35.112.198.104.bc.googleusercontent.com. [104.198.112.35])
        by smtp.gmail.com with ESMTPSA id c9-20020a170902d48900b0016db43e5212sm7246195plg.175.2022.08.21.21.00.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Aug 2022 21:00:57 -0700 (PDT)
Received: from martinet by pc-zest.atmarktech with local (Exim 4.96)
        (envelope-from <martinet@pc-zest>)
        id 1oPycS-008hCz-1u;
        Mon, 22 Aug 2022 13:00:56 +0900
Date:   Mon, 22 Aug 2022 13:00:46 +0900
From:   Dominique Martinet <dominique.martinet@atmark-techno.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sean V Kelley <sean.v.kelley@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-pci@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
        Hinko Kocevar <hinko.kocevar@ess.eu>,
        Dan Williams <dan.j.williams@intel.com>,
        "Kuppuswamy, Sathyanarayanan" <sathyanarayanan.kuppuswamy@intel.com>
Subject: Re: [PATCH 5.10 480/545] PCI/ERR: Add pci_walk_bridge() to
 pcie_do_recovery()
Message-ID: <YwL/brvUP1aiwo93@atmark-techno.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220819153850.911668266@linuxfoundation.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg Kroah-Hartman wrote on Fri, Aug 19, 2022 at 05:44:10PM +0200:
> From: Sean V Kelley <sean.v.kelley@intel.com>
> 
> [ Upstream commit 05e9ae19ab83881a0f33025bd1288e41e552a34b ]
> 
> Consolidate subordinate bus checks with pci_walk_bus() into
> pci_walk_bridge() for walking below potentially AER affected bridges.
> 
> Link: https://lore.kernel.org/r/20201121001036.8560-10-sean.v.kelley@intel.com
> Tested-by: Jonathan Cameron <Jonathan.Cameron@huawei.com> # non-native/no RCEC
> Signed-off-by: Sean V Kelley <sean.v.kelley@intel.com>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/pci/pcie/err.c | 30 +++++++++++++++++++++++-------
>  1 file changed, 23 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/pci/pcie/err.c b/drivers/pci/pcie/err.c
> index 931e75f2549d..8b53aecdb43d 100644
> --- a/drivers/pci/pcie/err.c
> +++ b/drivers/pci/pcie/err.c
> [...]
> @@ -165,23 +182,22 @@ pci_ers_result_t pcie_do_recovery(struct pci_dev *dev,
>  	else
>  		bridge = pci_upstream_bridge(dev);
>  
> -	bus = bridge->subordinate;
>  	pci_dbg(bridge, "broadcast error_detected message\n");
>  	if (state == pci_channel_io_frozen) {
> -		pci_walk_bus(bus, report_frozen_detected, &status);
> +		pci_walk_bridge(bridge, report_frozen_detected, &status);
>  		status = reset_subordinates(bridge);
>  		if (status != PCI_ERS_RESULT_RECOVERED) {
>  			pci_warn(bridge, "subordinate device reset failed\n");
>  			goto failed;
>  		}

A local conflict merging this made me notice a later commit:
-----
commit 387c72cdd7fb6bef650fb078d0f6ae9682abf631
Author: Keith Busch <kbusch@kernel.org>
Date:   Mon Jan 4 15:02:58 2021 -0800

PCI/ERR: Retain status from error notification

Overwriting the frozen detected status with the result of the link reset
loses the NEED_RESET result that drivers are depending on for error
handling to report the .slot_reset() callback. Retain this status so
that subsequent error handling has the correct flow.

Link: https://lore.kernel.org/r/20210104230300.1277180-4-kbusch@kernel.org
Reported-by: Hinko Kocevar <hinko.kocevar@ess.eu>
Tested-by: Hedi Berriche <hedi.berriche@hpe.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Sean V Kelley <sean.v.kelley@intel.com>
Acked-by: Hedi Berriche <hedi.berriche@hpe.com>

diff --git a/drivers/pci/pcie/err.c b/drivers/pci/pcie/err.c
index a84f0bf4c1e2..b576aa890c76 100644
--- a/drivers/pci/pcie/err.c
+++ b/drivers/pci/pcie/err.c
@@ -198,8 +198,7 @@ pci_ers_result_t pcie_do_recovery(struct pci_dev *dev,
 	pci_dbg(bridge, "broadcast error_detected message\n");
 	if (state == pci_channel_io_frozen) {
 		pci_walk_bridge(bridge, report_frozen_detected, &status);
-		status = reset_subordinates(bridge);
-		if (status != PCI_ERS_RESULT_RECOVERED) {
+		if (reset_subordinates(bridge) != PCI_ERS_RESULT_RECOVERED) {
 			pci_warn(bridge, "subordinate device reset failed\n");
 			goto failed;
 		}
-----

Since this (commit I reply to) has been picked up, I think it'd make
sense to also include this (commit I just listed) in a later 5.10 tag.
It cherry-picks without error but would you like me to resend?
(I have added in Cc all involved people to this mail)

Digging through the mails the patch came with seem to imply approval for
stable merges; but it didn't make sense until pci_walk_bridge() had been
added just now. Now it's here we probably want both:
https://lore.kernel.org/all/d9ee4151-b28d-a52a-b5be-190a75e0e49b@intel.com/


(I noticed because the NXP kernel we are provided includes a different
"fix" for what I believe to be the same issue, previously discussed here:
https://lore.kernel.org/linux-pci/12115.1588207324@famine/

I haven't actually encountered any of the problems discribed, so this is
purely theorical for me; it just looks a bit weird.)


Thanks,
--
Dominique
