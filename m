Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8DDD4B76A7
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 21:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241010AbiBOR31 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 12:29:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242539AbiBOR30 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 12:29:26 -0500
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85514DB4BF
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 09:29:16 -0800 (PST)
Received: by mail-oo1-xc2a.google.com with SMTP id k13-20020a4a948d000000b003172f2f6bdfso23997931ooi.1
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 09:29:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=njbqDSApNZJxgs8QUG+GJc2lRg8kr9qwNOtBMNrAGzk=;
        b=Hg3yzSGM6InbUrgXSxmZSoAqb6uDGrwrZKujnThQlviuJauC0iCJUExwou4yPKJifZ
         obaXgpqa/bOGF9trvOyYCD7dtImTql1VR6ZIOA+/hMzf4kq/egRB6LiVPtv8lXKIgkZE
         iFHUkTRTxq7zD3FxS55Cbd+wzzjO64T2oyNXY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=njbqDSApNZJxgs8QUG+GJc2lRg8kr9qwNOtBMNrAGzk=;
        b=7YfRVNHyCNVSctM6sv3+JZ1J72E9uo0yuYH0E9zexxbKYa35cpWxtWp1nLtIrU+dKT
         JUn83k0rHzWJcKfK5t8NFNJN8hBoZM46Fnv4WYxGjTPduc3w2a/ndwWct1sIp86qeK/N
         ZdL0TN++u3c5i4TQgqyBQ5fvTaDmTBUfDNQ9iIuhpxJJGdpJG/6gsYxBFBS8rK4JGj7U
         IKOkBRzpt7IJ6VAMCZjch6DY9BXpPbQ0vZrSxuVmwwWWppjF4KVjR/SZSt6xeUZUxLLS
         wAA1RjJdUTb18qpNnt/tyIqDQYBaNzYuP3l3bQjYxcid2YbqvQLOu5JVruN9xcDRnVvI
         BqGQ==
X-Gm-Message-State: AOAM533NGqUQIIvJssKVOYieto0n2AqaFqj35GqnrwFhZGw+eBDIHG/8
        egiuMsMnifqbrgL5ihBnijPlig==
X-Google-Smtp-Source: ABdhPJxLqmCfbePiA5dJpCUgGhVla5Ir+4EqFudR5QZ5U0xtkChH47WQL72pJkS5oVWw5+oCNIb4Xw==
X-Received: by 2002:a05:6870:10d8:b0:d0:eaa:951a with SMTP id 24-20020a05687010d800b000d00eaa951amr1779644oar.296.1644946155821;
        Tue, 15 Feb 2022 09:29:15 -0800 (PST)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id s6sm16348289oap.32.2022.02.15.09.29.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 09:29:15 -0800 (PST)
Date:   Tue, 15 Feb 2022 11:29:13 -0600
From:   Justin Forbes <jmforbes@linuxtx.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.16 000/203] 5.16.10-rc1 review
Message-ID: <Ygvi6YWU8QxV1ToD@fedora64.linuxtx.org>
References: <20220214092510.221474733@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 14, 2022 at 10:24:04AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.10 release.
> There are 203 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>

