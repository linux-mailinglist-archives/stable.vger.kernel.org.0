Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5F6F4DD56E
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 08:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbiCRHrn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 03:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiCRHrl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 03:47:41 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0321A1F83F0;
        Fri, 18 Mar 2022 00:46:23 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id o6-20020a17090a9f8600b001c6562049d9so7665811pjp.3;
        Fri, 18 Mar 2022 00:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=qoi4QGgxrqjy788HWka9y5Q8veZdkoJr+j/YlxCsH+E=;
        b=g9SqHeIRuugdjX+4WOujma7JC1opKvGijJAuXQg4tW3kvr2JaRNsfrAFJCg04cUhq0
         lDF3i/9r93bV7k4vdBBpII39DbhLCJH+m/YA6vaNtvXGfiq45S0mgaG2h98Sb9+TGGBl
         bVYoJhgliXG+iACkxW8I8kDQsCr2GsEINHMOrzXwPNhB/f+qd4jUyCnsoodE6mnia5Bw
         UZ++mMjaa2LNh/d9rQX2YdgG/lBPyQjca99jOG9D8TWTRYZV2axIfd/CRDh/gaNKct9E
         lntLTyXIAUNaK7rMp3sUMmnRj2ECdHL3YjibNhJmZhs+SIvX3JsxO8y8ejxGf7s9sNxj
         XMoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qoi4QGgxrqjy788HWka9y5Q8veZdkoJr+j/YlxCsH+E=;
        b=koA3njMzVR8nQaJ+vr+yVEorOrLZhMqg8RPFOH00zTa8k3YeVJWDZ4CD4Enl3bF1+P
         X5bM2Y2cBysnt2hpP8iEzqCitBXKJrHD8LqXWsi2yUhoG3nSJlJiQ8oPeOzWhqcC8lmn
         21lIlLZP9N2o4B2gQtNQPgVpRfZCoCKABSBv95gQD9s52GgcyQxJkxOGL0+XQ3npdMJg
         th5EWZtztPADUDeJpDz26DerFCdocmMF4KrGbNbNrxqWdPGzKHr7emNB6NarY/9btVAX
         GfeirmXDLGbNM5IxtnGcyFYSRBVZRij3DlWMYcO2D9Sdi2l8cIIYUl0AwOsMmYGVLrt+
         GNDw==
X-Gm-Message-State: AOAM531nVCFI6+gfSjTWH8i69Dr8pqUFQ6x6kDEx+zgKQadNWPpvRrTK
        qdrtD6/CQb/bmCNSf62RnyM=
X-Google-Smtp-Source: ABdhPJxZYm549yKrguPyJ2FQkzbsflhZ709jcp46n0H5+PvSUe8+uXf6aci4EwNuy9yt5eCwfqkK8w==
X-Received: by 2002:a17:90b:3e88:b0:1bf:3a96:54c1 with SMTP id rj8-20020a17090b3e8800b001bf3a9654c1mr9781455pjb.244.1647589582458;
        Fri, 18 Mar 2022 00:46:22 -0700 (PDT)
Received: from [192.168.43.80] (subs02-180-214-232-3.three.co.id. [180.214.232.3])
        by smtp.gmail.com with ESMTPSA id k10-20020a056a00168a00b004f7e2a550ccsm8691490pfc.78.2022.03.18.00.46.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Mar 2022 00:46:21 -0700 (PDT)
Message-ID: <7a3ac61d-bd82-9a97-7caf-5437f18d7cf2@gmail.com>
Date:   Fri, 18 Mar 2022 14:46:16 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.10 00/23] 5.10.107-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220317124525.955110315@linuxfoundation.org>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220317124525.955110315@linuxfoundation.org>
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
> This is the start of the stable review cycle for the 5.10.107 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0) and
powerpc (ps3_defconfig, gcc 11.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
