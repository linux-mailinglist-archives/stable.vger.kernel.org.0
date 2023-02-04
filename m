Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D956968A7A3
	for <lists+stable@lfdr.de>; Sat,  4 Feb 2023 02:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233127AbjBDBtV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 20:49:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232127AbjBDBtU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 20:49:20 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21CFA18B13;
        Fri,  3 Feb 2023 17:49:17 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id r9so5673105oig.12;
        Fri, 03 Feb 2023 17:49:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BBV6tLgmQoWDoh9RhWPBNIn2AEFZuaxRQtRmny5UPaw=;
        b=NpwO/8uDseHlTvg1WKGhfINn3fp+R3EeG7vjwBorjzGvrDqXc6WQTHKMe3NDxQhV9P
         Y1LHVit0tIhDcTlfyGDaZOH/UoYyx2OGIKD3mJOifSMD3wsY0ia7IDNmvbwdVmrmekE1
         8pn/rHQbNWP+pjf/ktqBzL7RsUe5cx9RMFzkg10tl7OqC1Jz8eRNGzDuC8Q4JavdOCWB
         4xeqwCY85clu3Qx9/kTzx/l++z6mTv7E7sWk/mkLytUz4OBZzwgpaaZpNqmMY3K5oL2i
         YRvKqSSxbYY8YFGPJny6KyG/kl7/G3aQvWUmXII0P1oZNCTTicm/kNccGFjgOk+5TYvJ
         NI0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BBV6tLgmQoWDoh9RhWPBNIn2AEFZuaxRQtRmny5UPaw=;
        b=gWvmU/AGjNaO7Q2AxZyzvB1qdIPcV0Wncacwfuw0tXfzEwzRJXd+CfuQyhn7wIHGLr
         zZmzrpfzQRjp/n+3Fqajrez3iSjWNO/6l6kh8J9F3gaJdS8ZHoplh6YhKq3gSFwi6nuZ
         7kF+whMUm0EIJUtaarMhLXNqf76Hv5a/dpE3EJdxRzcuAvU35CmDRuXAlH1fnC+4IXmd
         TvObJNXgWvb4uisWL+f0nMxyyqW12bqopKd7WA8xQuCutnKJv5SEw/tpFBbYX27pvRCh
         7qWown7AYD65DTtBvSWJANHMk21LAJNBmrgg39VucZb7G4IfYyNGVNvRV3blYvsPJb9a
         QUTA==
X-Gm-Message-State: AO0yUKU9bXw6AyHVz/JudOzL9AjxBE4OEBNWT0F0hzq2Cw4o4p0TNLxE
        FdPxIpMNCdeaIEyzNhOWRxc=
X-Google-Smtp-Source: AK7set/c2QtTnBc5ohHtDll1Vj2MBQnTFhgAf2asBDsy6jGuszBs9B1//LH3f2jF8JvTTm2+PNSIuA==
X-Received: by 2002:a54:438d:0:b0:35b:e443:e5d0 with SMTP id u13-20020a54438d000000b0035be443e5d0mr5179070oiv.17.1675475356404;
        Fri, 03 Feb 2023 17:49:16 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s6-20020a0568301e0600b0068bd9a6d644sm1832157otr.23.2023.02.03.17.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 17:49:15 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 3 Feb 2023 17:49:14 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/79] 4.19.272-rc2 review
Message-ID: <20230204014914.GB3089769@roeck-us.net>
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

Build results:
	total: 155 pass: 154 fail: 1
Failed builds:
	ia64:defconfig
Qemu test results:
	total: 426 pass: 426 fail: 0

ia64 build error as already reported.

Guenter
