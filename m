Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB34420DF8F
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389516AbgF2Uh5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388044AbgF2Uh4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jun 2020 16:37:56 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07573C03E979
        for <stable@vger.kernel.org>; Mon, 29 Jun 2020 13:37:56 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id n5so16728425otj.1
        for <stable@vger.kernel.org>; Mon, 29 Jun 2020 13:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Fm46DHlI8TQvkZHu+cmRB2IdIOYCe5xNqBHbvb86YyI=;
        b=V2Y3vTGJ12Ll/zYo3s2cphA4SCNvy6j4fT/a3ty8OKVVsQYsdqWJ227S2Q04r/yETO
         h+WFXtp2g82jsnVpQ55K1BaUAT6r6jDmYafNQeIrtx27I17+9xkY5SMcWC1b7EuJVqW7
         J5tQYaClR7vkxyDmmz3EYV/8sbafzTBaw0184=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Fm46DHlI8TQvkZHu+cmRB2IdIOYCe5xNqBHbvb86YyI=;
        b=iCNo2LVlhdZQ/eTcEendKE5cKjvcWTenT15FDoYNQKN/39rFus7rOmpqIbKsG/yIIG
         iAVVDm0rJjqCuu4POz3MuKvfxoiqcFxqgLKhl4vXG1C/Op0De7OA6aIraJBXpi8pg/tt
         iaTwVo9kgC46mXNfTr9Q4uUykUmnCt5K4ra5QTD8CbgpZMMMQRiEFOFG+SZonAbOflBi
         yFuTNh3Ly0vNk6Shms426eK7gHuWOQxiYvhPB79yEFiu5DJp3UukG17GPA2QUc/UM3W4
         Vd6FAYykUW2uIYQN89GSayR/bnSQP9s5y1Poii2imYFMkcVtqNhwh0GPsTrD9D9cIfgy
         Hu7A==
X-Gm-Message-State: AOAM530htSbQkW/m8Na5lG3MhTw/UoMDpqXa8/OBVwMtFTKQZKtw/HZj
        ZtwtrlgC1KRzJImX293KtEAKNg==
X-Google-Smtp-Source: ABdhPJzNAvuk+0W2NxftJEP+MRskEe2g3Brg83ppvWRminnOPpTlroZr/g6WX21bBuN68CdAychIPg==
X-Received: by 2002:a9d:4a8f:: with SMTP id i15mr15826182otf.77.1593463075332;
        Mon, 29 Jun 2020 13:37:55 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id g126sm187086oia.41.2020.06.29.13.37.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2020 13:37:54 -0700 (PDT)
Subject: Re: [PATCH 5.7 000/265] 5.7.7-rc1 review
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <42dadde8-04c0-863b-651a-1959a3d85494@linuxfoundation.org>
Date:   Mon, 29 Jun 2020 14:37:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On 6/29/20 9:13 AM, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 5.7.7 release.
> There are 265 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 01 Jul 2020 03:14:48 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.7.y&id2=v5.7.6
> 

Looks like patch naming convention has changed. My scripts look
for the following convention Greg uses. Are you planning to use
the above going forward? My scripts failed looking for the usual
naming convention.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.6-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
and the diffstat can be found below.

thanks,
-- Shuah
