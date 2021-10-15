Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C3642FDCE
	for <lists+stable@lfdr.de>; Sat, 16 Oct 2021 00:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243204AbhJOWHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 18:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238832AbhJOWHy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Oct 2021 18:07:54 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBBBDC061570;
        Fri, 15 Oct 2021 15:05:46 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id o83so15034669oif.4;
        Fri, 15 Oct 2021 15:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=H6Alg5uwEI98g7UD7ptfR3twq6N1uqKCAhPA4fiUNkM=;
        b=gEEb5lxLeWYPhQZvfciz+4DhFVXhAYNOBNRSbffo2LhoqIhqnlJT4Bb7UKIPRF/xfi
         CzbyfhBHbQdKyBluVMPyqA5TltXvOCgZmuqEjh87D9y5rftAyEG41e4OLYBYcSx0unX+
         /98VTZpsSFbH1zFiN+GpgvipmVNXxYKhY+ux51mf8GweymXXeE4YTvfx2KkF4jNAlP96
         ib4jsZ9MlGwRGlHHCuDQsJGxlOCXiOWYcV/YLvhNzdJOfeEHl8SR6Fs7k768HHJug+Ac
         lcK5JoGaI0Q/EGd8IIzKUndjiZr3hEDivR0k64DZ7w8R2Uv0luBW5g+KTvAs1netFW8V
         K8Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=H6Alg5uwEI98g7UD7ptfR3twq6N1uqKCAhPA4fiUNkM=;
        b=vwR3hLPsJrVpCjL3Lj9CtnYqzUGCg3SvD3oPfmyXS1kT3zrRr2HLxbOs09vZSPDMss
         Gk5Yd+HycEs2K1y1Vpg2J8vlLvPaXowTLwbUvzd8NEw/Skd1BIDXBDFjRxY8nxbaZ1DH
         ZH8aafkxIgPUPr6syp9WMMTzmHSIjFgOxviA+W0Y2+LG4cGP+OTTAf+WTxbgu1BOzhMg
         wxEzvOyVL34QreazQHxJ3vlT5PnGIWx86FaU97RQKe1wr3Q5Uwoam73qW66lU7y42fMu
         11BkHMLwtnaTABpxVL4oHTDQtHyCuvRSlw+rviVELafvTXidHw6CBB6uT38IIQQYZqw1
         VpYw==
X-Gm-Message-State: AOAM530P1oIfSmMAHxLhJV9m4jqZALtvilh9cRgRciAKcvyi9BLupjo/
        lnFFdjtAMMZ3k9M/VN6nnRm/66XbWkk=
X-Google-Smtp-Source: ABdhPJwVDfRgqqqZfiLbjmL2RvGzG+N2fDcFn1Vtbq3LXp0IwlwlvltJjf53vUY7nwWhwLd0EmmPDQ==
X-Received: by 2002:a05:6808:1a86:: with SMTP id bm6mr10340172oib.125.1634335546214;
        Fri, 15 Oct 2021 15:05:46 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r184sm1416278oia.38.2021.10.15.15.05.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 15:05:45 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 15 Oct 2021 15:05:44 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/25] 4.9.287-rc1 review
Message-ID: <20211015220544.GB1480361@roeck-us.net>
References: <20211014145207.575041491@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211014145207.575041491@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 14, 2021 at 04:53:31PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.287 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 16 Oct 2021 14:51:59 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 394 pass: 394 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
