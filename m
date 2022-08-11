Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D56058FDAC
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 15:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235091AbiHKNsw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 09:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234841AbiHKNsw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 09:48:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01551883E0
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 06:48:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9316D614C4
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 13:48:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88690C433D6;
        Thu, 11 Aug 2022 13:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660225727;
        bh=/mLJQZhQKfvIPS4YlPFFXQF89JAb0XIWb2Q/5HSG55U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kHCuGMV1z+vUsfWzNfRh5a/C0uY8HK/fom07qZCkMVCwO4ckX9kL0n+Fh6VP3j/vB
         5zp6UTo9oni86eg7LNkOhe08rk7oh8FJP31HJHNbKTFn6H9SBGMkRrqYjNzyd4evF9
         R1DpI3fZd79zQRXdp/yEwMducinplX4kaX2Ic3Ho=
Date:   Thu, 11 Aug 2022 15:48:43 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     meljbao@gmail.com
Cc:     stable@vger.kernel.org, Sasha Neftin <sasha.neftin@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH] igc: Remove _I_PHY_ID checking for i225 devices
Message-ID: <YvUIu/ROCzcoOPhE@kroah.com>
References: <5d499487-2503-f1bd-586c-57ac755e1f41@gmail.com>
 <YvTDQr7MuhnQYP/9@kroah.com>
 <1bb5e092-310b-26fa-38f7-fb797b1cd995@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1bb5e092-310b-26fa-38f7-fb797b1cd995@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 11, 2022 at 06:19:20PM +0800, meljbao@gmail.com wrote:
> On 8/11/22 4:52 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Thu, Aug 11, 2022 at 04:39:51PM +0800, Linjun Bao wrote:
> > > commit 7c496de538ee ("igc: Remove _I_PHY_ID checking") upstream,
> > > backported to stable kernel 5.4 to support i225 Ethernet adapters.
> > >
> > > Signed-off-by: Linjun Bao <meljbao@gmail.com>
> > 
> > What happened to the original commit message and signed off by lines,
> > and why not cc: everyone involved in the original commit also?
> > 
> I wrongly re-send this commit to mainline initially, then Tony guided me
> submitting to the stable tree with Option#3 [1]. Sorry I did not involve 
> everyone in the original commit which I should. I re-send this commit 
> because I encounter probe failure with i225-LM Ethernet card on liuux-5.4, 
> and the original commit could not be applied to 5.4 directly, and this 
> duplicated patch has been tested with i225-LM. I would like this commit is
> backported to linux-5.4, please correct me if I am doing the wrong thing.
> 
> Regards
> Joseph
> 
> [1] https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html#procedure-for-submitting-patches-to-the-stable-tree

The original commit worked just fine, why not just send that?

I've now queued it up, thanks.

greg k-h
