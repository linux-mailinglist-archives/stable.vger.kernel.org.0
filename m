Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3E96536EF7
	for <lists+stable@lfdr.de>; Sun, 29 May 2022 02:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbiE2Afj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 May 2022 20:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbiE2Afi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 May 2022 20:35:38 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC1147AF1;
        Sat, 28 May 2022 17:35:37 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id g15so2716134ilr.3;
        Sat, 28 May 2022 17:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=zBbB8sfN9DN9D0ZO169jw7e+Jin3Iy6ToRbAHydzWH4=;
        b=bGfJCva0zMK2l5ZZ7Q+pPsRoJH7+y1IKwycwCU06Hj/yObjumykBGQDJDyCBR/2Wt9
         ukXjxNg3P4NQcWXKLBN3D69m1U/s+BCJUQcyWGpDlaYixcWezfF5em1qHTkRjVlGy5ne
         fgY15oQvjQQSKoBB+OyejLWT/wkSBhO9I7q7A482pFAdPjTR8EL8FDqzmFBTJc/h0oIg
         +Nj974FyUuM2ehtTPQQgOfrX/Z75tGuEqtqbPmGn2K5pYw2BIIGprFH8IIE0TacgwPub
         VtMYjChY0cxhg8utmNnQrJi0j9yIHHnYm4ZqAd5gmFpP0RS3f4ZK4n9IGtbXFBuNvtYY
         8o7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=zBbB8sfN9DN9D0ZO169jw7e+Jin3Iy6ToRbAHydzWH4=;
        b=eYw4ZL3iEOhuhhqYCt1txKRPCDPmPfIO807nlYRamez9STwsSsbuXlkDesc1wtULBG
         8Wvj0dHR8pYXoZ3GNxqZ9fObisLdhJBRRCByWxWpdf29xoqICj5TAZcbkLt6T3pnyn4h
         fUsKpF4DvxyZ2Cr6qBP0bbfq4HHg1BHlAqUc0xE52tgT4dYitG3wQEtdrboupaBfv9zk
         btqXHFdLX+VKxcecKudcU4NNtjVyTgqQxOJZexCnSWYNeRptVJMFsBzFGqADskQRYFBZ
         2gOFACKzVD3R8HjXd24Vc2U9SOWTZ1eUnDcLnyT+09VI2LTDZJOpf8+cQfJ1QBnWltbS
         oDNw==
X-Gm-Message-State: AOAM5308yBC/b3g8c3mMQxn1vRrUqvB0lDASvjVOxdWEp4Zd7tZs7wbD
        nnq5XxiFEr5xxBfEChWgp1cllWqo2I/TlM5P
X-Google-Smtp-Source: ABdhPJy8vquvLCdSwsxP4KdFSn00rqFuHeS2F3Gsfo7fC/22BzG3GegMgHajEEBrmx9/gAvFuMNsGw==
X-Received: by 2002:a05:6e02:1d06:b0:2d1:a247:650a with SMTP id i6-20020a056e021d0600b002d1a247650amr17244845ila.27.1653784536335;
        Sat, 28 May 2022 17:35:36 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id ca24-20020a0566381c1800b0032edc61365csm1609523jab.131.2022.05.28.17.35.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 May 2022 17:35:35 -0700 (PDT)
Message-ID: <6292bfd7.1c69fb81.86411.6465@mx.google.com>
Date:   Sat, 28 May 2022 17:35:35 -0700 (PDT)
X-Google-Original-Date: Sun, 29 May 2022 00:35:34 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220527084850.364560116@linuxfoundation.org>
Subject: RE: [PATCH 5.15 000/145] 5.15.44-rc1 review
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

On Fri, 27 May 2022 10:48:21 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.44 release.
> There are 145 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 29 May 2022 08:46:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.44-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.15.44-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

