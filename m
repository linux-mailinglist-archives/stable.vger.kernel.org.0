Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1454053CB7A
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 16:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbiFCO1J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 10:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbiFCO1I (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 10:27:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97EBBB7E7
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 07:27:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90051B8234E
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 14:27:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4958C385A9;
        Fri,  3 Jun 2022 14:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654266424;
        bh=7U0aoCVVJE0y26ZR04Q4Y/AUEyFaCWAx1E1DyqF52f0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cYuPmkx4ivmTG39CYvx1XmOq89XTMK9NuDmBCG/1ATT8DgPZDmppsrVcH3x7V4NDm
         ID5fdZu8quyz9FHVs4KpcdDlHsSYRoYpq5k6e9ShsRNmaBmLItCW0Gz6wa9zEP6tWJ
         ZVtsO//rD9oCTunsyknkUgnmUaeOVCSkFns+TlxY=
Date:   Fri, 3 Jun 2022 16:27:01 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thomas Sattler <sattler@med.uni-frankfurt.de>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: boot loop since 5.17.6
Message-ID: <YpoaNR9lxNrJcmY+@kroah.com>
References: <11495172-41dd-5c44-3ef6-8d3ff3ebd1b2@med.uni-frankfurt.de>
 <YpkY0RLWki4PJ49y@kroah.com>
 <88b0eb42-41eb-af0e-285c-05f86a5c5fea@med.uni-frankfurt.de>
 <YpoFId6um9GaXKha@kroah.com>
 <21de0fda-0ff0-a553-dae4-193eaec25ca3@med.uni-frankfurt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21de0fda-0ff0-a553-dae4-193eaec25ca3@med.uni-frankfurt.de>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 03, 2022 at 03:46:34PM +0200, Thomas Sattler wrote:
> Am 03.06.22 um 14:57 schrieb Greg KH:
> > On Fri, Jun 03, 2022 at 01:29:26AM +0200, Thomas Sattler wrote:
> > > Am 02.06.22 um 22:08 schrieb Greg KH:
> > > > On Thu, Jun 02, 2022 at 06:14:43PM +0200, Thomas Sattler wrote:
> > > 
> > > Now, knowing that they were two patchsets, I compiled 5.17.12
> > > twice, once without 60d2b0b1018a and once without d17f64c29512.
> > > 
> > > And it turns out it is 60d2b0b1018a which breaks my system.
> > 
> > Does 5.18.1 also break for you?
> > 
> 
> There is no difference between 5.17.6, 5.17.12 and 5.18.1:
> 
>   - they do not boot vanilla
>   - applying ead165fa1042 is no help
>   - reverting 60d2b0b1018a allows booting

Great, please work with the developers of that change to track down the
problem and get it fixed.

thanks,

greg k-h
