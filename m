Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7131409A82
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 19:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241943AbhIMRSX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 13:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238180AbhIMRSX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 13:18:23 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42AB8C061574;
        Mon, 13 Sep 2021 10:17:07 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id k23-20020a17090a591700b001976d2db364so543901pji.2;
        Mon, 13 Sep 2021 10:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=mlffzi5+OqIROP85Dbv15MA59w+8i9Z9ITYBlj56pU0=;
        b=Mu/e5CaUDM1L2F9jn+v0PvqL+HkMe5ePy9F+pmf7VA+ub7axLoWtBG00OtIGIzR9zL
         lfc8Xrvvuft6Ji6bGX5XCcJuqhvH6bNXDzeyXfir2R1ng/pKQdWnXfjQPLt9K+JZN9we
         HYyKxRqt6Wb62jWJTT6gT48LX1AQ+K3NMT3dldXyXB6Yl5KGuQhuxxRwiHyAFe596z4C
         4RV7h5KvASgOab+gDgSiL8PIbtQko7gAUn4RS92sB8UKnoH6lqX02XtxT2Rn0D2i4UEu
         GzlB7tO4BN7htemHM0ujod+M+YgWgBbu4OSWClHJHTHbncmzN2AWCxxkYpxOOVcpVjj8
         gwLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mlffzi5+OqIROP85Dbv15MA59w+8i9Z9ITYBlj56pU0=;
        b=sicHnyHQ496ilHhAdFNe6ugeEXRJaocma4nF/UApoZ5gTb04eBCeGfOfULwNTpyMoV
         Ty2NIf4/CAhUI8CdMq4Vu5gohAF5w0TydJgYmHr4y5D2ML1wihtD5yr3M+e7NRLKda0t
         kl6jiHQhIoGWkJQyOaZoWcEF3SpHbAB+qr/wFJMcwVUJX44feCgIpT93Ut8AbgBKqG4Q
         9NHqtVB5eWCYGiQ/2Bc12vLTeg/8fVuJ5L0gb4bY+7N5wYZ95LWYcwWRZ2nSQ+dfvcSi
         aqcHjylGpic08xoZsuX1rzqVvqOqG6TlUzLZ2kV7/VpENNDOCVfygN2pTt+qg23hXklu
         gB/w==
X-Gm-Message-State: AOAM5334e6mEr/5p/sTdpTAJMZ2fQY0TEarjogCsxkWVFyHj7dtg1oea
        upOy13F3zpThrc/SQcSaxC+ldNDP/BQ=
X-Google-Smtp-Source: ABdhPJz+gOronG3BOnMuJ4/mQKjyhJU5qZdDUxaJ0ZfR7ljiczAAE3ctCLrZVpas9gpy7YzaZDo/Uw==
X-Received: by 2002:a17:90a:5d0f:: with SMTP id s15mr609451pji.10.1631553426754;
        Mon, 13 Sep 2021 10:17:06 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id 19sm7870251pfh.12.2021.09.13.10.17.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 10:17:06 -0700 (PDT)
Message-ID: <97818897-ac4e-503f-0859-defecb03fe4c@gmail.com>
Date:   Mon, 13 Sep 2021 10:17:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 5.4 000/144] 5.4.146-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210913131047.974309396@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/13/2021 6:13 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.146 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Sep 2021 13:10:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.146-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
