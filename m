Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 524715F52BA
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 12:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbiJEKjQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 06:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiJEKjO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 06:39:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD91760EC;
        Wed,  5 Oct 2022 03:39:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11588B81C9E;
        Wed,  5 Oct 2022 10:39:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3220AC433D6;
        Wed,  5 Oct 2022 10:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664966350;
        bh=t86moVWLtfQNHQsmVb+kuiHXrm2+BEqdnD45+rfMf3E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nCBn1WpQetxNI6KOI7cj7F4BbCWslFE2/DiAeRKUvvWEWw9THvrQWzPydOTFGYH27
         +hN3nCl3TbFjdrYaWeDjPSXCkXazcfCQDQjeOX0AVgQvDz2BqVkoJtRgYaVJfqxAFB
         6MIFhikCA4T/82fWXj98LbBj4wcg04j7ISxM81Wg=
Date:   Wed, 5 Oct 2022 12:39:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.4 00/30] 5.4.216-rc1 review
Message-ID: <Yz1ezFRH3/UXpQCq@kroah.com>
References: <20221003070716.269502440@linuxfoundation.org>
 <7af02bc3-c0f2-7326-e467-02549e88c9ce@linuxfoundation.org>
 <YzxvTF3qOacE9Cdi@kroah.com>
 <e5b31a9f-56a2-d9e5-fe60-b785171600e2@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5b31a9f-56a2-d9e5-fe60-b785171600e2@linuxfoundation.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 04, 2022 at 11:39:57AM -0600, Shuah Khan wrote:
> On 10/4/22 11:37, Greg Kroah-Hartman wrote:
> > On Mon, Oct 03, 2022 at 05:49:21PM -0600, Shuah Khan wrote:
> > > On 10/3/22 01:11, Greg Kroah-Hartman wrote:
> > > Compiled and failed to boot. Reverting the following patch fixes
> > > the problem.
> > > 
> > > commit 4b453403a945b13ea8aa9e8628bec1eaffeb7257 (HEAD -> linux-5.4.y)
> > > Author: Shuah Khan <skhan@linuxfoundation.org>
> > > Date:   Mon Oct 3 15:45:57 2022 -0600
> > > 
> > >      Revert "drm/amdgpu: use dirty framebuffer helper"
> > > 
> > > thanks,
> > > -- Shuah
> > >      This reverts commit c89849ecfd2e10838b31c519c2a6607266b58f02.
> > 
> > As that commit is in 5.4.215, it's not part of this -rc series.  Do you
> > want to submit a patch for the revert, or want me to make one up after
> > 5.4.216 is out?
> > 
> 
> I will send in a revert.

I've done it now, no need to send it in.

thanks,

greg k-h
