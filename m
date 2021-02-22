Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9BD321ED8
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 19:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbhBVSK6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 13:10:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231286AbhBVSK5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 13:10:57 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6703C061574;
        Mon, 22 Feb 2021 10:10:17 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id t5so253538pjd.0;
        Mon, 22 Feb 2021 10:10:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Qc0fpzrU1CPbygjDvtp+BhS9vGGt7mUmosW6V6i4luI=;
        b=IIFZC4IHh/gshHdRBavDtlrXbRFvIBpyidzdSsrWDw+KkMxitFBisnaL0bggHH+/w9
         M/e6kc6JuWe+r9YFLxqweSkltKBO7G/isNPPWZnmN1ccxUjOnLHDGdThUYyn2Pmz8BQ1
         DDnUcPzKOOmU1A/ILWdxRpyDmIPVUGFhmDggUbF5O/C6WyBIWvJ1rHg4HItkf8rHEvbp
         8ynyljrWJ9StOhm3LyGXwv1c//F8KZvGFSL5pQzFNJHAw8H2/purJI3wbvRWj1Er2ziW
         sgsfmneSHMAg/WoSKcQrL/W04bzY7c22YZu6dex/XWio62ieMF1poeiGXDpnBjW+vWVf
         BEFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Qc0fpzrU1CPbygjDvtp+BhS9vGGt7mUmosW6V6i4luI=;
        b=Vxkez9P7kKRhDU7K2mJw9QGVe3G0JoBJIMGIdMe7IFr9SGF+3Ik7wRgHmSfO6DWLZU
         uZygWdGoVLCIA/NAkvlRwGhvJlyBGT23vpRmQWl1fPcGAPUGThq+5oW+Ce+/g9jWjkte
         H5g/dZy+MbeN6fB9BeqHkzHHwQdWaQBC7YF8Lmb1UHkdyJCzu81vvWVl548OS6QHi2Kd
         uUUKLdQuJUrs7onfkIuhNpKBpP3RKoX9STEIbpUr3I27vZjh/cmVbJgxs7Ytx4padf9+
         GibhT8kUlglcXNxX8vqlKuGsKm7e0SMtOt0VfkE1sAadWeqREj49yW7h6mvfFs05cTwh
         iDuw==
X-Gm-Message-State: AOAM530xQTU3xgm/Va+gBDuWrJVKtBwZgYAUfxuBCW1EnVEvRFjpYAPb
        EILJJJJI78yp7hb5xFloMTICW9KNs2Q=
X-Google-Smtp-Source: ABdhPJzOMFO2q0LK38mmjD9IzrwKPr+DkIJzwDRUdsfbnDXiuV7dmywWKAUU8JyGGaw6AyBA1+rqmw==
X-Received: by 2002:a17:902:9f94:b029:e3:287f:9a3a with SMTP id g20-20020a1709029f94b02900e3287f9a3amr22498479plq.46.1614017416868;
        Mon, 22 Feb 2021 10:10:16 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e16sm19291202pge.17.2021.02.22.10.10.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Feb 2021 10:10:16 -0800 (PST)
Subject: Re: [PATCH 5.4 00/13] 5.4.100-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210222121013.583922436@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5070492c-3d93-035c-e536-e2674fa2de07@gmail.com>
Date:   Mon, 22 Feb 2021 10:10:02 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210222121013.583922436@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2/22/2021 4:13 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.100 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.100-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.

On ARCH_BRCMSTB with 32-bit ARM and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
