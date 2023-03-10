Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8586B3BC4
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 11:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbjCJKMq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 05:12:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbjCJKMp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 05:12:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92F7E108C01
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 02:12:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49B16B82184
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 10:12:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 850CDC433D2;
        Fri, 10 Mar 2023 10:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678443161;
        bh=jJLMD96/c3Kc6fJ20REZjtcb6/OxiPj/Tep9783Wh7c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JX7lEVKumZwkmGxNdv/rOQ3mGZAKXJD7w2/GVpm0YQQiI1opMTPOFXy+uRJTMbNAg
         QezLGOrtvk6xS31PYIfMCqgnVh9SGdb0/CQ5MkNVgoMWPVKzw6+ES8tT4BccQyKdCS
         9AB0MROBkTKxuFzUc3QakE2O+EXeqBGks2t7gwa4=
Date:   Fri, 10 Mar 2023 11:12:39 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Cheng-Jui Wang <cheng-jui.wang@mediatek.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 00/10] Backport patches to fix lockdep splat in 6.1
Message-ID: <ZAsClzHcFVs+Hztr@kroah.com>
References: <20230303092347.4825-1-cheng-jui.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230303092347.4825-1-cheng-jui.wang@mediatek.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 03, 2023 at 05:23:22PM +0800, Cheng-Jui Wang wrote:
> These patches fix the lockdep splat reported in this thread:
> https://lore.kernel.org/lkml/20220822164404.57952727@gandalf.local.home/
> 
> 

Why not cc: all of the developers involved in this 00/10 email?

I would need approval from them to be able to take this.

Also, is the lockdep splat correct?  Or is it a false positive?  And if
correct, is it something that you can actually trigger somehow?

thanks,

greg k-h
