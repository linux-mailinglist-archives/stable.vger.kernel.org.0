Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C57041A328
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 00:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237575AbhI0WiX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 18:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237501AbhI0WiW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 18:38:22 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D8ACC061575;
        Mon, 27 Sep 2021 15:36:44 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id k17so17217891pff.8;
        Mon, 27 Sep 2021 15:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=Iid0Hd0O+RUNCJJw3MrAwfoiGTT9f1lgfwXnLDmkw5k=;
        b=e9+iArJtko0R/F9mrfNIsVZzk9I/CHaIzFFXUU6qwXZse5WaY1DI0jXdAyFoHLbfk9
         TTSHbENk7Pa3a7NqPj1Q87Vrgad89j80OnCmZ1eDGE5k6CmVgwypOg8IFuOkhP7GdZWA
         n6f412acuuwmavLwGiITV993jsymZd2nic09CpTv4wxlEjMl7GAqDSjLflOi5eYGI7NN
         NQ5F9oFOtAGk64eHiObBtStb7ndjHfwaNZN6vofVIVQJhnj0PFnq26SR3eP6pE5gmzxx
         Xz6JDoF0JavPIysXu/tIx8bI7QmrtTkz7FT7zsJzUBpsfMOa1jHmSdigR2ZYNwOyAnxu
         CUyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=Iid0Hd0O+RUNCJJw3MrAwfoiGTT9f1lgfwXnLDmkw5k=;
        b=jNVogLNL4FahJcq5zzEJErRBvdVdSHneqRhd+WJOy7ML/Ln3uQksSFRtDxdM61/dfv
         4cK3OCfIR1s72gW7x7oTSpwWELT1DKIo+pcYvpaFUHcSNqrpafQ82ptr+Ql542r9s49e
         cOs0NiBx0q+BsMx4CT5OsygR/MaudK1X4huDbx6er+N57vCvJ6P1ze8P9uKmHRgLSAAe
         3/DHRI6boIHyIxfnQfbTNZd3XHHjXCh5KYt0Uop9mO+fE/Zg7SqwOEX9a9+JlQPgnhJq
         QHhSIdUOWhZBeUwou0Zl6e+8tJpy1MP/sNzfLajHWkFjWqx0MASlvRWP0YSiFXao1yw/
         6tRg==
X-Gm-Message-State: AOAM532P4DtobcqpglMoTo5JC66qf5nROJprVT/CoclQZMU73GYZNuBZ
        CFBPNvfnyGSjRit4asJ3skDW5ms23QlxOFIxR0JoOw==
X-Google-Smtp-Source: ABdhPJzeMNyqs2F2HfVItaBqfh1sQAHbuZ67pdKDbR2AwGp4B799TUXeFWB8XzBz81quE95WloeUJQ==
X-Received: by 2002:a65:6919:: with SMTP id s25mr1012190pgq.14.1632782203294;
        Mon, 27 Sep 2021 15:36:43 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id n66sm18231723pfn.142.2021.09.27.15.36.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 15:36:42 -0700 (PDT)
Message-ID: <6152477a.1c69fb81.5c2ee.c931@mx.google.com>
Date:   Mon, 27 Sep 2021 15:36:42 -0700 (PDT)
X-Google-Original-Date: Mon, 27 Sep 2021 22:36:37 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
Subject: RE: [PATCH 5.10 000/103] 5.10.70-rc1 review
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

On Mon, 27 Sep 2021 19:01:32 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.70 release.
> There are 103 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Sep 2021 17:02:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.70-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.70-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

