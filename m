Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1511760796E
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 16:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiJUOXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Oct 2022 10:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiJUOXW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Oct 2022 10:23:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4FD127D4CC
        for <stable@vger.kernel.org>; Fri, 21 Oct 2022 07:23:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E323B82BCF
        for <stable@vger.kernel.org>; Fri, 21 Oct 2022 14:23:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CA5C433D6;
        Fri, 21 Oct 2022 14:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666362194;
        bh=cWPl6VksCNwrlIm8EAM+LaA9DpE69r4WtElnbJJQHqQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a6FeqpNAdXaAjHfWGANC4LiqizfbfpoY2WeXa1teX1Kubl2jufmbUfjCbZVLC20eH
         jliGwi6/fnCS79cgBZpsJm+UJG1fxqNjsGfhDSnGP27lsHudJ9FPvHbfJU6JHJew6x
         pOCR25CdVWMIeDHDzaCT0gkHl41QulfD70VILQLw=
Date:   Fri, 21 Oct 2022 16:23:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Evgenii Stepanov <eugenis@google.com>
Cc:     stable@vger.kernel.org, Peter Collingbourne <pcc@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: backport of arm64: mte: move register initialization to C
Message-ID: <Y1KrUDvIf30wAcUC@kroah.com>
References: <CAFKCwrhcszDEzW8S2Y_aCZW2o5H6S=Z-Ao1ASpzPw3ZOm9UAtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFKCwrhcszDEzW8S2Y_aCZW2o5H6S=Z-Ao1ASpzPw3ZOm9UAtw@mail.gmail.com>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 18, 2022 at 03:33:08PM -0700, Evgenii Stepanov wrote:
> Hello stable,
> 
> please backport the following commits to 5.15-stable:
> 
> commit 973b9e37330656dec719ede508e4dc40e5c2d80c upstream.

It does not apply to 5.15.y :(

> Please note that the extra backport below can be avoided with a
> trivial change in the above patch. Let me know if that's preferable.
> 
> Cc: <stable@vger.kernel.org> # 5.15.y: e921da6: arm64/mm: Consolidate
> TCR_EL1 fields
> Signed-off-by: Evgenii Stepanov <eugenis@google.com>

Yes, please provide a working backport.

thanks,

greg k-h
