Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8933ABE49
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 23:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbhFQVl7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Jun 2021 17:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbhFQVl6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Jun 2021 17:41:58 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB59C061574;
        Thu, 17 Jun 2021 14:39:50 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id t40so8119897oiw.8;
        Thu, 17 Jun 2021 14:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=d8Zs8qw7sR61WtkRfigNap0tfqLyndnlbYXYujK4HL8=;
        b=r8GKnDSavWRtxDYDLpbzJZ2zjDf6f861oEt3O0akaT1k9C6/cWeddXrSL0aLhwUhZn
         +zVT2h/sIjJvVj47z2rmP61c1vsYPMPi+6rZqgqvvb8Qw5D/rjfEfDve3yRhKdOv/YdL
         Wk8Kxa8OQRJiKmMj9cKlJBSFi5IXeSlIy1xg/BE5M2oo8AyBJ3Mikd5BT0UkU2OA2rfm
         GmOEbDdtOQij9HBdmxTYl3vE6q5NmPDME23sFAnH3wWX2n4ipTzCLr7LfTYSa/AisyBc
         4q7doOrKljV28cIE53ItPducxMJlyPFrqrBG1AeKKvh1fg/V+8V335XxITCZTEq9cEKd
         /ptg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=d8Zs8qw7sR61WtkRfigNap0tfqLyndnlbYXYujK4HL8=;
        b=PwL1PvlviEPlZ0LmmwUR5IBA/7aGe4ovoiImMMMdqc4IKYHFrlukSwI/hNuOhebsCH
         SEZb/ttvhtvoe2mFqkTPzBHLLljDyRFZoMQ0dSqw7ptwFKZRQsD1XVnaHSy5eQLKrtC6
         WCf3DHhLfJUwzQen11JnpZSwQym0iu+2WC2DSPWvQGct5EW29rVLQTOn72vM6qyPW9xZ
         5j/obs8SiEccswVWbJ8zsubodO4zTvPbmcpWWb61aJkZNTr4L9rgsQKHfKhsgnx0ERPa
         kh07xdk5D2oWKyEry37FHMOXemWDOkUDFcHhxC7CQSE2hIZPcJx5KArRyvzbG9RT8E+u
         Erqw==
X-Gm-Message-State: AOAM531mgoyXxE/jphte0pW2nhvIQpERZN+HdoAN2supL+XDxO5/vrX1
        CQxB3GDalSaeTCmSvlnxze8=
X-Google-Smtp-Source: ABdhPJxITqYaRgLeTnF40W4qaOKmwCO2I/QysO0iR6kMdheR04DjqxQyjVUAAA4HT3fCbh7UbxF1ig==
X-Received: by 2002:a05:6808:ce:: with SMTP id t14mr4849868oic.29.1623965989772;
        Thu, 17 Jun 2021 14:39:49 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t14sm1416542ooh.39.2021.06.17.14.39.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 14:39:49 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 17 Jun 2021 14:39:48 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/38] 5.10.45-rc1 review
Message-ID: <20210617213948.GB2244035@roeck-us.net>
References: <20210616152835.407925718@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616152835.407925718@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 16, 2021 at 05:33:09PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.45 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 18 Jun 2021 15:28:19 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 455 pass: 455 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
