Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61A62397EDF
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 04:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbhFBCWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 22:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbhFBCWu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 22:22:50 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B73EBC061574;
        Tue,  1 Jun 2021 19:21:06 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id u11so1333027oiv.1;
        Tue, 01 Jun 2021 19:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0fSJBCMxaoM4NQmOKbp4M7Miv42qY5qVbEGNnTAYMSM=;
        b=Y9i/U1CKik6aGXaW1KVTLCXAwuVUXSFKn44bew7CvU/JT8jN9bvLbGLCq6wudIsCmI
         YHcewnd+dXEVoJW4KxZO11mYv+OAzRdHv/R2J+GtBOc/AdJWuWTOSdNoPVratta3rkSi
         8yqtDBnzGL+4F44Op54trT4dgR4egUkQkKTrC2jPiuTcer8R4cK8sK721XeuBkOxHVdl
         JmoQGmlUydG53AUARu0EiIOv1MetbZ7+9FckWQY8lgckPpa1HMXoKUF7GZtBRXfnid87
         Mg0NjIVvAkI9Ryg2u0X/WJmC7hXOkEt1rwys3/s8Y1Nt8ANryHo4+AgDwmfrYK1NAGSK
         tqCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=0fSJBCMxaoM4NQmOKbp4M7Miv42qY5qVbEGNnTAYMSM=;
        b=hMCXFDvG8Iq6naLc08eslZ9k6RyUVv+oGafgIpH+QDSj5FlZGMFxKA+NJbFIxeDdPG
         zpUutrJIYayqba6nn6b+F8BI56MHJ0gFIUlZEDlhw/w68I2ExyUQv8PVe4pMjH8dwvyV
         BUlR3RgmylWwj7p9o8gY7a6OqQC1Z+X8yrJSZFh36YsFvxS0wfc3ExnvIXb6i7R0zv+L
         W497xpvHC9ZC7YZlILsba9TKLKllfBCcl2i7a9XDoaCsiWN3fFby3USgwtFQ7wuQ1RS3
         PjqPSMifi7uPjKkd87iSogcGf8kZ5Iy3bzn2daq+605svDFZwpoxhbGLf+GPiU6F7xjt
         sJGg==
X-Gm-Message-State: AOAM531WJbUIMLSaqqgj4PG2J+5j83XYtBuixPGfEhGvesnmIP+7MjFi
        ayBFk52a7gpmqe9+VgxDo9Dpi0QgUUc=
X-Google-Smtp-Source: ABdhPJy+jZV2Ep0GhfR8avw5TThterQBvtDUFwRXZeyUfH03xBQn7jaKmX8OETs1NvhBrGcXQ7iWYA==
X-Received: by 2002:aca:602:: with SMTP id 2mr19704459oig.113.1622600466169;
        Tue, 01 Jun 2021 19:21:06 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k18sm4466642otj.42.2021.06.01.19.21.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 19:21:05 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 1 Jun 2021 19:21:03 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/64] 4.4.271-rc2 review
Message-ID: <20210602022103.GA3253484@roeck-us.net>
References: <20210601103052.063407107@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601103052.063407107@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 01, 2021 at 12:31:11PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.271 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 03 Jun 2021 10:30:37 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 326 pass: 326 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
