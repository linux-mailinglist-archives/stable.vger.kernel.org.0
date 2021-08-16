Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 867C03EDFE9
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 00:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbhHPWZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 18:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232067AbhHPWZi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 18:25:38 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD04C061764;
        Mon, 16 Aug 2021 15:25:06 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id n12so21664507plf.4;
        Mon, 16 Aug 2021 15:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=2RqMzcD4UvwGiyZx79RUBWTeM+cyC6B7TUrlBteeegw=;
        b=BuKRfAITTzvbgx2v6yV/j0wfE38BmqoVuXryxRQ0asMPHjikvlvup+mXzJZBs8N6/I
         /GZGZ6n6l65jVkz8mblmBibLT+Q51Sw2dzkDhM8BDncGkiWuulUroauvSeTgiEyGFvMC
         1fk7cIlhZ16aEudxxOCYnq87oHMvowS33vuyTyBV5ItlQRewAvCcpju4PAowAyQEx/+f
         J/Ca++fRYNvCNLi8wM4bS7rFCQP9Uiy3W7kZEd0rCSanXiyiYMMq/wdPz0azfU8fTuCN
         BHImN6nAUne3FYvlaYhDmuSfzd/y6vlRdDkVF9DrzjBM1SOS6IBW7Le15D69+OG1Sqr4
         lfzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=2RqMzcD4UvwGiyZx79RUBWTeM+cyC6B7TUrlBteeegw=;
        b=CGnDamTJa+jtLR5+KOiSuW/HYwnVYY0/obUkDcj2vx57GcAEKPZgLV/ILZ1oOuVvSk
         FGQpv7GIOYLEmnFpqfaKG3y6KoHkAWiRk71/ExOWT0b4a7rqxFFKy8nFc3sYgeZ9YXwI
         tPIoaeaVqfXRu3liN8dZDV5csTnaqMjtSnrgBvyTwUFikW80eypD/yr/HFK7uGadn8GJ
         6zvz4+8Aa5zR0TWyLs18fk2CdWStKZHhFQU74QnWZC1ano+jIMzsZFK4eCcT1pKVKuh2
         ELSMARVq+fkO6qCspUfUED3EtfIG5oH6rBLWZzmfe9t5YVb0E+MD82jmotO6srX2O833
         CISQ==
X-Gm-Message-State: AOAM533SVFVgHFgJuGFJw8Y2GvoHnT9yFPcPK/cbxYq6iBuqn4ElE2Dd
        bH8mxpg+ZUkB0y0HTWGXZJh0H4GTu4DBpiaY1R4=
X-Google-Smtp-Source: ABdhPJwjn6+ZqwunRb349Qwtid5aLjnGUIseYXeT34LE4XOgyXImdTgtqph6YtY3/Fdwk/wOWjCldg==
X-Received: by 2002:a17:903:22cd:b0:12d:8876:eea7 with SMTP id y13-20020a17090322cd00b0012d8876eea7mr177366plg.75.1629152699390;
        Mon, 16 Aug 2021 15:24:59 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id d13sm165790pfn.136.2021.08.16.15.24.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 15:24:58 -0700 (PDT)
Message-ID: <611ae5ba.1c69fb81.62816.1120@mx.google.com>
Date:   Mon, 16 Aug 2021 15:24:58 -0700 (PDT)
X-Google-Original-Date: Mon, 16 Aug 2021 22:24:52 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210816171414.653076979@linuxfoundation.org>
Subject: RE: [PATCH 5.13 000/153] 5.13.12-rc2 review
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

On Mon, 16 Aug 2021 19:15:09 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.13.12 release.
> There are 153 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Aug 2021 17:13:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.12-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.13.12-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

