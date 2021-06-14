Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400263A6BF5
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 18:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234546AbhFNQhv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 12:37:51 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:42830 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234470AbhFNQhu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 12:37:50 -0400
Received: by mail-pj1-f50.google.com with SMTP id md2-20020a17090b23c2b029016de4440381so341652pjb.1;
        Mon, 14 Jun 2021 09:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=7GpXpQ6p/q5LJyJma0Mx9AxuXvqCzl20g2ThQbzoAlU=;
        b=Gbc4nm3yqkjJkxlquP/DH15gGqEiklxYhPadqahgbPEDw3tLCo4GQTDukPY8w4MvG6
         j02HFfcp+hxcOU03+SqPFTeeRDEeP0nRJ0Rcgyz5bbbXqSoRGHygKG02cWnvdSWFTPMm
         rrptc5ojbHUUCzuoQdfdQWf7UOR4HbdE+P/1qAm5TH4e+wrqVj1bn+Vvobt1P/kdwUhf
         auYS1cFjlFIZnuSCI6egQNDLvlWNt+Payps4bquwXEhW7FOVEUfNkXGNjq6i6UAKVX9X
         +ZbCjuKGQLcLYvzKpaKUVvpCaKMDxT6yZWTLmQHj3mpHxVj7jivEdOq1oqyVU4MMJ2CY
         LLZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=7GpXpQ6p/q5LJyJma0Mx9AxuXvqCzl20g2ThQbzoAlU=;
        b=Q1lwptDq6yMwKQMPAb8ZAB8TeudxBEOd1zUOQoXEgBhVgSv0UdR1ajquVTLZX2nBcC
         WxPBddKh+izbwdx7ajJ568gHjAl6/OffEjcAKbZyKbldpvcnaIocTwxmOXos9R0J0VFz
         S7MgPkP61o5JlsrSumxSKqbO0aZQjn/LaHjR7mL+ZeR3o51WRGRHkIrKyKBbo8Si0V3Q
         eva61VWcC/uBvxzWekhE30Tf2iJoZRkZqv1sPkZO3yIog2yUAUD7pVDX9jQYHD85rIMS
         sTYJ/ub5mHldUdcZQFuXluNqnorsBPILLj7mKSP/3bkZ6Y5fTisMq+y7t9YxVVsFIUOX
         iENQ==
X-Gm-Message-State: AOAM530Q9rc+C3sMeRkFUQyPVLB/F1sBVi4uarSl8r30hvfufn7tkffi
        +zojtDJ9Lq0wl8Xy0D5DCRELqms/XMUpKIocsn+jCQ==
X-Google-Smtp-Source: ABdhPJymmKV0grDz1brD7WlNyXZgOS4Lye9HYQ0LSSdvyD6Ffp0/+BGDPcIkRy7AnjlcVxPYFmDQBw==
X-Received: by 2002:a17:90a:5795:: with SMTP id g21mr2616053pji.235.1623688487123;
        Mon, 14 Jun 2021 09:34:47 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id l201sm13112213pfd.183.2021.06.14.09.34.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 09:34:46 -0700 (PDT)
Message-ID: <60c78526.1c69fb81.6b7f8.512d@mx.google.com>
Date:   Mon, 14 Jun 2021 09:34:46 -0700 (PDT)
X-Google-Original-Date: Mon, 14 Jun 2021 16:34:40 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
Subject: RE: [PATCH 5.12 000/173] 5.12.11-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Jun 2021 12:25:32 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.12.11 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Jun 2021 10:26:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.12.11-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

