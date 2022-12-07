Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F606645C6F
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 15:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiLGOZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 09:25:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiLGOZi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 09:25:38 -0500
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B06EE21271;
        Wed,  7 Dec 2022 06:25:29 -0800 (PST)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-14455716674so15307742fac.7;
        Wed, 07 Dec 2022 06:25:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CNO7oy1kZ/LbkPvSex6hVFeb8qf9A9gkFQgfh2XVq/M=;
        b=ONffI2aXVriT9+sJJpAv8XUZUt6ZNdVOnfSfE73r3U6mJz8/s3mZCWCnhH8xmuNZ6u
         ARmTT9OtylpJJno0ZF48ayrSJh1USW6xWIVhxG+eCVR6rjgo4+bDdeQ0ylCmFGieBdQS
         0PSnzdZBROYfvazFWex5Buse9ddjpy7/4sbECbrMgZ9ZEVF5U6qIPON8e12Pt8Vue6lV
         TEp6XIVZLo0PkhfYBiaTdEDh6cgbEH+9h1QC21cvabHuHt2RzoFpHgp/V+HXF49+4MnH
         OSKoGRG+AbheDqiMSdOvfkwhjjdl7SnG8spiSn0dezH4CfArtarMo0NxfMep+bmjvXvb
         smtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CNO7oy1kZ/LbkPvSex6hVFeb8qf9A9gkFQgfh2XVq/M=;
        b=FiVjHC9VY8pEwgNRDQYgJduozPsNZ9LLedIFhpyNP0/T7dyi3203GulQx4CZGA6BnO
         Vw3HNuUTwfKjTSuZPy2OL1fkmxRQYg0XAwrPbgcH1OSw0DFH6iviHNfQCp+bKJxcCw4+
         TSREr+79qdicpjjDDa8qtFaqK3HtuX1gwD10MzbltGIqXCraZWifD4fwXrScqxQrxYvi
         ZmYLPVtPYsNck39gzZAbVePtf2KJTyyj/sGuZ2dQ6z3Uz362DjW6kLAPISa4xoEtGjp6
         TS+V0FGudg5/Gf4UfNwJOtsfSpABp4CIFZ8h6veNXLU/Yx0dJAfEzGaPNZ2+n6pVKiMm
         oREQ==
X-Gm-Message-State: ANoB5pm4qXoDdhvvlxaofqTIUD/Ui0U30yQ0YMyPv1a5qjEM2HJO0wYo
        vDU1Es4085/v4KmKRn6afmg=
X-Google-Smtp-Source: AA0mqf4DBQ3/oxfxenA+7m+wGzkIZJA2gjRBYzlrAKKmg+uSE0ATyn2afM3a9RiQyuxdd8vvXSmmXA==
X-Received: by 2002:a05:6870:d90e:b0:13c:ed73:847e with SMTP id gq14-20020a056870d90e00b0013ced73847emr52506663oab.63.1670423129004;
        Wed, 07 Dec 2022 06:25:29 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id cz41-20020a05687064a900b0013297705e5dsm6212167oab.28.2022.12.07.06.25.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 06:25:28 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 7 Dec 2022 06:25:27 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.14 00/83] 4.14.301-rc2 review
Message-ID: <20221207142527.GB319836@roeck-us.net>
References: <20221206124046.347571765@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206124046.347571765@linuxfoundation.org>
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

On Tue, Dec 06, 2022 at 01:41:52PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.301 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Dec 2022 12:40:31 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 422 pass: 422 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
