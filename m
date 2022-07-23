Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5583757EFD4
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 16:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbiGWOwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 10:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbiGWOwh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 10:52:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C901E3F5;
        Sat, 23 Jul 2022 07:52:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11C94B8092F;
        Sat, 23 Jul 2022 14:52:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC40C341C0;
        Sat, 23 Jul 2022 14:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658587954;
        bh=eHGhJ9gT5hbsaF5ne4IhQFx6DfM/kznHBz4j3QNAFyU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wxodx3+zAsm0XiEbE3jw6YNNywhqynaK28nIT8AcIzHvhFoVT1zmIXMDlmXG45CFd
         NfY8R+wL8UyExZ6+RhMoqBPSvo6tKE/P+/IVdduH//9Cae0uMHuoBOvs/aGgJhTfL9
         R1/IQm4BXaOV9l1b+826TQBDHUItZ5Ks7ijSw5e4=
Date:   Sat, 23 Jul 2022 16:52:31 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Demi Marie Obenour <demi@invisiblethingslab.com>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: Backport of 166d38632316 ("xen/gntdev: Ignore failure to unmap
 INVALID_GRANT_HANDLE")
Message-ID: <YtwLL6hONAyOwjT6@kroah.com>
References: <20220723034415.1560-1-demi@invisiblethingslab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220723034415.1560-1-demi@invisiblethingslab.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 22, 2022 at 11:44:10PM -0400, Demi Marie Obenour wrote:
> This series backports upstream commit 166d3863231667c4f64dee72b77d1102cdfad11f
> to all supported stable kernel trees.

All now queued up, thanks.

greg k-h
