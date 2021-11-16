Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0A64539DF
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 20:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239145AbhKPTNo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 14:13:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234139AbhKPTNo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 14:13:44 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C3CC061746;
        Tue, 16 Nov 2021 11:10:47 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id x131so257877pfc.12;
        Tue, 16 Nov 2021 11:10:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=eBSPzzajCdrzYfnx6jBvyKXcVypTe7nZNo4nt7RUwXs=;
        b=SZPHux02xi0uODPX+y5vk5PyOIA6QEbhzEz2Umq3TnhDV8nBwXUHzG6RCR75q7I+eK
         wpkG/NOdFc26UTYuTJ415woz9fk0nvTdcqGsC/H09jjZsBDMBZEsIXOVvGWASyg9gjWD
         o4ibokhSqHjY3ps86+JxFsSL6hgXA5iNHa4/t9gHB17L5YeRwIUjWDry/AJ6oGJZzg4C
         VYBzLG0I+8pNj20896YpYQ7nRZ8lpryRZoGBWQQepIPjO20PlqcZQ5LhWV7DzJqWdxrp
         WWvntvuEnLk32U1BflbT69veRWpYxkhrHhvxpkJreQpCZ20AsVclIlSVFu4Wr1t8Cprc
         L8ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=eBSPzzajCdrzYfnx6jBvyKXcVypTe7nZNo4nt7RUwXs=;
        b=Yl9gU8UramJ5MDHoJtWtIfI52soShCBseSAROTEawqRpyY7BEIRz+W061uNG7m0baf
         8oxr50wS5JaV34sIScqL3Cf4KM21AJHlGlpmKvHjFBI+4jafFtxzi+FXrTM2wDVRqihX
         dWuHE/Xp2vl2r05mQXOAIUWKpbvGvpORJJGuKSooqOUqKSjTAOpTf7y0B1brryE5z3IP
         Qvfey2UhsKrgJni0kOkO1sZfLdUAyo/ITdlhsTxGsisG9cfQsq58tkenpEAswIDaNHLd
         pvenClHaTgKqs0ju+uK4BvxyFyZVzhvU1SUBM2gvWnd2i1T2mwHsZ7StLexZpoHJ79O6
         hzsA==
X-Gm-Message-State: AOAM5304w2ePmwygmv6+sub8NZ1xIH81mW4Y3PEjyPL1Fxomw4R1v96M
        w8RAf9jBVqiTWHjNh6w0RaxG0p8j3Ohsvd6i/60=
X-Google-Smtp-Source: ABdhPJxMVZP+uZOxZsr1lfjvxVAgvUwE1uRsiAq5QdxFT5Spt5YVVgLjFoK6TAiSQq5LL/26M9e4Kg==
X-Received: by 2002:a63:595c:: with SMTP id j28mr929571pgm.350.1637089846417;
        Tue, 16 Nov 2021 11:10:46 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id o9sm9991379pfh.37.2021.11.16.11.10.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 11:10:46 -0800 (PST)
Message-ID: <61940236.1c69fb81.80445.da78@mx.google.com>
Date:   Tue, 16 Nov 2021 11:10:46 -0800 (PST)
X-Google-Original-Date: Tue, 16 Nov 2021 19:10:45 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211116142545.607076484@linuxfoundation.org>
Subject: RE: [PATCH 5.10 000/578] 5.10.80-rc2 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 16 Nov 2021 16:00:53 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.80 release.
> There are 578 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Nov 2021 14:24:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.80-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.80-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

