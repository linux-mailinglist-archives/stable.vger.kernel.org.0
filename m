Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2819D5225D9
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 22:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbiEJUtk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 16:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiEJUtj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 16:49:39 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC9A128ED16;
        Tue, 10 May 2022 13:49:38 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id n8so258078qke.11;
        Tue, 10 May 2022 13:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=1QtSHWSt2P70HyR6hX4k2G7pqEyPFZ8xAGoNFzir3SQ=;
        b=YkGu5LR6Wft8MV6XPCrLi+3vMPkMsQLNUSMRBHgn9q+e2mm8xFcXvnGtIt2T1e4MJC
         iHfHS4sZXCZ3FPZ6JGkMtumQPnzwZtsqey7J1ss75J1a4S/aUPstkYqxDlJuTYQTjrnX
         KnBRu+ligRRIe+4XkdqZT2OcuSn2kg0xcBfG9e62d29uJRMmV3ED3WrKd91MtY05Sznv
         qSHFpuKTaEosSYo2d71XApai830knTGk6g4lgJbpgIcyk8jynIQflDLSd1DJdImkGEuK
         HyUW7qvMcXveRP9dBHbaT+J8AgKV3S0+ULVJgjcHCL+8PZdturN0ECq4g62VeLvpM8HC
         40Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=1QtSHWSt2P70HyR6hX4k2G7pqEyPFZ8xAGoNFzir3SQ=;
        b=bpewXv6NiZipaKR6yYMGgfCP62J211trxM34DrIfyMcNkJ/yBT2PpPKjGGBAwo4Jl0
         wE1adh2ScN6Wf+rz6/4JPA9Bi3Bd4K1uGamq30Yadq+YiQbrETXXRMjoze2BInCkCIZK
         SLtJvv++3wBgL1fZBthxZSSfO9aINC7R2qXmYfnhhDvoG0eC1SeiyylKH7U3MXTb2KFM
         UVKjYaU/DmeDPHNyG5LEbuBvuAd+qkLtT20T0vSSPK7n3uwPnaumb4ZHFV0jbZDoC4C7
         Qi+rWKue0YI9lgJhdMaWs4EGrwqG68h/k/2v6vcmxJ8hUpmHEwG+WI4V44FzSVvKPajd
         uSFw==
X-Gm-Message-State: AOAM533UNkbTNLZoapyLVe7oDPeS3rxcpU6W18Zox9RfPahfYLEx6Tq5
        gNIdjOc+EB7goM0lv6UlQoo9Yj0dN4toz2PLRNI=
X-Google-Smtp-Source: ABdhPJz8+eivJDtoj2avoAWtwcGjdnjIg9IX86Y4q1sdxJbBIpePbMx3np/zn4peC2vhdB8GKcxtwQ==
X-Received: by 2002:ae9:c313:0:b0:69d:7664:e51d with SMTP id n19-20020ae9c313000000b0069d7664e51dmr16826896qkg.199.1652215777600;
        Tue, 10 May 2022 13:49:37 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id y188-20020a37afc5000000b0069fc13ce22fsm9200337qke.96.2022.05.10.13.49.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 13:49:37 -0700 (PDT)
Message-ID: <627acfe1.1c69fb81.98150.f640@mx.google.com>
Date:   Tue, 10 May 2022 13:49:37 -0700 (PDT)
X-Google-Original-Date: Tue, 10 May 2022 20:49:35 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
Subject: RE: [PATCH 5.17 000/140] 5.17.7-rc1 review
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

On Tue, 10 May 2022 15:06:30 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.17.7 release.
> There are 140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.17.7-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

