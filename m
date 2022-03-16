Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5F14DB336
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 15:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243168AbiCPO2K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 10:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356799AbiCPO1v (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 10:27:51 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE08F39174
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 07:26:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 246C9CE1F94
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 14:26:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9733C340E9;
        Wed, 16 Mar 2022 14:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647440794;
        bh=JW6d5LJkYtWBuryX3EDJNepPYt1eYaCSXr2vEEtyRCQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C3BiPtAKtITlMJ3sNAkXDmllp06sGntMD9bba5DAnLXPCXEBaIbZbv0+cL0EkfBfh
         EtyO0j6TLOIkwilTuMOlU2zliSuJJe+7Ni/jSI8BKo772pjkhzdhOabeNs6nyKjEjw
         BlOQyQXtrSoF4xKLPgz7jQjnZn9rIfMvh6tn96fo=
Date:   Wed, 16 Mar 2022 15:26:31 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Cheng Jui Wang <cheng-jui.wang@mediatek.com>
Cc:     stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Waiman Long <longman@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-mediatek@lists.infradead.org,
        Eason-YH Lin <eason-yh.lin@mediatek.com>
Subject: Re: apply commit 61cc4534b655 ("locking/lockdep: Avoid potential
 access of invalid memory in lock_class") to linux-5.4-stable
Message-ID: <YjHzl3Arey7KH0CB@kroah.com>
References: <6eb2052f463d323b0a82e795d765afb9d5925f6e.camel@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6eb2052f463d323b0a82e795d765afb9d5925f6e.camel@mediatek.com>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 16, 2022 at 02:01:12PM +0800, Cheng Jui Wang wrote:
> Hi Reviewers,
> 
> This patch fixes a use-after-free error when /proc/lockdep is read by
> user after a lockdep splat.
> 
> I checked and I think this patch can be applied to stable-5.4 and
> later. 
> 
> commit: 61cc4534b6550997c97a03759ab46b29d44c0017
> Subject: locking/lockdep: Avoid potential access of invalid memory in
> lock_class

I do not see that commit id in Linus's tree, are you sure it is correct?

thanks,

greg k-h
