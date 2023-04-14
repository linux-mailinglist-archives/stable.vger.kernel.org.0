Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE446E1D7C
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 09:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjDNHv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Apr 2023 03:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjDNHv4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Apr 2023 03:51:56 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFAF944B2;
        Fri, 14 Apr 2023 00:51:53 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-63b5312bd4fso1690229b3a.0;
        Fri, 14 Apr 2023 00:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681458713; x=1684050713;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=K5rTwOdgFJZZPJX3fXkfiAvyTbB7Q3vbD/59Gc9iVe8=;
        b=HAc5MiWnDnFtyBTlxHKLzbEMGTFyAgbTTZrlLdU0FS9A9k8jl+iq0lngjS757FM4Xy
         i0w8Hi4GZw8epIIPNjnmIMfIKwRn7hROlz19QTFX7BCm9js9koBzidT+Gm9ZguRlYwvp
         26xrtKFt96+vQQF4h7+I5ULtIAd1G8Nu6rMFRxF1x8fj4hF+2So/uPj6KrnH4TO4YbZL
         cVZbPVUkhNcZIaEgGOaGJw3KuI8rGhO6T17WED5BTImY4B4TTHQrPVJTxEP2oD4iW1jC
         SDf8h8VqGBW+Dv1OXtmO7ceK80U6n6UsqnHsocaz63WYTpkBjxmGIQL+JI9mVEqiVkIt
         evpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681458713; x=1684050713;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K5rTwOdgFJZZPJX3fXkfiAvyTbB7Q3vbD/59Gc9iVe8=;
        b=iXm3+NbflZ+wNzni15Vwu6iyzj4AivLGGZc/XI6nvzGjRvQrgsE1dnzZ04HD6xOA7H
         84cWld4IxEzYwfxJ9Mdja1AhNKGO5NaDXPr5EjA7Gh/zxky0x2o1zQDudCgNJlTBkML9
         sKzRzpL2YnpPqX+dT4KQK8bjgo8usz7GkP5jg6dyuhcK1p6vs3Jh9oEOKLxAbQ2v3uyN
         6DPb7T3Aa8H9FxQni50tdaBlUwKw2ApAj+/zgkZrPZVdklQhlYl2cTdb9lHvAoVMJ0/8
         kM/MbhQfmYf78vk/DRE0hgcy+BzcMWKs6T5rqmdrjmVpXLbG1ZMsE1xbKynBuhGw/vqI
         aHFQ==
X-Gm-Message-State: AAQBX9cd07Wrrz+4rJglbAc4rWZSPxRl1C18g7+lNczhYsAKi+w9/lIa
        027gVgF14vcPAp4Hv/0ia8XJPblogQY=
X-Google-Smtp-Source: AKy350ZnWysc0UeSs48nYjpcN4LkbUG3Rcp4C3XtxQgqKYU5gC4EHhKTSZrUqgds2FWiCaEDRaEu0g==
X-Received: by 2002:a05:6a00:430e:b0:62d:d85b:fcfc with SMTP id cb14-20020a056a00430e00b0062dd85bfcfcmr10116197pfb.8.1681458713036;
        Fri, 14 Apr 2023 00:51:53 -0700 (PDT)
Received: from [192.168.43.80] (subs28-116-206-12-58.three.co.id. [116.206.12.58])
        by smtp.gmail.com with ESMTPSA id g14-20020aa7818e000000b005d61829db4fsm2465430pfi.168.2023.04.14.00.51.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Apr 2023 00:51:52 -0700 (PDT)
Message-ID: <5f445dab-a152-bcaa-4462-1665998c3e2e@gmail.com>
Date:   Fri, 14 Apr 2023 14:51:47 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [REGRESSION] Asus X541UAK hangs on suspend and poweroff (v6.1.6
 onward)
To:     Acid Bong <acidbong@tilde.cafe>, regressions@lists.linux.dev
Cc:     stable@vger.kernel.org, linux-acpi@vger.kernel.org,
        Thorsten Leemhuis <regressions@leemhuis.info>
References: <CRVU11I7JJWF.367PSO4YAQQEI@bong>
Content-Language: en-US
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <CRVU11I7JJWF.367PSO4YAQQEI@bong>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/14/23 02:35, Acid Bong wrote:
> The issue appeared when I was using pf-kernel with genpatches and
> updated from 6.1-pf2 to 6.1-pf3 (corresponding to vanilla versions 6.1.3
> -> 6.1.6). I used that fork until 6.2-pf2, but since then (early March)
> moved to vanilla sources and started following the 6.1.y branch when it
> was declared LTS. And the issue was present on all of them.
> 
> The hang was last detected 3 days ago on 6.1.22 and today on 6.1.23.
> 

Have you tried testing latest mainline to see if commits which are
backported to 6.1.y cause your regression?

> # regzbot introduced v6.1.3..v6.1.6
> 

Anyway, I'm adding this to regzbot:

#regzbot ^introduced v6.1.3..v6.1.6
#regzbot title Asus X541UAK hangs on suspend and poweroff
#regzbot ignore-activity

Thanks.

-- 
An old man doll... just what I always wanted! - Clara

