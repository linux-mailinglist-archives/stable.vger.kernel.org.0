Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 644994EBF80
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245723AbiC3LEu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245749AbiC3LEp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:04:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21DF5D0AA2
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 04:03:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B307761551
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 11:03:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE80C340EC;
        Wed, 30 Mar 2022 11:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648638180;
        bh=kSsXVJQfFQDmFtemNmAyXdnfJf3VRKebi/QPi5Xho3o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wBbDIRu7wNWw3dn3UlFRR37zNf192/Tlkfzx+BQxulJ2HEq4CsT1Dqyp84boHZhiR
         ZT3oskFEjBTA+Kukh/NNHkrPeNP6KqY2l4QJuSUzuJ8/kooOJeiCSHN9vYKyVkaALk
         WQuytwR011OWyZPaV/LjNmFhz7Baux5FCRgGETOo=
Date:   Wed, 30 Mar 2022 13:02:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Joshua Freedman <freedman.joshua@gmail.com>
Cc:     lis8215@gmail.com, paul@crapouillou.net, stable@vger.kernel.org,
        sboyd@kernel.org
Subject: Re: kernel 5.16.12 and above broke yoga c930 sound and mic
Message-ID: <YkQ44cqrnIH6aoxg@kroah.com>
References: <CAJQ3t4RxYXkREhwBb_JgYj4=ty+VtnV9m65U79ZLbmmj4mN7WA@mail.gmail.com>
 <YkQUGVC3MBSnc2LI@kroah.com>
 <CAJQ3t4TqK+q5zeHCQ2uxGvhT4q0Bpe6PBuDTm28HqyHwH5mzhQ@mail.gmail.com>
 <YkQnGmxdi9GWZmfC@kroah.com>
 <CAJQ3t4SnNyHEaWizzVDbaMSdHDRe9wHGx2RdgJJea=G4sFmdnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJQ3t4SnNyHEaWizzVDbaMSdHDRe9wHGx2RdgJJea=G4sFmdnw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 30, 2022 at 06:28:33AM -0400, Joshua Freedman wrote:
> I'm a mortgage broker but I can figure this out.
> 
> Am I doing this:
> git clone git://
> git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-stable
> 
> and then git good and bad for for 5.16.11 and 5.16.12 and putting that to a
> log file that you can use?

Yes, that is exactly right!

thanks,

greg k-h
