Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84FAD33C7D0
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 21:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbhCOUgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 16:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232395AbhCOUgJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 16:36:09 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4211C06174A;
        Mon, 15 Mar 2021 13:36:09 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id p21so21156917pgl.12;
        Mon, 15 Mar 2021 13:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9W5Vza1zdnhq73DRYJgUL8FEoXWeecaJWERvPnwUpIk=;
        b=GYDNWA3oQqynNHzhFhW/W8B88eNQMPjL2RXbBm24KUVcJDWnSzGe/J5LebDQtcV6hj
         XduIU5Tr9YNPD11ea9Y0XcxPD5z/A8ggjPSVaa6W81Lc/jiOD/5kWE9JU/180gRqnbBF
         Tey0ngCxpSGEF3zO2HBXRvAXpWc3vntZkwTx0owNpkfx8JNmiMFGc4FwQTK91cgPBoeF
         ZOlrUpb57/xUbVvCes2uTeBfbavBsEg4CaTidQta0Hs6S+8YNgOwud6M/MVJ5wAJo7aE
         cHkSENl/lHytxXlV7HF52zZ7a8CLthH/GleE2qFlaXx5GiPiRyMRMslysFd/CbzChzlb
         uuzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9W5Vza1zdnhq73DRYJgUL8FEoXWeecaJWERvPnwUpIk=;
        b=Qpu87eYFc/9Wv7Te9PfQO4LG4ZYTp/v2+MZAdXFKsCdIgxsZpXJ5FBQr4cFPqWhIVG
         euS59F+oJsIWorTtfcfwdM6vd5O3IO8hNmpXFqscei+UiCuuoiVCn6dB+qe4qbps0INz
         BHDuGmUWDgoUwEH7wuYWjHe2e11peoodA6GYcFTm6gzM0KWE25UQuP/OKkKiZlzl2q2l
         aYZyC2K+h+dTuRS+2TLU78eSYPLgZC3EV5AHouiRdbx7bNDQFJXwDSVEQClwXx8Ii14N
         g0Y4yJ0uZ/w4i02j+u67HQvKXwEUjJTVpak+DEJD7u+RaXhezh4I0YFQ42v3WoBVDmr4
         /I3A==
X-Gm-Message-State: AOAM530VT6a2xL78I/hW8AZU4dWu4/P1xtghwmMIrEaLoIfetd5+fryE
        772fGyKaTft5yNoqiYqAf0TnKgfad8w=
X-Google-Smtp-Source: ABdhPJxtNZ0nDzAHhMlbZtYzgbehteduECJo5RQAnzY+P6cjtiVW3OP8oceKV416JMTrAF/J9RHycw==
X-Received: by 2002:a63:d58:: with SMTP id 24mr759362pgn.171.1615840568825;
        Mon, 15 Mar 2021 13:36:08 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a20sm15150491pfl.97.2021.03.15.13.36.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Mar 2021 13:36:08 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/290] 5.10.24-rc1 review
To:     gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210315135541.921894249@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ed1d3843-71a7-e569-59ad-8db7caa5aed2@gmail.com>
Date:   Mon, 15 Mar 2021 13:36:06 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/15/2021 6:51 AM, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 5.10.24 release.
> There are 290 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 Mar 2021 13:55:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.24-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
