Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC9E45E6DE
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 05:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344452AbhKZEd5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 23:33:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344752AbhKZEbx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 23:31:53 -0500
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B79EFC061D5F;
        Thu, 25 Nov 2021 20:14:04 -0800 (PST)
Received: by mail-oo1-xc33.google.com with SMTP id x1-20020a4aea01000000b002c296d82604so2703144ood.9;
        Thu, 25 Nov 2021 20:14:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ysfwz3hFKZFJvNE/jUfhB/xL42BB+R2wPpHfZ3fAAxg=;
        b=ThYRzloaqJSs8sCice+NmokV6TfRJm2zo9AM9mqGGRZW6tRnicB7+ZCvUKtXV5dTZC
         S1DfkYAR88jzcxBAVNmjtVoLgk62pK+mJiwwNp69/3jGDNYcmVcIdAPOZqFSQ60c+MOy
         oLq+0A3u9W50j8+ZRG/7BLSkv3Dck6aLyhldgduRAArkSa9a1yg46C8GG1br/ShIDVGp
         swylApsWEgpgEpvYRsSuvlLcGaPK6jDMfHGJqT9ASfPSNs6lNR5fQWAiAt5gkE4n/vSx
         VmawnuzEX5otUFSoLegDS53LXeXR8Fuk7bondrmRgYXN2GzGTl5NcHRBXSp9mE0m5KaN
         Ei9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Ysfwz3hFKZFJvNE/jUfhB/xL42BB+R2wPpHfZ3fAAxg=;
        b=X4BIMjvYxZ4nm2cwm2XDzqnZ8i7xNFJ+3FTRIzvsBi56P1PB3K5E3OVQwPLP7nl7HG
         Pls6oGoTR4HnJR/NqJSl8V6CzEsIbXivqh5guQjdacMKu7KuRNreiGIwh2GyFmmZVOxb
         cSDt+ST774pZZmnqU4hqG7IiuqualUGaEayc0L3iknDiEFatWbXwW2dMwfBPHzZ257Zu
         ug0qJn2Ermza3H6vmtlH7z7xs0qv8LdzWlEYUDrHGol8RXhVk9xetqe4Vvsc+jN2v+qx
         qWr/KlDpIl4zR/54gw9+eVwTmB2YOSkWSgZry+s/FNxjCiET7XNz6M/mTxSn9KAGoTMH
         dfgg==
X-Gm-Message-State: AOAM533LYOcy+v5eWVOoOLxYRoh9kG8DHpRB30rcffYjI+9vghgnzYGS
        D1nuUdRkF8oPF8VVuA0TDog=
X-Google-Smtp-Source: ABdhPJwDJsGfLAUrw0DRY5qR53Ni1INw3QvxQsWSp2hgBMLVnQqBrQ67uG6vkz9Qrt5Q993d4vHxeg==
X-Received: by 2002:a4a:8746:: with SMTP id a6mr17725096ooi.93.1637900044187;
        Thu, 25 Nov 2021 20:14:04 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m23sm848503otj.39.2021.11.25.20.14.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 20:14:03 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 25 Nov 2021 20:14:02 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/248] 4.14.256-rc3 review
Message-ID: <20211126041402.GC1376219@roeck-us.net>
References: <20211125160530.072182872@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211125160530.072182872@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 25, 2021 at 05:07:22PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.256 release.
> There are 248 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Nov 2021 16:04:58 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 423 pass: 423 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
