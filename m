Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6113C636E
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 21:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235768AbhGLTRM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 15:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234064AbhGLTRM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 15:17:12 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B33F0C0613DD;
        Mon, 12 Jul 2021 12:14:23 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id y4so17311816pfi.9;
        Mon, 12 Jul 2021 12:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=xQvtw5BQf/3kAW/eFbKgr2fiCmuQc191adEeBK2hePw=;
        b=eNBV0ICwCVFGpcm7tSWWgFWFUHnMCITihDB8RJFuzUxgwXLHQZMit1uHfA5Lg/tW61
         7vxah2zaVY6XmNcrUYcuHlnS9jpG537GhJD/A8MXn3h4MjD7lgYBvgWI+8wIJ2gJ7hRv
         CZ3BgNPBAxzzczLp7nmNq3s+eaJdqqAIWJxiyFbJErNU6Zx95rH0KqVQLYmkps90u9Uw
         8IV63D8CT+uiPMx88EPr4Z1Y+JnPiXZLu1LXPJqoYFPKgeV2Md2MRCTVpQnSZlrTJB/7
         t7K0Hwm635Wasi0UxlZzL1B0gtTRbIuL+BIuRrWyMvcHfIlhDuESn0bv33nto/xnBaYx
         gpIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=xQvtw5BQf/3kAW/eFbKgr2fiCmuQc191adEeBK2hePw=;
        b=AeJ3CXpm3yG5JtFrnAzI96LBsHdDtscW1makSYvPqlW3x0xWd9Ewfh75LE7vR8mpLT
         2ar6fMQV+XwIBVO67V3NkWYxIZ4lR8QNo92hiX9eYUBOykgIOJa5lQ6VBTq+/NsYYP9n
         Ny8ICWfv3WtVD34VbDLHPC+nUF1kC2v82xTznQf1NBqYgwe+xwLFW51cwuDfUl97RJ/X
         1vUpbLQY9YKkLePDTrww4mqxJ+oV/0DKUDuMSaiqGQzLUulzUMNtDPVaNEvJyPokOgLn
         IuxTCjUW2EQCSE9Ha1dBJiqEtRmZi3H0GrzhetVOPEKzWku4vKIvfopuKA/J0M9L5LnI
         6WiA==
X-Gm-Message-State: AOAM530ZbwjXsBSc68Pn1FVrJzvT2ml6BEFQe83H8bOXGO40+FKigGJG
        pN4VZneShwdgIMOLhxSSObKESPBT4IGq2O5k8Uj2Yg==
X-Google-Smtp-Source: ABdhPJyI47PxQeCsPWJFfn42kHk+FxtsGqTM7jkDgp/9QSBK/bzzWo3Qw1WDicFjYQC3GC8ifvFPiQ==
X-Received: by 2002:a63:170b:: with SMTP id x11mr571913pgl.253.1626117262712;
        Mon, 12 Jul 2021 12:14:22 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id j2sm16471589pfi.111.2021.07.12.12.14.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 12:14:22 -0700 (PDT)
Message-ID: <60ec948e.1c69fb81.4148b.0f92@mx.google.com>
Date:   Mon, 12 Jul 2021 12:14:22 -0700 (PDT)
X-Google-Original-Date: Mon, 12 Jul 2021 19:14:16 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
Subject: RE: [PATCH 5.10 000/593] 5.10.50-rc1 review
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

On Mon, 12 Jul 2021 08:02:40 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.50 release.
> There are 593 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jul 2021 06:02:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.50-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.50-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

