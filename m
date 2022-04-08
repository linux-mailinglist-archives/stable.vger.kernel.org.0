Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2E44F8E79
	for <lists+stable@lfdr.de>; Fri,  8 Apr 2022 08:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234116AbiDHEnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Apr 2022 00:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233655AbiDHEng (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Apr 2022 00:43:36 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14FAB1B3095;
        Thu,  7 Apr 2022 21:41:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 21931CE29D0;
        Fri,  8 Apr 2022 04:41:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0066C385A1;
        Fri,  8 Apr 2022 04:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649392889;
        bh=cnXCoSbyONABUhqSZykXs692fOjS6Q14s5CcV/v+cEA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oTAW/NA7qTEoY5rxDrsMB2n++AkM9l/u5YNBXV47nUnsWXoTEpiWjUJ3iQYJwcDCZ
         kr2TvVAwx5R8usInMBPpwlXptf60QEBGbjq5CfhyTGC8E7nztNNVBrOLxIY2aj+0iv
         RswSmOzR+TtK57yT03UBuvv9l0yIMgtlK2bPkYTk=
Date:   Fri, 8 Apr 2022 06:41:26 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/597] 5.10.110-rc3 review
Message-ID: <Yk+89iEPuKh06Pcu@kroah.com>
References: <20220407183749.142181327@linuxfoundation.org>
 <20220407214816.GA186606@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407214816.GA186606@roeck-us.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 07, 2022 at 02:48:16PM -0700, Guenter Roeck wrote:
> On Thu, Apr 07, 2022 at 08:45:17PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.110 release.
> > There are 597 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 09 Apr 2022 18:35:00 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 161 pass: 161 fail: 0
> Qemu test results:
> 	total: 477 pass: 477 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>
> 
> Guenter

Finally!  thanks for all the testing here.
