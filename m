Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 919A5543CA7
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 21:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235290AbiFHTRA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 15:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234646AbiFHTRA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 15:17:00 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518A153C72;
        Wed,  8 Jun 2022 12:16:55 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id v7so17293443ilo.3;
        Wed, 08 Jun 2022 12:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=vMA4yROB5vytB/Y5xXRxGeGfQYPAkveG/uAMgEmsPmM=;
        b=MIHLqfrpFd/XJ2it0B5YupLAuImBMt8+0EUz3a4Svqhevb5vNX6GJxru2jlo1N3lFQ
         Aex/cbgjl19UXrOIlGYkx+3gts9Kq4U1il6ENsoVL6895gBmLfngDb/A+dyJ/59/WF0b
         SUkSK39BVmocjNXspM5/ieUzgqWShQMp4Isv5uwJ44ANKgQyniMqtxW2F+yA9Sm+f7rE
         QZLwLrEXXSDYJZL2rbu6BcIfEcTqvJwr7x6xZdWNNpOfXA4G15R9hti/z/J453TSA8Rt
         jdAIncolXMOJwGVjvpUtMGsz9wUTYDZvTkS1I2Qrgo6+QvKk6MWdw7d45whQagGZNtW9
         bFZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=vMA4yROB5vytB/Y5xXRxGeGfQYPAkveG/uAMgEmsPmM=;
        b=2/Xcm7ozIUY8jvpz+olSDA4GMQ2KFoPnfj4EK8NEkPQHKbUvvrf0aI5W2WBpPVWCQR
         dHGvxNjtZ0FVI0CQBLVV1nXsDCG2kS4/gCB0wBOpTcaelHfpumlkhyOWSh2teiioKl47
         CnZyH1ccYckh9ZLi7vQwxw92g+DfkU5G3pvoFMY/MTtr2CrReIhNh83vGnasjZI9giqL
         Bh2VH0tuM3QFEhfO89nt268OylJLRJ055CZciEHoPmv5DRSwc2YunTjK/PR33wdOHBU9
         xx5k8plWr/h/qhvrhMeU5bMjz3WD1LUlgUrAv8MmTSZZrS2v/co4Cw0Wq1JH0fWPK+Ak
         nBxQ==
X-Gm-Message-State: AOAM533Z84cCROC5klsKXL3aiTBAya392iGC6PujhE9OdMHMnh+8/6oI
        UD8scpp42AWKo7cWaFLvmBMoWLlz8iEdpQEQA3I=
X-Google-Smtp-Source: ABdhPJzFIxILrJBrN3hhP7AyYTY/Kk16RW0cXpnMWxxKwNt0/3UEiPr9qQdg5fxpB9LjZX3ShZ/7vg==
X-Received: by 2002:a05:6e02:1564:b0:2d6:5b63:80ec with SMTP id k4-20020a056e02156400b002d65b6380ecmr3166326ilu.46.1654715814278;
        Wed, 08 Jun 2022 12:16:54 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id p3-20020a0566380e8300b0032b74686763sm8451217jas.76.2022.06.08.12.16.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 12:16:53 -0700 (PDT)
Message-ID: <62a0f5a5.1c69fb81.2112a.286f@mx.google.com>
Date:   Wed, 08 Jun 2022 12:16:53 -0700 (PDT)
X-Google-Original-Date: Wed, 08 Jun 2022 19:16:52 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
Subject: RE: [PATCH 5.18 000/879] 5.18.3-rc1 review
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

On Tue,  7 Jun 2022 18:51:58 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.18.3 release.
> There are 879 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Jun 2022 16:48:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.18.3-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

