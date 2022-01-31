Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 893CA4A52EC
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 00:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236748AbiAaXKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 18:10:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237386AbiAaXKv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 18:10:51 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CE1FC06173B;
        Mon, 31 Jan 2022 15:10:50 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id z14-20020a17090ab10e00b001b6175d4040so743660pjq.0;
        Mon, 31 Jan 2022 15:10:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9t3mfmDA8GZFo+l72gnLywT2eoPZ4DZx+SRwZ0QekIA=;
        b=Y0EYMUGWRv8Qidirg89yvIWIMraFc5PGpzKNZVWNrI+yT1Ri4kMUGrQssQfCTsJMtE
         jHmqsDsrDs7ElAPoih+FpvFsjMj/ut+zpmkl9vMb32ZCVkZ0VBDwRRHod9YmpDvYDmGA
         vefTZdDurjSgVNHrG8n87loZkofEGPqXDfqu5/pzSPc4SZbMpSy1QZlKrcOBLqY0t+x/
         tVV5Hmzu+oGI4ewu0nQgDRrNn5otqugFr3WrjHRDZySg+RFl9O7A2NFX/6oFM+5Z9kKP
         6mKW3EfGjqFUXT/sxtcl6UYAJPP8VjGWigap0FBRrLljJMv00nkXYI+7I9es0Z+Dlrrt
         lzwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9t3mfmDA8GZFo+l72gnLywT2eoPZ4DZx+SRwZ0QekIA=;
        b=TkdlGrg9QUWZc8Izbb+y1Vl0OrqnVPI1mwO7YANpxQGdUl3pJbH+ig3vhpxacdQh8U
         25cajRJhJA13FuhGohFKrQCQ3CFfqI2sUsSj/BIpKgyqret32Ee/PNEh1igAiR9CED/C
         HjY2BQHC+CrC7RNBjnWfGnIIDON8DzSkomy9fWY7YecnXtRMzyCnjTPAS+Ape87vTUn5
         55JfOPPDBcq3QjjwD95o8vtozHdjyfqfkeSWtqFd6dYanChkXprM+ElndjwMUjTpiyAD
         BItI3Rw3P+hIjWweInkh0CUHVWX2uweBWBXeVfHywC5/JBnjY8WCS5mrkT5Si+4dHFGU
         uf9w==
X-Gm-Message-State: AOAM531rfKUy7xoOkT1fh89VlH850ViZqx8e/F/8Vrwx8HSvGQFoHulR
        pSOIrwuU5moQGQva9fTi+PU=
X-Google-Smtp-Source: ABdhPJxybBeYQIcyM1KeJyR0bHv824VTtO4h3Ba0z8rAqVru2zAf95Wmchd1IkvxJj1pno8jxndqfg==
X-Received: by 2002:a17:902:6e08:: with SMTP id u8mr23261912plk.157.1643670650082;
        Mon, 31 Jan 2022 15:10:50 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id a17sm29387033pgh.9.2022.01.31.15.10.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 15:10:49 -0800 (PST)
Message-ID: <ae07c82b-5f7d-c60d-163d-e06f68a1da69@gmail.com>
Date:   Mon, 31 Jan 2022 15:10:48 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.15 000/171] 5.15.19-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com
References: <20220131105229.959216821@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/31/2022 2:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.19 release.
> There are 171 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Feb 2022 10:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.19-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
