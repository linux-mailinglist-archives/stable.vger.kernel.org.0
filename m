Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCF1E532C99
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 16:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234313AbiEXOwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 10:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbiEXOwd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 10:52:33 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2E96B7FC;
        Tue, 24 May 2022 07:52:32 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id u27so25254104wru.8;
        Tue, 24 May 2022 07:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=p8XUzdGzVpg8fBT/j5RB66ji+Am5Pltq0V+Xp6PZ8sg=;
        b=M6ucU7znQIdKsftQAVc6nTAyuVNl29vlfdqaGHsYH78z7AmtKaX2DZxkdjw189yzp3
         VWUMEkphWyeYPvMJbNVCFLoY+8M708rQQR/QTss45HR4gz6wRxyNX/RAh5DpF/fueXpU
         BpESBmmEtHOBmU4+jJ2LLku9UpBQPCGxCuh23mHG1qZ9trs9pWNQCe+k2qX9XAOfx2Ms
         46zwbGUtuhLeWrTLMAiMv7Axwx8ECGIbQbem66Q7tnn0veZwtUq1fm8SU6kCeGW/ugHv
         d93zO4GmIhkfR2ip+S2uo7YrHX2345IOl+Mt8BemJP4eVu2gKySMWyegNKXuqC3zCUg1
         P7Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=p8XUzdGzVpg8fBT/j5RB66ji+Am5Pltq0V+Xp6PZ8sg=;
        b=Tyopm/19L7QzHcAqLnwpLGuG4mEpjQaIBNyteYT/AalgDtu3WKsapuAu0tUOdhHnBZ
         0RNEGXgFpZO/D+rIMMnQD8Ly3X1VIrWvmKjFmwATg2qZu8jgMIpNCkMIFwPhWBF8uO92
         YY7Wu5v8sPjT/Zk//3SjmQykEyDY3sc6SEY1EO00ZPjyWM+Gybetv7GKEJvXrEBsq7UE
         IHsrpFz+dprSPjP2aG382fG3eLwIPRCbuchoBes83Wz+4qJ7DaXBds5EoKovSa5wfDyU
         MZew7IbAUeI4fm6eDZtcOD/wDhwa2E5nzuPOFeSomvikPlH5nDcmKrvOjOakB7KtoetF
         oYSA==
X-Gm-Message-State: AOAM531xffBjIX6ZSpz/WI8iGbIAd6yTY03TGjXkBZD2p0uzbI3AC5Tl
        shAYogPOSMOh/h1Q9tZUfWnYGUPuW2Y=
X-Google-Smtp-Source: ABdhPJxFCGP4qOnnSaITHVu90+VgyNyrdus79QWaF30ot8J5Kduwh2YUCt3/dmerCA97GWJe6rCH1w==
X-Received: by 2002:adf:f550:0:b0:20e:69df:5f05 with SMTP id j16-20020adff550000000b0020e69df5f05mr21730089wrp.194.1653403950998;
        Tue, 24 May 2022 07:52:30 -0700 (PDT)
Received: from debian (host-2-98-37-191.as13285.net. [2.98.37.191])
        by smtp.gmail.com with ESMTPSA id i7-20020adfa507000000b0020d02262664sm12859419wrb.25.2022.05.24.07.52.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 07:52:30 -0700 (PDT)
Date:   Tue, 24 May 2022 15:52:28 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/68] 5.4.196-rc1 review
Message-ID: <YozxLGkBA/GgkWrg@debian>
References: <20220523165802.500642349@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220523165802.500642349@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, May 23, 2022 at 07:04:27PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.196 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.3.1 20220517): 65 configs -> no failure
arm (gcc version 11.3.1 20220517): 107 configs -> no new failure
arm64 (gcc version 11.3.1 20220517): 2 configs -> no failure
x86_64 (gcc version 11.3.1 20220517): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/1195


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

