Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51C636BDCCF
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 00:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbjCPXU3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 19:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjCPXU3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 19:20:29 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0FE19F00;
        Thu, 16 Mar 2023 16:20:28 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id h5so1872660ile.13;
        Thu, 16 Mar 2023 16:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679008827;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kiT7fkFtVF0n3Eq41iQuXy9kvWS5g2M36ZfkL5aFQ4E=;
        b=SjOfvPAcNU2JoOc5taB73FlbEMLaMF/wcBaDJ2xDjr2xAPPZfbn3ZPpDyWzNBOcZ7m
         77b3/ULninLGOEMXibzJG+vykBdar3XKRT+M3KONQZON+DyVv5fHZibT9B8y5MYWWLXt
         kVn6DRLW5XPcLuMZPPRxnKo7cOKYMadKUtYT1CaDY2ZxhzMJ9PEpfdyQgovQMsiUzBmv
         pOXXs6KXXkAxkxj7Mm7jMl+78uvXmqXi6Av323147yM/6Hhe/6U5G+c3iiv2muQlxzif
         84XT3VxK76dm6SE16FXo08reEcmzDbyaGIswWLXFlHz31NAMyhIIWrsvoyNuaG4dPdcX
         7ewQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679008827;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kiT7fkFtVF0n3Eq41iQuXy9kvWS5g2M36ZfkL5aFQ4E=;
        b=Ab17Spig3lWg//KogOa3b4esBkqBuhvg0KlWoJ3RXNSEYO9C88wYNdfkZNhgJENYh0
         z5kqVVdzmygNwsbmGYmt5O60RQ3QRieCMbeDehuCVljS6m7ZB9sXqdLj+oJAJttcMzQb
         VNUYPgodBhG6K2Ve8hWCacswhMW13Px/lb+JI4kXkCFUAaPhLEHPqaulbX1S22tzVshQ
         SfXTVeFyXuP594bCs2DqnaJb0Ba8P7FzYSNFHLI3vVqyQibTzJfQUhztwIeU5q9VtpRt
         2I0Es6DPoG/7IoRFnJy1viugXZvW9fVQqPWkw9w/PYiq9taql2olbcawNM1+Ez4ATeWO
         SVhA==
X-Gm-Message-State: AO0yUKXSqiUTcLrvlcacyjndHdEpF76V0G6kymsVMxuCxzuw5/ygtm7c
        LTgNtjCrRFFEe0C+fBFZP3o=
X-Google-Smtp-Source: AK7set+D8b2k+mSFHjgu55zS+J/u1/lj+YDkGFZsjTYSNGF+c5zs+jS1nHlSWOBjMQOPN1w9VJ70Tw==
X-Received: by 2002:a92:dacb:0:b0:317:99b9:3d1c with SMTP id o11-20020a92dacb000000b0031799b93d1cmr8521841ilq.26.1679008827541;
        Thu, 16 Mar 2023 16:20:27 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 3-20020a921803000000b00322f1b34d92sm171453ily.35.2023.03.16.16.20.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 16:20:27 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 16 Mar 2023 16:20:26 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/140] 6.1.20-rc2 review
Message-ID: <3633184a-6d1f-40ff-99dd-80b5ef17f5a0@roeck-us.net>
References: <20230316083444.336870717@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316083444.336870717@linuxfoundation.org>
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

On Thu, Mar 16, 2023 at 09:50:22AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.20 release.
> There are 140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 516 pass: 516 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
