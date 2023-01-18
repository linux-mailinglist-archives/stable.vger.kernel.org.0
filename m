Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD6A67101A
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 02:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjARBh6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 20:37:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjARBh4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 20:37:56 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0075143A;
        Tue, 17 Jan 2023 17:37:54 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id s66so26865976oib.7;
        Tue, 17 Jan 2023 17:37:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ia/Q9WKwsAe0fHRlJDemb98849A5UJ9ZYQ4kp5Qk6BY=;
        b=oHPCUinx9Sz6p4HKy0ltNW4nuRdMMEJCKPKQ6g4jzgQhkMTiLuupElh2yks8LiKOKk
         UrCsh/G9M8Si3/RfSdvn3Mz9sDldLVbkJu+eqpSwvni3bzm7mR6GmywrWtItF4lupE1O
         o27v/snrJrC6RdWaoPcQ13Siam24Rk4p6E+utxi0K7Lac0VuU6MMHzH4pYsvpdl2MU30
         We62cQ0gZOq6b+GbmQSJQsWydsg28zhuvC2biF4Vsz90JYdQCN6mSFrAC425aDMPbrgv
         x5c/6K5k5j1C2do8ISghVwCtIT/92k78WTAIla6lUF9LxJ5aZoNRt954lcZMUSSzHP4c
         /F6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ia/Q9WKwsAe0fHRlJDemb98849A5UJ9ZYQ4kp5Qk6BY=;
        b=zuOLI2zJib4vAO7kS8qu5kXvT8/5hUkjhFQg8DMvc6iSPSPibkV9uGf80OlsCGA55v
         xECzpfVnmYLah6bcUQuw6rja/fCNz6PfhlzpG6e5RKw/P0KExh2b/6NpdrjuZ563hdVA
         PhAfQ/3GmxsGlOmeB9BzrnnWe8NPAulupCk8TGtkl2WUgSK1g8NnWft6RXulhYHEVJZX
         4oQ1ZGrwMFcqTUlma1kg1Wd6BgnL7zgZ10w0p56ZHkvj+4jY+fTQMRMl6sEUsUcGj8Ta
         OD7TCxsyX/6/ID5UJ+UTSSFLTAj3l1ii18mmA3Gh3pD2w6HMM2P/gGnZe5jGUUSNjo2i
         bh1Q==
X-Gm-Message-State: AFqh2kpoUFa2NtiJaUU9ajnnhiiOIgLHHKPk/5kf1sKGTJGaz0Mlr34I
        fyVeOA3NrP1YW3wAPfH/Al4=
X-Google-Smtp-Source: AMrXdXsiIJ8X1hvftOxm/F6SRpU3Ecgnat49YhEaWN+HdOLExdn2khyksVITO1Jk3dIDe3c8MpN8mQ==
X-Received: by 2002:aca:bf09:0:b0:355:1de9:3929 with SMTP id p9-20020acabf09000000b003551de93929mr1933183oif.47.1674005873936;
        Tue, 17 Jan 2023 17:37:53 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y16-20020a544d90000000b00367080ab4casm3223782oix.35.2023.01.17.17.37.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 17:37:53 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 17 Jan 2023 17:37:51 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.14 000/338] 4.14.303-rc1 review
Message-ID: <20230118013751.GA1727121@roeck-us.net>
References: <20230116154820.689115727@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
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

On Mon, Jan 16, 2023 at 04:47:53PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.303 release.
> There are 338 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 424 pass: 424 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
