Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4D25B741F
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235801AbiIMPTW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235951AbiIMPSi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:18:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0606D79A41;
        Tue, 13 Sep 2022 07:35:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEF40614CF;
        Tue, 13 Sep 2022 14:34:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1EB1C433D6;
        Tue, 13 Sep 2022 14:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079644;
        bh=wvX/8tER1vYek1vzOBoKyRvWRfxfMD8tTbBrb7D4Zgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wrm/V0EfKX9qPpW1tri+F3NVMia8SuPe/WK9/EfzkZKLdvYfxowermCQfyZcv6wCx
         yQXMN+DqhZPyzZ/v2+gRG5w8zPqRhHEWLV5OyQu+72FUZugVHC+vw3nrQh8ZlFGb/a
         dJzN9WQQcQhixsweEtFoRGoEcIvQLVjilRToXw80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 19/61] USB: serial: cp210x: add Decagon UCA device id
Date:   Tue, 13 Sep 2022 16:07:21 +0200
Message-Id: <20220913140347.478966094@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140346.422813036@linuxfoundation.org>
References: <20220913140346.422813036@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit ceb4038472a4803e7046ed488b03d11551991514 upstream.

Add the device id for Decagon Devices USB Cable Adapter.

Link: https://lore.kernel.org/r/trinity-819f9db2-d3e1-40e9-a669-9c245817c046-1661523546680@msvc-mesg-web108
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/cp210x.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -134,6 +134,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x10C4, 0x83AA) }, /* Mark-10 Digital Force Gauge */
 	{ USB_DEVICE(0x10C4, 0x83D8) }, /* DekTec DTA Plus VHF/UHF Booster/Attenuator */
 	{ USB_DEVICE(0x10C4, 0x8411) }, /* Kyocera GPS Module */
+	{ USB_DEVICE(0x10C4, 0x8414) }, /* Decagon USB Cable Adapter */
 	{ USB_DEVICE(0x10C4, 0x8418) }, /* IRZ Automation Teleport SG-10 GSM/GPRS Modem */
 	{ USB_DEVICE(0x10C4, 0x846E) }, /* BEI USB Sensor Interface (VCP) */
 	{ USB_DEVICE(0x10C4, 0x8470) }, /* Juniper Networks BX Series System Console */


