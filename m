Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 313BE6A77DE
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 00:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbjCAXo2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 18:44:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbjCAXoZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 18:44:25 -0500
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41259311DD
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 15:43:51 -0800 (PST)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-172b0ba97b0so16342714fac.4
        for <stable@vger.kernel.org>; Wed, 01 Mar 2023 15:43:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BhW2gSdbv5vMwTEl6x4Xp05rj+HEUyPIAacoa6OCF4k=;
        b=E35mtK6/8sAjkRNZ2FP9bXdH50V4kdqOmdYviyhAKKLQXPgKfuRDUD8W3tIqkjbJoi
         H85Bgi+n442XfOAms5NNRYP001Ea+Z/Qfq84NxUNF6SracCH4YCNxH2AbsPb+mPEClSH
         HTfJBWINAC8ws2m/moqnXhbsKj9KPdqCITrxc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BhW2gSdbv5vMwTEl6x4Xp05rj+HEUyPIAacoa6OCF4k=;
        b=xlpTyZDPmueJJu+DQSmDFJxsfvOpTUL0ck2SisApIZQQBVpm5suHR21buMQXo7DQ+S
         4GZ6u1JjovHyWjIW9qtfYSohWYFrtK7p8+RI2fuD+lx6e6BpsG/ruEnOOjwmrzolTh3B
         D9bdzsGBm7US7eMSkeRPukb+lGfcHXJJYp1Vptx7c0VxLOeLDZ0yViztsojOS5mppcmU
         WtZuN/jgstFKDIF7eI7k04YJO554oJ5tkM+BEybAOt0jPPn5ODu4tDhBHtXX/Z5NX83Z
         oabOU3f7/PzajuidwJBwIUGeIGSzyazVHJDMWVb/vam0NcsTV4YX6UuMlrXLRD5PEy1j
         a7hA==
X-Gm-Message-State: AO0yUKUF6twbPl0TrfXZTtO8ZQqz8h9kIg890DUwYOxkckZtxm1T/zg3
        4kcqZM86rD7WfqtYSdKBPKue3w==
X-Google-Smtp-Source: AK7set+978mFlFhzy0VxpuZmK0F+YK3Y1dBCQ1diTXwLhMGmdVcnUWQuvcCagDvjz5WXR5jfSlsqDA==
X-Received: by 2002:a05:6870:c192:b0:16d:f28d:3094 with SMTP id h18-20020a056870c19200b0016df28d3094mr5022083oad.53.1677714209004;
        Wed, 01 Mar 2023 15:43:29 -0800 (PST)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id b5-20020a05687061c500b001435fe636f2sm4830336oah.53.2023.03.01.15.43.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 15:43:28 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Wed, 1 Mar 2023 17:43:27 -0600
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/42] 6.1.15-rc1 review
Message-ID: <Y//jH9m03FZZzjpD@fedora64.linuxtx.org>
References: <20230301180657.003689969@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 01, 2023 at 07:08:21PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.15 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.15-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
