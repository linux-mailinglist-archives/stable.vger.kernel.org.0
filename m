Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 670494AA966
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 15:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380110AbiBEO2k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 09:28:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233697AbiBEO2j (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 09:28:39 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB8EC061346;
        Sat,  5 Feb 2022 06:28:38 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id q19so4188700wrc.13;
        Sat, 05 Feb 2022 06:28:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=my6SYWgNkFEI4drfyD8kjZeU1iIkgJuhbEnGEfifukk=;
        b=gWfqpNFV79N0+fdERIW8y/1dZ40qZuL4A6K1jUJ0sc6AGK2fk8F+v6N8XZiXfGfRON
         4+CtaGopAvDL5dalLqVJ4ZIy8Nhb1iSiO3hSL3FircIzui0tenhVZk840OKPnoLXQcLH
         bSugmnFTGbPKnrhwaOSsR5EVEJfQLF4oQPjBg6trjzipkSBsuyMmYMzQapXqbukw8iLS
         VZ69Pg3IxBctKGgaQIKeZJDWve42bryd7RYj5kFppBxrEFM940feb7LNos5ZXKVCFLRI
         eHXmLVr2QL3TB+Sm9VHjRA0uZRKKwGnYfe7o12QeMWn56uKwSsEEcDYJaeSF4oWauvYO
         hvoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=my6SYWgNkFEI4drfyD8kjZeU1iIkgJuhbEnGEfifukk=;
        b=gLtnAvX8RIuB8ejzJ0mr/CjIGajfshgbOeMQ7dp4JRefE8cxJpNbLZitYAinFdBzWU
         YLtXD/B9ReQiVvbzy/v0x7FzeWlIfK3xfn9/BEBINemKVAsuM5ADx9g6WS8WnWfkYWU9
         rvwJxWbqbs1pshK4NxmMkXdE+AzV9y9vvK95b3Fye3S+6fqT1xkhiRtobBPCpziHjhlx
         sdZgr++suujHatKlXXG1D+PRYJzbnfDYtoY9rR8QF83zvASMbzrUtNIzgqyp0pAP9qPB
         2YLmceP7uW79WLh1ANIMuCKmsacM7AGULyauJH1iUW1V/I7gl/LUkXjH9xObxiAC7WdO
         AZKA==
X-Gm-Message-State: AOAM530EiXtgbHWg7uKmI3CGFPiiQH9xfJ/CdZY0aHqfH5Dc8AWw5eD+
        LlxgmWO/ql/qrC0S3gCeV5zNm6bmjoc=
X-Google-Smtp-Source: ABdhPJzm/n4T3CRQZO89EPBsx1cbhar8desf3A2C3KY0Bj8NJRMCh2vwWHhwAsT28iMiMlNZaDDzsA==
X-Received: by 2002:a05:6000:186b:: with SMTP id d11mr3252135wri.21.1644071316707;
        Sat, 05 Feb 2022 06:28:36 -0800 (PST)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id f14sm4402422wmq.40.2022.02.05.06.28.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 06:28:36 -0800 (PST)
Date:   Sat, 5 Feb 2022 14:28:34 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/10] 5.4.177-rc1 review
Message-ID: <Yf6Jkpnx4krAxr6F@debian>
References: <20220204091912.329106021@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204091912.329106021@linuxfoundation.org>
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

On Fri, Feb 04, 2022 at 10:20:13AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.177 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 06 Feb 2022 09:19:05 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220121): 65 configs -> no new failure
arm (gcc version 11.2.1 20220121): 107 configs -> no new failure
arm64 (gcc version 11.2.1 20220121): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20220121): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/709


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

