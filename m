Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8FD06EE434
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 16:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234377AbjDYOru (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 10:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234232AbjDYOrs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 10:47:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F384C558A
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 07:47:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59D2D61765
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 14:47:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4888CC4339B;
        Tue, 25 Apr 2023 14:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682434063;
        bh=M3ZbDEgb2ssOovZh/hG1m8GiYo2lyFEaIM6ZdjIhAtg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wiEFeUn5Fg/NEidGEfjlY9Hz35NRacS/URFPRiZ4TGRI3Ddf9D4AUeTEqub+u146j
         sEGcKFC0brlTwZ3IXTuomRwOfcuzCPug6geSQiYtToU5MsKK4VLDXEpCNmKeVX+sFO
         x5rpUxBeSk+T4DwJJbHcpVJUBn8GmSKujwVcsDv4=
Date:   Tue, 25 Apr 2023 16:47:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kristof Havasi <havasiefr@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Subject: Re: Does v5.4 need CVE-2022-3566 and CVE-2022-3567 patches
Message-ID: <ZEfoC9UDzniw6mo_@kroah.com>
References: <CADBnMvgH1H_+WNSdQ=hJp15v4jh0nwFZVkggeiCSWaFHtzORJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADBnMvgH1H_+WNSdQ=hJp15v4jh0nwFZVkggeiCSWaFHtzORJQ@mail.gmail.com>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 25, 2023 at 04:08:30PM +0200, Kristof Havasi wrote:
> Hi there,
> 
> I was evaluating CVE-2022-3567 and CVE-2022-3566 which both
> revolt around load tearing and reference an ancient Kernel commit:
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> 
> I am not sure whether they are applicable to the v5.4.y branch as well.

I do not know, what specific commits are you referring to?  CVEs mean
nothing, they are not valid identifiers, sorry.

And have you tried applying them to the older kernels and testing to see
if they solve any specific issue?

Or better yet, why use the older kernels, why not stick to the most
recent one?  What is preventing you from switching?

thanks,

gre gk-h
