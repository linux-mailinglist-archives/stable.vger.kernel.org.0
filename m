Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6F5B489B45
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 15:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235510AbiAJOau (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 09:30:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235530AbiAJOau (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 09:30:50 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 271A2C061756
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 06:30:50 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so50165pjp.0
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 06:30:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20210112.gappssmtp.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=CcamlWs1isX1h8/o0AFArdkvbA9sYBTbXJp+4ZP/YKk=;
        b=HU6Qa9x23jaVK2yer703j2WbcS80H6hcYzWo9PAXkb4WJDHw0jTysnwJ1nLynGqOkm
         QXSxe1m1x/5gx9XfPt+AUkgOlLuH17Hv+IJ6U8w0SCDs5OFSMa0LstKKDRf2YkpAFVWU
         WHweJ5QeUytstmhZF8LW8UbppMj1SIlf1GZKGOH0zwIYEl9PXILIL/G6Ql1nnqg0pR8/
         2vnj0H335TFXYeHvsVrQNDBrzPk62wZO3Qyw0xbkDPcUPIKNnq35WKyRPghyseojZAZu
         ZxDZb85MLvp/iidMTdi9l+T3xG9t0AeikuLAAmnmtXau41S+iOAACHVEq6TLq7vYuQEh
         q6ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=CcamlWs1isX1h8/o0AFArdkvbA9sYBTbXJp+4ZP/YKk=;
        b=pdasY/J/7JE9ZRgJ6u7ngP9MIKNJpcGF4RKk1XTKryV78XmFkBye+16uIbF3Ovnpym
         U8uI256dy8WW/wjK0fj4Yn+/4MXGN/hS+RSlMpW5lL2gHJMxXaTfA+HaLC1wfYySuJbq
         AihwYTWe961/oFhvsF6rre88lblUizAddxjTCO0QGMzxJjU/7DdQjD1tTpRBPs/cQruZ
         kgg4dhuuWApeoWEl++E3xqq2Vn2E+2MkthLA1c7DsbZTd8R5RTe6ugVGHetlupmvA3WZ
         qNxRth8IESfsuKUc/P3niN/falRj27TPGO6RUqriYP2XYkcJdob3dl3V93CwItucDdgf
         Wfcg==
X-Gm-Message-State: AOAM532CN68UNLppVQ8gx5WE38xV8ro8AvG//QbA/frOrmejdN/KhhUv
        39ST2P+JKjbsMwP2TPLRTY8FDA==
X-Google-Smtp-Source: ABdhPJxUWGGRpFCsoVOLozehyMAHKh4eLISheE8+skZ7k/WXqPvo+cH7yL3vZLm+kX7TToX+scRyaw==
X-Received: by 2002:a17:902:cec2:b0:149:7fa3:3fe3 with SMTP id d2-20020a170902cec200b001497fa33fe3mr64346958plg.161.1641825049689;
        Mon, 10 Jan 2022 06:30:49 -0800 (PST)
Received: from [192.168.1.32] ([122.164.22.119])
        by smtp.gmail.com with ESMTPSA id go19sm7245239pjb.25.2022.01.10.06.30.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 06:30:49 -0800 (PST)
Message-ID: <98aac9ed39d2ca3e0a9163c584d9c361acd86584.camel@rajagiritech.edu.in>
Subject: Re: [PATCH 5.15 00/72] 5.15.14-rc1 review
From:   Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Date:   Mon, 10 Jan 2022 20:00:43 +0530
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
References: <20220110071821.500480371@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2022-01-10 at 08:22 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.14 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied,
> please
> let me know.
> 
> Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>         
> https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.14-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-
> stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
hello,

Compiled  and booted  5.15.14-rc1+ on VivoBook 15_ASUS Laptop X507UAR
. 
No Regression  from dmesg.

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

-- 
software engineer
rajagiri school of engineering and technology - autonomous
