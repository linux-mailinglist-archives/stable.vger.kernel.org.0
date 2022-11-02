Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 661D5616F1B
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 21:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbiKBUsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 16:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiKBUsP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 16:48:15 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F6F765D9;
        Wed,  2 Nov 2022 13:48:15 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id n186so3143936oih.7;
        Wed, 02 Nov 2022 13:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1R+kPdUwpILgSxzae/u/gpRu4jldLuHqjWFbxDw4WVs=;
        b=V9JnLImy+JyZXXXE/VotKasJjk7dEVynobUp+nN4iVZ5L8Ov5fs/OL7IuPPFpTeCHP
         CxHfsyshrcEN3YZNnmQ9x10WtyeHrezctAEsLH5/4Qt3zmSw0desubheZgVcrhycoBsY
         LlOW6WxoAuyhmSZfwmq6hnI9umxALGdSZfB58PH17Dk7q90Psm46TbfVw6Fzo1M4+L1F
         2vJcwBSqamCQTz0gZBKM52ulds3tou64OvWXfMagbiHU/krccTk/Pw/lm1hhOMsNmuG0
         nP6aCMD+LLuTCsgfmB3rh8EWMPGS7AS4HfPa3j5jKWLSxGfrTthPGhZOo8TMcsO2+vE7
         NE7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1R+kPdUwpILgSxzae/u/gpRu4jldLuHqjWFbxDw4WVs=;
        b=PSI9elObqP5CgKutG4xMVVGvDp+vnXmqgu8xBNOz6PYxbFwDHufCyXrFwNb3zR2F95
         TwUeK59vq6NkrD3Z0phiptfb4ycR4Va7i/sjc5U/F9kjX29exDxQKAVNXhPGvf+hXd02
         FUs5DJa4/1Q/gQeot3d7qV6sGmkMzyvftWTYdOsyq97aOvSkHzdGpDGdF10nFJ8ieZFD
         Ll8xHfMp76IAo4uCCKIY4uTecNyjMV/cYJstbnAIHicmamdIpj65EtCx2EWmtyceicUN
         xx1oV3Q1It83c4CicHpK8pU1c5hsjPma1ZFPEuL1J7xE4+iOJ5lF2OyWjrphQOuWg3GR
         GiRg==
X-Gm-Message-State: ACrzQf0I/CpwsEwwzfeLVAlLAPfGVpNNOc9NmpsBPvelfRPtcHlkHJPp
        RtMjHTzwDNgJkQ0vz0YRUa8=
X-Google-Smtp-Source: AMsMyM7YjsxFiz6JcexC8tue/fTcMAq7RLth3HOCMWC5GYPADqBFwBpAh+2MIPSNixPw0Cx6asJfRg==
X-Received: by 2002:a05:6808:1527:b0:35a:4051:7287 with SMTP id u39-20020a056808152700b0035a40517287mr2365779oiw.5.1667422094783;
        Wed, 02 Nov 2022 13:48:14 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s6-20020a056808008600b00354b619a375sm4931739oic.0.2022.11.02.13.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 13:48:14 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 2 Nov 2022 13:48:13 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 6.0 000/240] 6.0.7-rc1 review
Message-ID: <20221102204813.GH2089083@roeck-us.net>
References: <20221102022111.398283374@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 02, 2022 at 03:29:35AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.7 release.
> There are 240 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 152 pass: 152 fail: 0
Qemu test results:
	total: 500 pass: 500 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
