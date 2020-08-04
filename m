Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 352A823C0BD
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 22:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgHDU1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 16:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726580AbgHDU1U (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Aug 2020 16:27:20 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54EFFC06174A
        for <stable@vger.kernel.org>; Tue,  4 Aug 2020 13:27:20 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id v6so20803895ota.13
        for <stable@vger.kernel.org>; Tue, 04 Aug 2020 13:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3U2d9txIEQffkxR+C7dpVs5o376ZxXZi742uV1M7EXQ=;
        b=iH1T1HgcpWpoBKI1Vo9Sf7YqPyw+CGqCPAxwZ5FZzMwDN74RPKzibY4w6LooPuHrwY
         FOEU8Msx/1A5kdzLljYqoRskNRRVvTT4K4jTkQn6elV5uYqZ/gS3JYsiHzowi3BHI61R
         8DbK3Ddf3Dac/jU0jWLhA1BFtoPfaCHi10yvg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3U2d9txIEQffkxR+C7dpVs5o376ZxXZi742uV1M7EXQ=;
        b=tQvBfD1+ohV7p6uWrbeKB5SitfpDNFZb62wcQdXsyZVANcxePE7R5HCrQVF1v65IGF
         Vbc10P6XDoWtBrxwz9Gysc59knlZsaIde/DQMKt+/E5oGiY+Ud55RfNTGlW7d66A/az8
         DtWtN60UPdVN3peOhORlttSiFbPtzhKl+fMQr+/jvH+RLfeugt0tUtUyoY/30KX/wz2g
         VqtnTWGMDTEhYtAJf8EUTUJpWL7/Yv4UGj0pZaKEIcCfa73ZiZeLJx19bryMuKkVYk7F
         OUFywjy8L2dLyzu7z8vPh64pTN7w4SdZQYyx3lTyhkBYKhRDX4jSUPSwl2Lt4naE0l/Z
         p1pg==
X-Gm-Message-State: AOAM533xdpRUsQbXmUlkIj99NcZfFm91t+moFDdKzyY1lng9Jr1pUiLi
        lbUYutXPUsyPdBy50r5ddZbMSw==
X-Google-Smtp-Source: ABdhPJwN+2kbx53QduKzLPU4lnEd7L/RCzoTLR8Bw7mn/h8kmECuGOnxaRp5Gyl60OLFhH+H+TwxUw==
X-Received: by 2002:a9d:7695:: with SMTP id j21mr18957852otl.340.1596572839721;
        Tue, 04 Aug 2020 13:27:19 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id m205sm3736239oig.34.2020.08.04.13.27.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2020 13:27:19 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/86] 5.4.56-rc3 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, skhan@linuxfoundation.org
References: <20200804085225.402560650@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <a6a058a2-b0b5-8e85-034d-325982549df3@linuxfoundation.org>
Date:   Tue, 4 Aug 2020 14:27:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200804085225.402560650@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/4/20 2:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.56 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 06 Aug 2020 08:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.56-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

