Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 181842848E3
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 10:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbgJFI6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Oct 2020 04:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726258AbgJFI6e (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Oct 2020 04:58:34 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36026C0613D1
        for <stable@vger.kernel.org>; Tue,  6 Oct 2020 01:58:34 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id 34so7602589pgo.13
        for <stable@vger.kernel.org>; Tue, 06 Oct 2020 01:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=vkRHJyGChLkKIQ9Yu0q2nBBAktc3uVt2UFwIZhntbIA=;
        b=XnapKJdsdd0e28QirBbJ6AkfPrr2NtzaHAoTQPckffkrNaBZVoO+Pw0oI/6ifM3cLC
         L1sygGE4sACX8961MqEFbvdzUsMbPH0P2ySyFrphcJJALAF7VEyk7FbLAD1kC/mOhbBQ
         U1VZrEc5WSBn466WfaoBJOtONn/Zdyn9/Z+oadaZRYXaVQB+COUq8/Qlhf7ETFK0ENNc
         XuZEY9PxhsmZyC2kVzkLWccWiZxUhTYq1Wom/CBPs+62OoBb4BJKiMwBJyund335DhT5
         BluabXVii28wtQ9YVWVpoeVGWxC6qFMPFaJgN/Vcugsi2LNPpZ/BF1t+3yNf9qnXwo0+
         p4RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=vkRHJyGChLkKIQ9Yu0q2nBBAktc3uVt2UFwIZhntbIA=;
        b=OL30TfZnJ5yQDU3lF8H8BrYLkdYZAifWuacVMJD5KclyF0/1VMgeM/Ta5uBZ7iipAJ
         48MZlV2Z77xBrTKS4/0D7rZu6Fk5DiG4bNCTzvVIMa8HaT+jjCrzzk6TmlHVWAykK0el
         05wpE954ACR7yzur/dW4brrcDqXO1/mVvuV8usTbvRmp4yhntflQSr+ARpuzB+BXH0gD
         9Oto/EwOPihfr6sLNf1hOBc0vAOFRA5V0Z5A9dvs+5aQREkoXXI23i1p76tqkJIForL/
         uiZ5NiN/eiq6njbr07WyzFajzR992wd7EAEotpEbEOzUk5HUZNSznExmUmxf5cqpPKxT
         XeWQ==
X-Gm-Message-State: AOAM533UzRi//DGmFx+cUr8Ml/8mNNLjlF2x81HpPepLCO7q/VApfR4Z
        8NusaUdkSdHrNyPbJQZ9fXpT1Q==
X-Google-Smtp-Source: ABdhPJzTp/pVza4zpWwjrb0hHeZFRoopLGsa597KkVaTmVo0/IZboydkcbx5SkWWpM4CtTYCUPLq3Q==
X-Received: by 2002:a62:7e94:0:b029:152:60c3:faaa with SMTP id z142-20020a627e940000b029015260c3faaamr3946593pfc.9.1601974713632;
        Tue, 06 Oct 2020 01:58:33 -0700 (PDT)
Received: from debian ([122.174.189.32])
        by smtp.gmail.com with ESMTPSA id i7sm2622829pfo.208.2020.10.06.01.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 01:58:33 -0700 (PDT)
Message-ID: <862a8f5622f5fd44064347d8ef437806989a310f.camel@rajagiritech.edu.in>
Subject: Re: [PATCH 5.8 00/85] 5.8.14-rc1 review
From:   Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Date:   Tue, 06 Oct 2020 14:28:28 +0530
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2020-10-05 at 17:25 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.8.14 release.
> There are 85 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied,
> please
> let me know.
> 
> Responses should be made by Wed, 07 Oct 2020 14:20:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	
> https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-
> stable-rc.git linux-5.8.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

hello,

compiled and booted 5.8.14-rc1+.
No dmesg regression compared to 5.8.13.

networking (wifi): functional (ok)
ssh : works (ok)
rsync of a large directory over ssh : works (ok)
git clone : functional (ok)
web browser: works (ok)
email: works (ok)
wget: functional (ok).
play audio/video files : functional (ok)

Base Board Information:
Manufacturer: ASUSTeK COMPUTER INC.
Product Name: X507UAR
Version: 1.0       
Serial Number: N0CV1847MB0006040
Asset Tag: ATN12345678901234567
Board is a hosting board
Board is replaceable
Location In Chassis: MIDDLE              
Chassis Handle: 0x0003
Type: Motherboard
Contained Object Handles: 0


-- 
software engineer
rajagiri school of engineering and technology

