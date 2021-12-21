Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69A2547C987
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 00:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235216AbhLUXMc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 18:12:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234684AbhLUXMb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Dec 2021 18:12:31 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7D9C061574;
        Tue, 21 Dec 2021 15:12:31 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id v6so1045276oib.13;
        Tue, 21 Dec 2021 15:12:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=g0mH/Qw49e6+PM6tbEgw9bZbSCl1gMykjtc9ehIYC7Q=;
        b=ZM6Xauh9qHZi2FWeS9e0FmFPyF5tLswPzXW7ljLHfr70THbR6qegS+LPFtJrrzTR0m
         e2SU055OdsnIU7FOXUjgNgJCvjG3U+vKd3KPOoj2v/gAEQ2mtgdiMjcjeHHW92vvdcgC
         pkuS+ugQtLTbwlC1GPYqZCeRwFTDpjNw4QtsCtVdwZnv3V9ocX0syU+yaHEKzD0FsEmn
         D+rtk60+a980faqWZcKlnwqyh4X6muad0rBYjbg5rThGqvDlPWS2qk62qD0+FdwoNlEN
         Tbt9EiiVLXUh2iTsqA1dtlYL9AS8d+sEf1tpH8cZvO1htqlcIjeKCRhT6hTd4g0xICfn
         PSYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=g0mH/Qw49e6+PM6tbEgw9bZbSCl1gMykjtc9ehIYC7Q=;
        b=K/Gvp85a7T9ifADifnwbCdbGoSrHMhsUo9XDgFqHxLDCTz/I1Xz/NPm1Ll1uxPkVQP
         SSqE/8EPBLRwW1RM/gXkWEdpw9fS0/NlGwNX61e4x/8IQDyL8qo39RQC+PMMFSymZ3ko
         2nfDz3pHK3BqU7SwERXx55MzTwVmM56Gy8Qhsad7O8IgXIkloqSkabX49lMMxW7rAOuk
         BuJllfQja8wHSxZX4HpcEx3GL43SDJl8guBAXtBc9Shqd7iJEWnKf6ybK+Pw8u4hush3
         8iZMSVDXWTe9y2bbAFCDA6pbqM76O5gloAyv3+lO0aLJJM7ePFga9YYtOBNz+Zcq3vnX
         vPEQ==
X-Gm-Message-State: AOAM530D1mdZtuNy3qPXWazu0T1UYUGPSgV5HZHSBMwUTBGJGZUhMEQv
        a+9WEFJ+MfiY5P+zauxsyjc=
X-Google-Smtp-Source: ABdhPJxKYS5VWFIttJCYdaSJgvTQbwCMCdL6qQzWcWDquL6Dx0WVe8+3bPtkDI7vmnZ+TrnqzwVwFQ==
X-Received: by 2002:a05:6808:1058:: with SMTP id c24mr469175oih.58.1640128350990;
        Tue, 21 Dec 2021 15:12:30 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t13sm62808oiw.30.2021.12.21.15.12.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 15:12:30 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 21 Dec 2021 15:12:29 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/45] 4.14.259-rc1 review
Message-ID: <20211221231229.GC2536230@roeck-us.net>
References: <20211220143022.266532675@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211220143022.266532675@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 20, 2021 at 03:33:55PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.259 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Dec 2021 14:30:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 421 pass: 421 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
