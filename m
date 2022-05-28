Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E58EA536EB7
	for <lists+stable@lfdr.de>; Sun, 29 May 2022 00:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbiE1WYq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 May 2022 18:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiE1WYo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 May 2022 18:24:44 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8DD8994C2;
        Sat, 28 May 2022 15:24:43 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id d3so5344836ilr.10;
        Sat, 28 May 2022 15:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=N3v44ReYX5jx9W40W1DGsgfgrBeQ3zGO29bJKTGOgCU=;
        b=a9UbY5hynLJJf05/3zom0G+FvOFdrfcX/QQkv6gqdz+JzNvj6AcJoyLD9sDpbW6xs1
         g+jRl6CM3tFNU5it5vUVPby2bG+JEC8Q1Xa+tT+PfR3mKJTi38GnuQOAXh1um9vPJpca
         NXksGq+iTmR9OCh0QRuml+qte+xXdFH5lVRWRdZbsXVNXGKvJSt0QTKv72aXTAb0xXrk
         qJuSDimoCODqXF0EzMLPJ4hf0mX6gT5OnALipMGdlsjLR6nkV4PXJ0e3R+cyIvl+i0ty
         +8At1FZ8+9owwoSuHwGCt+DrDr31fngzo4e44lENQ0au20taIRuSXnLreCPqc9fjHPIL
         z3+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=N3v44ReYX5jx9W40W1DGsgfgrBeQ3zGO29bJKTGOgCU=;
        b=p/o2W3+QpAVyqZ1UYh+czFLO9uCUPtXVikm7OmPbMrEfB6LYU+BmDnLp74RYqJC/7F
         V6AS8JJbmjPy5v3WBY0ALDlwzmAPLQNXsFuRs3UpGN+fWUdEEuaDScZL2KhPgeDZf1Yd
         NPDxSIg4bAxhFZaUffutRBNjIZAkRf9gzUNUGgS9nC7t/3RY7c1LT5/hpeAPTTN8o+4T
         NmIoNv6A3DD057SWb5ZHbaHDNm5stH4zQX9Cy66k2M9bYwVwy90vk9MA1r5bZN8GS2Zw
         MPqYlpY6iADmTddeDN+Vhjg2nR/wVk8SS/R/3Va9nu8S2u9wpp4xs1uGM6gK82Q2PqiJ
         AY3g==
X-Gm-Message-State: AOAM531jjoE9lQIgWdqhjsmcTZkVWZljA/1MbZa3YF3Se0ihXK/vXnhZ
        RWediMmFKVydhgLHIKEsP4vw2PsQkD3iFU8h
X-Google-Smtp-Source: ABdhPJznQiOqNeXDNDsYgA1mowMF0ihTFvsZCd4kFNljMysyTB66mN8DDpPM680y76kIFbrFJ+J8bg==
X-Received: by 2002:a92:d1c6:0:b0:2d3:96da:426e with SMTP id u6-20020a92d1c6000000b002d396da426emr1603438ilg.152.1653776682741;
        Sat, 28 May 2022 15:24:42 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id a18-20020a056e02121200b002d39ae9918asm353361ilq.54.2022.05.28.15.24.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 May 2022 15:24:42 -0700 (PDT)
Message-ID: <6292a12a.1c69fb81.748be.15b9@mx.google.com>
Date:   Sat, 28 May 2022 15:24:42 -0700 (PDT)
X-Google-Original-Date: Sat, 28 May 2022 22:24:40 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220527084828.156494029@linuxfoundation.org>
Subject: RE: [PATCH 5.10 000/163] 5.10.119-rc1 review
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

On Fri, 27 May 2022 10:48:00 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.119 release.
> There are 163 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 29 May 2022 08:46:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.119-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.119-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

