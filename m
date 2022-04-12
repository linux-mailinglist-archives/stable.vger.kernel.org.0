Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED8E64FDD62
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 13:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236763AbiDLLJV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 07:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347062AbiDLLDn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 07:03:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004FE222B4
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 02:54:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6C5861901
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 09:54:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1640C385AF;
        Tue, 12 Apr 2022 09:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649757252;
        bh=lIyQG8gLjUG9lnHcGOepvk05O58BPqXpgSHPt0dZNVk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iABNB9F1FMDrs1eAIbnSdbL7TdaNFEmjjvds6GjRYa4F1a79nOeEd+asaRQVIl6TC
         kVxXDxkxQgOhTtxJpRxVa72ws0HZFKWDipn47GddYiKd3feG+JoVaLQYmzQzBGvTfu
         TEFWs/m4eEsmfg0AkPGIJNNGahYGL6M+ny79vaYg=
Date:   Tue, 12 Apr 2022 11:54:09 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "xujia (Q)" <xujia39@huawei.com>
Cc:     stable@vger.kernel.org, duoming@zju.edu.cn, linma@zju.edu.cn,
        davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH 5.10 1/2] hamradio: defer 6pack kfree after
 unregister_netdev
Message-ID: <YlVMQY+mDYmdeDKM@kroah.com>
References: <1649745544-19915-1-git-send-email-xujia39@huawei.com>
 <YlUmU+YrN69AQ37K@kroah.com>
 <a79e8c4a-e47a-eb94-e15f-471ffd6c1f70@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a79e8c4a-e47a-eb94-e15f-471ffd6c1f70@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A: http://en.wikipedia.org/wiki/Top_post
Q: Were do I find info about this thing called top-posting?
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Tue, Apr 12, 2022 at 04:50:23PM +0800, xujia (Q) wrote:
> Yes, They also need in 5.15.y.

Great, please provide backported patches for that series as well so that
we can then take these.

thanks,

greg k-h
