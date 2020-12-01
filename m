Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73D972CAAAE
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 19:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729873AbgLASWq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 13:22:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729816AbgLASWp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 13:22:45 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04EAC0613D4
        for <stable@vger.kernel.org>; Tue,  1 Dec 2020 10:21:59 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id b12so1776780pjl.0
        for <stable@vger.kernel.org>; Tue, 01 Dec 2020 10:21:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=3wVl7AQw7YfGdQmKD3HVJT834y1hUCU2+m4Z3qdyyYo=;
        b=Dls5fLnL0gLVcKVWjt6HnWDP6qgpeIsFHtHHJB3FoSUQWXIjug1jvZrarrE2U6pN/x
         jhEqa7kqs9we4K3WfpOt9DzDeBk8vkBf90bSokJRBlSeykf73xFqxGFVkuPzE/6o3z30
         /afHK3AGdClaCbpw5uA0i9M30fnzYL8Wo/zEVsZ3a4Hi97Izpceo4RhkFm64rrp5+7rx
         9k5ensm2l7JpyO7JfUCt+doUCxNIMbql5ao/zs60fKFMhzmkPsYtD6g4Szw2k53X0Uq5
         M3h/WsYUw8xgNK6zYitbH6prWAN9wz+DeS2QLQLgDCyrzNtQeslGYcRkf7NOrx7Y1z4P
         i4Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=3wVl7AQw7YfGdQmKD3HVJT834y1hUCU2+m4Z3qdyyYo=;
        b=jZw1fkdNLkEYVnevl5Ct8KGzVNPGIqjJoOXhoEea4AIPnhdZysyo4XRivyZ0JXEazn
         5B3aXkdMPKAUj+TInzywOHkr8blSKHqHdr4xl4M5WjLUIOL2MCNfLAtt6cIxkGwhf9Hf
         tkhF+xQGv//DJs0ucrMH5FmN7WC5opPBPSfRgED1F6fIEshbj0oSA1eixxfUmOSP91Ga
         JaFsNPTWgNTgcSwcO/WR9GxPgPNtSN4XLV5Fi9U//Eg/0NHIIDRcscJuVcKOO78GwyKf
         0ZnsH8EHXZBpZjbk4ZJbTF5a8fTuRviM3mY0mAShgDGPtX/kttWmm5pCXeFiuFKToohd
         hH5A==
X-Gm-Message-State: AOAM532LVim5nhM3LD3fAwPHkR4VJhv9S0+15YJ08FWLK9+UeFgnOuUF
        F21S8MFtKsnWbL8SK1eY7n+88A==
X-Google-Smtp-Source: ABdhPJzNmqfQkYiWnjvw6ooAq9sxr3HtM5CN1pbMX5RPxx/fwdvj833jUU2F986IevaEnEuHOlSiYQ==
X-Received: by 2002:a17:902:5581:b029:da:a547:b6a6 with SMTP id g1-20020a1709025581b02900daa547b6a6mr1906487pli.78.1606846919392;
        Tue, 01 Dec 2020 10:21:59 -0800 (PST)
Received: from [192.168.1.9] ([171.49.174.71])
        by smtp.gmail.com with ESMTPSA id h188sm460205pfe.88.2020.12.01.10.21.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 10:21:58 -0800 (PST)
Message-ID: <b46f5368d281ceaad1c27adf818b986ca68ce925.camel@rajagiritech.edu.in>
Subject: Re: [PATCH 5.9 000/152] 5.9.12-rc1 review
From:   Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Date:   Tue, 01 Dec 2020 23:51:42 +0530
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2020-12-01 at 09:51 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.9.12 release.
> There are 152 patches in this series, all will be posted as a
> response
> to this one.  If anyone has any issues with these being applied,
> please
> let me know.
> 
> Responses should be made by Thu, 03 Dec 2020 08:46:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>         
> https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.12-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-
> stable-rc.git linux-5.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

hello,

Compiled and booted  5.9.12-rc1+. No typical dmesg regression 
or regressions.

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

-- 
software engineer
rajagiri school of engineering and technology - autonomous


