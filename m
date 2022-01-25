Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7441D49AC25
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 07:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240686AbiAYGGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 01:06:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242172AbiAYGDI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 01:03:08 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC84C0613E6;
        Mon, 24 Jan 2022 20:21:50 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id r59so746058pjg.4;
        Mon, 24 Jan 2022 20:21:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=GCtYDXOant2JMvhCArTGBt3s3S3YwfTxu+0hSAqbaFY=;
        b=bPm//ca9cRtkGd+2Dr98rlgBg8qrvpDBparI78AdS2DhP7V1yzeVR8pQLNCJZwhwNL
         hj6OVuU0hIFjofP9p1gmthDDovSM8rlD7r0MNBIbbo8rou//x9XwcJkJNAq7tHVQegcg
         Bhucwo/Wnq6EhzVxYn2ycOXmYT2g80DfkFDBPh/jy3RU2uXpXovSuowgXP0eJwnRuANg
         KpJm2fGrXNwTaz2lYGmAduQyuZMuAGJof/S5vcvn37si6lqDu9NHog7DTWwBKhkj8juW
         70cLbuvp5XUREjKbO0UB3QzS24r1VEaT0+djg4i6AQV/YFKsGT+xSKB4XX7CA2l98c83
         NiFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GCtYDXOant2JMvhCArTGBt3s3S3YwfTxu+0hSAqbaFY=;
        b=kAzrtn1vFFMzeyrWGZCE61HfAyzLFuw74Eku0dzCFuFZ56Y43DBuwUe/aD7KJCP6aa
         jHx6ydwy+rBxrBq3kbYc2noJ3f32H844Ym1g1OImF0NTB1nIEBDQuIINgkRhs0JF5G00
         qyfpxY+yKW0ZWu2/HJo9wCkZlr7lP976LTKN8Mc5Fj7rJyHYUnfRJtE4SdMKk/EHvT0E
         uRPymEK0W40tFDfUmSACnJsxmFJXQlJCYjKIxF6huZ3++rPUx1MmFGHL8nAqEaWVV++h
         fCIIvlEWcUmldvm/0RwSFZ8WzvjOHhoTxW48LUIifhY5IgtabYXCRmrYvU96+uXJ+w7I
         0UKA==
X-Gm-Message-State: AOAM532I+RWPRF5BxCXB5ft5/Qy24YdM8/9lD8qWktQ6ehREaKejTRRS
        OZLWHezj1i/aq1o5BoiXUCn+EaHlwfk=
X-Google-Smtp-Source: ABdhPJxB13Ct+i192lnu46CHP73DLx4EdFj4X0yZVhsWbzSzMqJukCt2emFJeP5zdX/DVTlrTyIXxg==
X-Received: by 2002:a17:90a:788e:: with SMTP id x14mr1626228pjk.174.1643084509773;
        Mon, 24 Jan 2022 20:21:49 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id nm14sm827452pjb.32.2022.01.24.20.21.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 20:21:49 -0800 (PST)
Message-ID: <ce5c2323-2bd6-12fe-5fb9-1a09a40fe1ba@gmail.com>
Date:   Mon, 24 Jan 2022 20:21:48 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.16 0000/1039] 5.16.3-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20220124184125.121143506@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/24/2022 10:29 AM, Greg Kroah-Hartman wrote:
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

BTW it does not look like the same CC list was used for this one and the 
other stable release candidates, can you copy the same list next time? 
Thanks!

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
