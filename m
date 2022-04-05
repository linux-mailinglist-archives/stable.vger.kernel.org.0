Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6784F543D
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 06:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387909AbiDFEqZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 00:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1836201AbiDFAfQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 20:35:16 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD2415FD5;
        Tue,  5 Apr 2022 15:48:11 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id k14so674454pga.0;
        Tue, 05 Apr 2022 15:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=WeQRBWICcKsG6vLLIzWdoFskEeVQFi7P73q8nszBBDA=;
        b=VoBQLxjXKRhgoEZMZJRAv5QfNyAH8MytMo8DwH5Dv9nt8nIWUKqs2NRJ1NU3+nWmP9
         XRUmMxfCwtPIcqQ6NjRZynr+btsYF8TAPnJtxi3rxDWEgVm9guXw60BZUqEwu7Qc5Yrw
         gYUB9ysEURQQra9mLfL8Cwnfm7CjIrB6QcZBDrTBsaUBpdP5u9SsKrXS04Q0A5ItzrRB
         JEFqxbsi2StfGSYfdCVjke+C/BhaCXVUmeFsYFNLY5KmAm6vEifcLHFdCzVPpE/0G8a6
         LFCc9t+FoOI/W06An24Ls81JlW0rp5YEkY1f2CkDQm3LvyGPzrwcUImBRwjFDMdTsAoZ
         knSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=WeQRBWICcKsG6vLLIzWdoFskEeVQFi7P73q8nszBBDA=;
        b=M9qIFi2TRt3cGrnqzrOx8im4/23CSbxh5CPMppsyrINeJxCG4glFjEziDFtj51QDwB
         bDUuIwCBokMpMs7+KpnjoKBXAQjQZL0mRNQE0w415VzRB6q3XIBp0L8QjBQLT8UO2ifo
         VXUn4aHLu937W+lUokVc5YXSQl/uvVd9ly6zK3bTLrMpHinvRLVlwX5IdV2bFYcjpwVM
         /fc0FuTyEJyI/lEgD/8wA3CK8ceeO69yN2k2pgP+51O7W324cNgY8v1Oyzr1ct0IMm25
         WJDlzE800jbjZl3HGzc+iQLDpHozMpLitH+tIqzfZAfPIPscCWtyghRlG28FFCuI+9hy
         w94Q==
X-Gm-Message-State: AOAM530TxsH+bwPZEVRlZje+1Y2bbtt0SeDueXJuKqyK6fuJ0RPJHG7u
        XV09kvx1z+P0lqrZrpg9JtE0E0Xw4KHYQf8B+90=
X-Google-Smtp-Source: ABdhPJw6zyo2FFbI9UTmLozRelgtiDM42JkhZ6L78RnLYYxl6fTZ8LJBFBZI2xZqVlv+Y+q+AKvizw==
X-Received: by 2002:a63:3819:0:b0:398:1338:1118 with SMTP id f25-20020a633819000000b0039813381118mr4523806pga.33.1649198882974;
        Tue, 05 Apr 2022 15:48:02 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id q203-20020a632ad4000000b003987c421eb2sm14434334pgq.34.2022.04.05.15.48.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 15:48:02 -0700 (PDT)
Message-ID: <624cc722.1c69fb81.44fdc.649f@mx.google.com>
Date:   Tue, 05 Apr 2022 15:48:02 -0700 (PDT)
X-Google-Original-Date: Tue, 05 Apr 2022 22:48:00 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
Subject: RE: [PATCH 5.17 0000/1126] 5.17.2-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue,  5 Apr 2022 09:12:27 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.17.2 release.
> There are 1126 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Apr 2022 07:01:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.17.2-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

