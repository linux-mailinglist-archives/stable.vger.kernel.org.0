Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6544C52835C
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 13:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243190AbiEPLgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 07:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243281AbiEPLfY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 07:35:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2687338D9F;
        Mon, 16 May 2022 04:34:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00A3FB810DC;
        Mon, 16 May 2022 11:34:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD11C34115;
        Mon, 16 May 2022 11:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652700873;
        bh=VIjeUm3LaYeCFJmbQbH2oscDVvuWwsjB79z0orF+OQ4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=123ai4KiWcVioC5eWiG96njqc7mLD+88+JlzflnckRhREJInge3086Aml+/cAHy5B
         CZxLi6GGW3cXZaF1Zh+tYXm/ab4RLAkd8sg3zWqimmilwkG+ToucUXyC/p7s1lsz9p
         RA+/Whe5PNM+81RBpcWZBNofUdNy32eAzGn1LiQY=
Date:   Mon, 16 May 2022 13:34:30 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Cc:     stable-commits@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Patch "serial: 8250_mtk: Make sure to select the right
 FEATURE_SEL" has been added to the 5.17-stable tree
Message-ID: <YoI2xgS/dNXdDTyN@kroah.com>
References: <165268940760187@kroah.com>
 <20b50545-0a0b-b59c-83c1-0e76fe9694c3@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20b50545-0a0b-b59c-83c1-0e76fe9694c3@collabora.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 16, 2022 at 10:57:30AM +0200, AngeloGioacchino Del Regno wrote:
> Il 16/05/22 10:23, gregkh@linuxfoundation.org ha scritto:
> > 
> > This is a note to let you know that I've just added the patch titled
> > 
> >      serial: 8250_mtk: Make sure to select the right FEATURE_SEL
> > 
> > to the 5.17-stable tree which can be found at:
> >      http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > 
> > The filename of the patch is:
> >       serial-8250_mtk-make-sure-to-select-the-right-feature_sel.patch
> > and it can be found in the queue-5.17 subdirectory.
> > 
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> > 
> 
> Hello,
> 
> please do *not* backport this FEATURE_SEL patch, issues have been found with
> that one and a revert has also been sent:
> 
> https://patchwork.kernel.org/project/linux-mediatek/patch/20220510122620.150342-1-angelogioacchino.delregno@collabora.com/

Ah yeah, I'll go queue that up to my tty tree now and drop this one,
thanks!

greg k-h
