Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEC44DB4E9
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 16:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345637AbiCPPcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 11:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238657AbiCPPcg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 11:32:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B24DE6CA7E
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 08:31:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C5E3616DC
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 15:31:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C7BC340F3;
        Wed, 16 Mar 2022 15:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647444680;
        bh=9ctp6RO64kNLGedDE5QkD08/qc84M9aO0xsGgkUdehw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rbdgDUxuV20gBW39s5SKCt2nvq2SBNoQ4CZ8CvVauZuAhkOH6ykjfmVUJyK5lT2sS
         siH4lKCSC6pZY+c4rM2Cuf4+hXJA4gGUXrs7LdePLkGUS7LorSIXrgxrWUAeEFAtEH
         gN7mqVQsnmO3N3HccK2YMl4GaQmAThBpy0U5x/ZM=
Date:   Wed, 16 Mar 2022 16:31:17 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Waiman Long <longman@redhat.com>
Cc:     Cheng Jui Wang <cheng-jui.wang@mediatek.com>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-mediatek@lists.infradead.org,
        Eason-YH Lin <eason-yh.lin@mediatek.com>
Subject: Re: apply commit 61cc4534b655 ("locking/lockdep: Avoid potential
 access of invalid memory in lock_class") to linux-5.4-stable
Message-ID: <YjICxcNVK+1VBNtz@kroah.com>
References: <6eb2052f463d323b0a82e795d765afb9d5925f6e.camel@mediatek.com>
 <YjHzl3Arey7KH0CB@kroah.com>
 <ee1e2ab4-c498-c047-ad70-fc46b508fe74@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee1e2ab4-c498-c047-ad70-fc46b508fe74@redhat.com>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 16, 2022 at 10:38:04AM -0400, Waiman Long wrote:
> On 3/16/22 10:26, Greg KH wrote:
> > On Wed, Mar 16, 2022 at 02:01:12PM +0800, Cheng Jui Wang wrote:
> > > Hi Reviewers,
> > > 
> > > This patch fixes a use-after-free error when /proc/lockdep is read by
> > > user after a lockdep splat.
> > > 
> > > I checked and I think this patch can be applied to stable-5.4 and
> > > later.
> > > 
> > > commit: 61cc4534b6550997c97a03759ab46b29d44c0017
> > > Subject: locking/lockdep: Avoid potential access of invalid memory in
> > > lock_class
> > I do not see that commit id in Linus's tree, are you sure it is correct?
> 
> This commit is currently in the tip tree. It have not been merged into the
> mainline yet, though it should happen in the upcoming merge window.

As per the stable kernel rules, the commit has to be in Linus's tree
first.  Please email us again when that has happened.

thanks,

greg k-h
