Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC11152D35C
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 14:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238394AbiESM7a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 08:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238743AbiESM7Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 08:59:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2F262A3E
        for <stable@vger.kernel.org>; Thu, 19 May 2022 05:58:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10CB2B823E5
        for <stable@vger.kernel.org>; Thu, 19 May 2022 12:58:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F406C385AA;
        Thu, 19 May 2022 12:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652965136;
        bh=lFzjtGwIRVicuXFFs1tf9bbi0nrBSacAWIS+GJVUTpQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KxCHBvsFz6E+1r1NrCASyI2RDV3qrQCaNizISfrXc0zIKIxpeMnUPnY+mcMToQLLE
         vRkbadgPeoVS6gERQpKGN07Lkpe77YkZZjGd3FJAotqcBrU4idvD6PylvUapuonxX5
         JcbqP/Wf3oqPCeHT/N3I9iiT4LO6xplzbNwEYuMg=
Date:   Thu, 19 May 2022 14:58:54 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yu Liao <liaoyu15@huawei.com>
Cc:     stable@vger.kernel.org, liwei391@huawei.com, jani.nikula@intel.com
Subject: Re: [PATCH 5.10] Revert "drm/i915/opregion: check port number bounds
 for SWSCI display power state"
Message-ID: <YoY/DiESRWp4smNC@kroah.com>
References: <20220517124932.2241186-1-liaoyu15@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220517124932.2241186-1-liaoyu15@huawei.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 17, 2022 at 08:49:32PM +0800, Yu Liao wrote:
> This reverts commit b84857c06ef9e72d09fadafdbb3ce9af64af954f, as it's a
> duplicate of commit eb7bf11e8ef1 ("drm/i915/opregion: check port number
> bounds for SWSCI display power state").
> 
> Cc: stable@vger.kernel.org # v5.10+
> Signed-off-by: Yu Liao <liaoyu15@huawei.com>
> ---
>  drivers/gpu/drm/i915/display/intel_opregion.c | 15 ---------------
>  1 file changed, 15 deletions(-)

Someone sent this right before you did:
	https://lore.kernel.org/r/20220517000835.2450573-1-gthelen@google.com

I'll merge them together...

thanks,

greg k-h
