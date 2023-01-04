Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B16A65CB93
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 02:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238403AbjADBix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 20:38:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233540AbjADBiw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 20:38:52 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24BB17593
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 17:38:49 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id i127so28547014oif.8
        for <stable@vger.kernel.org>; Tue, 03 Jan 2023 17:38:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7xiJceqXb+ErDMJE6RdkUBkKlMsVUevK6KQODTOQeNE=;
        b=cgocR8kJne+v2LfJ1M+39Y+WFnzR2RfHzix5JcICL0w/SQ/MTmRVI3zy6as3846VKB
         UJ4rET4SgdihgeQ6qQQUYg2UDjq+ulOE5hBTCCGB3rkZN2Tv+QLCNr5FgjwLvVE7wung
         hSrD9nepNh0YS/faWkd5pRNUkBLvJmu01BWGM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7xiJceqXb+ErDMJE6RdkUBkKlMsVUevK6KQODTOQeNE=;
        b=HQ61hE2riXGK1JDivHVweRiNR0eKktcFYzabtGATFFGR7M3ZnwcuSyvuo8oNZW/67M
         E1zyRd25kcAL1RFB/3/RmWB6NOEqhFpVYJk5CSuLEnspob+n5QmFun+VEMjPMtDzlY+L
         mHr+RikQ3+vQ9Ipnxi8WASVyw10lJQMOmThjd2zJOog/hS51S4CGVpeJrtIQIP+5lfIV
         cTpFtWNnHtYInm3xllYs9npW2rpSP4LM00jMTtyywLhXs4XXavvmAnRtbI5GWUW5V0a7
         MQLhNvbM0BCw89Uc4iChxtRAi5rjd2GMs6imRvn2A0v6Oqs+AotKOQM9lTQwuoIvdw8N
         eIAw==
X-Gm-Message-State: AFqh2kowDKqUZkPWpC0siX2pIdYf5za/NplL610G3QDzg12MJynkqTYD
        OrdwzkAWo2yp0SVBCS94iNBwwA==
X-Google-Smtp-Source: AMrXdXuEEiqD7YMLDJRG/moqiOTIvlKBHn0RDaHAY+4JnbJkovH7LLd3AlM4DQiO8DdZIIDGhE5JhQ==
X-Received: by 2002:a05:6808:2020:b0:35e:46d9:21bf with SMTP id q32-20020a056808202000b0035e46d921bfmr28869075oiw.17.1672796328975;
        Tue, 03 Jan 2023 17:38:48 -0800 (PST)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id b66-20020acab245000000b0035b4b6d1bbfsm13559979oif.28.2023.01.03.17.38.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 17:38:48 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Tue, 3 Jan 2023 19:38:46 -0600
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 00/74] 6.0.17-rc1 review
Message-ID: <Y7TYpnlZWQHBa1Lm@fedora64.linuxtx.org>
References: <20230102110552.061937047@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 02, 2023 at 12:21:33PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.17 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Jan 2023 11:05:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
