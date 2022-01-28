Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7AE34A025C
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 21:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239970AbiA1Uy4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 15:54:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239235AbiA1Uyy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 15:54:54 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42719C061714;
        Fri, 28 Jan 2022 12:54:54 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id a8so7224068pfa.6;
        Fri, 28 Jan 2022 12:54:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=ambBcbrixqPyjx7tGTI/ftZLjdBWOR5lpCRheJYyAlg=;
        b=qYopsGEuAbpYshUNQC/Kclt7bsmDI7MySchY4F8hWYyaXdDdmTHhg3gc2pwATVznGh
         QQSjwPgM8waduTwEpmRQGPPn8h08KXDATqCv4jcy8Y08XVkFZjQ4aw+02T7pmo3nbD7F
         GRveSXMAX2PLB5Qpopz4RAyGEf4sDz7OwK70UInlvEmDOOZYE7hIv9kIhwNjTANr6j+h
         B8tI21Sxm4JvrD5FLr6KOnmnruXHyXAEc7ntELxcWzAlx2p4AeZf549IbRHXeB84ZT5Q
         7i/69ka4zovBnA4RJdQFH4MhiJ/IDqOc9A1STcTwteANrm2wRqd77wfKiC284K+zptED
         ryQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=ambBcbrixqPyjx7tGTI/ftZLjdBWOR5lpCRheJYyAlg=;
        b=ipK3BqSR/cTUvITHsMgITII9sXD4LkvM/q6NNUA71MWalFfVoTvRs1wVEQ4ppRkm29
         k1f6d9spdnAZmctyouLcunj7rw6pwOD6CghqMcqRvao74WWr0owb3B6qC7O3EW6n71eY
         SUmku9Me32nv4elz6A/jeD6zcdNnCFmPz56qpQJUPxTO84J3NXvm8a+tE3Xfl3061e0S
         qq3wtOJJpPuhE5JyL9rUbKTXkZHaw4llr4ycZi/BP0wsHv4+fWKT6I16oAA1BXhNScP0
         nVQFEC1Dk1uvAuJqguz7yzq7XDEQ6EyvzYwPoqk0HtVizEFA8D9I2KdXZF+m/SdkYAqs
         vgsw==
X-Gm-Message-State: AOAM533fxseuj1zm2SD0chbaGoPcSCJSK2/+vf0D1LyH67q6dM4GPLvG
        9aTpfGmPBFLJntjHfGQPuYnV907G4iB4CEpNts0=
X-Google-Smtp-Source: ABdhPJwTd6D5G3WmVfbeTqeJ2r3J1wx9YjIlETFcw7xDa/qlQqTGGujlZOTw4neKQhaFjKuTOP4xMA==
X-Received: by 2002:a63:90c1:: with SMTP id a184mr8011294pge.246.1643403292538;
        Fri, 28 Jan 2022 12:54:52 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id 8sm3218765pji.4.2022.01.28.12.54.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 12:54:51 -0800 (PST)
Message-ID: <61f4581b.1c69fb81.c89a3.94c9@mx.google.com>
Date:   Fri, 28 Jan 2022 12:54:51 -0800 (PST)
X-Google-Original-Date: Fri, 28 Jan 2022 20:54:45 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220127180258.131170405@linuxfoundation.org>
Subject: RE: [PATCH 5.10 0/6] 5.10.95-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 27 Jan 2022 19:09:16 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.95 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.95-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.95-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

