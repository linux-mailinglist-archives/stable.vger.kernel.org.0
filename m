Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99080361598
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 00:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237064AbhDOWnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 18:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236939AbhDOWnK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 18:43:10 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C149C061756
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 15:42:45 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id d2so21510140ilm.10
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 15:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=daLW2DBmLQg88l6j7UKESf1D46Y/zvpvMhTRH7cMua8=;
        b=U1dxTjLs+Jh6GMgUsB9dh+NnSPgyphca0cD2MqQu6pD+RocSgFLdLJe1FC4Ep1G0OO
         BbQv/KzdQexo3agDrv00vf61QGRwWe/g+QQi5oYE65yu+n+dm5xQB/OORsjFPpt432oW
         L+iqTFsHlP+r7zq8FJMFoccKMmIM93PaG4wjo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=daLW2DBmLQg88l6j7UKESf1D46Y/zvpvMhTRH7cMua8=;
        b=cSFD81KjQP7iLZrbDXSTUhyuMNLeg8hPdH2BfHx60KbQMX1AMZ9t6Fm3dWHzcVHA0/
         H70/DnG44VAGB4A47ETqcH9IK58TfgoPm5VtOUNlPwpKrrbBtuX135hV3+nJZqw7FMZ6
         1G/wMNyFU987QnNYIJzsgntcDjnfp9l8nB4sMHpa0zExFaYAOtK3HgWNVgj4ctrxLuI+
         B350TYgLBfvFL0REpnnfaNlPZdN1I9I/fSMPko+1gn+CDEeZ2wH24i3kKWvwcZKkXBY0
         4NnKPaU1rnZsaJj6/pmP8xtX/1nnVOESI3U0caqyU0UmPTVne0k90Srhal4Bz03MwFvF
         Q+tQ==
X-Gm-Message-State: AOAM531inyaVrDYaGI/SXBugtsp1n04R+lGdTf8f6nFYJv7woj29Yfnz
        GfoViODUuqtOzONq0dSa1wBRrA==
X-Google-Smtp-Source: ABdhPJzQUqhSBhBY6zcgdgd+YvZpdUzJljB49lH3I+zbACt7es5Yz5UmJBmd5UqF3ZCN8hObT4c5Qg==
X-Received: by 2002:a05:6e02:781:: with SMTP id q1mr4711789ils.91.1618526564828;
        Thu, 15 Apr 2021 15:42:44 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id a7sm1827953iln.57.2021.04.15.15.42.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 15:42:44 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/25] 5.10.31-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210415144413.165663182@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <bebd0bd2-d9b0-2270-598f-b94383f4c136@linuxfoundation.org>
Date:   Thu, 15 Apr 2021 16:42:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210415144413.165663182@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/15/21 8:47 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.31 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Apr 2021 14:44:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.31-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
