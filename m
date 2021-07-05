Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2453BC36E
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 22:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbhGEUmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 16:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbhGEUmH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 16:42:07 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F251C061574;
        Mon,  5 Jul 2021 13:39:30 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id h9so22050496oih.4;
        Mon, 05 Jul 2021 13:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7v+MPV4w9LwHg9kzg0lkoslkBvwHebim1lk8HYafM/k=;
        b=jIjfUFVuUBYm3Fnte0E/1645XZ8YavQgWZL5CsX6So8xodWw16bajBOiJmIa47zbH5
         DTgsNN4C7goERe4S0StOwC61ulZ1vo6uPu2RT/DnVEZawEiXj+n5v2ZeBHwJCKfeMtAj
         OK8V4mcEK6EVNd+OiyRlEj87TsytnGT/MuF0BUxFS9HbswwkfYLAr/DaeKYwIlAT+wM0
         z4hNL+5LiUKSeHnOB0F0H6UCVPhN3FmPzPorNX2Ybi0CS4SFe8kjU7cyo+qHqMVaImqQ
         8l5NlLKvmMQkjVXAjFpIbK92LxSGZUyWg+0IZtjI3uTHxwZro9CEO+tNBR6abbDEusYt
         Od7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=7v+MPV4w9LwHg9kzg0lkoslkBvwHebim1lk8HYafM/k=;
        b=XbB/F/HEHtNO35Sdm8AgTsESnasthneznoZKEDUMi3/wzxnjwHUMrlnyPe4ZTGNLcV
         F/eIRNKpcUjlTdDsR36d9MX4Qdcnk3CSxBlveNbtIM8HzlXt9szTLBn0stIWxaSsEMG4
         kYKNYohl+3NtO+Dpiu8E1K0ihmJ+RBb8rHja+ue/upLBsq68fpQQSpFwFWXDc53Amfwr
         VY9SKPbTcsHGjhuRzCq8AyEXpgCNhNHKQ83QNKbQgoXby/IzoaE+vtlHjuLLmwjM1FJq
         uIODe8VxvzqkWoZVNeBIfb3UpdnVfeYJ8u2UGzr+14qEZG66ilrLglHJXd9y46Qcgtrv
         C7rg==
X-Gm-Message-State: AOAM533bEouxy5SwZNDEdus6hYm9muGmB2deMipzWjqvnt9/Khva1IQ6
        whedpEbC7XfE4XRPx7h1Y+s=
X-Google-Smtp-Source: ABdhPJwPoIQ62ginrK5JCEGdIZuT4+IkEjosPs+3CxFcjn/D3WsW17PCevySuyfZL6qyYn0rGiWntw==
X-Received: by 2002:aca:d60f:: with SMTP id n15mr9137314oig.176.1625517569767;
        Mon, 05 Jul 2021 13:39:29 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 25sm2261935oir.58.2021.07.05.13.39.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 13:39:29 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 5 Jul 2021 13:39:28 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de
Subject: Re: [PATCH 5.12 0/7] 5.12.15-rc1 review
Message-ID: <20210705203928.GC3118687@roeck-us.net>
References: <20210705105934.1513188-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210705105934.1513188-1-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 05, 2021 at 06:59:27AM -0400, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 5.12.15 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 07 Jul 2021 10:59:20 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 151 pass: 151 fail: 0
Qemu test results:
	total: 462 pass: 462 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
