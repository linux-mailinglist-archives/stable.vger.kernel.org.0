Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26A0657B383
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 11:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235626AbiGTJK0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 05:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234921AbiGTJKZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 05:10:25 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 740BF26D2;
        Wed, 20 Jul 2022 02:10:24 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id j1-20020a17090aeb0100b001ef777a7befso3301022pjz.0;
        Wed, 20 Jul 2022 02:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sTsDNsbNdeSVMtD8eRDDUkMIBEhKPE+q81EkScKHRlc=;
        b=EmX0SzEhIZgptWCwjF/HTCsuWvI8AgLdla3TA+sTwcDwhGPgp5FoRjP6IkCMtpWMHv
         q8n0hp8fTwL5NBaMzX/QTZ2BHNAOW3EI42hrxDMN73nBAIx2hx6XIV/eyEhJoyZ4HC25
         OROlbAFkUwc7H32U/p3ZayTUN0gl3nkWiXQjGusRPfX7ej+iMjXSziVZ0wQdMEp/W9FL
         jSJIAdiNtXMESlKF5hicOKMVyD2Tqq7mzEITnleYNHSuJq+MhbnOeX63UNvqVp/nSYxk
         3jiSK5Z9HVfPCgX17rxpnHtdGOSbZzNgD25e/HCOzDHF4r/7T1Z/JfreAEzi3Y9P6Dke
         XqeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sTsDNsbNdeSVMtD8eRDDUkMIBEhKPE+q81EkScKHRlc=;
        b=UNkt0ivVIK7U8gssDV5V6/Y7GJqZvW8ArjQVu07QmzZRQHdKIh6YhFIGgoGMBR0Fnf
         MWA3gU6XukcdVBuocZQ1WAnoVn2N30+Cl1jaAcFh15fXCLsn4PDwgg1Q5jtr7Tx3JlPJ
         eR4FuuL9fI65AsxrBcqQx+0sPw4TgMs2kjh6+Mf9zy1zJ+TCXbLwcfE1KEOXIkNdaUHP
         oHDLJYfSzJfs8LNhIXVBkTIyTlmtvI51hGO/9oSS6IO4+42fW/+VAjGsfqeGRnEopW4i
         7YlTnQv0IhckGMvDyInwpZwVwhTXlP0oDzdsISE17cgY0U/Kiovf0D/c4RLo+wwl6uAN
         Ta6Q==
X-Gm-Message-State: AJIora8LboAOvNeYg7aEYmkqdK33q5cncMPSdgpQ2wFgyNu5BKtj6LH6
        IwJFPqYfxtZ13zx31FpQZCc=
X-Google-Smtp-Source: AGRyM1vtEINJKfO5EMi3ll29u6Mudn8Yi2awZ7v2pLtcVBEzKK2hUJmWOV7xNuluCHe58YWxpdv98w==
X-Received: by 2002:a17:902:ebcb:b0:168:e3ba:4b5a with SMTP id p11-20020a170902ebcb00b00168e3ba4b5amr37591122plg.11.1658308223917;
        Wed, 20 Jul 2022 02:10:23 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-73.three.co.id. [180.214.232.73])
        by smtp.gmail.com with ESMTPSA id p14-20020a17090a74ce00b001ef8ac4c681sm1102786pjl.0.2022.07.20.02.10.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 02:10:23 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 2D090103B12; Wed, 20 Jul 2022 16:10:21 +0700 (WIB)
Date:   Wed, 20 Jul 2022 16:10:21 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 000/231] 5.18.13-rc1 review
Message-ID: <YtfGfcyjKaNHPndU@debian.me>
References: <20220719114714.247441733@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 19, 2022 at 01:51:25PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.13 release.
> There are 231 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0)
and powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
