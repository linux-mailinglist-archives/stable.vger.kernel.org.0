Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EABE9423B26
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 11:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237968AbhJFJ7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 05:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbhJFJ7o (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 05:59:44 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9007C061749;
        Wed,  6 Oct 2021 02:57:52 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 133so2042104pgb.1;
        Wed, 06 Oct 2021 02:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=7FriFJj7WffhxBLqLs76zq/OLQ9MH9uFy8sbq0vYEm4=;
        b=q7RWrIWMUVeToWw+pYw71E0PEoGRtZImX4BT5PqMKdgaVdsmjz6FGyZKcpvHm9vLMb
         SaRwDa/8Q/szr9EYmOs5R22llfP9T5ZtXXRUUlrnvHiUvwVGtXwRli9Lx8/cgoiUd1fU
         soItvXlNNZNTITXNaZpJJ+Ef0yWjLuVzkP4VbNlqLoveN8qjjgykKZJADu1TnWzg11ty
         jxD0WW/0fvokHy/ZbnRMbkN6kIjGzIl9c1aez7+KZY5y2czmvEPMp+LyFAtDPxAPLWfb
         iSgZkutaPMNbLAVj1IoUM5x3QPpwFcAI4oIWha8WZaeyMX0u7AMB+odF2fP75WNW2kH8
         /hrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=7FriFJj7WffhxBLqLs76zq/OLQ9MH9uFy8sbq0vYEm4=;
        b=cXezR0ygtYOXyJor3HxLGDmwqxrYZq3ATVvdBkxKqvdxvJb3bOQbpFekJYwFCU9Stp
         cvUNHPQbHHCEs7YrYOTZlfAt3UZmwdtdd94IqKkbp6xBk64Y+tbxp11bAI2/0s9Fk1Uk
         LxcScDYtZLYagUaYVVJSPPDjiA97DfyDbo0yxlRTjOb9JuYF+/vhAT8wzR2kxQWd9G5V
         kWoRRYH/0Vn4oOcHxbY2WMmjZOYJxw5rOkNJunUpaLxbMo0G+mC+NA9dO/UvhrEHZwLy
         EHyiawPwD38WnUoMVvkMzaW7j8tj2vyAEaTREnWj66uCRJz/EB5wABQS1XutrFHYi+NL
         FSqQ==
X-Gm-Message-State: AOAM531LYpYdMnvnU5SuuODcausLfcXN71dgyVgGO/iH1fehBRwHvUmQ
        LmOodBkkgoSl6c33fxrphjIg/zFiuwbxqeAVWT0=
X-Google-Smtp-Source: ABdhPJyQEHG20kLPf8g5gHznIYBqupucrQCb5koWaJey2oY33RPawpFKc5YM08+9HW7TH/Brf60QTA==
X-Received: by 2002:a65:5845:: with SMTP id s5mr19404801pgr.227.1633514271746;
        Wed, 06 Oct 2021 02:57:51 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id n24sm4573607pfv.144.2021.10.06.02.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 02:57:51 -0700 (PDT)
Message-ID: <615d731f.1c69fb81.6075c.dbf7@mx.google.com>
Date:   Wed, 06 Oct 2021 02:57:51 -0700 (PDT)
X-Google-Original-Date: Wed, 06 Oct 2021 09:57:49 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211006073100.650368172@linuxfoundation.org>
Subject: RE: [PATCH 5.14 000/172] 5.14.10-rc3 review
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

On Wed,  6 Oct 2021 10:19:58 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.14.10 release.
> There are 172 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Oct 2021 07:30:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.10-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.14.10-rc3 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

