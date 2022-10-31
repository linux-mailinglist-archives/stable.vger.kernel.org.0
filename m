Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 379CE6137E7
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 14:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbiJaN0L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 09:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbiJaN0J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 09:26:09 -0400
X-Greylist: delayed 822 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 31 Oct 2022 06:26:04 PDT
Received: from mx1.mythic-beasts.com (mx1.mythic-beasts.com [IPv6:2a00:1098:0:86:1000:0:2:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E15B51005F
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 06:26:04 -0700 (PDT)
Received: from [217.155.36.16] (port=44302 helo=[192.168.1.22])
        by mailhub-cam-d.mythic-beasts.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <john-linux@pelago.org.uk>)
        id 1opUaW-001RBB-4H
        for stable@vger.kernel.org; Mon, 31 Oct 2022 13:12:24 +0000
Message-ID: <6239ff94-c587-b2ac-9b8b-cdf5e65d0157@pelago.org.uk>
Date:   Mon, 31 Oct 2022 13:12:21 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Content-Language: en-US
To:     stable@vger.kernel.org
From:   John Veness <john-linux@pelago.org.uk>
Subject: ALSA: usb-audio: Add quirks for MacroSilicon MS2100/MS2106 devices
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-BlackCat-Spam-Score: 0
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_05,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

Please can you consider my "ALSA: usb-audio: Add quirks for MacroSilicon 
MS2100/MS2106 devices" patch, with upstream commit ID 
6e2c9105e0b743c92a157389d40f00b81bdd09fe for inclusion in all -stable 
kernels. Apart from the device IDs, it is a copy of the similar existing 
patch for MS2109 devices, which is already present in -stable kernels.

John Veness

