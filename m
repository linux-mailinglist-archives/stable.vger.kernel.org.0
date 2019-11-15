Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F89CFDF6D
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 14:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbfKON4V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 08:56:21 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35698 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727529AbfKON4V (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 08:56:21 -0500
Received: by mail-pl1-f194.google.com with SMTP id s10so4732905plp.2;
        Fri, 15 Nov 2019 05:56:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Mz79aTWpXk0yI2Pr/twZvU2HDOpqkdDgAxaW4oSXtNI=;
        b=H7vs1I2ZEcbY5ONBGs1yHXuXuP2OSXa+9asNyELgKBDH/DP9KxyNIl2EUdJUCCa/Kw
         QAclk/jwD7dRKjePfkbyqT0K2zfC4vZb+MbBKaJAcJQdgkr3WgR3CdfVDv1/bcYOrvfo
         8qj+s28pFnTOpaZVWV04HK2Y07fZrxWaGsk2Q5fI675kEyMseGajA+t+kF7UphNI/kLn
         p07c6CIyitCHPqvAzgD+8g5+7vu6wEchlXsxBCglv1kiq3gkvtaGm3xK/E738EOeDtmm
         RhLULLEOOX/cWF2AFTp8s1marssCxBxxk8v09ofV1b2tmmcvB+S4TP37OXu6irPnsiH4
         hnkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Mz79aTWpXk0yI2Pr/twZvU2HDOpqkdDgAxaW4oSXtNI=;
        b=WIC809+hv+XJulKItznFqyl75zA+9+EBNpn+uwKardkgx0PXRXlLfpEtvy4WAWnBvl
         rCGAZFw2S5bYS7LuCXUwkrPfusUV9OC+pLK3s8gvYMGV3vi7LsezNlUc7bHpUS2WL9Qv
         YlHQ5QZf/T1BMe3P3s5aMLADl+3rj1+CkkMXj1sbNpFaCWqcHEq2sHrTmSnqtOVUkkoK
         9OZsNvsvTYnzDpWHdELbeDMyC6FZ34Go1Ny/Q++oH1r2IxF22asGJcGnLkU4ZnTe3d9n
         YU2hNxsFlv1KI0dRHIrbLuzU7uG1gxI7ZaZ1Xb/dFVQdPepe7FttgHNlzTfypAA0TgPz
         XduQ==
X-Gm-Message-State: APjAAAX0VRmnTbdb/jmzLJ+HXqGUKWyHDqhxEpHZKswNq20U7edVgwoz
        iTi6NYrQVIMI2Vm1qFX4HfFjTnzO
X-Google-Smtp-Source: APXvYqxD9GrUe5KRurez2tdNWL3FqhxlpscHn4PSVjj6zuVOu9tF9f8uetlx8WN8j8jgKn3CmMwFiQ==
X-Received: by 2002:a17:90b:906:: with SMTP id bo6mr19813957pjb.11.1573826180499;
        Fri, 15 Nov 2019 05:56:20 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m11sm4006000pgd.62.2019.11.15.05.56.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Nov 2019 05:56:20 -0800 (PST)
Subject: Re: [PATCH 4.9 00/31] 4.9.202-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191115062009.813108457@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <64c3a414-36d1-aa79-ad5d-75b5a57225cd@roeck-us.net>
Date:   Fri, 15 Nov 2019 05:56:18 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191115062009.813108457@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/14/19 10:20 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.202 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 Nov 2019 06:18:35 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 356 pass: 356 fail: 0

Guenter
