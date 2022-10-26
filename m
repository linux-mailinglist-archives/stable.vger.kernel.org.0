Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB1BA60E58E
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 18:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233441AbiJZQll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 12:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232773AbiJZQlk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 12:41:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 326246B8F5
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 09:41:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3A6B61F8A
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 16:41:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8BD8C433C1;
        Wed, 26 Oct 2022 16:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666802499;
        bh=ZrHGt36zubHPQ6ib6JDDuU7W2uKWdeua3iS+/oFPZp8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iqrP9bKBYBRdOqp6I1jWt6+N9YZoZ+0qOwW+GM7mOssnFfxjYF3tHQ38iPBsTrJt9
         jQPNTynFoVuSFC1WtgNMpN872ez/s3+Ktb/rNYut9BcASr4UEN2Y+9X3+48EkQU5Ms
         x8PUUpwDBW0cH7vACrVD/UpAWU03fqvbjn1AwYtk=
Date:   Wed, 26 Oct 2022 18:41:36 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Seth Jenkins <sethjenkins@google.com>
Cc:     stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH stable 4.19-5.19] mm: /proc/pid/smaps_rollup: fix no
 vma's null-deref
Message-ID: <Y1ljQBkfcCoLYTx+@kroah.com>
References: <20221026162438.711738-1-sethjenkins@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221026162438.711738-1-sethjenkins@google.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 26, 2022 at 12:24:38PM -0400, Seth Jenkins wrote:
> Commit 258f669e7e88 ("mm: /proc/pid/smaps_rollup: convert to single value
> seq_file") introduced a null-deref if there are no vma's in the task in
> show_smaps_rollup.
> 
> Fixes: 258f669e7e88 ("mm: /proc/pid/smaps_rollup: convert to single value seq_file")
> Signed-off-by: Seth Jenkins <sethjenkins@google.com>
> Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
> Tested-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> c4c84f06285e on upstream resolves this issue, but a fix must still be applied to stable trees 4.19-5.19.

And you need to document really really really well why we can not take
that upstream commit please.

Also note that 5.19.y is end-of-life.

Please fix up and resend.

thanks,

greg k-h
