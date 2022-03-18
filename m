Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E23984DD8B6
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 12:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234109AbiCRLKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 07:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235639AbiCRLJ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 07:09:58 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56FAB129247;
        Fri, 18 Mar 2022 04:08:38 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id gb19so7187592pjb.1;
        Fri, 18 Mar 2022 04:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=XCCbLTv9eWPD7TX/cN1YQ5eQJ43DRp8t/kpHrfAaI0E=;
        b=dM0jr56G5E2Kcay4eeUFdb3j96R+pWouxXgQsgvucvcSbwPsWB4jKOqbLRA8z7mGHa
         uoK5xhXKqSFjzlaExI3jTLYelpUwdxbgZjrgZon0XwRmACOVm2erl7RG110SE6rt8gCj
         Y9CqEFJpj/FWimWGrdYchgcsGMtrh6Y1PItqhUv9KdTPCWfMxWMY6G2nmLN1WzBBOknF
         ZsILZLtOI2E+Wrn6lnO5CoEN2fyHbrKEmZOZ6JLEZp4x3ZjKEnLVNRHtK3bk5k/HxCkG
         gCPh1Efwy8cFzWKq3j8duAIyORHRSbgW8eW1J4VlNiwzR4iy1as9g94lYEVIqHBUXiWM
         vKGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XCCbLTv9eWPD7TX/cN1YQ5eQJ43DRp8t/kpHrfAaI0E=;
        b=jDHCCpvxZGNVOzO8ZgZUh7gC53QMWV11dAAKihaesCOiglBADPj3pzw/j1syQFB4TE
         HR+oxm162MOAL7ogT7BzZzKOY1SqN1LIYSCcrWm099ox6sXEDmjICiETAbJlGDMfwPVq
         AjIHm26ggYC+K77VWE2WhJ224L06FYk5bj3T4H1p7MLdHsDni+cSzjYV3W8I9EHs22vm
         51uBZaQF99hH4p+feX7cgp3ZhYGqvts1gvl+FSLPexTs/VF1TEdhN3gP94/X8SHzzdr5
         YAPL4ehONM+FCDSuNKHk7Lv4ebJGC4iOMBwv/Jurb3PHnpmGkcfHAklgRrTnPeiFxhyq
         2GBA==
X-Gm-Message-State: AOAM533yENgKyahUgKGrA9/t8iiGmbni5nnsmgZm3IAAkG+I9HA2jmdT
        Is+dyMVjBaENeiwAbofcEII=
X-Google-Smtp-Source: ABdhPJyvo+nwwwOZ1V/X+2hGkm5fS5cC9ixObTnuhBBc05bkF80hGBPypIamfCdAySXJ2o7SVoIBMg==
X-Received: by 2002:a17:90b:240e:b0:1b9:2963:d5a1 with SMTP id nr14-20020a17090b240e00b001b92963d5a1mr21076681pjb.227.1647601717775;
        Fri, 18 Mar 2022 04:08:37 -0700 (PDT)
Received: from [192.168.43.80] (subs02-180-214-232-1.three.co.id. [180.214.232.1])
        by smtp.gmail.com with ESMTPSA id lp13-20020a17090b4a8d00b001c18b1114c8sm12128633pjb.10.2022.03.18.04.08.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Mar 2022 04:08:37 -0700 (PDT)
Message-ID: <abef3e24-2d56-161b-9ed2-95a43292d371@gmail.com>
Date:   Fri, 18 Mar 2022 18:08:31 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.15 00/25] 5.15.30-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220317124526.308079100@linuxfoundation.org>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220317124526.308079100@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 17/03/22 19.45, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.30 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0)
and powerpc (ps3_defconfig, gcc 11.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
