Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6AF547C98B
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 00:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235928AbhLUXN1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 18:13:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234684AbhLUXN0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Dec 2021 18:13:26 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C501C061574;
        Tue, 21 Dec 2021 15:13:26 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id i5-20020a05683033e500b0057a369ac614so413012otu.10;
        Tue, 21 Dec 2021 15:13:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mE4x/+EXRn28ALmC0qUcN9vkoss9m1YQ8pLZV6uS/Hk=;
        b=MdWxfYGQYBkcIX3W7rJFi/nMbuDGl2K5iqlhEighHVRJQOmDj59gmuqLxKf10t2Wwe
         uxeTGBv2KjAGCfDr62HQ6JosPtfhlX87B+eNFHBW5YsRZqheVKeiNQZ2xR2b4V5bsVrr
         lGW4+VvqTylWLsCPvlJ7Ej3a/CXAYSjfO/QmpA/nFBRT2HVDJ9rI8LSY+TAgcVP1CSWh
         f5+jtaSuDrDkFI5qI7TEg168pvPQk6PpnTRaeWcKrGtBId5NgYYbnJpr8DJnNaIxWMLu
         D5oH8eXJ9PwEVOAZUjEcn/T070YXh35JlWZS0n+4RYanFAASZimYHF7GLiTLBnBBejm5
         0rsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=mE4x/+EXRn28ALmC0qUcN9vkoss9m1YQ8pLZV6uS/Hk=;
        b=k+f654n/wrVSFGqHJYZZZibb9O+JdrMrNvYTwx2B/Z/Kq/dRrtz3OAccDap4Aj9+Cf
         3he1xN4CJWne+wfyIanQdrgSePx8Y2LYBEXt72xJA1iOdRPynZILzI2ClMAsT0QR6v6S
         WxLqMlgS+TiKf7ohvIF8DXsQtAnW9v+nWiW4AWXO7QEpt+8rbOJyvfL5KhBDd9UOKl9p
         rHUN/Pv5jvhuuFH/T1+wRh3cLSn0jMEBsuYli3/vFwSQhV5GeW7NvYE2gHbWN+gVdOJd
         NRpVRuuhzSScGxEZjDp1UUVPj2heHH5z80Glke7Twf0bJQMq14bZ2cAjG9p8ptqZqwWz
         RnYg==
X-Gm-Message-State: AOAM531tcRnqWQEOwonxIJY2BUSHY2B1y1s4eYtK65R+B8gFX3VVm/Zy
        DwBvMy8PyMCXp+5k2YGqDmw=
X-Google-Smtp-Source: ABdhPJzxUBNx6c8Jg6HKmmf/mtyCsnLwHFJMv1OZxCCAHEqV8iO/R0RgObfOC4pZF6gWTvEiOwxfkA==
X-Received: by 2002:a05:6830:1551:: with SMTP id l17mr373897otp.335.1640128405746;
        Tue, 21 Dec 2021 15:13:25 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l24sm75503oou.20.2021.12.21.15.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 15:13:25 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 21 Dec 2021 15:13:23 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/71] 5.4.168-rc1 review
Message-ID: <20211221231323.GE2536230@roeck-us.net>
References: <20211220143025.683747691@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211220143025.683747691@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 20, 2021 at 03:33:49PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.168 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Dec 2021 14:30:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 444 pass: 444 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
