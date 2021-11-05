Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FAF644657D
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 16:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233355AbhKEPPI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 11:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbhKEPPH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Nov 2021 11:15:07 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D68FC061714;
        Fri,  5 Nov 2021 08:12:28 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id v40-20020a056830092800b0055591caa9c6so13520958ott.4;
        Fri, 05 Nov 2021 08:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/YNjQMD2QoyAC9Y05jwQxJeTKE5EA/2HhQWkWfMypOI=;
        b=FBhKiAqwx0tfDYBArTwTBkTWP1RAB2aHPCohohhhTWNrK2fhrN7Cayu1BGkI//IW+B
         Fhz5/J1pCiY3Flpjd4Zb12GS0yoYoHl2ah5xIyczICu+Uii1EcZE2ug6ZGO46LnukFWv
         jtoTQwiYnEI+J60p+Lk4CYcEAcdVmYehv2tsRwWR9QKS+lzF23kwHNHQlP8l5Mc4WwS8
         XrZxJhR4xOnxAsUnU/5El2awIwZU8NO4uiCF+jvoG41N+0iiW8OwWfRBV8gm637T7coQ
         x20tw1JbIaB9TkMRNOLrt9Bf7BZl3+r581AgS3zPySYzMsGEB2G+XsNEEU9o61MDx4u8
         jAMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=/YNjQMD2QoyAC9Y05jwQxJeTKE5EA/2HhQWkWfMypOI=;
        b=LYa0adzHpi0QbiK73RixR9Kda3E40qXROSQvjbbPyVZEdJO79i1ra7IsIPG54vh3tX
         ffNUl/71oTJPcJNaUcKjPjx/3y4eoikcXu6QQv65N6vQETgLztmuhlnADStvLada0BCv
         nXDr7tH0LbokdeQEZJXxf0dDMrr5XML6BSky56N/YOv9sgf3HvLnWheVYcbC1Z/nZRS9
         xhyeKWJjjciKwjAanbWeXvUMk/6IZ+FeGcNwPhVa93P8zYVStMRK+QjkyfgR0bQGhfz2
         bFJRtHINFBhY9gq9dYYXAM5KRK55R7N/Vf45CG3lLuaBnLBY16/ff6CUeFpRMr6Sg3Qs
         eF/A==
X-Gm-Message-State: AOAM530tkQjBAeEm6FFI3uPMW9R1FkX9+4JxVB7Apm+XA0jYTJCos9uP
        rDVD8VttNqqRMZlz6rxI0yM=
X-Google-Smtp-Source: ABdhPJxxvpoA9rzp2KGoRi0iDqa1uB9/QA20XILhTsej6RgyYcdBNngPPi1LROxcR1rdTEg5/quJBQ==
X-Received: by 2002:a9d:6346:: with SMTP id y6mr47241805otk.154.1636125147749;
        Fri, 05 Nov 2021 08:12:27 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k24sm2355516oou.18.2021.11.05.08.12.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 08:12:27 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 5 Nov 2021 08:12:25 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 00/12] 5.15.1-rc1 review
Message-ID: <20211105151225.GA4027848@roeck-us.net>
References: <20211104141159.551636584@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211104141159.551636584@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 04, 2021 at 03:12:26PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.1 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 06 Nov 2021 14:11:51 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 482 pass: 482 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
