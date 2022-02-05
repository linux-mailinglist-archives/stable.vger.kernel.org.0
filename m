Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B227C4AA78C
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 09:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbiBEIOO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 03:14:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbiBEIOM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 03:14:12 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 484AEC061346;
        Sat,  5 Feb 2022 00:14:12 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id e16so7005443pgn.4;
        Sat, 05 Feb 2022 00:14:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=OPaqRK6zQFZz/ChCegqKFzHD7aeWbU0fGcrGynwFCb0=;
        b=eokRVSppxhbBykTB/idPGoi50GHNnmRvScDmv5qv151yl302PTMFuOGikIBzLBjIQs
         aFAVEBYavzHi46euGXxeay/mirNMnC1OPo5CbMvM39fF6uC0jP4qogtxJnkGw2KHDegc
         mjXKAdDg6ZSikG+BPyw2QrFx/jH/2XT9WL7ujjfgxCy95sBkA2MlhJM8Of32FIEq+ock
         uUbCuMaVadhUXRAKllwHjX3nA8HJb0/1J/THSuo1QoyRtjuDxMZKtbgyS+hoy728Q5RC
         a2nfWSmeKRB6nRbnJj3LpKswDn8qrsKp6JPFR342y4G41NiDEwoZ7ZYLRkJkeJU8SGjO
         kbkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=OPaqRK6zQFZz/ChCegqKFzHD7aeWbU0fGcrGynwFCb0=;
        b=0HGVOtpCR1K/EC20tXDmycpaAfNsZRLroiDuwzyDyMQuEuV0oQaELuELeXUBSzozVw
         hGRbDSu1nwW05VdYeOryME/GofrGuPla/PhPDWL+ubJITctK8ZGoqdT49KUh/IePnNWF
         jaKNIi1DYmvVYc35ptsTZHtoKz1Tc6xGKc+GA/hSTioPInzoERM42Te3rkAVll+WsalP
         mC+me1YNmhBSVkh8nk7NT2DvvHzgLS2oQrSJE9xaOD3d7H+MFNxFkJiuegsFzVQYYthm
         V1+eob/t5P72I48Fx6Jtg0fhxoFqhed11R98pYdzsafE5bhhkttrrTpWnX8ups0O6hd8
         WLzw==
X-Gm-Message-State: AOAM530e79m4DKkjYye8efRKYZXPkNC6wkQjVKwxttN6YWkXkJbpOGsT
        NPMfwOqxXw2kEaD0+lqSHIA=
X-Google-Smtp-Source: ABdhPJxXu/2XWfsyc+zpsIaBJ+FwPMvjOjuP52QvK179wk8Vg8sAkM3hEg32lEJ83kV0EZPcIO2WHQ==
X-Received: by 2002:a63:8b42:: with SMTP id j63mr2179302pge.225.1644048851399;
        Sat, 05 Feb 2022 00:14:11 -0800 (PST)
Received: from [192.168.43.80] (subs02-180-214-232-71.three.co.id. [180.214.232.71])
        by smtp.gmail.com with ESMTPSA id a1sm3171724pgm.83.2022.02.05.00.14.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Feb 2022 00:14:11 -0800 (PST)
Message-ID: <5da760c1-c52f-786c-aaf0-f4575e0a7547@gmail.com>
Date:   Sat, 5 Feb 2022 15:14:04 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From:   Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Re: [PATCH 5.16 00/43] 5.16.6-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220204091917.166033635@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20220204091917.166033635@linuxfoundation.org>
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

On 04/02/22 16.22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.6 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig from raspberry
pi kernel sources) and ppc64 (ps3_defconfig).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
