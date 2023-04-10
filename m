Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A92A96DCCD9
	for <lists+stable@lfdr.de>; Mon, 10 Apr 2023 23:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbjDJVfj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 17:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjDJVfi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 17:35:38 -0400
X-Greylist: delayed 8459 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 10 Apr 2023 14:35:35 PDT
Received: from mail.tty42.de (mail.tty42.de [94.130.190.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D14801730
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 14:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pisquaredover6.de;
        s=rsa; t=1681162533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MsX66Sdgtyw8XZTaxGP+msd1DvHC+CiXuQWqkADMNWQ=;
        b=dBrQqbKgUU7gi7kHdiYdZwySaWEdxfQpuG7cSvfRyC7j7+LLPbvJkhNwHvEi+EPPRSZDkK
        Alj+2Ezxoc82giHqagyuJtfMhnf1aLSOzwd9BjJTsT7ml0YVADAqsEZOYZoGTuS8sc3ic2
        dD5ICC3n8eaKa5WGNvp/HAR+IHwB2uT+YEF33cGJFP+3grrHekjnBaU0s2A6PmJBzBye3E
        6cZ/l8Wjico6VKeJ3TAY1IZ+RCFfP2d3zW3UUNSF3nx4eJuFo0u9m4UHzE6mHT/sNc5suY
        0w3wug/Qix3fllZRHV50pL/vU2/PI6Kxp1e2w87/HAGbrlBl75FX7NdVPDPH9A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=pisquaredover6.de;
        s=dkim; t=1681162533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MsX66Sdgtyw8XZTaxGP+msd1DvHC+CiXuQWqkADMNWQ=;
        b=WxL95ldv/XMGqHuhY8S/6R/Z2lbGeT7/10HGAKLl46PdCFP0aqJwoasb1hvvO2MYfzkQvX
        iV8XRzvYvYdceMAA==
Received: by mail.tty42.de (OpenSMTPD) with ESMTPSA id 32dc02dd (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 10 Apr 2023 21:35:32 +0000 (UTC)
Message-ID: <5d0f31da-add5-b0b4-2a91-57859529dd88@pisquaredover6.de>
Date:   Mon, 10 Apr 2023 23:35:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: Regression in 6.2.10 monitors connected via MST hub stay black
Content-Language: de-DE
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>,
        "Zuo, Jerry" <Jerry.Zuo@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <8e90142e-cdc3-a4a0-754a-4c7a2388940b@pisquaredover6.de>
 <MN0PR12MB61014AE52F7F84A86F909717E2959@MN0PR12MB6101.namprd12.prod.outlook.com>
 <MN0PR12MB61011B4C8FF79D3035963095E2959@MN0PR12MB6101.namprd12.prod.outlook.com>
From:   Veronika Schwan <veronika@pisquaredover6.de>
In-Reply-To: <MN0PR12MB61011B4C8FF79D3035963095E2959@MN0PR12MB6101.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

6.3-rc6 alone fails the same way.
When the commit is added, it works.

On 10/04/2023 21.22, Limonciello, Mario wrote:
> [Public]
> 
> And if 6.3-rc6 fails the same way, please one more check with 6.3-rc6 + this commit:
> https://gitlab.freedesktop.org/agd5f/linux/-/commit/c7c4fe5d0b0a
> 
>> Hi,
>>
>> Can you by chance cross reference 6.3-rc6?
>> It's quite possible we're missing some other commits to backport at the same
>> time.
>>
>> Thanks,
>>
>>> -----Original Message-----
>>> From: Veronika Schwan <veronika@pisquaredover6.de>
>>> Sent: Monday, April 10, 2023 14:15
>>> To: Zuo, Jerry <Jerry.Zuo@amd.com>
>>> Cc: stable@vger.kernel.org; Limonciello, Mario
>>> <Mario.Limonciello@amd.com>
>>> Subject: Regression in 6.2.10 monitors connected via MST hub stay black
>>>
>>> I found a regression while updating from 6.2.9 to 6.2.10 (Arch Linux).
>>> After upgrading to 6.2.10, my external monitors stopped working (no
>>> input) when starting my display manager.
>>> My hardware:
>>> Lenovo T14s AMD gen 1
>>> Lenovo USB-C Dock Gen 2 40AS (firmware up to date: 13.24)
>>> 2 monitors connected via dock and thus via an MST hub
>>>
>>> Reverting commit d7b5638bd3374a47f0b038449118b12d8d6e391c fixes the
>>> issue.
>>>
>>> Best regards,
>>> Veronika
