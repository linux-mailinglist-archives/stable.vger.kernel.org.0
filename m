Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F334421C7F
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 04:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhJECRh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 22:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbhJECRh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 22:17:37 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8353EC061745;
        Mon,  4 Oct 2021 19:15:47 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id n64so24238992oih.2;
        Mon, 04 Oct 2021 19:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/cLu1/S7iq87OpIyThMopkJpAXg+ue6Qhstg63B2u3g=;
        b=NH2u6nO4haqCirU1rMLWv37k2HUNJ/arPUKXzQOC7PBq1Dyyv4KIuGWUPofBiUFSF/
         mCCtaohA9A8/6ADrDJJJxIhCk58bb3Ugpj1aPlaZ5mXsVStzwJQ/Jt5worwTvrCNswEu
         vwaV4IFAM3ldHAcyDwnBZAJhygxgkKIJERQb1bmc5cLMSUGjbAzxvZCmX0eUrz9YW0Z6
         4GqLNqtE8CJJLX5ZpJQzYHA+S5IRnWd60qBovTmSY2ssfUAo/WUSJNKbSbKe6wNSJ3Fp
         hpSLLE94hzWCdKtCZ8JYpKrDw0Azwq8uxhdOBPldoDwqnmWQ+Ikf8sr6Kw4oZhndWw8U
         7+3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=/cLu1/S7iq87OpIyThMopkJpAXg+ue6Qhstg63B2u3g=;
        b=0lU070a/wotqFxk91AR/C5SEy6TavkV/TnLkE8ADI6czwLzqE/x4o2E2b7c6uKRAv/
         fhvkVSbtGT0u7v53TZQ9z7QkRiaeQ+hQ8LRU7vc9KgWmUNdT5D13GJpDq5germwdrmzG
         +U8yT4UAckYNebYoaQuDnB2Kyipv79ND3MzQe0GeC/zuNM+6xbJkAQFNn4rScnj/12XU
         QUM0z/5sOWojXpuvY7u/xDrZ0XBfpLYTZoKnO4AvaUU9VB8+l4NEsxtHia5cSOSoOy4v
         D8uoZvaWU2Jzvoizs3McgTRHgO3txJxmZ7tLrOIvfyZsMkUKCgAw9nhx6MMqvHOfEAQB
         rPyA==
X-Gm-Message-State: AOAM5312Z7q+2Yw6lBb80QcDJSqsypnKLFjn7WkQ62GxQxlLI8ufnb4u
        PGECDdJu4tSYQhA8r2NTmrk=
X-Google-Smtp-Source: ABdhPJymaYzf9h5xAg9aScuMhG6h0Tw6vdQ89UXwDCkpMQ/796pc/i1yx1WzaqyOg9paqm8sjcI6aA==
X-Received: by 2002:a05:6808:2128:: with SMTP id r40mr434542oiw.24.1633400146986;
        Mon, 04 Oct 2021 19:15:46 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u17sm3288420ots.22.2021.10.04.19.15.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 19:15:46 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 4 Oct 2021 19:15:45 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/95] 4.19.209-rc1 review
Message-ID: <20211005021545.GD1388923@roeck-us.net>
References: <20211004125033.572932188@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004125033.572932188@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 04, 2021 at 02:51:30PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.209 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Oct 2021 12:50:17 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 439 pass: 5 fail: 434
Failed tests:
	<many>

Again, presumably the same crash as reported by everyone else.

Guenter
