Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 380414FE765
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 19:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242381AbiDLRnq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 13:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238311AbiDLRnn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 13:43:43 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C285DE47;
        Tue, 12 Apr 2022 10:41:25 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id cw11so2049011pfb.1;
        Tue, 12 Apr 2022 10:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=fMSQntlwd+/xbPrWRwO1YYSdjmQYi5eTkeCVnF/Cadg=;
        b=aiSy9KZRb0TKtuYz0znkNffXbtaoR3PHZnVAvSrWZJBE6R6vksMRbuwvhCqYifQoDG
         iPeBe9frvNFkcbmUff0piTtH3BQBoQSlDA4pvOLXyVQSmZHexvVxHxRFpUx0GQ9z3a8B
         9mH/o2B/t9l4GQZndUHf0QPWKw2jJuBD4+AOAR6iGwtcnZUsFyM0y4NQLmvx16C+cdvn
         uuUUtNifi+b5S/2EuG9MGZ86RMu9yWtPOyerGsrlH/BDJNLAieydFNiD5uqxpUcZkvnJ
         jNVIs6iJxuhuoAxy7S6FyQFI+76gqDmb7SJ+4Sus571zpBKCXuD+LejBTtuifA0v+F2O
         A/sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=fMSQntlwd+/xbPrWRwO1YYSdjmQYi5eTkeCVnF/Cadg=;
        b=WdhZI+FNI/rw4O+8Co1lW+UEeC9GGepQ40UskXEWhD4kKcB96QA8kGZ0Bt1GLYj2Ud
         oScv3VaOLi7Lriwof1kI8N3YAO4hN++f1fNGim6yAHEZU7QFk05yj0U0XnN/ZCZAh+zj
         wR81HTo8iYv3UIGK329eK4HxomAXWIBwAruBMIWAn8sCJhziO40+fsfL9TuSwRBNthUS
         10IHrxWMJtzlpAm8O6+eYCbAd/eybENTl3NznVvUJ/VIdknCz+qKz1go79vsgZvzsfAz
         nFTFLYWClUk9mS62xaMdQDy1LE6Z60i+M6GpKBfYwARiA1kpMker33bicqBVBDYqrw0i
         z1iQ==
X-Gm-Message-State: AOAM532P6taGHjlu7x/fSsq7yUAkds2yJaZfhojLnqsR1lev60I3iY0u
        mcS+85Sq17oZYG+F3dJNmMXHb2TPri2ZWKmXAx4=
X-Google-Smtp-Source: ABdhPJzomvD4HrQatnGG1J//pBwkFBGyXediAbaTEIEK8sH+/C8hH2cl6n7G9YJ+YoSGzULBg2yyRg==
X-Received: by 2002:a63:af42:0:b0:39d:942c:504b with SMTP id s2-20020a63af42000000b0039d942c504bmr3838930pgo.453.1649785283927;
        Tue, 12 Apr 2022 10:41:23 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id fa11-20020a17090af0cb00b001ca6e27a684sm125247pjb.16.2022.04.12.10.41.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 10:41:23 -0700 (PDT)
Message-ID: <6255b9c3.1c69fb81.7480e.0674@mx.google.com>
Date:   Tue, 12 Apr 2022 10:41:23 -0700 (PDT)
X-Google-Original-Date: Tue, 12 Apr 2022 17:41:21 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220412062927.870347203@linuxfoundation.org>
Subject: RE: [PATCH 5.10 000/171] 5.10.111-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 12 Apr 2022 08:28:11 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.111 release.
> There are 171 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Apr 2022 06:28:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.111-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.111-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

