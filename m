Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFB3553FCE5
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 13:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241224AbiFGLI2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 07:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241198AbiFGLIH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 07:08:07 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2716E108A80
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 04:04:15 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id q7so23640912wrg.5
        for <stable@vger.kernel.org>; Tue, 07 Jun 2022 04:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raspberrypi.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=/01LXbrU5z5LnyLvjVjhRw5gO2250QwVl7s1xHwA700=;
        b=objHCNZ2KHO9DKsSjO8txuN/+/mQ3Au1SYtWJQNggjJdRxrnuZ4+W3rWrIr83s8ODW
         Bws0deMMR63NQvh0cC8AhlykhECHpnxi0fW7eXM3/rdK+SgeAsemMcHlovWQRAZD7uGR
         nvQN5mPCsGcImLn/TSRpxfTXSuEjqf/5RqrSUX4xbZ3G2JgVReRkWAwRmmrnhQAEj9NA
         aGsOmRKCnmYBCMjFFhqDQSrdmORT/Mb3YT+ugzwfcGPSR9Iocyeh7BLPPhUES3qyOGHs
         5w1KY/5llywB51iAhww7Ss9NFnlLTThZsO/hzYT+wiax+4ghDg4D2dGFLEzL8uY9RScd
         qSOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=/01LXbrU5z5LnyLvjVjhRw5gO2250QwVl7s1xHwA700=;
        b=febvM8/0OxU4olTmebxi4bkw5ofzQkVXzwGPp6y5cwqkhiVaZwgEXM6Yycx0qgs97t
         HAOCGZT3Nsf9Olo7iOnAZ401HrIzTFD5XeTlaIxrzANtf+q0mTj0fsvotR3M9N3kqAL3
         oZUDbaP3jwQf8wUVNdpkXs3L2u5zngfjuHnlmjhTKJMo4tdUFiOPsOrQQNDhUhvj48gm
         FURq82GwtfEoiy+t3/OH7O+5+zn/CwDq+QOCGUug263UmhFQZuVCLEhsNCqsHIT7HyV+
         PZeJts0DRySlUhc+nJHnbY2pRtcWsSp16qikQzonWyd/wGyWo7XUcnd1zuqO4CC9HNGa
         E0SQ==
X-Gm-Message-State: AOAM532UMoL3cCWhggnmRqQO+kfp4SRIH+voYuljxmFvvW/e4Qk1KEy0
        5Li/LWP0h30D7NX+a6hW7VajqQ==
X-Google-Smtp-Source: ABdhPJzus08UZgzKpQfSWRZXh0KYJWzP4L6nwpadyQuwOPoYoBOiGTsbLG7c7WdWfMKvsvli7OXsVA==
X-Received: by 2002:a5d:6e07:0:b0:210:3472:c4c7 with SMTP id h7-20020a5d6e07000000b002103472c4c7mr27128795wrz.15.1654599854368;
        Tue, 07 Jun 2022 04:04:14 -0700 (PDT)
Received: from ?IPV6:2a00:1098:3142:14:901f:dbcb:c1e4:e4b8? ([2a00:1098:3142:14:901f:dbcb:c1e4:e4b8])
        by smtp.gmail.com with ESMTPSA id s12-20020a05600c384c00b0039c587342d8sm2102181wmr.3.2022.06.07.04.04.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jun 2022 04:04:13 -0700 (PDT)
Message-ID: <c47c42e3-1d56-5859-a6ad-976a1a3381c6@raspberrypi.com>
Date:   Tue, 7 Jun 2022 12:04:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2] ARM: initialize jump labels before setup_machine_fdt()
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        stable <stable@vger.kernel.org>
References: <8cc7ebe4-442b-a24b-9bb0-fce6e0425ee6@raspberrypi.com>
 <CAHmME9pL=g7Gz9-QOHnTosLHAL9YSPsW+CnE=9=u3iTQaFzomg@mail.gmail.com>
 <0f6458d7-037a-fa4d-8387-7de833288fb9@raspberrypi.com>
 <Yp8WBaqr+sLInNnc@kroah.com>
From:   Phil Elwell <phil@raspberrypi.com>
In-Reply-To: <Yp8WBaqr+sLInNnc@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 07/06/2022 10:10, Greg KH wrote:
> On Tue, Jun 07, 2022 at 09:47:30AM +0100, Phil Elwell wrote:
>> Hi Jason,
>>
>> On 07/06/2022 09:30, Jason A. Donenfeld wrote:
>>> Hi Phil,
>>>
>>> Thanks for testing this. Can you let me know if v1 of this works?
>>>
>>> https://lore.kernel.org/lkml/20220602212234.344394-1-Jason@zx2c4.com/
>>>
>>> (I'll also fashion a revert for this part of stable.)
>>>
>>> Jason
>>
>> Thanks for the quick response, but that doesn't work for me either. Let me
>> say again that I'm on a downstream kernel (rpi-5.15.y) so this may not be a
>> universal problem, but merging either of these fixing patches would be fatal
>> for us.
> 
> I have reports of a "clean" 5.15.45 working just fine on a rpi.
> Anything special in your tree that isn't upstream yet that might be
> conflicting with this?  Any chance you can try a kernel.org release
> instead?

A clean 5.15.45 boots cleanly, whereas a downstream kernel shows the static key 
warning (but it does go on to boot). The significant difference is that our 
defconfigs set CONFIG_RANDOM_TRUST_BOOTLOADER=y - defining that on top of 
multi_v7_defconfig demonstrates the issue on a clean 5.15.45. Conversely, not 
setting that option in a downstream kernel build avoids the warning, presumably 
because it takes much longer to accumulate the required entropy.

Phil
