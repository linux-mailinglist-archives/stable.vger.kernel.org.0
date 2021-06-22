Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9ED3B0F77
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 23:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbhFVVhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 17:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbhFVVhA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Jun 2021 17:37:00 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAFB7C061574;
        Tue, 22 Jun 2021 14:34:43 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id h24-20020a9d64180000b029036edcf8f9a6so22699197otl.3;
        Tue, 22 Jun 2021 14:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fwcNg+ygPgbQ4dNMrpd1UuIL887dBuU4gxTrF6jj+oo=;
        b=rtENRi1g4XKvrtf/zerLqaQD18isaZoYqa+1WnQ7UBAzr02CCmpz6JrNQkObwe8VO1
         7LCyEDJryKF0fLyrPHkwTKvg7FKB7E64X64Mx0rIGRv8kodbK96mOuvblgaJJLA5q7Gh
         74+gLU22hggynaeTcMufkRIuXPo6wo9mjk17VNNKNGPOkSQtMKaX8EjO8PXl0NP7JN7P
         8I1sAXWq/WOpFZjs8kB3L+TxkXTzw8J+ywYDvUb1vnsBqM9h8zsFi0loFMpJwxSHy78M
         3eohF2lWowYMm0gC3P5QjRk7e7mwBDhYKvXL3x0PN96oX0u9o/Vx0a68ag8wdSIMvkXw
         hJmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=fwcNg+ygPgbQ4dNMrpd1UuIL887dBuU4gxTrF6jj+oo=;
        b=OY4eUCn+4OOG1b+dHef55qSSVHm8Widwof8ZqkBeerx1MWLyk0NbRkcS2vBv36JH32
         eyeHV+4YtdBmbcmHP4UnVyWtX11G+g942XnA897SmXBT6OriOoCfTGL5YHiTnyurseH/
         3YAQXVpvOjSVyv7A7xKGD8Ifj5GJRP1nYxyR3ZAtBGsb41Cjj6QVrdt0kEyzuVZLTePb
         cdNmY80v90DOfWx2mL1x4uJCgnYnGZj4HP6A9KkyZGIikjrR9rHPcTpZPSYGHKO25p6J
         E8UTGgEaehP7GwpN+1XsLxMVK6rX8oltEvvG3zDDM8Sif/CfnDxZuRIALzQYrihucSlr
         n3jA==
X-Gm-Message-State: AOAM533D+C0MJIEp8x4bh8CZtnTQP+q7w2k1WxPFkfU4/HZymQj/RQJ4
        w8492EtL0Tc9+fcu2m3ppo8=
X-Google-Smtp-Source: ABdhPJw5OAZGTJvPZO/F+EL/QIS/WhMAzJxEy3M0SuTyaUGDLrjTnUAVzOCX+BAI1LyX+aBF2Jsg9Q==
X-Received: by 2002:a9d:6019:: with SMTP id h25mr4599415otj.317.1624397683268;
        Tue, 22 Jun 2021 14:34:43 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c11sm739545oot.25.2021.06.22.14.34.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 14:34:42 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 22 Jun 2021 14:34:41 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/146] 5.10.46-rc1 review
Message-ID: <20210622213441.GB1296965@roeck-us.net>
References: <20210621154911.244649123@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 21, 2021 at 06:13:50PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.46 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Jun 2021 15:48:46 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 455 pass: 455 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
