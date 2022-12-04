Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4E17642076
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 00:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbiLDXDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Dec 2022 18:03:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbiLDXDg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Dec 2022 18:03:36 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C442D10B74
        for <stable@vger.kernel.org>; Sun,  4 Dec 2022 15:03:34 -0800 (PST)
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 7D6673F133
        for <stable@vger.kernel.org>; Sun,  4 Dec 2022 23:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1670195012;
        bh=S7YMQqF7AFOPlXKCubLQj5wkne/rfUvAtvkieI6VllQ=;
        h=Message-ID:Date:MIME-Version:To:Cc:References:From:Subject:
         In-Reply-To:Content-Type;
        b=NeRWx5c5dPEg4/6bYcX9WZxLWBjIBMRqc4aPBayh4Mibf9suX9hrhXRQWUSIk/MtQ
         fT1Y8njEveMSd9cdwQB+aVIjpRK6pC6R8jtnKme/OvcYBZQ+Q1xXoXv7DTtRt0fFdT
         gV/RLRfE4zAzfTXB01bVq8lpOS/dzQ+aFPpSZKU5CHHPnuvlRYqhQMn7+2sbq2p60w
         vEoYMcesQZvZyugicDJP0VqSpeBiIr6YCafwlZMLocpWRW5MTFFO6/NlwTs+FHBw8g
         oh5KzWBa6A0R1UkR+/K2LmUHIuw+HNFtPkohpUR6DKqaAjPaRh1HaAIH/0Tb8BitKa
         SyR+cq6pVcZkg==
Received: by mail-wm1-f70.google.com with SMTP id x10-20020a05600c420a00b003cfa33f2e7cso5953866wmh.2
        for <stable@vger.kernel.org>; Sun, 04 Dec 2022 15:03:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S7YMQqF7AFOPlXKCubLQj5wkne/rfUvAtvkieI6VllQ=;
        b=yeF+jhOhK3WUW5CjFi77AcfAEOZ6Q22ZV9pCg6fYHol1AhenLZFFlxjsX0HWRLjQId
         5FgExdr3CmXG773NbPiM80MMMODOdwMFe3HrL6whmGw8By3QKB+ghBZsYQxCM8SIkF0Z
         8UcEPn0Ao1fQkPuCbgf7Z6hoRsoMHe85fX4bMvpiQe4wc+rBcJeppcPS1aECRCBtUTYu
         l+CAsWb0EALS3oLZGA5WYW6NYr3ii8cT8f00em7CvaO1ZyOmUy6igq/OUG30sl60WmVP
         G6YC6ZpWKzFCfcHQ/Cf34F9oB8U17OdbMn9nIGD7U1VO5cq2mdBRCEmLjfD1isaA/1tt
         p4Zw==
X-Gm-Message-State: ANoB5pnTdD1R6WDV0jETmWQreK147kNKO7PPqOMo4zsV2CgJv7+DVjlR
        iusjHYfqjqlkamlMWUiA1Yocc37gxkCng4xxfyMyknkfMJxOYL1NTOWsQoJz9WWXLVntDWJPmpK
        7vJSWfj1+JFqLLrIw0f9cUZEKN3v34+Vv+w==
X-Received: by 2002:a05:6000:989:b0:236:91d0:1f with SMTP id by9-20020a056000098900b0023691d0001fmr41659631wrb.33.1670195011500;
        Sun, 04 Dec 2022 15:03:31 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7SlNv2PvRtZ7pl4BFZ6ISMlvyJJk5q1n5Ki9JCgBvLobXmPdJ8b/nGOF/nLO3nPft+0iG3Ag==
X-Received: by 2002:a05:6000:989:b0:236:91d0:1f with SMTP id by9-20020a056000098900b0023691d0001fmr41659624wrb.33.1670195011234;
        Sun, 04 Dec 2022 15:03:31 -0800 (PST)
Received: from [192.168.1.27] ([92.44.145.54])
        by smtp.gmail.com with ESMTPSA id z10-20020a05600c0a0a00b003c70191f267sm22468903wmp.39.2022.12.04.15.03.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Dec 2022 15:03:30 -0800 (PST)
Message-ID: <1f0c76ed-5929-8804-ab79-a1c49368e20a@canonical.com>
Date:   Mon, 5 Dec 2022 02:03:29 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:108.0) Gecko/20100101
 Thunderbird/108.0
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <20221203222434.669854-1-cengiz.can@canonical.com>
 <Y4zFzNGlCC1wlyc2@kroah.com>
Content-Language: en-US
From:   Cengiz Can <cengiz.can@canonical.com>
Subject: Re: [PATCH 5.4 0/3] Bluetooth: L2CAP: Fix accepting connection
 request for invalid SPSM
In-Reply-To: <Y4zFzNGlCC1wlyc2@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04/12/2022 19:07, Greg KH wrote:
> On Sun, Dec 04, 2022 at 01:24:33AM +0300, Cengiz Can wrote:
>> Hello,
>>
>> commit 711f8c3fb3db ("Bluetooth: L2CAP: Fix accepting connection request for
>> invalid SPSM") did not apply to 5.4-stable tree previously.
>>
>> One of the notable dependencies is commit 15f02b910562 ("Bluetooth: L2CAP:
>> Add initial code for Enhanced Credit Based Mode") and that doesn't apply to
>> 5.4-stable either due to a mismatch on `l2cap_sock_setsockopt_old` in
>> l2cap_sock.c.
> 
> And that commit does not seem relevant for stable backports at all as it
> is a new feature.  If all you really want to do is fix the "bug", why
> not just take half of commit 711f8c3fb3db, i.e. the half that actually
> matters in this kernel tree?

That sounds reasonable and it actually was my first attempt.

However I was not sure if that would be enough to mitigate all possible 
execution paths. Since your earlier (possibly automated) message[1] 
listed possible dependencies and I wanted to play it safe.

[1]: https://lore.kernel.org/all/1667811208314@kroah.com/

> Why wouldn't that just work for all of the older kernels?  I'll go do
> that now as it seems like it will solve the issue, 

Please do. Thanks!

> if people could actually test it (hint, why didn't you cc: the bluetooth
> developers here?)

For my patchset I ran basic communication tests with l2test (from bluez).

```
$ l2test -I 2000 -r
l2test[1492]: Waiting for connection on psm 4113 ...
l2test[1494]: Connect from 00:11:22:33:44:55 (bredr, psm 4113, dcid 64)
l2test[1494]: Local device 66:77:88:99:AA:BB (bredr, psm 4113, scid 64)
l2test[1494]: Options [imtu 2000, omtu 672, flush_to 65535, mode 0, 
handle 1, class 0x6c010c, priority 0, rcvbuf 212992]
l2test[1494]: Receiving ...
```

And you are absolutely right. I forgot to CC bluetooth devs. That's my 
bad. Sorry for that.

Thank you for the constructive feedback.

> 
> thanks,
> 
> greg k-h

