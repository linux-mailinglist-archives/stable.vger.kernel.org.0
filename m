Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16ACD669704
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 13:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240570AbjAMMa0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 07:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240363AbjAMM16 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 07:27:58 -0500
X-Greylist: delayed 527 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 13 Jan 2023 04:25:18 PST
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050:0:465::202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA4EFD0
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 04:25:17 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4NtgPd0hLzz9sRT;
        Fri, 13 Jan 2023 13:16:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1673612181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=uLpYBbXupoR2rTXmmvvx1r2uwe1KKv0Tzmr2RiVHw5c=;
        b=kjTOdf8bArbIFh8EnmZ0U2VLrajU4c/rddC+sEFGyOPUgyMrGxyFlJdeSky2/3Wa2VMj8b
        MuHSC9TZNTWTrmjnKs8OSAFWpgzF6Z6K6UMs42hGaXoU3ekzOhdnXelhbQn4hIuLPLgfn9
        uRsYsm+K732fIY22OqzQx2szoLSuoWQS3vb2cVM3vVL3kBqaQmb+Yc9P+uHcsCT3FhBrGl
        y+9GnVMghjQyNaglBHYAPcEXKFo2A0qeZvpNHAKM6MQfRLvO55/4H3AlQxZ32FXPqiQjTQ
        DfJxdXciebYMyOT0XAW6XoEPabudefY2SNVaNT8V4WteVdwxpjieBe5+6BHPDQ==
Subject: Re: Kernel v6.0.18: Resume from hibernate fails, system hangs;
 bisected
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, alexander.deucher@amd.com,
        christian.koenig@amd.com, luben.tuikov@amd.com
References: <2d59ed2b-ba8f-6695-9764-fd3b109acd4c@mailbox.org>
 <Y8EtfP9CA52Btz7b@kroah.com>
From:   Rainer Fiebig <jrf@mailbox.org>
Autocrypt: addr=jrf@mailbox.org; prefer-encrypt=mutual; keydata=
 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
Message-ID: <f17b8213-f173-cce4-5ba3-058130d1cf8c@mailbox.org>
Date:   Fri, 13 Jan 2023 13:14:58 +0100
MIME-Version: 1.0
In-Reply-To: <Y8EtfP9CA52Btz7b@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-MBO-RS-META: ccqn71z76wy67qb6qxwwd961a3j4bu16
X-MBO-RS-ID: 5ba118b282c0037c92b
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 13.01.23 um 11:07 schrieb Greg KH:
> On Thu, Jan 12, 2023 at 10:03:33PM +0100, Rainer Fiebig wrote:
>> Hi! Since kernel 6.0.18 resume from hibernate fails, the system hangs
>> and a hard reset is necessary.  The CPU is a Ryzen 5600G, the system is
>> Linux From Scratch-11.1.
>>
>> I found this in the system log:
>>
>> [...]
>> Jan 12 19:30:03 LUX kernel: [   50.248036] amdgpu 0000:30:00.0: [drm]
>> *ERROR* [CRTC:67:crtc-0] flip_done timed out
>> Jan 12 19:30:03 LUX kernel: [   50.248040] amdgpu 0000:30:00.0: [drm]
>> *ERROR* [CRTC:70:crtc-1] flip_done timed out
>> Jan 12 19:30:14 LUX kernel: [   60.488034] amdgpu 0000:30:00.0: [drm]
>> *ERROR* flip_done timed out
>> Jan 12 19:30:14 LUX kernel: [   60.488040] amdgpu 0000:30:00.0: [drm]
>> *ERROR* [CRTC:67:crtc-0] commit wait timed out
>> ^@^@^@^@^@^@^@^@^@^[...]@^@^@^@^@^@^@^@^@^@^@^@^@^@Jan 12 19:31:20 LUX
>> syslogd 1.5.1: restart.
>> [...]
>>
>>
>> Bisecting the problem turned up this:
>>
>> ~/Downloads/linux-stable-BLFS-11.1> git bisect bad
>> 306df163069e78160e7a534b892c5cd6fefdd537 is the first bad commit
>> commit 306df163069e78160e7a534b892c5cd6fefdd537
>> Author: Alex Deucher <alexander.deucher@amd.com>
>> Date:   Wed Dec 7 11:08:53 2022 -0500
>>
>>     drm/amdgpu: make display pinning more flexible (v2)
>>
>>     commit 81d0bcf9900932633d270d5bc4a54ff599c6ebdb upstream.
> 
> Can you resend this and cc: all of the people involved in this commit as
> well as the drm mailing list?
CCed those involved in the commit but couldn't find the address of the
drm list.

> 
> Also, does 6.1.y work properly for you?  6.0.y is now end-of-life and
> you shouldn't be using it anymore.
Yes, a cursory test seems to indicate that 6.1.5 is OK, I'll be using
6.1 from now on.

Thanks.

Rainer Fiebig
