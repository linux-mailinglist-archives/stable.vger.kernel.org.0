Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44DFD4D3A80
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 20:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237785AbiCITlC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 14:41:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237667AbiCITlB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 14:41:01 -0500
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B032DE;
        Wed,  9 Mar 2022 11:40:01 -0800 (PST)
Received: by mail-qk1-x72a.google.com with SMTP id z66so2634210qke.10;
        Wed, 09 Mar 2022 11:40:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=s9TuFEteEBJyUqVDG7TaPbp87ib9masJw8gyH2zNUGw=;
        b=UIrVlydol3+YB+o5UQa0NrsY3rouwB3z2oKdqXgeMVoLqr+FTWVTg79bWXJFCNgsZ0
         T1fDDToeGMO9IIykSVLa4uxVsXVJWZJFFaFZQV0wFSQonNCJeOLcbDJeYAQuyM/ezkYY
         l/mHiRboq6yprNxB9fJ4bdKmoaJNH/W1yU/tUN0uXBtMe3CSVGTcSHOx1Sqqt19/jxxS
         lCAF7LgXAFi4qv+Yz4Sa8rbx7cXDECo1U57QtB8u8OXARLlQSz4Lh9A6GEAl5anHKr+q
         fRqTRAEhuUYnge10djA07oWDXRSxjpipGHhxN+zfK9SXEDu/7feaK+G6GjYSBY56pRy7
         QdPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=s9TuFEteEBJyUqVDG7TaPbp87ib9masJw8gyH2zNUGw=;
        b=eLEij2vEofdoRBfpeyG5dQYZr7Gfj2c9yhF5ep4MpxNkB5S7F0sv6OOka989MxwwO0
         l9rbP05xPfKFk5PfmtoyVRHq9znOOvjTAQVDtGSXuFrBO+55q1bi5tr2uD5/N8MnwfBr
         ESD40k4rvtR/9O4MR68xMbov3ejFuchACb9TuJadGjacOf4ujNKhgux+knBW7lxGAB0A
         f4PVSUb0Q8FrVObGZJyAvVOPCIeSkavlqkqaZ0j3tIY+uYw72w/BALVcM/Id8J4RNGWh
         f+70umOVra5HHFCBNprlOeYDyJShf9CsikeBc/wxdWigth4VtDjMvNEjWdE04+eecBxm
         q7EA==
X-Gm-Message-State: AOAM533lUv0gCWvVZ+X1G4NWikv4SETUbRPmGFCiaZ1d+P9xYbMkvqZf
        yoSflwBVOTd2UDxglLZYfPq/04LDANddMc9zZS0rxg==
X-Google-Smtp-Source: ABdhPJz1AVvAko0khaPwEOjNXWhlCJgRlgat8VQj146ocb5cc/6I2VUyM1V4TXl2tNVn1/26htLHdQ==
X-Received: by 2002:a05:620a:1a10:b0:649:e26:6b47 with SMTP id bk16-20020a05620a1a1000b006490e266b47mr850390qkb.143.1646854800151;
        Wed, 09 Mar 2022 11:40:00 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id f34-20020a05622a1a2200b002e1a35ed1desm1280675qtb.94.2022.03.09.11.39.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 11:39:59 -0800 (PST)
Message-ID: <6229028f.1c69fb81.5de5f.8434@mx.google.com>
Date:   Wed, 09 Mar 2022 11:39:59 -0800 (PST)
X-Google-Original-Date: Wed, 09 Mar 2022 19:39:56 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220309155859.734715884@linuxfoundation.org>
Subject: RE: [PATCH 5.15 00/43] 5.15.28-rc1 review
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

On Wed,  9 Mar 2022 16:59:44 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.28 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Mar 2022 15:58:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.28-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.15.28-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

