Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA60A5AB49A
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 17:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236631AbiIBPAD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 11:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236650AbiIBO7o (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 10:59:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 743B7F8F7B;
        Fri,  2 Sep 2022 07:27:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 353ABB82C3B;
        Fri,  2 Sep 2022 14:27:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF50C433C1;
        Fri,  2 Sep 2022 14:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662128870;
        bh=tQY7/HHQWHScexKcExDCv7i+nSy1eJGSaTIyODbVfsA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Li9ryciRD3E/4bnTvp/mVWlHl93v3lvWLC7i89FZX4W/7LGUDqmpae0fv31C1qTa0
         cHcHSRTPPP216AJiMkPpjMsW7Dbs0KuCAFpkB8XbdfHYyFsk9BfDLfYyXEyvqnNKgA
         DWtjkYp6QvaM9FcivsbOF93QUG79vA0xxiGYEj7w=
Date:   Fri, 2 Sep 2022 16:27:46 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Varsha Teratipally <teratipally@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Manfred Spraul <manfred@colorfullife.com>,
        Davidlohr Bueso <dbueso@suse.de>,
        Rafael Aquini <aquini@redhat.com>,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Request to cherry-pick 20401d1058f3f841f35a594ac2fc1293710e55b9
 to v5.10 and v5.4
Message-ID: <YxIS4jWE03E5pZjS@kroah.com>
References: <20220902135912.816188-1-teratipally@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220902135912.816188-1-teratipally@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 02, 2022 at 01:59:11PM +0000, Varsha Teratipally wrote:
> Hi all,
> 
> Commit 20401d1058f3f841f35a594ac2fc1293710e55b9("ipc: replace costly
> bailout check in sysvipc_find_ipc()" fixes a high cve and optimizes the
> costly loop by adding a checkpoint, which I think might be a good
> candidate for the stable branches

What do you mean by "high cve"?

And that feels like it's an artificial benchmark fixup, what real
workload benefits from this change?

thanks,

greg k-h
