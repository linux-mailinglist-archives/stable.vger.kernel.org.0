Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 585A05BA975
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 11:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbiIPJby (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 05:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiIPJbx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 05:31:53 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A19A9AA340;
        Fri, 16 Sep 2022 02:31:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 07DDCCE1D3C;
        Fri, 16 Sep 2022 09:31:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9954DC433C1;
        Fri, 16 Sep 2022 09:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663320709;
        bh=7UIk94apV2JSIdIma5XEPFCxVUCn/GILfJKzfsTJaio=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fs1QUPs+QAtV1YBowieVT20CQUENb6dMdn3sEnVjw9RYjeXcKo+ChmVyulmSRdFX9
         jZ+jU6KR9jeDEFOKaEo4VOF+m2tSqOCex0IdDejhYNWE6oKLr95uNOnelggWoh1IRi
         uqUiNhStkXvpiv+NqFQqiv76HsSIo8+qlQIUs8Og=
Date:   Fri, 16 Sep 2022 11:32:14 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     sean.wang@mediatek.com
Cc:     stable@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Deren Wu <deren.wu@mediatek.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 5.18] wifi: mt76: mt7921e: fix crash in chip reset fail
Message-ID: <YyRCnmmwSRxqf2Ww@kroah.com>
References: <3bb8b13686a6d3f62c4094385b24e38ac769a158.1663219683.git.objelf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3bb8b13686a6d3f62c4094385b24e38ac769a158.1663219683.git.objelf@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 15, 2022 at 01:32:10PM +0800, sean.wang@mediatek.com wrote:
> From: Deren Wu <deren.wu@mediatek.com>
> 
> commit fa3fbe64037839f448dc569212bafc5a495d8219 upstream.

5.18 is long end-of-life.  Remember you can see what kernels are active
on the front page of kernel.org

thanks,

greg k-h
