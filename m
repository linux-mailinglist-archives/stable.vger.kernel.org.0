Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73CA13E2F94
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 20:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236800AbhHFS7K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 14:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236433AbhHFS7J (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Aug 2021 14:59:09 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DBFAC061798;
        Fri,  6 Aug 2021 11:58:53 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id w197so9654507qkb.1;
        Fri, 06 Aug 2021 11:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EwPwTGFLGnTMMYpnQ6JiBfLXzZWEL8LJcfsp89PFLeA=;
        b=Kn86eCHmmJdwXwSGNE4czF6wC8+m/HN19fyjWSxLiSwXcD73AUioJiKriT/Q0Ry5OL
         CwMsdWzvLfSL22KxU0Lm4oRfNwDDtGpReoJIku7aU20ouyPnaEuV7ptwKX9GL/0loRYg
         SpcPEsq6EVQXmj1IDdbHwKenqe/8FfDcG2X02GfKU+kxvMfIxQO/UX9d7/VR8m6impOy
         MZ1Ep+qgia8q+fZ5PO6AdFaBENc9C+OfUsuHFXNf41i1GoR4FvMlFZ/k0EkViG2faj+q
         jeGHJJXKlDD3s20WFBABuK484uuiEnq20mlwmnI87YRlfRwTrAQURyn86vZJkRBhqkP3
         BSFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=EwPwTGFLGnTMMYpnQ6JiBfLXzZWEL8LJcfsp89PFLeA=;
        b=Qe0ZZ4vaNarnCUFPNrCKDbLXrsVXRgI4suKsoAnvTQSPr6FQHUP38vZLwKsOOY8cMI
         cVBgt4fvKMI/wt9Jc3UgHUwomMuEknCUTROLlzfmvGSlomyOj57o2HZt4QWMm4pbqUMW
         rTdx0mnRhMGg7Xv6tBlsneUPhF84peArE+JjC/NNQYz0ylRFXJJG7JUnorF1qlQj0rnO
         BevqltQ3Z7OGI+8FBHKHNS8jneUdtCANQ2pRCW9bQJxastChlFyuTaBHEa/xITzwvedZ
         ryVQKJsp9d+KohNIsnYyxP+2L+hbRJdcKI5NteVwMVn9Xv7RIXw1sU+6LPSOJMxUJ12g
         cRDA==
X-Gm-Message-State: AOAM530btGysUyY3sd/J6Q4ZELatEBkbzmXeE0LmDqJtRMrZDtP9zC8m
        jvmdoM8+Gx46pxy+alSXqC0=
X-Google-Smtp-Source: ABdhPJwwdy+sp/fVlM8ZA2BB3ybbm1bGTfb0k+Xz1w3XNY+NUohZqLcSOWvcPvnZKRgsM6j38ZJa+Q==
X-Received: by 2002:a05:620a:1a0a:: with SMTP id bk10mr11461984qkb.274.1628276332570;
        Fri, 06 Aug 2021 11:58:52 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q26sm43087qki.120.2021.08.06.11.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 11:58:52 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 6 Aug 2021 11:58:50 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/23] 5.4.139-rc1 review
Message-ID: <20210806185850.GE2680592@roeck-us.net>
References: <20210806081112.104686873@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210806081112.104686873@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 06, 2021 at 10:16:32AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.139 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 08 Aug 2021 08:11:03 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 445 pass: 445 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
