Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28EC94D5EFF
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 10:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240266AbiCKJ75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 04:59:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347657AbiCKJ74 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 04:59:56 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0A62655A;
        Fri, 11 Mar 2022 01:58:53 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id h15so12098901wrc.6;
        Fri, 11 Mar 2022 01:58:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i3NW5x0NziceOqfFD3EnA8Wx9WLWdE4ilwBF6WyCrxw=;
        b=LcMdMHxBvozczf6meHZbQS5OG2OV7qy89Hqz217tElUy3+Zqkxo+NZqQZtRFkJtDe/
         idLjdrxCt2gMbvjVk+QNutD/LpcDr9UTDHob11BJRYEZpn07xZEpVbazfWnpWaqpGHu9
         K3LfOs6/Jl1+COyy9YxyjHlPk3kADKzwTB3YR/VbZ8HJoH4GLHSX5oFCW+aWdlni6TtQ
         xuNclu68VmaktbgF0oYfvWqy2BqbvH7Y4UhUg/FeOj8QF2kTA1dW5D9WOKrgkI3g+NTv
         GgPC9DGpYKx6+r06mijLvuVC8XU8isZq9fAke82Ooi3sMRNIK+L9S+habNb1YXFPKUY/
         6wyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i3NW5x0NziceOqfFD3EnA8Wx9WLWdE4ilwBF6WyCrxw=;
        b=X7DasNXX1iF1otbWX8Ksh/1KpFaOfbE1Bv0ctgi7XokMK6ydHLJ3LqAyXdJ0BWBmyu
         IZOhFc4NMyEvS3zFPEZ4C9Dz6FZxuiHd+k1KXJoNxIYy0uyC67IpLkvUq5E+CkCXTnj8
         lDT7w015YEE5bSqSl/+0wmmTf8cZO9q69xJJ5O8gVGOIzIVPHaFwUQCE5lbSBdFIrIMf
         zmf/5HDUiFeoep9fYIe7lYUOoy1tps7xtoWcwopPMdlIWtczalSM3OmoVkZwOoHDBUOC
         2xymKILSmspflKeQHPCxpVlBRmdpZK1zO73ssLUgdKRRtbvzRfQeV0pww+ama86w0ohH
         hVYQ==
X-Gm-Message-State: AOAM533EDa3kNyqhs77VmikYp1lhnIvPjtQTXECZ6OtqbHrJjjgv2Df9
        voP5G3mPz3iBZfp869Oiho0=
X-Google-Smtp-Source: ABdhPJykzFtSjRskkdvrH9sJVSlRPXIugTdlYgVVVxHkxibSM89zlO7T7ljTPvZbt7RbF+uRJL1kzA==
X-Received: by 2002:a5d:47a1:0:b0:1f1:d729:ecdf with SMTP id 1-20020a5d47a1000000b001f1d729ecdfmr6474537wrb.466.1646992731421;
        Fri, 11 Mar 2022 01:58:51 -0800 (PST)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id n16-20020a5d4850000000b0020373b34961sm6123371wrs.66.2022.03.11.01.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 01:58:51 -0800 (PST)
Date:   Fri, 11 Mar 2022 09:58:49 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/33] 5.4.184-rc2 review
Message-ID: <YisdWSC5pHrB+53i@debian>
References: <20220310140808.741682643@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310140808.741682643@linuxfoundation.org>
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

On Thu, Mar 10, 2022 at 03:19:01PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.184 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 12 Mar 2022 14:07:58 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220301): 65 configs -> no new failure
arm (gcc version 11.2.1 20220301): 107 configs -> no new failure
arm64 (gcc version 11.2.1 20220301): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20220301): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/864


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

