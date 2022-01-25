Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37D5849BB07
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 19:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237217AbiAYSM3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 13:12:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236942AbiAYSMQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 13:12:16 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8D8C06173D;
        Tue, 25 Jan 2022 10:12:15 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id d1so20111108plh.10;
        Tue, 25 Jan 2022 10:12:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=oncvTFBiH1AN1qkgKqjjo5usjPdYcyTNfm6ebR6GGgg=;
        b=U55+0RvH9Ct33KOJYfC3NT19EgIgJJHI/p9+j3KfYpMa/R2U6tbhwX52hQjM8W4cAR
         gDox1Lw+iLj3ibZ/nJTyZ/56wvlxdsxb3gJ24OQVe0wsx9ASg3qTh+sJTMRwvGAwsDO8
         UzXxZKnCYpxdWzrnhWfkwXokfs4E2vzQslt9KC4fdpHssDMDV25FcWX2RPiSZu2Yt6jt
         4BkMMLShSGEk0MYvaJUqCmFXBR1Qk5S+mtQDIoaNjwDcOQ6b6NfDnbTEeZMtQLxXUi+j
         6O4Prm5GoKCyztuNRT9fwGouHNM60NXB21+23CkyMkV9P+iCE4xe0wHnoU3RSvGVBsJ6
         wyKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oncvTFBiH1AN1qkgKqjjo5usjPdYcyTNfm6ebR6GGgg=;
        b=CnC+jFtx1L+EjyFVmanUDczCTF4/r2rmG6ybBcYudH2dnSdi0cYjdbYbk3+ZsqiZI4
         fkIHK94EDqsKqOUOUhuR73VVezEJBhGgd+/eQ/kzUINIz1X6dN1ozuciZhh2alxlSYLe
         U44ZTuU1OGqZzm15uGA0vY36da27iQ5GHNSgNXpIWGRhENk11FcSom2jRV+cVQKo1aAN
         RBtWaxCpgS+V4ucsgGhxjij/VGRW1z43zidb1ZYeVQxp1nYptxb2hQEVoKmwMymHikem
         D4TDXjLq3vTg8V/RUCA6hsosWvGA7hU9p9Mzu27UYB6OyEjFszv/o9A0K4rtMuZGEtq5
         s8lg==
X-Gm-Message-State: AOAM533vaKS0nAXNQns1wzQoI7JSA7O8s6o3P7NBlshKemm3VGwQ8pTw
        EbO3XkKfGeY49aVmbaO1ppA=
X-Google-Smtp-Source: ABdhPJxjnybuFczjajxTOaUK9aAEWMUSJ4x+gaOCBS6OBH/udUgi3+mMcluTSwOAF7N8OZ70JH9bzg==
X-Received: by 2002:a17:902:dacf:b0:14b:2081:1c20 with SMTP id q15-20020a170902dacf00b0014b20811c20mr17657075plx.13.1643134334658;
        Tue, 25 Jan 2022 10:12:14 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id ha11sm2879550pjb.3.2022.01.25.10.12.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 10:12:13 -0800 (PST)
Message-ID: <79dc2061-e3db-50a0-3cea-cce87abef718@gmail.com>
Date:   Tue, 25 Jan 2022 10:12:11 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.15 000/841] 5.15.17-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, stable@vger.kernel.org
References: <20220125155423.959812122@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220125155423.959812122@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/25/2022 8:32 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.17 release.
> There are 841 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jan 2022 15:52:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.17-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
