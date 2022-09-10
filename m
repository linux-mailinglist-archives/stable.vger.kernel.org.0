Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2F2F5B44AE
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 08:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbiIJGfZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 02:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbiIJGfO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 02:35:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ECA515FC7
        for <stable@vger.kernel.org>; Fri,  9 Sep 2022 23:34:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 076FBB80682
        for <stable@vger.kernel.org>; Sat, 10 Sep 2022 06:34:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 437A5C433C1;
        Sat, 10 Sep 2022 06:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662791657;
        bh=ATLAj0JuRaO2FN8aPLJKrolLYUopwlXB6D8c6azjBJQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ldrf4DHWm95J1OwnVKVRGbmnl8fLq3wSI152vU+/rCXB5s0co+8Ty3ArrbcoOq3Fq
         jpd/DATtBOcfESXi8CR5TGB8YcOwZSRl029cQHDxfcf85lyN+whpzN8tslpGV1Lb6o
         SmrPjMnNVgrs6WF68Ls2XUG1COYpw/kFpS1AgVHs=
Date:   Sat, 10 Sep 2022 08:34:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ye Weihua <yeweihua4@huawei.com>
Cc:     stable@vger.kernel.org
Subject: Re: Backport patch "mm: fix missing handler for __GFP_NOWARN" to
 linux-5.10.y
Message-ID: <Yxwv/82jkMjew4ZN@kroah.com>
References: <38acddc1-143c-469e-c918-93b5589068c9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <38acddc1-143c-469e-c918-93b5589068c9@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 09, 2022 at 11:40:07AM +0800, Ye Weihua wrote:
> The following patch is required to be patched in linux-5.10.y:
> 
> 
>     3f913fc5f974 mm: fix missing handler for __GFP_NOWARN
> 
> 
> Commit 6b9dbedbe349 ("tty: fix deadlock caused by calling printk() under
> tty_port->lock")
> 
> was backported to linux-5.10.y. But __GFP_NOWARN flag is still not check in
> fail_dump(), and
> 
> deadlock issues still occur.
> 

What about all of the other stable kernel trees that the tty patch was
backported to?  Do they also need the mm change as well?  That would
include 4.9.y, 4.14.y, 4.19.y, 5.4.y, 5.10.y, and 5.15.y.

thanks,

greg k-h
