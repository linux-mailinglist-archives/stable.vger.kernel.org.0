Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75DF9442434
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 00:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbhKAXlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 19:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhKAXlS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 19:41:18 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD0E6C061714;
        Mon,  1 Nov 2021 16:38:44 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id g125so27321350oif.9;
        Mon, 01 Nov 2021 16:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VgkjFTC9RyhtrTKMV+RrbntbAV0PQrslVFy3sRkEl1I=;
        b=cj5pjP4LFMXFJjjZS2vv1egOnP/wl0Ryexym2V4ZdxIQnZ35qr7x5BYBgKy4O2bPob
         3gWgiO6BeJl2FF82J97rvSAIC1s4aekaCFrrbSyNd/9KT27O9LXMTCSVj/5E4lqOZPEu
         TDAdbDLtGXiBgDSOZm/TMnq1+19vnmWSmfDPKje/Vz0GJTiLqx0gn+eB6XGBqjzAILYU
         p8aHId9y0QOnDV3raa3sr5zeeqD6Rz/TEF7fIQXhd2Nb+MOApVUxertOjCPmDyRjDmCM
         YbUyodYfxD8jLzHKmwfbJu3wFm81N4Ungpx+Zu9uN7gcD4Z+sJEYjUAdj4TaCEhdOdUH
         8Izg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=VgkjFTC9RyhtrTKMV+RrbntbAV0PQrslVFy3sRkEl1I=;
        b=Zt93jwd2nknUklweLWYyj3qK7JQbTfSeGo1Ut633DSZPP6+nnh8JOqKc3QG48W1J77
         bIbHR7/7UZpmY0phYND7lqGDcFkdRQKD330eadyxtEh/IKkf3iE9qiFcAM1ibKHSHQjf
         D33iOBA4r9oZmWDQKCZESFROPw4XRPggimN4VpBMJwB1ENpW38lsS4pzBmr0QbJoPup3
         mSK5MGPbsWrtZvK8BBftOaG711diYj0ZDrZO3+m1yOLmv948CbhtcgfXNoSA+OCQI0+C
         HqF/wjHU98d+vW3bGqywjA6KHGPhlqCakf0qLMShcsARqrL7HsGmdUqeUvHqXwW7bv98
         xp1g==
X-Gm-Message-State: AOAM531P6EycSDn/ahtv9+WjgQASETtyYNVrErclI+1rU5IWqtuExAbP
        7mS5WwzeonNuCPzthl7Qbio=
X-Google-Smtp-Source: ABdhPJzy3teXo80CYnk0/iyshCbabhHetFu2B2ryGiD+KL1uHPVJDHz78USpSgmommPpF3FBkDavwg==
X-Received: by 2002:aca:d6c3:: with SMTP id n186mr1919056oig.142.1635809924217;
        Mon, 01 Nov 2021 16:38:44 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j15sm4509363otp.27.2021.11.01.16.38.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 16:38:43 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 1 Nov 2021 16:38:42 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.14 000/125] 5.14.16-rc1 review
Message-ID: <20211101233842.GG415203@roeck-us.net>
References: <20211101082533.618411490@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 01, 2021 at 10:16:13AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.16 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Nov 2021 08:24:20 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 482 pass: 482 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
