Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4E6051F99F
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 12:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbiEIKSM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 9 May 2022 06:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231674AbiEIKSA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 06:18:00 -0400
Received: from mail4.swissbit.com (mail4.swissbit.com [176.95.1.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB8127F13B;
        Mon,  9 May 2022 03:14:00 -0700 (PDT)
Received: from mail4.swissbit.com (localhost [127.0.0.1])
        by DDEI (Postfix) with ESMTP id CFFE712329B;
        Mon,  9 May 2022 12:12:45 +0200 (CEST)
Received: from mail4.swissbit.com (localhost [127.0.0.1])
        by DDEI (Postfix) with ESMTP id BE6B0123087;
        Mon,  9 May 2022 12:12:45 +0200 (CEST)
X-TM-AS-ERS: 10.149.2.84-127.5.254.253
X-TM-AS-SMTP: 1.0 ZXguc3dpc3NiaXQuY29t Y2xvZWhsZUBoeXBlcnN0b25lLmNvbQ==
X-DDEI-TLS-USAGE: Used
Received: from ex.swissbit.com (SBDEEX02.sbitdom.lan [10.149.2.84])
        by mail4.swissbit.com (Postfix) with ESMTPS;
        Mon,  9 May 2022 12:12:45 +0200 (CEST)
Received: from sbdeex02.sbitdom.lan (10.149.2.84) by sbdeex02.sbitdom.lan
 (10.149.2.84) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 9 May 2022
 12:12:45 +0200
Received: from sbdeex02.sbitdom.lan ([fe80::e0eb:ade8:2d90:1f74]) by
 sbdeex02.sbitdom.lan ([fe80::e0eb:ade8:2d90:1f74%8]) with mapi id
 15.02.0986.022; Mon, 9 May 2022 12:12:45 +0200
From:   =?iso-8859-1?Q?Christian_L=F6hle?= <CLoehle@hyperstone.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     Ulf Hansson <ulf.hansson@linaro.org>,
        Ricky WU <ricky_wu@realtek.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] mmc: rtsx: add 74 Clocks in power on flow
Thread-Topic: [PATCH] mmc: rtsx: add 74 Clocks in power on flow
Thread-Index: AQHYJ7nTpeKajlBmYU+vTOb/+dRQe6ypG9+AgG2fl+T//+dBgIAAIfU6
Date:   Mon, 9 May 2022 10:12:45 +0000
Message-ID: <050affc68f7f4861b35a1ab96e228fec@hyperstone.com>
References: <fb7cda69c5c244dfa579229ee2f0da83@realtek.com>
 <CAPDyKFrYWgCbwk6-hNZjtx4mdn7Sx1NJLie+f8wEjS==_HXR5Q@mail.gmail.com>
 <add6c326a5b04525965ffa1e9e96ea41@hyperstone.com>,<YnjjR8pouD4KtHtT@kroah.com>
In-Reply-To: <YnjjR8pouD4KtHtT@kroah.com>
Accept-Language: en-US, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.153.3.143]
Content-Type: text/plain;
        charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-TMASE-Version: DDEI-5.1-9.0.1002-26882.007
X-TMASE-Result: 10--2.793000-10.000000
X-TMASE-MatchedRID: 9886Ub8IUanUL3YCMmnG4pTQgFTHgkhZC/ExpXrHizwAVRCE8nexDo1E
        I8AWiw6Ubqm1oygU5ObYkRVj06do/LiVxHiyyevs5mBuXg7cqjd9LQinZ4QefIFD/hZ+jeimI9G
        Y7ey6AisNXwNUB3oA790H8LFZNFG7/nnwJ52QYi/M/gWu/p797j6Gi6QRunof1CN3TYYN8DYd5/
        WEzsCddpTgIiWJPNXFftwZ3X11IV0=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0
X-TMASE-INERTIA: 0-0;;;;
X-TMASE-XGENCLOUD: 79bed6de-9f61-4070-8e16-e1b3ad1b2366-0-0-200-0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>> Can we get 1f311c94aabdb419c28e3147bcc8ab89269f1a7e merged into the stable tree?
>
>Which stable branches do you want this added to?
>
>thanks,
>
>greg k-h

From what I can tell the issue is present since the addition of the driver in ff984e57d36e8
So I would suggest adding them to all? Maybe Ricky and Ulf could comment?

Regards,
Christian=
Hyperstone GmbH | Reichenaustr. 39a  | 78467 Konstanz
Managing Director: Dr. Jan Peter Berns.
Commercial register of local courts: Freiburg HRB381782

