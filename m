Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21EE06A946C
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 10:49:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbjCCJtH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 04:49:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjCCJtA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 04:49:00 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBBF61027F
        for <stable@vger.kernel.org>; Fri,  3 Mar 2023 01:48:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1677836938; x=1709372938;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=uIoGKTM+botEjFPFMsCu6mxNY93QEUww5QbbHkHHhtI=;
  b=Oo0hwsjsu5vKjoIj2YeF9muynwZUn2Ag0WpI6LGEJDYx9pmX+xSql7oc
   maUBxJiAVOWUCmMab3A8mhlldPpQgaid7e6I1Pmh1MZlma0avxMqcPAts
   OVhAB5LEbTvUQHzQhLvH5vEcQW2LHQ5DEF93yKpO0fqFy/MFo5JQdgF00
   jMp+r6gwpM9k8XwBLXCxs15b6XA8c4gQMkgDQrTI5EM1juqSpNMICBRTT
   ZZB77rqOeKxMH2cxPlBcijrfE3p7JfcaPBmAOPflFndargW9DyNjHP2EP
   xSEqNbJosS6vgBZnR4v2FBE3Fc6E6gq4JVQ+4EZmGy0HEFr4MnW+B1gPf
   A==;
X-IronPort-AV: E=Sophos;i="5.98,230,1673884800"; 
   d="scan'208";a="329046054"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 03 Mar 2023 17:48:56 +0800
IronPort-SDR: 3C+bEkJAcVDE7f8wwC3KcpWAGIOwDcfuQo+PW6JC9WHufRa9awcczQ0CxT44gKgr63U2LYU7KP
 N4VMarn1RsRm/p6Cq0XPimcmpnSz9rpzxp8LCrhbany0kC20tVL72XCaAfeRXsP0f3OI1vsJff
 fydj3yPoNBEMrvbaewj0ONgEhdPPTt+p7TZeqYLPWs0/96ndIhwubkrxzP19r3KQd4/QqjjLD7
 fVTedHHUEiKbDY5ycykGTHDjSdm9L6GHnbBeBP/rXAd4iEB842RlQgZso5dBb6tT9lPGDzrz54
 mBw=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Mar 2023 00:59:59 -0800
IronPort-SDR: 4nA7nXY7JnRtqBYjAJf/JE/IoyYE8BO3jcGMrGwtGQLnUP04we9yYtXQOhLM49hrE1+R2/EuWY
 p8rtkpoF7jXQgUPlq2eFRMlWg4BS+dWFVDiG4pS2i9Qpq9Bhoa2gZ1HUZIi9JClnHnxRxYHO8T
 CCAOpvBBYYkDJcbsEA7mJZvdE5cahmjewzw+KXkqS8XwHIKFidDiZ/9UQ36QbFdNfww9SwUOmV
 rqsSpt3El1kuNI3/C4OauQaliYNF+n3mtYRA8477RVP3W/k+pPp2BvCU/B3RmCfio/ell/kwSD
 aQs=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Mar 2023 01:48:57 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4PSjpw11XGz1Rwtl
        for <stable@vger.kernel.org>; Fri,  3 Mar 2023 01:48:56 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1677836935; x=1680428936; bh=uIoGKTM+botEjFPFMsCu6mxNY93QEUww5Qb
        bHkHHhtI=; b=qupa7oQRg9BOLX4qEG+sh+IsrkELz8Lg8XNpWttJmF+iGgYJbIz
        9ARw8CzOip9WdFO2Xx52cEIQBRUdXF39Om+RmOKO+az5wK0f+zmLKf9HK6Q+w4tG
        qu2aBAOwmVY/W4D3+qIAlzhN88z22PtfRsFdUTvvKX6KgXbfCn8WWUC6rlj+nA5R
        Dbi971vktYK6dO56VzfwcUKutLq2wgsYLRqTk8Je9BSzK98nkvlCcX/xMjC95Zit
        bVCzXVAmAwXlfRPDS8zabb4hwBJU51FpVAH7FsOb6wAV1/YWpbEJJYeyoMcZijem
        dN6TKgI2aGMJ0DaynHZzqgYLNIWKmIbZzHQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id hgk1X-sUzWnf for <stable@vger.kernel.org>;
        Fri,  3 Mar 2023 01:48:55 -0800 (PST)
Received: from [10.225.163.47] (unknown [10.225.163.47])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4PSjpt1k4Yz1RvLy;
        Fri,  3 Mar 2023 01:48:54 -0800 (PST)
Message-ID: <af6a355b-3ac2-a610-379a-167e87145368@opensource.wdc.com>
Date:   Fri, 3 Mar 2023 18:48:52 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [regression] Bug 217114 - Tiger Lake SATA Controller not
 operating correctly [bisected]
Content-Language: en-US
To:     Linux regressions mailing list <regressions@lists.linux.dev>,
        Simon Gaiser <simon@invisiblethingslab.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        emmi@emmixis.net, schwagsucks@gmail.com,
        "open list:LIBATA SUBSYSTEM (Serial and Parallel ATA drivers)" 
        <linux-ide@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <ad02467d-d623-5933-67e0-09925c185568@leemhuis.info>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <ad02467d-d623-5933-67e0-09925c185568@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/3/23 16:10, Linux regression tracking (Thorsten Leemhuis) wrote:
> Hi, this is your Linux kernel regression tracker.
> 
> I noticed a regression report in bugzilla.kernel.org that apparently
> affects 6.2 and later as well as 6.1.13 and later, as it was already
> backported there.
> 
> As many (most?) kernel developer don't keep an eye on bugzilla, I
> decided to forward the report by mail. Quoting from
> https://bugzilla.kernel.org/show_bug.cgi?id=217114 :
> 
>>  emmi@emmixis.net 2023-03-02 11:25:00 UTC
>>
>> As per kernel problem found in https://bbs.archlinux.org/viewtopic.php?id=283906 ,
>>
>> Commit 104ff59af73aba524e57ae0fef70121643ff270e
> 
> [FWIW: That's "ata: ahci: Add Tiger Lake UP{3,4} AHCI controller" from
> Simon Gaiser]

I sent a revert with cc: stable.

Simon,

Let's work on finding a better solution for enabling LPM for that adapter
without causing regressions. I will need your help for testing as I do not have
this hardware.

-- 
Damien Le Moal
Western Digital Research

