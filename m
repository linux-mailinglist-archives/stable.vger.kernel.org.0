Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92D3C5F0464
	for <lists+stable@lfdr.de>; Fri, 30 Sep 2022 07:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbiI3F6f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Sep 2022 01:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiI3F6c (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Sep 2022 01:58:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52FE169E72
        for <stable@vger.kernel.org>; Thu, 29 Sep 2022 22:58:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5932D6223A
        for <stable@vger.kernel.org>; Fri, 30 Sep 2022 05:58:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A00C433D6;
        Fri, 30 Sep 2022 05:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664517510;
        bh=MX7SYb4vy45NYzPRy+E4YlrZSouPYPalitZ97czaT4A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Jv4J32GgJaNufhN1gRA8h4Ixj4SRbWVvoFq06xFK0eaqZpjmuMHm5SwFa2n2rnTJu
         oDAcqr2P/kBWmdIC6EqLs72pzIDg/HOUURaM1fetywXw0YQk9mLKgLO/AKgtmHZZ5W
         A3pZ9YRvk0qguOC9xIYxgoxMaApQoYPbXXomOvO4=
Date:   Fri, 30 Sep 2022 07:59:07 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jerry Ling <jiling@cern.ch>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: Regression on 5.19.12, display flickering on Framework laptop
Message-ID: <YzaFq7fzw5TbrJyv@kroah.com>
References: <55905860-adf9-312c-69cc-491ac8ce1a8b@cern.ch>
 <YzZynE2FAMNQKm2E@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzZynE2FAMNQKm2E@kroah.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_PDS_OTHER_BAD_TLD autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 30, 2022 at 06:37:48AM +0200, Greg KH wrote:
> On Thu, Sep 29, 2022 at 10:26:25PM -0400, Jerry Ling wrote:
> > Hi,
> > 
> > It has been reported by multiple users across a handful of distros that
> > there seems to be regression on Framework laptop (which presumably is not
> > that special in terms of mobo and display)
> > 
> > Ref: https://community.frame.work/t/psa-dont-upgrade-to-linux-kernel-5-19-12-arch1-1-on-arch-linux-gen-11-model/23171
> 
> Can anyone do a 'git bisect' to find the offending commit?

Also, this works for me on a gen 12 framework laptop:
	$ uname -a
	Linux frame 5.19.12 #68 SMP PREEMPT_DYNAMIC Fri Sep 30 07:02:33 CEST 2022 x86_64 GNU/Linux

so there's something odd with the older hardware?

greg k-h
