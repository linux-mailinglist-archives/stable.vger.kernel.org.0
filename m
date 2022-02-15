Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB5AF4B60EC
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 03:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233538AbiBOCWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 21:22:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230431AbiBOCWd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 21:22:33 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 111AC6324;
        Mon, 14 Feb 2022 18:22:24 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id o2so34193156lfd.1;
        Mon, 14 Feb 2022 18:22:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=P/tvBzh5yTdGWjYe/a4NiHPV5u6LYQEeMADqm7POP+A=;
        b=GNbEl+j+OyeSr4lg4pcZ2QBdhvcJf11Y2vSXjOzCWQ4dy8Fq/6KnDrfnGfNWOPnND9
         7X9Q+qyVGmlC8oaJXu6OTA5jX/4EGtEJSmltOzv0ed772IHODNDJhwCwQjay8u6UuuTk
         48qVfVkDNSthvcWtHy+axf1lpg5Y1f7WBtecVUAlRNuZAmPEnatJ0AxmXHe60sARqYpV
         w9OILWkw/1dnKFTlGQa3U+LcWRlyoqjSfRHd3IEr9y2w2NZ76fupzra6beJn4j/DJWmR
         v1wUtzeWaFUnJKAI7qAJlS8a0JH/8dxLkLZiVrEgg9ej8C16tmIhJItNy3mBUwEd+OR4
         VOhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=P/tvBzh5yTdGWjYe/a4NiHPV5u6LYQEeMADqm7POP+A=;
        b=vJ00Jk1rfhfSDSa/ut1olnxjes71ND5dKxX2GvrhUnooNSymSxcquzzdmAHcCjd792
         sjI1K9S1OKhqDQjDOPwRl1RyKbH4529mQYs1dpHV/Cl308N9v96r67IGDlkm4lJs2Prc
         6YroHGp69YFshTMHhFxEAbweyVXTn8/uexbGHSz4M5PehuO0usGThlv0gsBn6b4LWOfU
         hF2otiPo0GUDXcnR00nBOkpck/t4uQOkWny6cqht5Sq1PfRgR2fFNhJ+y8qStHpO4y+6
         G9ifwHk3yio7hrgytGqYRShlAK8wq4GpuzaZRFtNneCg6W3/z4lViO9LnFZEIe7j7x2j
         mtng==
X-Gm-Message-State: AOAM530BzQ3H/kDUmnGnUeD2wZtlGj3qrfimwryZfk8MULcxEmqo/uh5
        0kXpuxx60oahUKCKdTb1M2stmSnGk0JP8wuYEZRJHQ==
X-Google-Smtp-Source: ABdhPJzfUtt+wefzMntdmoZ4JJ9s6pAwxvOVMbM7sTtjvILR+Zn6ZEVa12hOaRqyLz461kg5oAM8MA==
X-Received: by 2002:a05:6512:3619:: with SMTP id f25mr1427675lfs.245.1644891741973;
        Mon, 14 Feb 2022 18:22:21 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id d5sm1046952lfs.307.2022.02.14.18.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 18:22:21 -0800 (PST)
Message-ID: <620b0e5d.1c69fb81.cf937.4f88@mx.google.com>
Date:   Mon, 14 Feb 2022 18:22:21 -0800 (PST)
X-Google-Original-Date: Tue, 15 Feb 2022 02:22:17 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
Subject: RE: [PATCH 5.10 000/116] 5.10.101-rc1 review
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

On Mon, 14 Feb 2022 10:24:59 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.101 release.
> There are 116 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.101-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.101-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

