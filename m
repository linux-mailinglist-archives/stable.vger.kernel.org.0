Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0E7409EF4
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 23:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244592AbhIMVQQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 17:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243974AbhIMVQP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 17:16:15 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F6AC061574;
        Mon, 13 Sep 2021 14:14:59 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id m21-20020a17090a859500b00197688449c4so1085680pjn.0;
        Mon, 13 Sep 2021 14:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=cTJGsnmU8yvelUHgpPgOpFMhebEW0Np4c1cofoJEIuo=;
        b=S25A87kJoQJQmPTpwvevtIExxObpISsSCAXbjemiB7i7N0TBqxcQTTAZCzsX2nENLN
         CIZeNXdsqTQ0WL+VYrE7glXJoqE6UQdHXX965AisAN+dE1pgJlYImNnLEotuXWo8iZC+
         ogBi4fJiVj0V1HEjSQyEaKLON9uT5msC9MDTKAl14M3BJ6ZSkXwZfJB3yv8Ntn3XM+DK
         bf8Y/ANVjcygEMXGBY5j2diAkjpzRo6v3U4z+NStLh4mPmLHczQDJX8G4LW1hixKglJ+
         kwXMd5CV3pE6vg3AyLGaJEcx+ZdqVmyVXORH0hQEeOS71miQ8HYEQW6C8YTOfuBBwGgZ
         EoWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=cTJGsnmU8yvelUHgpPgOpFMhebEW0Np4c1cofoJEIuo=;
        b=10ioYA60ZS3dvO0AYqrN/wIAoEV7UHZvCgNT+svoD4OJZYhLQpsLJ8xzu75jIh8DwC
         bTxpLbOsehGETm9tr9cc5NRynyYgO4esnyZTN4WttWrAcVIsGyLsNf22WsBl/gJ2n6+5
         lcXPygb6SUJEIsXiFGTtcR6Kj7xZWdmIvqQJn9rqzueL1j75NQ33fOhLjZVbVy4okHFH
         QE7UygxjP6V+P+Pmb9CH3JTNZW9MM9KWKUSqsBP60YzpmHAScfQWe97sjkM0WfElBwH4
         LuZFzGwoIGOq3TSzdEWerUKNrSCP4gCGx8RX5Ui/Fmwr/7+4TXhR6eElU6N92z2Uiuey
         P3fQ==
X-Gm-Message-State: AOAM530V1p+UaKqfw8cNxZXHnsRhbkrTcw194JKZMi+k1FMmQo/CNkXU
        4FeydYjZkjYjP31anB2NYq23KDBO+rYdFosesTI=
X-Google-Smtp-Source: ABdhPJyxMaVXs3yIgyckriOJc9qI+r12Idlpn8haNlwpaBxLgYiCjNL1NuQvHk2+6fYa1gNP0D9qcw==
X-Received: by 2002:a17:90b:4a8a:: with SMTP id lp10mr1580764pjb.216.1631567698522;
        Mon, 13 Sep 2021 14:14:58 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id y3sm7548069pjg.7.2021.09.13.14.14.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 14:14:58 -0700 (PDT)
Message-ID: <613fbf52.1c69fb81.1a3eb.5d54@mx.google.com>
Date:   Mon, 13 Sep 2021 14:14:58 -0700 (PDT)
X-Google-Original-Date: Mon, 13 Sep 2021 21:14:56 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
Subject: RE: [PATCH 5.13 000/300] 5.13.17-rc1 review
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

On Mon, 13 Sep 2021 15:11:01 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.13.17 release.
> There are 300 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Sep 2021 13:10:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.13.17-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

