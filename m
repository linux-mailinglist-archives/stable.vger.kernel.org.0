Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F12095E99E7
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 08:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiIZGwO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 02:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233626AbiIZGwL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 02:52:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6982275DC;
        Sun, 25 Sep 2022 23:52:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79C51B80D99;
        Mon, 26 Sep 2022 06:52:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89A9C433C1;
        Mon, 26 Sep 2022 06:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664175128;
        bh=XNNFMGS8B2n+QvdgSptFn8UGirUjUYDqei0fT1bBzFE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NsV8iXupRLtGXmF7mw55uzjbT19XdJ39pWiNa4weqA51WLsMqe7koQ1t5OypfxXK7
         1PJQRSCUKTIquIeLHWxfHAr0I3dygmZnqFQ3XPYkq9yW3QgYHKs/MXGAva8moy0wnR
         vEsi1p42RHkfoSfnAzR2t1Dkfl70UXKtOu4um1n0=
Date:   Mon, 26 Sep 2022 08:52:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, amir73il@gmail.com,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 5.4 V2 00/19] xfs stable patches for 5.4.y (from v5.5)
Message-ID: <YzFMFWDw8iHPzYZj@kroah.com>
References: <20220924125656.101069-1-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220924125656.101069-1-chandan.babu@oracle.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 24, 2022 at 06:26:37PM +0530, Chandan Babu R wrote:
> Hi Greg,
> 
> This 5.4.y backport series contains fixes from v5.5. The patchset has
> been acked by Darrick.
> 
> Changelog:
>  V1 -> V2:
>   1. Added two patches which fix regressions that were introduced by
>      two patches present in the V1 patchset.

Now queued up, thanks.

greg k-h
