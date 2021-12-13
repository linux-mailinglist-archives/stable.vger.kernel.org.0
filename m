Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC5D47355D
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 20:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237543AbhLMT4t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 14:56:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237307AbhLMT4s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 14:56:48 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83390C061574;
        Mon, 13 Dec 2021 11:56:48 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id r26so24609502oiw.5;
        Mon, 13 Dec 2021 11:56:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7YGIp5I7VEviDx/z1uBwH7MU/NMziwskhWfGZge5r5M=;
        b=Qs0ZHWuojXd8xK3kZMtCGfIu2axcJMMIWMNbKmou5u9aVvMblYBNtSG7+gKZx2/pmD
         VrmYTfNW/icUoDhRa5FYdaaTcQmmg8sjaDlZ+azyq77ttVuhtiwm2mwfl4HgmIyK6Zae
         CSZexTgUNneE7ho/oQYsoIXDNgZhGqBfWTQqlVsm/R/sPpsw2j157PSGDeyfFDsM+BwD
         p8kCP4eCiSBtwH2sxRLgpxgB9N0S5BQSbCNuAijO0Rs4ub737hxemPmJSV4O+94N7Wca
         tmXrlBE01jFU/T1Po6eHG4hGBXPfCeKr0l/OTDpn1vB9gRjYFlYeTvjM0SfhJuZ/EgZH
         34IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=7YGIp5I7VEviDx/z1uBwH7MU/NMziwskhWfGZge5r5M=;
        b=wOIVnsZ8xYsy7/FQm0U87jHcej7iFvwF2GFTuV1nnD37J5GAUe6vlVYvCdVk3C5rtZ
         AFRkp0jggzGH9Gkgb1aofOGqmyQ/pZbtScJCx3BzTTjN6W1JPaAEyVg7KuQ9+TbdDCBa
         FWKKNtOfk1Y8fqnk7KEoc6R7GZ7NbR8BSXAgFjzgPmiJ1z3WC1ha2ogzB0GDZLBew9cz
         tydEsRu0kdymOFA5BDKYMEWJi0aB2cPGRITI/DYs8C4AGjr/fJtYQKDzOztLKXBdkSS7
         +5f4X3F3xNHyogKDWArfY38/yNxRb+DC9tWTET7d9F4wbZPXsaKhEnUMvT5B4WM9ekQ8
         pSqQ==
X-Gm-Message-State: AOAM531syhNw53yuwXV1Cqr4tlDx9bENynI0Pm9eYU5J59At4rQYu8uC
        KDy3VS7zwKiTor+PLTYU4Ac=
X-Google-Smtp-Source: ABdhPJyu+sOS4OEBF2+F8M5HkcOOML27K0JWnWeS+nVeI9WVv+XdQ8tKulNgD/ONaX0k9lP1jqYyQQ==
X-Received: by 2002:aca:5b87:: with SMTP id p129mr703670oib.30.1639425407974;
        Mon, 13 Dec 2021 11:56:47 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i16sm2845823oig.15.2021.12.13.11.56.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 11:56:47 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 13 Dec 2021 11:56:46 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 000/171] 5.15.8-rc1 review
Message-ID: <20211213195646.GG2950232@roeck-us.net>
References: <20211213092945.091487407@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 13, 2021 at 10:28:35AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.8 release.
> There are 171 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 480 pass: 480 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
