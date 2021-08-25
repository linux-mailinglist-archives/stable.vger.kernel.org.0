Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53EC23F7EB0
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 00:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbhHYWhT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 18:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbhHYWhS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Aug 2021 18:37:18 -0400
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8431BC0613C1
        for <stable@vger.kernel.org>; Wed, 25 Aug 2021 15:36:32 -0700 (PDT)
Received: by mail-oo1-xc29.google.com with SMTP id t1-20020a4a54010000b02902638ef0f883so277530ooa.11
        for <stable@vger.kernel.org>; Wed, 25 Aug 2021 15:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=d8md7ioYZl9GV7mUuUBl7JQ1HgtGE6JeFMZVVYUrQlE=;
        b=P3ATd0JJBzQZXX/5e5ilkz3BqMtt6o3CSmeqXM26MOEEVP64SS21zDRNyFtbgP+vhg
         C7fkoT3XOXwVgWEU7HgimEYg329WdtfG+gtxtLJ1O/KqhtdyehPpAuwIDhgnYHF5rwaT
         e69hoGQ8sBwGWiqoVolV8KmozEZADsvrJ3iQc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d8md7ioYZl9GV7mUuUBl7JQ1HgtGE6JeFMZVVYUrQlE=;
        b=r7wP9NoEyebpI87C8eST7ORn+aTQbt8OBYIXdRZGwksYzwykyESMs7BiXZ3KXitX3+
         ZGr6ZY2w0pLBZmTy/plaJcl9yoRQq0ABcXMW0emPDNe6xwBhd9ipMGP1Qhb1wyflWn7s
         cDL94vXd0p45lcA/PESPdV/izQ6GPeIYZakmzTPfWnIYs54Y5Er/QVsYUl0UvGGbfktr
         FMPxDlQ2ZkX7UFspZwlarU2klemlg29pft0OGlhtfqERpS02qXe982d5ZihfjEhPwbDF
         U6KLCVUhJLGtPCn6SAjGYjdpRoim+fAA4+c5GSXGP8KJbDJnGUfFl9icz0YxtnbSOrxz
         q+Yg==
X-Gm-Message-State: AOAM532chf6nemjh+ap11MPqipNrK5FZHSMlvPDvbZZE5AlnHNcQACyt
        TEtQGTiwTucbOLRVuXIn6wW4dA==
X-Google-Smtp-Source: ABdhPJyjs/F5tqdOl3OP+JcLmmpSKoJm97EzhRwdA3KuVcrO7rvAJDSbkDR57GjxS3fnk0ZTHwo7tw==
X-Received: by 2002:a4a:94e2:: with SMTP id l31mr508751ooi.62.1629930991873;
        Wed, 25 Aug 2021 15:36:31 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id a6sm232791oto.36.2021.08.25.15.36.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 15:36:31 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/61] 5.4.143-rc1 review
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210824170106.710221-1-sashal@kernel.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <290fd199-2d38-30f9-6430-3c97308896d6@linuxfoundation.org>
Date:   Wed, 25 Aug 2021 16:36:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210824170106.710221-1-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/24/21 11:00 AM, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 5.4.143 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 26 Aug 2021 05:01:01 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.4.y&id2=v5.4.142
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
