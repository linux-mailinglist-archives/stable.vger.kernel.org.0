Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B967B43A9A6
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 03:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236110AbhJZBQz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 21:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236078AbhJZBQw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 21:16:52 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0185FC061745;
        Mon, 25 Oct 2021 18:14:28 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id f11so12599902pfc.12;
        Mon, 25 Oct 2021 18:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=M8BDgiMgTEEdzwj24tM/1izVkkyLZ+QZWEpP9NWhiJk=;
        b=TX0DGP3jtOW+0fxffC5fuuU47iwSFChikEMnvL5CjuXMGdNge1Rl55OV4SpTD2rNZw
         DHuJBn089S5/W/SvyAr3Eg+qhf09agnkLa1pY7OY47CVZqPsQPaKrJrk6rbwWl2Sjewk
         YwtIZJSn9KfZ1PNKXpqdCf7jRqpF1xomy6Xmc+PkDgN8Xql/lqIzdXOawYdiZaDFzYg2
         p4umiUa81YSGvgu4noUKNs9fUqBJgfPhGHA/A1uo4RDtaFNVzbGhrHaxn+G93NB6I/C+
         dAMleFI6GlccDJC6aO9DC5zw6EJgX8wP44BAUjGBokzT8Qruyb8mxindr2fB9Y2Zldpt
         sahw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=M8BDgiMgTEEdzwj24tM/1izVkkyLZ+QZWEpP9NWhiJk=;
        b=hn+8UhfF6+jkF/uQx0ZYmpSG/mStlk5vuy2KUoEcE8GUQPz1/2TjtgpXiKY5d7qgEg
         XdYOp7ztCqCluW+MXPejQL8or/1ksN0tKR/Wr9/LZUmq/xQKSc6Yplocci9qWZCq0+xv
         n/zyhVvA8IITtyDVREhfISrz96hSaXgq9htPdNN8IfrKQTPFbvU6usPFbUnW3QVuHf0T
         jf5UwD3W082FflMRVxO8GtFNw7TiW/+l8B3gKy+AOmBEeeMDVu2D8OJtxI9Gi/nEfAM3
         Tg/yry5Cw3VQBHtVKpauh0gNDcjllg48NJXi+angudW4611fdoEBSfEOjC/Eiwz0YPeM
         B9Ww==
X-Gm-Message-State: AOAM533KPPqDg4n+Hf4T4g2Oztl/H5g9fy795sefG2dgGw4Covaaw783
        uyHp1CPxFH6s5GLFxLA1v9gdobld/BbLkcimKBA=
X-Google-Smtp-Source: ABdhPJzkRBpwN7yCVSqrmo1d+OTl0QuQudO58cwSd190OeX449mCxBlWUeXVx1hhBHvgLF1MdhQ6Ag==
X-Received: by 2002:a63:2361:: with SMTP id u33mr16273070pgm.369.1635210867005;
        Mon, 25 Oct 2021 18:14:27 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id x5sm3940658pfh.153.2021.10.25.18.14.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 18:14:26 -0700 (PDT)
Message-ID: <61775672.1c69fb81.f2d13.a494@mx.google.com>
Date:   Mon, 25 Oct 2021 18:14:26 -0700 (PDT)
X-Google-Original-Date: Tue, 26 Oct 2021 01:14:25 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211025190956.374447057@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/95] 5.10.76-rc1 review
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

On Mon, 25 Oct 2021 21:13:57 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.76 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 27 Oct 2021 19:07:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.76-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.76-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

