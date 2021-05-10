Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB513799D9
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 00:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbhEJWRt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 18:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232753AbhEJWRs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 18:17:48 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 317D2C061574;
        Mon, 10 May 2021 15:16:42 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id n32-20020a9d1ea30000b02902a53d6ad4bdso15845217otn.3;
        Mon, 10 May 2021 15:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QYRzooxQM78V6aVVWFEgwKklL95CEktc5LfOp3LiZUU=;
        b=m2fgdWlJ8iyrcu96Yr+Rt1/e5YqmzxOG8f5fLO0yfvc+GZ5413gIvlFUKHmhbOt7h7
         ++U2j9kUA78nyIIDlQ2qgdRnpgZ9M19gV0JO6ysbED8tIQQAw+w3JhbCc6LwxbstivG9
         4mz3F0REISqDN2t7QE4tdl0kKzYD4eZmwwZPYJ5klmG5vfuSXpd6v6tj2PxvNZzCQYW0
         GavaZyqqZaJ5uRYJZZuCrp8nghqdfpGynvDExXkRYjdfO0+vpOARMa+3Zn2okrWe2dfK
         IuL2HVCEuUeqh1Mnw6oeOw7lz1q6U61+rXH5gXYuHgUY+TgFO94sWTCEu9JserVE0kdn
         esEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=QYRzooxQM78V6aVVWFEgwKklL95CEktc5LfOp3LiZUU=;
        b=iNnnlhlcDf0Awrl2y2JT+qFmQWqPpneQN7FTOX+0xWQ0jf8+i2VjOKE+jN4AfuC5CV
         49yPEePJrimwLhR+Vp+LB3YwYb0xo7Hq84QuJKWN+za2UidnUMjGjQzHmN7lH/kzTQ4k
         iQpd1sdRoqYB8uKV35mAm2hEux9CUqRqvPWDlOS2fsNx0rhd4g4xp7PlFyrpnt+zuanD
         miApxSVnuS47kVQg4Cm4Gm6R+KsaaMfz0aJ21gUPgsss2iHgX7eFQ7ll6BGtwvcW/sIp
         HuygJmsKfO2JyJwfXO0WiSArcfzqdhUD6zTfVAOT+nZLKLKxcd0MU1h74uKQXzxP+9+I
         6ilQ==
X-Gm-Message-State: AOAM532JEGDQuBEdR/QFtoG0PfvYXeMewwNO4Y8rFfmFBdxRjNAoGApd
        Klpby2KpMq84r6w7HSf1KOA=
X-Google-Smtp-Source: ABdhPJwaVv8tV4QT5tzdDRVo1VaxYs1msMnqbeSJx/HPd1SaDaNfoxPllungUBexQ6PZ5Ta3TPRMPA==
X-Received: by 2002:a05:6830:17cb:: with SMTP id p11mr24296519ota.283.1620685001643;
        Mon, 10 May 2021 15:16:41 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d19sm3017440oti.57.2021.05.10.15.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 15:16:41 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 10 May 2021 15:16:40 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.12 000/384] 5.12.3-rc1 review
Message-ID: <20210510221640.GD2334827@roeck-us.net>
References: <20210510102014.849075526@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 10, 2021 at 12:16:29PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.3 release.
> There are 384 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 May 2021 10:19:23 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 151 pass: 151 fail: 0
Qemu test results:
	total: 462 pass: 462 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
