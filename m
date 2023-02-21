Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2D469E465
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 17:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233175AbjBUQUY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 11:20:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233381AbjBUQUX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 11:20:23 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E93B1E1D0;
        Tue, 21 Feb 2023 08:20:22 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id m13so409167ioq.13;
        Tue, 21 Feb 2023 08:20:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WnsUJ3ZfQsjocJ1MNs8mmeQobzQph5HK/7b0ejy/R4k=;
        b=WGWXD4N8ZtnmjS02bYRr2xuqHXSrLva2PFeCtNfQTQOB2r8cpMOMUud/ejKUxKazAE
         q5wyIV1z66FNch+iu2ZAtfh7eFcoK51lRXrZP2k5Lkhq92ixCZbhr3d8F/QZqdJMA14i
         Vh3QVma4J0KA7bSCh2IfYBZ6+40I8a4IEQv/yPoOcnR3/gjLfu2WNgyKtebyLD1NAiJ0
         OH8gJnCmVMYywX9iD2cIAGEInQ7LGGbOgcULpZMEmnXWge0N6tf0f5KvYDLPYQcWrwQ5
         vhTLaCzC2hCBMxEZhxhFJwRn1F7/7zm6NzLrrXK566yfiHgaPP2tHn5rYXbw9SIfzJ6F
         RLYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WnsUJ3ZfQsjocJ1MNs8mmeQobzQph5HK/7b0ejy/R4k=;
        b=kAQOypvLsbuHQupPUwJFFZeIr9zkQC1dnPUQhPqjZF1s0ukLZFOTDPdKrPsy+RKmLK
         qcl7t2zQBZxIL+W8KTgtDxH8uiAMhBoA73NbclP0IWb0jGj83Vp9kWHZaTocthba500O
         rbpzq6yvngyteXKWvwJHZV4qVw/FoDnCHfCo5nfD96ImaMUIK9xk8QeVFXNylxKaEQRc
         ao1K3Pj68pgfXhSPx4FI/dEdqhAdwy+EomZXx4UflSCAJjqvwB31X4noQkXaYs9l20br
         F3I77zLLhC2B4OI31mXu19Sta40u1Xvrc7QqzOPg6xWsjkrwJPjvaJhVu5FXm1iGHrtE
         p6Uw==
X-Gm-Message-State: AO0yUKVlXg9sDergz236UWuFmn4IETYT6b0MTjfte08SDxU46UAcXfmG
        7H/zJHl88WrW5Cy2lnZ44SFmAFPwVHc=
X-Google-Smtp-Source: AK7set8K26MePS+VB0vTMu+AJq8hl4TQYc1y3scWRkcT6GaIaxBWawpivNDabi94udeiuX04mJplEA==
X-Received: by 2002:a5e:880a:0:b0:71e:24ee:5352 with SMTP id l10-20020a5e880a000000b0071e24ee5352mr2645650ioj.17.1676996421620;
        Tue, 21 Feb 2023 08:20:21 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k7-20020a5e8907000000b007192441e5e6sm668397ioj.45.2023.02.21.08.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 08:20:21 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 21 Feb 2023 08:20:20 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/89] 4.19.273-rc1 review
Message-ID: <20230221162020.GB1588041@roeck-us.net>
References: <20230220133553.066768704@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>
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

On Mon, Feb 20, 2023 at 02:34:59PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.273 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 426 pass: 426 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
