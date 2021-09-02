Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1E953FF5D7
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 23:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347553AbhIBVvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 17:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232404AbhIBVvf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Sep 2021 17:51:35 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1370AC061575;
        Thu,  2 Sep 2021 14:50:37 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id g66-20020a9d12c8000000b0051aeba607f1so4347423otg.11;
        Thu, 02 Sep 2021 14:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6aJbgb5TBtxqaXU8ze5xtILpaV7oTM2qMWVvD4eYMMg=;
        b=MqsjMU52zZqgJ5hwgRkYaDoo5X/8hnyrRoqwgTmntC7XmsHu8aVRa1JCBn2MzgFWHq
         YfDPGjUNqRIPjnDb2cVGeM6bZV25M5PwRIgoO2YYG1ZLmUtpcUS/Nj2Updcu8e4nCq9t
         hrH+5ERKMwXQrrcLV06AXhpAnrdkHZzx/3Ni58DVOKNVQ1eKUvy1PeQHLSZqQDoOf+bO
         K1a2o+LFLp/P4JXlcz4G7vxew6fDdSAZbtXcOB0pgWywxIBi+RLVtcQxWl92x9X+Qjun
         HvxM+0esZYiJQ7W4raAcPIoNGTzo+dszP4xlRrFByRiFwCRroIZb4nGEADZIzLDoNJtg
         waJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=6aJbgb5TBtxqaXU8ze5xtILpaV7oTM2qMWVvD4eYMMg=;
        b=R/cTFYXVNg84epQ3djk42DEAu50XuV8pKGXSiTCX6llXL/OzdUH+auoGsf9FJkBG8p
         n+WJlYXyQfdgjTUd1nCB3Hjl+mGIT3E8C+uScfN6+emkBOOmJLsrj2XNVOEuGf0BXSGV
         SYieafSjJhN1k7AC30WhVu6BEHz/GZ+pIREDP6ffETaH7KhhCZl1nNp9rkf0Mx/qfB91
         PMTJ3gCc2UQHSggtVqn54aWM/TtR1psQaL2yjeIXQcUuPvgzLpUAl9NJ/yBBG+eHrjoc
         M4GvevXt0EEYi7L78+hN2RWpYe8p3jGnpE2aBMBnI/3qQY3jCpQRHPe0ufxJRHMLCWXy
         LsXA==
X-Gm-Message-State: AOAM533q+u+S3tD4dU1u5VNV2GBmIJCVKgpo+S4E9YPVk27D0oK/4Gmq
        25d4MoSutkoxEc2b/6cr4PY=
X-Google-Smtp-Source: ABdhPJx44bwMIbYNcXKLGrFaZqKLByeMp44YGJQ4gdVhG3umZ5+JGyqYIOQxIKHM5cKEBxI/RCZxKw==
X-Received: by 2002:a05:6830:3482:: with SMTP id c2mr319661otu.16.1630619436527;
        Thu, 02 Sep 2021 14:50:36 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w9sm591590oti.35.2021.09.02.14.50.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 14:50:36 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 2 Sep 2021 14:50:34 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/33] 4.19.206-rc1 review
Message-ID: <20210902215034.GD4158230@roeck-us.net>
References: <20210901122250.752620302@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901122250.752620302@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 01, 2021 at 02:27:49PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.206 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 438 pass: 438 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
