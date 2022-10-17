Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD5E660064E
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 07:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbiJQFaf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 01:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbiJQFad (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 01:30:33 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0337447B8E;
        Sun, 16 Oct 2022 22:30:31 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id t12-20020a17090a3b4c00b0020b04251529so9951590pjf.5;
        Sun, 16 Oct 2022 22:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=JRRV+BVnZSRzFh23m9ZCERUTYJbzBZ4kBt9Yb5nHkGQ=;
        b=aFndi2mIhdZkE4m6cZPPdm89z0CtfyCl/DJKoR1uBHdpOWdqUcEgD1ETr10JW4oy0D
         ksZJfpKquRnT6YQOjS8GOf3iTKNAlcbbw5jrBTbADNBfNCeYdRDKfkEbNxxk8gLLxikz
         8FMLUKjz8NOXk06NSTCutG8CGH1VRQmkopOZcBhMG2tnCIwv8GRpKcs7E224pVlBsynC
         MjTI4fPHg5DHxjCdvAmNP2Q45bonGJh245nYeWCZMjOBSU9UMuWey4DmiG3Ko2t9aJzu
         ocBjWJtcm7+E92qAsdd9umVR7S/Z7D5QfQuwiH+rA5BF5ZHPwXssP9tJAIzxDfu6wq7z
         CEnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JRRV+BVnZSRzFh23m9ZCERUTYJbzBZ4kBt9Yb5nHkGQ=;
        b=OOXdAfTT2zl2ctkVNacSwIFUZa6O4qMOBCo+HhqaGmhSMAMllOikQdZrnNbohLel3h
         X3jZDA+VYi/lkOVCvVnVyfLfQoXK5Vp3geM6a4s4nTI4R1QoJGzyBXDMvs0xjJh9UyGC
         6FX+8OEbjFA2lK16e+DH9jIaKtqtF2jcP7SkUPqGrH11aMdoCxInYIQwQ504xUipg/qe
         t9M4it0S8d82lhYNhpiaLdxuJYtIexbWctbkJmHFSl7/jVED3KKifkJj9nzPLpr2Kv7Q
         pzHjrkK7xRTFvWiRnruzLM5oSARrOHbCzEQ7ypBIGliGJhl8wM0mmLfs/Ahe08NGpAg2
         C4dQ==
X-Gm-Message-State: ACrzQf3ZI0pxWMP1VLRyX10ONk+u4H+ibpRWTNOEM3hcXQEkAcPl7H43
        OA7cBWl41Luj7ii6Z179JUA=
X-Google-Smtp-Source: AMsMyM764BZ4BA2I/rZP40tJ8l9JHd2XlyxM0DKTGuRYfO55wwsPgHeq46VJXIRv79rJra2KZPSNmw==
X-Received: by 2002:a17:90b:4b88:b0:20d:2935:7053 with SMTP id lr8-20020a17090b4b8800b0020d29357053mr11660718pjb.153.1665984630198;
        Sun, 16 Oct 2022 22:30:30 -0700 (PDT)
Received: from localhost.localdomain ([45.124.203.18])
        by smtp.gmail.com with ESMTPSA id h15-20020a170902680f00b001728d7c831asm5596122plk.142.2022.10.16.22.30.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Oct 2022 22:30:29 -0700 (PDT)
Sender: "joel.stan@gmail.com" <joel.stan@gmail.com>
From:   Joel Stanley <joel@jms.id.au>
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc:     Andrew Jeffery <andrew@aj.id.au>, linux-usb@vger.kernel.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Zev Weiss <zev@bewilderbeest.net>,
        Jae Hyun Yoo <quic_jaehyoo@quicinc.com>,
        stable@vger.kernel.org
Subject: [PATCH] usb: gadget: aspeed: Fix probe regression
Date:   Mon, 17 Oct 2022 16:00:06 +1030
Message-Id: <20221017053006.358520-1-joel@jms.id.au>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since commit fc274c1e9973 ("USB: gadget: Add a new bus for gadgets"),
the gadget devices are proper driver core devices, which caused each
device to request pinmux settings:

 aspeed_vhub 1e6a0000.usb-vhub: Initialized virtual hub in USB2 mode
 aspeed-g5-pinctrl 1e6e2080.pinctrl: pin A7 already requested by 1e6a0000.usb-vhub; cannot claim for gadget.0
 aspeed-g5-pinctrl 1e6e2080.pinctrl: pin-232 (gadget.0) status -22
 aspeed-g5-pinctrl 1e6e2080.pinctrl: could not request pin 232 (A7) from group USB2AD  on device aspeed-g5-pinctrl
 g_mass_storage gadget.0: Error applying setting, reverse things back

The vhub driver has already claimed the pins, so prevent the gadgets
from requesting them too by setting the magic of_node_reused flag. This
causes the driver core to skip the mux request.

Reported-by: Zev Weiss <zev@bewilderbeest.net>
Reported-by: Jae Hyun Yoo <quic_jaehyoo@quicinc.com>
Fixes: fc274c1e9973 ("USB: gadget: Add a new bus for gadgets")
Cc: stable@vger.kernel.org
Signed-off-by: Joel Stanley <joel@jms.id.au>
---
 drivers/usb/gadget/udc/aspeed-vhub/dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/udc/aspeed-vhub/dev.c b/drivers/usb/gadget/udc/aspeed-vhub/dev.c
index b0dfca43fbdc..4f3bc27c1c62 100644
--- a/drivers/usb/gadget/udc/aspeed-vhub/dev.c
+++ b/drivers/usb/gadget/udc/aspeed-vhub/dev.c
@@ -591,6 +591,7 @@ int ast_vhub_init_dev(struct ast_vhub *vhub, unsigned int idx)
 		d->gadget.max_speed = USB_SPEED_HIGH;
 	d->gadget.speed = USB_SPEED_UNKNOWN;
 	d->gadget.dev.of_node = vhub->pdev->dev.of_node;
+	d->gadget.dev.of_node_reused = true;
 
 	rc = usb_add_gadget_udc(d->port_dev, &d->gadget);
 	if (rc != 0)
-- 
2.35.1

