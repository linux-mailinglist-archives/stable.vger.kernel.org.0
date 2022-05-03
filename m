Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9722C518A38
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 18:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239688AbiECQp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 12:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbiECQpZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 12:45:25 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A2E2B195;
        Tue,  3 May 2022 09:41:52 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id v65so18711744oig.10;
        Tue, 03 May 2022 09:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DWGsTojyGQoSPIdCEDVzeXxH9jCGYkBR9JrUFgAvz6M=;
        b=p767NOvM44rw4/Z1xJXqfTr4LYOq/GvY9Lw7UYjhoP+9u9avKmVoxs/2O/Wfq9cmhJ
         BBHuhb897jNPkSzDbGcoeaGJnVNIqaL9iEK/BELMw87Grt3no7yCxXzEuEi8esgf3QmI
         ytnHenRgWyoHBDXpcUPqN32TElN9llRMcSp9DpDk9TI6CqgK1fliIuJxkKTwCXpb/mUX
         g3LW+QeThDOgP3kAF/JoR8pdj0ZGKYrxr5GsT5gENPpp1PsrPaYDuRbEOWftcXnDmJiF
         LB37DalfuKyofh/XbMxcuwLhfxQN5/bicyz/SfRkPUrwz44Henks2SoMA4QEugdKcphc
         uSDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DWGsTojyGQoSPIdCEDVzeXxH9jCGYkBR9JrUFgAvz6M=;
        b=sT04GqMPjzDbU3/m672xBhtLwiAZdXJRVnYk6Xr+VqkKX0R+cKJtTetjBjXnQRVJCf
         S97UmrWtRUPNWfLxeV7z9SXhWgjsP+Tkye9sbO3upO1/Ok29BkwypRS9eqJHi4gRctu+
         PPBa/vTy3SJIapKGM8cAVzvtTFJCHYgacbhEj3Q/jNEu0rVA44O8fs+5NbczkstES11c
         ZbPN3V8H3Cc5cjBSK7VdI4AvUYwNlSCSC/CGiST/3d9lMDS03dBXrkwzLj1AD6AjQuzi
         nhIUdgk660Z2z1sxQfbDOqL1X/XzEE/K/+vbf6tSnOQBHInRbANokLkwro7Ll/4QK9wH
         xdoA==
X-Gm-Message-State: AOAM532d2Ku3WSD6+uv0FRyjLRsj0inEJ1bL9djhHSgw5WaVdz1xcsNZ
        CqllqymWjAEV9mhsZrJt6mI=
X-Google-Smtp-Source: ABdhPJxJQtL3i+X4QSSL5pl008gbPgE0+t0O5LHQEsorzC2juhySNzwgMdnPmSQ4NNbM+0aj0KlJcg==
X-Received: by 2002:a05:6808:2107:b0:325:b9df:a6f8 with SMTP id r7-20020a056808210700b00325b9dfa6f8mr2233422oiw.164.1651596111758;
        Tue, 03 May 2022 09:41:51 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e10-20020aca130a000000b00325cda1ffa6sm3475308oii.37.2022.05.03.09.41.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 May 2022 09:41:50 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <fd8f1f86-1fb3-b4de-61f7-b7ec5aa2f95c@roeck-us.net>
Date:   Tue, 3 May 2022 09:41:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 4.19 00/12] 4.19.241-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220429104048.459089941@linuxfoundation.org>
 <20220503141652.GA3698419@roeck-us.net> <YnE7aX7p4iQvOrZf@kroah.com>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <YnE7aX7p4iQvOrZf@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/3/22 07:25, Greg Kroah-Hartman wrote:
> On Tue, May 03, 2022 at 07:16:52AM -0700, Guenter Roeck wrote:
>> On Fri, Apr 29, 2022 at 12:41:17PM +0200, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 4.19.241 release.
>>> There are 12 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Sun, 01 May 2022 10:40:41 +0000.
>>> Anything received after that time might be too late.
>>>
>>
>> No cc this time ?
> 
> You and Pavel said this, yet I see your response here:
> 	https://lore.kernel.org/r/20220429234822.GB2444503@roeck-us.net
> that you sent on Friday.
> 
> Did some old email get unstuck and resent somehow?
> 
> 4.19.241 was released on Sunday, I have not sent out new -rc
> announcements yet.
> 
> confused,
> 

No, it is me who is confused. I saw Pavel's e-mail, checked stable,
found this announcement, and thought it was a new one since lore
reordered it after Pavel's reply.

The problem I reported is for v4.19.241-49-g667276a8c00e,
but is also affects v4.14.y.queue and v4.9.y.queue.

Sorry for the noise.

Guenter
