Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6FA5AE954
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240005AbiIFNTt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240405AbiIFNTr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:19:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737DD1EC61;
        Tue,  6 Sep 2022 06:19:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1C45B8172B;
        Tue,  6 Sep 2022 13:19:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D44C43140;
        Tue,  6 Sep 2022 13:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662470382;
        bh=BTg9gQUger7R1N0lK9WoWSHjauuapLO0VcAWfc3zmBA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zyN/UhP+4EaNxECr4XgVq2GdAa6RhrcuEKfzizcAulG75063HQVwdA09pRQwIApar
         ahc9six/M1tUB06HjzQ6JSza6+pNwbMB0CfAZsKIlAejCnZdtkOzrBygj7UsKRBi9R
         fZF9K+hejZfRCcI2/7Jc0okIHvIgHGLgDo95KJPU=
Date:   Tue, 6 Sep 2022 15:19:38 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH stable-5.15 0/2] USB: serial: ch341: backports to 5.15
Message-ID: <YxdI6mtLKqW/s3WQ@kroah.com>
References: <20220906122127.31321-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906122127.31321-1-johan@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 06, 2022 at 02:21:25PM +0200, Johan Hovold wrote:
> Here are backports of two patches that failed to apply to 5.15 and older
> stable trees.
> 
> Only the first one actually needed to have some context adjusted.

Applied to 5.10.y and 5.15.y.  didn't apply to anything older, odds are
no one cares about this driver for those kernels anyway :)

thanks,

greg k-h
