Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 111B958C9A9
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 15:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235651AbiHHNns (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Aug 2022 09:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234710AbiHHNnr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Aug 2022 09:43:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7CF2DD4;
        Mon,  8 Aug 2022 06:43:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39A8F6069F;
        Mon,  8 Aug 2022 13:43:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A28C433C1;
        Mon,  8 Aug 2022 13:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659966225;
        bh=nfCLhuo/af3d1Kxx50lesHmUHkqwUMorAUzMRJ3p9g8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nsYL8wLw+NtwhL/fDfhkt2i2pLnGwFwXAie1kcWmhtL35R/wSG2rYHqKDGxPI/++o
         qQFDgklhvPKGo7WdsD35vbmIgcBrF4ViC9ftWA/oh726sN21B51v7GU+SZGx/PKiv6
         eAFOUhGymrugGx2lYCxDS08blRKSzxDotEPKzTos=
Date:   Mon, 8 Aug 2022 15:43:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH STABLE 4.9 5.4 0/2] btrfs: raid56 backports to reduce
 destructive RMW
Message-ID: <YvETDmzlSBMpObNm@kroah.com>
References: <cover.1659599526.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1659599526.git.wqu@suse.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 04, 2022 at 03:54:17PM +0800, Qu Wenruo wrote:
> Hi Greg and Sasha,
> 
> This two patches are backports for stable branchs from v4.9 to v5.4.

Please note that these commits are not even in a public release from
Linus yet, so I would need a LOT of assurance from the BTRFS maintainers
that they are all allowed to be taken now as that goes against the
normal development cycle here.

thanks,

greg k-h
