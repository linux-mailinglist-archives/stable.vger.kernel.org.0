Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA576D3EC1
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 10:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbjDCIQo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 04:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbjDCIQn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 04:16:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A68AF1C
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 01:16:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B94B2615E4
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 08:16:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1B29C433EF;
        Mon,  3 Apr 2023 08:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680509797;
        bh=0YMLdEs0miuZYv+8l/b1W0dp0h04xzmEmWYsm7UgisQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fJO0Wbi4QE6ZaaKifiS8Z60A/QB+EJFHcPjXawuiuugwzfZi5f9LSCMmfEYS/MCKX
         3Ej98zYS/U6Km4VSJSIWIruuzCOt3kFOGGXpAJn8KYNEMj4SE+Uazf6lN0SpzCS4mk
         NEALg43gmsSnqj1irkUgkrg99pVCKpT8PitFbUdA=
Date:   Mon, 3 Apr 2023 10:16:34 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] block/io_uring: pass in issue_flags for
 uring_cmd task_work" failed to apply to 6.1-stable tree
Message-ID: <2023040359-marine-bonded-22b7@gregkh>
References: <168000366614476@kroah.com>
 <efd0f445-a958-0cc5-870f-b2ff5c7a57e0@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <efd0f445-a958-0cc5-870f-b2ff5c7a57e0@kernel.dk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 28, 2023 at 12:35:54PM -0600, Jens Axboe wrote:
> On 3/28/23 5:41 AM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 6.1-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here's a backport of this one, thanks.

Thanks, that worked!

