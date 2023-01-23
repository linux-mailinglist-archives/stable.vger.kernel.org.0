Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE476779F3
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 12:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbjAWLQT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 06:16:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231714AbjAWLQS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 06:16:18 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7EFC2364D;
        Mon, 23 Jan 2023 03:16:01 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id q8so8686657wmo.5;
        Mon, 23 Jan 2023 03:16:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LVFdM5WgBVSap0quv3MdtxapkYDhzJb23/YwiZONLaw=;
        b=cJcFhfva7fRhhbX3pPyubTH6B/sSVDJIvYzU+8US4pGpmWPIHBfEiVzzpY6abZPAg4
         QrjTz22qBNIhAgyJTH8nLJzfyi5MrFvTvNKFSnXnQF67/dc3JFUCp8ChkvyY5AOeMAYi
         sxbEEVRjFCX2yj8TBCUrhHqFh2/PBuPE7Im01CdbsE/R3qU14a+/OtsMBrfE9Ihe5jq5
         qSO0BOrBvJPBoV+th8u0rZ0xiZ/9uK3UKoXAeGzTBwTGI87aX1KznC8Zy0IqvShUQ/I9
         9X4LNo2cFfdNC0bH9NkKeKtKl3A7vqVq7RxSMIzOJAcyestfMDYaCRPNWajJ2F5cI+ih
         KSkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LVFdM5WgBVSap0quv3MdtxapkYDhzJb23/YwiZONLaw=;
        b=u8/1TI3hd5MUzhLqTS87rADsUhIzWLxKE3PcftcoaWJCBB+x6LdVKkRbCa2NX8ukiD
         tWak+CtTdUuFvWF9wkcZK6Wnnsfs3tzUtefh/eknJfcypTGW9ihFD9dCPy0qACNuiYwF
         ITVRBXzNsV3kE6MAaFhOXPaNv/tBRO/4gH9LdhDz6xoycLuICgUAn1gf6t9pvuBWhFgu
         KWnbUb1UhrMxd6KqhfCja/08TqzbgDJvHcy5coI2FwZPFhLkZe/xVhfuXMDcA7r0v/zJ
         bqDv7Db9KERpvwdZG36+vuhIhLv619G8/jAeFsSU3x4Gb+Giu3X5SeCPvTW81t1ZijuX
         9WUQ==
X-Gm-Message-State: AFqh2kqdO8PSi0qJJmWkmOJIs0X6pBUnWOLoUeAv5J7jqCpRK37PoptW
        RgNkV9McDPMgzZSpvAhodE0kfwQoEGo=
X-Google-Smtp-Source: AMrXdXsnDYueLRl2gA8QhpByjLAWXPeMRC1E+XltFU1wbF+xIpZHVi2daGvYFPWI+rDeKpSOMEvGJg==
X-Received: by 2002:a05:600c:1c9c:b0:3d3:49db:9b25 with SMTP id k28-20020a05600c1c9c00b003d349db9b25mr20457530wms.26.1674472560233;
        Mon, 23 Jan 2023 03:16:00 -0800 (PST)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id c2-20020a05600c0a4200b003daf6e3bc2fsm21865968wmq.1.2023.01.23.03.15.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 03:15:59 -0800 (PST)
Date:   Mon, 23 Jan 2023 11:15:58 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/193] 6.1.8-rc1 review
Message-ID: <Y85sbu82fM3fsrBa@debian>
References: <20230122150246.321043584@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Sun, Jan 22, 2023 at 04:02:09PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.8 release.
> There are 193 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20230113):
mips: 52 configs -> no failure
arm: 100 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/2705
[2]. https://openqa.qa.codethink.co.uk/tests/2700
[3]. https://openqa.qa.codethink.co.uk/tests/2706

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
