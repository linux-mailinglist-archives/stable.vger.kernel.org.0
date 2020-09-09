Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4C5D263248
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 18:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731086AbgIIQj0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 12:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730871AbgIIQjH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Sep 2020 12:39:07 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F13C061573;
        Wed,  9 Sep 2020 09:39:06 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id d189so2949441oig.12;
        Wed, 09 Sep 2020 09:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ww3mWyWuTFhDbo1n5mXAbWve9LWoufaIChsxhLZ13sI=;
        b=Zr4X8vdZrRuqsw1uFz6anu5hQtYfiEv7lq1qxOZnYa0hsBwawQ2W8yfkPEfbzY3paV
         73EtufYw6hmTOa8k1U3jzX0yXW8GgSV4DJ8kYw7Kd4ZdNMEHSCOgM7DIXhEArRmSDsLc
         Gcr5fS6/W2ns+AlxdvJAZxHjywh9yZCxPgvTdlNqIpWNm1yYLRJL16HyHpJjNm/whHSF
         YEtd60ghqMmufYPqfQfYJSZGlnwhrW5X1vFdBddM/7V0KrgGzG8AxUoau/A8IQAshS4H
         R+0SIMapLc3LEAiJmv3gK+6d8KoO5a++wDnZZS1SJMQWBYJrrcwgxgDoXEgTZUItyf1x
         6I3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Ww3mWyWuTFhDbo1n5mXAbWve9LWoufaIChsxhLZ13sI=;
        b=dVleIWFdiuVFn+aF1ZUtAXZ3eXvSXdKJLKY5kX7oC2XwYR+L3HYm7k7Nm/cBrB/tFd
         jK+6kE9OITa8U6Mxhj71trLEw2ymllfUc2XhDqIFTEMz9RKdMF/kUkeyolUmlxsyApro
         Ky0LStlryO9yrRS89j++fEvahfmcATWGNPiwNToIEUi/JCjg4Pr7wY/42fVrGRFwZIBL
         G05vSyny0/MJGjNpm1MXAEsoQuEoyBPF3VMatReYshJz4l0klbQG/EVFxkDXVEQ4pc3/
         yLc0SpTDqfWOqUFY5Iebb+u1cxZhgrTrB2ohkqe36Z1RQnskd5X0dOGC0L4RH2Vgn3Nj
         sW5Q==
X-Gm-Message-State: AOAM530e4V3315CQcVjEeM+Phtme+EdqD310ZXqTWjAhQ2PfY5yyu3zD
        TyvCkRlja997bw3M41H2cGs=
X-Google-Smtp-Source: ABdhPJzGZp8kSHfXt01A9y5UVNpocAC9m67pQJhZQS7q6Ud1FRAf5cDqhOn1KoLr3VHvXC0XJDrlMg==
X-Received: by 2002:aca:ecc4:: with SMTP id k187mr1122905oih.138.1599669546261;
        Wed, 09 Sep 2020 09:39:06 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w12sm443099oow.22.2020.09.09.09.39.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 09 Sep 2020 09:39:05 -0700 (PDT)
Date:   Wed, 9 Sep 2020 09:39:04 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/65] 4.14.197-rc1 review
Message-ID: <20200909163904.GA1479@roeck-us.net>
References: <20200908152217.022816723@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908152217.022816723@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 08, 2020 at 05:25:45PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.197 release.
> There are 65 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Sep 2020 15:21:57 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 171 pass: 171 fail: 0
Qemu test results:
	total: 408 pass: 408 fail: 0

Guenter
