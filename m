Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1EB954D42A
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 00:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344070AbiFOWCv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 18:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349805AbiFOWCu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 18:02:50 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54BE51409B;
        Wed, 15 Jun 2022 15:02:50 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id t3-20020a17090a510300b001ea87ef9a3dso19765pjh.4;
        Wed, 15 Jun 2022 15:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zYQJtLnYbYiQQQ0fyiU3klMIhQhlOiHvSuqMrJE96Do=;
        b=TOG+bCV3B2LOzzpRnpoE2YKj9zAf274IKpCQZ26a5gDwPdGv3sbYU21yWbE7FcIgCO
         ddpTojr+/mA05paV4GfSJi5pXtvy+ri0H1yYvDMgj17gQRwOi3IvL8aYke6eBY56HmdL
         wo0V2rmfhQbBqxoq5xLy7dr/f6i+PFysegQ760IiTIbKQB1BbaY8/hRDvbT2o42F7un+
         JorM+PPJg0rvPpHwAQ3UoUUIn3oaKwgFjnfqugAzOfLsHwhy9CvDK1N6rI5Zy15KBWV6
         K9VkTjUOx2b+dPM/z2BMfJH8WuAIHgDD5f7Uo3NxAE9RoFuop8UsxKnK0leiLp3A/Bgt
         GiAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=zYQJtLnYbYiQQQ0fyiU3klMIhQhlOiHvSuqMrJE96Do=;
        b=izfwvtEnzJ/4dedIb0xQkF3moGJ3MfVjlNYaqA2FGUZlLz0BCNpgeAiKWCwJKTJeRl
         xKgMBFViXllc1j8RyUQd26pzH9unVKWWWWNQG1LZuutuIozUlUu5znoB5Gmu0RGn4bBe
         p7aLD8wVleAW7CeIYj2juGo9E9DTPNJ/u0ZP2U2Ey5FDH+ww/1l+LgFMObPhd8u4v642
         h9tTIEeUKTb7lVhMstO6j/NfbRmn5OxTU2gIboqNStDjByID5k68/qeiBd4RfsiAyuGq
         +qMHTVcWZi8QouMpGWsKhKZn3qUldhMiMH2akZY7c1whPoolcRoj9wKizi57d/0DGJBC
         kiHQ==
X-Gm-Message-State: AJIora/fkdSCUfDoYvisl6fFmKanxErX8G2l3kwYHLO90P/m1qa+yRS+
        SdUmHUvg4bWYORrCwAhKSLg=
X-Google-Smtp-Source: AGRyM1s4CoT28Xzft0Dh+p58KyboWTgfk6LykE2QtwffljtCBA2WJyMPCKqBnhdKjwNiqPR+SqXc6Q==
X-Received: by 2002:a17:90a:94cb:b0:1e3:4295:9c18 with SMTP id j11-20020a17090a94cb00b001e342959c18mr1573475pjw.53.1655330569887;
        Wed, 15 Jun 2022 15:02:49 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s10-20020a63af4a000000b003db7de758besm88057pgo.5.2022.06.15.15.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 15:02:49 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 15 Jun 2022 15:02:47 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/15] 5.4.199-rc1 review
Message-ID: <20220615220247.GD1229939@roeck-us.net>
References: <20220614183721.656018793@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614183721.656018793@linuxfoundation.org>
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

On Tue, Jun 14, 2022 at 08:40:09PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.199 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 449 pass: 449 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
