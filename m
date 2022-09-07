Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F28375B00C7
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 11:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbiIGJn5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 05:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiIGJn5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 05:43:57 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C958FD7F;
        Wed,  7 Sep 2022 02:43:55 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id m17-20020a7bce11000000b003a5bedec07bso11457872wmc.0;
        Wed, 07 Sep 2022 02:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=9/xmz1K3EAur5r0xgkOcxS7AQ9x/ShM4a46yCxbHdMw=;
        b=Y13yGzY/sn8a0Bema5ex3Ry5uO7ptoyLa47eeLKrj0zxKVsO38Y3ZzCnE3g9eguTCQ
         BCxzutuBgX0HnsOFRIQTlEDSvuoc+vTG2MgOfikVPX8RZXzliyNrjKUdRmvu4gkv0Mit
         i2lhdB1iJZVGO6vr7Mjgg8oAS4gfCcmhMXPC6sun17dH8ewksbogsFAAR+EgtY1wUhzQ
         kYo8vMLaETewcX4v6QspJ1MLonnmfP26Vnl7/hwQ3kQ/iXMYQ/R2VwX2BU2tjiVkRWKI
         JWKehPdhW+fzIH5sHS8whXUVWlbQ+NmsHDYWqYmuDixFdeGtvC8nfxSGtAYefIP6xfPy
         VJlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=9/xmz1K3EAur5r0xgkOcxS7AQ9x/ShM4a46yCxbHdMw=;
        b=i6365AVdpoKW58ZURIZmqmIe6Kw0zoSImgRjheLLSxAtlXacitB4LFQTTYiyo7j7TY
         lKdlwxEa2bQUkoonusnhDeo1rmFWOravtZLQQBGOLaybT18H4stRt7h8L+NGesnApqnx
         s5SzNo0TBVFq0wO5YkFO7jIj6sxSiaE8YuLkSG7nX/JdtWhX16MHZzhpeki5vJDN3tCe
         HU7ZohFKVhZGvkhHqFbvSkVY5ic4C+atYR8M6FMs2UkIXRe8CURwzb2ETsnZTrl1Hhvg
         bmWDDqvw0EuUnXae7YEvrDnSAI7yloONXilXw7R3xcbDvxfueI4Yq3K7UrSSv53jcUgV
         hYtA==
X-Gm-Message-State: ACgBeo2/Ll1HfWl+Ihwf3uo+u7BzP0ICX4LarNOCnrlqT10QF3ResGFA
        GBvEn4NSy+NXhzi6stN9pFw=
X-Google-Smtp-Source: AA6agR5TH7i3awt6RIN7dHkVIh5+jT3YkdTLuoMmsSXPSq5NwY346UDulEpBKMJB+t8/cx+IkbiyrQ==
X-Received: by 2002:a05:600c:444b:b0:3a6:6b99:2394 with SMTP id v11-20020a05600c444b00b003a66b992394mr1458569wmn.43.1662543834068;
        Wed, 07 Sep 2022 02:43:54 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id j17-20020a05600c411100b003a6896feef7sm17627154wmi.39.2022.09.07.02.43.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 02:43:53 -0700 (PDT)
Date:   Wed, 7 Sep 2022 10:43:51 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.19 000/155] 5.19.8-rc1 review
Message-ID: <Yxhn13seD6t7vqD/@debian>
References: <20220906132829.417117002@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Sep 06, 2022 at 03:29:08PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.8 release.
> There are 155 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Sep 2022 13:27:58 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20220819):
mips: 59 configs -> no failure
arm: 99 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/1781
[2]. https://openqa.qa.codethink.co.uk/tests/1786
[3]. https://openqa.qa.codethink.co.uk/tests/1788

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
