Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41F5D4E810D
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 14:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbiCZN3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Mar 2022 09:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiCZN3F (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Mar 2022 09:29:05 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 557C924314A;
        Sat, 26 Mar 2022 06:27:29 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id o6-20020a17090a9f8600b001c6562049d9so11116034pjp.3;
        Sat, 26 Mar 2022 06:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=r0pAApFv6gV2oaztpvw2JNdhvRxbJovm8RY3Df64j3E=;
        b=b/xZszrTPZ6Sm2QPIxLJNnZcC6MPDOtbKM6iudqil2k2ZBxAPxg2RuX3+d0eTb2h3W
         uC/KAKnjCYZyRnb+D2o5GVrMv691ZNjEOhUpnY90VpsQUAwJISB9Wh/IKPQnLnfV0MTZ
         Nf3uD1UxxZ71BWSAjO97r0ehGh1HZQPJkQx6VGJFqxGDg0akaQbn7p5WysbEybAMeqKO
         ZZ0/VKedej+2pYolhlwzqYuXBiHrEgD8JDRiDeS4nPY0JSgkAzXQiUgW1JtpscVRD2DH
         9EfFYU9iG9dzgcRtKqXXkUbYXdlWlkHLcnXU/fJSAktOaZW6AlvsccE0QnnHV9yDAISx
         2TcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=r0pAApFv6gV2oaztpvw2JNdhvRxbJovm8RY3Df64j3E=;
        b=uQfCWPOlNpnJhx97R5IgRyj2wP44eTcE/HUmOj+gnPNfQ6rlh3ddMzsD9dl4lxVk7a
         hfWanq2u8TGlM+0QqGLCIOTn3Li7flE68czLMb+fH7d8MzR8psIluskcY42iWEJygWyh
         74OlllVdJEi0yBcewYNq1yj+hdG8BaZbnoBdMYNTnt6shx0doi7rsn2qyNLidWXXuJbB
         aSXKiRXvPUzrxGiqF4EIhECzHXu5y+Rr/hjhuspQdYS/ELp/rDMocoR/ix5+GvKcvyJ3
         3t/BPNG1sqPWc/wvJcICK1wVZY8qZe7TTwPmJTUwvGS34395nDDQb0j6UGHrSHA3ygri
         xisQ==
X-Gm-Message-State: AOAM531QoQEsO4nEnWJ8GwC0mVtZBA7QcMgF2ElAAhwZ4HUcb1I6ez5R
        uVQ3D1D/2n8KzRpaO8y3JyaWP8Owbhmrep+M
X-Google-Smtp-Source: ABdhPJwK6lHFr0MH+mikZW1I5iXp/JFL94cJcrXA4RwcCKBLL+mZVQm0fVZ2BwpnSe4zDELzMEfjuQ==
X-Received: by 2002:a17:90b:1d04:b0:1c7:1174:56ae with SMTP id on4-20020a17090b1d0400b001c7117456aemr30308257pjb.153.1648301248915;
        Sat, 26 Mar 2022 06:27:28 -0700 (PDT)
Received: from [192.168.43.80] (subs32-116-206-28-2.three.co.id. [116.206.28.2])
        by smtp.gmail.com with ESMTPSA id s14-20020a056a0008ce00b004f66dcd4f1csm11094840pfu.32.2022.03.26.06.27.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Mar 2022 06:27:28 -0700 (PDT)
Message-ID: <0d8f6004-93df-db06-778f-85e371d4ee35@gmail.com>
Date:   Sat, 26 Mar 2022 20:27:22 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.16 00/37] 5.16.18-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220325150420.046488912@linuxfoundation.org>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220325150420.046488912@linuxfoundation.org>
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

On 25/03/22 22.14, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.18 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0)
and powerpc (ps3_defconfig, gcc 11.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
