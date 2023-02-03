Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07B5C68A02E
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 18:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232882AbjBCRU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 12:20:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232448AbjBCRUz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 12:20:55 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E29D18B17;
        Fri,  3 Feb 2023 09:20:54 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id k91-20020a9d19e4000000b0068bca1294aaso1550530otk.8;
        Fri, 03 Feb 2023 09:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uBFW9j1K4ay/fyk8RRmaUzvcSTxtx0DjoFk98LpIzlE=;
        b=XzM5UMtU8zsLoV581At1cESCgD8+GnpzJIp0HACv5i81ScqYJts1PlErkyE7gqq2u8
         J0NmRUAVlw5TwxEbdG3JD5Vaz1ZLGUn542R79WI3IrTkeLYxNWUxMDxP7xJiFPRs404J
         a9fXZw8GDYe7/ARsERbsujmQmJ62+Sjt85oJFyOkd5bGEo7sCAQNK8PrfcIMv1XTNy8r
         EmXzjtGwjV2eIXiIjk2WQG7KyHsvblM3XP91hG8f8wHvnc7ta1zhzusI7Eq3uXztko6V
         Mb9pRcKIdrKx0TefqEX7qvYp/JUWPYPhZRr1VfgPnFqgumTSRWjkoVKWhD3Gqmzg/dhq
         wkdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uBFW9j1K4ay/fyk8RRmaUzvcSTxtx0DjoFk98LpIzlE=;
        b=xqBHj40oucqIr/cBWif9qFjVOfAVJtTpUQEsYjn5cVY3A9HzI9MvVl2FUTn2/VEe/9
         xkRiEbkARiGE5CNQezF9yFZ2EAnqO4hToaRkXmWR4CbpWHvJhdnIJCWMY5RZP/2o60oE
         VOUqxcUmOL7+YL6Xi3OucbAZtt5cdAqbIh0LOI5AuFrODLoj3FAUmbPBQmUMVQw0AsIM
         q1KEEW2gEZlGGVHCxgPUWdnq+fiQ83EksnSy5hDXsN44N4yGLaC0vBUM2sfjKsecoo8C
         CRGHLlvFaY9aOUdC2uYowg44ophYH8Q4221xHd2wGvxl1/SIqw8f2kTbCGTmhnXBXzwu
         jcHw==
X-Gm-Message-State: AO0yUKVxL+qV+jg/e5Ei8168oammebBKZQHaF/x48qZTIRj1fKB1PKJ3
        p40FgKU10KVaXMBJENtRkuk=
X-Google-Smtp-Source: AK7set9AidXA4NehQTMKgjQrvwNVW3BN71g3Gde98+Im1ser4mqZiya9kyMtAVXwq04zVvTkZDAD/A==
X-Received: by 2002:a05:6830:26f0:b0:688:4670:e964 with SMTP id m48-20020a05683026f000b006884670e964mr5870691otu.27.1675444853908;
        Fri, 03 Feb 2023 09:20:53 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k5-20020a9d7dc5000000b0068bcb44e7f5sm1297480otn.68.2023.02.03.09.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 09:20:53 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 3 Feb 2023 09:20:52 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/79] 4.19.272-rc2 review
Message-ID: <20230203172052.GC1500930@roeck-us.net>
References: <20230203170324.096985239@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203170324.096985239@linuxfoundation.org>
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

On Fri, Feb 03, 2023 at 06:04:53PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.272 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Feb 2023 17:03:03 +0000.
> Anything received after that time might be too late.
> 

Ah, I was too late. The ia64 problem reported against the 5.4.y
release candidate is seen in here and against v4.14.y as well.

Guenter
