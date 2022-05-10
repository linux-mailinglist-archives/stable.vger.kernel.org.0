Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9D9521640
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242178AbiEJNG1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 10 May 2022 09:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242170AbiEJNGY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:06:24 -0400
Received: from mail3.swissbit.com (mail3.swissbit.com [176.95.1.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D992618FC
        for <stable@vger.kernel.org>; Tue, 10 May 2022 06:02:27 -0700 (PDT)
Received: from mail3.swissbit.com (localhost [127.0.0.1])
        by DDEI (Postfix) with ESMTP id 07EBB462E08;
        Tue, 10 May 2022 15:02:25 +0200 (CEST)
Received: from mail3.swissbit.com (localhost [127.0.0.1])
        by DDEI (Postfix) with ESMTP id EBE91462E02;
        Tue, 10 May 2022 15:02:24 +0200 (CEST)
X-TM-AS-ERS: 10.149.2.84-127.5.254.253
X-TM-AS-SMTP: 1.0 ZXguc3dpc3NiaXQuY29t Y2xvZWhsZUBoeXBlcnN0b25lLmNvbQ==
X-DDEI-TLS-USAGE: Used
Received: from ex.swissbit.com (SBDEEX02.sbitdom.lan [10.149.2.84])
        by mail3.swissbit.com (Postfix) with ESMTPS;
        Tue, 10 May 2022 15:02:24 +0200 (CEST)
Received: from sbdeex02.sbitdom.lan (10.149.2.84) by sbdeex02.sbitdom.lan
 (10.149.2.84) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 10 May
 2022 15:02:24 +0200
Received: from sbdeex02.sbitdom.lan ([fe80::e0eb:ade8:2d90:1f74]) by
 sbdeex02.sbitdom.lan ([fe80::e0eb:ade8:2d90:1f74%8]) with mapi id
 15.02.0986.022; Tue, 10 May 2022 15:02:24 +0200
From:   =?iso-8859-1?Q?Christian_L=F6hle?= <CLoehle@hyperstone.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Ricky WU <ricky_wu@realtek.com>
Subject: Re: [PATCH] mmc: rtsx: add 74 Clocks in power on flow
Thread-Topic: [PATCH] mmc: rtsx: add 74 Clocks in power on flow
Thread-Index: AQHYZG2+SMidSc50iEW8Aq37+2MmcK0YEwBK
Date:   Tue, 10 May 2022 13:02:24 +0000
Message-ID: <939808fa84904f72a54d427ca4592486@hyperstone.com>
References: <d569393619d54d8789a223a9db6d455e@hyperstone.com>
In-Reply-To: <d569393619d54d8789a223a9db6d455e@hyperstone.com>
Accept-Language: en-US, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.153.3.143]
Content-Type: text/plain;
        charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-TMASE-Version: DDEI-5.1-9.0.1002-26884.007
X-TMASE-Result: 10--6.828200-10.000000
X-TMASE-MatchedRID: zdfKSpJbRLjUL3YCMmnG4pTQgFTHgkhZC/ExpXrHizyiC7BD4niBmM1y
        AQzkcdXP1FxTk7orjNY78hi5kBbwX01MyZuVGIo08IK7yRWPRNE0000sN/tt6RBLhUIMOS2ntMt
        w2twfYavi8zVgXoAltkR/QHjUqtCG7tpwfSrcmEDZs3HUcS/scCq2rl3dzGQ1nzEbdasY8vQ1I4
        XRLnq2Vh8+Cx6Dnwmz+uakZn8QCSCD9X9+g9CG9g==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0
X-TMASE-INERTIA: 0-0;;;;
X-TMASE-XGENCLOUD: d569237f-5f67-4ecb-ab3c-a6e66a5b7ca7-0-0-200-0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>commit 1f311c94aabd ("mmc: rtsx: add 74 Clocks in power on flow") upstream.
>backport note: removed unavailable power_delay_ms 5ms as 10ms is fine, too.
>
>SD spec definition:
>"Host provides at least 74 Clocks before issuing first command"
>After 1ms for the voltage stable then start issuing the Clock signals
>
>if POWER STATE is
>MMC_POWER_OFF to MMC_POWER_UP to issue Clock signal to card
>MMC_POWER_UP to MMC_POWER_ON to stop issuing signal to card
>
>Signed-off-by: Ricky Wu <ricky_wu@realtek.com>
>Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
>Signed-off-by: Christian Loehle <cloehle@hyperstone.com>
>---

Now for 4.9.y and 4.14.y, my bad and thanks a lot.

Regards,
Christian=
Hyperstone GmbH | Reichenaustr. 39a  | 78467 Konstanz
Managing Director: Dr. Jan Peter Berns.
Commercial register of local courts: Freiburg HRB381782

