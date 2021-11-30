Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36AA44633C3
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 13:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241215AbhK3MHi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 07:07:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241212AbhK3MHh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 07:07:37 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83696C061574;
        Tue, 30 Nov 2021 04:04:18 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id v19so14735175plo.7;
        Tue, 30 Nov 2021 04:04:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=bjVpDyjxHskTZYTfM4axp1DnsWXtF9XEukYNPnEOBEs=;
        b=c65utgY9gnMHOEwKrhRPlI5bYOl/Zy6OKNJXH2C0RO80MxYXjQpQVsvEX4lMRphL0I
         xGNEmJZ4lqOoHB0cn1E26Vvd78QEYa/gaMciW2S1It9G5R3gBIv8x3Rv5hf+odxclYSU
         vZpf79IMZT6ORm8sI5LVN3lA6fRRnYPYCEQnBc0dTz3BdOrAl/Se7ec/UAMynM32XNc2
         MWUEcOYZU61rOKSdhZ2T7xtmcxouV7JZeuW6kpr44/EiAXY5M+pwEdW+PQvTzy56kF3s
         izfa+tu8ZSqwrPHjlxNvSoAUjZM7ejYiCklzZTFk8VH2q4P5ZWe2wopIosncnOqx/zx8
         DATw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=bjVpDyjxHskTZYTfM4axp1DnsWXtF9XEukYNPnEOBEs=;
        b=kg/KZlevGflSYfB3Ph1gNwOGHV6PTdBqe/4VFLp8zhcoth5+wH+qFbe94bFKdp1ROV
         oPxx4uCkuqlrPStwFulIHSVVwWXpw/fOCdU74i/6G0zd5TfL2WpnWT8QaQBE8hTGMLcT
         02KLL2dHeWjcC5IOejopVi3T4YH/JvVzHLHZMeZwlpQZ9eAjKWLv+0dtFweoiY4KOF/X
         5kTixYKp1VQqvL0HL/yHzno3r/AEiqdBNAF6jmvnxz57/VKHx9dn7jNlK/Y+O7ay4Dx0
         Sd6SgwLL+M1JB+K5WtKfLQOuXttQyx63mWaWHYX9Vv0Aq8w2Y/9dJe+6gMKfjv2SUnCq
         E3ZA==
X-Gm-Message-State: AOAM530w04a7C+Js5OT+y7JOFarpBpvMW7dbKh1qiAlIkOyryMkcQkbq
        uxve5hVOkNLq5DbupRvNoIV48ENXmDnV+/eSeVA=
X-Google-Smtp-Source: ABdhPJxce92w+RYkbwZbMZnT7baaaqcyNYCS8n+3UgSU/qJKpF6aZP/B1DjzRRGqD7IXkAOVmv7d7Q==
X-Received: by 2002:a17:902:684b:b0:143:84c4:6561 with SMTP id f11-20020a170902684b00b0014384c46561mr66960890pln.33.1638273857440;
        Tue, 30 Nov 2021 04:04:17 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id u17sm11233541pfi.120.2021.11.30.04.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 04:04:16 -0800 (PST)
Message-ID: <61a61340.1c69fb81.4b6a9.cd00@mx.google.com>
Date:   Tue, 30 Nov 2021 04:04:16 -0800 (PST)
X-Google-Original-Date: Tue, 30 Nov 2021 12:04:10 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
Subject: RE: [PATCH 5.10 000/121] 5.10.83-rc1 review
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

On Mon, 29 Nov 2021 19:17:11 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.83 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Dec 2021 18:16:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.83-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.83-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

