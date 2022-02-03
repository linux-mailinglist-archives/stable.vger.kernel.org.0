Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCB244A892C
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 17:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233754AbiBCQ72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 11:59:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiBCQ72 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 11:59:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21853C061714
        for <stable@vger.kernel.org>; Thu,  3 Feb 2022 08:59:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7792B834FC
        for <stable@vger.kernel.org>; Thu,  3 Feb 2022 16:59:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FFF7C340E8;
        Thu,  3 Feb 2022 16:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643907565;
        bh=LnHneESsTr9ZeTaZCx9F0eeahRB5B7DLcvZZ25AoyF0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wcs50vJ7XvqK0O72Xf0bJreGSEaFDQcYF3pHOB4piolyUKyq1uqTi0oL7iGS7wxRT
         /oIAvyxKNWMQnXkHK9qO2SwPcvDpDGrJsn0rX21yKpA37LvUVQ58CpWRPfzTeJdGtj
         B/ICFNledM2NrMG5N2yc1DarsQOBTGn9z3jFGZAE=
Date:   Thu, 3 Feb 2022 17:59:22 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Elder <elder@linaro.org>
Cc:     stable@vger.kernel.org, davem@davemloft.net, elder@kernel.org
Subject: Re: [PATCH 0/2] net: ipa: back-port concurrent replenish fix
Message-ID: <YfwJ6n/2MOMbXbpo@kroah.com>
References: <20220201011658.308283-1-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220201011658.308283-1-elder@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 31, 2022 at 07:16:56PM -0600, Alex Elder wrote:
> Attached are two patches that take the place of one IPA fix that was
> requested for back-port.  The original did not apply cleanly, so one
> prerequisite was back-ported, followed by the "real" fix.  They are
> built upon Linux v5.10.95.
> 
> I wasn't sure how I was supposed to indicate this was a manual
> back-port.  I added the upstream commit ID in each patch but it
> needs to be edited.  And I added a "References" tag indicating the
> e-mail to which this small series responds.
> 
> Please let me know if there's something else/more I should do.
> 
> Thanks.
> 
> 					-Alex
> 
> Alex Elder (2):
>   net: ipa: use a bitmap for endpoint replenish_enabled
>   net: ipa: prevent concurrent replenish
> 
>  drivers/net/ipa/ipa_endpoint.c | 20 ++++++++++++++++----
>  drivers/net/ipa/ipa_endpoint.h | 15 ++++++++++++++-
>  2 files changed, 30 insertions(+), 5 deletions(-)
> 
> -- 
> 2.32.0
> 

All now queued up, thanks!
