Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38DE748F306
	for <lists+stable@lfdr.de>; Sat, 15 Jan 2022 00:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiANXce (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 18:32:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiANXce (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 18:32:34 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037F5C061574;
        Fri, 14 Jan 2022 15:32:30 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id a18so3284413ilq.6;
        Fri, 14 Jan 2022 15:32:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=86UOOD+8jKmAIN2Sw05IJAEDZE16W4XSBxRW5tI83xI=;
        b=EfhH8lzPipJcQTM3iI6WkVch96DC4C3MeV9m1VHug+5Tp5wBpr6bT+3lTcPH3jZ7jN
         7f9HiooVePWPzA3uwO9iI31Iy55jTeHoVO1DS2ai/DGfblC1gKmdx5KTN75yLmMyd4xe
         OR875TOtswy9fh92sVg3xxo1XpCu9XToGe2Gy9UKCp7cUqbObdJ3osrQsa7TEt0zEUEl
         pdEe9woIXw9mqvtGKdv1OZUEKyBG+glUTMrC50ZVIOaNfPGOLIzGsKATH14gMtXUY1v1
         JsqzhNIFxbnQpueXcGAe4zNgymSw03WKYAEn0s842RoSRpYG4zCXHeDy+FooohFDNbpO
         Ho0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=86UOOD+8jKmAIN2Sw05IJAEDZE16W4XSBxRW5tI83xI=;
        b=SZ6aCrbzY4CfnzNqm/k2sUWYUA3GQzbUxrB4b8bdBr5BljeAQMseGAoc2zoFRU3DC0
         OkPBi+IfNbqiNpd/lnqjICy95MQ+vvscFEq2RzgBXJNrypMN11hMAjigxhhHxXCanuRL
         ybyMKtYTgaGs7NgPzCiRxqNzaP2xQn9rz4JmCR1FSr+rkRghv77QkPcURyBwUuasjJ0S
         HOxYAhkdKsLbwgnqZ7UmtaQo5q6ydUi7ei6ndLYX5yhoPHP1kGebgIaRXjdURw5WLXe5
         cxESngccZKat+oUd5t8dDqoZ3ClHe066osS9xy5uGVrcelvgHp72Ismg6TO3XAQnCUQ+
         ZZ4Q==
X-Gm-Message-State: AOAM530aIh1FrS/ebQtbBKru++v3uAgq1adi18AeTlRgDLgHmNQKj+k/
        z2fGd3SYTSVBwrOOJfeWjZrq1lKz2rTGRn9LO08=
X-Google-Smtp-Source: ABdhPJzj1Q13O8ozeYjz/R5TZhta2004hkGVv76WBiy2ghnttKv3DdVTGlZHezr0glIcLJRK73Aj+g==
X-Received: by 2002:a05:6e02:1a24:: with SMTP id g4mr5732307ile.71.1642203149304;
        Fri, 14 Jan 2022 15:32:29 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id h7sm4793816ior.53.2022.01.14.15.32.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 15:32:28 -0800 (PST)
Message-ID: <61e2080c.1c69fb81.3439f.5eaa@mx.google.com>
Date:   Fri, 14 Jan 2022 15:32:28 -0800 (PST)
X-Google-Original-Date: Fri, 14 Jan 2022 23:32:27 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220114081545.158363487@linuxfoundation.org>
Subject: RE: [PATCH 5.15 00/41] 5.15.15-rc1 review
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

On Fri, 14 Jan 2022 09:16:00 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.15 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 16 Jan 2022 08:15:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.15-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.15.15-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

