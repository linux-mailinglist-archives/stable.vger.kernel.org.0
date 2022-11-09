Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03D2E622245
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 03:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiKICyH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 21:54:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiKICyG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 21:54:06 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A3CC21274;
        Tue,  8 Nov 2022 18:54:05 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id r76so17488296oie.13;
        Tue, 08 Nov 2022 18:54:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rBLZkJy5Pp4Vpzz0NWiO5S2UOJ9yN9uTsYNq/gfnkYI=;
        b=ltk5/S5XHdqjLJtA8myZw111jK4YqHjyFUd66tIyRXCFvddlDxeXY2V6w31crN1exN
         rV8/oVEY3jfko9wObsLjdRwt3WU6IghTUYnYRoQbTibSVZ75bJaUTdwRQGxhbGMKWwrz
         BftVdHlBkj7e7iamWNLd28QVMjXwrgh5qi1VCrOmvQi98xr/KKRydOEgO0vcWFEzrGTs
         LseOhn8Ag9O+vsmRIh5XDV6Kx8mDpjScYBPObe44OQEi9RvAaaS9Y/S/grGi4yMkF/pQ
         1cDeOsa14AgGnc63jOn06mN4fH76S26Bg8/AXi4vuZ07x1egokjB3/wkZBtv8mUFraZe
         Xh4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rBLZkJy5Pp4Vpzz0NWiO5S2UOJ9yN9uTsYNq/gfnkYI=;
        b=x3ICY2Omg2wDYS3x7ZARhRh4vhwncuRkmJCaCj9zCNoQkDKby2ARxYbvu8Ow3SmchG
         HqKlBviq3PJ/+76RMZ244NN0iDH/Q/Y/sam7RsrLcYff3PhGqte3X4zVfag/nURYzmdq
         o3NeJvX9TIyeXsCdCk0HNC8uMoxBBH5N40tkhPhEUkC5/uMl8JJnWgjAvYYU6XH/dtO4
         CHWhVjXyAh/W69TKeAO+3lZymh12Oz8bVdVIiOY6LCcKuYgAbIDErUkrp3siCflbGGy/
         OT7+l3QS3KHO4UIXu5ecFTZwrfZK9kiOa21stddfkDRZaXvVqS0WraPxMNBUiNEpFrYR
         3fCA==
X-Gm-Message-State: ACrzQf2bZJ4LTpBFVgSRe9gSPukMwzazgFeinvgUlcfR6JNpLfD8PCQl
        i6oJzCIXoV5eT9MPQVXFgN8=
X-Google-Smtp-Source: AMsMyM65LdLfRxE0GxhydaG8ObHJgW/wS+FwVUJIoUp1X73R6GIfsgnVSVh3fUuZ+mlbIJsjW9oUJQ==
X-Received: by 2002:aca:b154:0:b0:35a:856:4b88 with SMTP id a81-20020acab154000000b0035a08564b88mr28020880oif.219.1667962444769;
        Tue, 08 Nov 2022 18:54:04 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e1-20020a056830200100b00661b5e95173sm4763329otp.35.2022.11.08.18.54.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 18:54:03 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 8 Nov 2022 18:54:01 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 6.0 000/197] 6.0.8-rc1 review
Message-ID: <20221109025401.GA2033086@roeck-us.net>
References: <20221108133354.787209461@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 08, 2022 at 02:37:18PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.8 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 152 pass: 152 fail: 0
Qemu test results:
	total: 500 pass: 500 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
