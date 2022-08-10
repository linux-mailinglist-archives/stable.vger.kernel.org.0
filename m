Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26B2258EE12
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 16:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbiHJOSB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 10:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiHJOSA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 10:18:00 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1544972876
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 07:17:58 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-10cf9f5b500so17975157fac.2
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 07:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=aLbFUlGFxratZwVvqyKdINnxG6W9VgbuCyf2C3Yr28o=;
        b=h9IxXV/InGN8vO34EJQcwzBtQSN+sI8COLJgVOhVYaaXwaxFYA7G1nkVrb0CET53Ul
         14AEsDOlYSsolAEa0PoOdzcKUDEFBFQPIztw86mKYuG9NaCFAsFMi3CnEL3MuNKXdp73
         Tm3ZI+Sep57ObzNbbf6z3yZZjy+wuhSlpzids=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=aLbFUlGFxratZwVvqyKdINnxG6W9VgbuCyf2C3Yr28o=;
        b=xUeGjA6bytNAsam9fsHaAijujvss7+6p+mZ8LU3vUR9/h1fjU1K8wygvRK9cpsQf0F
         DgVwHGsDIel+dN1LKYARltpJZgjLQ5KgrEoCZTrTsMTWS2iUjwVGCBhKxGnd0lELb0Ml
         o72TkY1FYYJVwqz+ArX9zy9QCvyTE7hDpbEFI6EcU2M1JHrAOHhSz5wwqBhCP4htFddd
         KxxJFvCxNCPkJMSvjf/i4g0cjZ00g6MAkFEXBOZqyJuCRxtwDFqIwOghGubj2i+4kR7L
         83CKhYFCb85TzzxS9kJtTkcFC0nkZKmv8wNAa0sNAYfLmrrM+X868mFHJJ04AhYfaWr1
         hI/A==
X-Gm-Message-State: ACgBeo2oPIDKQBO26Nd9EipuBV5tVF0EHCyME2sWufrWEr2g0dVvceJ2
        xgyLY2FmgAb3Vdt5VK9coChqFQ==
X-Google-Smtp-Source: AA6agR4vts6CzXsb3tJwgh/SJvCYXoI1Mq5loN4pZ3z7ZS0hpWeCu5I9XQ4HwjBOowhwtdECj6fAAA==
X-Received: by 2002:a05:6870:c58b:b0:10b:d21d:ad5e with SMTP id ba11-20020a056870c58b00b0010bd21dad5emr1551174oab.287.1660141077335;
        Wed, 10 Aug 2022 07:17:57 -0700 (PDT)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id f63-20020a9d03c5000000b00636dd66b24dsm695583otf.42.2022.08.10.07.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 07:17:56 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Wed, 10 Aug 2022 09:17:54 -0500
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 00/35] 5.18.17-rc1 review
Message-ID: <YvO+Eui1TScY5a3+@fedora64.linuxtx.org>
References: <20220809175515.046484486@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809175515.046484486@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 09, 2022 at 08:00:29PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.17 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Aug 2022 17:55:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.17-rc1.gz
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
