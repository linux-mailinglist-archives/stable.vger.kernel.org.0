Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6486E689F82
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 17:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbjBCQp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 11:45:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbjBCQp1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 11:45:27 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 364106950A;
        Fri,  3 Feb 2023 08:45:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 808E8CE30CC;
        Fri,  3 Feb 2023 16:45:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89CAC433D2;
        Fri,  3 Feb 2023 16:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675442722;
        bh=jFqyihOG2qysQhfUaE8WHd7ywz99MsnZfWzodwPNilo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G6/WWc8hp0Xk23in/lJm56NhvcRndfWU6EugJe+EpyH8lVaJbXQHAouLzK6COs5l/
         tp5oFNUXrjFKfBMxZC7BG6+9NtuLxh/CiFa3KuVDOqaGx+0mHS0y7b+hxSb3TwheYN
         URwF5W1FCr5VeSUjxnogdwB8URnYC2CoMQ8CYSdE=
Date:   Fri, 3 Feb 2023 17:45:19 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/134] 5.4.231-rc1 review
Message-ID: <Y906Hz3UWYxoxYdD@kroah.com>
References: <20230203101023.832083974@linuxfoundation.org>
 <20230203155619.GA3176223@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203155619.GA3176223@roeck-us.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 03, 2023 at 07:56:19AM -0800, Guenter Roeck wrote:
> On Fri, Feb 03, 2023 at 11:11:45AM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.231 release.
> > There are 134 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Building ia64:defconfig ... failed
> --------------
> Error log:
> <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
> arch/ia64/kernel/mca_drv.c: In function 'mca_handler_bh':
> arch/ia64/kernel/mca_drv.c:179:9: error: implicit declaration of function 'make_task_dead'
> 
> Caused by "exit: Add and use make_task_dead.". Did that really have to be backported ?

Yup, it does!

Eric, any help with this?

thanks,

greg k-h
