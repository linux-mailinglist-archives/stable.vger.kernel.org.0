Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44E2E4C7E66
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 00:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbiB1Xag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 18:30:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiB1Xaf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 18:30:35 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E1E13F29;
        Mon, 28 Feb 2022 15:29:55 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id c9so12067508pll.0;
        Mon, 28 Feb 2022 15:29:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0ah+EiT/Kv9UMvjfGktqGGOLIqsvdmMBt3Nl7Zdj3R8=;
        b=nfVkLbNiWmQSjZbxY8wT62wc7lC6XAZbYiAy0S1SvWET0+kaXtxYZTtYgypoRJhHGQ
         541fooDwqy8YVK85WQOHv9h3F7N0CTDgZTaK00jrteA9jYvr32vBIBnTmYbm/5ozLYG2
         6JQloPMAo0z60zgYgLDyakFuD3Y6hymYlcTOI6hpCYg2zzO9MZLySMZk0nzmAGzsVI/h
         snmojgqEtmvQyivNtG5uNbVeDAEN6GOVk9z3utM/iphs36xoCE5XLUtTc17eqgQC9Jip
         +qcSx188onuoXhZPQXIh9ALlpYDjUZH9z3OZqsLTV25wAaRNB16RSQV0G4f1023PpmzZ
         qzeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0ah+EiT/Kv9UMvjfGktqGGOLIqsvdmMBt3Nl7Zdj3R8=;
        b=cQ92ntZIQW+d/0rgwdEAK79ZAcNWf+RrwzyL5G0K0JHmEdKIc29ElUtZ5VwuO9a6lu
         ZlaqW7JwPai56FUgI4LRUy7N94s5MaX2EWYFlsAKq0++/g2oZZ2rxcZWRr573ShIn3Wg
         sqI0n60DXfkN/7qoX1I9PN3OkYM9JEKfwjeY45c4rIjcmL+YkIRFZVyzGrorGYpenSBA
         lgNZg7reVzO71hu37yjGISF3BQnAfGPH3H+5kpjtXiYrwP0exFyf0HnWuQ3t2bQ29BlY
         Bsa2x0/DD0XizseZ971v79wXW9rzbQjAKMQAInsCoTMSsE+zHWQu4xJK7CN88OhKAsl5
         KqtA==
X-Gm-Message-State: AOAM5315tZfWae20ANAkiBq5AKIhfLyyGrn/1HszkZ8p8VOHAWhyo4nU
        sSqelgSF7zMd4EnRumDOGsg=
X-Google-Smtp-Source: ABdhPJxx+AnM1o5a4G1Gjo3xylTI7+FQnHZciuCbGmpKTItb0k488E2t3F0ezWmYmzJdH5/87e+9nw==
X-Received: by 2002:a17:902:da8c:b0:151:76bc:6df7 with SMTP id j12-20020a170902da8c00b0015176bc6df7mr2963561plx.85.1646090994867;
        Mon, 28 Feb 2022 15:29:54 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id u15-20020a056a00124f00b004f12b8c81ccsm14646530pfi.75.2022.02.28.15.29.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Feb 2022 15:29:54 -0800 (PST)
Message-ID: <8d517b7d-a52a-a029-1754-055d28e76cfd@gmail.com>
Date:   Mon, 28 Feb 2022 15:29:52 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH 5.10 00/80] 5.10.103-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220228172311.789892158@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220228172311.789892158@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2/28/2022 9:23 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.103 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.103-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTb using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
