Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2614B3DF53F
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 21:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239168AbhHCTQm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 15:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239453AbhHCTQl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Aug 2021 15:16:41 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F140C06175F;
        Tue,  3 Aug 2021 12:16:29 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id 61-20020a9d0d430000b02903eabfc221a9so21762969oti.0;
        Tue, 03 Aug 2021 12:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HCgEE1b51wiASDeGwUy1MK4VODOo/3wTJ8aUA/V+axY=;
        b=ceRrhrAJzWjeJtc5D6yMrlDd6ZgKefN++oa4Oxktzo5YUxCKy7+N87LG5syGgbaYyY
         eqEgEvS9oczD38l53Q86SipeJ/T4GBgE2jAD4zODNk2MIo15c3SzWL2ZtriW64baT7zS
         DG3g9QIN8YKcIYZ9CVxs7m8e8Jc9RVAas80sOQZyC9Lk7Xm27zd8sGdMe3HNbiU8UjAB
         6na/ZRXV527Bl4gjHOoFnxS+Jp0rueZhsI9xSUTMX0BBw5exgn4ojb59LR/Xnrt8C/g7
         FNHa7E36YpnjCetBQh2CMSSzsDhm8Lfa6dBAZKrAIpZ9ZUn4A1JkAVOZgwX/5TIB2MDo
         +MEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=HCgEE1b51wiASDeGwUy1MK4VODOo/3wTJ8aUA/V+axY=;
        b=QLNvN+UTeBu2RRHtmDlRnEHwo4qI2n9uSR1Xoaq4qpPu0KkwX8lxFCMz6D7jjcRHYb
         6yCQQJ2AqySBVlsWcxv+3FiIrgNRQ5B6w9ixPLqdVHOLEP9MdBUEGo0aZjRsA9Ydw+wy
         f6XuM3jvpboSx+eADCtLCsCCbFaJW2BswyFPwJXhMHXkxfRekrNDfjIOJzi46eTtpLiH
         nrDB40e8IbIYzut+U4Tv1oYwGL2X7nyCDr6oTEF5hDbthvF0QKM+jmbuT5tquobYcQeS
         79BcdcPh+hLT9xQjLMYFIPrkdD7W38UTFILEyva4X1nuxyq3ScuBVQ/linwU7HWmUrIG
         szvw==
X-Gm-Message-State: AOAM530xfBHVsKAuVE33kjxL7b41s90GtuHX7w8q5qr9HcSEIljMMFb1
        wn6O6w1VwDHVulMoKRJd3Ww=
X-Google-Smtp-Source: ABdhPJyOyoRw17kpPbvMhNO2Tvu+C8VVflaLWTyi0WKWGCBXoE5mTsINWtcANnKZo3IiIr6N/XX0Uw==
X-Received: by 2002:a9d:1d7:: with SMTP id e81mr16682566ote.106.1628018189087;
        Tue, 03 Aug 2021 12:16:29 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k4sm2614573otp.2.2021.08.03.12.16.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 12:16:28 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 3 Aug 2021 12:16:27 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/67] 5.10.56-rc1 review
Message-ID: <20210803191627.GF3053441@roeck-us.net>
References: <20210802134339.023067817@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802134339.023067817@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 02, 2021 at 03:44:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.56 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Aug 2021 13:43:24 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 467 pass: 467 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
