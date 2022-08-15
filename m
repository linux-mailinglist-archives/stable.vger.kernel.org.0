Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C39E592E42
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 13:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbiHOLi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 07:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbiHOLiZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 07:38:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2AF02494D
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 04:38:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FAD161167
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 11:38:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A69C433C1;
        Mon, 15 Aug 2022 11:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660563503;
        bh=00iWghXu1D8BGFfHNyrQsbQ26GA+h94ZxRBfNbIXA7g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kU3QwHmueOr4jIcgECpKsNb0gb2I85a9KO0t4UmgEQ+cBq2AD2CxjJELaMN7aVU9F
         pm+8v2UDHFXVTIgofOsTgj5iZWB93ZXft3YiGfmgT/AAWgDRF4KOfEyLghADVDyj6c
         qDNM3j6+kOfJefa64qVSQIfWHbPZ7N4iJsRZLQ2M=
Date:   Mon, 15 Aug 2022 13:38:20 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Petr Vorel <pvorel@suse.cz>
Cc:     stable@vger.kernel.org, linux-mm@kvack.org,
        Michal Hocko <mhocko@kernel.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        William Roche <william.roche@oracle.com>, ltp@lists.linux.it
Subject: Re: Backport d4ae9916ea29 ("mm: soft-offline: close the race against
 page allocation") to 4.14 and 4.9
Message-ID: <YvowLH8GvMxMWcHH@kroah.com>
References: <Yvopj0gK5Dg95u+b@pevik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yvopj0gK5Dg95u+b@pevik>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 15, 2022 at 01:10:07PM +0200, Petr Vorel wrote:
> Hi all,
> 
> I wonder if there was an attempt to backport d4ae9916ea29 ("mm: soft-offline:
> close the race against page allocation") from 4.19 to 4.14 and 4.9 (patch does
> not apply, haven't found anything on stable ML, nor in stable tree git,
> therefore I assume it was left as not easily fixable).

As it didn't apply, why not try creating a backport to test this
yourself?  I'll gladly accept such a thing into the trees if you make
it.

thanks,

greg k-h
