Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F05B38C630
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 14:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhEUMGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 08:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhEUMGw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 May 2021 08:06:52 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2F62C061574;
        Fri, 21 May 2021 05:05:25 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id y15so3371266pfn.13;
        Fri, 21 May 2021 05:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=IKvYYqLsxyKEeUsDvRss4bF9+AV45aa77OTQUmH4lC8=;
        b=TyN8xCQ5ia1zkspm9pr6RVukeqMus3yIVRgciDcF+G7WiU6LxkA6eDhAYWCgP7l5+P
         vdsMw7JWNwFQS477nZZ0q3DFO3PHb07opbDhthpVxWXGf0TOfh6zqhRoxtazMIrdhqtl
         8nN0AxWBZjkbtdb/aogwgkW1Cp+aFVIy4agaSRwMDXC3QLnXsb2hYLnE/5cWgaQWYU3a
         KDOAj7aQDDcvD5Qi/Kw16xjXJQTzfL2JNLCVrR1nY4j3i7wiTzBe6lZRFPzCXZqluZir
         il48tCWaEujSGwoRtACg1f8tcTghma/yW4CIJzFwkPMZMl63T+aNrVCs48iGg7QenDpn
         RG0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=IKvYYqLsxyKEeUsDvRss4bF9+AV45aa77OTQUmH4lC8=;
        b=DDaTNcQ5S6rKFcn5cspIi8qcWeU5h6xYZwTxm/uJyD7JweYLbp3nAPP3XRxbnhXNbg
         QXE4Reibz5DD3ULqt7L7IR1Z//pIjWaWNeLpQkbuppC14rJcMlxoUElebFWlmoSIQAS/
         wEtBhUmQGnl0H+hmP29//XTSkhKTriU9nT6s1k/39tmFGruHdsEvPjQt6yngdZALujPR
         7kcizFYhnFLhgNB0m4bHKpR8uWG+vbYq5Ox2qVhQnRw7AvUdAcb/1Q/C0eFJGq40hQwS
         kAnTWM5qKx+WRyaQDQd5DlhIIOenYevd809QYlu01ABfXmb++FidS2rw4a8aiY8Av+sP
         O7jg==
X-Gm-Message-State: AOAM530rqs4wGTeTs1Eu7pC+y9q3Lzq3O7arBQVVDlp95qInPVhlBvVG
        foxv1g/2aq1tYC35mOuiX1N/vw+cLJVlPa4KLbzRAA==
X-Google-Smtp-Source: ABdhPJz7G3bh3cPagwj+TXJS/806MkPr9FwaWLaq4gSH1wCJQP67CeCAB2ShPNoR0kB/a3y7T0aAbg==
X-Received: by 2002:a63:d014:: with SMTP id z20mr9509259pgf.428.1621598724767;
        Fri, 21 May 2021 05:05:24 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id s16sm4566005pga.5.2021.05.21.05.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 05:05:24 -0700 (PDT)
Message-ID: <60a7a204.1c69fb81.c0176.f54f@mx.google.com>
Date:   Fri, 21 May 2021 05:05:24 -0700 (PDT)
X-Google-Original-Date: Fri, 21 May 2021 12:05:22 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210520152240.517446848@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/45] 5.10.39-rc2 review
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

On Thu, 20 May 2021 17:23:18 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.39 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 May 2021 15:22:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.39-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.39-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

