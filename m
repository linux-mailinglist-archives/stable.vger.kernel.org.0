Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1433EDE70
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 22:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbhHPUJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 16:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbhHPUJv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 16:09:51 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96775C061764;
        Mon, 16 Aug 2021 13:09:19 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id 28-20020a17090a031cb0290178dcd8a4d1so906069pje.0;
        Mon, 16 Aug 2021 13:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=e3i/TRNxZkgmIo5b9GF0JXDAT8twapBtaF7YyisE06E=;
        b=s49OBJ++EqB1i95ifGYY3/hYtZxjjuRiVR4cuXFLyvaXJ3uCqEA/oqOAit5WwQADsx
         6L0gkVCWJv+McoKuEfRaYb4xTb4fnMP9MXEZlXT5yxmIiHQZknlDCo4khtR+I61KFuKS
         yXu4lONfQTpnXPJ3mU1XpyrGLpwM/tpYodqmwtyNjThszpAbwlS5C06QvTrNsDIKoOuW
         q6yRgBiaqZXMTbfZFKTJEMrcymh7SLE3O7VJobTMLfZq42uFKNPjZJvrWhiYievnZHKz
         SVMAdXPx7Z/8aWtytHhDZ2WEAvmnZHuUVs1AZS14CODlghccN2viu2AjLdrB7TA+6T/g
         gAeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=e3i/TRNxZkgmIo5b9GF0JXDAT8twapBtaF7YyisE06E=;
        b=FjkxUXp4Mu7UIG0tEw8fHF9W6OX+C8pS0oboaCte5ffNGgj7AWdvMtTpj2SiIykGEw
         cR92AT4zdfKyhMXr84HTJfLOYqZoOMQBnUUoOKJh5DomEYmmA4t4W5Z9mxsU4bZ8Mx8v
         EAmz4lOniBUMajgv5hUDJBSjiTwbGhppjWH+HpvcxYS2bcGVlcUA8xQGakQJFh++fYQZ
         kuSdoC+rRSROzLyQVmYFGuHEbw6+4MnXj77EtaDPQXyi2s8ei1mZEzQx3+b2qhnOa7CV
         9VmJ9jcIVq5aqFMywvkF+txLIt6IePro/ecYRM+LV0MGi2gQIypzgaLS13h6NR6ikqk0
         7hDg==
X-Gm-Message-State: AOAM531qEt+N1ZASjRE1O7rTu4vbDcNgiBZNuH1DzoqDGFTgVUZN2Beb
        yY29y4jwYzAiBulC+Cyo7WgS4Ekb7F85zLR04VI=
X-Google-Smtp-Source: ABdhPJwH6uqQEw9CUIDqmftwX5hJEX4LhR3FAwDj5p7IjJWBSMFS1nHOmN4YckruKsr43Z8Pm2IGeQ==
X-Received: by 2002:a63:496:: with SMTP id 144mr486326pge.353.1629144558746;
        Mon, 16 Aug 2021 13:09:18 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id g13sm18435pfj.128.2021.08.16.13.09.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 13:09:18 -0700 (PDT)
Message-ID: <611ac5ee.1c69fb81.25042.01d4@mx.google.com>
Date:   Mon, 16 Aug 2021 13:09:18 -0700 (PDT)
X-Google-Original-Date: Mon, 16 Aug 2021 20:09:11 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210816171400.936235973@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/98] 5.10.60-rc2 review
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

On Mon, 16 Aug 2021 19:14:55 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.60 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Aug 2021 17:13:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.60-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.60-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

