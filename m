Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12AA7682BBD
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 12:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbjAaLqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 06:46:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbjAaLqR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 06:46:17 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C7C1739;
        Tue, 31 Jan 2023 03:46:16 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id hn2-20020a05600ca38200b003dc5cb96d46so3279761wmb.4;
        Tue, 31 Jan 2023 03:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Vq6HyzZQz16acVezHP9SWCf3XDSeGmT7X5o85bGVUXI=;
        b=O3K4OC2d1o7wCk5uvlizgzHRkdNRc6DX0k1b00MbHp12QYEWZihnzSfFBwZ5Oqcafq
         23Ic2mZD8xDbezEYL92zKoPxPoG70eruVVDuQGJXP7/qpJP9+dwd87wLV++tAnYeXKyE
         6QY2729ZAB9rTFOfmAIdzemrV0iQ1i3ILP3AZwnZjnSGqWam9JFQUByBhIFygL1nz0x8
         R+/CL2n6IcQrRBCWMorLCo7XvKBgMOh1Q37V7kuxgnyt1F74abFNRSOJzq0OD1XkYgco
         ofmqqU0k1KN6YEOY9qeR1uQ1b1Q2jHujoXgh20lGnVJfrdR56WJK2mR5udBR6Ng7XI3k
         Vitg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vq6HyzZQz16acVezHP9SWCf3XDSeGmT7X5o85bGVUXI=;
        b=f5b+t3pPj4cBOztO0fBf04HCdEfZpnYtEKoHih5n+YMelPglB3xh7EBBFNXnNoO+4M
         fHISs5I1akbfAiHvRztSJk/v2sFw4rHOai6OD8tbDi5mYD2Q33QUhBTytVju7/1v07dp
         0sZ/+rEcziIrijX1Sas6rqLSLaQa48wHdK31ERt86UdQuurxRerFuzKIm7zTRvwl1CqS
         UCtnBlr3xC9WnN06fdBuZ6952e+17tKTjaB24qbp3lEB29R442jQpX9ucILELh9Y6kJc
         G36YlQUm/i3zTe1qiUPrfZCWp1nsuVH2ZsWkx8gb5nfS9JTXLcXnlfmk84vAZD230K25
         BhiA==
X-Gm-Message-State: AFqh2koJpMk83q2ZGv6hL9AblG/F8ldD3QPGhyej4YfceecexjIK84A3
        Elg9WivwW1nROPne8jUd5Dth4KfLOWQ=
X-Google-Smtp-Source: AMrXdXu/k4+Ms+DPozoJf6nMbT8xOFk8bn1foiMZqp1W7W3R3cVBaz/D3DJiguCZcxcC1UEggGVkCA==
X-Received: by 2002:a05:600c:255:b0:3da:f9b7:74c7 with SMTP id 21-20020a05600c025500b003daf9b774c7mr52369687wmj.13.1675165574753;
        Tue, 31 Jan 2023 03:46:14 -0800 (PST)
Received: from debian ([2a10:d582:3bb:0:63f8:f640:f53e:dd47])
        by smtp.gmail.com with ESMTPSA id p9-20020a05600c358900b003dc1f466a25sm19860084wmq.25.2023.01.31.03.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 03:46:14 -0800 (PST)
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
X-Google-Original-From: Sudip Mukherjee <sudip@debian>
Date:   Tue, 31 Jan 2023 11:46:12 +0000
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/143] 5.10.166-rc1 review
Message-ID: <Y9j/hCr0GJjyDr1j@debian>
References: <20230130134306.862721518@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
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

On Mon, Jan 30, 2023 at 02:50:57PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.166 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Feb 2023 13:42:39 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20230113):
mips: 63 configs -> no failure
arm: 104 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/2767
[2]. https://openqa.qa.codethink.co.uk/tests/2770


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
