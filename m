Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 741563B69F0
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 22:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237487AbhF1U7u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 16:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237592AbhF1U7u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Jun 2021 16:59:50 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84C76C061574
        for <stable@vger.kernel.org>; Mon, 28 Jun 2021 13:57:22 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id g3so9888433ilj.7
        for <stable@vger.kernel.org>; Mon, 28 Jun 2021 13:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ExBqZ4fFUGq6qkTuRSNlnPB5XbkHr6PXqlYIc7Ox2Gs=;
        b=MP/NoRKbbNbwlDwYC4z6ywv/AjMVI4ZK/CFru+nutHTxlMTkOmyeHDO9pwhlE1lFfr
         Djp+rFJ4SXmE9TLYwX5cbleaN/lQP8W7YJjpmLEd2HbzJRZzXxPUPQw7JvzmrrYH4Pqv
         NfnIhmzGOEeyRqD33CB2PsY2DAizLopHicpTM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ExBqZ4fFUGq6qkTuRSNlnPB5XbkHr6PXqlYIc7Ox2Gs=;
        b=fToupBCHL/gJGubu8eLi8PO44bx6bjpZHMt9LryBptFKg/VKQCZdvkRtKB3zG4zWFr
         oSSMQimZTVImyXSBxEfUeIdqnv/o2tujSNAJI2KSxUAEijx+0ybQHOUw3qy5rpWuQC0h
         ZM+4lfelFsHada1Gjja0Zftm4B37UeJFJtoRLrBGtTV2g/9kiuKkQfSpY8NUqABjYd48
         2ARybnCBB4fPgfYh541j7ZdltKtzyh2RnuecyLeeDJ4iRumy8Em6IoEUw82i8It6bSal
         SXI5tfv5szBo/Hh3odYdYWeDQMfMUdVRQ8TIjjMaBcj+dF25keFr/76yTVEAulgcvlfU
         RhrQ==
X-Gm-Message-State: AOAM530KQFpM+DkOxXQmqZZLXcYl7sVU/wD7BxEUig8bi3maq4lcNRuW
        akcJykcs1F84o58qDJ/UhxL/yQ==
X-Google-Smtp-Source: ABdhPJyjNcIyebxLcpZEWQ2jHEjcP2S2ihsmlQxGsuFA1DBlfrOSmHeDYiMMmBzRehafymNSj0haZA==
X-Received: by 2002:a92:b50d:: with SMTP id f13mr19623232ile.253.1624913841964;
        Mon, 28 Jun 2021 13:57:21 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id a24sm2380976ioa.35.2021.06.28.13.57.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jun 2021 13:57:21 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/71] 5.4.129-rc1 review
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20210628143004.32596-1-sashal@kernel.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <d3122f35-4659-8bed-65eb-77087eec82fe@linuxfoundation.org>
Date:   Mon, 28 Jun 2021 14:57:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210628143004.32596-1-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/28/21 8:28 AM, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 5.4.129 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 30 Jun 2021 02:29:43 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.4.y&id2=v5.4.128

My tools are failing on this link. Is it possible to keep the rc patch 
convention consistent with Greg KH's naming scheme?

The whole patch series can be found in one patch at:

	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.128-rc1.gz

thanks,
-- Shuah
