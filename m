Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0223748AA
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 21:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhEETZ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 15:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbhEETZ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 15:25:27 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 742ABC061574;
        Wed,  5 May 2021 12:24:29 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id md17so1376308pjb.0;
        Wed, 05 May 2021 12:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wHHJjG1E759TaLHE2KWHbz19PcWUQLfwFA03nkndayc=;
        b=k+cAwJLnmpWGV0eg5Um3AknavouvKT6Iw1Bu0O40pyF7sxZoMjO3izDcaGEIdcn8Pb
         AsoHmDnU5VahaWtOK6CSTpeaHmUZ4ynoJ5W+WsL+S3iRI7ggRX7ecXkWsTIQl6Izpo7/
         hpk7LIE00GoCq57zCKO49NYam+1U17ukTn7vb2Vocd4sMkNQNmPXPM/NiJx96e4krHBw
         DJ1FD6BUB1g+iVdq4EJl3AjJzKLv1Syi4LDbHnhLY/PzpRzrGz4voMZ/TEoXoTlIjP1I
         UapaPX+EG19QMVtW0bDvRvrUJkxwHL4oDS5EgT8oLsmorSmPy7v/Px9IBt5OABbZjl7W
         Xqaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wHHJjG1E759TaLHE2KWHbz19PcWUQLfwFA03nkndayc=;
        b=o/jlBSKXqIMmGMHSeQ/sefq66nlPfRvGNsQ6ZkC0m2ZUchFYNX6yA4UI13rsEy+jJY
         DDKPZvKyBjx2Drs+nhZpQ0MUAiFVjClnQDNiclQwvLIRV3IwVSVAMaUElQ7X5/e9bAvv
         14V1dtzwyoDPJ7nQsDJCWbsXRsrvoCpoINDUPhgD8oB5TVNyHtHFK+RDTXiTmvkHA4sn
         liUUSSA1CKd7svDtSENMaEQ8dApJcAwWcGklDJj2HtI7z/QkKjYBu5pFVJ94146Qp+PF
         E+Ie2gkXJ+Zv14pF/DP6wkxxsD0TP4oE6mG6abZQmNUHfhMFWZmR8CXDXrbuytQZ4RAB
         XmyA==
X-Gm-Message-State: AOAM532ehRXAJx4vnUUwf7Vxv5BhIG5aY90EbQGoGnjUigpnpLTmYVdb
        uZCKQHJvFnPg61+M5dqCFee1WIh71e4=
X-Google-Smtp-Source: ABdhPJz/g5aUxaNQVFJyWlVN9F7vCEwINA8GSktoI/QXAFo2Neoe+m+SylVA22CXVbukHkY9Hh8gQw==
X-Received: by 2002:a17:903:248e:b029:ec:9c4f:765e with SMTP id p14-20020a170903248eb02900ec9c4f765emr657405plw.17.1620242668624;
        Wed, 05 May 2021 12:24:28 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id a20sm39639pfn.23.2021.05.05.12.24.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 May 2021 12:24:27 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/21] 5.4.117-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210505112324.729798712@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ccc64af6-846b-6b7f-8e82-860796ebfdb1@gmail.com>
Date:   Wed, 5 May 2021 12:24:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210505112324.729798712@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/5/21 5:04 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.117 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 May 2021 11:23:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.117-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
