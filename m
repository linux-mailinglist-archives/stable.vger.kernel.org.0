Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D14A1383A78
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 18:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240764AbhEQQux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 12:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240906AbhEQQuj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 12:50:39 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D06C059CA6;
        Mon, 17 May 2021 09:33:31 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id b13so1581364pfv.4;
        Mon, 17 May 2021 09:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eR/7fI1UFI0lbQbmLWNbiWwZ7NzStsvm/sdwpBqswd0=;
        b=YpQxAxLj8w0Ov99/r0AUt037+MfErX0qTGo5iVaekc37rGTNYoxlHwhMiHUt+6hMtS
         MGIpLeCi4PYLkbwO0dQBEBV6xJFOgRA8CY1FdSSbX5GTPuSECIPHs8XRKg2PskvD/UIk
         O6g/rM4wxw93depEXe1vGOQko0ofni8DFniWWKznqTfo29OJjdosMgkmozNQ4yet0ohz
         y1wIiR2iF9BekJCmqxa302j/zGoQLBbbW59PLC5Mcvs7Os1Id0y1YQAITsIzWEqQBAjZ
         IeJ094Fog0MfyOpApsegpaN89SqQjl0+B9Do9pcNF0HSeHFeR7YJpPMq8sbrlVpz4UIg
         O02g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eR/7fI1UFI0lbQbmLWNbiWwZ7NzStsvm/sdwpBqswd0=;
        b=Pd81aMfenrYlS4G8LeR0yaWsHKsKF/68nZ7RIl2/s+bE6JoFe390qwgcTuSpmpm7Rt
         YbrSpSV86Vcp//XGlU9KP6/vpF8PaLF0uaidbQ+iQsh0I2V2kLBsPHB27LMLNZJh9jbo
         RKwJMTh8lpbb7KGn+MP3x6bolSfXUkvjbpC3Fyld68/IOTotuV7jBddUtTY/SUK/lDpX
         708UL8Qy7jOxAwb6HHs3aiFRZ1GVyjLlbKyqQTTc0eFzHMxFQcYKdApLecEFr5C1AY9g
         vEMvYjfcl63ZcQNEOL+RaWeUGkVShiGVOWim3I08iz5aRnv0GvdLQrRD7G3j8ovzs/ct
         0VtA==
X-Gm-Message-State: AOAM531y09DCctAsc4fPRQSgK8qcQ45yuHzGzLIhyAEakwtCY4UkIdUi
        1f8qqKWyti/6aIhUugbcj7kaXZ1i70E=
X-Google-Smtp-Source: ABdhPJzqkzDWpRHL5jbgrcGXxzY6jPAuG0Xj1ArabHHEbF1FBHe1x/cG5HbxhwOz7KmrKfQOMy9K5A==
X-Received: by 2002:a63:9350:: with SMTP id w16mr400363pgm.53.1621269210218;
        Mon, 17 May 2021 09:33:30 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n11sm10202260pfu.121.2021.05.17.09.33.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 09:33:29 -0700 (PDT)
Subject: Re: [PATCH 5.4 000/141] 5.4.120-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210517140242.729269392@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7f205669-205f-0d18-05d5-1a06364f54b9@gmail.com>
Date:   Mon, 17 May 2021 09:33:26 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/17/2021 7:00 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.120 release.
> There are 141 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 May 2021 14:02:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.120-rc1.gz
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
