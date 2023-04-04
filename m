Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD116D6ED2
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 23:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbjDDVVK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 17:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235711AbjDDVVJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 17:21:09 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59EAB12F;
        Tue,  4 Apr 2023 14:21:08 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-17ab3a48158so36224938fac.1;
        Tue, 04 Apr 2023 14:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680643267;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4aw6Gxj1ezgrCRCYFxG0UvVBu8kOMvp7xd7jQqy4KvE=;
        b=oM1L2ElAOImE1hhfg2nTa1G+csSaLR/9a4WK80pzz+awU9fcXUvyqT/Ra7lGAxIC4A
         Cw5BGYYSpvLnwSbEQVlT4oE+MMEbHpZBx+5VJJconnGFXjVSupB3959ehmK1/yMrWtk+
         GtBI5r9sOPNbFSTneXsiA//raWATpMsEh0CxW56un3mG74+spume3R9qRl+RuAdlwvel
         cObRqCnpu6MJ9Soch8X8y01WVsj1a8LIIOuJ6XwLYprSg1xDH1fpoa2rzwEJ8I1dwlZK
         SATbjLXWLfu4Om06KClIECroHHZ4OkxPl4ir3tznCzK0Yue0f0RFHjjIHEbF2tdIVMB0
         c5tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680643267;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4aw6Gxj1ezgrCRCYFxG0UvVBu8kOMvp7xd7jQqy4KvE=;
        b=Bqli/KN63QFl7x2/8K6IIDPatAy8hQICEejRybYCtgJ3K8JlouxDJJDEnrO1nO9hHB
         BsPYPQO540MpzqE5amaZ/OfMOs+CRCtQKZRj+29mpcsUydg9vSUAd1xHmidevU17NmAY
         DVI3fRruL34Vix93tKpyt/bfhSaqHjrCsmKNEnnVL4RUDabnGn0w6y08V7PwE/rjEByC
         BywwtLVDeN+0BMfn1rlX0TBqjO6z2RsAJvnhvZOJKCZouzugt0t46PDZ3m1r0m6tCAzB
         TUcPbGtKPAM8S3klV3F29m9tkJNZGE7PSltSzTpDWhH1XWlHyZzCUTg/Tnz19U7k3Fi+
         aVfg==
X-Gm-Message-State: AAQBX9fsViYgRBepRN2nzgOjL0nti3Gb41kiULrYWkT9Ni4tuXsL/zFu
        0mXQ//ddnK7GIRzl4B9oS84=
X-Google-Smtp-Source: AKy350YVuXWW+vkM7HUrHzbjwxSVTX4McBNiJ1Efd7JoFrAVUqwb5Duvu/mnwmt1FK/5a0Y2Qmqq/A==
X-Received: by 2002:a05:6870:658e:b0:17a:a2ba:9032 with SMTP id fp14-20020a056870658e00b0017aa2ba9032mr2514129oab.3.1680643267684;
        Tue, 04 Apr 2023 14:21:07 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id zl20-20020a0568716d9400b0017fea9c156esm5255021oab.18.2023.04.04.14.21.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 14:21:07 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 4 Apr 2023 14:21:06 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/173] 5.10.177-rc1 review
Message-ID: <17f0c9aa-3b87-4621-84d4-bf036671a09d@roeck-us.net>
References: <20230403140414.174516815@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
X-Spam-Status: No, score=0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 03, 2023 at 04:06:55PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.177 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 485 pass: 485 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
