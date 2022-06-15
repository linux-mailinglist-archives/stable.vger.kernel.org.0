Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 125E054C488
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 11:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237161AbiFOJXC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 05:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240896AbiFOJXB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 05:23:01 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34ED413D74;
        Wed, 15 Jun 2022 02:23:00 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id c21so14538049wrb.1;
        Wed, 15 Jun 2022 02:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BWokWoGaQLe1EbuiSilnXY0apKkI0jKMPtA3Kn6isHA=;
        b=ipViYCb+P4rh8xv6TlwmObrD0Up/yKbF4T0+7OYWFUJU+io7YVtDN0KrDt7paZgNgZ
         GWQn9LnoR7wLEqASJK3eYZ4A+j74lnYykZsqRzvjsfceNgihkeZtBQRUz/VzHz3VGhIf
         rrDJWcO+/uYRl1DunKwDzNCDqqlTuSRQO/wF9ClhwYTw1WgS7lagXcdsjRDxE+KORlzO
         ikNFkTdLleuqBP++m7mrX/VOfTtmn2h29gCzdniEIHeWrtFXDSxyYYQ5hPYo/MSIWdGN
         WcPV5bETyzaW+EXDiAcPkuq0PoNkQ/YBWzpnVErvczuRgr9BI4nbHKf1VKhoduxa5RwX
         rEGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BWokWoGaQLe1EbuiSilnXY0apKkI0jKMPtA3Kn6isHA=;
        b=4jiC457t8lvA3RP86WZ4GRB+7AQuMK5Vd+1d30bESiKMjPPazk+7J/Jc/41ZUmSq2t
         NFTHRnK0vF07/77XqxglUQ8x2fPGjNcwVz2E3aTDDQZwLdn2qjqZRx197WT30KFwxNCk
         YxuiHkBLFXtukNmptflTuiBVGX/8Boo2iRanugd5oKc1G2z5zBvQJKKfl5PFn0YzPr7I
         ObJKFSoj05nuoPDHpn1O71WsvVVh4miwjwJtZiixVUTuEeoQ+m3v84bApkGEUYsXQ3ca
         PSUE09azoTW5X4NsvNS6MlNOx3dThH336nBujdb1bosEqNJ1GoDmCU6g9BjZGwEPDnvi
         nmxw==
X-Gm-Message-State: AJIora8HjaqsxFXP1aQKwRtSYMLh36GE4Qqe8K/z080lfTOBN1YtAzLb
        8Fi0tkCUTFatM9bn8ZuEDYU=
X-Google-Smtp-Source: AGRyM1ub0Gdi1PzS48n/pcjCVJ2Egf304c5j9WLTJwpx6g93vJuX92umgZLUpJ4m33kXFYLTsp3Iww==
X-Received: by 2002:a5d:5452:0:b0:216:f80e:f7c6 with SMTP id w18-20020a5d5452000000b00216f80ef7c6mr8883061wrv.472.1655284978687;
        Wed, 15 Jun 2022 02:22:58 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id bg9-20020a05600c3c8900b0039c45fc58c4sm1910694wmb.21.2022.06.15.02.22.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 02:22:58 -0700 (PDT)
Date:   Wed, 15 Jun 2022 10:22:56 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/15] 5.4.199-rc1 review
Message-ID: <Yqmk8DRLrZMVTj00@debian>
References: <20220614183721.656018793@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614183721.656018793@linuxfoundation.org>
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

On Tue, Jun 14, 2022 at 08:40:09PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.199 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220612):
mips: 65 configs -> no failure
arm: 106 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure


Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/1332


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
