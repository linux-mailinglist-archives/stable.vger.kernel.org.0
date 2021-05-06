Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E204C374D13
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 03:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbhEFBvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 21:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbhEFBvx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 21:51:53 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EE52C061574;
        Wed,  5 May 2021 18:50:52 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id u19-20020a0568302493b02902d61b0d29adso2756082ots.10;
        Wed, 05 May 2021 18:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tSgGUCKxTJuWl9JFY4/2Jxrs6tE4U/e+d6isMh+EsQM=;
        b=ghzSourcKEu1nc0+C+Q1N0OmmZrXpyORs6VBMts9u8WY5wCoHhvculTHwKQxxfsQ3l
         U7LZHyrfBTq1yoXQ2qrAPlAd9NRGzyv2xo5jw5juk/WIFfKFzo7dF4NKpys960QKFznP
         g66QYyKkAXFfCyL4MNdFmt/i7fKZVDvR8UkbIfAhOYfau8ghHyOG3uBs8hXSMrlkMxrM
         4xb7ki2h72L/jr5+erlhiBocFfCigmj2giCcJgQu9d5g3qbsNO9F3sRytZNr3bpXqa8b
         CcC4T5kfKN6mfLA2pfh9XQkkelYucLaxnP5H9mRXtcswcTwJ94biFMRVOBrm7lIaUjPt
         q3xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=tSgGUCKxTJuWl9JFY4/2Jxrs6tE4U/e+d6isMh+EsQM=;
        b=H4CUdsyqDP5fn9tvpiZZLVn8s3l6XTmJtjXqyIZ5m5HmStsi6OpBaHJfMkbd1k8MRj
         hWv4dTvuRnlPEofQzBl7nFiPs1GfOZdEEIptRKdKQCAmZ0YFlCSmbEfIUS1W871oS3oW
         5Ig7vGCkBYGLVd1+OHg64CoVc1/GsNXtj8WTcRaD4ALf2Qu4xLTVEDILgWNxfJiDAzvl
         K009AO2lXDS6FMQe+VMdOz2kQvEEh8MD77RtRtM/5I9oaoRp73zyqsQzdp6d6kRy6zq6
         +90v2wVw7KHGvotQ80OJFlekPwuCLKhw9b09SutjFRME9+Tn8uYMBRRTeGN5aLg/m93W
         ygQw==
X-Gm-Message-State: AOAM533E/AwUYqsst6pgAvUJiYLO298FNmuEr9ZGVYx8uRzBWK0dQxS5
        bnWvyBsSyP3UsdZU9t7Mczw=
X-Google-Smtp-Source: ABdhPJwB4HlLJHm8Ey1gtoujJdqXxoDlZI10CIKT2B0ZO0G2OOFY36BFf1X2Nxb/uAG4YaAxXecHVA==
X-Received: by 2002:a05:6830:55b:: with SMTP id l27mr1332771otb.260.1620265852151;
        Wed, 05 May 2021 18:50:52 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o64sm187447oif.50.2021.05.05.18.50.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 18:50:51 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 5 May 2021 18:50:50 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/29] 5.10.35-rc1 review
Message-ID: <20210506015050.GD731872@roeck-us.net>
References: <20210505112326.195493232@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210505112326.195493232@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 05, 2021 at 02:05:03PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.35 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 May 2021 11:23:16 +0000.
> Anything received after that time might be too late.
> 
[ ... ]
> 
> Shengjiu Wang <shengjiu.wang@nxp.com>
>     ASoC: ak5558: Add MODULE_DEVICE_TABLE
> 
> Shengjiu Wang <shengjiu.wang@nxp.com>
>     ASoC: ak4458: Add MODULE_DEVICE_TABLE
> 

Please remove one of the above.

Other than that,

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 455 pass: 455 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
