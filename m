Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3804EC7A3
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 16:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347675AbiC3PAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 11:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347703AbiC3PAo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 11:00:44 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4A16599
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 07:58:59 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id j8so10471081pll.11
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 07:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=1VLp2VWnZ6zlMXeUck4cWxYwR/OF6OKfS2Jt+as28C4=;
        b=cHxbuI9aqAFojyZYh3XcOMsn3V+PzZ0BqAmGAQmyRW0r0rTJS3IVLvYu0TyYT710K3
         aOLH8Zp3wBWpKtO+IJ6vQDGvwrLf2QCQNnH6QytPpCxwQCpAA8ggDDgFZfUJ/splbIth
         TkZh5nuDKRN6iscKM0oIaUBdaYrKGYD4cJ0j2eUGYtL1Nip+dN+HMcqdFf2iyYkanNDF
         e8u5+JTJVJA0DTWnabm8/Hv4tOA1m0m3G9MgKu/LxG0fwzpK4muYIQdKD3klpd2Uw1Rt
         Krcblpct3fO30DTVqmZL84aNsOLMybDZLOUbSy0qwGt4i9kOaol4i8/M2fBN020t0hTf
         hH0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=1VLp2VWnZ6zlMXeUck4cWxYwR/OF6OKfS2Jt+as28C4=;
        b=epfGplnKBZNKR9KYjAPLGERlMEeZrcBoG/7nPGX67gfwx+BqPmJk9Lmq2tb3Jg7sPx
         ZDVjqnJSwNmBfG3BqR1A3FSqx6k5sj0sVrNCGiXxa1uUFSwp2JJADAIK2j1iPbte8n1Z
         Yoa/ev2MUmIFsws4j6rzCUkvYGxo8wxG0kpl34HTILJpLP9Syaffuyy9bmLk+V8Oxksd
         L+S/fSXc38JRdXdHY39ybzZ1YaNLtSM+kZvpV7NHDqO3kDC/3A1NORuPj44DV0mssH/0
         hWENyoHD9mtNN+3rT/QsWcgcsar+U/1bWUFChu1P2sjs1p6pGCt4RAvhO68a1NLVAbrA
         i+Cw==
X-Gm-Message-State: AOAM5313jKWmY096ZYXfahzX+4c0dAWGivbTjoAvzOfTHqY9tYWW/5Ep
        DkAP1Nf2GUb243jU1l6CftLJy5/TKHFZHBGBKlk=
X-Google-Smtp-Source: ABdhPJyBZ3xl3SyhvqxQ0Y5HPIqOSo6wL676XexB++1crfDMFjGlbfCr0uWgxfJJY2E5GOgfBFS5dA==
X-Received: by 2002:a17:902:b704:b0:156:624:934b with SMTP id d4-20020a170902b70400b001560624934bmr22399pls.116.1648652338616;
        Wed, 30 Mar 2022 07:58:58 -0700 (PDT)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id u18-20020a056a00125200b004fb112ee9b7sm18546842pfi.75.2022.03.30.07.58.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Mar 2022 07:58:58 -0700 (PDT)
Message-ID: <7f0f8140-3e4c-ddbf-158b-d3dd0525aa68@linaro.org>
Date:   Wed, 30 Mar 2022 07:58:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
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
 <fc9370b1-274c-00f3-0734-4f1d271b98bf@linaro.org>
 <YkRtFpMlNUUH2/7/@kroah.com>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: Re: [PATCH 1/2] stddef: Introduce struct_group() helper macro
In-Reply-To: <YkRtFpMlNUUH2/7/@kroah.com>
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

On 3/30/22 07:45, Greg KH wrote:
> On Wed, Mar 30, 2022 at 07:38:12AM -0700, Tadeusz Struk wrote:
>> On 3/29/22 21:44, Greg KH wrote:
>>> On Tue, Mar 29, 2022 at 03:02:55PM -0700, Tadeusz Struk wrote:
>>>> Please apply this to stable 5.10.y, 5.15.y
>>>> ---8<---
>>>
>>> Why?  What problem does this infrastructure solve?
>>
>> It is required to enable the PATCH 2/2
>> ("skbuff: Extract list pointers to silence compiler warnings.")
> 
> That wasn't obvious :(

Yes, sorry, my bad.

-- 
Thanks,
Tadeusz
