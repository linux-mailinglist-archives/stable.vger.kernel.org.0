Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7AB3BD9DA
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 17:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbhGFPRD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 11:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232037AbhGFPRD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Jul 2021 11:17:03 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6416C0613E0;
        Tue,  6 Jul 2021 08:14:23 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id d2so2863163wrn.0;
        Tue, 06 Jul 2021 08:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DgjljfmGgSx9QEsOVA6OlKs2IlS/qr/eXPZE0FkrXyg=;
        b=mM29XqYWQPm+Tom9Y5OS+sukydghYiDLIULz6QS2lw7Uvb1ZqlQIDlu9YXk4zFZ+k7
         uZgNOY3AWdZEGFzgeaDsNhQdT0BzKmn6QObEnfQRUeHSEOvKZM8JQ3xoKwBs+1G6OP8z
         zrVEFr7gNPufKrkhQE+Q+0N0+Ivc1kDu4ppye2Va73C2YYAExQOAoI/3+3vf4eAeCngo
         2s1xY9t02b6WEzuw6/aBdDl0BYNLYtMB+ggPiuA1/60UxvWt88UBf0ti3xr2PYznlG9k
         Afh94gHmMW+xxVsi78k2zCVzAQ+zElk+nqZZSVJnuPOQV4z3ujQiEtYSmevqP01Ft0rM
         0DWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DgjljfmGgSx9QEsOVA6OlKs2IlS/qr/eXPZE0FkrXyg=;
        b=mACIeR4VlIq1+b+QMFUlKy+9iNiIaUt3DsYkaqcn2o7gaE3JGwp531x2eOipcS1RS0
         TwZ308ijzL0FMQ2orzpYGBQ0HCu4tNErDBYiru7KemXnFf1XRR8gS8/DXAZd+pmqaefj
         up0CTrxVqo6mgT0c0L3vgB3Npb79aFE8KwVpEmHqQM8wm64dqXVHYuaK6KhFzsQhgAHf
         r/Q4B+9BkY8zJfqOrS5SUDM7f/dBBezTLLivNEXnyyBZc5NjOuGKwXDBp5gOcNwPbQe+
         7P1uZ5OFTaoVVw8Ie0Eupa34cb5MZy8UGOWIA9ryhy7b2b2k8n6uO863kydyvtZTBLNO
         jh1Q==
X-Gm-Message-State: AOAM533hjMiJqY3DKmo4mlt9lOOaE49+ZOEQtk7m0Zk2O/FC6+cf5tc6
        8q6Jj29VcdlW72qWzLzSIMQ=
X-Google-Smtp-Source: ABdhPJzau4ygOdzbje3ufpsMlCIHsY3m+TjCycdriA59yVS0Ue6Jl9IlcBsUquztXDmLe5yQF2a3+g==
X-Received: by 2002:a5d:6ac4:: with SMTP id u4mr3972919wrw.166.1625584462255;
        Tue, 06 Jul 2021 08:14:22 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id h9sm15840112wmb.35.2021.07.06.08.14.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 08:14:21 -0700 (PDT)
Date:   Tue, 6 Jul 2021 16:14:20 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de
Subject: Re: [PATCH 5.10 0/7] 5.10.48-rc1 review
Message-ID: <YORzTK+qJrbMo8IM@debian>
References: <20210705105957.1513284-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210705105957.1513284-1-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Mon, Jul 05, 2021 at 06:59:50AM -0400, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 5.10.48 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 07 Jul 2021 10:59:49 AM UTC.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210702): 63 configs -> no failure
arm (gcc version 11.1.1 20210702): 105 configs -> no new failure
arm64 (gcc version 11.1.1 20210702): 3 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.
arm64: Booted on rpi4b (4GB model). No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
