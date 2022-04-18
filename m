Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F14C4505D8E
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 19:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242013AbiDRRgg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 13:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241994AbiDRRgf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 13:36:35 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BAEC3206D;
        Mon, 18 Apr 2022 10:33:56 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id c23so12934561plo.0;
        Mon, 18 Apr 2022 10:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=LoUHhDopm7zO228/OowYORqH3/eeqlWJ5ILCat5h2cY=;
        b=JfaWvVOECFy1iQ/cLnHqKp43Jf/gdypi1Rbpy3xMiW0hTo9qU33vCsq9n+/sm6aVO6
         O49jUMdyrY3MXuKmw0FGLErrKEU5tUfnPYs5LY1JPLYmhEDC5Ug6kr3vD9IAU4JZ1EvY
         9Ms8pCh9Ui8udh21kApfFl9nRLhjYvZEur7yVjDWOMvgE3OaPmIAHh2rhicJ9n7LSWXu
         eYJtlZypg+rn6qmZ5PyFD3t7Wtydui5YgDIiT/i3bXvKVOrDkDoAJZsW12k9c9PZYhg4
         3HrdCE6MCkmFGj6eLyKQfz62qTpbJVAwrfUY17ib2bwQsj6tyUc3Ug7P7QdXlA7cvmcg
         6UGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LoUHhDopm7zO228/OowYORqH3/eeqlWJ5ILCat5h2cY=;
        b=ypwvsUdit3fClTlcN1GwxNY4j+2iwHtS8OxW0SGCu2Ibp2oCEkAn1GvLYngNe9dslh
         FwfcexJ8Oj6np256MVEaO0TwKe3Zf72MyBPaincLYAJxe4xpe6DBedxT0riillXnGPTr
         uzziPAKautTjEmJCHMuq54FWQkmTJc08i+3X/33C1MJTgv8AJCbD4JZJvYdFPC69Nv4T
         wKuY7OMXDW69IvdPawvPOucZWakiw9+IFKWZA4rqdM+cspIKp+nSYirHBvyjpqruy1am
         A4qDkVUVnkXOR0L3FlvwEp54WtobYYda7NnhW66QBLU6PRivWFbKnivMKDXDMMYZbmGW
         hi1Q==
X-Gm-Message-State: AOAM532wXjh5w9iYSTP+rAQ/b7HWv/JMMjxbbn0YPgU/opPCWqtrwbVk
        EciZGMaEORRRJerCOA2nPIqP2YNzFOM=
X-Google-Smtp-Source: ABdhPJzvSmDEpzLesq1VV8XMrfwhF8Fabhmz9beheHlj2YzVEwA5fJsbX6P8X4tcKOJJPBmYdK643g==
X-Received: by 2002:a17:90b:1801:b0:1d2:6382:dfe4 with SMTP id lw1-20020a17090b180100b001d26382dfe4mr12390787pjb.202.1650303235798;
        Mon, 18 Apr 2022 10:33:55 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id l25-20020a635719000000b0039da6cdf82dsm13606066pgb.83.2022.04.18.10.33.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Apr 2022 10:33:55 -0700 (PDT)
Message-ID: <f7ed39df-b6d5-38af-7c37-629d85bec674@gmail.com>
Date:   Mon, 18 Apr 2022 10:33:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 5.4 00/63] 5.4.190-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220418121134.149115109@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220418121134.149115109@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/18/2022 5:12 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.190 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Apr 2022 12:11:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.190-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
