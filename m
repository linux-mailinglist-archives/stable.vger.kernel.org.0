Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01AF66D6ED8
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 23:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236178AbjDDVWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 17:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236314AbjDDVWI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 17:22:08 -0400
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 713744691;
        Tue,  4 Apr 2023 14:22:07 -0700 (PDT)
Received: by mail-oo1-xc29.google.com with SMTP id o15-20020a4ae58f000000b00538c0ec9567so5390715oov.1;
        Tue, 04 Apr 2023 14:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680643327;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xLtXm86nIpV5O0iZuPwpTb/HuHq3oo/rP7oXpg4owkM=;
        b=LCwhAtP1n8BdQUor449EVn6BOH1cKJn11n4bhzyvQ3c/g8nR7cPLJzvQLZZAiR2Lpq
         bz9WfWTf7x9fWxdu30PP2g9PnEbJZKyqmqY+1RH6s09PyFp2diXvN4hs3Yb2eeD7RQC8
         DpeyKvdmk3U1W+6G70P0N3jcjISelHrkKekrsQBLCQv1Gk3K4g4/DRIqipvzusaVTvoR
         5EPL3v0/K2pJfPaxWQwew+l6EweMcP7eWCwvLhIfi9fBx5ERaDBiGT25GA1ZH8Yftn0z
         0ZsBidjGkHNhqg6EOD+cXydVPiJPkKKekSJT8PD8UA/UQEcLqAqghFnDxRbKj3TOusoj
         ZpVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680643327;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xLtXm86nIpV5O0iZuPwpTb/HuHq3oo/rP7oXpg4owkM=;
        b=Wq1xK+4Tfv7KTSEgpaeAC6M0Quaq1ptPOtYlIp6ehEWzpYNylK1ki2JQTsUkAhsUEa
         qygk+4qjIZS6Fuar+9/y1iVO8OD0vTkbwaBaQuN1kr2kCyYnUbthg09zWdEG3GutTG+1
         HnTye9wD3DU3FyfDWvZKScMTwLBOZntAo3GpPImgRWGm42lxgwfTZS2cvwKFWtPpdJgJ
         UTEXF7j/eFOCBZl4R7B3EQ+/lnzP8Gy0SJdkqtj0j4Xd5DNC9Aldc92oX6w1Fm93mb2K
         xzb9C+UeLlpajGc23ouFD4OLuMdbJwtQSdUZPIJvewLpUfD1gmqwXVTJ6sZNmAkLbGkN
         BPUA==
X-Gm-Message-State: AAQBX9f7vsyShbEtINa/Me8Fhg0W0JdTnbcXkxYH3milksaSJhxy3TTV
        g2PmNnJibaOdxbO07gtfQuE=
X-Google-Smtp-Source: AKy350YB41lBiTY3+jKqRDqp6yP0x9B9J+Wif0a86wPc48UhwUI8K4du3u+miOgnH+TEG4JDLP2VVA==
X-Received: by 2002:a4a:45d8:0:b0:53b:5510:958d with SMTP id y207-20020a4a45d8000000b0053b5510958dmr479838ooa.0.1680643326778;
        Tue, 04 Apr 2023 14:22:06 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d11-20020a9d5e0b000000b006a3170fe3efsm4243878oti.27.2023.04.04.14.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 14:22:06 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 4 Apr 2023 14:22:05 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/187] 6.2.10-rc1 review
Message-ID: <d8f3d6cf-e1c7-4f00-a452-1ca945d5a580@roeck-us.net>
References: <20230403140416.015323160@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
X-Spam-Status: No, score=0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 03, 2023 at 04:07:25PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.10 release.
> There are 187 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 520 pass: 520 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
