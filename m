Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B16F4D5BBD
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 07:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232738AbiCKGtf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 01:49:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344020AbiCKGtf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 01:49:35 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB26E3C4A;
        Thu, 10 Mar 2022 22:48:33 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id t5so7137404pfg.4;
        Thu, 10 Mar 2022 22:48:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=qpSfz8gqfGxIVJN26AyR2MIUuctENRka78Wio/sVIYM=;
        b=fC0QkbxQL3nuVdXoQX+98UKd4BgdWw37Pkwa33/bGvNHPoCRq423WKpAzYhJ0WYhFL
         q/Ub9XHcoUM40mRPkj2rrd+J+C46PDvktuWrrmMn/AKBlMiYmgV7Ay1LKBEGElxIFr2M
         jLlFQVs5EInOksRS4x4Ec4NrkBfcjX1z3IzBzOsoADHzKSDT6FcMi2QhB0kFLgKenNW+
         SGQ0HGrk0UYTjeTk490EusnFqFduAxXC0vMEuPKNE7l4lkDlnD6PciOgoOgV7P/wn8J5
         LMswicWncI7N/V3SwUNr0+l6TmcSEPs4OXY8KY/59PW0ESCIrTuieza0YY7h39VJYAST
         OagA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qpSfz8gqfGxIVJN26AyR2MIUuctENRka78Wio/sVIYM=;
        b=5d/4+ZbYDJYxBupmEF5pM3hniP28NXCUDLJx1jwuGecuEGnVwPaquVJzkap9BMXMhj
         PcZjuHRkp5H1tzRwKzS8fVwFUU0ZtJi2xP95nrSJ1Njlfp8asGcVW5owi2sJsWR3tcZL
         7mE8DzLXCeX1gNIfB1y1QU54qsRBZaek2z1liKkZgzhBinrVXg1RhrenOvB3kbsTX72T
         4uI/7JaJtf53ZWoIE4BbRC6od3KKUjfgZoEha/ATHoUbRpBt/2bFdOkuMftjT+Z2QMM+
         IeelhjxON2GCxw9mHnfm9GgN+L0boL3iZDVeGPXIu6D8LWgJBoFwOP9WV4Y0GQP2v+F0
         2MMA==
X-Gm-Message-State: AOAM530k0tJE6UcKcRA4cGkl2lWcaTcdhp132Rxdw5cMMuU67HvQG//h
        4ZTi4bcxIi3Pfe0oaP+yGB/fSNIhh6TkAQ==
X-Google-Smtp-Source: ABdhPJyVIBuCYS02t2xEjrOzUhD82N4lKwOGqN0h2vqgxu74pd1fYpey8VXgtqNMAgbNt0cYALFb+A==
X-Received: by 2002:a05:6a00:16cd:b0:4e1:366:7ee8 with SMTP id l13-20020a056a0016cd00b004e103667ee8mr8924268pfc.9.1646981312797;
        Thu, 10 Mar 2022 22:48:32 -0800 (PST)
Received: from [192.168.43.80] (subs03-180-214-233-18.three.co.id. [180.214.233.18])
        by smtp.gmail.com with ESMTPSA id w12-20020a056a0014cc00b004f790cdbf9dsm726949pfu.183.2022.03.10.22.48.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 22:48:31 -0800 (PST)
Message-ID: <5054b988-0d81-cf14-9614-492392d2c91f@gmail.com>
Date:   Fri, 11 Mar 2022 13:48:27 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH 5.10 00/58] 5.10.105-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220310140812.869208747@linuxfoundation.org>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220310140812.869208747@linuxfoundation.org>
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

On 10/03/22 21.18, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.105 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0) and
powerpc (ps3_defconfig, gcc 11.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
