Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4E396B232F
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 12:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjCILiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 06:38:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjCILiE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 06:38:04 -0500
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 819441E29F;
        Thu,  9 Mar 2023 03:38:03 -0800 (PST)
Received: by mail-ed1-f49.google.com with SMTP id cy23so5600104edb.12;
        Thu, 09 Mar 2023 03:38:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678361882;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mM1ayM67gmODluLDBPt8vqT0sHU0TAIuRWhypzrZ2jE=;
        b=GDn5d38P4ioAZWv9s7FkPItbTnNOwgu9NxMm5EbotD4Nz7W2aVEcaPx5EX1DlLwOHX
         02HVlsaCIhiYiJBXSZc4hf3KaCGn8EXA8pCmxThIzlQmNdJCLAiK7tyJTGrxLmI3t5Rd
         /r/HRYMqUoyOOG744XnQEiTFsf85hKy4fGWWv1UdLBddquFtJhAW5j4eYjwQGs9jUPJO
         2iqGGEUyFGcIYPpWucTAVQGA1U3JAvbqQuk7qtp5lleoIJLrcsRk2fI8MnfNn67lOyjI
         7rHnJ8MNCrnTA4skueFAmrZrXybm3MxUcsbRsAYzSzvSe/c4TqJYAdwM8kBkw8HE2Qgl
         jDlA==
X-Gm-Message-State: AO0yUKVi3ypSfzWxfNBXqeBj14wcrIYL5smd3VNAoSyD/uK5SKIfWvbM
        MLDv5aMx0AN/eoi75NmZH/s=
X-Google-Smtp-Source: AK7set8uNJKJbmIY/B+3Dtne4qmPemh1ashddWF0pWqFULxC3ibgb+85qsWO9tv0GSp4cOeKaRkwqw==
X-Received: by 2002:aa7:d404:0:b0:4aa:ca81:a528 with SMTP id z4-20020aa7d404000000b004aaca81a528mr17516820edq.40.1678361881859;
        Thu, 09 Mar 2023 03:38:01 -0800 (PST)
Received: from ?IPV6:2a0b:e7c0:0:107::aaaa:49? ([2a0b:e7c0:0:107::aaaa:49])
        by smtp.gmail.com with ESMTPSA id j7-20020a17090643c700b008caaae1f1e1sm8675728ejn.110.2023.03.09.03.38.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Mar 2023 03:38:01 -0800 (PST)
Message-ID: <d02b87ce-3c76-f940-ed01-771a27e79022@kernel.org>
Date:   Thu, 9 Mar 2023 12:37:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 6.2 0000/1000] 6.2.3-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20230308091912.362228731@linuxfoundation.org>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20230308091912.362228731@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08. 03. 23, 10:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.3 release.
> There are 1000 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 10 Mar 2023 09:16:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.3-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> and the diffstat can be found below.

openSUSE configs¹⁾ all green. x86_64 runs fine in qemu.

Tested-by: Jiri Slaby <jirislaby@kernel.org>

¹⁾ armv6hl armv7hl arm64 i386 ppc64 ppc64le riscv64 s390x x86_64

-- 
js
suse labs

