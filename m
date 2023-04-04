Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A10A56D59B4
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 09:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233585AbjDDHdH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 03:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbjDDHdG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 03:33:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E728C188
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 00:33:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78DBA62F80
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 07:33:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A3E3C433EF;
        Tue,  4 Apr 2023 07:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680593584;
        bh=SVoW6fS2Yskb3Jfsbp0DL4kY4JiLIV1ESqOaFK6eDOQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FIOVIQNgoIt6BG7rUKHZ4AEisITm6vMT6JT8svqPFazorrdDjDJKUm22iK5tUVXSb
         kdmtdwuJ/S9dOO0BE43HRJyIJsuL/ke3Ff11ipmrIGsGazA95ZMRbKbf7/iV8RpBD9
         6SVZJyoyNsO2RnyAC+4Jxa6ktaPuL/DRSRtnN9xg=
Date:   Tue, 4 Apr 2023 09:33:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     xiongxin <xiongxin@kylinos.cn>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] powercap: intel_rapl: Optimize rp->domains memory
 allocation
Message-ID: <2023040453-womanlike-neurosis-3b23@gregkh>
References: <20230404072209.676132-1-xiongxin@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404072209.676132-1-xiongxin@kylinos.cn>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 04, 2023 at 03:22:09PM +0800, xiongxin wrote:
> In the memory allocation of rp->domains in rapl_detect_domains(), there
> is an additional memory of struct rapl_domain allocated to prevent the
> pointer out of bounds called later.
> 
> Optimize the code here to save sizeof(struct rapl_domain) bytes of
> memory.
> 
> Test in Intel NUC (i5-1135G7).
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: xiongxin <xiongxin@kylinos.cn>
> Tested-by: xiongxin <xiongxin@kylinos.cn>
> ---
>  drivers/powercap/intel_rapl_common.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
