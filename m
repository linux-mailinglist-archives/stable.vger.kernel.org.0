Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31E086DAB2E
	for <lists+stable@lfdr.de>; Fri,  7 Apr 2023 12:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbjDGKBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Apr 2023 06:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjDGKBG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Apr 2023 06:01:06 -0400
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13ACE86A6
        for <stable@vger.kernel.org>; Fri,  7 Apr 2023 03:01:03 -0700 (PDT)
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4PtDQh2MH0z9sbm;
        Fri,  7 Apr 2023 12:01:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1680861660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=2dcJG+h6D6Yjb6GKndwmF20WC1V+R9FG6kpjICyY6/M=;
        b=UTNoS0fjiWzrKjLuQ8e5oAYh6vR9iRAyRwTySsvggiZ0NdI/Bl4OTlgwPOVimV7VfYq7/J
        K7mADuktfbZTrTQnSFnY5gAHGvTR5dlfneE8gxpYpxty43uzky0y8C331luOd03k+p3OF5
        OJQjNa0cHSkQSxI4xF3/qsNXwBUQCFF3wy3FeMGAHBUnItG+5NNvy6vFvy+tsz+4hSnhR1
        xSSDf65WTZnTFdpL6yxsZmNjakc5EXCbV10FfRetrsntVpTOoZSFle1FQWUp+xaFJ6qWK4
        N4KfFIkYvICY6GiS1PSRBSPkbCRLzRErdCBvdEMEO97x21eCGQH8SrVNRg+BJQ==
Subject: Re: 6.1.22: Resume from hibernate fails; bisected
To:     "Huang, Tim" <Tim.Huang@amd.com>
Cc:     Linux regressions mailing list <regressions@lists.linux.dev>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        Greg KH <gregkh@linuxfoundation.org>
References: <b52bfd11-0d90-739b-be3e-058e246478f7@mailbox.org>
 <c87add10-3e8f-b17e-f3f5-067431a23e16@leemhuis.info>
 <d3ac4ff5-863f-2179-1120-191774d80a27@mailbox.org>
 <ZC8m_gjbB4oVlO5t@kroah.com>
 <BY5PR12MB3873E2729AAA7D0FBB657611F6969@BY5PR12MB3873.namprd12.prod.outlook.com>
From:   Rainer Fiebig <jrf@mailbox.org>
Autocrypt: addr=jrf@mailbox.org; prefer-encrypt=mutual; keydata=
 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
Message-ID: <aecdece7-6652-c2c9-46eb-03abdb4204be@mailbox.org>
Date:   Fri, 7 Apr 2023 12:01:04 +0200
MIME-Version: 1.0
In-Reply-To: <BY5PR12MB3873E2729AAA7D0FBB657611F6969@BY5PR12MB3873.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-MBO-RS-META: t1f8gd757pqmu5yoxf9ipxmwrgonbgek
X-MBO-RS-ID: 417553d25df8875dedc
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 07.04.23 um 05:40 schrieb Huang, Tim:
> [AMD Official Use Only - General]
> 
> On Thu, Apr 06, 2023 at 05:39:07PM +0200, Rainer Fiebig wrote:
>> Am 06.04.23 um 15:30 schrieb Linux regression tracking (Thorsten Leemhuis):
>>> [CCing the regression list, as it should be in the loop for regressions:
>>> https://docs.kernel.org/admin-guide/reporting-regressions.html]
>>>
>>> On 06.04.23 14:06, Rainer Fiebig wrote:
>>>> Hi! Since kernel 6.1.22 starting a resume from hibernate by hitting a
>>>> key on the keyboard fails. However, if the PC was switched off and on
>>>> again (or reset), the resume is OK. The APU  is a Ryzen 5600G.
>>>>
>>>> Bisecting between 6.1.21/22 turned up this:
>>>>
>>>>
>>>> Author: Tim Huang <tim.huang@amd.com>
>>>> Date:   Thu Mar 9 16:27:51 2023 +0800
>>>>
>>>>     drm/amdgpu: skip ASIC reset for APUs when go to S4
>>>>
>>>>     commit b589626674de94d977e81c99bf7905872b991197 upstream.
>>>>
>>>>     For GC IP v11.0.4/11, PSP TMR need to be reserved
>>>>     for ASIC mode2 reset. But for S4, when psp suspend,
>>>>     it will destroy the TMR that fails the ASIC reset.
>>>> [...]
>>>>
>>>>
>>>> Reverting the commit solves the problem.
>>>> Thanks.
>>>
>>> Please try 6.1.23 and report back, because from the thread
>>> https://lore.kernel.org/all/20230330160740.1dbff94b@schienar/
>>> it sounds a lot like "drm/amdgpu: allow more APUs to do mode2 reset when
>>> go to S4" might be fixing this, which went into 6.1.23.
>> Yes, 6.1.23 seems OK so far.
>>
> 
> 
> The patch " drm/amdgpu: allow more APUs to do mode2 reset when go to S4" is to fix this hibernate regression issue.
> 
> Sorry to have troubled you.
No problem, please don't take it personally. It wasn't a big deal and I
was just a bit grumpy yesterday.

Thanks for the info and have a good day!

Rainer


