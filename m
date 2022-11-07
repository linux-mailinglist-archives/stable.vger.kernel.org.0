Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8682961EE3E
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 10:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbiKGJIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 04:08:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbiKGJIL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 04:08:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F17165BA;
        Mon,  7 Nov 2022 01:08:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE5E4B80E6D;
        Mon,  7 Nov 2022 09:08:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA41C433D6;
        Mon,  7 Nov 2022 09:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667812087;
        bh=OhByz0T9SQQs92Itd0spYibA9KnFzTYX2OAXyF3uH58=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QqsjNSlrsfllLC6v2KlBLnD9RAtf8YmqVwNIGE67VhSqi8md3hsXvlpnjDVgOxVNl
         b/V4xoLtENXfCKdMzfnW8hA/BAihMtWk3Ew241HuT7vvGkpj0xk6eMp4DeZlDnOtB7
         iNe2FBO1pBji/WM9wTcahXCsF5+HvP72fo/vebMc=
Date:   Mon, 7 Nov 2022 10:07:58 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 5.10 0/3] fscrypt fixes for stable
Message-ID: <Y2jK7kjycJrpJq5a@kroah.com>
References: <20221104233800.421135-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104233800.421135-1-ebiggers@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 04, 2022 at 04:37:57PM -0700, Eric Biggers wrote:
> Please apply these to 5.10-stable.
> 
> Eric Biggers (3):
>   fscrypt: simplify master key locking
>   fscrypt: stop using keyrings subsystem for fscrypt_master_key
>   fscrypt: fix keyring memory leak on mount failure

Now queued up, thanks.

greg k-h
