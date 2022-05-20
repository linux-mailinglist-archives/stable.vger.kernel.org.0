Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C66C152F456
	for <lists+stable@lfdr.de>; Fri, 20 May 2022 22:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353435AbiETUYX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 May 2022 16:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352457AbiETUYX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 May 2022 16:24:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E3714AF4A
        for <stable@vger.kernel.org>; Fri, 20 May 2022 13:24:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26286B82B7D
        for <stable@vger.kernel.org>; Fri, 20 May 2022 20:24:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A021C385AA;
        Fri, 20 May 2022 20:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653078257;
        bh=+5RYhtAgWRJ7pdNslBbPmd3oCYbyUp+XYs7RPBbUcAQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xNIansiFJ9RvQiLlFJSRXNaP4IUwxhJ0xRKoHr0o9wcVPT0DGqN3qqPg4istompsH
         iTPQeq9m+tvkfEkDaqVza+hBLT1LdnFxAKq9+D78s7WgqrFD0TF4l64g2a6V87+ij8
         xw7aZ+rxZFsLMVle66h6urnllqManUIQNHOCTmQs=
Date:   Fri, 20 May 2022 22:24:14 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Abel Vesa <abel.vesa@nxp.com>
Cc:     Philippe Schenker <philippe.schenker@toradex.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "peng.fan@nxp.com" <peng.fan@nxp.com>,
        Francesco Dolcini <francesco.dolcini@toradex.com>
Subject: Re: Broken Audio on Stable Kernels for i.MX 7 based Boards
Message-ID: <Yof47ukLV0cmk0+r@kroah.com>
References: <536ad55a36d88364299f22782f7c12a6c70c5c11.camel@toradex.com>
 <YoecO1jxbh3nVJGF@abelvesa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoecO1jxbh3nVJGF@abelvesa>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 20, 2022 at 04:48:43PM +0300, Abel Vesa wrote:
> On 22-05-20 13:25:29, Philippe Schenker wrote:
> > Hello
> >
> > I noticed today, that commit eccac77ede394 ("clk: imx7d: Remove
> > audio_mclk_root_clk") was backported to stable kernels. This commit by
> > itself does break audio functionality on i.MX 7 based boards. [1]
> >
> > For this to work commit 4cb7df64c73 ("ARM: dts: imx7: Use
> > audio_mclk_post_div instead audio_mclk_root_clk") is also needed but is
> > lacking a Fixes: tag, hence it is missing in stable kernels. [2]
> >
> > I noticed this while merging stable-patches into our downstream-
> > branches.
> >
> > @Abel can you confirm my finding?
> 
> Hi Philippe,
> 
> Yes. Sorry about it. I should've added the Fixes tag
> to the first patch (of that series) too. My bad.
> 
> Lets hope Greg pick it up.
> 
> > @Greg could you pull patch [2] into kernels where [1] got merged?

It is already in all kernels except for 5.4.y where it does not apply
cleanly.  Can you provide a working backport for that branch?

Philippe, what branch did you test that you saw breakage?

thanks,

greg k-h
