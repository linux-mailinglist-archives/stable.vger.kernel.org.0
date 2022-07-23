Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8AF57F012
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 17:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbiGWPZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 11:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237283AbiGWPZX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 11:25:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F2C66412;
        Sat, 23 Jul 2022 08:25:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B51FE60C20;
        Sat, 23 Jul 2022 15:25:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85DFC341C0;
        Sat, 23 Jul 2022 15:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658589920;
        bh=tQkEVIN5ISmej2VFxfxzefOD9+NGT3k6YyQxpo504+k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=z4smg4CnbhuPItpb61LljlhxzLMuVf5vrVZ33/jghgZH0ey6LQQbTl25XAgF0XdLR
         dw+pLL1vOcoBNbHmZzisIYt+a32mCRLSFADFPpWRg6Vf1NxXj9zfOFgsUxW8LmHYmv
         sf3Qdio5uZbwnf/EW7Wp28gJi9jhuZlas5cW8hkA=
Date:   Sat, 23 Jul 2022 17:25:06 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     stable@vger.kernel.org, linux-xfs@vger.kernel.org,
        amir73il@gmail.com
Subject: Re: [PATCH 5.15 v2 0/6] xfs stable candidate patches for 5.15.y
 (part 3)
Message-ID: <YtwS0l617OyO9Hop@kroah.com>
References: <20220721213610.2794134-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220721213610.2794134-1-leah.rumancik@gmail.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 21, 2022 at 02:36:04PM -0700, Leah Rumancik wrote:
> Hi again,
> 
> This set contains fixes from 5.16 to 5.17. The normal testing was run
> for this set with no regressions found.
> 
> Some refactoring patches were included in this set as dependencies:
> 
> bf2307b19513 xfs: fold perag loop iteration logic into helper function
>     dependency for f1788b5e5ee25bedf00bb4d25f82b93820d61189
> f1788b5e5ee2 xfs: rename the next_agno perag iteration variable
>     dependency for 8ed004eb9d07a5d6114db3e97a166707c186262d

All now queued up, thanks.

greg k-h
