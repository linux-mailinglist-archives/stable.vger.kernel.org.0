Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 700E65528B0
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 02:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242262AbiFUArE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 20:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbiFUArD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 20:47:03 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5EA711165;
        Mon, 20 Jun 2022 17:47:02 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id z14so11682451pgh.0;
        Mon, 20 Jun 2022 17:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VSbIvxEhc1TBP4Z30ISo78vhzBQQhL5q8+ALPQQm/F0=;
        b=Kdpee1dp4Hphgiq0ZI8H6P9D311w6fs2MGoe4138qDquoM8e4gMj/f3j+OONdE+iCl
         8K+JrofMgb6QJ99A551gT4mfL1gjwjD69woKxewj8y/rAFzXQ9GL8yrhv3duKmt1CQsP
         eUFexHKthm2Pt+h//wGUzIGWo5e4kDoOR9713u4B/FiuDnq/IL8PU4kEvuD9SFxspft6
         6sANVOsHqG+ioJRS5WbMMTey2n2pTStwhEkGREq+VTU+h3miIb0n5A6J45mJIaM8396X
         cOrhheGF49OcQuXVZ9rJ/Pf/f0Xp6rjpMT5w5yXK6qX+xfISXJ+EgoY3iIt9M7BVL7J+
         +NwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=VSbIvxEhc1TBP4Z30ISo78vhzBQQhL5q8+ALPQQm/F0=;
        b=c97IcB7PHfwTpht5ZyTHTXmiaqmz8rRXJbwSO1faPUYqHF7yrtsToaxdFKVmjmarQ/
         azOg8g1XsryI6BG5gZvC8lPGWwuswcUGHIx6kPwfu62d87RcpNjhtm9K2BdKQVDTXixB
         iG0OAtHV9IreTosbL+vHW9vR2pa95PQd59p8rLV42dKTYuSt/o2Xv2Ga6AO81DphMeB8
         ELUQk7WUu2DhQ9OQyF+PENrrRh8jvIATdcqnZdLXEgkLWhRcZfTaqcc7vLCNhjxIJPuY
         VFqC7BM6pZOMgrIeNhkxVni9yAozsl7KybZPv9sBfYRAAt0sUwLKMWOcQVkB8Pu14nkR
         hEMw==
X-Gm-Message-State: AJIora/aRF/1MdJYZfl35iVEikdFWkw2sbQmaZZwagWtytyXPXmOIq8u
        0cfnrDGDO3XpsWKnUG4Lo6o=
X-Google-Smtp-Source: AGRyM1sgQxid4KDrB5fOZofd9u8G6sngEdZKJmRRA81L93hg9ddrwC1y/MFhttfHdr7MESlaVfTJCA==
X-Received: by 2002:a05:6a00:450d:b0:524:d95b:d51d with SMTP id cw13-20020a056a00450d00b00524d95bd51dmr21741776pfb.29.1655772421192;
        Mon, 20 Jun 2022 17:47:01 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z24-20020a17090abd9800b001ec85441515sm5379584pjr.24.2022.06.20.17.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 17:47:00 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 20 Jun 2022 17:46:59 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/84] 5.10.124-rc1 review
Message-ID: <20220621004659.GB2242037@roeck-us.net>
References: <20220620124720.882450983@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220620124720.882450983@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 20, 2022 at 02:50:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.124 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Jun 2022 12:47:02 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 477 pass: 477 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
