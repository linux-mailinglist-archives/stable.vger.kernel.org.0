Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0AC510A02
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 22:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350756AbiDZUQO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 16:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354822AbiDZUPq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 16:15:46 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF38D186BC3;
        Tue, 26 Apr 2022 13:12:36 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id q129so21958374oif.4;
        Tue, 26 Apr 2022 13:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zKJpCMBeF8B/PJAJrqhW7UFToVOkF6mADA8ZVZlqfgs=;
        b=owXx4YcdZZ9D4JIWd9XnOlZRpDLuAbEAIEb7POfQ0KtiZdSfxhfbeevpv9EA0ZwV2l
         AwnLC8/s0uOwHEMA7Wajuh6wjPrXhoTZm9dHZyA3S8gYqt3fmiIJ4eeig0aRK+GpMTfo
         Kd/pG8+/yU9GT9Mi6Tyxwx7uuTorXhKQBdRDPKXFPnuDJDq/fkvJnDYkGg8ELGjcW+0Y
         0gqZnvbaLeUey9R3dxlhgSRz1JISMtlfCbocKIhw0zHqhp8vfPfZDsWXfIwAVV5SyNZE
         0UUyKa3joRUivUEjJ7ap0YGOXjfSe39h5qTZEGWbDrO9oRo/62x4O6D2M8K2hriIhEui
         44Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=zKJpCMBeF8B/PJAJrqhW7UFToVOkF6mADA8ZVZlqfgs=;
        b=FMRMrcQ9fDIX0sD4dgYSwh8z8u3cOrL6HLRImEt9ygKbg/+cy6MCxszY0ZIX9fXaCo
         1QU4w8ZDdpNij6ya59NGQm6Al+kEn+4gQ60Qqa8/TJ/4YsIztUiu2jKecpGN5yZQmMhX
         orSOAGpwOeW5TbR4SOSl7wHqJrZ3n+mGdFtsqP1aYERJw/eS9zb3gHPDU0MqXToFAl+Z
         Y8tNIAUCaRHhDObvXy5wkfj1QutGanhZF7r17/KGfyiXZ48GoacNMTOtADYwpAzo/oZr
         mUDDhv7v/ZJrKKfpU4e5g/SzJMf+gMCyfzkWBXC3u+rSOKEmdyR0SicvpwYiUlh6U686
         J4ig==
X-Gm-Message-State: AOAM533A2+3yzxqMyvtKJcGA8H4JE3Td6zYNTAEJ7mWt026tzJwAaXF9
        OW2Wz74Cz5balwcUm9OE2Hc=
X-Google-Smtp-Source: ABdhPJyDeNZjASbyjTlKCDTDmWlLeJIeU+8RDtaSjDXdPAwHXZ5bZKObf/dA+XzEaFqbtcsXqTBWxw==
X-Received: by 2002:aca:1112:0:b0:322:a142:f191 with SMTP id 18-20020aca1112000000b00322a142f191mr15502943oir.41.1651003955371;
        Tue, 26 Apr 2022 13:12:35 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g5-20020a056870340500b000e686d13889sm1170231oah.35.2022.04.26.13.12.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 13:12:34 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 26 Apr 2022 13:12:33 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/62] 5.4.191-rc1 review
Message-ID: <20220426201233.GD4093517@roeck-us.net>
References: <20220426081737.209637816@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426081737.209637816@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 26, 2022 at 10:20:40AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.191 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 449 pass: 449 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
