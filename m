Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2B964E63AD
	for <lists+stable@lfdr.de>; Thu, 24 Mar 2022 13:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241627AbiCXMyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Mar 2022 08:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234892AbiCXMyn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Mar 2022 08:54:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9074E5FFE
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 05:53:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49B20B823A6
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 12:53:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE8BC340EC;
        Thu, 24 Mar 2022 12:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648126389;
        bh=ZGqUepQyACLE7/CgPAKx0mmFpDbZjD49zHX3v4n9+CQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RC3AXFu3nTyvFuMuUWNSd0HD+bHiinzdvT+IrhNDHSuCvp2agvld0FA/S8KrSv2pt
         9PaIaGzyD/C0DjxrGCp1FWPPsOEB5JJiuPoT+O/8rxvu9QJhKzmeSeRuT5cBUh7/Vz
         nJvnaQ9EMqsSDUQGG97nsKAJzfaeeXr0LDnB8GAc=
Date:   Thu, 24 Mar 2022 13:53:06 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Chen Li <chenli@uniontech.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: Apply "exfat: avoid incorrectly releasing for root inode" to
 stable 5.10
Message-ID: <Yjxpss8oKlFwn/Jp@kroah.com>
References: <3943117e-b490-14e5-c72c-3a7db3cac061@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3943117e-b490-14e5-c72c-3a7db3cac061@linaro.org>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 21, 2022 at 09:23:07AM -0700, Tadeusz Struk wrote:
> Hi,
> Please apply 839a534f1e85 ("exfat: avoid incorrectly releasing for root inode")
> to stable 5.10.y
> Syzbot can still trigger a BUG:
> https://syzkaller.appspot.com/bug?id=0896bca762e93f26a3922dc0822313a7be65a3c1
> It is already applied to all versions above 5.10.

Now queued up, thanks.

greg k-h
