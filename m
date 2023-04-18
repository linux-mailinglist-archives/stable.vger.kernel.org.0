Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3D96E5EE8
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 12:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbjDRKez (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 06:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbjDRKex (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 06:34:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26DEE86BB;
        Tue, 18 Apr 2023 03:34:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE66C62A27;
        Tue, 18 Apr 2023 10:34:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8229C433EF;
        Tue, 18 Apr 2023 10:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681814087;
        bh=d6mf8hQQA/TLtLKUsV4oB264U+bIK5MAkh67T3U9uNY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bFZfmYfBi0BRtBU5PBWGqrxCcy2U4rpKMSoNJf9iUREMdnajGCJcnUYXfwBhUIMZc
         UJNFMm/7NMOQWMRA9PtkLMZvlBs08zS79Q+sd00JCzWNmHRIxy4jpxDvd1Lop9d+O2
         KseCnO8H+P0XmN6z10WPuxsf9yeF42a4xCm3APXo=
Date:   Tue, 18 Apr 2023 12:34:44 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yang Bo <yyyeer.bo@gmail.com>
Cc:     stable@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        mszeredi@redhat.com, Yang Bo <yb203166@antfin.com>
Subject: Re: [PATCH 0/6] Backport several patches to 5.10.y
Message-ID: <2023041850-slicing-ancient-8203@gregkh>
References: <20230412041935.1556-1-yb203166@antfin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412041935.1556-1-yb203166@antfin.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 12, 2023 at 12:19:29PM +0800, Yang Bo wrote:
> Antgroup is using 5.10.y in product environment, we found several patches are
> missing in 5.10.y tree. These patches are needed for us. So we backported them
> to 5.10.y

As many of these are also missing in the 5.15.y and 6.1.y trees, we can
only take these if you have a series for all kernel trees as you do not
want anyone upgrading to a newer kernel tree and having a regression.

So please fix this up by sending patch series for all of the relevant
trees and then we can queue them up all at the same time.

thanks,

greg k-h
