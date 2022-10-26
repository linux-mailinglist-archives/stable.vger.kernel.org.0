Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C26B360E5D4
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 18:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbiJZQxB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 12:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233394AbiJZQxA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 12:53:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D89D2A705
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 09:52:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E833161FC8
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 16:52:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00BDCC433D6;
        Wed, 26 Oct 2022 16:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666803178;
        bh=yGoXyHbdfrJHP1OgismEfrYvD4y8uK0GSiZjNSknmHA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qiL0sw6pTUMVeBg3ACy5fhrrsc4SRi1vh8ycNi1oluWqW8EUnIGA+w/rIJhDa6D5g
         ovQVw2qhYJksd+ui5Z838ZQCiHiEN/4HwXpCYLkiZ7OW1b8eG7QMUL1vN3eD0MxvUo
         xIfXPu8Za0bNcZ2YKSzmR6dPBnOJl+49uvAjdSdQ=
Date:   Wed, 26 Oct 2022 18:52:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jean-Francois Le Fillatre <jflf_kernel@gmx.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] backport: r8152: PID for the Lenovo OneLink+ Dock
Message-ID: <Y1ll54KuNR/GUlIO@kroah.com>
References: <20221024214207.49365-1-jflf_kernel@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024214207.49365-1-jflf_kernel@gmx.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 24, 2022 at 11:42:07PM +0200, Jean-Francois Le Fillatre wrote:
> [ Upstream commit 1bd3a383075c64d638e65d263c9267b08ee7733c ]
> 
> The Lenovo OneLink+ Dock contains an RTL8153 controller that behaves as
> a broken CDC device by default. Add the custom Lenovo PID to the r8152
> driver to support it properly.
> 
> This backport removes the PID declaration for MAC address passthrough,
> for kernels that don't support the feature.
> 
> Applies to v4.14, v4.19, v5.4, v5.10
> 
> Signed-off-by: Jean-Francois Le Fillatre <jflf_kernel@gmx.com>

All now queued up, thanks.

greg k-h
