Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C41044C69F3
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 12:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234748AbiB1LPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 06:15:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbiB1LOg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 06:14:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957AC723FD
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 03:10:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6E3D60A21
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 11:10:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC7FC340E7;
        Mon, 28 Feb 2022 11:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646046623;
        bh=vPeXBLNhnK5tAsrysu/2v37eZ64Rr8VnUms2OBUZIWA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MyiC8m+xjI830nBHJjQjM/z4xsV/rzr2+mT10nQHBGsXNtto9SyrXM4g+3lOvAnSE
         1LgxrnNeY4LTltkW59C98aqwRGqO5agYAu5A9ACt+BpaHoPauV0b+0SwqL/HztsP3J
         zVUueKr8iilryf3lBkf23qxOnDk3YqvS13HFj8lY=
Date:   Mon, 28 Feb 2022 12:10:20 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     stable@vger.kernel.org, Brett Creeley <brett.creeley@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH 1/2] ice: Fix race conditions between virtchnl handling
 and VF ndo ops
Message-ID: <YhytnJGxStO0Gai9@kroah.com>
References: <20220225202101.4077712-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220225202101.4077712-1-jacob.e.keller@intel.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 25, 2022 at 12:21:00PM -0800, Jacob Keller wrote:
> From: Brett Creeley <brett.creeley@intel.com>
> 
> commit e6ba5273d4ede03d075d7a116b8edad1f6115f4d upstream.
> 
> [I had to fix the cherry-pick manually as the patch added a line around
> some context that was missing.]

What stable tree(s) is this for?

Thanks,

greg k-h
