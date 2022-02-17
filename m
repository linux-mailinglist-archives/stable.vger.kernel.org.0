Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED9A74BA896
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 19:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234467AbiBQSpg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 13:45:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235553AbiBQSpd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 13:45:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB33DFBE
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 10:45:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2447B8236E
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 18:45:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8692C340E8;
        Thu, 17 Feb 2022 18:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645123516;
        bh=VGSuIcgIvcpd6c6sXsqtNBx96uVynzIqQ3dVAJrMQnw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K4LnhHJVuEx6HJHnFFl7K3054vkU66/u7rEY3PpG4DTefmEdV021cXepfR3BlYtzB
         QSKhNoG4pRDyIMdD60NoIaXdY46r6esq5vdwVO7YyHuKOfeUd7VZ8nSgGYqW11kZKf
         k0afmsLSVqHcEORqxU10bXY/a6hkW+mNBL8cfJNI=
Date:   Thu, 17 Feb 2022 19:45:13 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Karol Herbst <kherbst@redhat.com>
Cc:     stable@vger.kernel.org
Subject: Re: Backport request: drm/nouveau/pmu/gm200-: use alternate falcon
 reset sequence
Message-ID: <Yg6XudxfhB2vH/Kn@kroah.com>
References: <CACO55tsiiuhuTFiTqFO4bqjex87AiMN4q18ovCFSF=+HW9uT9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACO55tsiiuhuTFiTqFO4bqjex87AiMN4q18ovCFSF=+HW9uT9A@mail.gmail.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 16, 2022 at 12:34:45PM +0100, Karol Herbst wrote:
> subject: drm/nouveau/pmu/gm200-: use alternate falcon reset sequence
> commit id: 4cdd2450bf739bada353e82d27b00db9af8c3001
> kernels: 5.16 5.15 and 5.10
> 
> 1d2271d2fb85e54bfc9630a6c30ac0feb9ffb983 got backported to a bunch of
> kernel versions, which wasn't really intentional from nouveaus side. I
> assume this happened because autosel picked it up due to the
> "Reported-by" tag? Anyway, It actually requires
> 4cdd2450bf739bada353e82d27b00db9af8c3001 as well in order to not
> regress systems. One bug report can be found here:
> https://gitlab.freedesktop.org/drm/nouveau/-/issues/149
> 
> Users did test that applying 4cdd2450bf739bada353e82d27b00db9af8c3001
> on top fixes the problems.

Thanks, now queued up.

> We still want to figure out what to do with 5.4 and older, because the
> fix doesn't apply there, so we will either request a revert or send
> modified patches.

A revert is fine if you want to send me that.

thanks,

greg k-h
