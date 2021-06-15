Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8771A3A82C4
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 16:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbhFOO2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 10:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231409AbhFOO2C (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Jun 2021 10:28:02 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E579CC0610CB;
        Tue, 15 Jun 2021 07:20:34 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id q10so14172761oij.5;
        Tue, 15 Jun 2021 07:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cVThV6WBeRJY5lp4bb0Y+W15lu+K0EYtECg1eInJ0hc=;
        b=YUTvG4Y/hV0bjyWC60yzoZ7HwZVh/Ji28TZOaamzagXDwwlUIz3l1cTwHz6OagEH+v
         dGEk1m6JP3m3tuGeePUUBXmT6dsiHivmzcdVZBbTuKhAMSR+Bi08Vtma2Z/sbompJlUk
         ddwmytDeYf3wnEwp956BR9iLwZ4G0jGxpFGKv9VsJc5EYgJjTBRPT4FFdkz7uiVfqsaA
         7lS4Jo+K2EXMAjW5DdOgHQdvSO3Ci3PAo87WzYD5855bxkgWZniqJOMH58vqNVDeS3PN
         5scwAJ0B6G2b5sco256T0z9LQxFnVtIw2zjyAiY23oSRty7jsDxzeVPt0aSstAwNgX4Q
         fMnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=cVThV6WBeRJY5lp4bb0Y+W15lu+K0EYtECg1eInJ0hc=;
        b=uNFv+f0soRDkHh9Ots48Za1/DI60JGCsM4ZYAK7B331hZESlqdSzsURi8mcQEZ1pNv
         sPQh4T2eIxbErgGyl6hah1TTAeU1C8GFvp/8LlxKtWFbQm3DyylsqJfd+7X4jUpYWY7i
         xH5rCB5oxqeaiuAlvgprVzb0LHZaxVBAN4zxt6iBMrFKSpo3VCObMQgJWe+tK26iUPms
         GzFr+AeWq7HjFqctOuFvHNbdN61VH4WOyKAxaXNfcD3nrBNLyln1k8qbz5oCeMxsWNlK
         3s9HcxrHYkDr85+mCcfRZ7UnbVzBGpa6EymhOpU2SgGIfT79CsSU54rVKVnEUGa4b/BN
         gLvA==
X-Gm-Message-State: AOAM533xx7Tn/CYc4b2xdW7AzSmmxCC2X93JjnjnyozsMohu14Nmj2Ej
        LtTSAr86engQ4Xxc7SCmYtY=
X-Google-Smtp-Source: ABdhPJyfruif6MMySsjGyc5CfRm3gloBVPSTOkm1klzKSANLQ7PBGL8yFgjh7L+OwrVsxL5vbCj2sw==
X-Received: by 2002:aca:c3d7:: with SMTP id t206mr3441019oif.148.1623766834355;
        Tue, 15 Jun 2021 07:20:34 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t26sm4150915oth.14.2021.06.15.07.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 07:20:32 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 15 Jun 2021 07:20:31 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/67] 4.19.195-rc1 review
Message-ID: <20210615142031.GD958005@roeck-us.net>
References: <20210614102643.797691914@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210614102643.797691914@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 14, 2021 at 12:26:43PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.195 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Jun 2021 10:26:30 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 424 pass: 424 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
