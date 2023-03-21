Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65F8E6C358B
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 16:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbjCUPWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 11:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231707AbjCUPWj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 11:22:39 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E9421C5BA
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 08:22:06 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id w4so8305711plg.9
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 08:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google; t=1679412123;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6gWfY3tQUtshjFSkcAdDgcrIWsk+2YKijGy43yiViKk=;
        b=EaR2/n2qw+RyvpiZ1yCsIKAcdWm37lT15zD0Eq+LIDerzkbF29Qpc8oGElyy34NZPr
         l4Lx4DuvMJaS34Sfd//GyLDGUbt8pzJbBd7BfQqMSiFz8uKPAWKWu+xXZJotGnqfFatR
         lz2shj9+DWX2Gb3sbL/SHkaPBtR/Wxz3SLytg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679412123;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6gWfY3tQUtshjFSkcAdDgcrIWsk+2YKijGy43yiViKk=;
        b=OFoHC6Zs0Ve4vqmn1C1ofOMwunYoaSznVc4tGmLJaUcI84LhAVKbuIan3c4LdJic2m
         bpXDKUxlg/WcQUWJIX9eLp2vLhi662ASWgQVjz+GIRwu4Y4Y1sR9WWr8QASsgaa5YD2C
         76NNPBYz/oN/imNlvjhqYpqLD62/++Oz10J5/CRO4bp29IEflLSF2g5svjAqmoocMuCH
         vfMBl+IbK9TxtcR6gEZSxb7cbOzOwgeiG6LH+hRt6Al+e+Ii8IxYn1/O493eNxWNjUYT
         O/kJLtvk/cy91FpyCpZc2Den82LIMcwTmD0v3vIYnAT9Uvc8/pjpdPygsRk8X4sGvOXZ
         IE2Q==
X-Gm-Message-State: AO0yUKXtVGs8xVNFPAKUJswtAfgQmSlFWxTVBLSADuLzNJfv7OGwLIz6
        PJcB7I6fwU7s3krSvQ5QPduq7Q==
X-Google-Smtp-Source: AK7set+kulQ7RY0SJLZceDsuQd7Xg4twQsw+0TsI21QGPHuCcuIHG7WMoLXcFTf0NePX91aMu6DBLA==
X-Received: by 2002:a17:90b:3a8d:b0:237:ae7c:1594 with SMTP id om13-20020a17090b3a8d00b00237ae7c1594mr247406pjb.8.1679412122531;
        Tue, 21 Mar 2023 08:22:02 -0700 (PDT)
Received: from b1f8169a9f5c (124-148-239-102.tpgi.com.au. [124.148.239.102])
        by smtp.gmail.com with ESMTPSA id s61-20020a17090a69c300b00230cbb4b6e8sm8129524pjj.24.2023.03.21.08.21.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 08:22:01 -0700 (PDT)
Date:   Tue, 21 Mar 2023 15:21:53 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/198] 6.1.21-rc2 review
Message-ID: <20230321152153.GA8@b1f8169a9f5c>
References: <20230321080705.245176209@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321080705.245176209@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 21, 2023 at 09:39:14AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.21 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Mar 2023 08:06:28 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.1.21-rc2 tested.

Run tested on:
- Allwinner H6 (Tanix TX6)
- Intel Alder Lake x86_64 (nuc12 i7-1260P)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- NXP iMX6
- NXP iMX8
- Qualcomm Dragonboard
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro
- Samsung Exynos

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
