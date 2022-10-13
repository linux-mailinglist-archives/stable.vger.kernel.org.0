Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B56D5FE062
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbiJMSIW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231458AbiJMSHn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:07:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0954160EFB;
        Thu, 13 Oct 2022 11:05:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 156D3619C6;
        Thu, 13 Oct 2022 18:01:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 208B8C433C1;
        Thu, 13 Oct 2022 18:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665684064;
        bh=xm4dJk+a4xXbTCFuEdRLmVRDxS983Q+yBTlQeFFvqXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Dhm3jIGZFO2heety8nCOH0YaArjcpWPSHRGoou3/3X5zvWtePHvflW0iknGhlhGr
         nQI3Y3Hjnvo/yp30BNv45XJsPN6fMDunP+x2vKqP0NSEhvfIAYtPqd0IMd6QwhnMG/
         G9q65xyQ6SsVhsuFeJnv0UzEC441oz3/dXNMktfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank Wunderlich <frank-w@public-files.de>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.0 14/34] USB: serial: qcserial: add new usb-id for Dell branded EM7455
Date:   Thu, 13 Oct 2022 19:52:52 +0200
Message-Id: <20221013175146.891278087@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013175146.507746257@linuxfoundation.org>
References: <20221013175146.507746257@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank Wunderlich <frank-w@public-files.de>

commit eee48781ea199e32c1d0c4732641c494833788ca upstream.

Add support for Dell 5811e (EM7455) with USB-id 0x413c:0x81c2.

Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/qcserial.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -177,6 +177,7 @@ static const struct usb_device_id id_tab
 	{DEVICE_SWI(0x413c, 0x81b3)},	/* Dell Wireless 5809e Gobi(TM) 4G LTE Mobile Broadband Card (rev3) */
 	{DEVICE_SWI(0x413c, 0x81b5)},	/* Dell Wireless 5811e QDL */
 	{DEVICE_SWI(0x413c, 0x81b6)},	/* Dell Wireless 5811e QDL */
+	{DEVICE_SWI(0x413c, 0x81c2)},	/* Dell Wireless 5811e */
 	{DEVICE_SWI(0x413c, 0x81cb)},	/* Dell Wireless 5816e QDL */
 	{DEVICE_SWI(0x413c, 0x81cc)},	/* Dell Wireless 5816e */
 	{DEVICE_SWI(0x413c, 0x81cf)},   /* Dell Wireless 5819 */


