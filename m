Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4344225A1
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 13:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbhJELtU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 07:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbhJELtU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 07:49:20 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2873C061749;
        Tue,  5 Oct 2021 04:47:29 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so1795352pjc.3;
        Tue, 05 Oct 2021 04:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=/qeZJF/DjVv0OSOUHcuL+U2oI15czJP1GzeBGDs6VcQ=;
        b=O6eFC0vAgyZZM6iaerOYZSnoxamNfDfW/ZJOjuMLRrED/ffe8J4gBssdRBQm04YWTh
         cAtucQJzmRk2UlmzvHQyoFHQrZJUdqadD0LKcmDTVVNSGI/t1XU438a8PAuGLkd5aRnJ
         DWKch21wXDv9+ELAMHYVOLQs9Cn4mYOZeYJdEVlKsydrU6Ko6IxzgwXRhP2bQNmVRQlS
         JJMlkltTHWgtLW3PSQ4ooC2oNoPdzkBniMT3eCAbKCS5oj6wuVnLIerDRCIipeQSMdVT
         omTETH0WWSALTQ44DkTtOwyPQTVTXNCzITb+s3xgULoHc/TdmVshjZpGOVE/YTSy4GUH
         XrsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=/qeZJF/DjVv0OSOUHcuL+U2oI15czJP1GzeBGDs6VcQ=;
        b=DraLAGq4WlLqbNHg5ridYFfUEjwDe26as3/ZxrFCdSN/FxTCAfB14sVlsF/XeiVgp4
         33M0NC6j2EkMN3nEioH0CABB8fkiLpTDZ09Adl0aD+CifbmmRA8ddQCwcmQDxThm8LwL
         VlyizIPww04KUbySw0re0s69o3iGmBXXqljP3dLntsUbalrdesg3AFWL9cWWEeVvUPOp
         2jy2UzZPWWLhshBAmOWOsFoBqbX3sBnADH5QoCizHqQywwuB74GgBL2WCCpMt7E4wKAj
         Y5q5fs5sDrKpUdYeCm30I4OCPBsJnDDHPfUoaS4jkgvRuY9/U+iQmuL0rELDJ8RUg7mY
         Jj7A==
X-Gm-Message-State: AOAM530Pye6mXq4aK4UbowHFqbe1TdLQ9L1oCOFRyLCbAgLxUbx5PcPG
        eIF0gf3nKbGHBO+CvvhJjI7R95CyNljXzpS9zhI=
X-Google-Smtp-Source: ABdhPJz04XcEduymmQjK02vaOjyUbcmeLHPGK6rgDjyv0xC/JskXuW7wQ8Twk7xouUJKEQtIP9J2yQ==
X-Received: by 2002:a17:90b:17c9:: with SMTP id me9mr3287628pjb.197.1633434448945;
        Tue, 05 Oct 2021 04:47:28 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id s25sm17687561pfm.138.2021.10.05.04.47.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 04:47:28 -0700 (PDT)
Message-ID: <615c3b50.1c69fb81.3a387.4f59@mx.google.com>
Date:   Tue, 05 Oct 2021 04:47:28 -0700 (PDT)
X-Google-Original-Date: Tue, 05 Oct 2021 11:47:22 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211005083301.812942169@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/92] 5.10.71-rc2 review
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

On Tue,  5 Oct 2021 10:38:32 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.71 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Oct 2021 08:32:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.71-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.71-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

