Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 466C863C7BF
	for <lists+stable@lfdr.de>; Tue, 29 Nov 2022 20:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236613AbiK2TDt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Nov 2022 14:03:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236641AbiK2TDa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Nov 2022 14:03:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321E795AA
        for <stable@vger.kernel.org>; Tue, 29 Nov 2022 11:03:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3E03B818A9
        for <stable@vger.kernel.org>; Tue, 29 Nov 2022 19:03:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D04C433D6;
        Tue, 29 Nov 2022 19:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669748599;
        bh=Znsm9roC2BHiOKZcl6/WD7mTZ4zLCB0yakgzR5M3fkE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CGpGRE7dL51Np9LFkCu1nuAKUlvhc2/+jhhxdHmFkSGOCfz14gbn/eVCMDoHyNAT9
         WVLF4pcEYYG2wWchZHjgfVB5Pbkmy4HBMX8rIetZSg6wgWwdy41cKOdYVbZPc+HJ2l
         HdOXQNK6P4YVInMuyDG2vDEwyLvCkoKdVkDKhVkY=
Date:   Tue, 29 Nov 2022 20:03:16 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: Stable backport request: kconfig/symbol.c
Message-ID: <Y4ZXdFPLP45YcJCD@kroah.com>
References: <CAEUSe7-V73jB83Vbv-5AYiOUn8+kXw_fRt74DNiz4gFwYs8mrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEUSe7-V73jB83Vbv-5AYiOUn8+kXw_fRt74DNiz4gFwYs8mrQ@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 23, 2022 at 05:55:14PM -0600, Daniel Díaz wrote:
> Hello!
> 
> Would the stable maintainers please consider backporting the following
> commit to the 4.9 and 4.14 stable branches?
> 
> commit e3b03bf29d6b99fab7001fb20c33fe54928c157a
> Author: Masahiro Yamada <yamada.masahiro@socionext.com>
> Date:   Sat Dec 16 00:28:42 2017 +0900

Now queued up, thanks.

greg k-h
