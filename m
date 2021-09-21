Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D014413B6E
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 22:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234848AbhIUUfE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 16:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232025AbhIUUfD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 16:35:03 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04DD6C061574;
        Tue, 21 Sep 2021 13:33:35 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id l16-20020a9d6a90000000b0053b71f7dc83so239427otq.7;
        Tue, 21 Sep 2021 13:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ru4CyNIkv5xnOhwInbWJtUWUjFbvQgm2YdSxK5wX4DU=;
        b=dLv6lw4Hr/9leq+Vpvg9H1YGhSLEgLUNRgLmAn9iXLnGYb4azK6WjTKpKqnpHhs4CR
         1WBP6EtqTOol1rXw6abF5kUNu6cIW66OZe4iOkPZtfxGFJNtg6tkcAyLNWTt0HGdoVL0
         PN8QUNP052dCCEW9q2ZJytRDLo1mI5UP/1tT/ylpFVocMmbllFRWW6X4u9zOzNo3RTB4
         czMbJDrtuCSHVU+VLTmBhvsz9kzkEeB7idgkIkxmvXl4dXBy6rsg0A/ANyUKs4UswXCR
         tNfZYDynWIosjmc9voriKhHnDG8qOAME2YucfhrD8TSAZnLuwu0CguHJRmOEqp9d1hjL
         ynkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Ru4CyNIkv5xnOhwInbWJtUWUjFbvQgm2YdSxK5wX4DU=;
        b=nRN0WyBkiEUNR7RhksPyAGvta9hZbGBuOcdzJ5IcJB529azZSlM8M26l9zMhVo/YBH
         vYtNFz+N6aneWp19Rtimp1/XGa3Uo/oCr57A++9uTWuJzw0QniGHuw5psOjO/Ug2vl8X
         5ld2OV+daJx7zQs58Gyfo7EG2Qw+J/B+YtCY2FJsyFsZ5o7KU7yaxlM2b+WwnQDXJ9PX
         u5BbbkjRBzpkf0i1b3yrEJysS/MzN+PCMIWZ++4n9bDSdrUiWXvVKNSHRy2d8THxJZ7Y
         +CjD1cVqSTMLEpYsVoMceCKRTPgjjntw6AcwkWyEZaTdqDWmndcXjzHDIFuSCO2UZcRi
         wslA==
X-Gm-Message-State: AOAM533YwzO9gie3c2ry90pswHGsJIpEsx3wJvc6UT1nJbyqq8uH8eor
        PwDjE0wzBTt8ihz8xq4LnOc=
X-Google-Smtp-Source: ABdhPJy19vPmToKT6WUZ6tGrFO0tP5eQrmp0C27pkmvhITGGBYcAhOVAznuFyMmPFHKaAWymd/cqgg==
X-Received: by 2002:a9d:411:: with SMTP id 17mr10102509otc.239.1632256414363;
        Tue, 21 Sep 2021 13:33:34 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o2sm12472otl.34.2021.09.21.13.33.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 13:33:34 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 21 Sep 2021 13:33:32 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/293] 4.19.207-rc1 review
Message-ID: <20210921203332.GD2363301@roeck-us.net>
References: <20210920163933.258815435@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 20, 2021 at 06:39:22PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.207 release.
> There are 293 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 439 pass: 439 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
