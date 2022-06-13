Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64E2D549DE1
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 21:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239955AbiFMTmD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 15:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241716AbiFMTli (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 15:41:38 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FFC5443D4;
        Mon, 13 Jun 2022 11:09:42 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id q11so6926617iod.8;
        Mon, 13 Jun 2022 11:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=BdShuRznc48z2XC5wSXtTuM/rzWexYQvGOWNZPMTvEY=;
        b=J2RxzjyUtGcKpTj3psVfg/QNPYdSizdx9mZpzgMBuIkGZYp9cPbtDPa7i643uCrcP3
         hG7Dnjb0IVjm5XdGdQJPCQOhTznLw656WC+iEc6P9hD9aerbjSuiMnNtTm+X0POXy84e
         Zu9dQm8sAWzE26GA6nV6ugE+zYH/dZZPuKijCGjGQf+sZuxk59wYpagBjaSF0y67EnM+
         y7hnsb7Nj086ilqJkCWOQuw+n4cJbESVqcMiBQA0F7gVX2DpVRkOuM+P/NTIJnIpmrI5
         O0Oim1wYP+zu2dkkDS7lNMFjdRG755Axq5oSrAleJdupoqUJr3m5KrPhTjDek6N42lBA
         XjDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=BdShuRznc48z2XC5wSXtTuM/rzWexYQvGOWNZPMTvEY=;
        b=1uWBKhEbHxYhOMT46scs7N60JKhXSr7ucDw/of4ivkANW88+wV2pBTA7vhSolmMKOL
         qwvfmvceaU3li7YEu6wNhjT1ru8xhFtpuSW/9Mi7/Wkhungs2JThRVKutdlfs04NC2wo
         rqLO3tiIU9FtjC6XxhZeo2DcumRrs7pPVea1266peikV5b6MLn/B//t9Yml6++ORJJX9
         70bQnDp9tUNTZbUlaJBnj+iFYKGLdEMuFQgDuuP5+9UUd1EeJ1sz/guJBC3wD9lIlaF5
         ZKSthduTwfRvSl+KLr4n3Bvgi+Q5v6/wdQS18kQtvkqtTBTaV2rcxynLnY+2FRD3ZsoN
         oWdg==
X-Gm-Message-State: AOAM531O/E+O1HzxGuejJznEhJ2oo1NmdDXbwNsGxSbxUXjEWx8x2IYa
        142x3x0RonAicHdGqBQ9j0Jo5TOzPgn+9M1PZek=
X-Google-Smtp-Source: ABdhPJz3IOBMpOTwjVaNN195qt0AdVBtFA2M7bVMILhHlrxOpC+Q2h7/KbhKSJUW447vUG+O9+Rtjg==
X-Received: by 2002:a05:6602:1355:b0:63d:a9ab:7e30 with SMTP id i21-20020a056602135500b0063da9ab7e30mr498646iov.119.1655143781233;
        Mon, 13 Jun 2022 11:09:41 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id f19-20020a02a813000000b0032e12c332efsm3803336jaj.130.2022.06.13.11.09.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 11:09:40 -0700 (PDT)
Message-ID: <62a77d64.1c69fb81.df7d8.3694@mx.google.com>
Date:   Mon, 13 Jun 2022 11:09:40 -0700 (PDT)
X-Google-Original-Date: Mon, 13 Jun 2022 18:09:39 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
Subject: RE: [PATCH 5.15 000/247] 5.15.47-rc1 review
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

On Mon, 13 Jun 2022 12:08:22 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.47 release.
> There are 247 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Jun 2022 09:47:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.47-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.15.47-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

