Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6B552D90C
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 17:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241589AbiESPtU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 11:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241642AbiESPtN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 11:49:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5CD108A83;
        Thu, 19 May 2022 08:45:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEBDF61BE0;
        Thu, 19 May 2022 15:45:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C921EC385AA;
        Thu, 19 May 2022 15:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652975134;
        bh=grMrez5z/qqSwQfDRZjfSNqC7wVFEopD1oJJWSiFoLc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jrk0HJqiDHGsWZNXPq68+mIaObqaevRudF9yM+wIPbrZ967oq1V/YgY1OopBbe2GL
         Hu5bwu2Ue/AV2h3DJuSxElAYPYVqaOKx49MzyHwMNCvAVDV8QgBGXsob+KRyapthIn
         OKzOQ2/3INec1Nf6Txp/YOn9ek493BKfBSCPslwk=
Date:   Thu, 19 May 2022 17:45:31 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Denis Efremov <denis.e.efremov@oracle.com>
Cc:     Larry.Finger@lwfinger.net, phil@philpotter.co.uk,
        dan.carpenter@oracle.com, straube.linux@gmail.com,
        linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: Re: [PATCH] staging: r8188eu: prevent ->Ssid overflow in
 rtw_wx_set_scan()
Message-ID: <YoZmG98rI7oK5qgf@kroah.com>
References: <YEHymwsnHewzoam7@mwanda>
 <20220518070052.108287-1-denis.e.efremov@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518070052.108287-1-denis.e.efremov@oracle.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 18, 2022 at 11:00:52AM +0400, Denis Efremov wrote:
> This code has a check to prevent read overflow but it needs another
> check to prevent writing beyond the end of the ->Ssid[] array.
> 
> Fixes: 2b42bd58b321 ("staging: r8188eu: introduce new os_dep dir for RTL8188eu driver")
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Denis Efremov <denis.e.efremov@oracle.com>
> ---
> 
> This patch is a copy of Dan's 74b6b20df8cf (CVE-2021-28660).
> Drivers r8188eu and rtl8188eu share the same code.

This does not apply to my tree at all. This file is not present anymore,
what tree did you make it against?

confused,

greg k-h
