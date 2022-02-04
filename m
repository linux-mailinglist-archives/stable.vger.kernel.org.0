Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46DF24A9930
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 13:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356391AbiBDMV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 07:21:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237442AbiBDMV1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 07:21:27 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE45C061714;
        Fri,  4 Feb 2022 04:21:27 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id h20-20020a17090adb9400b001b518bf99ffso12938816pjv.1;
        Fri, 04 Feb 2022 04:21:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=dAtkN0WEE99WegUGgzufuxdEl8C+V1DMiMczTkC1l0Q=;
        b=hdbk/9fxLHRiqvD1U37NmMvWPQfOKqti8FSTg3S/Nme1GurXGQwV8RrkNQoV/6MObR
         EGzNMx82zO3z/tCxF5VRC30jrRryoxjrUIbBDaCRq8LJSYLhobezVCk7fxpJl9OPLokd
         3IFA8grrvAs6alWv4nrioEAHwGxw8iS+qNLJW34O99O5t2a9ZpALpncVdXWg73WfUPWS
         2FkrvdSn0fdjcSJ4bWCw16oAFN5ID+zNw8o7FZpKMJ/iSxeAhfRo4ANUYIJit9q6t4VV
         AlVICwSvGm8hHcGQEloSIyrUyc4kS6wnPLM2F0KGjKfASp6KEv9dilZUaZlv2WG5AHT5
         h83w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=dAtkN0WEE99WegUGgzufuxdEl8C+V1DMiMczTkC1l0Q=;
        b=yq7yS30Kj6yUj2LqWX6q0iPggdFUKj/dlNEuNvC55gYHUTzwECcexq/WXcdzlSGJhS
         P8ANwcwMx+c8nA886dFdc3MWSfKFRuQuffi3ayt7r8XrRuSRJh9VjSMPqZq65J+4Ynd9
         Wb4iNkPn5dWa4womnq541lIklIrcmp8vPNWJ/6e3mBHxBmjmzrV0EgvhuZP1Zioj+YJI
         OAACgvPNXyTIEqKFvnMO8OtqyaPn5optHQ4L1h6CcfDdxv7mC0tdjwXgTV63jjWbxK7M
         XZ6TmacLkkVfTXitGgf0t/Cgt2n/snPkntiGXHwmvACrX1Z66g8Ahzjgj9M6mWXYzZm/
         AffA==
X-Gm-Message-State: AOAM531RiVMq9c26JQa+op3XNSLVs3JFmAyzwAULJYtLeBD6Mb4dZZ/R
        2N3y080JpjSqIq5h++G0we0=
X-Google-Smtp-Source: ABdhPJwJTCea7DO7BfEN1Lt2Ch1r23IrSp83zKhGsERdBbziMhky/iIb5X138bQ/bN2IMfwkQyitnA==
X-Received: by 2002:a17:902:7242:: with SMTP id c2mr2948654pll.168.1643977286912;
        Fri, 04 Feb 2022 04:21:26 -0800 (PST)
Received: from [192.168.43.80] (subs28-116-206-12-44.three.co.id. [116.206.12.44])
        by smtp.gmail.com with ESMTPSA id v22sm2688092pfu.38.2022.02.04.04.21.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Feb 2022 04:21:26 -0800 (PST)
Message-ID: <3eab9c66-12f1-6c69-e299-c00f5e4e340d@gmail.com>
Date:   Fri, 4 Feb 2022 19:21:20 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From:   Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Re: [PATCH 5.15 00/32] 5.15.20-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220204091915.247906930@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20220204091915.247906930@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04/02/22 16.22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.20 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
Successfully cross-compiled for arm64 (bcm2711_defconfig from raspberry
pi kernel sources) and ppc64 (ps3_defconfig).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
