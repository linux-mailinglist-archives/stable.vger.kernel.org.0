Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1A3A57E961
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 23:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236488AbiGVV7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 17:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbiGVV7E (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 17:59:04 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22E0218E;
        Fri, 22 Jul 2022 14:59:03 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id q16so5435648pgq.6;
        Fri, 22 Jul 2022 14:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jZ/ixO28yYwIJ5/L4AiDcfSrXtY5aArPM+MmJUD+1Zk=;
        b=CRpDDm2a2k77Tl4XsCjmvrNG9fHpkEwq6Msq1WMY9yBSYnANGk+73yTdsq0ePYqZMX
         zRE0rS0OcWBESiJpav0kdhd0WrcvIcqIOZReg4IWb2Id4feV4ym3y0BaL5Z5Q03A+y5G
         tYk8az0UC4UE4B1vR17KMrhgfuXYdY1hk1WHJbdMChzcnxB1Wbs4j0MwJR60R+jmsQdo
         NR3PnBL2RhotiRWYMZ3k5r9N6qPBA6tBQ8xC1znNU8+oPjXlQOn2R2zCXO9ky6wEL4tY
         dDgJw+9OsWM1zulMHDOg//1SEJphqbO8R7wx+YVNbRUPal1C5kiOCiB5hWMgJ+w+ZqBL
         d4/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=jZ/ixO28yYwIJ5/L4AiDcfSrXtY5aArPM+MmJUD+1Zk=;
        b=xwnWhr6cGERK/nMlmOFQMJX9amOY57BY6UAzEuIliwZPCiaFxDCTsbQRHELi/LFji6
         ga0bKIIgr2w/fZM7QdI45iYFy9Kn0o+MjCc8OLEe4ZCj1Xj47N0eZ3WzyTeCKctg22WZ
         UkmsQTEUd4OjxZt8RthgiHLZa64MfhuBNG7/B5oYKSOF7vgPZ8yQH2fMyVmNBDXH/XkA
         feys2OoDcqJjDFHk9IbF8XuteYWuoRYbS8CnIfnkN26hbLVsCWH1QF+Zov/9npt/OKq3
         m91mUx/BAbzd2M8LqN8DNUK8kh150YnnmiB5WdTKSFTTXvna2w/sn35nhYOVZDlmvIVu
         Rs+A==
X-Gm-Message-State: AJIora8We/AtKBfeRbp2v1zPqjgR2iTihyrxrkRW7F/TrNwTfrgMcOlq
        lq4Oq87nAB2DaQ6JXRBsfqk=
X-Google-Smtp-Source: AGRyM1vTLB900erkWUhTG4Z2vTbFwvm5J+q2m/lgHdAK0karRxtAtPRe4YguNOgMGgq+j1ky1Qx6Fg==
X-Received: by 2002:a05:6a00:1901:b0:518:916e:4a85 with SMTP id y1-20020a056a00190100b00518916e4a85mr1918764pfi.65.1658527143118;
        Fri, 22 Jul 2022 14:59:03 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 135-20020a63058d000000b0040d75537824sm3852558pgf.86.2022.07.22.14.59.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 14:59:02 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 22 Jul 2022 14:59:01 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/89] 5.15.57-rc1 review
Message-ID: <20220722215901.GA1030798@roeck-us.net>
References: <20220722091133.320803732@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220722091133.320803732@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 22, 2022 at 11:10:34AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.57 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 24 Jul 2022 09:10:51 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
