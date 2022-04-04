Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA86B4F1049
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 09:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358267AbiDDHv0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 03:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347554AbiDDHvX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 03:51:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5CDB26117;
        Mon,  4 Apr 2022 00:49:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 526136123E;
        Mon,  4 Apr 2022 07:49:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6603DC2BBE4;
        Mon,  4 Apr 2022 07:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649058566;
        bh=AoiHI2nGjs21fXdHt44B/SOkaBG2cktvg1RoLP5GUNQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FXkYDEIAYyQ6mAzM0f8Q1KO9Cv9fD2oab8cDuj1NalBNo7BV1eurVJykhNGlVvrah
         XyzZKQ7woNh+ig6bsuZPTZy1LvvMQixmZjeQBXXTzTyjEyYKwnBhWw8EW+VsMa6a1k
         9LE67NwFqi61nP/Em5Z/bYmcpuw247j7HaaqbHRM=
Date:   Mon, 4 Apr 2022 09:49:24 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Chen Jingwen <chenjingwen6@huawei.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] [Rebased for 5.4] powerpc/kasan: Fix early region not
 updated correctly
Message-ID: <YkqjBFVqgHtUojdC@kroah.com>
References: <d4d9f1d352e617848a8ec19013fcce8d0cf2ceea.1648993765.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4d9f1d352e617848a8ec19013fcce8d0cf2ceea.1648993765.git.christophe.leroy@csgroup.eu>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Apr 03, 2022 at 03:49:43PM +0200, Christophe Leroy wrote:
> From: Chen Jingwen <chenjingwen6@huawei.com>
> 
> This is backport for 5.4
> 
> Upstream commit dd75080aa8409ce10d50fb58981c6b59bf8707d3

Now queued up, thanks.

greg k-h
