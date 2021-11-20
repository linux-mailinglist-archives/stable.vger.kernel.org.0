Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B17D457FA3
	for <lists+stable@lfdr.de>; Sat, 20 Nov 2021 17:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237773AbhKTQ4S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Nov 2021 11:56:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbhKTQ4S (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Nov 2021 11:56:18 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC903C061574;
        Sat, 20 Nov 2021 08:53:14 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id w6-20020a9d77c6000000b0055e804fa524so21745886otl.3;
        Sat, 20 Nov 2021 08:53:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=M/HaDHyrNlYo5UnKNbsUcamxXNWPtD+C/rNyIGWojbg=;
        b=eDoyvaD8drpvD+8Kn/rdklrnFnMxSPoe2wraHUODf8f7u+3ZUZIaP7Q37X8CUUOq4I
         Xb7+o0SsYBJE8AmBRxN/q4512opdJKK//wkb3OXxnzR01wUSduz3XlzXnq4tcPpkfPET
         TDMiw+5BFUNRF554zRuUYiFSq4w6bZZpX2wMnb/1osQgmHcKmz5S6LW2guDU4f9EamEY
         zV0yyJXZNk6aueA/kzzI/+WufkpNVJgPGBWf48vZhm56yutPHtVR548g8/fI6nPZYyOM
         JBjsRWhhWBdnRzcEifHyzO84zZ8K1bWCRXqFu08wxSJ7HfuNzWMtJ0LpYFi7TAgJWa0S
         1AYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=M/HaDHyrNlYo5UnKNbsUcamxXNWPtD+C/rNyIGWojbg=;
        b=eOo+4n9kqj1lPWoRGeN3ueeyq7mGnmuB5/pq9uek66D8FF+xrOjR9BILpNDhzHEbJR
         /npEkmIFgdQNEW75x3P10JkFM7unh1MVTwfq0U8UrYfTuuKvPBbBYvulkw6Y/n+zI51n
         kKB/GNPlBY4ozUuUl9aqfF/mVACaaPxULVOfHUdoBFQHQ54dkMrBzbhatVlE86Alu8x4
         oDRsQsIeHVgQaJSfCOBKtncaqdWjmMW5pXRtLJo0U1IBloRpy3NJJ2vCGqJacHfcAL4I
         O/pAotGfrSl2ZwjWac/LTzavp0uK9DBEYPhH1sypvQdWlwjl99UYrHSre64IAOhx5uth
         iwWA==
X-Gm-Message-State: AOAM5334o0zv01Rv6KzWDM3sHSwGlcUs6ro+LxrsG15qTDAeZdgvSzl3
        xDMXEfa/rCzWk9CtolKeHQU=
X-Google-Smtp-Source: ABdhPJxMyA4mfmyQCC8MtsaIT/15NXIKIU1I5bwlEObPwRHAuP1bzvEKvrI0+MaSEjke0kgtK/1IEw==
X-Received: by 2002:a9d:6854:: with SMTP id c20mr12958241oto.190.1637427194185;
        Sat, 20 Nov 2021 08:53:14 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j5sm650708ots.68.2021.11.20.08.53.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Nov 2021 08:53:13 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 20 Nov 2021 08:53:12 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 00/20] 5.15.4-rc1 review
Message-ID: <20211120165312.GC1237134@roeck-us.net>
References: <20211119171444.640508836@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211119171444.640508836@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 19, 2021 at 06:39:18PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.4 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Nov 2021 17:14:35 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 482 pass: 482 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
