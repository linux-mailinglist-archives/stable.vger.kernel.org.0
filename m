Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 794946584F4
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 18:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235361AbiL1REO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 12:04:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235365AbiL1RDs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 12:03:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B0AA1CFF4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:58:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6F43B8171E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:58:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48505C433EF;
        Wed, 28 Dec 2022 16:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246687;
        bh=KO9p54nhjzygjNgFozlKGwdkzlpcixkmnImu6PElxDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A1B7qVRAIWoVVwxn8CvPWZMAzz1EBpbpoV/t597IcM1jBPAdtCHBjWbhlV/a7/PRM
         kUGgR8ctCNp5+YpZ5MyAKdm2Jh+6nEURfEmgnr57Znr69Qjh13AJioklnvzqoebZxG
         BAbqeuLkxJ/4T0+hppPQEC6OcnU3IxLeDDDlq18M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, wangdicheng <wangdicheng@kylinos.cn>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 1099/1146] ALSA: usb-audio: add the quirk for KT0206 device
Date:   Wed, 28 Dec 2022 15:43:58 +0100
Message-Id: <20221228144400.017586259@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: wangdicheng <wangdicheng@kylinos.cn>

commit 696b66ac26ef953aed5783ef26a252ec8f207013 upstream.

Add relevant information to the quirks-table.h file.
The test passes and the sound source file plays normally.

Signed-off-by: wangdicheng <wangdicheng@kylinos.cn>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/SG2PR02MB587849631CB96809CF90DBED8A1A9@SG2PR02MB5878.apcprd02.prod.outlook.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks-table.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -76,6 +76,8 @@
 { USB_DEVICE_VENDOR_SPEC(0x041e, 0x3f0a) },
 /* E-Mu 0204 USB */
 { USB_DEVICE_VENDOR_SPEC(0x041e, 0x3f19) },
+/* Ktmicro Usb_audio device */
+{ USB_DEVICE_VENDOR_SPEC(0x31b2, 0x0011) },
 
 /*
  * Creative Technology, Ltd Live! Cam Sync HD [VF0770]


