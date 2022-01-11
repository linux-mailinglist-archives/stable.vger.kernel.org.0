Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0376448B46A
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 18:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344061AbiAKRuo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 12:50:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344022AbiAKRun (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 12:50:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C9DC06173F
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 09:50:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB7FC616FB
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 17:50:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8618CC36AE3;
        Tue, 11 Jan 2022 17:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641923442;
        bh=uxnffL6mtT/yv31+telqYg6YWVVyy0DzU4iUMt7T73c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pRLhr+7+/Zce2aE04oKAlMSAjzy2eFTcgJ/oyAUHnFrRL0zbut6l7jLCLND1JBKec
         9hW1ikKw8hV/bFJ0NihnvS/5lDvsbzR1LqqXUSN2bv9mBN5cvxeW1VRcwk/M/TgHQG
         q+1IBjAkSatgj8PiMrLHYCmsB2LdskKSECAMzR2I=
Date:   Tue, 11 Jan 2022 18:50:38 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Amy Fong <Amy_Fong@mentor.com>
Cc:     stable@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH 4.19 stable 0/5] Backport netfilter: nf_tables: autoload
 modules from the abort path
Message-ID: <Yd3DbmZ9kF6rY9bj@kroah.com>
References: <Yd2kKZEWm6AdBYDE@cat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yd2kKZEWm6AdBYDE@cat>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 11, 2022 at 10:37:13AM -0500, Amy Fong wrote:
> The following series backports netfilter: nf_tables: autoload modules from abort path
> which fixes the bug mentioned in the following:
> 
>    https://syzkaller.appspot.com/bug?extid=437bf61d165c87bd40fb
> 

Please fix up the subject lines to match the subject lines of the
patches you submited, and also properly sign off on the backport you did
here so that they can be accepted.  As-is, we can not take them.

thanks,

greg k-h
