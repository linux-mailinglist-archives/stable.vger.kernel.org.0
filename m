Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8D0E68E772
	for <lists+stable@lfdr.de>; Wed,  8 Feb 2023 06:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbjBHFV0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Feb 2023 00:21:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjBHFVZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Feb 2023 00:21:25 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F08C29E17;
        Tue,  7 Feb 2023 21:21:24 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id v24-20020a05683011d800b0068bdd29b160so4881714otq.13;
        Tue, 07 Feb 2023 21:21:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HWiqZrImJXEuLHbtd52IqcloEJiiELL3yBzzB//vuKs=;
        b=oFzWTEqVuoYaNCaulckmyLVfy1vLCJESrVmdFRsP6viGFPz5bwc4Vap7pEOr/xA1om
         66EsFf/YBqet5kV/ingNyFmpSsVoGKszKMn/QpknUY5jfCJRPQbIfxUExoSoPlQa0MoA
         +DlGUk2Lrx0voXFsUkQ4Tawk7RsrrxeAKuvV30sHSrAWkggWhrTIbzifsCIGlqWNQxm/
         bdoOYPeVL21aOKm6Z4BhG+qr4n5Rg6Kx8icMYr6zDx3kysTxeLxiSbDumBYqe1+k6V6C
         nyl8HrPEld6ZQz/QBHzpY7KZUUPD9+K2buEqFb3sNHDg2nTrOw1WQ98YP2vMDXy5pgnP
         feWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HWiqZrImJXEuLHbtd52IqcloEJiiELL3yBzzB//vuKs=;
        b=M/RBl/CAY4m+B7RIEaUwYscXeEwcSu1eiBQvuaGIpK7UDGGbghTgWV4WekUAadw5yF
         1wBqnFuYPPdKCIOKGi9l7wFoZpjn/XDP1NKNNh2NW637cSDHBBNZWuCvPZslYydj4wtI
         dudKOsaHs+mOGHMDAxyaWUKXJeh6t4gohbD3tXOnYAnL4FqShelh1BJNwqcoKkXyejhl
         ytycvDGZ27+UouVnwzwfKpaoARc9ZLDjA2U8db8hGCNpYAzBP2WO5pihZMf5Los1RXau
         PTo3bg+ijGX/sb4IJLzaz9xPmcyDUyRMCtGCZZ3LywnRz34H91YK2G9c3mSnt5QXvdG9
         bt2Q==
X-Gm-Message-State: AO0yUKX4ldlG8J76MuPCQsQQnlLt2D2Mz65Dbf0hIn8YqfqOUpkl2EfT
        JHSuqhG0LHI7CJuhldXieUk=
X-Google-Smtp-Source: AK7set98deWCt/leTm0NgjpKMk/+3LSkE6y9uuuda8BdpPD8vxLgAFk4bMmRrZdbUJtm7OeZ+Xhdyg==
X-Received: by 2002:a9d:758c:0:b0:68d:b390:e6e7 with SMTP id s12-20020a9d758c000000b0068db390e6e7mr1814624otk.16.1675833683759;
        Tue, 07 Feb 2023 21:21:23 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h13-20020a9d6f8d000000b0068657984c22sm7589039otq.32.2023.02.07.21.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 21:21:22 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 7 Feb 2023 21:21:21 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/120] 5.15.93-rc1 review
Message-ID: <20230208052121.GA3509133@roeck-us.net>
References: <20230207125618.699726054@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
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

On Tue, Feb 07, 2023 at 01:56:11PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.93 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Feb 2023 12:55:54 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 492 pass: 492 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
