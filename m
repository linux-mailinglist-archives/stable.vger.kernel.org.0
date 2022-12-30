Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B33A65969D
	for <lists+stable@lfdr.de>; Fri, 30 Dec 2022 10:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234754AbiL3JQx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Dec 2022 04:16:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbiL3JQx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Dec 2022 04:16:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C27F1A38A
        for <stable@vger.kernel.org>; Fri, 30 Dec 2022 01:16:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF0FF61AC8
        for <stable@vger.kernel.org>; Fri, 30 Dec 2022 09:16:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D48DC433D2;
        Fri, 30 Dec 2022 09:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672391811;
        bh=kZWcStAvie3G58rVTjxtLdxTfwyQh2a6SEBAVt1L6jg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P53UyW3vrgmfeRWo8GsjNVCGgeFynLOVrI7I8VIT5HCIhhEOrYxmNp2dv9coqHg9/
         rBeENbmMxe0F+DlEgaiagMeP+kUaKXuGaU0BNZ0a+qhiCOt3/z3ORFR3uRqB4k0iz0
         r5wxheq1ozrb3IC3GdzbravkDhtA56vxt2vfC9T8=
Date:   Fri, 30 Dec 2022 10:16:49 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 152/731] powerpc: dts: t208x: Mark MAC1 and MAC2 as
 10G
Message-ID: <Y66sgU+uDY2tEYY1@kroah.com>
References: <20221228144256.536395940@linuxfoundation.org>
 <20221228144300.959873542@linuxfoundation.org>
 <c46e40a7-d110-0968-e331-987e77c565a5@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c46e40a7-d110-0968-e331-987e77c565a5@seco.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 29, 2022 at 11:00:19AM -0500, Sean Anderson wrote:
> Hi Greg,
> 
> On 12/28/22 09:34, Greg Kroah-Hartman wrote:
> > From: Sean Anderson <sean.anderson@seco.com>
> > 
> > [ Upstream commit 36926a7d70c2d462fca1ed85bfee000d17fd8662 ]
> > 
> > On the T208X SoCs, MAC1 and MAC2 support XGMII. Add some new MAC dtsi
> > fragments, and mark the QMAN ports as 10G.
> > 
> > Fixes: da414bb923d9 ("powerpc/mpc85xx: Add FSL QorIQ DPAA FMan support to the SoC device tree(s)")
> > Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> This shouldn't be backported without [1].

Thanks, I'll drop this from everywhere.

greg k-h
