Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC83667296
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 13:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbjALMvW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 07:51:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbjALMuz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 07:50:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4632B4FCE5
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 04:50:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECCFDB81DD5
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 12:50:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF0BC433D2;
        Thu, 12 Jan 2023 12:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673527847;
        bh=sadXOzPmXim6CcqW8Jclh+ryrYj8qf5UA8P2plWNoLI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hz99nnYt9L62v2GjapupKW5y8UVfQk2DWRCtPQizCbz0cpAb8FwyomdO+/4Ji+4w4
         kz8PpgJvNeBRscslzaZFkQzh1UbERX1PsbjmQHxDCk0fIIHOAOByLKKTwgALfbdL4J
         rxYjSmCfObP1+pHNT7RogC7Of+4d++woPttJbCFA=
Date:   Thu, 12 Jan 2023 13:50:44 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     stable@vger.kernel.org, matthieu.baerts@tessares.net,
        pabeni@redhat.com, mptcp@lists.linux.dev
Subject: Re: [PATCH 5.10 0/4] mptcp: Stable backports for MPTCP request sock
 fixes
Message-ID: <Y8ACJJeUzvn3j9Rx@kroah.com>
References: <20230107014631.449550-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230107014631.449550-1-mathew.j.martineau@linux.intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 06, 2023 at 05:46:27PM -0800, Mat Martineau wrote:
> Greg -
> 
> Here are backports of the MPTCP patches, and one prerequisite, that
> recently failed to apply to the 5.10 stable tree. They prevent IPv6
> memory leaks with MPTCP.

All now queued up, thanks.

greg k-h
