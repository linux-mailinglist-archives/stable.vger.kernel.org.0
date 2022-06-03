Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41C9053CA43
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 14:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244454AbiFCM5S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 08:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233094AbiFCM5S (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 08:57:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEF8810FDF
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 05:57:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A3EA6168B
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 12:57:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7798EC385A9;
        Fri,  3 Jun 2022 12:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654261028;
        bh=BgxSOabF8NS37zOh6KbugrE/MEMF9mMNUdEJ5iL5IBk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MiP6OTFBDA92tEzIiGA3uLEDPs3VtM1bNSM+s+iigi4cMZxb03rZEEvXGa5O/TA8q
         dcAC3vhH6Kl+jTSeqZlQQfhMrOpycfqwp4p7sxpKyGyof2AYpf7vFY+LYkQWJZrArO
         K7f+YffaBKOijQSIaEnjAnyTtqMwuWF0tsv5mC8g=
Date:   Fri, 3 Jun 2022 14:57:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thomas Sattler <sattler@med.uni-frankfurt.de>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: boot loop since 5.17.6
Message-ID: <YpoFId6um9GaXKha@kroah.com>
References: <11495172-41dd-5c44-3ef6-8d3ff3ebd1b2@med.uni-frankfurt.de>
 <YpkY0RLWki4PJ49y@kroah.com>
 <88b0eb42-41eb-af0e-285c-05f86a5c5fea@med.uni-frankfurt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88b0eb42-41eb-af0e-285c-05f86a5c5fea@med.uni-frankfurt.de>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 03, 2022 at 01:29:26AM +0200, Thomas Sattler wrote:
> Am 02.06.22 um 22:08 schrieb Greg KH:
> > On Thu, Jun 02, 2022 at 06:14:43PM +0200, Thomas Sattler wrote:
> > > After applying "patch-5.17.5-6.part198.patch" compilation is
> > > broken. Still after applying "patch-5.17.5-6.part199.patch".
> > > After applying "patch-5.17.5-6.part200.patch", compilation
> > > works again but the resulting kernel now fails to boot.
> > 
> > I have no idea what those random patches are, please can you say what
> > the upstream commit is?
> 
> I took what I reverted from patch-5.17.5-6.xz. In your tree it
> matches what Nathan mentioned (60d2b0b1018a) plus d17f64c29512.
> 
> Now, knowing that they were two patchsets, I compiled 5.17.12
> twice, once without 60d2b0b1018a and once without d17f64c29512.
> 
> And it turns out it is 60d2b0b1018a which breaks my system.

Does 5.18.1 also break for you?

thanks,

greg k-h
