Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0584A315611
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 19:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233197AbhBISfl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 13:35:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233469AbhBIS2z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 13:28:55 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0768C061222;
        Tue,  9 Feb 2021 10:14:18 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id v193so14953403oie.8;
        Tue, 09 Feb 2021 10:14:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uC2sHfG55Bhg5AF+u4X4Z3yOGvnoP1M4X1biD+7KcZE=;
        b=dNWufn47yiyXuCQXxDx0Un98ZyxUmwSTzDT9XUN32dyKOxsXXm2Ta3yr8COSHv4A+1
         WuxpRrxx5odr61XuHBgKZ2xhyIVI91c534EM8VXHn7IB55m7UlZvqMlxu+t9d64Mi/P2
         TAscsOGAivSKbZuyBHYsx2HQVsDRFvYG5iZk/rP+Cdaj8UhLDC6pAJlpXwaBlb0C7DCo
         047vF+0s2IsvAJmvEN9deJlRB9+qVzfVm2MUOiLMHQvvihGDaS2In14MfyeoscQLEFke
         1NwSYmMErmGQ02NwOxtIkEDejCbYcvGju0WwHf6/6a20u4m4LqkDpuPbbXK3g0sTVKW2
         xxIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=uC2sHfG55Bhg5AF+u4X4Z3yOGvnoP1M4X1biD+7KcZE=;
        b=HOI9IQpRaGTNZ5p5O2B9oXUt7thzPGDni4KQS3Ma41pTehFJ6mOz0ls3rCQFIq+Dkn
         BLCVOk2QDT8mos/UBsg6nR9j1b5xaVlT9n65i4F/dYClClvmPMw9j0Po1XvSg6Cj4IJo
         CPpwx73Xj9hHBdygRqSTiP2BpP6jyy4iw+pRHFUqfwiZp7Y96R6jKVGylUnTzmfpbqDT
         ciBMlk/m6S7G0/WV7nNCY6r3o28d0CrTCwP7OpdoY3NgjYiNQJDpMy1XQuHP09WNFWTG
         AQ621Fy4lZG+vdGaDSCofDyJdz0HlOKA+n7Oibf5GNNmbVDxejdNW664ufO/1wpxx4ID
         C+UQ==
X-Gm-Message-State: AOAM531kf0apjLnZGcx8rveWrIaWniz2BTDcpq8R85mQqPrkM7fluH84
        2L25upZQF+UgSwFgahvdsS0=
X-Google-Smtp-Source: ABdhPJymhedgx5s/7DHLnNUaPN4aPbAKv0i8gj0otoKe7Vp36HG0eh37jjdhPrgsW2tVfsAmbx/J4Q==
X-Received: by 2002:aca:fc0c:: with SMTP id a12mr3166763oii.5.1612894458250;
        Tue, 09 Feb 2021 10:14:18 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c2sm4213603ooo.17.2021.02.09.10.14.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 09 Feb 2021 10:14:17 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 9 Feb 2021 10:14:16 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/65] 5.4.97-rc1 review
Message-ID: <20210209181416.GA142754@roeck-us.net>
References: <20210208145810.230485165@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208145810.230485165@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 08, 2021 at 04:00:32PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.97 release.
> There are 65 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 Feb 2021 14:57:55 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 427 pass: 427 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
