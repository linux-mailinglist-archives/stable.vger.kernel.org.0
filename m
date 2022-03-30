Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70FF84EC7A8
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 17:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236253AbiC3PBv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 11:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240208AbiC3PBo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 11:01:44 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC8781EEE7
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 07:59:58 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id c2so17807314pga.10
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 07:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=ihIQhi45Tk2WCEjRnjH70plwRpZOIp3dLTUlkro65zc=;
        b=eOTTaZgCHLhwsCxPQGz6yJ0S5octViRhHt80S5j5MSBEfJCWj3xaoX9UQovPrJA8uz
         EClBqEPpNks+PF/FDtYjS2YuqM0/9IGSP0Z2PhQpvNmi/RiteGtEi7EVK357SNW9HPqN
         HEZw/Ka2F+S4LVNBcdQCDNnZqMjXv5EZVoTMzeHL0+E/JzsVdwG/mDXE3NWpQU/lTH2L
         /+5MK9zf+uwwMnBW7qFLIaujhmpk3u+5vKoXYSwObpOm3BJ1ZHBWanrqhMQQTf9ltH9v
         JMpdEA/M+TY2JrCgx2+I/PogcN1M6Z5NOoUArmApYjMPBreMw4LudPhZn6E8HpkLQE7k
         q2Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=ihIQhi45Tk2WCEjRnjH70plwRpZOIp3dLTUlkro65zc=;
        b=wchbQVCifPp7XdChiHMyayh1RqyV1qDEO61527FXurG/i2xR++iAtFqUPck/go4bcd
         8+lAxBVnUZYqVfNu+28WOHuBD8vOrs4A/ikHE40nkpwz3JL/O3MuuF7pGrB72rTd/S1p
         6BogAprUvdUo9R3iTSI3pt94LoTn+S33dM97L75Hyct5SdH5fNfswNuQwWchP4a01ihg
         kIYcEiYcKuwxirUXo30ak/oOepDZiSwNdKoSbCxDUkom5QdXgJqXgEngyEsg0NUAslZH
         PPPjsIgUolrOo9dBg+nxZL4C6z0pwCe6hgU9/eQNTr+9Yjk7TBLYUqwNiPJTQ9xnveJ+
         XNxw==
X-Gm-Message-State: AOAM530y9/urQ+HT6V2sMNeLqoE1o9Jyoh1XCjJgPzy5E++lxXpGPssF
        xDFzBYtCVHbkxK7+F2t6Q2ZkFA==
X-Google-Smtp-Source: ABdhPJyCevCsgzKARxDNX4HQzEFMCgVRwhKZqiUhG/nXq9hAFGeuH+jSvWD8VdL6KHAbCQiIeOr3NA==
X-Received: by 2002:a63:931d:0:b0:398:a2b7:76b9 with SMTP id b29-20020a63931d000000b00398a2b776b9mr4052347pge.239.1648652398399;
        Wed, 30 Mar 2022 07:59:58 -0700 (PDT)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id k18-20020a056a00135200b004fb18fc6c78sm20297694pfu.31.2022.03.30.07.59.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Mar 2022 07:59:58 -0700 (PDT)
Message-ID: <7f3c25f5-33ac-b5f6-9c2e-17e2310a6377@linaro.org>
Date:   Wed, 30 Mar 2022 07:59:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <20220329220256.72283-1-tadeusz.struk@linaro.org>
 <20220329220256.72283-2-tadeusz.struk@linaro.org>
 <YkRtWs7ieUA/7Xg9@kroah.com>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: Re: [PATCH 2/2] skbuff: Extract list pointers to silence compiler
 warnings
In-Reply-To: <YkRtWs7ieUA/7Xg9@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/30/22 07:46, Greg KH wrote:
> On Tue, Mar 29, 2022 at 03:02:56PM -0700, Tadeusz Struk wrote:
>> Please apply this to stable 5.10.y, and 5.15.y
>> ---8<---
>>
>> From: Kees Cook<keescook@chromium.org>
>>
>> Upstream commit: 1a2fb220edca ("skbuff: Extract list pointers to silence compiler warnings")
>>
>> Under both -Warray-bounds and the object_size sanitizer, the compiler is
>> upset about accessing prev/next of sk_buff when the object it thinks it
>> is coming from is sk_buff_head. The warning is a false positive due to
>> the compiler taking a conservative approach, opting to warn at casting
>> time rather than access time.
>>
>> However, in support of enabling -Warray-bounds globally (which has
>> found many real bugs), arrange things for sk_buff so that the compiler
>> can unambiguously see that there is no intention to access anything
>> except prev/next.  Introduce and cast to a separate struct sk_buff_list,
>> which contains_only_  the first two fields, silencing the warnings:
> We don't have -Warray-bounds enabled on any stable kernel tree, so why
> is this needed?
> 
> Where is this showing up as a problem?

The issue shows up and hinders testing stable kernels in test automations like 
syzkaller:

https://syzkaller.appspot.com/text?tag=Error&x=12b3aac3700000

Applying it to stable would enable more test coverage.

-- 
Thanks,
Tadeusz
