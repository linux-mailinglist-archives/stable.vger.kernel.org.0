Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8144F529934
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 07:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbiEQF4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 01:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232643AbiEQF4s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 01:56:48 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A38E9FF8;
        Mon, 16 May 2022 22:56:46 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id nr2-20020a17090b240200b001df2b1bfc40so1427982pjb.5;
        Mon, 16 May 2022 22:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=JVOKegek7JHiOysW2rYKEpTUTNZEwQMKG3m7Lffleqg=;
        b=eoNDiFrPg6qmpM1VJXyxzSSoJDE8KlPj0BBbp2ZlHt5EPij02Jo2AEXpyf+ZI9XcJm
         4C7eNqa1oNA8LfvaKyEyT29YGe4uGzTcNRFDWk7sIUzcr2SJZLMcPWgxkwW757FKqLiO
         jg8z4dx7DbYKAjPi8juQb3Ifk1mfhpXPQoNMYL13rJSvRMikogprsyzEQRmBUcxFPLSX
         lfFrCIyLSmbchN3duKb1t8TIQmRMwvGDf7O0xe4xtW0Yw1Bau23Nk/uut+S1Z6T7ryX6
         fYz+1IRF27eGKvbUjLiE7M8aMQC0Tw7DDvpdAJ/h7RLqHlow7w+2Ep6oeyFdhkT6cMbx
         J7ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=JVOKegek7JHiOysW2rYKEpTUTNZEwQMKG3m7Lffleqg=;
        b=WfPFubO1+2PTSTfovCy9FAiadAiSby0J0XgOy5vPSLC07Tgp88MoE2LFY8UM8//2wa
         cBmruw7x6qdyQrMvyjqqeWh4f8DdsdjSzH6oD9dWFl3xDjOREpLVthItTOk0VTb6hSsx
         YH853G2c8sAeNOtkkuLBA874G4ljrSDV2nmwBOGjMxDXpRvkg5HqaeZ9uGcwypQFq+ua
         Z+eRY3CRH7fkOBhOvzocFvD8IK74TEd/xEZB2c1hRgGOCTX/BDBL0+rzP5u6AhvIjIxc
         3O1uD4SRuOjUUdqcxaVB4jqCcAYwrLIIuCM6jfMpY/TX5n5smhdty3xSldeeczffHd5R
         x+SA==
X-Gm-Message-State: AOAM531olAwRTd6p2S7dl+TPOpRrHNjTEUAveqCKzdBSEosjAfrVWzNT
        yykrD/8QDlF51xZOlKB9Lze9StJAp2/6horQ
X-Google-Smtp-Source: ABdhPJxEzi1isbqaBInveSBcD4mlvidLlTPuFHZhEpTks3GJo5OtPsWqYXt+sTV9pjpnn7eqc7JvbA==
X-Received: by 2002:a17:90a:764b:b0:1df:58f2:784c with SMTP id s11-20020a17090a764b00b001df58f2784cmr8485891pjl.122.1652767005384;
        Mon, 16 May 2022 22:56:45 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id e3-20020a63f543000000b003c291b46f7esm7510526pgk.18.2022.05.16.22.56.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 22:56:44 -0700 (PDT)
Message-ID: <6283391c.1c69fb81.edfcd.382c@mx.google.com>
Date:   Mon, 16 May 2022 22:56:44 -0700 (PDT)
X-Google-Original-Date: Tue, 17 May 2022 05:56:38 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220516213639.123296914@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/68] 5.10.117-rc2 review
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

On Mon, 16 May 2022 23:38:20 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.117 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 May 2022 21:35:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.117-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.117-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

