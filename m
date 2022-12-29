Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5C59658D96
	for <lists+stable@lfdr.de>; Thu, 29 Dec 2022 14:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiL2NnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Dec 2022 08:43:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233263AbiL2Nm7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Dec 2022 08:42:59 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D7C1C8;
        Thu, 29 Dec 2022 05:42:58 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id r11so17134324oie.13;
        Thu, 29 Dec 2022 05:42:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iU5YR6g7EfNu0IKYILG9gNX2NqRxPGtJQ3zhvrD7d40=;
        b=Vjnbt8qCFN9vs5SeheQkjqX73L+5YrEyhgFYHuNft0EHBaacpA6LgS5zEvsxfdpjgZ
         G5oiQcGyZSjoCfrB9kHrfIDFUcHZ9fBR4QLM0HK+FFOnKwOFPjB0o1Ok0BEo8bIgGKmY
         /ZCUFD/f4xZJHelP9yi1cU4AdWCt8c5hTSoCfmT80dT9mpYbc4VQuW0xeodQPvthDLjp
         bHMnjKDXp8LhCssXKaqDFwZuzHhAUyPuEZ9RP9HSOCSITztZFGS+knJXJXQAxGSwOFHF
         yR6VK9tVleeQjRAE2UUyh40RIlwpeQ27z7F5CUpD7MpyJWjS1Rt2BXKnx0ZxYgdNRvml
         RjPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iU5YR6g7EfNu0IKYILG9gNX2NqRxPGtJQ3zhvrD7d40=;
        b=uN8+Omx6AAb+UdO+7X6O32l4FX9xVEUlItHz0AnYNVQ9djUEI0mGZ1NRucW0dkTdM+
         iB6TPtuCM3Sehdw6LHW1AA27QstgrWERNbX39cYYE9EfOA2gJRLrM2+eLnM90Ox8QbWG
         hUaJlTFF601QG6VrxTz5Ni83zItXvvd7uRN819NzD7WizOWiA2253QIAgmtPHV0LgneK
         vmivnMnykZI6ETUVUOpDZmL5BC49jNuFz/Ku7BZ8OsxuPl4UpLvPcR1fJLKwfTHYwRX0
         lNMXPnE7mSjXrV1H4m2QqTk4SgeZ7EzYvKBs5Y10K6zRpj22MldjZvNoP1y5q6vybuQ8
         aaDQ==
X-Gm-Message-State: AFqh2kqzBOPE03EjTp5OHd9obl00rF5LsyumDHbbLwbmWnyWvQWT1afN
        q1EmDDfaVQ2T9vXd1kQCHb0=
X-Google-Smtp-Source: AMrXdXuo9eYBLfUByRgvD9NMG9Rb66AbVGrS7Ha0n8FVfIwYn+QIzbcIG8zOwR37iOFykfujMN4XdA==
X-Received: by 2002:a05:6808:1387:b0:361:25b3:b4e6 with SMTP id c7-20020a056808138700b0036125b3b4e6mr15394570oiw.22.1672321377725;
        Thu, 29 Dec 2022 05:42:57 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s8-20020aca4508000000b003549db40f38sm8037733oia.46.2022.12.29.05.42.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Dec 2022 05:42:56 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 29 Dec 2022 05:42:55 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/731] 5.15.86-rc1 review
Message-ID: <20221229134255.GA16547@roeck-us.net>
References: <20221228144256.536395940@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
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

On Wed, Dec 28, 2022 at 03:31:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.86 release.
> There are 731 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Dec 2022 14:41:39 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 158 fail: 2
Failed builds:
	arm:allmodconfig
	arm64:allmodconfig
Qemu test results:
	total: 489 pass: 489 fail: 0

Build errors as reported.

Guenter
