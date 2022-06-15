Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92FAE54C478
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 11:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344514AbiFOJSp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 05:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347862AbiFOJSn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 05:18:43 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9630D1BE9D;
        Wed, 15 Jun 2022 02:18:42 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id s1so14474453wra.9;
        Wed, 15 Jun 2022 02:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hfPRWz/6+mbBhg3uMrSTa4uQzlgE7HRjEzmSGZBqwzs=;
        b=a10ya2bR9Hw+5B9wfwSOtWz8++8Qx1+QGcHA1qacaBV8T7nepPaZ7OxLwOXcW6XriI
         jw8ZxaoUOn2b8MEPGGD5b1gF9X2o0ZJtHE20aQtz5isJQ6IUzTA6L8SK7nllEX6Yxr//
         3fidAfAn8cWZL5mE492WnvOwDuCrSb6M5HPZtiryTb51gTYPEDjGhnQcT12zGP/xjtXO
         L/xXmwn+frIZEOLyAm2SAEKVNhRIFaQ78snLX/aB/OugUJSOkBkBKCe1M2OHWZ+IaBPD
         +BgagbRQ94BAv60nmIfqeziQmnQ0IphEG+MsNNmF2rj/DENZVqqmoZAk3L8CA6jG5LJl
         m87w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hfPRWz/6+mbBhg3uMrSTa4uQzlgE7HRjEzmSGZBqwzs=;
        b=gg1Kh+zQyvUW0MmVPt2chWV3gs6jVnKtnzqjqUDZnQyDyDbUHa1wJWjNEAv0aBIxtC
         OzykW7SRzluc9YLelbLHfZEXeoY5T8uLR3xoCcCJEQ+y3OLajb77PO7bMXjMsEFbEYK7
         cPkdb1nEG9w/GsPThzmj6GnOoKWH/xw+gXONmaqB2pNPOhCg3tBC5MhPLhI0YOo6ZsCt
         Qqq7RqJb+mgcVN7WPFtl1W+DnPkSExOo2dQMZV+xzK77Fv9zERAde6IpdL+SRUofkPhE
         Kb6dD66SPTQ/PsL4ox/VE878lEqE3RwV5+yyAt8tOFPVEevub9l3AkEsiUj+Iy6MDSbu
         wbwA==
X-Gm-Message-State: AJIora/hyyLp8jDqVNEmnw4qWisCirek5J5nr+/iObfiHySis++E9eHW
        elNUzgAwXT4cimsOzxeyeFFO+qSUAq8=
X-Google-Smtp-Source: AGRyM1vpPjOc3KjZW/5OI41y3qgwBQeqaa/Mw5VXqkAVDPSQURuVyyZjJn1b4MmJszzJo+MAGeRR5A==
X-Received: by 2002:a5d:4fc5:0:b0:211:c8fd:3d0f with SMTP id h5-20020a5d4fc5000000b00211c8fd3d0fmr9046485wrw.10.1655284721042;
        Wed, 15 Jun 2022 02:18:41 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id l8-20020a1ced08000000b0039744bd664esm1705440wmh.13.2022.06.15.02.18.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 02:18:40 -0700 (PDT)
Date:   Wed, 15 Jun 2022 10:18:38 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/11] 5.15.48-rc1 review
Message-ID: <Yqmj7kkdooFqIv+V@debian>
References: <20220614183720.512073672@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614183720.512073672@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Jun 14, 2022 at 08:40:29PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.48 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220612):
mips: 62 configs -> no failure
arm: 99 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/1334
[2]. https://openqa.qa.codethink.co.uk/tests/1342
[3]. https://openqa.qa.codethink.co.uk/tests/1341

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

