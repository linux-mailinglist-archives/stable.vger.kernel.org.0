Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41F5A682FCF
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 15:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjAaOx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 09:53:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232165AbjAaOx6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 09:53:58 -0500
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B3574EC7;
        Tue, 31 Jan 2023 06:53:57 -0800 (PST)
Received: by mail-oo1-xc33.google.com with SMTP id 123-20020a4a0681000000b004faa9c6f6b9so1624853ooj.11;
        Tue, 31 Jan 2023 06:53:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7HsrtStY3E61z0G/wRXKXXaZ0jNwSSC3qcgpQS+wiRw=;
        b=SDVSEzhYoONdKeSm5dvdX2m1Texi9UE07YqKc+4vysWUVSqGHVnxEMyHc3LfLFFIDH
         szZUm2fOCV2+w34L5JhfyIhraq2MKIKEu9WWLPsEzGEnf7H9Rlr3yznFFqFrmNSc1IhK
         c9NlZQW8V0ZgENTvBkQTf2iCKulaIkPKqmtRTeEvFvQxSoGs3RUBm5WPzeBfkcsni0V/
         0dTIGGk7YDPPl0fBW/t80rC6wy+8UNluiTOGp42ZqSlrLumqCuOXjolWjixgiWO5B6kS
         zJhTqB7l9KxTiKD4yN3DKGRoLUgPbhuDQp+BbLfEz2U8b3aPih1IWmqGWcosuxDkWaTy
         te6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7HsrtStY3E61z0G/wRXKXXaZ0jNwSSC3qcgpQS+wiRw=;
        b=JGawkIP5Eu6456hMXb1rRsWdwvrwusv8fD4aWwNHooiR+iHKlgyfWfmAcIbOjSvw/3
         N9he1PtCyDo5yFbRLpnuwnsbpQHvxfjw0BS2Y35UAk28BRXoX+MfmhbQF9DXYmZe5sLN
         JZIQ6gNxuFC09x3hepFkuXfgsQL2gwci/neTew/705wxJa6HJE+dpll00SNNTMaOy6xe
         N8fmKfCk2Q2WXogm4A5Aaf3MYsj9MghXvkftje8Mng1L55pbioGnqYZAFJzMQJIKkXsD
         msxg2aRC31c4Mro1tNrOyheEZDDit2yEFOiMWSS0UDQOSvr6G+purnvGX8pkwFI3k3qD
         M89Q==
X-Gm-Message-State: AFqh2kokKtcXH+beRh0LJL9kfnyv3ElObKU4dk7vXi3rZ9Y0UHOr5XXO
        gk81asDUL4VO1w09fbkaNUg=
X-Google-Smtp-Source: AMrXdXvjO3xaAvEbXT4YA83iFh+1QmZxRJRGbpG26g0ePhLu/YyDiIMWUoaQx2VnMWKOr0Y6eegoOQ==
X-Received: by 2002:a4a:7512:0:b0:503:a97:f96d with SMTP id j18-20020a4a7512000000b005030a97f96dmr16231343ooc.9.1675176836355;
        Tue, 31 Jan 2023 06:53:56 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e12-20020a4aaacc000000b005177543fafdsm2631030oon.40.2023.01.31.06.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 06:53:55 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 31 Jan 2023 06:53:54 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/306] 6.1.9-rc3 review
Message-ID: <20230131145354.GA3590064@roeck-us.net>
References: <20230131072621.746783417@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131072621.746783417@linuxfoundation.org>
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

On Tue, Jan 31, 2023 at 08:34:09AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.9 release.
> There are 306 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Feb 2023 07:25:23 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 503 pass: 503 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
