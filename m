Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46A06543D7C
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 22:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbiFHUVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 16:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbiFHUVu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 16:21:50 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B68AE2B194
        for <stable@vger.kernel.org>; Wed,  8 Jun 2022 13:21:45 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id q11so14182683oih.10
        for <stable@vger.kernel.org>; Wed, 08 Jun 2022 13:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=58aSr0bRVSi9wdaXddHRZjDCKiPy6uA1abmn5b8dz7M=;
        b=EX+p9N4YOsucKkgCnxfTjea2SyDYngYe/q8EeKnjIOitKGZeJkJsIZPGrCys1i32/Z
         m0y4j6ZeDJK159sDVeMjaCojsufFeTcRtf/nmh/bp4QblGvC6/UZZEgF1WFDHFfM8prU
         pfnhR0D4wdSIigo02hkah4AgTg6WJ3Pr+HH14=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=58aSr0bRVSi9wdaXddHRZjDCKiPy6uA1abmn5b8dz7M=;
        b=QP3+psqNnvtRx8p18aEk0bLhJ3aNJiY6g8WmEoJ8XqxXrEz+mzKroyof6NfegNgTGi
         V2AjK4GtnYQHWyOrIWlXJlEBauWQOnFxiX+PfrsHsTezGXg14TXpYWBT73fB2MD4AVmX
         aFHtA96+GIBcgZ7ySo4g0Kn067de1gc3ESFpmny0tl8dZ8mlFsTs0H0BuSug9AUm6J5X
         5x8ZjgWExohZtJrsBz0tg4NLoX2heuW0frzq8MCu1qOyDh01+q2LWboZaBvhGex9QopH
         ndrSik+1oPd2bsfBeS+QIBir3fNG2gXk4sqqtvPz2onIzxHw9RsVgY9CTZSnbk/N0LqL
         rYCg==
X-Gm-Message-State: AOAM533IH/DDVRDOeonl9/8JIKB6DcgM1095riIF3k4wWCNFjFhnt9G1
        RQAOAtLD7BL+9OEQNbvQl5W8vQ==
X-Google-Smtp-Source: ABdhPJzM2ZEWcrJ3Tl5mzZbXUpabPcMKHlkZYoqIgyJl+cPy5nSBRDAWbY3bX3W84hQxziXuvJqdmA==
X-Received: by 2002:a05:6808:2114:b0:32e:9a0d:ba13 with SMTP id r20-20020a056808211400b0032e9a0dba13mr3456845oiw.268.1654719704715;
        Wed, 08 Jun 2022 13:21:44 -0700 (PDT)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id a30-20020a544e1e000000b00324f24e623fsm11473233oiy.3.2022.06.08.13.21.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 13:21:44 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Wed, 8 Jun 2022 15:21:42 -0500
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 000/879] 5.18.3-rc1 review
Message-ID: <YqEE1rxQ8Xduqttv@fedora64.linuxtx.org>
References: <20220607165002.659942637@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 07, 2022 at 06:51:58PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.3 release.
> There are 879 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Jun 2022 16:48:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
