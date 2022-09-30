Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61AD65F039A
	for <lists+stable@lfdr.de>; Fri, 30 Sep 2022 06:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiI3EhQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Sep 2022 00:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiI3EhP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Sep 2022 00:37:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 376FC120873
        for <stable@vger.kernel.org>; Thu, 29 Sep 2022 21:37:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0E2162229
        for <stable@vger.kernel.org>; Fri, 30 Sep 2022 04:37:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B396FC433D6;
        Fri, 30 Sep 2022 04:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664512633;
        bh=ZRAneb5EcyZv3GWlaKMOIKXFNSHL4IGIBr70WUNZcIQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yzAUlKsvKUtXC7KxaLpRgt5sQadaJsJRJ2qcIjBvFcMFspnw9Fb1eYyKI5Yel2bAB
         2bEsUUMDe6X/HZAURnoUsyb/OjkjUHWLB3pMADdtxY5DwXI7hElgt4Fto7nazPVM3V
         ecxkrq5NL5xq2dK5PUqwr7/oaC6Ausr7zRWwUqs8=
Date:   Fri, 30 Sep 2022 06:37:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jerry Ling <jiling@cern.ch>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: Regression on 5.19.12, display flickering on Framework laptop
Message-ID: <YzZynE2FAMNQKm2E@kroah.com>
References: <55905860-adf9-312c-69cc-491ac8ce1a8b@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55905860-adf9-312c-69cc-491ac8ce1a8b@cern.ch>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_PDS_OTHER_BAD_TLD autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 29, 2022 at 10:26:25PM -0400, Jerry Ling wrote:
> Hi,
> 
> It has been reported by multiple users across a handful of distros that
> there seems to be regression on Framework laptop (which presumably is not
> that special in terms of mobo and display)
> 
> Ref: https://community.frame.work/t/psa-dont-upgrade-to-linux-kernel-5-19-12-arch1-1-on-arch-linux-gen-11-model/23171

Can anyone do a 'git bisect' to find the offending commit?

thanks,

greg k-h
