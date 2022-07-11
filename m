Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE0156D897
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 10:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiGKIpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 04:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiGKIox (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 04:44:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F83BDC
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 01:44:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E579161040
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 08:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC981C34115;
        Mon, 11 Jul 2022 08:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657529092;
        bh=f5MWZKVY20v5lVL2svf/A/lpLsy+s5x6DCT7o8eJKcs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AMQKmF35vUCihiLM/yUw35y6rou1BhMCiMNyvd0Rs0AuW5+VIiSX/3iSov631Bqih
         H1wqi6Br3lrrp/kl0xvop6PkLLXUd7WvbAtaMHm+eOAoGTg1xLGxSLGHPObghRCn+1
         KrFQCxTybbQZgEaAkQ0uWWBpvknm9X7596RGVmPs=
Date:   Mon, 11 Jul 2022 10:44:49 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     stable@vger.kernel.org, andrii@kernel.org, kuba@kernel.org
Subject: Re: [PATCH 5.15-stable] selftests/net: fix section name when using
 xdp_dummy.o
Message-ID: <YsvjAUpIl2WvPus4@kroah.com>
References: <20220711082538.38608-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711082538.38608-1-liuhangbin@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 11, 2022 at 04:25:38PM +0800, Hangbin Liu wrote:
> commit d28b25a62a47a8c8aa19bd543863aab6717e68c9 upstream.
> 
> Conflicts: there is no udpgro_frglist.sh as we haven't backport
> edae34a3ed92 ("selftests net: add UDP GRO fraglist + bpf self-tests")
> to 5.15-stable tree.

Now queued up,t hanks.

greg k-h
