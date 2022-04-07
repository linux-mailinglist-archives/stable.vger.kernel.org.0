Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54A764F79EA
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 10:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243170AbiDGIhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 04:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243173AbiDGIhE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 04:37:04 -0400
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9EF27660;
        Thu,  7 Apr 2022 01:35:03 -0700 (PDT)
Received: by mail-ej1-f52.google.com with SMTP id i27so9277248ejd.9;
        Thu, 07 Apr 2022 01:35:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Tr4Zz32fDjxFzXKC0Q2/00xloV2k6LUv3oxEGpw4WnE=;
        b=S1etPt28JB531Qq9crVPdg8jmPDGDy9X1CK2ssE3EY1ZF4iuS783rEcyHJK6dlTydA
         rxQiaeFagFL7LCd2x/7S9BDH1k3NyypWvz+ahAIzB/HLeGd7BTyjpIPQeO3dHhVAzJk2
         RAouvfyktd8yE2NVQIIkxYcyQnxWkr+Ylrp8+OtJcnwa0aCjvWBdlpsArZwqMdj6AStb
         WlWGO6s4ZrJtko0bsobkVFnoM7OVgGYJOtP2i9OKLhPnE842RxyMSgnra8preo0h9k5m
         l9PyEIzl4u0E/JVZ4DQ1eo0357tPRzEGcfEIlxiZZ6uDR4uCy4S1hs4HEL1AsH+em4rZ
         k7ew==
X-Gm-Message-State: AOAM532gC1HqVlH8zr8NZ7EsbVZoyO+Slme8jAnv77wh/4nSLixY6XQd
        RqXvp5pdMP4V9r95HyrUaMI=
X-Google-Smtp-Source: ABdhPJy+qjxdbstLkjc+zvK1U7WerGYjW6YueKSrNFS2Ewd+J4jF9ZW90Wae8sB2BBDjppOaqDgmVA==
X-Received: by 2002:a17:906:ae57:b0:6e8:30cb:2596 with SMTP id lf23-20020a170906ae5700b006e830cb2596mr2507515ejb.204.1649320502308;
        Thu, 07 Apr 2022 01:35:02 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id kb28-20020a1709070f9c00b006d5d8bf1b72sm7340288ejc.78.2022.04.07.01.35.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 01:35:01 -0700 (PDT)
Message-ID: <f0f09501-6d78-3e6e-bcf0-085806b59bc3@kernel.org>
Date:   Thu, 7 Apr 2022 10:35:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.17 0000/1123] 5.17.2-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220406133122.897434068@linuxfoundation.org>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20220406133122.897434068@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06. 04. 22, 15:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.2 release.
> There are 1123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Apr 2022 13:27:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.2-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y

All green with openSUSE configs now again.

Tested-by: Jiri Slaby <jirislaby@kernel.org>

thanks,
-- 
js
suse labs
