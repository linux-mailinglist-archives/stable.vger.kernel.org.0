Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98EAC457FA1
	for <lists+stable@lfdr.de>; Sat, 20 Nov 2021 17:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236650AbhKTQzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Nov 2021 11:55:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbhKTQzu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Nov 2021 11:55:50 -0500
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17AB3C061574;
        Sat, 20 Nov 2021 08:52:47 -0800 (PST)
Received: by mail-oo1-xc2f.google.com with SMTP id a11-20020a4ad1cb000000b002c2657270a0so4836736oos.8;
        Sat, 20 Nov 2021 08:52:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GP0164HGrMRdWXWNl3gnXyCmHmXhqsgPuXuti8AJxt8=;
        b=Dkg8lcJeCRxxLaj7S7ZyH5H4hVDiBTqxXfL+GTBkn5GP2GRZJ4dunuf8L+bTdKAzPC
         AH4UW6kT1GFBPuuRgJzV5hg0rKrvCQ6ZtQ0p+MDUMfWVR9oy3RGFmL+lsnLWtoa02JfB
         RoLaXUoql6fXVWaaxEzuLKDEZT5tqWOUAMx1Jbc0C1mkErnx6lKOb16M002cAEc2paDC
         r/cwTxYffjyCRMVJvH2KfW/aGkl4Mj1zkJxIO22/iV8GeQMmInsjglhizZ5AT8kC8I+B
         ABK2CRlg5G7gx5Zxkyf45gU7zrmjXXiDZY95XOAkxKPMLxDUa0OXWZkwvmrZgzI1dzxz
         0SpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=GP0164HGrMRdWXWNl3gnXyCmHmXhqsgPuXuti8AJxt8=;
        b=tSYxaXDliYpoXZQPfHMOpqUo6/4nwermCLqZOruu+dCW7Ko+CQUh+mfXzECTMn4zfd
         FWmaZ7jhSqkXzxd8neXhwLLCwDePNarFfVvZtxojMthh5UBKd+2Rw0ntZazD5j8RvV/H
         QDVGUrGCaVw4CgBAiT0/Xt7kURmXWjHrPi7aYdGKXpNVcTk2ZcMhq/EvOC5Ar5ieWx+x
         2q2y6sNdurIRzigjW0ThWfXDmHHNFpWS7JwKdCWALkeT+YUFbHFoCin34PhFD0TsLKVE
         nU0tzZW8FsociKu+hejtmgJYHLIUR7BmJa7owZQiZSTsOAkQP4lD7TnNkcdi6iHU+Z/P
         S2OQ==
X-Gm-Message-State: AOAM533TWEvGvYscg3G/RQxR9/iOQ8edEYXCeiH90zr6VQeQfQJoCPCk
        NIxuvopfXKciqjwPazPLH14=
X-Google-Smtp-Source: ABdhPJxNnVjPymJ4r+2oNA4nY2dxun2RR4m9uOghXd9KxF2ayV6A4WxgS09OAACtHdVOrr4qQlPNZQ==
X-Received: by 2002:a4a:4f04:: with SMTP id c4mr23452711oob.62.1637427166513;
        Sat, 20 Nov 2021 08:52:46 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c41sm693599otu.7.2021.11.20.08.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Nov 2021 08:52:45 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 20 Nov 2021 08:52:44 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/21] 5.10.81-rc1 review
Message-ID: <20211120165244.GB1237134@roeck-us.net>
References: <20211119171443.892729043@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211119171443.892729043@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 19, 2021 at 06:37:35PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.81 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Nov 2021 17:14:35 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 474 pass: 474 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
