Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19F836A9230
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 09:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjCCIMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 03:12:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjCCIMS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 03:12:18 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3B318B24
        for <stable@vger.kernel.org>; Fri,  3 Mar 2023 00:12:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1677831133; x=1709367133;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4WOsAfpITDveUkLlKm0C8SxMPp9Wv2/hWv9cOYmED8c=;
  b=GmPZwpXVNYarvzWSZYQv0rheHcJVvGjUIG29qEHRxsH80aRIhlQkLLCU
   ySMffChMJtxwkmJgg3B5ockUvSnshh1OJw9JGHnVt3I0O20uF/3HpZjKN
   oyGZ/mH2Ia8bTw2O0WUyz+IJx7RxSJpxfNeUt+Hwv79ncAOpqY39Q643g
   y6gAsmrbl3JvR18Ys2f4UwXLZ69lZiFoY6QtR5wG6zkR7PaYEmylOh/xd
   aRgeYneDg/QfXC+KqQw2DuCZArJpB7dg4jy7BQBxfLlWbX4gTcKa8SFBM
   dRS7wUT1pvYh0BTg+l2untXvrE9l9ceQs52j0SgWpqMVeCbjJ1gmFaUud
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,230,1673884800"; 
   d="scan'208";a="224494461"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 03 Mar 2023 16:12:12 +0800
IronPort-SDR: 5G0UXElQ72knhZGLktMfKVbL2w+yLeXqVlz+StU4f58nrNkC91mbRpn8qPTm+BrXmtW3OOuFvV
 04UOQfEvlOazdIROTcFxBsptMRxoImAiTSfhi396UCYHpLi2EpWUg42wqu5DqX09bgtBZB0QxI
 P2VdfodlqwZ1JpQgtyy6ZTNpNITt/fT+fuC12l9NrQBNhXkqnj+TlOALCjm9hwWV718At6NIpw
 zE+07AQxnssYomLOrxlX6aJOvHFza3uvGHjiExjQjDYhCCT7odoz9iSaaZH8C10oslDJYJjujX
 rkg=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Mar 2023 23:23:16 -0800
IronPort-SDR: 0jbYEBM9mWxRNSZaOC8yRWt6od7ZMPmLI3qbchKS01LjvUZVpvIkgJEmX3P/gDo7D3OFicuUYE
 0sjPnhL57FNrp5cOpsW9gh3A8fMGM3fBFJl6P3avRGNf3Y+kNa2A+hV6esGiqo0iXX+CY//91z
 F/rVgssImVDebgNIB2YoKvWvkcUr882yFzmraOxWUjPoPI9z5KZOaowqDDbn9Xmxu7/PSQO3sB
 ljilfEKQvTGbP0OJ/vPm1iWda/9nNbAF4whIHUIKSZtqtOHyt9oJzZIJcKwY4BFgLACWFBaeq6
 KtU=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Mar 2023 00:12:13 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4PSggJ57SVz1RvTr
        for <stable@vger.kernel.org>; Fri,  3 Mar 2023 00:12:12 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1677831132; x=1680423133; bh=4WOsAfpITDveUkLlKm0C8SxMPp9Wv2/hWv9
        cOYmED8c=; b=r939lYevixNneq869+mJPudSimlTooNyMa+LuxbtyX3/Swx8Pz7
        tCHOwEmkZ+rvG3JIQFK9PhihaN6HC2XOOkDPB/QkX9WkSCQdhs8Erv78BIciiF02
        Pxx+UrhZqJGC2ZE9g/s1CeVf7PEI0OZIFYDIyEKWiIfsitaozGUsBl2RZWOcTARx
        bxilI+K33vaEA0Q0U9NjKhMP+fs4P5SCfIMg7Bs9HqL3Vx03wzBa55QA3Ay6L/Jx
        syUMlAg7K+N0DK/SbZiJB6nLLhL72WNHqwfhs1NeHgRrtkeQfoYWWKPU2IyoV96S
        MW0UrVXMnJN+D3Weh9oigWDSSh2LJF9YHLA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id UP_mpq9xu33K for <stable@vger.kernel.org>;
        Fri,  3 Mar 2023 00:12:12 -0800 (PST)
Received: from [10.225.163.47] (unknown [10.225.163.47])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4PSggG591kz1RvLy;
        Fri,  3 Mar 2023 00:12:10 -0800 (PST)
Message-ID: <414d105f-4197-9bef-18cf-f44d422ffd62@opensource.wdc.com>
Date:   Fri, 3 Mar 2023 17:12:09 +0900
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
 <fa07d882-499a-4d49-8ab2-679298f16c54@leemhuis.info>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <fa07d882-499a-4d49-8ab2-679298f16c54@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/3/23 16:30, Thorsten Leemhuis wrote:
> On 03.03.23 08:10, Linux regression tracking (Thorsten Leemhuis) wrote:
>> Hi, this is your Linux kernel regression tracker.
>>
>> I noticed a regression report in bugzilla.kernel.org that apparently
>> affects 6.2 and later as well as 6.1.13 and later, as it was already
>> backported there.
>>
>> As many (most?) kernel developer don't keep an eye on bugzilla, I
>> decided to forward the report by mail. Quoting from
>> https://bugzilla.kernel.org/show_bug.cgi?id=217114 :
>>
>>>  emmi@emmixis.net 2023-03-02 11:25:00 UTC
>>>
>>> As per kernel problem found in https://bbs.archlinux.org/viewtopic.php?id=283906 ,
>>>
>>> Commit 104ff59af73aba524e57ae0fef70121643ff270e
>>
>> [FWIW: That's "ata: ahci: Add Tiger Lake UP{3,4} AHCI controller" from
>> Simon Gaiser]
> 
> BTW, there is one thing I wondered after sending above mail: was it
> really wise to merge this to mainline two days before 6.2 was released?
> Yes, the change subject's makes it sounds like this is a hardware
> enablement, but the `Mark the Tiger Lake UP{3,4} AHCI controller as
> "low_power"` at the beginning of the change description shines a
> different light on it.

Yes, I made the decision to send this patch as a "fix" rather than a change, and
that was rc8. In retrospect, maybe not the best decision. But the patch was
fixing issues for Simon, so...

Anyway, will follow this. I requested more information on Bugzilla. The issue
here is that it may be due to the device having a bad LPM support (there are
many) rather than the controller itself. Need to sort this out.



-- 
Damien Le Moal
Western Digital Research

