Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8658B4BB6FB
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 11:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbiBRKhH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 18 Feb 2022 05:37:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiBRKhH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 05:37:07 -0500
Received: from mail4.swissbit.com (mail4.swissbit.com [176.95.1.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D82F636A
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 02:36:50 -0800 (PST)
Received: from mail4.swissbit.com (localhost [127.0.0.1])
        by DDEI (Postfix) with ESMTP id 435E3122DB1;
        Fri, 18 Feb 2022 11:36:48 +0100 (CET)
Received: from mail4.swissbit.com (localhost [127.0.0.1])
        by DDEI (Postfix) with ESMTP id 32195122D56;
        Fri, 18 Feb 2022 11:36:48 +0100 (CET)
X-TM-AS-ERS: 10.149.2.84-127.5.254.253
X-TM-AS-SMTP: 1.0 ZXguc3dpc3NiaXQuY29t Y2xvZWhsZUBoeXBlcnN0b25lLmNvbQ==
X-DDEI-TLS-USAGE: Used
Received: from ex.swissbit.com (SBDEEX02.sbitdom.lan [10.149.2.84])
        by mail4.swissbit.com (Postfix) with ESMTPS;
        Fri, 18 Feb 2022 11:36:48 +0100 (CET)
Received: from sbdeex02.sbitdom.lan (10.149.2.84) by sbdeex02.sbitdom.lan
 (10.149.2.84) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15; Fri, 18 Feb
 2022 11:36:47 +0100
Received: from sbdeex02.sbitdom.lan ([fe80::e0eb:ade8:2d90:1f74]) by
 sbdeex02.sbitdom.lan ([fe80::e0eb:ade8:2d90:1f74%8]) with mapi id
 15.02.0986.015; Fri, 18 Feb 2022 11:36:47 +0100
From:   =?iso-8859-1?Q?Christian_L=F6hle?= <CLoehle@hyperstone.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Ulf Hansson <ulf.hansson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH] mmc: block: fix read single on recovery logic
Thread-Topic: [PATCH] mmc: block: fix read single on recovery logic
Thread-Index: AQHYJK0F7THTFUoG1UqyVjHZgEpMkKyZC9uAgAARJTU=
Date:   Fri, 18 Feb 2022 10:36:47 +0000
Message-ID: <03b3664476424756867d9dd76f984002@hyperstone.com>
References: <16451252511822@kroah.com>
 <abf69d264c7845bab8433ccae7ed0e0f@hyperstone.com>,<Yg92AW1onRd47G9z@kroah.com>
In-Reply-To: <Yg92AW1onRd47G9z@kroah.com>
Accept-Language: en-US, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.242.2.66]
Content-Type: text/plain;
        charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-TMASE-Version: DDEI-5.1-8.6.1018-26722.007
X-TMASE-Result: 10--18.286300-10.000000
X-TMASE-MatchedRID: Y6GLOewO+JjUL3YCMmnG4qzGfgakLdjaGbJMFqqIm9xXGTbsQqHbkpZh
        jmb07zEXsY+8nR90dzsknOGoeIQzlh/Qfe1gmZY9DstQFfLVA/ClLADMASK8xy2is8s1ivBkBk0
        sRysFrTDPQfWquCqW3djW4z+YWqqJ9xWd9ZideuhNsVUJg8FOpk+crEA4+nhZnhD4vcFcha4aT/
        e9Mxzf2PRhdDOk28T8+rMhH9g4h++h+znN1Lt6wN0KiTeJteVBfS0Ip2eEHny4wTpaFKqo4dRnE
        QCUU+jzjoczmuoPCq0nmzRvsQXrCr+44iuSrD8nXIHVMieLY8gUJI8by46oaiYtX7th1Qun
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0
X-TMASE-INERTIA: 0-0;;;;
X-TMASE-XGENCLOUD: c041232f-d5e6-4f23-8acc-efb0a165d9a6-0-0-200-0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the backport for 4.19, it applied for more recent branches and is not applicable to 4.14.



From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
Sent: Friday, February 18, 2022 11:33 AM
To: Christian Löhle
Cc: stable@vger.kernel.org; Ulf Hansson; Adrian Hunter
Subject: Re: [PATCH] mmc: block: fix read single on recovery logic
    
On Fri, Feb 18, 2022 at 09:50:54AM +0000, Christian Löhle wrote:
> commit 54309fde1a352ad2674ebba004a79f7d20b9f037 upstream.
> 
> On reads with MMC_READ_MULTIPLE_BLOCK that fail,
> the recovery handler will use MMC_READ_SINGLE_BLOCK for
> each of the blocks, up to MMC_READ_SINGLE_RETRIES times each.
> The logic for this is fixed to never report unsuccessful reads
> as success to the block layer.
> 
> On command error with retries remaining, blk_update_request was
> called with whatever value error was set last to.
> In case it was last set to BLK_STS_OK (default), the read will be
> reported as success, even though there was no data read from the device.
> This could happen on a CRC mismatch for the response,
> a card rejecting the command (e.g. again due to a CRC mismatch).
> In case it was last set to BLK_STS_IOERR, the error is reported correctly,
> but no retries will be attempted.
> 
> Fixes: 81196976ed946c ("mmc: block: Add blk-mq support")
> 
> Signed-off-by: Christian Loehle <cloehle@hyperstone.com>
> ---
>  drivers/mmc/core/block.c | 28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)

What stable branch(s) is this backport for?

thanks,

greg k-h
    =
Hyperstone GmbH | Reichenaustr. 39a  | 78467 Konstanz
Managing Director: Dr. Jan Peter Berns.
Commercial register of local courts: Freiburg HRB381782

