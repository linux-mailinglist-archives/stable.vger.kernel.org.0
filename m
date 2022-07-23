Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C48F57EF58
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 16:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236707AbiGWOAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 10:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236274AbiGWOAK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 10:00:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A7B7C11
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 07:00:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0A7CB801B9
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 14:00:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C7DBC341C0;
        Sat, 23 Jul 2022 14:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658584806;
        bh=6Z06LRymMxnGPEjmwyvXVIUrC0DHRu22dr8r9lSutOE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d8UZwskv8z2FK8lVPiE+cPB7ApuqLmtTnQ2VjpZGvOw4Z0Ki9UnEpP0CdKIz/UwKP
         +s6DYl9GZS8XL+Xmu0j+UC/EZ5Ic63JLRdqwxcjDoCIWC51ijkwJmeorOukoT1mzjz
         VIQZp/YM4L8BYl1cV9tnUG3r90R9+8OGGeXg+oNQ=
Date:   Sat, 23 Jul 2022 16:00:03 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Fabio Porcedda <fabio.porcedda@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v4 5.18 0/2] Backport support for Telit FN980 v1 and FN990
Message-ID: <Ytv+46DahY1Ity1e@kroah.com>
References: <20220720055924.543750-1-fabio.porcedda@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220720055924.543750-1-fabio.porcedda@gmail.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 20, 2022 at 07:59:22AM +0200, Fabio Porcedda wrote:
> Hi,
> these two patches are the backport for 5.18.y of the following commits:
> 
> commit a96ef8b504efb2ad445dfb6d54f9488c3ddf23d2
>     bus: mhi: host: pci_generic: add Telit FN980 v1 hardware revisio
> 
> commit 77fc41204734042861210b9d05338c9b8360affb
>     bus: mhi: host: pci_generic: add Telit FN990
> 
> The cherry-pick of the original commits don't apply because the commit
> 89ad19bea649 (bus: mhi: host: pci_generic: Sort mhi_pci_id_table based
> on the PID, 2022-04-11) was not cherry-picked. Another solution is to
> cherry-pick those three commits all togheter.

It would be good to take the sorting patch too, that way it makes it
easier to handle over time.  But I guess I'll have to rely in you all to
backport these instead :)

Now queued up.

greg k-h
