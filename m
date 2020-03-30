Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74E8E19820F
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 19:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgC3RRs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 13:17:48 -0400
Received: from mail-lj1-f177.google.com ([209.85.208.177]:45400 "EHLO
        mail-lj1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726981AbgC3RRs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Mar 2020 13:17:48 -0400
Received: by mail-lj1-f177.google.com with SMTP id t17so18984309ljc.12
        for <stable@vger.kernel.org>; Mon, 30 Mar 2020 10:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=5BBm4f47SH280MKWP5Vx5+wHH+PyL05wpqB2N7hI1nc=;
        b=lx3rAQDa1APYCez8z8KO0ob3ZfbCEOJ0iX7osSFrvZFKmYMgK/bhAwcfouzsKYXcLK
         kW5i6L2+y/mpllGx8MuoeKPeURxUdADKH1tarEJjDnMo+y+ojYoa4XGTAHhvRl4Je2Jy
         xqE9pOuKXtL/1ngNwpYp+OQZYyUrWJckk5mRC9t2TvlYUHvjcoD/KNqVqnCmUO7JJz/Q
         i3WS3YsNttqpmIVoP04aG9NdcnOtGGGB6aDhBb+nbxkWpoicJWgVcYUo8ImRzJ1LCgkq
         TYicdsLOMqCISS2ojDH/59xUpE6NYYWfaTjU36YFKshlmxgOPQpCbYKKmAmGuc3Fw+83
         iYjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=5BBm4f47SH280MKWP5Vx5+wHH+PyL05wpqB2N7hI1nc=;
        b=Ap2jhFmmGle9PSyr5M3nKAlqe2DBJJjfrKCXxhgHwN1TFFnti69XTje5vXiYUaBs4K
         IyvkrFAtFnJv8xAn3JphpAcuJBIy6HvLmVbFXlGUqfhaQFjjN8Azg63yiGwgT7v0G2FP
         EeYaRXLaFqeZ7IfMO92ICNAtgY81nWg3lxN15CXHcgpVIxgChStEFtpHemyOLo/rUxvl
         fTw1iqFb6y/4danuzGsH1uQ11urMxxAVqidFedTVGxjYA0VnlRh1TdltVfgcxnVrgaIm
         RX7EdJvW0RIt3Qrh1CNkV0PETf4QCqeFl4PvXWbBSixQ64wtIZJ24pkl5Rq6zXqe2Xtm
         yEow==
X-Gm-Message-State: AGi0PuZG4yhkdaUqi1OeZw4kHv7c/JKZpc6DvHNvGiN+6fKPK5HYuSzu
        np+ZtX4Kg0fCStBaWTUA2ZLQwnCeHezQaHEtHAqq3w==
X-Google-Smtp-Source: APiQypLpbJT/EFuPO1t/YsCMB67WXRIQBFDoLyFTLtQh+eAtoRoFg24lpIncxdrx8Wqu3fhnJC8zwIH6wxMCFzIl8h4=
X-Received: by 2002:a2e:3c08:: with SMTP id j8mr7853898lja.243.1585588666210;
 Mon, 30 Mar 2020 10:17:46 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 30 Mar 2020 22:47:34 +0530
Message-ID: <CA+G9fYsZRZoxTGieMCew7aC0pGCMjqJS0XbFzKgjw317gecEng@mail.gmail.com>
Subject: stable-rc-4.19: arm: dts: sun8i-a83t-tbs-a711: make dtbs failed
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org, megous@megous.com, maxime@cerno.tech
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

 # make -sk KBUILD_BUILD_USER=TuxBuild -C/linux ARCH=arm
CROSS_COMPILE=arm-linux-gnueabihf- HOSTCC=gcc CC="sccache
arm-linux-gnueabihf-gcc" O=build dtbs
 #
 Error: ../arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts:419.38-39 syntax error
 FATAL ERROR: Unable to parse input tree
 make[2]: *** [scripts/Makefile.lib:294:
arch/arm/boot/dts/sun8i-a83t-tbs-a711.dtb] Error 1

ref:
https://gitlab.com/Linaro/lkft/kernel-runs/-/jobs/491105939
