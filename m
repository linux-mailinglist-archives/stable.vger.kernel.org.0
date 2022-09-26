Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 959995EAD5D
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 18:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbiIZQ7S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 12:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbiIZQ67 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 12:58:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E50BFF;
        Mon, 26 Sep 2022 08:56:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D351B80AF7;
        Mon, 26 Sep 2022 15:56:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7BA6C433D6;
        Mon, 26 Sep 2022 15:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664207801;
        bh=ArnDF5MRuhhxGhxCbkUf3CKTJ039fI853Wb+yC8IojY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t/Z6aX8EZv1aU8UGtFgqXbDMb48cHbecnykfBamiGxpC6WN6DJYyMhNurD151NHRj
         J3iC1tnnoF2q7yPC5fMZwF5hjAK8fphR18UHqj8OmmyzdCXf+sCELTpX+c46FZc4so
         Sy5vSK92bPMirvqeBbet3dF0/Jib9NVtwCCLw1bA=
Date:   Mon, 26 Sep 2022 17:56:38 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Kees Cook <keescook@chromium.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.14 05/40] efi/libstub: Disable Shadow Call Stack
Message-ID: <YzHLtttzBVeg8gpM@kroah.com>
References: <20220926100738.148626940@linuxfoundation.org>
 <20220926100738.422260948@linuxfoundation.org>
 <20220926111408.GF8978@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926111408.GF8978@amd>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 26, 2022 at 01:14:08PM +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Sami Tolvanen <samitolvanen@google.com>
> > 
> > [ Upstream commit cc49c71d2abe99c1c2c9bedf0693ad2d3ee4a067 ]
> > 
> > Shadow stacks are not available in the EFI stub, filter out SCS
> > flags.
> 
> AFAICT, SCS is not available in 4.19, CC_FLAGS_SCS is not defined
> there, and we should apply this patch.

Now dropped from everywhere, thanks.

greg k-h
