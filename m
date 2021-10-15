Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 759DD42FDD3
	for <lists+stable@lfdr.de>; Sat, 16 Oct 2021 00:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238827AbhJOWJH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 18:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232796AbhJOWJG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Oct 2021 18:09:06 -0400
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4942EC061570;
        Fri, 15 Oct 2021 15:06:59 -0700 (PDT)
Received: by mail-oo1-xc32.google.com with SMTP id n15-20020a4ad12f000000b002b6e3e5fd5dso3434115oor.1;
        Fri, 15 Oct 2021 15:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CWiscDtyc+oBAUVlDbR9uPD1tUDLm9euPXUnKW0TESY=;
        b=VyYKKyhk8pGUSfL+PieEenyzGcs6NyUekRKjUmoCK8O+P8t0B/P/WOt0XXiaBOl6G2
         zzdCQFw2PD6+rZvrndZOWoo+NS1UYUrXJaWOa7OqMs2j3bzfG8MM/jdVbCg49dzwy4J9
         0c66iTrSOHdexC/+lscTkdpJBDb7xGL8HzFbF0O6b8H3fqmyW0reXypXhj4JVYoSQ30o
         669lfY05yn+bX3BSMo7r9suy+TyI+TmGsWf5UpK5DDh0w3/5LvXq9FWsMGEwVR4yR/Hx
         n7wSptctm7gZFHCqkgrnLqX8HeXFJEhrIutXgJcikwkq9ZZJij1C0kR5gSuytM5Ow5Jq
         cScQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=CWiscDtyc+oBAUVlDbR9uPD1tUDLm9euPXUnKW0TESY=;
        b=bmim9gbq2A3G1is8L4uIRqbzhqDJEb5Ovud7RdWbfA62eZ4TG/WzdXgLlxHp39piwI
         dUi0vvnLUCQFs9oSpoE/MoAff05L7WQM9T4sK6AqfRJ9ewl9hZUzeuceDCv3TVKkjCjn
         eGSIbO9GY58ifyIQpGC9iZvSeRTtaGceLbRhbKbalFspj7zzxd/L7zT1THW/GDzZ/9k4
         uc+hnoko13DGac4RdTtXe9d/A88kV1udXweIh5dwYpmzTTQ8xpJQUiOb3Mo9qJsWDRLI
         yDOuA1Z5LEOPlpiIN7RTuTyorHAJArB9FAIHcVUFntpbA/UQfRr/SmMW2ARLL3Mn5NBr
         AHXg==
X-Gm-Message-State: AOAM533a+nnmVieaVmQHpBJDHLgtyw8yHWtLG2pclUk2lN5pA9qZ7yBB
        sra798alf9YLgyMT/wbDOr0=
X-Google-Smtp-Source: ABdhPJzBWDWx6fO1LN7g729HH+BKJnUg+CTN8t0oQMW1UWXuYRY6STDgTCdARKX3ZDIw0ETnKREBsg==
X-Received: by 2002:a4a:9682:: with SMTP id s2mr10985199ooi.29.1634335618725;
        Fri, 15 Oct 2021 15:06:58 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a10sm1508879otb.7.2021.10.15.15.06.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 15:06:58 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 15 Oct 2021 15:06:57 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/16] 5.4.154-rc1 review
Message-ID: <20211015220657.GD1480361@roeck-us.net>
References: <20211014145207.314256898@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211014145207.314256898@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 14, 2021 at 04:54:03PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.154 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 16 Oct 2021 14:51:59 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 444 pass: 444 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
