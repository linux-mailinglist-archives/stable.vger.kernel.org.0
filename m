Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 249C45FA270
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 19:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbiJJRHK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 13:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbiJJRHJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 13:07:09 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C65A18376
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 10:07:06 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id w196so6959597oiw.8
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 10:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4ntCwspxSc8LnMTN9iQjHe9rnrb4f7GqTeok1p/IVIs=;
        b=Z1eFprVKT4JR2lBn3chsr0sIll43RjdzXviSEqySwZ/1DaNZBDpajhGITmLWWAUh7x
         RLdLg3IatsK5kTNtSUJbGHFsKlJRunPoQJfhMMy9eHPiBeMZIQGPNP93K19QBML7Vmue
         7B1oVRWnzyw1eAMCqia+KeU2a12blcGLJuvrQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4ntCwspxSc8LnMTN9iQjHe9rnrb4f7GqTeok1p/IVIs=;
        b=xLWBgLme4XXGDTzAZOHrFV0SllTzQycQEwgNt9xxAlKqBI+JssnVl3GbDVRA1TuucW
         w5vg/JT9jq1c2CNTn1BIcGUx6/qCHUHmB/Jytx+B4q3RFUi82gBtyLIbSU915Yu1te/m
         Rws9O5MHjzvHr8x1rt1JYdUDPvh9urtnddiD3FPeQLGexPyglHnbsBJxbF1oIVlUIwYI
         crb7DraexRaUfR7aAMOX937PsN38ODDj7gqStMQpodNtpUcA3Yqu8w5TCyj8YjA0lOEs
         Dvt9CJT8zXFv+3sY5KapgmnH6FsaaNSoEBAXAc0ZiVJBCSVfHWhPkheUGUuhXeJ7XKaS
         0HvQ==
X-Gm-Message-State: ACrzQf3vTFzirhBtERSWnzUGMWD3G5OaXCPl8nCiCiqZqWGghCq2/X+0
        HocV1Srd3dYiSUsMoV9st+FO3A==
X-Google-Smtp-Source: AMsMyM40pd0T9Fq//cbZ5cuv+ImM5zGJk7FqRm21LC4rjA3W1yhqyc+lnzY4mfR2SQYdN5/7flvWsA==
X-Received: by 2002:a05:6808:1441:b0:350:861c:68a2 with SMTP id x1-20020a056808144100b00350861c68a2mr9744380oiv.204.1665421625260;
        Mon, 10 Oct 2022 10:07:05 -0700 (PDT)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id 190-20020a4a01c7000000b00476989d42ebsm23269oor.8.2022.10.10.10.07.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 10:07:04 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Mon, 10 Oct 2022 12:07:02 -0500
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 6.0 00/17] 6.0.1-rc1 review
Message-ID: <Y0RRNgL0wULzAFJM@fedora64.linuxtx.org>
References: <20221010070330.159911806@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221010070330.159911806@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 10, 2022 at 09:04:23AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.1 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Oct 2022 07:03:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.1-rc1.gz
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
