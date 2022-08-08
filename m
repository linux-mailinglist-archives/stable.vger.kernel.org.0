Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0313D58C4DA
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 10:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbiHHIXR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Aug 2022 04:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231756AbiHHIXR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Aug 2022 04:23:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FF913DF2
        for <stable@vger.kernel.org>; Mon,  8 Aug 2022 01:23:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85CA660EFC
        for <stable@vger.kernel.org>; Mon,  8 Aug 2022 08:23:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4C0C433C1;
        Mon,  8 Aug 2022 08:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659946995;
        bh=Hu2pTWlXdL20lOyE0Z48rwJWmy9U7CbDFzntOcaxJOk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FJeGVaK/erm3TdqZP3/0N3DZH8InEMFmB18CufsRc/9WqIQnWT9GB7YtbTWP+scOo
         bxKpEH8CFEOwWzxb+0gv6zXQmzCFl66CtUhXmufaI2bM5rk26FGNwKut+JjxncaAeB
         /9BLBmOj2F8Zq06PR6sxWM45HBefMiGMTGucDSGw=
Date:   Mon, 8 Aug 2022 10:23:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     kernel test robot <rong.a.chen@intel.com>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        lkp <lkp@intel.com>
Subject: Re: Fwd: warning: stable kernel rule is not satisfied
Message-ID: <YvDH8FmikusK2yFy@kroah.com>
References: <2364552d-9b18-875a-484a-d54ee8b9b9ee@intel.com>
 <baf4e189-2302-ea9c-e905-4ebc33c1e937@intel.com>
 <7d749ba8-e1e7-6614-a5f6-abaeebd2691d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d749ba8-e1e7-6614-a5f6-abaeebd2691d@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 08, 2022 at 03:12:36PM +0700, Bagas Sanjaya wrote:
> On 8/8/22 09:51, kernel test robot wrote:
> > -------- Forwarded Message --------
> > Subject: warning: stable kernel rule is not satisfied
> > <snip>
> > 
> > Hi,
> > 
> > Thanks for your patch.
> > 
> > FYI: kernel test robot notices the stable kernel rule is not satisfied.
> > 
> > Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
> > Subject: [PATCH 5.10] block: fix null-deref in percpu_ref_put
> > Link: https://lore.kernel.org/stable/20220729065243.1786222-1-zhangwensheng%40huaweicloud.com
> > 
> > The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> > 
> 
> Sasha uses "[ Upstream commit <sha1> ]", so his syntax should be
> accepted, too.

That's not the "rule" that is being checked here at all from what I have
seen so far when this email has been sent out.

thanks,

greg k-h
