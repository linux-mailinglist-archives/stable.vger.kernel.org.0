Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA3B59AAB4
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 04:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242436AbiHTC3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 22:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235135AbiHTC3c (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 22:29:32 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB7C89A983;
        Fri, 19 Aug 2022 19:29:29 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id e19so4952730pju.1;
        Fri, 19 Aug 2022 19:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=h/HJ65cb2+nIGwhv5QH5QTgJ4jWxy0giXVXsSHB7yko=;
        b=iuCRhwHvRBHWpZ+AfOlPMiIE4kR6hweHfR1SBEN6YW20gjBM2ixZbR8hui4zb1FfIH
         KONz0WtxxHeYRsbXWN+bjJviEfSFdSqRGJdlYqSqh5cRn/Px1liqn3nUwC/MUpWEDAEN
         WlbKswo9JvZGBBdDfcbkhIz9dANcSE7v1j1JETjYFPobMcWHjdOPimg+iKnFUaGrIEgX
         vtxMk8zhKjKbYER1nFnXhJikpbg6sBLINjhe6EkPkFRBJsyYXLaD+70sjpXYUbpihqFO
         deEFYRZKvN3dcYDAA4FHkW7+m5urs0X7b06MlsxndKKUnI27es9IuyGrEWZ22Fw4uaIR
         6hEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=h/HJ65cb2+nIGwhv5QH5QTgJ4jWxy0giXVXsSHB7yko=;
        b=XhgXjcXJsXyQAqflS5yS9pdNI9rNlKFJYFTx7eoOr7GXIBiyTLujLHBAtBRPYFN7uF
         yjTjCdL6ipVk9g8V1G1k4kJhDYzzxuR0pkKkbDRyN2BmLfbSPOyoH/iiExwG5UJsLwqE
         jjskp4dkGAwnx5Cem3hviRfu1H/NOwO7c6vl67Ebqv9n2DYRwWrM5nEMQlr1ylbnro7x
         8/r0d0jgA264KJ9S/w4bFPPI9UqWh6y3HuWkiW78jUqukJUxKLBnIwWhTBDVaN51WbL1
         7o3SBVqgdrNMnuz4OysoJAPh1XPBJVaugqDbfA36kY4Xgi4dXhas2rhzptfSdw/h7uJj
         OAFA==
X-Gm-Message-State: ACgBeo3q4z0boSiHYrBvCGWnJaJ6CLUS8gqfrzcbLuOS2YLkDsUzvmdI
        5/vOW2N/tOkQItv9KW+31PsyG0qZ+eg=
X-Google-Smtp-Source: AA6agR6Zpo21opq2l8HWg7HLYMOJyGVGl/tr0rum0zXAixFaKrG0xIztTBKPV4VCL7tZ2YidfzXR0w==
X-Received: by 2002:a17:902:ef96:b0:172:abb9:657e with SMTP id iz22-20020a170902ef9600b00172abb9657emr10056786plb.48.1660962569323;
        Fri, 19 Aug 2022 19:29:29 -0700 (PDT)
Received: from [192.168.43.80] (subs02-180-214-232-69.three.co.id. [180.214.232.69])
        by smtp.gmail.com with ESMTPSA id u6-20020a170902e5c600b0016d88dc7745sm3793478plf.259.2022.08.19.19.29.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Aug 2022 19:29:28 -0700 (PDT)
Message-ID: <69366c8b-9bbb-7d4c-4d0d-4948d04e71bb@gmail.com>
Date:   Sat, 20 Aug 2022 09:29:24 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v2] mm/damon/dbgfs: avoid duplicate context directory
 creation
Content-Language: en-US
To:     SeongJae Park <sj@kernel.org>, akpm@linux-foundation.org
Cc:     badari.pulavarty@intel.com, damon@lists.linux.dev,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20220819171930.16166-1-sj@kernel.org>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220819171930.16166-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/20/22 00:19, SeongJae Park wrote:
> From: Badari Pulavarty <badari.pulavarty@intel.com>
> 
> When user tries to create a DAMON context via the DAMON debugfs
> interface with a name of an already existing context, the context
> directory creation silently fails but the context is added in the
> internal data structure.  As a result, memory could leak and DAMON
> cannot be turned on.  An example test case is as below:
> 
>     # cd /sys/kernel/debug/damon/
>     # echo "off" >  monitor_on
>     # echo paddr > target_ids
>     # echo "abc" > mk_context
>     # echo "abc" > mk_context
>     # echo $$ > abc/target_ids
>     # echo "on" > monitor_on  <<< fails
> 
> This commit fixes the issue by checking if the name already exist and
> immediately returning '-EEXIST' in the case.
> 

Meh...

SJ, I have seen most (if not all of) your patches uses descriptive mood
instead of imperative. Better say "Fix the issue by checking ...".

-- 
An old man doll... just what I always wanted! - Clara
