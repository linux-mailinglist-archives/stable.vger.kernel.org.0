Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9AB669708
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 13:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241342AbjAMMc0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 07:32:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241261AbjAMMcG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 07:32:06 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A9DE1CB27;
        Fri, 13 Jan 2023 04:31:02 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id p1-20020a05600c1d8100b003d8c9b191e0so17255845wms.4;
        Fri, 13 Jan 2023 04:31:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lhD1UdTqj8iuVwP6vGidIrXIpnvoDQg/rcDN5jZ5puE=;
        b=YZe90POZyiXSi9ctF3BVQ5n/U/IsC6HgnvfvOuI1ZPiK5hfenl5XL5htj+ysGmBVO7
         ArnP2mZdvXFae2BBbK8vVy9MuBJgHz5v+ABzyTTYjYAAAWheDnfO1vRcqW/j3tEIsauM
         bFzrXpTg+rBaGPKjSecRrse8vRNjpsu8h6ehq1deDQaWVW2R1mDtkvZ1QLVUmUdQKp35
         rZK5PA1JHK2qQKGlteZo+PAW23np+6Ek+HTiATlinhIkwaPNI5XezKrWsK4cpe9Xtraw
         oZoRAk4YSOl1fdRBmXTH2cU3CcRvOKzZ3Mm+0gut+983bpd6iRIPGXp/f6+W1wvjME8a
         MYAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lhD1UdTqj8iuVwP6vGidIrXIpnvoDQg/rcDN5jZ5puE=;
        b=ND9xa+IKje1TDPCfvoP14edzRVZZgDMJvFCtggWc7S1+DJeAPTYNJWNu4jXmhXhWvq
         qDGNWb3YrHAjdNVE66PCUEo1Mn+Mi/RX0thb1QKpoXpfxkPsVkDjLgNVjiyVhrVoiDaj
         HXliiDspjIS/Bq7O8QS8wfeqmh6XQjW9pxQt7ReM23D7VBQB4c/Sg41txkLhPO7AVE2N
         ifBrgeTm+JAUIF0qrI2JnqGlHcgPREnF4Rua5yz/h5Izc4SZr+JP6/HwkiExdMEvQ3Ce
         7mV802Ucs0CcoWuSLLSWDEqWbJAezNuNCs2nCMWMjf7XoEG8q/xq+jP+CGwPK5zGvrLQ
         yajQ==
X-Gm-Message-State: AFqh2kpteE4jQ1ZDAV7ozY3AfFaBl/RWC8Urowzp3xTuJN7FvRsSIWzz
        271eHOwSAfW/e3haQ080G28=
X-Google-Smtp-Source: AMrXdXupbdwZaqdjvV/WL7dNflPEOWjDbEIHBUvVmhulrO8pzyqCkTJJn4PUN/YAHCwrmOea0XEbPg==
X-Received: by 2002:a05:600c:1d20:b0:3d2:2aaf:316 with SMTP id l32-20020a05600c1d2000b003d22aaf0316mr58525914wms.36.1673613060577;
        Fri, 13 Jan 2023 04:31:00 -0800 (PST)
Received: from debian ([2a10:d582:3bb:0:63f8:f640:f53e:dd47])
        by smtp.gmail.com with ESMTPSA id m13-20020adfe94d000000b002714b3d2348sm18910428wrn.25.2023.01.13.04.30.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 04:31:00 -0800 (PST)
Date:   Fri, 13 Jan 2023 12:30:53 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/10] 6.1.6-rc1 review
Message-ID: <Y8FO/VuiRVFzbQ8V@debian>
References: <20230112135326.981869724@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112135326.981869724@linuxfoundation.org>
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

On Thu, Jan 12, 2023 at 02:56:21PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.6 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Jan 2023 13:53:18 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221127):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2630
[2]. https://openqa.qa.codethink.co.uk/tests/2631
[3]. https://openqa.qa.codethink.co.uk/tests/2634

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
