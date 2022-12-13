Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E363E64AC6E
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 01:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233346AbiLMA1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 19:27:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234253AbiLMA1B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 19:27:01 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 750E51DF3B;
        Mon, 12 Dec 2022 16:25:16 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id s187so12834425oie.10;
        Mon, 12 Dec 2022 16:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IWuVrJKzGO3J7zQt3sC4JYE8vUInb1HG8zTWsM3NQe8=;
        b=SBkdk72gLq8AoIWDYZs8QJzXR+EHvf9SatiYK8fTVceYdaWoVTU24iRpgeLLQdVZ9e
         WR4MuaZcsH8/WaoFbuObzCD3of0ypZCNJEJhwNT8fciuh26ZywN/zNI+FqLt2oN5wHI6
         vuzJWQ2BlzscyXolE+ahGRg8O4QtgAyVKlToZB1pESTJkbnp8aaXR1c6sYu+kL5XrIHI
         aGKW0fTzx60pmudeP+BEc1TtKmlKJoEjJP2eAhCtef7VqVh2graS//aDhuwZYQldEL5m
         8wPNURrMygXWRhMtdPjRCXMRzDe+xs8CU8TB4Mb5WDJedl+Jn9v6JZe1tWCUVdHq2lwg
         0zQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IWuVrJKzGO3J7zQt3sC4JYE8vUInb1HG8zTWsM3NQe8=;
        b=BKXSO7m0r+H1ty0q1j8jrm+dQVwiWwN/Fma9XJygcXOOrQf1PAc6MeCG343zSxasdX
         w/pNaBvhQTafrLMD9krFZbsNFnJq8ai3VDCWUZixs5SmhpkhNjIVv7WRUx8Q4lmZtem6
         RfMT+6vP4l/Upeh8cpepQCiacUY0Tnn2X+F4ZK8qG6uRuywUNx4j78+SlJb2Mk9Dxcui
         oV1H+5/K00ql7eJ7JYXQci9GLuzOvLTKtlszrsM9tfKG+Y886XmqlHxU6zvB69U/I+sm
         CV54E5xObBqO4GPo8qIay/cT2L3dOZtgEsX+2lx90xd+nzY5gbk1SQ+N/7M57IuOEcbz
         gPZQ==
X-Gm-Message-State: ANoB5pmwLiM7yfg8XhQ5difjMwL/k34pi05Zzs2Rj3M4P4Jnl8prLDAT
        Eo8laGZKbYhc82e+QyN/M1U=
X-Google-Smtp-Source: AA0mqf63VNtyZfShWDNsn7KB4a000kJ8JRcGDUS8Up9bCruEntxDSgHEtAR/e143uEslodrt/+WGDw==
X-Received: by 2002:a54:480b:0:b0:35e:8ab3:f213 with SMTP id j11-20020a54480b000000b0035e8ab3f213mr3284248oij.37.1670891115267;
        Mon, 12 Dec 2022 16:25:15 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v19-20020a056808005300b00359ad661d3csm4074983oic.30.2022.12.12.16.25.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 16:25:15 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 12 Dec 2022 16:25:14 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/123] 5.15.83-rc1 review
Message-ID: <20221213002514.GF2375064@roeck-us.net>
References: <20221212130926.811961601@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
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

On Mon, Dec 12, 2022 at 02:16:06PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.83 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
