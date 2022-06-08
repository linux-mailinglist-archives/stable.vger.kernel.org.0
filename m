Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6BFF54401C
	for <lists+stable@lfdr.de>; Thu,  9 Jun 2022 01:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232082AbiFHXtB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 19:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234736AbiFHXtB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 19:49:01 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DCDA2F386;
        Wed,  8 Jun 2022 16:50:50 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id g17-20020a9d6491000000b0060c0f0101ffso3949490otl.7;
        Wed, 08 Jun 2022 16:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4sYh+FYcEerY+vakF3ntDlV6c+4oz+T2KSVYcL4urqg=;
        b=FY7HmsYu4D0pTTtjbPgVB+tDrk3HXRlfyXqllfUe0m+osJqkMYcZLGi6OeLbfx+dhz
         g8YG/RND77cqkH6Btf4s9XoV+dKvBcrEAyuorL/Dx42MohokHueph5FwOwol7lkljtRL
         L57gq1QqfzfkF9cgHjujmV2FKQQ6s4b0U2I/uz0y8lb4Ne/nA0y+nTjGCtiTk+ztR0VY
         zDsKeGHoiwgaTzW2AllhUN7l5YXf1cvafbAw3koHRD/zOZQ8CcTKTvj76O90FMa43kGX
         OOpftFgfRD2F8C9hMdM7KG2x45ILYB1Lzu/IUxoICycSpi09ldlCyRqf3/904lcp1VCH
         tNgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=4sYh+FYcEerY+vakF3ntDlV6c+4oz+T2KSVYcL4urqg=;
        b=RsUowBgAg7PCSLPgarkkrzu5s25PLR3U7cMlKhEwPaQotzurTp+xJ9Te707tj2yllm
         9xQVBR9q5eM/1JwOirXNYqifyGY5+2orcikrGqNEsT2gWdEQesEkbWiQ8pxeMrKaOlxa
         j1bSfgrlfkrLkgFpv4pEmxtxNuxBHNJMYVfyRPKbehDU3kEfppq6dt01XoHOU2QWpjo2
         oUqgF/7nK3VOadbTjwvlhtQ3D1YXdGcQOGHFVkRxRBtft6/mBr8xJHcclsMnJtFlEpD3
         boMZYFFNKDzJmbVikp2jBDVkdrBizfg/ebAbhPdZkiVRTWCaMsrT4L3cSBSV1UjJchrC
         lb1Q==
X-Gm-Message-State: AOAM533RzdXSXLa/cOkKyK+Qu9TXknoosHXbMV6J4Z7XTZz7qvE8Y18O
        H1aHLuDeBSiIXrnOxK7QFyzk/ZC1E0A=
X-Google-Smtp-Source: ABdhPJyE8TdMpPpfsHsXA9zxkz2mg/hrespy5x3Y8bdQpbUhoHv/WC8JMRYPzAU/2wc8yw7PQFdjMQ==
X-Received: by 2002:a05:6830:1d57:b0:60c:1ebc:b4b1 with SMTP id p23-20020a0568301d5700b0060c1ebcb4b1mr1305240oth.255.1654732249616;
        Wed, 08 Jun 2022 16:50:49 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x20-20020a9d6294000000b0060bfdd44d79sm4571486otk.23.2022.06.08.16.50.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 16:50:48 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 8 Jun 2022 16:50:47 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/452] 5.10.121-rc1 review
Message-ID: <20220608235047.GA3924366@roeck-us.net>
References: <20220607164908.521895282@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 07, 2022 at 06:57:37PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.121 release.
> There are 452 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Jun 2022 16:48:02 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 477 pass: 477 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
