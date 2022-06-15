Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDBC54D431
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 00:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345675AbiFOWET (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 18:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242770AbiFOWEQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 18:04:16 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2E6A5639E;
        Wed, 15 Jun 2022 15:04:12 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id t3-20020a17090a510300b001ea87ef9a3dso23244pjh.4;
        Wed, 15 Jun 2022 15:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=B/lcBT2zvh9WH/SWJfT0cjMqf3IsmHgiP49j/MJgSQw=;
        b=Y+XeMqiwcoCfW0R+mi7lzArSd2bf0V48ufIARR2I+vKwQp8IlJ0Vw6QwlOxSkDrk3J
         djHgvjiNNrENZ5qof4vLgJag7T6nFwwPXwZub6Txansde63YVs9DtKrUWwJd3Mh0RoEP
         pHF1v6BoHEgnSaXspMC7XotRM191gSPjlVgWzvDiU1VTkZS/qk5c/N0Vltg3KL8ZX6bm
         rvjRDsKRWovSVUjPLks0ZU8BckoF3cg1Na/LvTfL/EjB+xlDKquSvZpSJvswDHbC5suo
         z0bPXuObocdaHNa533FPnmW1VUgJggrwFLFRJnMToEkrq3kbaxrSuCyRb5Zn90k1xVjv
         PjhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=B/lcBT2zvh9WH/SWJfT0cjMqf3IsmHgiP49j/MJgSQw=;
        b=p1m9Mp3q6Gcz+PNslh4N1ycd5rFQXbki8VK3n5Li6igbF4qpIYxx0+Dcc9byQ7N5qJ
         YiwtMwvMaoBBNpNYY5wJge2R4+FhYuQjGNxHo5uQtwGUe+T5/K9/+5hN2Yd1fSrjRsMl
         KP5xtku6/+SleCw6ygW2l79lYpgDu+E9L4XZxiplUIs8ivg59WgkW9w/r2qE6cxyzEm9
         yTaGV85NpD1rrfl0mPawlgie2KeW77u+9WBoJbZT+SPjhkqOVZsvJQMIVWgHWF2ynfDr
         jd6nucw9WCQxTYcS3SAp+M4qeh8aKPjXEHG2nG9lZNzDkYzjwtGyLzh+11t2Y9COZX3G
         XItA==
X-Gm-Message-State: AJIora8lO7EbLQ3ysbXQxE/8WKrhEcw7+3rsdH/eZ6neRpX79/cNRJjx
        Oz6Ib6iwAcggyNEtpsFWlQ4=
X-Google-Smtp-Source: AGRyM1vA76/F9uVYj1UN9pwyypo3U+tX9PWxxkFENMXnlDieKnUsQGYdIvpPByWeqf2nYc/Z0w5G7Q==
X-Received: by 2002:a17:902:f606:b0:168:ecca:44e with SMTP id n6-20020a170902f60600b00168ecca044emr1396112plg.144.1655330652392;
        Wed, 15 Jun 2022 15:04:12 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v125-20020a626183000000b0051bed79a5e6sm131249pfb.90.2022.06.15.15.04.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 15:04:11 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 15 Jun 2022 15:04:10 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 00/11] 5.18.5-rc1 review
Message-ID: <20220615220410.GG1229939@roeck-us.net>
References: <20220614183720.861582392@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614183720.861582392@linuxfoundation.org>
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

On Tue, Jun 14, 2022 at 08:40:37PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.5 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
