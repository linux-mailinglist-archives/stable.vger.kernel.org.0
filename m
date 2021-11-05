Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D148644639C
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 13:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbhKEMte (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 08:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhKEMtd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Nov 2021 08:49:33 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDAF0C061714;
        Fri,  5 Nov 2021 05:46:53 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id o29so3147174wms.2;
        Fri, 05 Nov 2021 05:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NThPmCA3vO32RA5SsFqbCQGjbrp+6QCfLu1YMTI8nlU=;
        b=S9bUZ74bWYkk6V68emveXgvtPJ5HsKhLW5jD2/Fx1zf69A0zQa5GAyPQa3NCOP5g+x
         uYYWVwQb1gd0b7KdKEEp+sBlXOvRRo7chWxuTaLIYRaBPSjO67FtYyT70Gfg+XeIzYSB
         hj5v2ecSJbBW8JUGn+VTT4mIq9w024C1EFdfSeiRUjIpZa/gQOILpUOONIC166VXsy/4
         XTtnS0yUou323BT5Jvgd9ARKOOD8DiBgzTVQhWTqd8N2qny80+0UR+zManYBfLsiJaCu
         f4+BFMp/3MVNe56fM+QJEsOg7FynGUAXUBmxm3SgeSy4TBSX5vnoidzQRFZO3iuuSzqL
         U90A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NThPmCA3vO32RA5SsFqbCQGjbrp+6QCfLu1YMTI8nlU=;
        b=bIPK8qtBydIItB/wM4ApxWxZQypdrioB1ey4oN94kaw2Joutkv8zvnOnisgqZAwBYb
         f3ZFGltAY1v1x735i2iY+YxY24JMt8DIE/ELSGK9dDu8GzBOvOPV+5dJTyHL/xbaYv+/
         wdPxWbPP7502l122tg3jVEsRTlkbvH7wxco6/3PPU4oRgYBDseMrSkAOzHl13/0k4S1N
         zbjFSdzIXrEy/5HovTeMzjgOjO0UCgoPJKkLkQBK1dhwodaZ2q9cTFfj8znXnFlUhqie
         cn/tABQEOWtajyo5zNxdMj1oIirAFyYfj80szqZ+jP/cq9L/GxzcyxgrLFf4LMPdwyTs
         vmkQ==
X-Gm-Message-State: AOAM533dwaOqreOqOGtbk/o/lEkApVr7yi2Kk/5Yjg4BYZCi/glz5jbj
        FxOAXpPJz0fzR1zA1DOxHbs=
X-Google-Smtp-Source: ABdhPJzg7hrlhlAQtRE4UPQI9Mx7ySmqdUQctvUHEaaCCOjC8gbfdmqIjAlRNNfRlLz131EIyQvQcQ==
X-Received: by 2002:a05:600c:4ed2:: with SMTP id g18mr18942095wmq.18.1636116412487;
        Fri, 05 Nov 2021 05:46:52 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id u23sm391396wru.21.2021.11.05.05.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 05:46:52 -0700 (PDT)
Date:   Fri, 5 Nov 2021 12:46:50 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 0/7] 4.19.216-rc1 review
Message-ID: <YYUnupGBGq9HTRWv@debian>
References: <20211104141158.037189396@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211104141158.037189396@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Nov 04, 2021 at 03:13:03PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.216 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 06 Nov 2021 14:11:51 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211104): 63 configs -> no failure
arm (gcc version 11.2.1 20211104): 116 configs -> no new failure
arm64 (gcc version 11.2.1 20211104): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20211104): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/342


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

