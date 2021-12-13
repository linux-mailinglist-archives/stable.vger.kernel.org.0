Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8421F472E23
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 14:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232259AbhLMNzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 08:55:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233777AbhLMNzM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 08:55:12 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1623BC061574;
        Mon, 13 Dec 2021 05:55:12 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id h24so11933064pjq.2;
        Mon, 13 Dec 2021 05:55:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=YzGxu20MakeDEnN9f5JcG8wOVkG33rDENjBSMh7QoGw=;
        b=M2OdVeC/LKjenUQYOkPjzxW7OA0Y0qiUAcrNC6esAPGnuO5+sJ7Gx/W6wgSoAAurmJ
         XwxEznarK+/Fyim5dLCNxoYENL8iQcIwrNRCSFxCxlEi2VVGphRPnw2buWG2ybUJsQWK
         9W+voLzbJLbyoDikBMnWFw6jO/VlfpV4qNv45DYisueq3L6RS0bhgnSCfZd90F/seLtT
         1Gl9aOS8pXsxVKxcuin9kXKMPPHZ4qLlWh/79AdGgyyuNjuHpmbxMSlExAIA+JlW8en2
         lcNqicgAuZHyJ88jeEY4mNhRCeCVKx6NZ6Ng9lIIM80GJT/6k6uTWeuaTvAk13PizZ7t
         07fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=YzGxu20MakeDEnN9f5JcG8wOVkG33rDENjBSMh7QoGw=;
        b=rwH37uNGWx8m8Ihq74KOCjtrsuEU5sbK4PrHeqcRYsdAHWfZsML0Ad6UYz2AcsILEH
         0qUygUl1jJ+sg+3ppkOWrInXvDClUHO2xXMc1CA73OmC/1CyhZmw+yfgESXsO/nr6meE
         VRL+/y6xovcSvuTfgkd9bZJaSaONRj7MdZppRcvf5AvFuHtHxX61UoaDHx4Upt0HdpaJ
         qUvt7Z46zzfaAwmS+6G9wYB2wcjQDFIPvlM5dhsUj+aKdlHvFTDyWltd5q4XVt7tqp7A
         YrkxGbYAyhDzfHllvEo6Ys2RYYpG5NbI/RnG1MVbvKcsEL325yslUmfdEHJHD80OkxVV
         v/CQ==
X-Gm-Message-State: AOAM530sjfsVC4FTQV9qz7cxuF6oZf8feOme39jBkJAyq6zPYE3D4LK1
        jn4oVcIyqrUdJl6akbU3gNHK3FvuHNfCgd9eaNM=
X-Google-Smtp-Source: ABdhPJwEL79UKNj6qw26G5N6j30WWRgaxCwrLdqOx2zAIaKZlvvC0+8jpeXm2AI+i3w9D517f1vzRQ==
X-Received: by 2002:a17:902:bd88:b0:143:d318:76e6 with SMTP id q8-20020a170902bd8800b00143d31876e6mr96652800pls.66.1639403710822;
        Mon, 13 Dec 2021 05:55:10 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id a6sm7218514pjd.40.2021.12.13.05.55.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 05:55:10 -0800 (PST)
Message-ID: <61b750be.1c69fb81.a81bb.2deb@mx.google.com>
Date:   Mon, 13 Dec 2021 05:55:10 -0800 (PST)
X-Google-Original-Date: Mon, 13 Dec 2021 13:55:04 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
Subject: RE: [PATCH 5.15 000/171] 5.15.8-rc1 review
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

On Mon, 13 Dec 2021 10:28:35 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.8 release.
> There are 171 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.15.8-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

