Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3736E5B6EA3
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 15:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbiIMNyQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 09:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbiIMNyO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 09:54:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D30C4F392;
        Tue, 13 Sep 2022 06:54:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAF6261451;
        Tue, 13 Sep 2022 13:54:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 768D4C433C1;
        Tue, 13 Sep 2022 13:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663077252;
        bh=8xIW2rJwihfScb+TqeOm4x25/yZ8HtZ+skFaX9eEuhY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xrpr2/PaglYh+LuDJE2eWT9kq5bqj6/qBaMBd1adXCZiifdwSuCsCWWW9DmsCUSXq
         i3A3L5U+cRBnUwEMlCO8Pg9z8Ev4UhmPJouO8lBER6DnRS0YTOG/WhO0Nomi2yJWWk
         RAUi5nESWfejhYyNC+AxadmS7XCBHOE/XMRBBdKQ=
Date:   Tue, 13 Sep 2022 15:54:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     yong <yongw.pur@gmail.com>
Cc:     jaewon31.kim@samsung.com, mhocko@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        wang.yong12@zte.com.cn
Subject: Re: [PATCH v4] page_alloc: consider highatomic reserve in watermark
 fast
Message-ID: <YyCLm0ws8qsiEcaJ@kroah.com>
References: <ab879545-d4b2-0cd8-3ae2-65f9f2baf2fe@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab879545-d4b2-0cd8-3ae2-65f9f2baf2fe@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 13, 2022 at 09:09:47PM +0800, yong wrote:
> Hello,
> This patch is required to be patched in linux-5.4.y and linux-4.19.y.

What is "this patch"?  There is no context here :(

> In addition to that, the following two patches are somewhat related:
> 
> 	3334a45 mm/page_alloc: use ac->high_zoneidx for classzone_idx
> 	9282012 page_alloc: fix invalid watermark check on a negative value

In what way?  What should be done here by us?

confused,

greg k-h
