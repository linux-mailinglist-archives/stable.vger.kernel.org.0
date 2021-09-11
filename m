Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBFAF407A48
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 21:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233561AbhIKTh6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 15:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbhIKTh5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Sep 2021 15:37:57 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD884C061574;
        Sat, 11 Sep 2021 12:36:44 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id q39so8170577oiw.12;
        Sat, 11 Sep 2021 12:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/kqngPaUT4ZJJZu3v6bdEJtrTXn+AEJe5ptseSN2Gjg=;
        b=OThR1rO78k43eUtSpzLd9xIScb4YR9qI5WUKJb4ZEWKhWpEQ0+YwCckuHGgNCPdEuN
         0m7jt91h3cJllVz/kmYpasVFKV+hylu7Mqmozmmm1YMrn/Ge2F3caad4Lqn02E8FAL6f
         IfvoxyIPq0T6/3RHOGZASwgrajxWjp3kCvj9mlwDJM6zzJcsRgvzcpDtPTRwnZbf+Ofx
         sztLOUDlLosVWHj1/yFpY9Lfra219CGASR3/v5UrkSucqn1MaF8YG4cGJ2zeXsswi+9Y
         jO+9tObe/CVcnjSukz8gsAYId/+JucWZdEG0yEU11k98iCrUx+uPl4hFH6czwNJmaKFt
         ITSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=/kqngPaUT4ZJJZu3v6bdEJtrTXn+AEJe5ptseSN2Gjg=;
        b=mf75QS00rIQ2HexjaQeEGYOLPoAdaY7FzMRzfgxkJ/ehVw2Ke0NJ6yitENQ+1+r6bO
         ko236tlrwGw854vyNl+KIqUAx0Ixep86DVbAd2Z/AfaBwNHql3Up0orGrDkdnSCNygxd
         hTrb4QDDn8bQuqFN6lB2w1OqJK4FEK9LOi3Ko6wnesnKrOKoZfrasdUgdRoF0PzD1CtJ
         raXWOfMq3mk2u5MYCOmnAMEVvw8p30ZliXbXsvzstumaCBi+sAaNME55eupLvrZ8qzfH
         PFo/nTwLi5Y8ZINT4EWCMkoDZqzJ29qaedO8MkADaRIj8yTmfe0Y2xZy32jgNQxM80k5
         68hw==
X-Gm-Message-State: AOAM532sx+JsCVJv1j3zp8ik/YIpPyvf5PfgQ73hrB0V3tRlQOfInk02
        /bGIVN9eSfswKyeTVSomMAo=
X-Google-Smtp-Source: ABdhPJyb4KkYx/wRtGKU++/4zozE5HWJmfiRSuypeV5Y+q1tM/5N9s9a01A44ssJb8qaAHZJ3zQIhg==
X-Received: by 2002:a05:6808:1787:: with SMTP id bg7mr2830780oib.39.1631389004335;
        Sat, 11 Sep 2021 12:36:44 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i9sm608856otp.18.2021.09.11.12.36.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Sep 2021 12:36:43 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 11 Sep 2021 12:36:42 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.13 00/22] 5.13.16-rc1 review
Message-ID: <20210911193642.GB2502558@roeck-us.net>
References: <20210910122915.942645251@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210910122915.942645251@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 10, 2021 at 02:29:59PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.16 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Sep 2021 12:29:07 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 479 pass: 479 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
