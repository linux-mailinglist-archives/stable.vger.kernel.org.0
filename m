Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72BDB6E5EAE
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 12:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbjDRKZ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 06:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbjDRKYx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 06:24:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4244D72A9
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 03:24:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC52862FA4
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 10:24:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3189C433D2;
        Tue, 18 Apr 2023 10:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681813479;
        bh=BcCnOuG4G972S81osN4uUdGsYnZqasNYjL5Fidz4a7Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hthCEbT50UjWLIZzGuRAOMhlMZRmYjO68KjwhwH2R49s0IZ0ch12TXtHFxElbJU2m
         dHb2q+WyCX3+R20j7DOdyS6B8chqmW/xL03pnNyD9H+s0H0HGyDyLErwxZve1sD1/y
         LAlYLa9KYg6prtsfvlMtj7bCWhkPkN8BA3LrB4AE=
Date:   Tue, 18 Apr 2023 12:24:36 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Takahiro Itazuri <itazur@amazon.com>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Dave Martin <Dave.Martin@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        "zhang . lei" <zhang.lei@jp.fujitsu.com>,
        Takahiro Itazuri <zulinx86@gmail.com>
Subject: Re: [PATCH v3 stable 4.14 4.19 0/3] Backport "KVM: arm64: Filter out
 invalid core registers IDs in KVM_GET_REG_LIST"
Message-ID: <2023041829-spyglass-partridge-c071@gregkh>
References: <20230404103050.27202-1-itazur@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404103050.27202-1-itazur@amazon.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 04, 2023 at 11:30:47AM +0100, Takahiro Itazuri wrote:
> Hi stable maintainers,
> 
> This is a backport patch for commit df205b5c6328 ("KVM: arm64: Filter
> out invalid core register IDs in KVM_GET_REG_LIST") to 4.14 and 4.19.
> This commit was not applied to the 4.14-stable tree due to merge
> conflict [1]. To backport this, cherry-picked commit be25bbb392fa
> ("KVM: arm64: Factor out core register ID enumeration") that has no
> functional changes but makes it easy to merge, and commit 5d8d4af24460
> ("arm64: KVM: Fix system register enumeration") that is a fix patch for
> the commit.
> 
> I'd appreciate it if you could consider backporting this to 4.14 and
> 4.19.

All now queued up, thanks.

greg k-h
