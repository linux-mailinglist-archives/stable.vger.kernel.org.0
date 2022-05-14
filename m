Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 547F7526E65
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 09:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbiENDC5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 23:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbiENDCv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 23:02:51 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A951821266;
        Fri, 13 May 2022 20:02:16 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id cx11-20020a17090afd8b00b001d9fe5965b3so12397761pjb.3;
        Fri, 13 May 2022 20:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=r995hMsKjxPDOPWj7IefzfQ4dcnkbqPB7PakkBYcRE8=;
        b=dkj4eutwlFRAm9F9U/EV2d09kF/rGK6RlnhcFpDsqJoj8P/F9iLuj5AlK02V880VTn
         VpenBLTyavq9vflC0QVJ3lHED/wvC0GEeiRFenFx9ZJAX7KX0obE2w0pYsGALK0NP3Z3
         CWtmiuzcXXI4YqJXNqsPImfWydZKDL+oB2JepAoMjQERy13OZteMxEuqSbyEAdZKYLRO
         idJ4DE9KJkk5/6vBEGRS+fv0+h6yFbO++FOgU2scHZChLhWO0lVuBr5TG7paFwprkIaZ
         +/9gB0b1DGaWM8nYMXx5UhHu7CaINXTiwGHNR8sQZzqSluxgbElznUMGDyqe83r09FJe
         E2fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=r995hMsKjxPDOPWj7IefzfQ4dcnkbqPB7PakkBYcRE8=;
        b=5bkzF2C0B+xaguacmiByixMUhBimftb6k1gMQBQ+RgAsLqPnNlaDGsto3c4Zqmrky6
         wBOiVh9XU1oajMRkllwwOyKOgbhrsmt6iOFhgSxZ+ooS/aHrdxAIdxU4RSExIjZBTFNJ
         Fl6iI3YAwkOWgo7VkqIaDv37l1R0JZ473i240QcMbzUsqgwR2WBPcjbkT0ZfLR9h7NTN
         wYnrIgTRG0pN/bBKjNXn9zT9Rr3bK26Hsbrl6BV0uccXfa/44aGmYjHU57VVf4abosgf
         bwMtcgvorLIP4YIYa7BWusskiDBB9JDkN9tiUgtEA2oO9Hh2krQMSABcixlZ7178Uobs
         7F5Q==
X-Gm-Message-State: AOAM531Z63+KMYppoQwDu6rIVLSyU3akcCtIxmjL1uA1QN/kWJvv88nP
        FvaQ5RwIr9AOgyiyXuOhsOk=
X-Google-Smtp-Source: ABdhPJyDziaw1rn2TFpbrCp1jGg5kmpdnZQIe2oIJRnAepUxSTRLIZr0MwEo9Z6yVBisvunq3ZteGA==
X-Received: by 2002:a17:903:2481:b0:15f:249c:2006 with SMTP id p1-20020a170903248100b0015f249c2006mr7650578plw.31.1652497336141;
        Fri, 13 May 2022 20:02:16 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id f125-20020a62db83000000b0050dc762812csm2498303pfg.6.2022.05.13.20.02.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 May 2022 20:02:15 -0700 (PDT)
Message-ID: <a7d29ef5-4f4e-d8d7-34bb-652b0b33978f@gmail.com>
Date:   Fri, 13 May 2022 20:02:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.10 00/10] 5.10.116-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220513142228.303546319@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20220513142228.303546319@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/13/22 07:23, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.116 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.116-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
