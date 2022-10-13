Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87D555FE413
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 23:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbiJMVQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 17:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbiJMVQf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 17:16:35 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A7E5AC52
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 14:16:09 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-1326637be6eso3740148fac.13
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 14:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kYh/T8GIXt/8dRfDL05pkWnOGPY3vN2VxsT9aCfQOzw=;
        b=FxeLJP0dRwDGs1+ifNhEGBvpa8CanRt2dqcRSBDc40Lrwgm0rg43BRsuAlmTCY8E0d
         iFxsMbEfwGdGAmXEjqdS4Qxr0xydStLFo+mrIaKMUeKqiC/+vyHfl9JvNRYvfdrfwbL9
         hadPR9JC+TaJD4qy7QgMIKsllg85/CrbxNZ1Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kYh/T8GIXt/8dRfDL05pkWnOGPY3vN2VxsT9aCfQOzw=;
        b=2tAy94st9IG6VSXosQ1kZNKV1v0MbTz3bBqiKv0mmv09I05KXjMW1VcrQHLGih3R41
         LjYto2nbdsvExsfoeKW6416MUIeIBoEf5p31fYCKn2Lni5vq9F6b5FJZ7Iv525WvhUwV
         sLczKt+4I5+t0nT7KedvHtFxgdLUSn5LnpnEcudQtV7ILfwpRWbuU9l4FOCVhoN2Ordu
         W7Zr4qt8PTQQGi+ah1oBx+8+X1OlgK77xQesoBEH1EjAEDHcz50NJToZvMc3BDBo1viS
         zKFwDORnm5CxNhcXn7q2123Fp0ulQzxNJQPaIstFfzEqHcnsijC9aOf6A6TVJyQzdOsP
         ONrw==
X-Gm-Message-State: ACrzQf3oKTzyFy7SP9khxo/Zw4h/XgbwQl0kK/9eDwpZ1FycBPTRUB0r
        zzSe7zWzvMFb4JSmEy+XBCaZFA==
X-Google-Smtp-Source: AMsMyM6B/9KxtwQkLWFdK44OB7vV2Mz+0dbglQ7RhfGfu3CxaeKaZobo325yEQkLdID6R6+Scsp05w==
X-Received: by 2002:a05:6870:6025:b0:132:6b0b:abc2 with SMTP id t37-20020a056870602500b001326b0babc2mr6294592oaa.177.1665695671149;
        Thu, 13 Oct 2022 14:14:31 -0700 (PDT)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id m67-20020aca3f46000000b00350743ac8eesm318376oia.41.2022.10.13.14.14.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 14:14:30 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Thu, 13 Oct 2022 16:14:28 -0500
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 6.0 00/34] 6.0.2-rc1 review
Message-ID: <Y0h/tAtz0kntPgun@fedora64.linuxtx.org>
References: <20221013175146.507746257@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013175146.507746257@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 13, 2022 at 07:52:38PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.2 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Oct 2022 17:51:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.2-rc1.gz
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
