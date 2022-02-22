Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF5FF4BF0C1
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 05:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234443AbiBVDmd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 22:42:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbiBVDmc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 22:42:32 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979351D0EF;
        Mon, 21 Feb 2022 19:42:08 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id v8-20020a17090a634800b001bb78857ccdso1079632pjs.1;
        Mon, 21 Feb 2022 19:42:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=6YZfA073bFOEKhW6Tp2T9VddZaZrJCiPQszcC3ZKisw=;
        b=hyU6AYAlD5Z4VaeroZi53IwiXULZ23fMu8IZyI2FytUKUaHZQdoMEQnzKXkD9E2yVq
         HEEIdip8GN++YpePgp4BAU4M0sBflFA0qedZjwUluzW0jNeQ+nCxVL1K3PF+tbB0dVEq
         z8qcM50o3rdrrljROOTMphhxoL/UlhPWz+18RLIouaLd7GWbs1TPbX4Ud86YIG0ngBO1
         7TXGXB3p9itrk4OsH7oytjxB59rJFLRANmul7nM3BS75+RB0D7zGg61NTwP1125KYGyF
         wy1sEGHqUy4nSqxPGBzI2xSwcZDsfdQXcZGl9kdJPm8ZSabGpvdfmsC4QVZo31thjB/a
         eN7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=6YZfA073bFOEKhW6Tp2T9VddZaZrJCiPQszcC3ZKisw=;
        b=soAx9zI5SHZOAhYH0Oaz2BHADFDk+8f1YKokAXmyiVmF/pvNIduj5ju8Fu976wmG/t
         SbEnU2EuuNlkN7Xw1EABKH9ludNW4sN2gzNa4WTO9jIEybv0fiAS9u3pDNaj63BfSIu3
         5UG+SYqR2AUmhYnVVccY1+USx7H6uMoK8kNNrcPRif2uIazY9k+2CTaLAOLw9oEHmZ9a
         aXT+qs/98DPkaHhKwcc3zkZul0kcLHQ8ejwo4bWTnfG0RppyKtKXf79PXjdpo45gpsR+
         r+Anc4gc+YS3DhI5YoRchcRZPdtyGe9Kx6O9j9qaphA59fqPWy5y8FS2u+Oym7XPPq9c
         8gVA==
X-Gm-Message-State: AOAM532T37paLIaBNh4Y7WuxZytppc5SKzrN7BJ6/ezmPIxRp82vJRfU
        uL9tgUwoqKJO6G0wjmymMSg=
X-Google-Smtp-Source: ABdhPJxyIyIXhNo6oAV+My576nXswaSPf9zXx3WoAaJpNkasWx5UngorjCSH9GHKNhS7AijNHHLdtw==
X-Received: by 2002:a17:90b:350e:b0:1b9:5875:a683 with SMTP id ls14-20020a17090b350e00b001b95875a683mr2080910pjb.51.1645501328044;
        Mon, 21 Feb 2022 19:42:08 -0800 (PST)
Received: from [192.168.43.80] (subs02-180-214-232-77.three.co.id. [180.214.232.77])
        by smtp.gmail.com with ESMTPSA id np11sm683221pjb.25.2022.02.21.19.42.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 19:42:07 -0800 (PST)
Message-ID: <f4994de7-edef-02a8-dccd-eb79745b8fd4@gmail.com>
Date:   Tue, 22 Feb 2022 10:42:01 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
From:   Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Re: [PATCH 5.10 000/121] 5.10.102-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220221084921.147454846@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20220221084921.147454846@linuxfoundation.org>
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

On 21/02/22 15.48, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.102 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
  
Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0) and
powerpc (ps3_defconfig, gcc 11.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
