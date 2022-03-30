Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3774EC6B0
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 16:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243573AbiC3OkA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 10:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242262AbiC3OkA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 10:40:00 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A6E4AE2F
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 07:38:14 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id h23-20020a17090a051700b001c9c1dd3acbso129563pjh.3
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 07:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=kVuNY7Sqe14PGOhB/TNhbJjSDccyFmB85NS7tUYn7n8=;
        b=B7wWXyO44NzUYxcmJmsqEENB+Dv8S176olzGL3Pqzu0H4W+yofbrPNnejBh7+DqWAS
         UzaqhFSnzyi37Xc0La3XEAapLLbUHfPa45Xurw6bNQG4a8dipnknOnjOgojft6/gKm68
         GljnoVV7yf53XdesHh0wqdywrN0RcKcB7DMnPBSIVM4HWvrW1WGYztDgvLvGKIWn+Zh6
         VG8M4vKVDqeVSdaEBZw1Anf2cNNCq+GKfbrzIC8gF9GWzE53xrKSyryszW4oms4KhSOS
         wj0ogI8A2ea2cTC9rfdNp9fQlqV79p89XMOUDLWq9uacNofQmfv8GQff6qvWQt4PDRHI
         YAag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kVuNY7Sqe14PGOhB/TNhbJjSDccyFmB85NS7tUYn7n8=;
        b=4b1mR1EF5cWJmykU94Q3yq95MKuzoQzWqY878DHv9vJYYc8qxuylPRFqpEMFJX7M2r
         LVLC16ktTsBlq2uIcYH7KHS4ZdE4ha85MIhvWjP3O8xhIFR4RtmdvqyW07/UE4faYoW5
         TMAXoyAGu+Oivpn6K9pM3g7wKlO+BTpOBNdfDBm+Sm/PcWsdplJiGoAfZtWB2VEpwa28
         lb0m292UgZNp3GbtCy6SaRIrh8R/+NMmt6s1aHcw6dpm4Un8Qxw8l4bnQJypBTdC+BuN
         gwVKBlhkZPhuqXcy0Qwi0+/mvYCniz1ChXSXvjItJ3SK4D6gYpOkLiA3MqwPRWefwYN0
         ZwGQ==
X-Gm-Message-State: AOAM533rXBuZwBaDT2erqGXzA50xrZQoZJuILBb08ZbrDJr6wIWgYhsC
        PfjwVfuwUzW45A+AcsGONA3m1bafYgIXMi7rmqo=
X-Google-Smtp-Source: ABdhPJy9584x8ya2gY0BLFxFzSqa8xUA2J7rSIYnJaIFfpC/OAqVGghpnl1X3MAL5gbXDiqasH32jA==
X-Received: by 2002:a17:90a:e54a:b0:1c9:7ee5:abe with SMTP id ei10-20020a17090ae54a00b001c97ee50abemr5502177pjb.128.1648651094277;
        Wed, 30 Mar 2022 07:38:14 -0700 (PDT)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id i62-20020a638741000000b00398b43168f6sm1207995pge.20.2022.03.30.07.38.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Mar 2022 07:38:13 -0700 (PDT)
Message-ID: <fc9370b1-274c-00f3-0734-4f1d271b98bf@linaro.org>
Date:   Wed, 30 Mar 2022 07:38:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 1/2] stddef: Introduce struct_group() helper macro
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Keith Packard <keithp@keithp.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kees Cook <keescook@chromium.org>
References: <20220329220256.72283-1-tadeusz.struk@linaro.org>
 <YkPgO5dmsl+BQzXC@kroah.com>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <YkPgO5dmsl+BQzXC@kroah.com>
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

On 3/29/22 21:44, Greg KH wrote:
> On Tue, Mar 29, 2022 at 03:02:55PM -0700, Tadeusz Struk wrote:
>> Please apply this to stable 5.10.y, 5.15.y
>> ---8<---
> 
> Why?  What problem does this infrastructure solve?

It is required to enable the PATCH 2/2
("skbuff: Extract list pointers to silence compiler warnings.")

-- 
Thanks,
Tadeusz
