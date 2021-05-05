Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80D6137493A
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 22:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234053AbhEEUUK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 16:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234027AbhEEUUJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 16:20:09 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D88DDC061574;
        Wed,  5 May 2021 13:19:12 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id y2so1740227plr.5;
        Wed, 05 May 2021 13:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=V7HoLEH7Lbw/E4Y76i8HPkqPsBjaCkYha/kjurWQVkc=;
        b=lcSLhOLuugm6sTCOH+2r0pJoFvoxYjH7+/vKd1ZjclcSqezzztTT8FeJ+hpKDcpd/1
         7qDCa2kk4bsNlh0ZgFBFAkGQ19oe70OzAiBvG8LnZrCSWERtqcRyCWcPYGFfXGUpkWpA
         CrdSLIhxAxmiEBoP36nbEnGrTzzCx+5hkKyzmfmxZXMdLLk2QWabMjZzsg/EmiiUqH2K
         xPNvcN4cPWBWyQyaTGLALy3jPAofmz74WC+fKw7yVgNzKGckNM+YknSxgbgt4CjAyeEc
         FMywOvpT5zUQJr0IDvp+XcthyNoRI9p8DgT2hP17jMLIo7DtYIWHrsunR4apuP+IeB99
         dgfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=V7HoLEH7Lbw/E4Y76i8HPkqPsBjaCkYha/kjurWQVkc=;
        b=fuHoGQN7uiGEq19oGN8S3eCSYYHHBMqpWq80zxi2D4HU54tbUyw2S1oWz3cSXyQMSq
         qyRBL0QiMfM03lf2AXseAptkzCJNDVOWbvJKSbLrFJocJlm0d7zAyJt3QcvVeJoBYh7D
         fnRoUyRlikOMrTM8tw6XVYbkABS2MSmaazw9EKT6TFpU2xjpYbImyPB5ESlx/NXT/Eyr
         uHNEolOV1foCNN4hrwn7W7sitnThzGdYetWKM26fkQMQCwFK+mUNsswK4RnX7njLNG6N
         mxNacXCvOFrizFsjEeyZkLVRfpg5YobcMPJpqBPu00QvWzKQEkKgUqs5QjWcG/jtNen4
         wp3w==
X-Gm-Message-State: AOAM532/XUGvYQFm7PgzjZGRJJ9Yd/nxCLGFk+8VTK9NqGEU921R6yHp
        d/Om3Mpj0lz4EmEaACnpYE+suqI3uMPaKOpeMb/BbQ==
X-Google-Smtp-Source: ABdhPJzWLOGVa1tUsXi+nDDGIM8gdi7Di6+Iz4zEOH97pjo5n0yI54hiMj40ip4V28A0i4MjiwRtzQ==
X-Received: by 2002:a17:90a:302:: with SMTP id 2mr13803238pje.34.1620245952036;
        Wed, 05 May 2021 13:19:12 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id u18sm95831pfm.4.2021.05.05.13.19.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 13:19:11 -0700 (PDT)
Message-ID: <6092fdbf.1c69fb81.ff5a7.08bd@mx.google.com>
Date:   Wed, 05 May 2021 13:19:11 -0700 (PDT)
X-Google-Original-Date: Wed, 05 May 2021 20:19:09 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210505112326.195493232@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/29] 5.10.35-rc1 review
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

On Wed,  5 May 2021 14:05:03 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.35 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 May 2021 11:23:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.35-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.35-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

