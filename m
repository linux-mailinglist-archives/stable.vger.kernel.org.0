Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED38462A03
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 02:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236961AbhK3B7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 20:59:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236957AbhK3B7p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 20:59:45 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA2EC061574;
        Mon, 29 Nov 2021 17:56:26 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id y7so13694343plp.0;
        Mon, 29 Nov 2021 17:56:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=SJ51wEfyc+XGHm6YzO5SBmA1qZqIR2PGjA14JSi/dFw=;
        b=Mb1wybldktrwK4FSCUhxLQVWmK2w4mvJJ+716rc72JvNkLx8Hs53hs6epAUbS7FL8u
         qZJ1zSAq/qFw6i+mdL1tQvqckGGXduZtVLvKlGcLbJdYP74K8LxsOiYBcDjPoC12tWdn
         cKae0yunSsSb2ROMc5SCainPsvgYHXkivM6TStiljDo+0SHogNMnj+7fqV+N/B/bQUiF
         OXdk8+xgkVjwMkjXsGhQOFBW3bxh6wiscKLPIW2xkd4yfI8sCV+xb+21SFFuyuz2DeVZ
         ZTyrV5/n6o5g0lVzTzRDknVXNQvIyXGvsXOpTcDtdF1uhbXh6fDHjP1QtCSAP48bfxfN
         F+BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=SJ51wEfyc+XGHm6YzO5SBmA1qZqIR2PGjA14JSi/dFw=;
        b=kNgN3Pp8Zs7LS10Gjl2a7znWa06bdGcseChN4i4b+2ZnlGwmJjrE1mhFFdjI8YWGSK
         sJgVajPHFgneDQLYeGDc3Fx7JLukkjmwCx5QDEQ199fbfek9KG50fRrT2PIAS9yfSiFO
         RjTMsXq/rg6rOTvShT4pBoQ6/ABAm1o4Uzu6E3WhBD5noQ/SzGZFTGTHE/iXde7juL33
         kukIeHbPIHfIGgVh1HJMziEgDcO6htN5CIHGGQL/oT4+X6CMvZ/87A6ysyFYr4xb7dah
         +hrXiFq3+YomyeGFjtp120yAcraqoafHhMRHvAVI+t1i/scYQmvlVgTc3BErkTBddedF
         NdGg==
X-Gm-Message-State: AOAM532zOxVPys09TsiqyX7jo5z58v1o7jF8wxDk89Hv5NPb1uuoaN0E
        2OW6VhVpMduFWOLamiEb8fmC3/B1LTlSHrJEhlY=
X-Google-Smtp-Source: ABdhPJzsgGeQHT3QjkPdc3Sr7T6deItm6yad1I3zQvrjihNNL8LQk0t+F8f//N9YWjrA1cLhkfqlDQ==
X-Received: by 2002:a17:90a:ec05:: with SMTP id l5mr2306980pjy.68.1638237385963;
        Mon, 29 Nov 2021 17:56:25 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id s15sm526894pjs.51.2021.11.29.17.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 17:56:25 -0800 (PST)
Message-ID: <61a584c9.1c69fb81.85d90.2708@mx.google.com>
Date:   Mon, 29 Nov 2021 17:56:25 -0800 (PST)
X-Google-Original-Date: Tue, 30 Nov 2021 01:56:24 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
Subject: RE: [PATCH 5.15 000/179] 5.15.6-rc1 review
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

On Mon, 29 Nov 2021 19:16:34 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.6 release.
> There are 179 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Dec 2021 18:16:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.15.6-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

