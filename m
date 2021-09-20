Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09601412CEF
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 04:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242453AbhIUCs2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 22:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348943AbhIUCZB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Sep 2021 22:25:01 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE1DFC0A889C;
        Mon, 20 Sep 2021 11:54:06 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id y8so17099826pfa.7;
        Mon, 20 Sep 2021 11:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IkjIzjHDCDALH4fxN/HhWlJ3UHaUw+i3IxXPF0eTxFw=;
        b=YZ0tdw9qmo2wgWszO1noIKB32A//ZTw13cO9q9G1ryxdMPAJvvwlV3mZjAsWkYmG4F
         KMCCcgD8Q/TN9rMPNvDR/gIAv4UZqqosnG/x651LEzVwl1/FzVamiBjzS8u+URq830EI
         BBAZnMGNFUO0UBpw239yHzkiR9WUouQ7/YwgiH9231eKMiaQF3d53TFn63rl7p4kK32N
         zAwvSdtGCgC0jb7zFvY0P5/adCwzJShs4gJ1qXz1e7/9DB1xPvaD9b+ZkwUL+Xn0lQj1
         Iu+RHLxS3kbi7h06lMyR/Ukml+PHDX7HHyUAX5V32JfFDkghAz5MW+FL0j8PgbcuyWrU
         GkYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IkjIzjHDCDALH4fxN/HhWlJ3UHaUw+i3IxXPF0eTxFw=;
        b=XVbQnFDGaOl+iCWgfXBbRWKaQQ6ZI5qo483HYoXxfwLWdt9Pk6b5xBfLc1IKxAoK7K
         JTfBXYc8CsztBKy/+pQPSW3i55GJN0G/HP+eZ76AsGw3E9nJxc5MFO1qlEQngeX/oDmD
         Lz8+2f2KK6iVgmRR+cqlpXy4Kp2lvrLoY/+Rgo7r4xBL6+r8hDZy+ebkx9IWoF7UHewp
         OS60yoM9Q5nu2XnsVrBRjKcTcYievRLeyszTOnmYQaWjlr/LJjIUhFe0bRME8O+AOSJi
         u3udTjIn4mzg9xZLFJOjATds/48sZkVDYIo9HgF15E6GEr/JvYsjx1kyL4Xuz0+vG2Jj
         xZ5A==
X-Gm-Message-State: AOAM530+RdLteXWeYH1/lY0Es8U/xjO9XY7vKhSDjIr2rLUl+1A8Y6TX
        LEoum+l+EabEythakgKa7ZyHIeH55ts=
X-Google-Smtp-Source: ABdhPJyPuJJme41wVpGuaXgay6kguMxPOL2OWx1E4rHl30lX3QxTLoN94GvSJIzB9lal0TkIjkl7nA==
X-Received: by 2002:a62:7e11:0:b0:444:bd85:e2c7 with SMTP id z17-20020a627e11000000b00444bd85e2c7mr19466313pfc.45.1632164046148;
        Mon, 20 Sep 2021 11:54:06 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t13sm579384pjj.1.2021.09.20.11.54.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 11:54:05 -0700 (PDT)
Subject: Re: [PATCH 5.14 000/168] 5.14.7-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210920163921.633181900@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ca3953f8-e3a9-e3a9-d318-0f84ba96db12@gmail.com>
Date:   Mon, 20 Sep 2021 11:54:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/20/21 9:42 AM, Greg Kroah-Hartman wrote:
> 
> Rafał Miłecki <rafal@milecki.pl>
>     net: dsa: b53: Set correct number of ports in the DSA struct

(same comment as for 5.10)

This patch will cause an out of bounds access on two platforms that use
the b53 driver, you would need to wait for this commit:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=02319bf15acf54004216e40ac9c171437f24be24

to land in Linus' tree and then you can also take Rafal's b53 change.
This is applicable to both the 5.14 and 5.10 trees and any tree where
this change would be back ported to in between.

Thank you!
-- 
Florian
