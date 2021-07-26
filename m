Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 835183D6786
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 21:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbhGZSxk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 14:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbhGZSxk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Jul 2021 14:53:40 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB500C061757;
        Mon, 26 Jul 2021 12:34:07 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id l24so7869000qtj.4;
        Mon, 26 Jul 2021 12:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=bIXwK5aZiKqtUTSBMf5q0dW8pTBaBYI5PkP0KdmZR5E=;
        b=BiH2TyDnw+7t7ftmiqsv6XUjIodOqZe2S+3XjEn0lJ302dnSgO3kjIFpGN1rKoxkPG
         ofnQModznT4mFV7KdxjDCm/Cazsh6U7O93/qRFZiyrmc3gYzm1IYFd2n4SDggvDTEQRo
         PkJcE87x8gyKfxuWspWLOuBB1SlTf6IJZtURngxcadaW49FF+TBD33CejCVC0SAZChTl
         dQjPiHW1O41R+3xx7Jbb42J6dQlZKUj0a2SCWe9j2YertyOF6yjJG8M0aKQpjUUBAE6d
         cdiGXxEKP1r1MoooVacsjwQ+cxL9pI0nBfmwQv9Xsngc3+1JQn1eBxjSyL9h1ka2V/0r
         euIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=bIXwK5aZiKqtUTSBMf5q0dW8pTBaBYI5PkP0KdmZR5E=;
        b=XhfmIs5HaKx3PUVW0COvv3JO/LJQCgnPa5sxrbTiNrfCJqBhL2LOXVwPYAJPJHXAjz
         kPXoH/oRHBN4fZOC1sq58mrIbhUEkE2+d8d5Mc2+S1ZWABbUUX1qh+x7q/acUYLF3eEt
         OU8S75sQ5Gj1YgL6pFRN0mI9zzAt6R0XZe8xnHDtZ/F5iOg2NFfj9/bI/ZYVS1/TRCx4
         dKIvzSkSNsneZEPiIUkDXOHrbGlCo1qJU/BdEsef1neALsfU/rH2Km/EPWlo4Oh9i8Ql
         DWkPvZFYnFtMW6BObSjZ66cWmTCBiMbTXkU+BNqLCFI3kVlJ2FdVnsrkX4ZbgDJFPcgN
         +sBg==
X-Gm-Message-State: AOAM531SG/nOVpUXb5rFnIl2EF4aph1Zgi+6Nl4/AdKnDFLH+IWzrxX6
        ZgSEQiecTgtY5VM/+waG9yY=
X-Google-Smtp-Source: ABdhPJz90qCIzUYglnz2S1n9osy8wWxOPlJTZAKMuMD9DwwGtHAZyi/XSnoKKJqSFoIqyFHMjJC7oQ==
X-Received: by 2002:aed:20c7:: with SMTP id 65mr7946165qtb.98.1627328046930;
        Mon, 26 Jul 2021 12:34:06 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c11sm406347qth.29.2021.07.26.12.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 12:34:06 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 26 Jul 2021 12:34:04 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/82] 4.14.241-rc1 review
Message-ID: <20210726193404.GA2686017@roeck-us.net>
References: <20210726153828.144714469@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210726153828.144714469@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 26, 2021 at 05:38:00PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.241 release.  There
> are 82 patches in this series, all will be posted as a response to this one.
> If anyone has any issues with these being applied, please let me know.
> 
> Responses should be made by Wed, 28 Jul 2021 15:38:12 +0000.  Anything
> received after that time might be too late.
> 

perf fails to build:

tests/topology.c: In function ‘session_write_header’:
tests/topology.c:53:2: error: implicit declaration of function ‘evlist__delete’; did you mean ‘perf_evlist__delete’?
tests/topology.c:53:2: error: nested extern declaration of ‘evlist__delete’

Guenter
