Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5193052ABF0
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 21:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbiEQT3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 15:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352718AbiEQT3g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 15:29:36 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95065506F1;
        Tue, 17 May 2022 12:29:35 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-d6e29fb3d7so25444916fac.7;
        Tue, 17 May 2022 12:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SHuMWI6XH0VRek0+IKEtjhDhDBtd2ZBzymnD6J3Bhak=;
        b=i6aUMhYnLtDVySh/xScnH1gtjPauIc13GMpPFm2546OWH7dmmnV4SkbM03sggYv4O/
         JJwB8i/Aj5dDVy/npP4lXzkg81dL5+VyLsiO2EQSjZGQuk0MMt5D7V8Upgl2F/wIre35
         gmHL/nM8RtGIAOuyrple8nPho8Mdi0XHxVzmpdDetaMv5FLOPRODgYqI4BQy9isOvFSE
         tuyg3v/dbEL0Oe92jvDcmo7d6rgyeOAlSvzMjaAsb0Uhamw9lEYlrsIgBVEabFqXAf87
         Y9/7MHfoCufN50OPJPdcXv2UqUtbUel6ZaAicy87f8bngeXORK2OFkT1lC1uL6r7n+B8
         mygQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=SHuMWI6XH0VRek0+IKEtjhDhDBtd2ZBzymnD6J3Bhak=;
        b=RyqWCYFZmjnAxknBd2bCSHrVY82jWY3cM41QEhGiE0OA+Dle9I5Ic1g1uj8FNap3Ud
         oBD+GRp3m3wuD78ufRpA5nbaG3cLCNqYz4Kw8/vS9vyubLjDAJTv6LIn/ryw78SC8zsJ
         kCNWdhJu8QTxYOupqG3sS+9kSgIqz7Y5YNvgnTNCTAWxFu80QCwuCtTTJ7Gs5rfucIfO
         2ru2M9DP0UXYjNkwwisMaOH/9QCydd2hdYn4qlc8vpPu9GjymQy/f9LATFgZsNE3X1GM
         DfzDXeG21ixvH2rcSA3fGwbtwQuIW174aqi9qGeleqZdhfNecTObv/KpDdkdweeMnWl2
         mcvw==
X-Gm-Message-State: AOAM532qT4hXoClNNGJdAYGEDuaEIbi7wh3jR1F8Acr3l331vTefmOAg
        1F93RHlU2YCfTokVprcqlSA=
X-Google-Smtp-Source: ABdhPJyPYWzMzJ5wY/pX3p44zeqseafEM4nGRE7uTSdcffyo6y1NusmEYlDHIVJb/26PWzWk2Q/oDA==
X-Received: by 2002:a05:6870:46ac:b0:f1:aba1:231 with SMTP id a44-20020a05687046ac00b000f1aba10231mr5632064oap.289.1652815774972;
        Tue, 17 May 2022 12:29:34 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r137-20020acaa88f000000b00325cda1ffabsm58845oie.42.2022.05.17.12.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 12:29:34 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 17 May 2022 12:29:31 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.9 00/19] 4.9.315-rc1 review
Message-ID: <20220517192931.GA1013289@roeck-us.net>
References: <20220516193613.497233635@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516193613.497233635@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 16, 2022 at 09:36:13PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.315 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 May 2022 19:36:02 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 397 pass: 397 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
