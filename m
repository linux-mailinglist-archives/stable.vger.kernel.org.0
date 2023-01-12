Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8E2667F6F
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 20:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240015AbjALTlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 14:41:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234531AbjALTkv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 14:40:51 -0500
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [85.215.255.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E3E6E0CE;
        Thu, 12 Jan 2023 11:32:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1673551875; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=GZ2T2djxT3FmtBmSLCXoavuBiLpkYAKU3T9oW2Xgyd5sRiluzeEh/TIEPCn2r42m9M
    dwqSdDX6UyLNNBLP6ZvKdM17xYwNOFtJecdbSoK9nGVAxzDGDIdkGONKvY4HveS5qEj0
    UyrbgOOW5MjavS46GqT5PTdDaod8tcqmNACRsetPimHj3yeVcY2a1kt5tnEURGdSiWbg
    D1yLHbajQa0MQPlw+UxJUFBcWE8UUIFch7v9UoYKA+FN7fIJImdhSymvxU2dODzoAmR/
    1aFohdqWjHHOBiazmRBMi99+h2Q3BUi5VkRB/5nzP6w9brgqK+rg2enCGk5mE4xoC3Zi
    w12w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1673551875;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:References:Cc:To:From:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=voXJ3+FVsOJeQocmOoD2w0EDxDMCn+AisNM+x8mge4w=;
    b=HUvuOUDceJbfRAy2gDuwPisO3ZxzIpRq1p5+0T8agOVjUvnOwBHS7OQipfhhAiH94p
    PqvfP+bOPwAbXE/Us2zyHXLMAOTLPXz2edTku8V+0yqpk8TvMxB9MHvKHfJLnY/5aBGG
    pGNcs+I4g8ebiwOqmLaCt7U4sLgkDcS+KrcVKz9IJ81ZeM3SwsEdmhKoZMSJvSasiDYB
    4r/yADUDY2nz8IEu5dpzEEN0Z55tbTCpzdzOj/iwfZh5vMJdtCHA4X+oRfZsM6C2FG/l
    /babNqmjzFbhAbkydMIH1kQWONGl8y+t3AnBXtz0u2gWb7WlQH5itkgayISIKkfbMFP2
    cajw==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1673551875;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:References:Cc:To:From:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=voXJ3+FVsOJeQocmOoD2w0EDxDMCn+AisNM+x8mge4w=;
    b=CC9+ZFq9Ndo7MzRv/6jIGOdcVX0V44Od/zZwg+omQ1POSz6gGyVlzSMOxPzeVDUPa/
    h6rdVKk5GMxQdMELdf03damt2rGgm0J1oTgcfGHXgr43PqeTozxmkoQxk7+7haZbGzyh
    3EntWiKNjq8BUqtNJpq1IKChRS772h+mN0Y4VcQ8Mnpy0bLun4pRSY0T3dIRg46l0bOq
    8Fdxm59aOATvYXS9HqFLScKiEHCSmK8JRL1bzI23PTh7EO0PUtUicu9Kvdb+BA8Gof0o
    445G11Swi1AGbZ4ZE1zGIgLa+rcxtKeLqryKZGLBd1HILX3xg5UQr/fvPedLbIaFNuNS
    Toaw==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3TMaFqTEVR5J8xpzl0="
Received: from [192.168.60.87]
    by smtp.strato.de (RZmta 48.6.2 DYNA|AUTH)
    with ESMTPSA id ifa639z0CJVF4Oa
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 12 Jan 2023 20:31:15 +0100 (CET)
Message-ID: <07af807f-14f6-c09a-78e3-ac9b52b0decc@hartkopp.net>
Date:   Thu, 12 Jan 2023 20:31:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2] can: isotp: handle wait_event_interruptible() return
 values
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, stable@vger.kernel.org
References: <20230104164605.39666-1-socketcan@hartkopp.net>
 <20230105093226.alchrnm34s6tmfpp@pengutronix.de>
 <20bef3ed-47ef-8042-6b98-1f498b81962f@hartkopp.net>
 <20230106113731.irqfxdpn5ygae44e@pengutronix.de>
 <0e0e041b-8dd9-0764-3fd1-a426c99ec417@hartkopp.net>
