Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D93D951E507
	for <lists+stable@lfdr.de>; Sat,  7 May 2022 09:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353816AbiEGHJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 May 2022 03:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239988AbiEGHJt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 May 2022 03:09:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D135541B5;
        Sat,  7 May 2022 00:06:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BBAE5B80CB7;
        Sat,  7 May 2022 07:06:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4539C385A5;
        Sat,  7 May 2022 07:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651907160;
        bh=qwSy8KX+r7vn0S4Djy5+UPC1jZRCNM6ihNYVtELPlVs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oXhx8ZJtl3cEAwR6coAnbItRzC44ZHxHZGaub/YrIOThAcXRh0kH43PzrX6HC4Oic
         zHenTmpeaklHaXT61P3vnnCEWQjqmhE/EaLEvsiPDA2DG299YNcOrkV+C7LqZrMTAl
         dlz066J7FWaSYh+i8XWPpQ5S1CpzbDhxFvBpPAkY=
Date:   Sat, 7 May 2022 09:05:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] rfkill: uapi: fix RFKILL_IOCTL_MAX_SIZE ioctl request
 definition
Message-ID: <YnYaVeCJA1VQuYie@kroah.com>
References: <20220506171534.99509-1-glebfm@altlinux.org>
 <20220506172454.120319-1-glebfm@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506172454.120319-1-glebfm@altlinux.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 06, 2022 at 05:24:54PM +0000, Gleb Fotengauer-Malinovskiy wrote:
> Fixes: 54f586a91532 ("rfkill: make new event layout opt-in")
> Cc: stable@vger.kernel.org # 5.11+
> Signed-off-by: Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>
> ---

No changelog text at all?  I know I don't take patches like that, maybe
other subsystem maintainers are more lax?

Please provide a changelog...

thanks,

greg k-h
