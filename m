Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5A0760E5F5
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 18:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233951AbiJZQ7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 12:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234097AbiJZQ6z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 12:58:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9580AF1A8;
        Wed, 26 Oct 2022 09:58:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4618761FC9;
        Wed, 26 Oct 2022 16:58:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A1AFC433C1;
        Wed, 26 Oct 2022 16:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666803528;
        bh=MxMNVBq6qCtDiZuSSRHMS4DNSCx1BT6mrpskQwkZdF4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tdX3s73UqQuJyp0qg2D8dDRFehu3TsIJuSq+SigPvbKYviY1zlgjgEw3YE6CFNkmO
         AU9iJZ1xSEWJ6pjy4aPEq07F17ijONUWMmCgLN4SqpHFdhvXNA75N7BuRcMTfiLj+n
         Wx6jbvQZiYBiiRkorWf3vQO4wVjbPAPp81he0ozg=
Date:   Wed, 26 Oct 2022 18:58:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Cc:     linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        jason@zx2c4.com, saeed.mirzamohammadi@oracle.com
Subject: Re: [PATCH stable 0/5] Fix missing patches in stable
Message-ID: <Y1lnRm9NZDhIFhwU@kroah.com>
References: <20221017192006.36398-1-saeed.mirzamohammadi@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221017192006.36398-1-saeed.mirzamohammadi@oracle.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 17, 2022 at 12:20:01PM -0700, Saeed Mirzamohammadi wrote:
> The following patches has been applied to 6.0 but only patch#2 below
> has been applied to stable. This caused regression with nfs tests in
> all stable releases.
> 
> This patchset backports patches 1 and 3-6 to stable.
> 
> 1. 868941b14441 fs: remove no_llseek
> 2. 97ef77c52b78 fs: check FMODE_LSEEK to control internal pipe splicing
> 3. 54ef7a47f67d vfio: do not set FMODE_LSEEK flag
> 4. c9eb2d427c1c dma-buf: remove useless FMODE_LSEEK flag
> 5. 4e3299eaddff fs: do not compare against ->llseek
> 6. e7478158e137 fs: clear or set FMODE_LSEEK based on llseek function
> 
> For 5.10.y and 5.4.y only, a revert of patch#2 is already included.
> Please apply patch#2, for 5.4.y and 5.10.y as well.

I am sorry, I really do not understand here.

You list these commits in a specific order, yet the patches you send are
in a different order.

And they don't apply to 5.10 or older.

Can you resend proper patch series, for each stable branch that you want
these applied to, so that I can correctly queue them up?

thanks,

greg k-h
