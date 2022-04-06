Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7254F63CB
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 17:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236558AbiDFPqE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 11:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236595AbiDFPo5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 11:44:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17AD641D11A;
        Wed,  6 Apr 2022 06:02:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0D88B8238B;
        Wed,  6 Apr 2022 13:01:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3562C385A7;
        Wed,  6 Apr 2022 13:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649250118;
        bh=uPrV80DxeNwcp1FdNzYO+3Drqzpm3w0g1FHPY+tG+WI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QVaDGy73WkBoQint21oa63zb2kKsQk0lVbSRoaMiK5UP0EK+aSKEDUM16apWSdi00
         ZmT4K59VUSThYE7z9HpZ8tcXK3zXRTi+Ri/jIADnqyA2/hMjw+B47N2aESyY0MZKtR
         MzJQVquSWzy4lyPAdtDchkySAMe26fIIAZXzmndk=
Date:   Wed, 6 Apr 2022 15:01:55 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        Valentin Schneider <valentin.schneider@arm.com>
Subject: Re: [PATCH 5.15 000/913] 5.15.33-rc1 review
Message-ID: <Yk2PQzynOVOzJdPo@kroah.com>
References: <20220405070339.801210740@linuxfoundation.org>
 <373809f0-9fc8-8eeb-ff13-146df11b4ece@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <373809f0-9fc8-8eeb-ff13-146df11b4ece@applied-asynchrony.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 05, 2022 at 01:58:57PM +0200, Holger Hoffstätte wrote:
> (cc'ing Valentin)
> 
> On 2022-04-05 09:17, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.33 release.
> > There are 913 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> This locks up  immediately when trying to use tracepoints, due to:
> "sched-tracing-don-t-re-read-p-state-when-emitting-sc.patch" aka
> "sched/tracing: Don't re-read p->state when emitting sched_switch event"
> 
> Reverting this patch makes things work again, at least for 5.15.x;
> don't know about other series.

Thanks for letting me know, I've now dropped it from all of the queues.

greg k-h
