Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 030D4431F4B
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 16:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbhJROTQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbhJROTM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 10:19:12 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A581C072477
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 07:04:10 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 5so40951705edw.7
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 07:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=0E8olpVuSZ+ptLyRM4c9kXpCgTo08CyV1Gik+ccxK8Q=;
        b=OAM3sNetluUSN+ZXtPOfvehMdOJbbNh8E6w3Ry94IGVxPd0omR4tjhMRTRsoqZHUWv
         rxsaOScA/PF9iZ1PwHBXw/nf9BelvIMhHXkM6xmbTkFa+PJNnlgx8TLHCiAorrJo5Tdz
         bwCHCP8kHwgUXp+49PbymAjgCPiBhe86viUUtn1PLWmCPWKFMcqZvleobyVwMD4PWu84
         oIAjMrx+9tYvCrl9D5VXSDNrZZSm1+mTZFeeg4iCKTSVFAB07sKv6VuE32YHrdg9Md0U
         l/dQDj4Yu71gShHFpVjcPUYMySIqWSFC16VmiSDUPKXRpt6BsVOqYhwBNOwqMvcWtw4Q
         sG0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=0E8olpVuSZ+ptLyRM4c9kXpCgTo08CyV1Gik+ccxK8Q=;
        b=IVio57YdGXXcS1VWXK8k6vVsK4JAKeW9kW7ssC7k2Gx+ocU12LLp0QV/Y/3YGFeA/d
         734qZlHzIsmi6V3GmhEmPZGMyWzAwPMPX8SXbjMu8Y/CVLGM5j06G2THlUb6vwejfIO5
         3bMBbylCJ8wBGCPh9ok4HdsTjI/nfbeUf0EmP1NcX2ncA4/2tqL2H97FaqXW343vUtv+
         4ZpbMkRZVyZRcjeE+mRmWPhyVtTMPkjZ2lvv5tP/xaGlIAJBg8kurZ/wyAMzEUcqoyhw
         n8Up8AN9K6Yb2u0OqORbNyU188GS6f0to0O4YAH2x1MxKL0wYPykoxIlN1JJvmpm9a9R
         ddaQ==
X-Gm-Message-State: AOAM532Rw5kvUtohIvxZmasU3YLYszIWhLicv0zliS0fezV9szLLlVQL
        101/68rMiEf0amNVmp9vWumqGJJSTZJzmpoExVm8Z6mozjfjXQ==
X-Google-Smtp-Source: ABdhPJxVuRu2Z1fK8N7CfkNeKnIWrUqElja5nWSdxBUpwa8YekKdBed7ofk1v9MZUctNEkSvc5XQkju4uHDYVZdTuG8=
X-Received: by 2002:a17:906:318b:: with SMTP id 11mr30057933ejy.493.1634565658763;
 Mon, 18 Oct 2021 07:00:58 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 18 Oct 2021 19:30:47 +0530
Message-ID: <CA+G9fYusztaOSJJxr5WuGOueDBaAxmerU99FSjh4Pf6JOFOQfg@mail.gmail.com>
Subject: Queues: mdp5_crtc.c:1058:31: error: 'mdp5_crtc_get_vblank_counter'
 undeclared here (not in a function); did you mean 'mdp5_crtc_vblank_on'?
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Following build errors noticed while building Linux stable rc queue
with gcc-11 for arm and arm64 architecture.
  - 5.4.154 gcc-11 arm FAILED
  - 5.4.154 gcc-11 arm64 FAILED
  - 4.19.212 gcc-11 arm FAILED
  - 4.19.212 gcc-11 arm64 FAILED

drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c:1058:31: error:
'mdp5_crtc_get_vblank_counter' undeclared here (not in a function);
did you mean 'mdp5_crtc_vblank_on'?
 1058 |         .get_vblank_counter = mdp5_crtc_get_vblank_counter,
      |                               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
      |                               mdp5_crtc_vblank_on
drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c:1059:27: error:
'msm_crtc_enable_vblank' undeclared here (not in a function); did you
mean 'drm_crtc_handle_vblank'?
 1059 |         .enable_vblank  = msm_crtc_enable_vblank,
      |                           ^~~~~~~~~~~~~~~~~~~~~~
      |                           drm_crtc_handle_vblank
drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c:1060:27: error:
'msm_crtc_disable_vblank' undeclared here (not in a function); did you
mean 'mdp5_disable_vblank'?
 1060 |         .disable_vblank = msm_crtc_disable_vblank,
      |                           ^~~~~~~~~~~~~~~~~~~~~~~
      |                           mdp5_disable_vblank
drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c:1061:10: error: 'const
struct drm_crtc_funcs' has no member named 'get_vblank_timestamp'
 1061 |         .get_vblank_timestamp =
drm_crtc_vblank_helper_get_vblank_timestamp,
      |          ^~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c:1061:33: error:
'drm_crtc_vblank_helper_get_vblank_timestamp' undeclared here (not in
a function)
 1061 |         .get_vblank_timestamp =
drm_crtc_vblank_helper_get_vblank_timestamp,
      |
^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c:1061:33: warning: excess
elements in struct initializer
drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c:1061:33: note: (near
initialization for 'mdp5_crtc_no_lm_cursor_funcs')
make[5]: *** [scripts/Makefile.build:262:
drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.o] Error 1
make[5]: Target '__build' not remade because of errors.
make[4]: *** [scripts/Makefile.build:497: drivers/gpu/drm/msm] Error 2
make[4]: Target '__build' not remade because of errors.
make[3]: *** [scripts/Makefile.build:497: drivers/gpu/drm] Error 2
make[3]: Target '__build' not remade because of errors.
make[2]: *** [scripts/Makefile.build:497: drivers/gpu] Error 2
make[2]: Target '__build' not remade because of errors.
make[1]: *** [Makefile:1734: drivers] Error 2
make[1]: Target '_all' not remade because of errors.
make: *** [Makefile:179: sub-make] Error 2


Build config:
https://builds.tuxbuild.com/1zgK0LewhdaH7jb2PYiEaTFPgT9/config

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>


steps to reproduce:
https://builds.tuxbuild.com/1zgK0LewhdaH7jb2PYiEaTFPgT9/tuxmake_reproducer.sh

--
Linaro LKFT
https://lkft.linaro.org
