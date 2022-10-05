Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 791A15F52B2
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 12:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiJEKgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 06:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiJEKgU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 06:36:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E240358537;
        Wed,  5 Oct 2022 03:36:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83701B81D52;
        Wed,  5 Oct 2022 10:36:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD075C43470;
        Wed,  5 Oct 2022 10:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664966177;
        bh=8XbabgE1D0oEFJS9S4bP6rY02PJRzXpydbpzjWIRZVQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sjj3pZW/wzR/tM02IEmybZybpCTy7jo2zFW+HAnZFD0pD3z/r3MYcUiy5lP3v2s6i
         OOQ/y1rKs8XqrnKvbBQsDaUDQ0PHGm6Bwm0GaZOeAzz+3NVdo9mnClZMZEgu7W+1Wj
         I3QJp1+RpR4Jy6tRQfat9YGfzKjPqtrtPz0boPmU=
Date:   Wed, 5 Oct 2022 12:35:52 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, amir73il@gmail.com,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 5.4 00/11] xfs stable candidate patches for 5.4.y (from
 v5.6)
Message-ID: <Yz1eCHncGRfFQ8ga@kroah.com>
References: <20221005070105.41929-1-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221005070105.41929-1-chandan.babu@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 05, 2022 at 12:30:54PM +0530, Chandan Babu R wrote:
> Hi Greg,
> 
> This 5.4.y backport series contains XFS fixes from v5.6. The patchset
> has been acked by Darrick.

All now queued up, thanks.

greg k-h
