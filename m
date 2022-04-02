Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 481A34F00E1
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 13:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240091AbiDBLCv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 07:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiDBLCu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 07:02:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 087EC5C64A
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 04:00:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 953106130C
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 11:00:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95345C340EE;
        Sat,  2 Apr 2022 11:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648897258;
        bh=ezOukuLurbs/KLEmmkQlpuS/N2BmFEEo/sZ6OYN2KTQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QWcVk2v7x+w+bNxpd1SIEuCz+CtHJgkorF4hjVtIDf712BbhPPzyL9AH4OT4kMLIV
         8cFsj+NTGCCZonFfMtSMnuP8DtdBljP29ySuofP5IUqaOCexEfxcKFGUrzA+r6maH9
         /0Lk4c85iFx1ZHknxYfKrOOh7UefbJURAK5cCa5A=
Date:   Sat, 2 Apr 2022 13:00:55 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     dri-devel@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [PATCH 0/1] drm/simpledrm: Add "panel orientation" property on
 non-upright mounted LCD panels
Message-ID: <Ykgs59VBVfU3v5jR@kroah.com>
References: <20220402093029.5334-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220402093029.5334-1-hdegoede@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 02, 2022 at 11:30:28AM +0200, Hans de Goede wrote:
> Hi Greg,
> 
> Fedora 36 has switched from efifb to simpledrm as the pre-native-GPU driver
> fb provider and the lack of this patch is causing issues for devices with
> non up-right mounted LCD panels (1), can you please add this to the 5.17 stable
> series?
> 
> Regards,
> 
> Hans
> 
> 1) https://bugzilla.redhat.com/show_bug.cgi?id=2071134
> 
> 
> Hans de Goede (1):
>   drm/simpledrm: Add "panel orientation" property on non-upright mounted
>     LCD panels
> 
>  drivers/gpu/drm/tiny/simpledrm.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> -- 
> 2.35.1
> 

Now queued up, thanks.

greg k-h
