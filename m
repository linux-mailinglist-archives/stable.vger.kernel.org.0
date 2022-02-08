Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0349C4ADA91
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 14:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241623AbiBHN6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 08:58:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376885AbiBHN6K (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 08:58:10 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABAABC03FECE;
        Tue,  8 Feb 2022 05:58:09 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id k6-20020a05600c1c8600b003524656034cso1711631wms.2;
        Tue, 08 Feb 2022 05:58:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0WI7Brn+NpJb3D0Xoxyr+4c5K2XB/T9OBVp3olCCxvY=;
        b=V2LO5O5B/3AxwicGT58Nl/qvy15xXxkYEJdFb2JP0lT/1941loLvsj8I6ZfAgakrGP
         nC1MPWJC/rU8GowQwiKSdJwFSxjTNOhzViMt+Mvh4mBa3apl+FMiohQSqyvVco5HAzg4
         zTcsxwbPEzRX5TrlBAQl9/tXvDDCvFVfj3NFzeStXZR2oht+DUCRZD33duO2/yv7bYYy
         H01nYkX2Y6TEAc5V3w8/QeUwrOdSqGNnsEF4XkKwI3e61aL2hL0crzAQCq6ShGNRDgsi
         WdAb6CAYeX+gJc2B4LmjWbz0STlNjp/cxmA0nDK7L6OzjwiPnCXB0TrxGv8KpDZ3Ku/s
         Ieow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0WI7Brn+NpJb3D0Xoxyr+4c5K2XB/T9OBVp3olCCxvY=;
        b=zzA2CZ9swqjDe1FiMVgrGWpXYxQYFQDp9UIsFkB2JxzGbvBdbtuj1+7heAu4dwBV1H
         HuL0BKVaD1LRPOU+XVWUuwqBp8SX4poa7NRCO9VVcCh6oYkygfBWPgx+9f2GHUM2zY5k
         zzsMoSPWqv2Mid+iQ2i0pxyU9Vk+E21yG8iQqmH+eaLtx47rtx14RHWClCWs+v+nMtFU
         yIJxDcbD6PYB8unZTEuAXRlJabXqQf5Sib0l0+G/B820/ifFWh6jvTPHDNb7JsoS5Tn2
         dfazXxyg77Lv71W8KMeIXvLlEAXkk8OYDC2xGVxGndIoiDfp34ysebvaknMijoejY326
         Ktng==
X-Gm-Message-State: AOAM532WawpWKronv5/3/XYOiq0j/QgNrartUE81VTdbHGujMFsfqQJ6
        ZkXP9C+H4sRiaAFTURQZrT8=
X-Google-Smtp-Source: ABdhPJy+itGHOfC/fsnESWjfMzDyyqIPKOTHOUuelPy1Cg/ngGBQOJvth+nLkTPZa4PVeLpFW0sTrw==
X-Received: by 2002:a05:600c:4652:: with SMTP id n18mr1241259wmo.160.1644328688001;
        Tue, 08 Feb 2022 05:58:08 -0800 (PST)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id r13sm1680683wro.89.2022.02.08.05.58.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 05:58:07 -0800 (PST)
Date:   Tue, 8 Feb 2022 13:58:05 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/111] 5.15.22-rc2 review
Message-ID: <YgJ27SqbSTk322Qo@debian>
References: <20220207133903.595766086@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207133903.595766086@linuxfoundation.org>
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

On Mon, Feb 07, 2022 at 03:04:35PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.22 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Feb 2022 13:38:43 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220121): 62 configs -> no new failure
arm (gcc version 11.2.1 20220121): 100 configs -> no new failure
arm64 (gcc version 11.2.1 20220121): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220121): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/725
[2]. https://openqa.qa.codethink.co.uk/tests/727
[3]. https://openqa.qa.codethink.co.uk/tests/728

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

