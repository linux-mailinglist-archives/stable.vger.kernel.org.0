Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0234BB797
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 12:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbiBRLFw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 18 Feb 2022 06:05:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234228AbiBRLFl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 06:05:41 -0500
Received: from mail4.swissbit.com (mail4.swissbit.com [176.95.1.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E761294FC1
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 03:05:24 -0800 (PST)
Received: from mail4.swissbit.com (localhost [127.0.0.1])
        by DDEI (Postfix) with ESMTP id BC372122D94;
        Fri, 18 Feb 2022 12:05:22 +0100 (CET)
Received: from mail4.swissbit.com (localhost [127.0.0.1])
        by DDEI (Postfix) with ESMTP id ACDD0122DF2;
        Fri, 18 Feb 2022 12:05:22 +0100 (CET)
X-TM-AS-ERS: 10.149.2.84-127.5.254.253
X-TM-AS-SMTP: 1.0 ZXguc3dpc3NiaXQuY29t Y2xvZWhsZUBoeXBlcnN0b25lLmNvbQ==
X-DDEI-TLS-USAGE: Used
Received: from ex.swissbit.com (SBDEEX02.sbitdom.lan [10.149.2.84])
        by mail4.swissbit.com (Postfix) with ESMTPS;
        Fri, 18 Feb 2022 12:05:22 +0100 (CET)
Received: from sbdeex02.sbitdom.lan (10.149.2.84) by sbdeex02.sbitdom.lan
 (10.149.2.84) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15; Fri, 18 Feb
 2022 12:05:22 +0100
Received: from sbdeex02.sbitdom.lan ([fe80::e0eb:ade8:2d90:1f74]) by
 sbdeex02.sbitdom.lan ([fe80::e0eb:ade8:2d90:1f74%8]) with mapi id
 15.02.0986.015; Fri, 18 Feb 2022 12:05:22 +0100
From:   =?iso-8859-1?Q?Christian_L=F6hle?= <CLoehle@hyperstone.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] mmc: block: fix read single on recovery logic
Thread-Topic: [PATCH] mmc: block: fix read single on recovery logic
Thread-Index: AQHYJK0F7THTFUoG1UqyVjHZgEpMkKyZC9uAgAARJTX///bZgIAAETi0
Date:   Fri, 18 Feb 2022 11:05:21 +0000
Message-ID: <3da3bebe0cdf40cc83bcf0fa37960c7c@hyperstone.com>
References: <16451252511822@kroah.com>
 <abf69d264c7845bab8433ccae7ed0e0f@hyperstone.com>
 <Yg92AW1onRd47G9z@kroah.com>
 <03b3664476424756867d9dd76f984002@hyperstone.com>,<916c2090-5b39-e9e8-190e-d0f8a77adfa3@intel.com>
In-Reply-To: <916c2090-5b39-e9e8-190e-d0f8a77adfa3@intel.com>
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
X-TMASE-Result: 10--20.786300-10.000000
X-TMASE-MatchedRID: TMsvcu6/L5fUL3YCMmnG4vrNPkGWAHDfGbJMFqqIm9xXGTbsQqHbkpZh
        jmb07zEXsY+8nR90dzsknOGoeIQzlgI2KcLRn3QR3nHtGkYl/Vr0swHSFcVJ6OZYcdJgScjx0zl
        xXfg8EXlG2tqztWvruuR+MiSV/ez6ZySn2p9T6YbUGdB8pbpdMvlSepWcgdLPx8BJ7uScK219zn
        8GcDl7ffryp24JbYmck3+SH70fHPb1zRJIGToPzhfqkKQlk1I5kYC3rjkUXRIFX02iZqzpiJ6ba
        /D5x6cp4vM1YF6AJbYihmDIoNV/MwtuKBGekqUpPjKoPgsq7cA=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0
X-TMASE-INERTIA: 0-0;;;;
X-TMASE-XGENCLOUD: 38de3133-1930-461d-aa52-34a225e3c4be-0-0-200-0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

You're right, I did not get an email about 5.4, maybe it was caught up somewhere.
Greg, can you apply this to 5.4, too?






From: Adrian Hunter <adrian.hunter@intel.com>
Sent: Friday, February 18, 2022 12:02 PM
To: Christian Löhle
Subject: Re: [PATCH] mmc: block: fix read single on recovery logic
    
On 18/02/2022 12:36, Christian Löhle wrote:
> This is the backport for 4.19, it applied for more recent branches and is not applicable to 4.14.

Was 5.4 done?  There was a "failed to apply email for that also"


> 
> 
> 
> From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> Sent: Friday, February 18, 2022 11:33 AM
> To: Christian Löhle
> Cc: stable@vger.kernel.org; Ulf Hansson; Adrian Hunter
> Subject: Re: [PATCH] mmc: block: fix read single on recovery logic
>     
> On Fri, Feb 18, 2022 at 09:50:54AM +0000, Christian Löhle wrote:
>> commit 54309fde1a352ad2674ebba004a79f7d20b9f037 upstream.
>>
>> On reads with MMC_READ_MULTIPLE_BLOCK that fail,
>> the recovery handler will use MMC_READ_SINGLE_BLOCK for
>> each of the blocks, up to MMC_READ_SINGLE_RETRIES times each.
>> The logic for this is fixed to never report unsuccessful reads
>> as success to the block layer.
>>
>> On command error with retries remaining, blk_update_request was
>> called with whatever value error was set last to.
>> In case it was last set to BLK_STS_OK (default), the read will be
>> reported as success, even though there was no data read from the device.
>> This could happen on a CRC mismatch for the response,
>> a card rejecting the command (e.g. again due to a CRC mismatch).
>> In case it was last set to BLK_STS_IOERR, the error is reported correctly,
>> but no retries will be attempted.
>>
>> Fixes: 81196976ed946c ("mmc: block: Add blk-mq support")
>>
>> Signed-off-by: Christian Loehle <cloehle@hyperstone.com>
>> ---
>>   drivers/mmc/core/block.c | 28 ++++++++++++++--------------
>>   1 file changed, 14 insertions(+), 14 deletions(-)
> 
> What stable branch(s) is this backport for?
> 
> thanks,
> 
> greg k-h
>     =
> Hyperstone GmbH | Reichenaustr. 39a  | 78467 Konstanz
> Managing Director: Dr. Jan Peter Berns.
> Commercial register of local courts: Freiburg HRB381782
> 

    =
Hyperstone GmbH | Reichenaustr. 39a  | 78467 Konstanz
Managing Director: Dr. Jan Peter Berns.
Commercial register of local courts: Freiburg HRB381782

