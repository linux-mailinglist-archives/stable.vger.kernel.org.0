Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54C336567E4
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 08:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbiL0HhU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 02:37:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbiL0HhS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 02:37:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C756465;
        Mon, 26 Dec 2022 23:37:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 322F460F90;
        Tue, 27 Dec 2022 07:37:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41EB4C433D2;
        Tue, 27 Dec 2022 07:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672126636;
        bh=pQnPE6E/xJO9E1lD8K29djauM+jLzO3hG3a4SnBs0T0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZwjHaGSnFdsRNisurOpXwgesMOIKMPezZUISOlXYNRzQeDiqlKA/ES7kmM91pWDai
         KPArISX/eaSnzVE1vHC6OBT0jOVDFjU7zGmJvdT/MWeU/bpo/fc0RPOe2ma8JD2x4F
         latXolE8G/1c7NPWDl1ztsgzmO7cIqO6e8nSEtAs=
Date:   Tue, 27 Dec 2022 08:37:12 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     GUO Zihua <guozihua@huawei.com>
Cc:     stable@vger.kernel.org, zohar@linux.ibm.com, paul@paul-moore.com,
        linux-integrity@vger.kernel.org, luhuaxin1@huawei.com
Subject: Re: [PATCH 2/2] ima: Handle -ESTALE returned by
 ima_filter_rule_match()
Message-ID: <Y6qgqO/LJ/wHUk5x@kroah.com>
References: <20221227014729.4799-1-guozihua@huawei.com>
 <20221227014729.4799-3-guozihua@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221227014729.4799-3-guozihua@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 27, 2022 at 09:47:29AM +0800, GUO Zihua wrote:
> [ Upstream commit c7423dbdbc9ecef7fff5239d144cad4b9887f4de ]

For obvious reasons we can not only take this patch (from 6.2-rc1) into
4.19.y as that would cause people who upgrade from 4.19.y to a newer
stable kernel to have a regression.

Please submit backports for all stable kernels if you wish to see this
in older ones to prevent problems like this from happening.

But also, why are you still on 4.19.y?  What is wrong with 5.4.y at this
point in time?  If we dropped support for 4.19.y in January, what would
that cause to happen for your systems?

thanks,

greg k-h

