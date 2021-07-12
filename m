Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 344B33C5DAA
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 15:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234435AbhGLNvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 09:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhGLNva (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 09:51:30 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71EC4C0613DD;
        Mon, 12 Jul 2021 06:48:40 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id s23so9687643oij.0;
        Mon, 12 Jul 2021 06:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=34VJOkAIsK76d6i1p/hMWZkvES6TvGjNy8eVswPlFJc=;
        b=B5OeUgYS8ekKIc41fYUulPnudLvdTW2OxW+9CeApnBImBHhTZRc33hVkht1VAniq3T
         mltgdW74/pHYJ/vc5eebqiyP5HV+mSlJc2tTPi9PNRj/4GptyekeQEkA1pylO7soULlm
         yQaks/BkHmdvIVB+KiMeomwVyTUnMMETIqSQEt+R07qRJBEQN00g4ED6kMaTjsQjANDJ
         vEdW4EquYr873Y3LtKhVqDuuY2b+Lbp7Dh5Y0lPc8PgEkEY24JIgwBF/B7JU/SPZl1Rh
         XV6wofn8fp38nXNAGe4ok7j02mXeHfFIIcNrf6IUQGXj2wZO7zINUYUBZ8NhQdZRxLcQ
         H8Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=34VJOkAIsK76d6i1p/hMWZkvES6TvGjNy8eVswPlFJc=;
        b=OMpMLtRsJivmnTwTHAHJdA1KH2n7zqIQBQg/yJgmRjzXPOKqVzNopkV32wDvjHHTQ9
         7sDzxq76a9Zr9T2w2d/f3yDVootCTlQHEYX+85orLZnk0+BhNNNkp7Tw0kRJGld1mMwZ
         1oysrAjgDZaohDS1h565Y5ERaeS7XKODykNJRLMWO7GPWO8LTBXSl7+2t9OWYQKKZexM
         eWz7SugDHrsnrL/eZ5yM+JXOCiuNm1ie0ge6I4PojNPiwziqRF44vhDN98xaIhvKxBD1
         0r5izd1ADdixU8iRHJJDbqDranoHrKoZymRd4w/fug+Qzs0nlps95+JeB9aYkt3Vvknn
         RAag==
X-Gm-Message-State: AOAM530QiZt7f5yOGk1ARaS+RkN/hU7Spso1sCPHHMD3e2qjvTPpvWNn
        8vzh6XFjaF2IQ8EpBBgYIS88c5xkniY=
X-Google-Smtp-Source: ABdhPJzJhemnkyKbA0EWjcVVb6hfqVduUICpI1AjYRt+xvBI/3STj/shRT2ffYofmmmeRrR6qa08Yw==
X-Received: by 2002:aca:1b09:: with SMTP id b9mr38636744oib.22.1626097719585;
        Mon, 12 Jul 2021 06:48:39 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q9sm3069131otk.18.2021.07.12.06.48.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jul 2021 06:48:38 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH 5.12 000/700] 5.12.17-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20210712060924.797321836@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <6c0d205c-6f8a-fc16-1083-76ea36358c65@roeck-us.net>
Date:   Mon, 12 Jul 2021 06:48:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/11/21 11:01 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.17 release.
> There are 700 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jul 2021 06:02:46 +0000.
> Anything received after that time might be too late.
> 


Build results:
	total: 154 pass: 153 fail: 1
Failed builds:
	riscv32:allmodconfig
Qemu test results:
	total: 462 pass: 462 fail: 0

riscv32 build failure as before, inherited from mainline.

Error log:
cc1: error: '10208' is not a valid offset in '-mstack-protector-guard-offset='

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
