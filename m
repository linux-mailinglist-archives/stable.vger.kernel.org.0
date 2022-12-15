Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4A0164DAE0
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 13:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbiLOMJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 07:09:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiLOMJ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 07:09:26 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE202DAA1
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 04:09:25 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id y25so15311998lfa.9
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 04:09:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BonayDXjelRmeYBGGJjvECoETrAi9l86oKUl2f/LTBs=;
        b=NZqx9pPeB0Pzcb5nIc5vvSOBjvvyGu7zDGqvDIpnGMLF3uCvxylvCo9HlNEZGRtdFP
         7VnsQYEW4SsYrnDPa/CwmizqbTb+7Tsn4VRbd0DwMy6iE7KfAAf6QcMoM9eMDxz5zY3b
         MITKvGFCEu1nxaKaWocTfOJ7QVeQbQ20Qwq54=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BonayDXjelRmeYBGGJjvECoETrAi9l86oKUl2f/LTBs=;
        b=Zy6Jzb3nPIK8AhilPusITm8n+8+Ac+PN0m2vniSfUHSI5M3RFO4YFDKMPLjMLcaYba
         1pjzWIkMsli+x0ygjbgMH4AThlwOOIc4u+YzJwpcCcO+RHlvYIRizwqEoJtgIa7Qoj1d
         w2m1E6fxA+OU4wrJG948vBApgWYZV86yK2mVXh0JMOIDD5Q9MRdpBi3Fb+UXY5sB18LX
         0LArwI2JLTtMvn0SBAJ/N2xletr9rAmRcLFh/RvjYt5HXhT/IGOLagnetSrlc0GRpNnX
         2VsLpCrWuU9rT+b1Nyy46JUXVYjFqPdPEbwfdGek4ycUKe8hSRy7fUoEGYnpzDBk6jOs
         7M1Q==
X-Gm-Message-State: ANoB5pmotjNHZ4ndTd5ZcDEvB9Jx++aH3llKM3hzgdzVRJyUpCBBqOUe
        Y+rQYd2gEAd4Eg5LGG+tBnnP+A==
X-Google-Smtp-Source: AA0mqf6FJx7D+G5p9QQX/o7bT+pFkhw513lLD2u4U9OZ1hBHy2y58Em73i14qx/TWBY6n0pv2ql1ew==
X-Received: by 2002:a05:6512:6d1:b0:4a4:7cab:3bad with SMTP id u17-20020a05651206d100b004a47cab3badmr9344432lff.28.1671106163654;
        Thu, 15 Dec 2022 04:09:23 -0800 (PST)
Received: from [172.16.11.74] ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id a23-20020a19f817000000b0049465afdd38sm1149721lff.108.2022.12.15.04.09.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Dec 2022 04:09:23 -0800 (PST)
Message-ID: <de35cbb1-e02e-5777-b80b-738e4c695bdb@rasmusvillemoes.dk>
Date:   Thu, 15 Dec 2022 13:09:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH AUTOSEL 4.9 2/2] net: loopback: use NET_NAME_PREDICTABLE
 for name_assign_type
Content-Language: en-US, da
To:     Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>,
        "David S . Miller" <davem@davemloft.net>, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
References: <20221212103704.300692-1-sashal@kernel.org>
 <20221212103704.300692-2-sashal@kernel.org> <Y5r+KyWmREm7dKbr@duo.ucw.cz>
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
In-Reply-To: <Y5r+KyWmREm7dKbr@duo.ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15/12/2022 11.59, Pavel Machek wrote:
> Hi!
> 
>> From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>>
>> [ Upstream commit 31d929de5a112ee1b977a89c57de74710894bbbf ]
>>
>> When the name_assign_type attribute was introduced (commit
>> 685343fc3ba6, "net: add name_assign_type netdev attribute"), the
>> loopback device was explicitly mentioned as one which would make use
>> of NET_NAME_PREDICTABLE:
>>
>>     The name_assign_type attribute gives hints where the interface name of a
>>     given net-device comes from. These values are currently defined:
>> ...
>>       NET_NAME_PREDICTABLE:
>>         The ifname has been assigned by the kernel in a predictable way
>>         that is guaranteed to avoid reuse and always be the same for a
>>         given device. Examples include statically created devices like
>>         the loopback device [...]
>>
>> Switch to that so that reading /sys/class/net/lo/name_assign_type
>> produces something sensible instead of returning -EINVAL.
> 
> This was already part of the previous autosel:

Yup, but it was punted for a week:

https://lore.kernel.org/lkml/Y5AO7TrYsdeVqyI6@sashalap/

