Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2AC57A693
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 20:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238024AbiGSSfy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 14:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234588AbiGSSfx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 14:35:53 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 003534A82C;
        Tue, 19 Jul 2022 11:35:51 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id b10so4652156pjq.5;
        Tue, 19 Jul 2022 11:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=bPNoRKQ8h2ZDOuTD44jnLk8tsWeAO41TwkS2ydw/TbQ=;
        b=jdnGo14Gc1dg+16AlLMoWVN5cn6IB663ou106EHBv64+fmIyr6qJ/2Yk9T6tQs81lw
         iDX10tDTKWldNHnJZzOdDhoU8eI5iRQjYsIiji+v8tYuPHvyClvxZqQeyfbkd4WLHsyZ
         W5+hOP2v8z2h27bU7sXsrE4uTWLhcokV2TxMLtAezw7hZync5OuH/dIwyHuIHWUMYlEK
         E30SxNo1Hd7Y5UXHTOL6MxXB0Dpjd7UQ/3wQiGH3GhodTa1UqgLVk/bgvy1RsHbJ0jR7
         +6rkGdpQR5JFjlr4KaTkABJ9bOv91jX53IOs7VserNtEeAGV6/pBZo3Uc1NtS/UmQ1qq
         2T6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bPNoRKQ8h2ZDOuTD44jnLk8tsWeAO41TwkS2ydw/TbQ=;
        b=Tizg5NtovuPyH6I9Fwt59NoRN5xwOfXeJ2cX2aSvKb3qhUIE6J1Hi0aKsyjLB1e+Vb
         RbSnRK6SjNP3tEkLB2me+U16g2sHJAW4utQlQshZGcw38HXExbQCYa8HHnHD5U+IhLf7
         EcI+8XFVad6Iy7jrv+q4sSTJ93QdmmINvUOA+KRMrlx8CoNlW8bPc5sgJ53yAbMifgpG
         oyGkFN6DV+oGAzvj9yvz18fNgrbGKXy6woDa0AoZxC6X2lMWCzhz2+KlGjrXFHvx/Yb7
         nkWJAXLEq8RDCqepmD8tZ86qPOMtf5ZnC01Y+an/49k6P0p1h2aKuHBrJfH01HAkyp7R
         BjVw==
X-Gm-Message-State: AJIora8Cpz1bzX3Wk8jx881PPhhL5GtQAiA7MOGlj1Pv2rs8PNUZ1828
        HzuRaM74be/4TT/hfpSX6hg=
X-Google-Smtp-Source: AGRyM1scl4FUEsao1cWuj7dLRHf2KfCN+GENjNED/nKWOy0VmP6mAqh1zuy9jwY9DQMMT7m+eSx0lw==
X-Received: by 2002:a17:902:e885:b0:16c:49c9:792a with SMTP id w5-20020a170902e88500b0016c49c9792amr35272167plg.11.1658255751365;
        Tue, 19 Jul 2022 11:35:51 -0700 (PDT)
Received: from [192.168.1.106] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id md11-20020a17090b23cb00b001f10b31e7a7sm10150861pjb.32.2022.07.19.11.35.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jul 2022 11:35:50 -0700 (PDT)
Message-ID: <1497bc10-6cce-3a2a-0140-fee428f9d09a@gmail.com>
Date:   Tue, 19 Jul 2022 11:35:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH 5.10 000/112] 5.10.132-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220719114626.156073229@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220719114626.156073229@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 7/19/2022 4:52 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.132 release.
> There are 112 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Jul 2022 11:43:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.132-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels and built tested 
with BMIPS_GENERIC (bmips_stb_defconfig):

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
