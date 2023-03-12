Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC4E56B63EE
	for <lists+stable@lfdr.de>; Sun, 12 Mar 2023 10:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbjCLJSh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Mar 2023 05:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjCLJSg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Mar 2023 05:18:36 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8342BF25
        for <stable@vger.kernel.org>; Sun, 12 Mar 2023 01:18:34 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id da10so37435256edb.3
        for <stable@vger.kernel.org>; Sun, 12 Mar 2023 01:18:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678612713;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b4gzSsgbZ4erZvHZjlQIpNSOpbnpH6u0xWtISBNFy7w=;
        b=BXHJbDqqrtyQ2+yo2jSIMXzeww7zT0AWp1dhYhJp7cZwzYLinKcEcXf/O4kNBQesB5
         7maNsUrBFSmlqwEpA+gGDgYpVIp5wq8Y7R5v9kKXEFW3A+RDGFf59SL2Mvw0oN+lnBTc
         QQxjiZiX7Uq3h8XIRpdMPCTQsgl5JNdqO3qFFwnVIhjdrsXwTtNxbVAsXZyz/FHygbPp
         gafDKehTgNUVtS3MTeQktS+xNYg5+BsGDGiaFWOnSi/uCJijgnLjy/iQds4Vfr3DdnXC
         ieVuY/1LBGLJCyeNhXGZJ5KhWgMRDh63mEIzFg3CygtIxy37b/M27JJczJKRDbRKzRM/
         7oPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678612713;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b4gzSsgbZ4erZvHZjlQIpNSOpbnpH6u0xWtISBNFy7w=;
        b=tIh1/uHgFCpsWBqdavXOrYvgD0ZTGJ0kg7FgvoH50D22dDZLX2uOwJQNzUgozkODqR
         4QAUHWrSYCdRkPJ8n+rh2AHXQXBt9YcIDDjX6g6scl4woWYeXQE8/cuoXNwSW/Ts149+
         T4Tx+05040gQzg4GB38ZiIUJh6e7XUP22UsYghwvaYPQyNknD6Ca0kaRbq3FDXGrnXcY
         ti/ZHv3bjLM/B8q01NmdkeZ4+P8gKEwiULi2bI2qHSy0KEVYiWbG6RgGFMfPTVj7a/3d
         BlXn4hygyX+xRqp0FQz4mf1BIbjMPTVVdgNusaBncuXcjXa8TjfFnwE4of6cGok+x9SX
         9egQ==
X-Gm-Message-State: AO0yUKWQDaVy4EAjSl6Ux2GjPU9Ddeo0iBSDVQQMKYDMzQRWFni8VVgV
        l/bJCTI/J/LICO7ctb6PY4ZlLYTnOVo=
X-Google-Smtp-Source: AK7set/6Bn9cj43Uh+XUwi/aN4rXgYeVJ4pSUAK09opYmnFDRWDD418v7rrvte8pAVSGuAM0UP+kBg==
X-Received: by 2002:a17:906:b10d:b0:89f:1a76:e2dc with SMTP id u13-20020a170906b10d00b0089f1a76e2dcmr29598090ejy.0.1678612712757;
        Sun, 12 Mar 2023 01:18:32 -0800 (PST)
Received: from [192.168.1.50] ([79.119.240.25])
        by smtp.gmail.com with ESMTPSA id pk10-20020a170906d7aa00b008d1693c212csm2035722ejb.8.2023.03.12.01.18.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Mar 2023 01:18:32 -0800 (PST)
Message-ID: <056d7e9e-a1ea-379a-8ff6-23848a4031aa@gmail.com>
Date:   Sun, 12 Mar 2023 11:18:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] wifi: rtl8xxxu: fixing transmisison failure for rtl8192eu
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <33adb1b9-37c3-76ac-687f-97383f2101ec@gmail.com>
 <ZA12dnmhzqnAR1Uf@kroah.com>
Content-Language: en-US
From:   Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <ZA12dnmhzqnAR1Uf@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/03/2023 08:51, Greg KH wrote:
> On Sun, Mar 12, 2023 at 12:12:12AM +0200, Bitterblue Smith wrote:
>> From: Jun ASAKA <JunASAKA@zzy040330.moe>
>>
>> [ Upstream commit c6015bf3ff1ffb3caa27eb913797438a0fc634a0 ]
>>
>> Fixing transmission failure which results in
>> "authentication with ... timed out". This can be
>> fixed by disable the REG_TXPAUSE.
>>
>> Signed-off-by: Jun ASAKA <JunASAKA@zzy040330.moe>
>> Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
>> ---
>> Hi, this is my first time here. I'm not sure if I did everything
>> correctly.
>>
>> This patch should go to all the stable kernels. Without it the
>> USB wifi adapters with RTL8192EU chip are unusable more often
>> than not. They can't connect to any network.
>>
>> There's a small problem: the last line of context in this patch
>> is only found in 6.2. The older kernels have something else
>> there. Will it still work or should I send one more version
>> of the patch?
> 
> This commit is already in the following released kernels, have you tried
> them?
> 
> 4.14.308 4.19.276 5.4.235 5.10.173 5.15.99 6.1.16 6.2.3 6.3-rc1

I see it now. It wasn't there when I wrote the email (a day or two
before sending it). Sorry about the noise.
