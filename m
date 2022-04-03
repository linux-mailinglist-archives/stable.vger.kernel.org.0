Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44FAB4F0956
	for <lists+stable@lfdr.de>; Sun,  3 Apr 2022 14:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357812AbiDCM3B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Apr 2022 08:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357503AbiDCM3B (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Apr 2022 08:29:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 973D32F032;
        Sun,  3 Apr 2022 05:27:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50675B80D2F;
        Sun,  3 Apr 2022 12:27:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5D3C340ED;
        Sun,  3 Apr 2022 12:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648988825;
        bh=zgNS5JeSbvVeyXlQEZUIkye/6ihd4vVdw1KPp14kaTs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n+N8X/elFnsdYCqzpfMNBDMYvA5W1lReaL39kP7Wp5RJXJ3FyskXLre8avFb4JFj/
         U6HN5f1ABQTY6yTniQ+8+pdyVjJOWMZK5VBQmmWq88jQVx/4oZIh8dKfCYi5Vo3QIe
         SupHOqxiqpE3OMChHVS4FlSF4exL826aoe7p13JQ=
Date:   Sun, 3 Apr 2022 14:26:34 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Chen Jingwen <chenjingwen6@huawei.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] [Rebased for 5.4] powerpc/kasan: Fix early region not
 updated correctly
Message-ID: <YkmSeqRUjqbH9dcX@kroah.com>
References: <fc39c36ea92e03ed5eb218ddbe83b34361034d9d.1648915982.git.christophe.leroy@csgroup.eu>
 <Ykl2C6DmSKWxlOWE@kroah.com>
 <fd2c0d7a-e194-1ce4-4a5f-2d66ae0d350a@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fd2c0d7a-e194-1ce4-4a5f-2d66ae0d350a@csgroup.eu>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Apr 03, 2022 at 11:54:55AM +0000, Christophe Leroy wrote:
> 
> 
> Le 03/04/2022 à 12:25, Greg KH a écrit :
> > On Sat, Apr 02, 2022 at 06:13:31PM +0200, Christophe Leroy wrote:
> >> From: Chen Jingwen <chenjingwen6@huawei.com>
> >>
> >> This is backport for 5.4
> >>
> >> Upstream commit 5647a94a26e352beed61788b46e035d9d12664cd
> > 
> > This is not a commit in Linus's tree :(
> > 
> 
> Oops. Don't know what I did, that's indeed the commit after I 
> cherry-picked it on top of 5.4.188 and before I modified it.
> 
> According to the mail you sent me yesterday to tell it FAILED to apply 
> on 5.4, the upstream commit is dd75080aa8409ce10d50fb58981c6b59bf8707d3

Can you resend with this fixed up please?

thanks,

greg k-h
