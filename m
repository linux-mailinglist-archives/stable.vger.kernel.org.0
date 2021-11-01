Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4CB442432
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 00:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbhKAXky (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 19:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhKAXky (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 19:40:54 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DB9BC061714;
        Mon,  1 Nov 2021 16:38:20 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id q124so27314579oig.3;
        Mon, 01 Nov 2021 16:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NJGLmbKfUwKRIG5Bv7ssICJ/vjE0g9h+cWaeTea8zK0=;
        b=extT4YmOPrRDZju8Lr3JuSGPrNSjtjeuq6gt4CwP4z/qhkyhI/nP4c49PH/o59Oocn
         /Cw2pRXroyyTf90f4xx/b3IjiL1ZIDMAfAq4/SWT/2+Z/ErJbU3pEfqBEh+nsHoPkGLm
         HAf247Wmd9Gw2XohIarDnGQ5VUW/SMZdane3+gNLL9YGtyvdPfFGR8YfG+WFjEKaxwCY
         G3yhyxlGIJ2baHykrKG2ZAc0B9krDfNazlivVyy87G9VfXyf9+vSXvh1KXbKnJWUS/0c
         /JKJCkja6i7WcwipolcY2zgJCEIeB/Dz/9EVt/3AqFZw90w9K21SWlNZ8kVRU7yZGHth
         6qXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=NJGLmbKfUwKRIG5Bv7ssICJ/vjE0g9h+cWaeTea8zK0=;
        b=iNufCcTfoowtqXQMnXLtPeoaT/+rFcAWAw2D0ybFLj8xL506LDL4ChxQsst+rbamLp
         QOmaBCsXBGpXzDnMy8d8VdmSk5WqOARUNPtRfIP3bVCvMDTb2o8RaSUFxSx5xvOpPsxh
         vPWsN8mHvXvyZrJIUj37vOw88o+hBD72I9gFlv8Ur8wWj4SKsgVx92S1NsOGCQUYoeL+
         62PtAxOnCGlj03jp9pctS6uBiK61UqWdWPn/OqYJu0DKDtb+yQ/pXqm115TyV6isRPsP
         d7UlnLsZe8SXfNwV9TJL9VekKSisfQDXC3JOGZJk70R9j6y6S5Y/VJAFF9uqA6T305tm
         6Mvg==
X-Gm-Message-State: AOAM533pSp0a0LE2BieH7adEXwGEYligGqAT5jqyFc7BCMoo/tl9qH2l
        jvFc+mqTsHOMvlKqd3zT+7Q=
X-Google-Smtp-Source: ABdhPJx7xv2atSeLnOSEnIjISe11688rtYlyjghWyS8OhcfHOwBG18ECQ9ulStWwSfhKszPJ3PbGlw==
X-Received: by 2002:a05:6808:1408:: with SMTP id w8mr1824755oiv.80.1635809899848;
        Mon, 01 Nov 2021 16:38:19 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x62sm4471911oig.24.2021.11.01.16.38.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 16:38:19 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 1 Nov 2021 16:38:16 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/77] 5.10.77-rc1 review
Message-ID: <20211101233816.GF415203@roeck-us.net>
References: <20211101082511.254155853@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 01, 2021 at 10:16:48AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.77 release.
> There are 77 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Nov 2021 08:24:20 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 474 pass: 474 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
