Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D09D9678E7E
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 03:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbjAXCrh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 21:47:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbjAXCrh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 21:47:37 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F0281BF9;
        Mon, 23 Jan 2023 18:47:36 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id n24-20020a0568301e9800b006865671a9d5so8473043otr.6;
        Mon, 23 Jan 2023 18:47:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YqexzIVMo40KP8hIDZ4Shizea2o4Dbmk1MKMn4wNOtQ=;
        b=UDKZR+Go9AIqlZ4sWp2iWsmkDb5CBx29aKwvioHxza+4UnQK29g+4zpcO87nTwopdj
         sSqa+ekMs9nNtjGYZFoCzQLK7DsMRsuKMMidQgRQ3uCNmxgfyBwVp1iTIo1As7N4fhoV
         /BQEyY6blqChslzEKOfJZU4XPvvHxT9kf47pWBRyl3P9jgenCroGOxIYGndg2d5VR1To
         YNc9A3a/B8rdRpmP0sOaiy9KqJq9H2cKmacYl8+rkQ0C2+R5kAxXDNMlczDzRjh33ChT
         Ru1yfYPJnWlPjbIRy1xYV4cOsJYVEywGolW/d4BJQ3bFmfyJNroExu9tE8i/udMSxTRK
         h4wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YqexzIVMo40KP8hIDZ4Shizea2o4Dbmk1MKMn4wNOtQ=;
        b=tQLf/bx1c7JAg9zuOs3K3svKgNjU9slxjCu4qxKtUgQDExbEIT4ebaATMkW+fYcpGH
         /C1pxVJMqPbavsH96jQj4p5YJwJg+NWcAf4YrezJ5HEMsPW6fD7Hyyv9Ysc6PMg5MBS7
         Hqyt9EQK99FigbvUtrTaC7B3lPYnlOsyUvXFbc/QUo9uWz8soe7K38JveW+cCQ9CBfCX
         o/SEu7nDaDtD3h/d7ePEfYohjx0F6JN/sxChOX4LKprmATCrTtorEEba6Kp9ToFu30Gs
         e2OHGu1mpU/Nxwa84tsB3SwDMVRJRqOv0EDdWUn9JIjGqmmXDX1Iptn7ygmOUxBLtO1q
         tQ7w==
X-Gm-Message-State: AFqh2kp0B8OrbE0qq1DfdFq35pZYGu5Y+3k1BGXeWR2s8BG2mQf0VoEW
        VjtsgU7HTgTjfeGNultEKuA=
X-Google-Smtp-Source: AMrXdXsiCbgg7HVN6mXN7b30bstYk+4L2gna7rlOHKvcnJ4xcDLaSqhzHprZxFED6URZlv57ZqLidQ==
X-Received: by 2002:a05:6830:61c:b0:684:c128:5495 with SMTP id w28-20020a056830061c00b00684c1285495mr12704506oti.10.1674528455878;
        Mon, 23 Jan 2023 18:47:35 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h22-20020a9d6016000000b00670461b8be4sm414495otj.33.2023.01.23.18.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 18:47:35 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 23 Jan 2023 18:47:34 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/37] 4.19.271-rc1 review
Message-ID: <20230124024734.GB1495310@roeck-us.net>
References: <20230122150219.557984692@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230122150219.557984692@linuxfoundation.org>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 22, 2023 at 04:03:57PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.271 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 154 fail: 1
Failed builds:
	i386:tools/perf
Qemu test results:
	total: 426 pass: 426 fail: 0

perf build failure:

util/env.c: In function ‘perf_env__arch’:
cc1: error: function may return address of local variable [-Werror=return-local-addr]
util/env.c:166:17: note: declared here
  166 |  struct utsname uts;
      |                 ^~~

No one to blame but me, for switching the gcc version used to build perf
to gcc 10.3.0 (from 9.4.0). The problem is fixed in the upstream kernel
with commit ebcb9464a2ae3 ("perf env: Do not return pointers to local
variables"). This patch applies to v5.4.y and earlier kernels.

I'll leave it up to you if you want to apply the fix or not; I'll be
happy to work around the problem in my tests otherwise. Either case,

Tested-by: Guenter Roeck <linux@roeck-us.net>

since this is not a new problem.

Thanks,
Guenter
