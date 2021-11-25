Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB4045E180
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 21:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232385AbhKYUXz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 15:23:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234768AbhKYUVy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 15:21:54 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9408C0617A0;
        Thu, 25 Nov 2021 12:14:12 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id b12so13996648wrh.4;
        Thu, 25 Nov 2021 12:14:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cGRbAmIntrNReggdNZPPRZCbQxv16T4ePIwmHccKtII=;
        b=qGhk6U6lUDkX6iODY9J/rlWrlJjsTzcluDUgPLZx/ZhjyEy/fm5dsevvfwJ6UsaZjX
         wejDqYw1o3KuUsXIbt5NhbfwrHMOQxaLxq2objnavwXBG+On+8ytBWEngnIuZ6Lrzx7h
         93Yr4DyvNbTrO3nQy+X+w2+4j6ebMgM0ttWo0jJk9uXz4rlh+5rH7ZQZavW5OF5Y6EZk
         UB1YC7XVagT+jC2egknyRlXBiDQD3JCg9ePOrYFqR8F4Wt22lE1pdsj/WvNEC9fTDpCb
         sr/QIY9H+nAr1UlqgIN0xgklRsYjqgRLIpPI8j7m7NN9EfIwcoZXWd/eUNONkOywHr6B
         MIHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cGRbAmIntrNReggdNZPPRZCbQxv16T4ePIwmHccKtII=;
        b=x4jMuPZvKyWExU/tjHfRiNnpiIPXNy51mP29EOaHYaeQ7KKhXoK0SVAQhaJOyORFny
         x3pk5EoFJjoXC4y0cK6rMfUSw92BfCeEpZ2z0eyR6CI6hKROiub0+Trd8DvSRR8d+0F9
         YnZ07uyjF7alfv0eL7rKtD5Vsx8YDSsg5RWcrByVKhowka1oWtff+Fdrp4MX4yVjybGc
         g2ZFaN6zZA9H8LnUtw6QRpMiUnl69v4jOKBdwO3iZRZ12bkkX3A2xYd9iNHVzNoD8wX2
         LIZsC6FFzThiQhTbN8R+/kZqPmuzfKeVkCB0/GCEyBLZa927WxyXQqJIzfdNJObtfs8S
         f67g==
X-Gm-Message-State: AOAM531lhlxcLxlqA4Wu+3NcEk90s1BrYbjbx5dB103RLKDYodJ/Pd7C
        Lky1j7oYWj5h74I5eCK8f9o=
X-Google-Smtp-Source: ABdhPJw1bH0RcFBIJErZH2jKj2I70LTvQb6zLEOeB6YKXg64OyIGn+w24wOc8XhUZ97eLv7IY1yNeQ==
X-Received: by 2002:a5d:614f:: with SMTP id y15mr9385395wrt.587.1637871251449;
        Thu, 25 Nov 2021 12:14:11 -0800 (PST)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id v2sm3578376wmc.36.2021.11.25.12.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 12:14:11 -0800 (PST)
Date:   Thu, 25 Nov 2021 20:14:09 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/153] 5.10.82-rc2 review
Message-ID: <YZ/ukR9KkNZkCQx5@debian>
References: <20211125092029.973858485@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211125092029.973858485@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Nov 25, 2021 at 10:23:48AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.82 release.
> There are 153 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Nov 2021 09:20:04 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211112): 63 configs -> no new failure
arm (gcc version 11.2.1 20211112): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20211112): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20211112): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/430
[2]. https://openqa.qa.codethink.co.uk/tests/427


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

