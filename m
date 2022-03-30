Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB924ECA1B
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 18:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346902AbiC3Q4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 12:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345089AbiC3Q4v (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 12:56:51 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA0E36B59
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 09:55:06 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id y10so15972427pfa.7
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 09:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=rkhK0E47U2bD5cHUrefr/FDASdAvPAtiLAN2iSS8x1Y=;
        b=p5G6lo+Q3EY61D9bYIF21FBCVrxt+H8Kmv/j4iFeEyMCyd5z1ln68WI7J3M8zMY2SZ
         7gJ3cR9s/9bacJ8Lj476U7Ta2g2sxkIV4KxVni6yDKLvHwac/Xp54fNleCc7OrK/b2xz
         jvyGFuw25K0YtHCQfTpwt+k7NTGh7LgqlF6eowXelF/QkTrgr4XBmOYnSWV0oB1rX7Wm
         LuRU+OVz4VT747HvqMY4XT/9pyKUfTrloqOxFTG6hBB/1IC6s25aChSU72DIFXJLoITJ
         8PMP5hxyAzoAkKdX902FeiCH81QH7kLlC1eouylOo/dq3DMqQgUdSDCDr/RaWGMFMbBB
         U1vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=rkhK0E47U2bD5cHUrefr/FDASdAvPAtiLAN2iSS8x1Y=;
        b=iksR1HccC8l9iIWXfNkC1CN4PQ7htuT7s4k/TpWPgrLALj5d6cDNhHpzapH3o6m4zt
         gk+UlGZHunpbPSbeR549ejuvv8B1al3k9tIowzUvSmuABMon3yT6AvXLeII8wGFdLlML
         9aZNdFvW17dJOHp4FvG/vmsW3hLqIFi+lU27D6sT376elgFECyULcrRTWqPYLPDGYKaA
         qYd3Uca6Sqpbm7sbCgm1V5Fgqo4wDIpu81VzCIYpHs73BxdbaKBAR4xOa5ZPN2/M5shT
         QheTWXC+ZGpsCVpfCeJPvTwThpsmemNPU2xwzztipLyjgIBQCH5b0Ih6ZQrklU5dyDne
         v6tw==
X-Gm-Message-State: AOAM5332w2yNbujbeBrda7tiGuzRYxtWZXonOS3O3RzXgrOufwAY8ZjE
        vWJ2dw7hQbxIJx8FJLtnU5xP7A==
X-Google-Smtp-Source: ABdhPJwlIIVX9hXGI2jS2yRenJJpbToHAAgOTMW4D/ia3WjX5Ck7+6N7KWyTh++BnK95MmQe5Kd3nQ==
X-Received: by 2002:a05:6a00:1c95:b0:4fc:da3c:518e with SMTP id y21-20020a056a001c9500b004fcda3c518emr444989pfw.72.1648659305492;
        Wed, 30 Mar 2022 09:55:05 -0700 (PDT)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id v17-20020a63b951000000b0038644f62aeesm18634763pgo.68.2022.03.30.09.55.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Mar 2022 09:55:05 -0700 (PDT)
Message-ID: <6049e57e-46ab-001a-8e43-3a7acbc1fb33@linaro.org>
Date:   Wed, 30 Mar 2022 09:55:04 -0700
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
 <YkSHOIOUwweHuog9@kroah.com>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: Re: [PATCH 1/2] stddef: Introduce struct_group() helper macro
In-Reply-To: <YkSHOIOUwweHuog9@kroah.com>
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

On 3/30/22 09:37, Greg KH wrote:
>> ---
>>   include/linux/stddef.h      | 48 +++++++++++++++++++++++++++++++++++++
>>   include/uapi/linux/stddef.h | 24 +++++++++++++++++++
>>   2 files changed, 72 insertions(+)
> Any specific reason this backport dropped a whole file from the original
> commit?
> 
> You can't send me modified patches without mentioning it, otherwise I
> assume you are doing something wrong:(

I dropped the updates to scripts/kernel-doc. I didn't think it was relevant
for stable. Here are the original stats compared to the backport stats:

orig:
  include/linux/stddef.h      | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
  include/uapi/linux/stddef.h | 21 +++++++++++++++++++++
  scripts/kernel-doc          |  7 +++++++
  3 files changed, 76 insertions(+)

5.10 backport:
  include/linux/stddef.h      | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
  include/uapi/linux/stddef.h | 24 ++++++++++++++++++++++++
  2 files changed, 72 insertions(+)

Do you want me to generate a new version with all three files?

-- 
Thanks,
Tadeusz
