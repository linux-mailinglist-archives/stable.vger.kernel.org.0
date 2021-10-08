Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 391344272CE
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 23:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243407AbhJHVGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 17:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243424AbhJHVGn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 17:06:43 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE714C061762;
        Fri,  8 Oct 2021 14:04:47 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id g15-20020a9d128f000000b0054e3d55dd81so8048115otg.12;
        Fri, 08 Oct 2021 14:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=otl5Xv/wAb/6wA04ta2GSSujjW2AEaYUVSiQRisCvmM=;
        b=mGhaiC08pKB4DwjAw90CUFaXYni9E83j8N4jMZMFU812HMruQVfbMMHafrAgpGkSnd
         ioN36/2sYfRep+QZ7agBTpPzgPydwbwU/KUZ33wJ//6iZHsLHQxtOdkUoXPmvELxYPG9
         El1Wch30QcHFEGzh1Wi+tjX24lgvmIV2I9sE/eMvyd5gkNweF0+mgHGelpmSVioMIkkv
         sdxEzfGLqhjwuwpGkNiFSaAX/xa/TQ4p7jhAneOTkJd+jWGilYwGJnpFBey9ZJjwi6Sx
         BugHXYXGV622XqJbf3Bl+NqS56HaGMb9fbuhwbVwLhD72jVxsnOK8d53yPWMBF0XuH4S
         lSew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=otl5Xv/wAb/6wA04ta2GSSujjW2AEaYUVSiQRisCvmM=;
        b=qiqHIJX8mxrHnDHM/LEfiR+ShuYsWvUL8dyKAcD02VzBOV7daTeJ6ez3peGj4ZkDdD
         Vibexo0ElBURwcdAKD8mBgsd8eEow2jtRIBR//nJPzNwH1v7H+bf/uc1zhQhL4cVQ2TV
         GnaPOCg/Eux5DjjYB3KIdECU4vpVwIvdv0ZW6vqOVHaZxqvzgHKjG4sW0KbyOjOJvsXy
         eng/gFn4HiilaFqeboQ0ak+aqs/nNJ2LKeVJ/Bm9JjXmZdnmeGuJABoYUtBFyj83YIsi
         +fypz5j+eAz1xav3s1NMAGVeYFHCvxV0wrwpML7T0ptuPRGkHPVWudutxz4WPlgP7Pag
         kL/g==
X-Gm-Message-State: AOAM531mOk3wU1W4LbHE/W6qw9APbvYDoJl9+pxFXOzJAdLXIhXjUkeu
        odLdzUNq0iBSwo/f7IHPmAU=
X-Google-Smtp-Source: ABdhPJxZfTt50ypl1ytHeYAYdZTfxathnbEWfiHE5kqcc6MRlBVdn6tRBkRqayqCWiRdwuRZHBiBMw==
X-Received: by 2002:a9d:784d:: with SMTP id c13mr10581171otm.286.1633727087133;
        Fri, 08 Oct 2021 14:04:47 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l25sm98635oic.54.2021.10.08.14.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 14:04:46 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 8 Oct 2021 14:04:45 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/29] 5.10.72-rc1 review
Message-ID: <20211008210445.GF3473085@roeck-us.net>
References: <20211008112716.914501436@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211008112716.914501436@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 08, 2021 at 01:27:47PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.72 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 10 Oct 2021 11:27:07 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 472 pass: 472 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
