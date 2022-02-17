Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D05C4B99D4
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 08:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236208AbiBQH3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 02:29:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232960AbiBQH3m (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 02:29:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D472A0D7D;
        Wed, 16 Feb 2022 23:29:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF94EB820E4;
        Thu, 17 Feb 2022 07:29:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F291C340E8;
        Thu, 17 Feb 2022 07:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645082964;
        bh=pnXOxu90AJxyypH+8loU5y4SRFkkQnaJMq3XJR+O0fs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kwhqRrsClw2vfa5iA/JAjFW3WWNR98A+qjQnbCljCgnK+CxFyXXakrVrQSoM89RrI
         JZUiZQXWV2KE0yLiWz66Nf/JL59nkI6lV7Bnfo6bFEM4cEYa9MOhT2H54Vk1wiX3Ni
         ySdi5xZR8Sxb26SU2PQ9FjlKC3Cy70vBMbTcKbOY=
Date:   Thu, 17 Feb 2022 08:29:21 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     liqiong <liqiong@nfschina.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] mm: fix dereference a null pointer in
 migrate[_huge]_page_move_mapping()
Message-ID: <Yg35UXjB7RpqVCOI@kroah.com>
References: <20220217063808.42018-1-liqiong@nfschina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220217063808.42018-1-liqiong@nfschina.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 17, 2022 at 02:38:08PM +0800, liqiong wrote:
> Upstream has no this bug.

What do you mean by this?

confused,

greg k-h
