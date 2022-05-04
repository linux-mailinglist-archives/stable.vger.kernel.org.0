Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1BE51A349
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 17:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351946AbiEDPMa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 11:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351966AbiEDPM2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 11:12:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E9C220EF;
        Wed,  4 May 2022 08:08:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCE59B8263C;
        Wed,  4 May 2022 15:08:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A49C385A5;
        Wed,  4 May 2022 15:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651676927;
        bh=+j0OUKTRMVyAKDfkZwYch4G0nCOnoDspSMbkklbc/N4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fjcu0R6daCQsfHq6QS5Oe/XBjGKiWjVhAdWoUIGQQLELST7JLnrBCcfia7tkrc5m1
         exBTkr8PXHxbX/kzdbGsgzW4gW2cE3T591JI9jc+zm95PkZLN6ykixc0A3DCPJ6mVo
         AJ2+Lu5Ad/JUMkOWWmkqeZH+hAOqARMLBglNG/h8=
Date:   Wed, 4 May 2022 17:08:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Steve Capper <steve.capper@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] [Rebased for 5.4] mm, hugetlb: allow for "high"
 userspace addresses
Message-ID: <YnKW/h6yElTSBKB1@kroah.com>
References: <9367809ff3091ff451f9ab6fc029cef553c758fa.1651581958.git.christophe.leroy@csgroup.eu>
 <YnEyiYh/NIFJG16V@kroah.com>
 <9853ade6-3f32-7811-474e-2da2361af16c@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9853ade6-3f32-7811-474e-2da2361af16c@csgroup.eu>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 04, 2022 at 07:26:00AM +0000, Christophe Leroy wrote:
> 
> 
> Le 03/05/2022 à 15:47, Greg KH a écrit :
> > On Tue, May 03, 2022 at 02:47:11PM +0200, Christophe Leroy wrote:
> >> This is backport for linux 5.4
> >>
> >> commit 5f24d5a579d1eace79d505b148808a850b417d4c upstream.
> > 
> > Now queued up, thanks.
> > 
> 
> Looks like the robot has found a build failure, due to missing #include 
> <linux/sched/mm.h>
> 
> However, looking into it in more details, I think  we should just apply 
> the two following commits unmodified instead of modifying the original 
> commit:
> 
> 885902531586 ("hugetlbfs: get unmapped area below TASK_UNMAPPED_BASE for 
> hugetlbfs")
> 5f24d5a579d1 ("mm, hugetlb: allow for "high" userspace addresses")

Ok, thanks, I've done this now.

greg k-h
