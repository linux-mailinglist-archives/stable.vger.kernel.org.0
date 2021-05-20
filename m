Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67CC938B9CB
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 00:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbhETWzH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 18:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232354AbhETWzH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 18:55:07 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77497C061574;
        Thu, 20 May 2021 15:53:45 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id v22so17960985oic.2;
        Thu, 20 May 2021 15:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cHn9MdxkQky+OSsNrVqrs1cMi8tNCSEVaIOL13EfDRo=;
        b=Injv61rtAxvw52WUvibHgOiMOT951mdlayFs/TXIfozOk3lpAG+MxVzcCZ8NUFlypO
         u77JbJ6YZJWPv17ZeEFuSkZIcKvfWVv/kh2hYIFnaAl6SWglrzORNanf341Q6yDP3/NH
         Sy4HLixa/aFYnoPDimiPVRsSu2QsmYXiJMGvf4iFIXdSoH9vf1jssHxwfVVuxQs5jrBM
         mWFKVb26i/5TYliknYfUnMZEOM/Jq1lxxHPg6sO0nAB7QGpXLzHXr42hg4OuwEu92M6o
         rqhqUFL5S56PRkx5FuiI4mGSEZjtcunNHuDZ3W4lYDQjqVzJ0RQEjrE7TZBVA+1eZUwG
         h/5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=cHn9MdxkQky+OSsNrVqrs1cMi8tNCSEVaIOL13EfDRo=;
        b=hk6fFl2BbjANrpGxIj34eGTOth03sokI7Ueid+hJtnpErcPt+c9aqod4BgBPfHoLmo
         VT3Rc28yuVkGrvPV2iGGDWS4XVijHKttaoiGtcPsKxrjhKJhzgVPSRO2oUItMpcA4lTf
         nX/7yhiTvwDp7DnkYG5oLNNEB+DpFt3ENDupyx6gh2qL+0+a6OCbIig6o641W/lKp+ZC
         u2I/Dkts825qRKFmKuZ1W8cg29U/kxVYgbXKxd7/cdSecEjX6o2tEakNAvwhDkSyK0tR
         MjNiknLy4o1yCbH62vFLny7DdQgTKxs0KqjDD/OfLDes+pWXT0qvtGXS4XL+1K6AK6JT
         rabw==
X-Gm-Message-State: AOAM533rCxTL6fTZy3/L/bNrTwUpdJNIvZpNXwk7I+03ux/WzeyiFg51
        plL3JzUK+3oeXaSZnaCRlpc=
X-Google-Smtp-Source: ABdhPJzwezxc5xI16Wcmu0k/7Bd+n288knzOPOo+BMHZbzEnE1snzp7d4RKLTRu6Kn4GSyxGKQVICg==
X-Received: by 2002:aca:ead4:: with SMTP id i203mr4977255oih.74.1621551224937;
        Thu, 20 May 2021 15:53:44 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x9sm664564oto.79.2021.05.20.15.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 15:53:44 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 20 May 2021 15:53:43 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/37] 5.4.121-rc1 review
Message-ID: <20210520225343.GD2968078@roeck-us.net>
References: <20210520092052.265851579@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210520092052.265851579@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 20, 2021 at 11:22:21AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.121 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 May 2021 09:20:38 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 428 pass: 428 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
