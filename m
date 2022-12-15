Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D097464D8F1
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 10:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbiLOJsC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 04:48:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiLOJrh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 04:47:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 978BA19C25
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 01:46:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44F35B819B4
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 09:46:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C53C433EF;
        Thu, 15 Dec 2022 09:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671097606;
        bh=lx+rV5uueEQ5fb/PFo36Z/Pxl5a59hfrMqfij69X/io=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kM5N4Z9Htb8ZNFPyyonyLMYrh7myiFcp0ggcq8Iei9olVRhx6o9wc3IatXzuy72Vh
         fo4Ffi9sWJkUMj+kjoDjadV0HgVrRe2/6oK/4Qrte41QMnvPb5ClqYM1ZyseW7q3qX
         TR59n5QwI2a1oXX5QHFmwnKm3hG7d5IhOpabPG/U=
Date:   Thu, 15 Dec 2022 10:46:35 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Wu Bo <bo.wu@vivo.com>
Cc:     stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        Ken Schalk <kschalk@nvidia.com>
Subject: Re: [PATCH 5.10] fuse: always revalidate if exclusive create
Message-ID: <Y5rs+9XEFSAcXCir@kroah.com>
References: <20221215093408.43407-1-bo.wu@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215093408.43407-1-bo.wu@vivo.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 15, 2022 at 05:34:08PM +0800, Wu Bo wrote:
> From: Miklos Szeredi <mszeredi@redhat.com>
> 
> commit df8629af293493757beccac2d3168fe5a315636e upstream.
> 
> Failure to do so may result in EEXIST even if the file only exists in the
> cache and not in the filesystem.
> 
> The atomic nature of O_EXCL mandates that the cached state should be
> ignored and existence verified anew.
> 
> Change-Id: I0f173de6f9f1af05d6e816246b5c56b670ec079c

Where did this change-id come from?

thanks,

greg k-h
