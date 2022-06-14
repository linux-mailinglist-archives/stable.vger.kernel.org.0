Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 307A454B4C4
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 17:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344494AbiFNPeC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 11:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355490AbiFNPeB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 11:34:01 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E1C92A71A;
        Tue, 14 Jun 2022 08:33:59 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id h1so8021696plf.11;
        Tue, 14 Jun 2022 08:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=EnPbUDuBaQrV76OT972s4CnY8jbzcsT5liVfmIAajO8=;
        b=hAhN1M2wtCXkNopu9yQiZUY6RHkfK3yZLXNh0lGIAnImY6KhOWu2WfoblxHysB3YLn
         FK9TZhv7IP7byzGf5Kt8zu0Foc6umPdGV9xcEU/T7sM3NOTbA6LLemqrdmwa8y+uZbN0
         e1Rb4yFySP7jlTfBM2HrsdvcIYvI8baNzVvmAeesttK1l7pWuOibWX2d0qlMMH/SKg1e
         Ite8TQJBYo7To0SBghywPIykrUY8SYCN687eQ4UDeFcYzFI2qPlzsdbZr6Euz7km/WI2
         7GK3v2p+f/4kLGDHJ8GTBnt5m+OKwxVxFjaSJlQbDT+4mle/DVIYL2awHSXOlCYs3GuZ
         IS1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=EnPbUDuBaQrV76OT972s4CnY8jbzcsT5liVfmIAajO8=;
        b=0kgFgIVINTLqM4p5xUGaTJV4oqiP3OqYMKLGkADTLRoAgnrQQTDoEwcLrJHYhbjegk
         JCJFM5WGow74v9l2YDtxnoQSJWmXz0IUlV2VQTlTQ6bv9DDCjzou0lCE9C77pbg7/5Na
         sbAlBSyjnvjD+3ktj06XyVBaGAMN7YvGviiHaqnevUxwuJEoerT6wAXiGg/NupSGKlGE
         yKOgeg0ApW1ZmwDsIyhnn9AHaAmDHZPBEbMfLE5hGY/HTIYbVUXF6WStAGpLweNIOkAr
         QssfGxFkgX48xsMB90/Al9xtGhnPKHJYa+Wwrvrgb5CYbFK3I4FhBuDtpIRYuRBZv/Qx
         dygQ==
X-Gm-Message-State: AJIora/9EmAfQDe+5iNg8GrBURKEjjCI3wILsGf6ZI6M5ud5BxVoSrCu
        XGLR+3n/+i0Yh5KFwMbQ4Po=
X-Google-Smtp-Source: AGRyM1ufDMm81VCpIqb+lHG6sK0za9IiPVuXZzpO3uF9uOkedQpayLeAcW1ZjwA6D9KQUG2mcyWbJQ==
X-Received: by 2002:a17:90b:341:b0:1e0:cf43:df4f with SMTP id fh1-20020a17090b034100b001e0cf43df4fmr5217372pjb.126.1655220838780;
        Tue, 14 Jun 2022 08:33:58 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v18-20020a170902e8d200b00168dadc7354sm5186665plg.78.2022.06.14.08.33.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 08:33:58 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <d993bbb6-e583-5d91-76c0-841cc5da86af@roeck-us.net>
Date:   Tue, 14 Jun 2022 08:33:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.18 000/343] 5.18.4-rc2 review
Content-Language: en-US
To:     Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220613181233.078148768@linuxfoundation.org>
 <CAK8fFZ68+xZ2Z0vDWnihF8PeJKEmEwCyyF-8W9PCZJTd8zfp-A@mail.gmail.com>
 <YqgsDXdY3OttH8Mc@kroah.com>
 <CAK8fFZ5SP4zAra2X8B3Q9zkhQGMfif+y-oEvkpR4fDpL8_upKg@mail.gmail.com>
 <YqihnavPcyzMMw8l@kroah.com>
 <CAK8fFZ4JnhA3s8e4YDp_+GOq5+p4YzRtKdEFzjogtXc3EBttzw@mail.gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <CAK8fFZ4JnhA3s8e4YDp_+GOq5+p4YzRtKdEFzjogtXc3EBttzw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/14/22 08:03, Jaroslav Pulchart wrote:
> út 14. 6. 2022 v 16:56 odesílatel Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> napsal:
>>
>> On Tue, Jun 14, 2022 at 04:41:31PM +0200, Jaroslav Pulchart wrote:
>>> út 14. 6. 2022 v 8:34 odesílatel Greg Kroah-Hartman
>>> <gregkh@linuxfoundation.org> napsal:
>>>>
>>>> On Tue, Jun 14, 2022 at 07:56:36AM +0200, Jaroslav Pulchart wrote:
>>>>> Hello,
>>>>>
>>>>> I would like to report that the ethernet ice driver is not capable of
>>>>> setting promisc mode on at E810-XXV physical interface in the whole
>>>>> 5.18.y kernel line.
>>>>>
>>>>> Reproducer:
>>>>>     $ ip link set promisc on dev em1
>>>>> Dmesg error message:
>>>>>     Error setting promisc mode on VSI 6 (rc=-17)
>>>>>
>>>>> the problem was not observed with 5.17.y
>>>>
>>>> Any chance you can use 'git bisect' to track down the problem commit and
>>>> let the developers of it know?
>>>>
>>>> thanks,
>>>
>>> I tried it, but it makes the system unbootable. I expect the reason is
>>> that it happened somewhere between 5.17->5.18 so I'm using an
>>> "unstable" kernel.
>>>
>>> Is there some way I could bisect just one driver, not a full kernel
>>> between 5.17->5.18?
>>
>> How do you know it is just "one driver"?
> 
> Just a quess based on "git grep". The error message was introduced in
> the driver in 5.18-rc*.
> 

The message was introduced with commit 1273f89578f26 ("ice: Fix broken
IFF_ALLMULTI handling"). Given that commit message, it appears to be
at least somewhat likely that reverting this commit will fix your problem.
I would suggest to give it a try.

Guenter
