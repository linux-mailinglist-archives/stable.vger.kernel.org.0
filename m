Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 208974BC0C1
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 20:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238398AbiBRT54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 14:57:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236675AbiBRT5z (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 14:57:55 -0500
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A770318
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 11:57:37 -0800 (PST)
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 21IJvMhu025645
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Feb 2022 14:57:23 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 509BB15C0036; Fri, 18 Feb 2022 14:57:22 -0500 (EST)
Date:   Fri, 18 Feb 2022 14:57:22 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Greg KH <greg@kroah.com>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>, stable@vger.kernel.org,
        Zhang Yi <yi.zhang@huawei.com>
Subject: Re: [PATCH for 5.4 1/3] ext4: check for out-of-order index extents
 in ext4_valid_extent_entries()
Message-ID: <Yg/6IgszAcONwk0n@mit.edu>
References: <20220217225914.40363-1-leah.rumancik@gmail.com>
 <Yg9lLNWNa8FLLhdC@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yg9lLNWNa8FLLhdC@kroah.com>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Leah, thanks for doing the backport to 5.4!   And Greg, thanks for queuing them up.

I note that if we first cherry pick into 4.19.y a fix from 5.2 that
probably should have been cc'ed to stable to begin with:

0a944e8a6c66 ("ext4: don't perform block validity checks on the journal inode")

Leah's three backports to 5.4 will then apply to 4.19 LTS; I've run
regression tests with the cherry-pick of 0a944e8a6c66 and Leah's three
backports applied to 4.19.230, and the resulting kernel looks fine and
prevents a kernel crash when running ext4/054.

Greg, would you prefer that I send the patches for 4.19.y, or do you
have what you need to do the cherry pick (all of the cherry picks are
clean, and didn't require any manual resolution)?

Thanks!

						- Ted
