Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F20C477B49
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 19:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233302AbhLPSIB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 13:08:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240553AbhLPSIB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 13:08:01 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7591C061574;
        Thu, 16 Dec 2021 10:08:00 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id bk14so48507oib.7;
        Thu, 16 Dec 2021 10:08:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=g2Pqfy6l65lMqJYsj0T2K9tMVP0lhzVSN0AdHdUk1Qw=;
        b=iSyt9C30dwEkaIztg8itX5W3JdHJUOz4NHbPVtcGweXUk3a9g7bIKxQfw7G5WUCCQK
         M/aoz+KYQE1w90tuRLibhSoRDzdsYJPvEZCuod3OKwClVdcbkWUZgkMbTHdL8UbNaA85
         h5FpvmGfoDzTDktjWQmaN+JaXk1vGV6z7PsgkppIV7Id2nl7WgQLrY88BPAGuDNz7ARs
         ySC7S7/U3LpZem1HhdRqtzbMTKu5B7uI6Gl3O0x1/npXB2L+TCoegE4b+/9JshB1xiQa
         KRe7lbgo/J0wHFe4Mwy0LG+FGWJf03DDwv+cjX3ywXVVR++4G3JCMVM4lRHexj7kFOm9
         CyBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=g2Pqfy6l65lMqJYsj0T2K9tMVP0lhzVSN0AdHdUk1Qw=;
        b=havfMKufuVJxeBfVPBHBFsctOeD1ZXlV2E6+gxLH7vVN66ZeybRAtzHuuSejwV3Jlc
         jEoNNvZJgb/iqf93sgtLt3lREm0Tv+HAFrVEKjDnllN549aKQejZxyljGcIjs00nscNw
         h5cnL1+FGDpy1MqvYlkFTe2eb4dOnZR1W7V1SpjFy3NhRzAhmnQ2CXtp9+YmDDtvmWF5
         fUA2r4XjhLjy+G7p0wrzu282fPXHNSz2EkKfUrAb1PFS1Wzlq1DS9ETrZQP8DJ/X2NRN
         laaAV0t8evBLwzpAIAktypJVKNGBQXJYrcSbDz45rajHKVFUNpPHvTUgdkdANK4UDXEY
         3nLQ==
X-Gm-Message-State: AOAM531nvoEXB7ico7D3SZN9CchnacBo8Fi/81+lKe2GoC3f4jj1gOEU
        thKGhhWpoVI5dbuB/SEG6qE=
X-Google-Smtp-Source: ABdhPJyy6fvb2a9ctuiMaC7xSz2JR3DpIQRSw4mlc/GkImAp6NSig2b1KFGohP2YkY8745HoQrAL7g==
X-Received: by 2002:a05:6808:118a:: with SMTP id j10mr5066300oil.101.1639678080130;
        Thu, 16 Dec 2021 10:08:00 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s1sm1128465ooo.11.2021.12.16.10.07.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 10:07:59 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 16 Dec 2021 10:07:58 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/33] 5.10.86-rc1 review
Message-ID: <20211216180758.GB1125270@roeck-us.net>
References: <20211215172024.787958154@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215172024.787958154@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 15, 2021 at 06:20:58PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.86 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Dec 2021 17:20:14 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 472 pass: 472 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
