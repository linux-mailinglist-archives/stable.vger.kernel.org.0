Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07A3E4E8D98
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 07:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236033AbiC1FvL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 01:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235040AbiC1FvK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 01:51:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C0CA51583
        for <stable@vger.kernel.org>; Sun, 27 Mar 2022 22:49:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C92C61035
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 05:49:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A743BC340F0;
        Mon, 28 Mar 2022 05:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648446570;
        bh=0zbZJTBV7Y0P7hb1nuQk/TlcWukonN/IuBzTc1ir9Ow=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PReVHSP6Y0DzLz9iqHhxHHPgQ0RUDt8CP8wM54ym14GXrIjCfzBh2h5aUtm+ySkK5
         gqtFitWepFxBD8lUWNUlgSVV3owcmUv6GAGW20QExl/NWUiEAU2VXGdPwPwaSh3YSx
         QPNm7jhOzCbHjbbRYxVDG4XmSgMgwl8I3OJkvdrY=
Date:   Mon, 28 Mar 2022 07:49:27 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Thorsten Glaser <t.glaser@tarent.de>
Cc:     Vlad Buslov <vladbu@mellanox.com>, stable@vger.kernel.org,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: v4.19.221 breaks qdisc modules
Message-ID: <YkFMZy+prbVe6bTS@kroah.com>
References: <919153d5-a79a-de71-9584-10179ae586d@tarent.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <919153d5-a79a-de71-9584-10179ae586d@tarent.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 27, 2022 at 11:39:10PM +0200, Thorsten Glaser wrote:
> Hi,
> 
> commit 92833e8b5db6c209e9311ac8c6a44d3bf1856659 breaks the
> build of sch_* modules in stable.

Where do these sch_* modules live?  In the kernel tree itself?  I have
not gotten any failed build errors here, what config option do I need to
enable?

thanks,

greg k-h
