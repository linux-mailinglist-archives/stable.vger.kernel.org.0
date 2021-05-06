Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81A85374D0D
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 03:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbhEFBuu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 21:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhEFBuu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 21:50:50 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E829BC061574;
        Wed,  5 May 2021 18:49:52 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id u25-20020a0568302319b02902ac3d54c25eso3567177ote.1;
        Wed, 05 May 2021 18:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mvEZJhQelIer635w4cqc148I50y0Aqtz5UMdo4L6uLo=;
        b=rXrV1sHA1Tsy/aV9fPIBk1+vYq1LhmC/qQogdSIGACsPREk7mLcB5BEj/Ptp3jPycr
         cC84cLA1UMkANaicgzg7h8yWnUjCndVetnt9jUdbhQitbU1BYfk1xcs+VKKYL4GVIKfi
         zmIkG/mmWj+XsdNfSulvoX+HgO43mqd3Xv4FZkp8PX2l+EZTyPLgC2jfauxeF83nIJey
         NKEo7ul3X1P0h6tSAA/yWf4cciTemKu3UPTxAgXww7iPgyMN3NQd1rKYeHfyrNtJsJKv
         5buugJeEnB4apTe8QG4rhG16chfybkMvQEStHedDa58ImMZhwaodDRJTr9qRDrHG6hQX
         Fl5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=mvEZJhQelIer635w4cqc148I50y0Aqtz5UMdo4L6uLo=;
        b=Na5siJk2+7J/El48wMGQXpXTOLf3iDFPujxDQd67XNr5zteg5buY0e24Su7uGyKolh
         aQnQ+a4xTERdkp64Ix3IWs+I+jmeAGRxWMpL51BWdXZnIwYqSq7KW+lKYGZRqdneKwAP
         /avjtGoy5fTagzIPZWZrxwI2PH9cV0WRHIkpBy9dIDN/L1i8kRGMbqAhWh4YTNipVjYx
         HW8zEKQmnkt/HMH5N2nuq9510CcWo5tO0/9sEeQWAFmNb46DO7cWPxFsdtbV4M1u5PWJ
         /uzGKzjpJXPFXfZPt2WYVMGwv/gOc71zuX+xf4qFIazKW3MAzUHiiugSHjgHwBRiVVtC
         ioyA==
X-Gm-Message-State: AOAM532GZcAeJwpNruW60oyXba4cK9AFuPYvcxG5hcOLEa8BS9hze6hd
        Qu5zCFYgzjryjjJmYCY5/J5YE1BPly0=
X-Google-Smtp-Source: ABdhPJwGiZBuzZGTB9okTTpA4eb2KrEhTrt5SnW/zLgEN6PowF2UY8yORZhRqrOD7UI6KUonym1rUA==
X-Received: by 2002:a9d:1d6a:: with SMTP id m97mr1367817otm.288.1620265792414;
        Wed, 05 May 2021 18:49:52 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x24sm276660otk.16.2021.05.05.18.49.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 18:49:51 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 5 May 2021 18:49:50 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/21] 5.4.117-rc1 review
Message-ID: <20210506014950.GC731872@roeck-us.net>
References: <20210505112324.729798712@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210505112324.729798712@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 05, 2021 at 02:04:14PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.117 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 May 2021 11:23:16 +0000.
> Anything received after that time might be too late.
> 
[ ... ]
> 
> Shengjiu Wang <shengjiu.wang@nxp.com>
>     ASoC: ak5558: Add MODULE_DEVICE_TABLE
> 
> Shengjiu Wang <shengjiu.wang@nxp.com>
>     ASoC: ak4458: Add MODULE_DEVICE_TABLE
> 
The above will cause trouble on builds with -Werror because
it adds MODULE_DEVICE_TABLE twice. Please remove the second
commit.

Other than that,

Build results:
total: 157 pass: 157 fail: 0
Qemu test results:
total: 433 pass: 433 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks,
Guenter
