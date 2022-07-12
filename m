Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1853F571D05
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 16:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233642AbiGLOmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 10:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233643AbiGLOlv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 10:41:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56920BBD1D;
        Tue, 12 Jul 2022 07:41:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6CD861956;
        Tue, 12 Jul 2022 14:41:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA632C3411C;
        Tue, 12 Jul 2022 14:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657636899;
        bh=Us6tXtpWdlN87UFBQiDUiwgUvv7JgqrvXg6ws7noKaw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D3QYU0hsmxMKL/gn81WY+UfS4eJ0LvRRY7aHq1YwJ5/oa53UHRvo8+aLALEREn3T0
         8ANwHCr9M/PYFZ7TI6kmuQ/gLr2QpcdTRRu7JmuA9HG3Cc5scm+/E4yOsLvLxtYwHR
         kB+2Fo4JnenNevCtY99bP00Wi19s7SOmi13+uf5A=
Date:   Tue, 12 Jul 2022 16:41:34 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ronald Warsow <rwarsow@gmx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.18 000/112] 5.18.11-rc1 review
Message-ID: <Ys2IHtSG7Jxuh5bO@kroah.com>
References: <b758ebfd-f153-c0e6-14f9-d66c760b2e11@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b758ebfd-f153-c0e6-14f9-d66c760b2e11@gmx.de>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 12, 2022 at 01:46:35PM +0200, Ronald Warsow wrote:
> hallo Greg
> 
> 5.18.11-rc1
> 
> compiles, boots and runs here on x86_64
> (Intel i5-11400, Fedora 36)
> 
> Thanks
> 
> Tested-by: rwarsow@gmx.de

In the future, please use the proper format:
	Tested-by: My Name <my email address>

thanks,

greg k-h
