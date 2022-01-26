Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16F4D49D509
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 23:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbiAZWLA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 17:11:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiAZWK6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 17:10:58 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272C2C06173B;
        Wed, 26 Jan 2022 14:10:58 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id v67so2307474oie.9;
        Wed, 26 Jan 2022 14:10:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=21ZfAX7z//yYX98NOI1emY/4VG55lyxDMWDLG9aXmHM=;
        b=NURkmVW1jvd6P6HsGBe4RRlTS3L8VK4hukdmV9d7DGEWEZt0L84SHI8atfpPRjCNms
         lkXlEGJ/S8fjcILXMEwhR8yDQuIuOwMF8OzWTOrmk8uNPILDKB+iCg3zML93LXrG+WQY
         OtZjI3iBUSk2Iends2M3PBZ8dW8x6doZwdojDc7eTbgTfEUQcjbk9m3M45k1QgrAiNS8
         pGTXyw2qfmvcIQHtompgxTTUsLwDwi5wPB2SLIgGHnXYbh530YA2JU9e9TZvnzHS2Gor
         h0G4hfsUdZ39iEcYlMDso4/rS6hk1WQmSGaCOVh7J7yzfuOKxmkG9BJS5cxVqpPXyZi9
         wOTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=21ZfAX7z//yYX98NOI1emY/4VG55lyxDMWDLG9aXmHM=;
        b=j5BKp/jQFflddJrjDj2kMYOkurXS0TUgUnPVFjnB9aPDODG0GO3gByAnFK1bybXtOT
         EOCtutkuSv/71L6Rs+z1/NrM9jYAR7ZsE0Kpw7joYltBqRWWPxWILIWHcU+x5dZqdAuX
         lTSVmj4Mc+/BNVCjgeyprt1qFdj+CwWlJH4cdWvMOzwKEjkXmJJkPC9tl/kfFGPnsSGa
         5CKbd7JdZ4ymH+tbzoa2CI2OkFGrj57TMz4kNVEjcX5yGVJSYIAAk65Wh3T1gYOZ8Dlx
         JUEiY4dfHt6PttTvhNgB3F6CC7pLHJ95YQxXNWjjaTDPfe6Fwr+yUKB3AtpP66oI+6ha
         4OCw==
X-Gm-Message-State: AOAM533y8M4UkE0rrD81RIWgpEdBIhL96/Wwtbpdvk2BBbshQVTvZuSP
        5Xxang9xQNBah/4cjqg+oBg=
X-Google-Smtp-Source: ABdhPJxgaSc8/eVC4azfcz1wopvdNHvVvd0s28sQXB/F90K2yk6hRZ/zEF97bOXEODITtiTH5EmqEg==
X-Received: by 2002:a05:6808:ec6:: with SMTP id q6mr438206oiv.244.1643235057548;
        Wed, 26 Jan 2022 14:10:57 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p5sm2940740oou.39.2022.01.26.14.10.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 14:10:56 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 26 Jan 2022 14:10:55 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 000/155] 4.9.298-rc2 review
Message-ID: <20220126221055.GB3650606@roeck-us.net>
References: <20220125155253.051565866@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125155253.051565866@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 25, 2022 at 05:31:50PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.298 release.
> There are 155 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jan 2022 15:52:30 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 397 pass: 397 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
