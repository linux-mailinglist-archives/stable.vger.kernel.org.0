Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D313AA344
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 20:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbhFPSla (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 14:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbhFPSla (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 14:41:30 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3525C061574;
        Wed, 16 Jun 2021 11:39:23 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id bb10-20020a17090b008ab029016eef083425so4153251pjb.5;
        Wed, 16 Jun 2021 11:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=H2rElKFC7U2cXO3emiTJr7HDkY8mE7KnGy2dC2t7KWI=;
        b=liZWSI78IF1pebRsG4Qr6Y/RUAlXWcriwEYEX57XnDnJ/aUPDeV+K9IqmXieUufBww
         o1wQ7dWO7QtggJAesm45Oz8kYm3v3BMY2XEVwF3QDtd05nFgBGyyL+5u4wYOBbeqU23K
         PNUM6TqYLS6EqMiOCB25djS3hAp8PYVnV5AdiampO+KD1DJD2y4hVeZG90YV65J+AzA8
         OhIQqr1QXpR2VfrP2RX9gIZyRvJiCf+6j3EFzc3McwYicV3NDxXSjMRt6SNssPmWybU0
         rPVqEvZaYkWlUhESdTn4GXnI5ugzlchCfWf5e6cJaJEJBkA0qOEAeYq/s7R0FNrr2eVO
         K+Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=H2rElKFC7U2cXO3emiTJr7HDkY8mE7KnGy2dC2t7KWI=;
        b=TblnQHEsPuo0yqYKCa6SopQAFmcKAH12zOemlOqApsXp0wi95TrMlVG+rXnbGQNwkt
         V5vOgfCvyU8wU5aHyyauM+lUWYk9N/a4sMEFYpi30PmFNmPzkDBKA8M5fHxC8mNPQLNb
         IL2lpRJpxxhoxQ3v1c/i1rTfiz+HmYj9Z7Sl649s1742qKlZLqsT2kE5u8NDaLuZFXCz
         MBBN+Gpl23vj+cZvZ0mIoDVthXMREfAjuHzGBswq1fp9BTql1sJxLUn7LBTPgeD1g91f
         Bb7J+JDKzg0NRFQIs2QzF0LYfIgnIuOGz2RR4C2HYxQjin5yFyzD7DbGojjXGb9Xgmru
         tYHg==
X-Gm-Message-State: AOAM531MYYB+ugrgRrQuihwFkFRy4C9EbnmLxgazwtU//EStLRRBFxZn
        r+xOUQOuuj6SbI2/EFtwllSMiUMHk0eMKC+Okw0FhA==
X-Google-Smtp-Source: ABdhPJym6pTy4/BhByKEpU++XR2IzG0jpIYHthF8Btovdthx8P8EvyNc1YpF45Y1fNLo0md6H3U9fw==
X-Received: by 2002:a17:90a:e541:: with SMTP id ei1mr1183040pjb.189.1623868762977;
        Wed, 16 Jun 2021 11:39:22 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id h11sm3008996pgq.68.2021.06.16.11.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 11:39:22 -0700 (PDT)
Message-ID: <60ca455a.1c69fb81.17a57.84c7@mx.google.com>
Date:   Wed, 16 Jun 2021 11:39:22 -0700 (PDT)
X-Google-Original-Date: Wed, 16 Jun 2021 18:39:16 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210616152836.655643420@linuxfoundation.org>
Subject: RE: [PATCH 5.12 00/48] 5.12.12-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 16 Jun 2021 17:33:10 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.12.12 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 18 Jun 2021 15:28:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.12.12-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