Content-Language: en-US
In-Reply-To: <0e0e041b-8dd9-0764-3fd1-a426c99ec417@hartkopp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I sent a V4 (recommended) so that you can pick V3/V4 at your will (see 
explanation below)

Thanks,
Oliver

ps. open patches:

[PATCH can-next] can: isotp: check CAN address family in isotp_bind()
https://lore.kernel.org/linux-can/20230104201844.13168-1-socketcan@hartkopp.net/T/#u

The below patch is needed to silence the Syzcaller
https://syzkaller.appspot.com/bug?extid=5aed6c3aaba661f5b917

[PATCH] can: isotp: split tx timer into transmission and timeout
https://lore.kernel.org/linux-can/20230104145701.2422-1-socketcan@hartkopp.net/T/#u

And the V4 patch.

https://lore.kernel.org/linux-can/20230112192347.1944-1-socketcan@hartkopp.net/T/#u

On 06.01.23 13:59, Oliver Hartkopp wrote:
> 
> 
> On 06.01.23 12:37, Marc Kleine-Budde wrote:
>> On 05.01.2023 13:58:30, Oliver Hartkopp wrote:
>>>
>>>
>>> On 05.01.23 10:32, Marc Kleine-Budde wrote:
>>>> On 04.01.2023 17:46:05, Oliver Hartkopp wrote:
>>>>> When wait_event_interruptible() has been interrupted by a signal the
>>>>> tx.state value might not be ISOTP_IDLE. Force the state machines
>>>>> into idle state to inhibit the timer handlers to continue working.
>>>>>
>>>>> Cc: stable@vger.kernel.org # >= v5.15
>>>>> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
>>>>
>>>> Can you add a Fixes: tag?
>>>
>>> Yes. Sent out a V3.
>>>
>>> In fact I was not sure if it makes sense to apply the patch down to 
>>> Linux
>>> 5.10 as it might increase the possibility to trigger a WARN(1) in the
>>> isotp_tx_timer_handler().
>>>
>>> The patch is definitely helpful for the latest code including commit
>>> 4b7fe92c0690 ("can: isotp: add local echo tx processing for consecutive
>>> frames") introduced in Linux 5.18 and its fixes.
>>>
>>> I did some testing with very long ISOTP PDUs and killed the waiting
>>> isotp_release() with a Crtl-C.
>>>
>>> To prevent the WARN(1) we might also stick this patch to
>>>
>>> Fixes: 866337865f37 ("can: isotp: fix tx state handling for echo tx
>>> processing")
>>>
>>> What do you think about the WARN(1)?
>>
>> If this short patch avoids potential WARN()s it's stable material.
>>
> 
> It is the other way around. As written above this patch might increase 
> the possibility to trigger a WARN(1).
> 
> With the patch:
> 
> https://lore.kernel.org/linux-can/20230104145701.2422-1-socketcan@hartkopp.net/T/#u
> 
> the WARN(1) is removed and this patch here makes the situation better.
> 
> Alternatively I could provide another patch for kernels < v6.0 which set 
> the rx/tx states AND remove the WARN(1).
> 
> Back to your original question about the "Fixes:" tag, I would suggest 
> to tag this patch similar to
> 
> https://lore.kernel.org/linux-can/20230104145701.2422-1-socketcan@hartkopp.net/T/#u
> 
> Namely:
> 
> Fixes: 866337865f37 ("can: isotp: fix tx state handling for echo tx 
> processing")
> Cc: stable@vger.kernel.org # >= v6.0
> 
> And later check whether I should remove the WARN(1) in older stable 
> kernels.
> 
> Should I send a V4 with the new "Fixes: 866337865f37" tag?
> 
> Best regards,
> Oliver
> 
