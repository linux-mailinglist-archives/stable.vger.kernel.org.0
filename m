Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 934B649AA01
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1323958AbiAYDaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:30:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3415597AbiAYBsF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 20:48:05 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DAFAC067A7F
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 17:46:32 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id x3so851307ilm.3
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 17:46:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OLFh68WssbeQyB1KrT0TRpUmamwDBiQmELJA8PMvRb8=;
        b=Kz8eMKjla9hxns2SFusdrhsEQaemENVSfQXAhV2XGbhNUGoZSIIGXScVsdzelc4LjM
         Nb+4nN9llQO2eqIVWV2oqC4Cs5zMd8SpdFBcY+FoPiMh1ppIvhwu6/XETOeiBybv3MRh
         b1PQ6tDHewtJvtVb6ebYv82xcyklYm445/sqA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OLFh68WssbeQyB1KrT0TRpUmamwDBiQmELJA8PMvRb8=;
        b=ZwebBIXhtvnqagZjMU2S3If5bBeOh8V9rtqXj3VNDvBePXupiNL5f5/qTditsp6rar
         gN6osQHjNOZgTBCEHxUzCAJicFvTXKRwa+Xc9ndOyUh57OfSRxcu0RoCcgtUWWyU90JX
         f0Bn8tsNWpPE3j50xPFGJL9M0+KUDeL6rDVtWhBOrrEpq+svnJANdUfKNf2z4bV1hqc2
         nGzLDulusUJNJKuaFYU45sJkvuqjXTBefp4iPiPMXudgPmes0L09JvlG1ZkPUsqkaPye
         hfzCE1YDacc59PXBS7HfPPwmktd3JNjgQNzaeTB9pUBqkSebRcgP3KGCaqdsT+7wPg1v
         SR3A==
X-Gm-Message-State: AOAM5336ZsxJn/HzImB3yPp/EjhW3LoXpQkudQW7LhW0EqRsT+GxLa9B
        ZOYs7CsoAWZU98PLVPXbkOBTCg==
X-Google-Smtp-Source: ABdhPJzfzNVUXd2pR1v+yfQ36klDiWPOQZ69j5O6DVxr1DyUrEf/Dj0WF1Nc3KzJXCeDylaHeMPHNg==
X-Received: by 2002:a05:6e02:1bcc:: with SMTP id x12mr10476913ilv.96.1643075191643;
        Mon, 24 Jan 2022 17:46:31 -0800 (PST)
Received: from ?IPv6:2601:282:8200:4c:b48b:eb27:e282:37fe? ([2601:282:8200:4c:b48b:eb27:e282:37fe])
        by smtp.gmail.com with ESMTPSA id v19sm8057996ilj.49.2022.01.24.17.46.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 17:46:31 -0800 (PST)
Subject: Re: [PATCH 5.16 0000/1039] 5.16.3-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <8e94c4da-86ef-4693-c1ae-31a3447f4efb@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 18:46:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/24/22 11:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.3 release.
> There are 1039 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Jan 2022 18:39:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
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
