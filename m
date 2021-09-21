Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7C6413A74
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 21:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233936AbhIUTDA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 15:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233905AbhIUTDA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 15:03:00 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FAA7C061574;
        Tue, 21 Sep 2021 12:01:31 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id i23so42288174wrb.2;
        Tue, 21 Sep 2021 12:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/uMd63v+SxKdFxs2HpZF37bfpeLncJCJyibFDLqSxbk=;
        b=JNVkQa7Og1rMOMKRgbU2B4npmWHuPxvYIKKtj6d9hhX6IzhGeE6peFSMVyH17IkI4D
         XOTk5JTnf+uV2aGN/Gr0sAefpINK3l1vDuIsRuOypK+gZhwZj9PDl4DacSQjc8jlISzw
         wpfDgAEn4lARaqaNVTCFbtnG+cju63imEp7F1inZ1Vg4ZlaH2qTVc0SmvyNPMkWQwhIO
         CNztaiZtWxOqggkbD4ELKa0vX2j9yZfChFH/Ar7SKFeAs6/OyQsgFy0u6KPWaQmd3Oo4
         79EpbfTM/6pBILZzDSYaMMLn1xgPMHc+X4FTwUsY1aob8XnOl1PlzPIslKUOAlSu5TSh
         vRvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/uMd63v+SxKdFxs2HpZF37bfpeLncJCJyibFDLqSxbk=;
        b=Ws27cBtjIqzS5qDJokAksWhlgIXR1csoabtwzCm8S1UyILavkLKDBxWJ5opalKBaJy
         4RjtH5CoQqNuyQkx0RuxQYLp8Hgt/BUUTAJhi5VKQR+af18ql02hNr+U0aL1HYW8AlnW
         ffgNNhTnD1iwuEtV0QwoLBigDpXc36NKpybGTxO263mroNmKaVrvHL8nKBzgrsAjBZIx
         zCce9tvmo/dUYDrE3KGs01ZkCHGmgGgtTAtLg3EoZI3rSmJXqnpHHfU5LmINvOt2V7qC
         F1mjPVabmUzgs0y3tM2wadddg+pwpzmW31AFlLjfDE3L7yBSNcpGWBCUFJliOAolaSSU
         T9tQ==
X-Gm-Message-State: AOAM533+fugzB1ffrRhC6tk2uvhPJmGJC3O6ACSwXlfhEy1ROiXLR+v8
        tbmDVNhklNTUfc9wFUb7Zys=
X-Google-Smtp-Source: ABdhPJwUPOXPyrVY+KM6YYc3qdDdwEi/oCqlzJ1JyAWFQNHKPKIZYH9Aa+f68GnLclCNBpAOLoEItQ==
X-Received: by 2002:adf:dc43:: with SMTP id m3mr18897907wrj.66.1632250890197;
        Tue, 21 Sep 2021 12:01:30 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id o7sm25121573wro.45.2021.09.21.12.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 12:01:29 -0700 (PDT)
Date:   Tue, 21 Sep 2021 20:01:27 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/122] 5.10.68-rc1 review
Message-ID: <YUosBwlIzEQy5NLN@debian>
References: <20210920163915.757887582@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Sep 20, 2021 at 06:42:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.68 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20210911): 63 configs -> no new failure
arm (gcc version 11.2.1 20210911): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20210911): 3 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/164


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

