Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 427F16C1490
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 15:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbjCTOVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 10:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbjCTOVq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 10:21:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE801F5F0
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 07:21:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB6F461543
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 14:21:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30B9C433AE;
        Mon, 20 Mar 2023 14:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679322105;
        bh=Bd/Exc1kzF9FwKljwEIzsaaIe1rp3rhnaUFDbUH8hRA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fsdjLbS/fr8AO//Q/qrm1YVwHOjhlez8kv08ko8Z956j9CNs7zwbCws8WAHxVmfuF
         K7bIAi+kItguHhz9a6JKgGpgLdIK5OPy5wbrq4LiTMcZ/X68NCXs0YuVzPmJ1Mlvi5
         Qs9/drHD2Qx57Nmg2zkH6LBMO//tDRwLnilOx5+s=
Date:   Mon, 20 Mar 2023 15:21:42 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Lee Jones <lee@kernel.org>
Cc:     stable@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH v4.9.y 1/2] HID: core: Provide new max_buffer_size
 attribute to over-ride the default
Message-ID: <ZBhr9hJSVjmq1257@kroah.com>
References: <20230320130957.2772257-1-lee@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230320130957.2772257-1-lee@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 20, 2023 at 01:09:56PM +0000, Lee Jones wrote:
> commit b1a37ed00d7908a991c1d0f18a8cba3c2aa99bdc upstream.

4.9.y is long end-of-life, sorry.

All other backports are now queued up, thanks.

greg k-h
