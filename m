Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C63BB4ED3C7
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 08:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbiCaGM2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 02:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiCaGM1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 02:12:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 488DA39B9D
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 23:10:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EEF8DB81F9D
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 06:10:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3393FC340ED;
        Thu, 31 Mar 2022 06:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648707038;
        bh=QICdryWtaWiU3eueFecZLNBfAJKcVaC/AbBx87DDOFE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0EU7J+Pw1oD9ygQ5dPIKsKupoLotrP0HtKiBEvIV2SPOBvJ+qzHqyctx96w+XXAvF
         IUk86DKD2OTMZqapstCGaG50viDWq5SI8eDHauUU8IAFlk6CwjFQrZujE+49BOjit3
         HBZS4R89Haatntyx+IKR/ce1SxtX2Sh7OBjs0vho=
Date:   Thu, 31 Mar 2022 08:10:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     jarkko@kernel.org, jgg@nvidia.com, jgg@ziepe.ca,
        stable@vger.kernel.org, stefanb@linux.ibm.com
Subject: Re: [PATCH for-4.14] tpm: fix reference counting for struct tpm_chip
Message-ID: <YkVF25nAXTmlg3hN@kroah.com>
References: <20220331022430.1937-1-LinoSanfilippo@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220331022430.1937-1-LinoSanfilippo@gmx.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 31, 2022 at 04:24:30AM +0200, Lino Sanfilippo wrote:
> commit 7e0438f83dc769465ee663bb5dcf8cc154940712 upstream.
> 
> The following sequence of operations results in a refcount warning:
> 

All now queued up, thanks.

greg k-h
