Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1EC54BFC4
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 04:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237233AbiFOCrA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 22:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235610AbiFOCrA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 22:47:00 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6859649B40
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 19:46:59 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id q1-20020a056830018100b0060c2bfb668eso7914487ota.8
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 19:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lC2aW9m+sCsaY8ENSg+Iq1e/uSllSgVY2V4gRPX05YI=;
        b=XMYWouVY01vv3esFUIZQsXrdCp0knmBSLJAs/HOot4ICBnzCJ8/1d7NNP8QP0Nl73H
         DmzhRa+X/+U7xZSFZrvObyZdLD3SLABY0xmR/LAEirOwqj2SPwhDC+r3dFXE9PzHqzK9
         cC4wImUdSfMF/FsuI9z2Eu7s57UpyjpDZm+NQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lC2aW9m+sCsaY8ENSg+Iq1e/uSllSgVY2V4gRPX05YI=;
        b=glsLVZoAEY2v1oxazJeWaf64IIUyVX8/UpnTkIqVFbmMDtXN8gz+cRSPG65hFIgNdZ
         uqa/sgycPwHdOg9eW+/twKWamNDFMmM8GLjLO6DTHkAbWv6srKUdwt4yg5omPzBD3ica
         QQWACjASRmrTlr3LGtEFdf+J6WYalY7Nb2LCUJ5imJPBUQ/vR4u8GPBEwwevGTa3Sqhu
         Xw6XzV8OKTjNofAXgNYwJInu/VDfgr+XEU59FRvl9DdxoJ723znVkkhLvvGal+r8dBSp
         bIMLes7f2ksZC/SiHZFCcG85pskIRcCTBQsU3+Drxqm8aCfJXFQzLaXiwkWCvg7FOdGF
         MLPw==
X-Gm-Message-State: AOAM531leg0DU08/1Pc5Yl/OrL/DrkmTPgWF+i2cH466nX+lqbOCxUev
        aQ2KKBwwSfSBxhDpVi59sdCUeQ==
X-Google-Smtp-Source: ABdhPJxgyPr6uHsivdG++8B+MJPcLPg/AysQ+2MFi4kMjS/iOGFw7oyHTXDZwcqPOpC6FYioaCJ/9w==
X-Received: by 2002:a05:6830:925:b0:60c:6c96:2366 with SMTP id v37-20020a056830092500b0060c6c962366mr3348324ott.54.1655261218710;
        Tue, 14 Jun 2022 19:46:58 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id bc15-20020a056820168f00b0041b8070a784sm5967882oob.5.2022.06.14.19.46.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 19:46:58 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/11] 5.10.123-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220614183719.878453780@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <f9d61d0f-dfca-b774-8c99-ba5974beaf64@linuxfoundation.org>
Date:   Tue, 14 Jun 2022 20:46:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220614183719.878453780@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/14/22 12:40 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.123 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.123-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
