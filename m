Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 379E7652308
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 15:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbiLTOse (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 09:48:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234170AbiLTOsJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 09:48:09 -0500
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96771C91C;
        Tue, 20 Dec 2022 06:48:08 -0800 (PST)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-1445ca00781so15645348fac.1;
        Tue, 20 Dec 2022 06:48:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QAmoyhOy1ZWXGk11kq9psAaHF5RfeZwq2ZqTGvEITGc=;
        b=Z97/Iz5yfCjram36iGpwvUByoee7z1ahP0JebtKlkXn/sCLsKzSANfyMoXWdIEQm+v
         VEV36hX6dokVyuozmHh91OhWWFw2lnDD+5q+7x8H8fCRn6lHtyLL4JWxJaXHQJnigA94
         UWvwwESxo+WtMBJgiEnHrz7rlj2L38APsVx3q8G4hy2ke257N2f1EYDgv8pwt8siFwcT
         gLRtKR2i3YcZAmN864n8GH2ZwXYEscQzaA6QZjn6AoGfDPjeJ9U/myWDaeCgxwXcFlNt
         YJUBO6ymGP0pqOkLiia6lueXWr618dRyPBuA8pNwPj7oo4oxCeQwuiNMnqGQQvKcP9rT
         0+/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QAmoyhOy1ZWXGk11kq9psAaHF5RfeZwq2ZqTGvEITGc=;
        b=x4Ips1PTXr3D626dlN9OS4jny1HULRonFn65EJPhRch9ZScV/jhq8dS3+jZxYX++CP
         H5sS/j8pyUpi1D4XsOJDa46NNYxH6M/yWDua23E+NQi3gfHcw4U4MlhBGlY7G/3LF9Vi
         9NJSXcIBx8JTWQSYDDhrbZygsv3LYP3o1eppeNX3acaKe6kc5GNO2/DNwzcMLbsMmwVz
         InlbvlndWgvZ64v3RbU47MlU/H7qOXJ9OqtHFWeJ2HacvyGhl+PguHtAohsyEf/MQk3a
         GTDad5iOtiXUrEgn7w5WwztbhqbZgVsE4xnRudZK078Di1b0WvwBd98CNdmApKQuAeNB
         TObA==
X-Gm-Message-State: ANoB5plUa/0juse2gsooHn0b3cFNfIA0OUZVdeLvTXh5Y9TIVNx5n0hG
        twWx3KPP0t3FGkZPvEoXOF8=
X-Google-Smtp-Source: AA0mqf5YS65IjMVg6g5bcWB/qEYNNiwMix7u401YOjWwoQTpLcTkg2QWZnNwE3miWGSdnfjju9dbHQ==
X-Received: by 2002:a05:6870:514d:b0:143:c900:521b with SMTP id z13-20020a056870514d00b00143c900521bmr21959823oak.0.1671547687921;
        Tue, 20 Dec 2022 06:48:07 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q10-20020a056870808a00b00143ae7d4ccesm6034886oab.45.2022.12.20.06.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 06:48:07 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 20 Dec 2022 06:48:06 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/18] 5.10.161-rc1 review
Message-ID: <20221220144806.GB3748047@roeck-us.net>
References: <20221219182940.701087296@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221219182940.701087296@linuxfoundation.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 19, 2022 at 08:24:53PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.161 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 475 pass: 475 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
