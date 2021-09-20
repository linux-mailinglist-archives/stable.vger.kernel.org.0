Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C100412AEE
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 04:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235841AbhIUCDb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 22:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240691AbhIUCAv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Sep 2021 22:00:51 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F720C095C34;
        Mon, 20 Sep 2021 11:06:51 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id w14so6501488pfu.2;
        Mon, 20 Sep 2021 11:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QfKNuRVgUMi6kijPXEerjifXSZC9X3m8EnGJqYh1Cro=;
        b=dx4+zI4MRNHv+qiZh9GTiM7NqMB4muQKxy8eGKxPztHUflafN6ZkDqrkyI7LQtGiFI
         eTzz/IvHynwG0v2bcoB4aaXiRkcAbv1WcysFR0xJcVFteKwjyMIwFSDI3DclHVeZ4Chg
         usonn1O1/BhEBRjUYdx8fHQ/B2XMy8Xv5srAEBOq3UyHa46MIh1ibCexlcfYKFliJPdX
         C6J/Zmj4npDSKbvRIHV0SGOSxq0O75ujT82+iP5smFRqq4vGGTa5cemfw+ig3Q0FjBny
         MuhXlz+sokxjqG+yQ5302zcAg6m25bqy7feY/P3QBIVzSkM0Diz3UnIL6g5kO0lHJtzB
         fxIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QfKNuRVgUMi6kijPXEerjifXSZC9X3m8EnGJqYh1Cro=;
        b=B6mOQzn+3pAPAj/1ZIsk+O0NYIQWW7oYOCOhceZVP3MAuIqTEgwqXw+mBMQ2+eYPeL
         8tMc6lT8Dt4b1Ui3Rb973f/xwiQ+kL01cFeOeLlSg1P69yDgzy0L2MAten9tkxwE3JzU
         hjckrFLSBHk046vyPM4nYgnhb2oNV+xBB52aeZj66DoypYHcyWZglrKpgDhdqXoRxCur
         jSY5f+8Ne+/Ez/UYR4pmV/Icu1c/9Kc88PxH+JeNJYCKRzHCSkQUsPJJo4jCwMleu5Ba
         FF20mOI6x6BZyxkZL3Wxqru9XTxiJmhlC6rkM6oKL9exH1GTBx06U8/m7P9jIT7p6HK7
         YA2g==
X-Gm-Message-State: AOAM533mhI9eCgNlKUimquEtkmnXrXUqSk4G4oTmZBniG0/rDEG86W4M
        ST4Sl0aFVH8VEPj2e37fTupcuoGh/uk=
X-Google-Smtp-Source: ABdhPJwuLVQUP+eGnAooHZDiCw/1dAJiobfuAmzezJo1p/O5YUM+FJ/yRi8xV/CsBaMnEXoEt6vvrw==
X-Received: by 2002:a62:dd94:0:b0:442:bb03:9663 with SMTP id w142-20020a62dd94000000b00442bb039663mr23684184pff.0.1632161209983;
        Mon, 20 Sep 2021 11:06:49 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id f2sm16028195pga.60.2021.09.20.11.06.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 11:06:49 -0700 (PDT)
Subject: Re: [PATCH 4.9 000/175] 4.9.283-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210920163918.068823680@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a0e47bb6-50a2-fd82-b9c7-1443cade5170@gmail.com>
Date:   Mon, 20 Sep 2021 11:06:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/20/21 9:40 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.283 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.283-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
