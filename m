Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B68E54B02F9
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 03:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbiBJCFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 21:05:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234354AbiBJCDg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 21:03:36 -0500
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 059F022515;
        Wed,  9 Feb 2022 17:59:18 -0800 (PST)
Received: by mail-qv1-xf36.google.com with SMTP id h9so3588307qvm.0;
        Wed, 09 Feb 2022 17:59:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=zaHt6sWpY5C0HN1ZyaKoNPi53f6iEdj2wRBDsfELfWU=;
        b=BNSgM9M2q7YKdC1G9xJhJ8sUwBQxKbiTGrTUxwClWh81PssGEn6KXzXhPZ/9/U8ZOX
         t63m+TzEb4+Jm/1BwuWkt8a4uzdfG3jc3uy7H8eGuwy59NlMZcBMz+k1yK0nerUS4QCU
         /nlqtrSuIVjaq7OGltcmH1xkbhzOKyQt2rWpSyf00XSWIc1w2HFU7xylTSGSJlaN6B5n
         XnFHLNstc+yGqwHqIkKGv2MZZxl/f13U0I3xHoETtOp12LP9jt8dUismLkZt6p+fW2Mi
         70jBw6I0jubYrqyCJd7ZqFhM9T+YejOK/PQpfajXsXN/wqqixnylLru/BYB75YHTWZDE
         q07g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=zaHt6sWpY5C0HN1ZyaKoNPi53f6iEdj2wRBDsfELfWU=;
        b=jj3DuASSBy2OOwwle+xz7rMrj3rKRQ49OwzagC83z+FxQs1hsMb4X2bNOwgujPIm0J
         5xxHGyfiSPIaJhwDAdq1aNcXoYCOmxmltth6IMOPVo2t087NoBmTSZH+i0XxFkFv7noX
         PB0gx98WQqBb38n7euoZYh1IglUmtcEzWct25u6Jx4mcXIGU6Gi+cPRdlbSQ/6QeNU6H
         ibTFZ5txp4ldZAxtFeySNf0uUXsEYEM/hgB8tMbtMZHNX1YkYwrQmu/a8vfxQHcgo729
         MFikQXZqEpDwGXA/zD42jznyT83UCFOU86tiey4VCx3cT0DmRYXlTVQybSEr32Fs8xEH
         9lCw==
X-Gm-Message-State: AOAM530v9OPySUmQf5NegEC976sTO4JzQ/eSO51QlHk3LV/Pc7LEJmco
        e5Mm+GhS9QgqIitIT0IVhWl+31bS0vLwcftUfWUzXw==
X-Google-Smtp-Source: ABdhPJzBc4q1624esWkXsa/tTH4nOvT+siaocFtsFfYzTyxgTjF6Yh8Jj3GhJxDceysQPVJfbwYbKA==
X-Received: by 2002:a05:6a00:15cd:: with SMTP id o13mr4983528pfu.54.1644454450294;
        Wed, 09 Feb 2022 16:54:10 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id s6sm15198505pgk.44.2022.02.09.16.54.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 16:54:09 -0800 (PST)
Message-ID: <62046231.1c69fb81.c9820.768b@mx.google.com>
Date:   Wed, 09 Feb 2022 16:54:09 -0800 (PST)
X-Google-Original-Date: Thu, 10 Feb 2022 00:54:02 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220209191249.980911721@linuxfoundation.org>
Subject: RE: [PATCH 5.15 0/5] 5.15.23-rc1 review
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

On Wed,  9 Feb 2022 20:14:25 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.23 release.
> There are 5 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.23-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.15.23-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

