Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6068B5144F6
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 10:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346723AbiD2JC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 05:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234595AbiD2JC6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 05:02:58 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D03C12FE
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 01:59:41 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id E214B3200937;
        Fri, 29 Apr 2022 04:59:39 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Fri, 29 Apr 2022 04:59:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1651222779; x=1651309179; bh=FyVzxdCunU
        yC7+HO6G4rcC2ZAU4rFB2q2q/ZyQjxpBw=; b=NFHPynrHgwgQQQgmtwz6Md1cS2
        kHPOKJEhtVfjOSkOUmMuVjj/teOzV/suxERfD9kFS09zy0lHTwnsNA0l+on9+Orn
        guwC4CcIbzfQuHlqjTyde7GnvbSv85hwhApBUfcgr0A8/9ukqtQipm71V8I/Kibh
        fK307zzUcp2XBIWSEMtF/OZXT72vy8KxXP0470p2pOKmtRXQdCwQ0uG2YPLPWvAz
        xz7hSfL8lFIsvoR87Bx4JRPr4CeKsbJMd2oT0mjrb5Er4sdXcDWgsnbcg4kx4DWj
        EGY8Gbpewd6OS5pZ8JEF6mRdL/RqoFjaI26LfgxJzlyYFyi0QCJoB2URg5Ag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1651222779; x=
        1651309179; bh=FyVzxdCunUyC7+HO6G4rcC2ZAU4rFB2q2q/ZyQjxpBw=; b=w
        nJy7zFtbBlF99DOgESOYKCO6Zrf9YPHy8YdYEVzW7dbfmVHcXx+BI1FCnvEglT7q
        rdPHh0uhWGBMFjS7mYc3TH6cRD7qHkw+KtIoUz4OrfhybPXpAFAZsqDMmgCC13PK
        4cKg7A8jWWSWBu+VmopH+So1QAdCFvemh6P3EHDDB1vMNCEf/pa5yx63y3jqzsX0
        fkD663cs6hkvwNCyn2CF7T/sotdAiEFboVD3OZxM1ho20xs2ZBIHg5vFIZuOp1pF
        Zqt5LKtAbBHLShpO58c6jJlvoogFe9LQ+zujObZVzuzbnLDDbSSaSFjnYEnNmUrf
        Up+BQN9zMDPDY7sewwSlg==
X-ME-Sender: <xms:-6hrYsV_ZTn82PkAs4Z7mW755-NM3Y-t_8v6sm44VaJAGQLOEBKbVQ>
    <xme:-6hrYgmBlIivqU_vwP3bmicg7iYQpiWerJ2g-AsL2UXgB2jQSPJZCWwXBMCXH7SMS
    _vQ8xKS9jywWg>
X-ME-Received: <xmr:-6hrYgZf1Uz_NZk1d7uxBQ2F32qf4rTjnOAHSQXRer_k38hBqQBKcvWT_opyTZHi2FBW96zNlYxa4WVMpQt4crHX5dkZtd0r>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudelgddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeegheeuhe
    fgtdeluddtleekfeegjeetgeeikeehfeduieffvddufeefleevtddtvdenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:-6hrYrVFpHwLnNsIeD5rvlCzQ4rfAeGh8x9OWiGIH-yG-dje2lGU0w>
    <xmx:-6hrYmkQsh3b9W-jB1YynYZ6_StGnd0PkaSGzlU4vWaICiRjA1-TTg>
    <xmx:-6hrYgfvQU_aHqQoDl2s-w101YIE5Z28yS26UTZz1BE6wTCJuPjlig>
    <xmx:-6hrYrxhHb8zBA5itLKXryjfffimpz_A2jJdzuODmmumHyor-AqEWw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 29 Apr 2022 04:59:38 -0400 (EDT)
Date:   Fri, 29 Apr 2022 10:59:36 +0200
From:   Greg KH <greg@kroah.com>
To:     Samuel Mendoza-Jonas <samjonas@amazon.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.9-4.19] jbd2: fix use-after-free of transaction_t race
Message-ID: <Ymuo+HQlSm4aaBZH@kroah.com>
References: <20220426182702.716304-1-samjonas@amazon.com>
 <20220427163150.djuapjmnvtautt5x@u46989501580c5c.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427163150.djuapjmnvtautt5x@u46989501580c5c.ant.amazon.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 27, 2022 at 09:31:50AM -0700, Samuel Mendoza-Jonas wrote:
> On Tue, Apr 26, 2022 at 11:27:01AM -0700, Samuel Mendoza-Jonas wrote:
> > From: Ritesh Harjani <riteshh@linux.ibm.com>
> > 
> > commit cc16eecae687912238ee6efbff71ad31e2bc414e upstream.
> > 
> > jbd2_journal_wait_updates() is called with j_state_lock held. But if
> > there is a commit in progress, then this transaction might get committed
> > and freed via jbd2_journal_commit_transaction() ->
> > jbd2_journal_free_transaction(), when we release j_state_lock.
> > So check for journal->j_running_transaction everytime we release and
> > acquire j_state_lock to avoid use-after-free issue.
> > 
> > Link: https://lore.kernel.org/r/948c2fed518ae739db6a8f7f83f1d58b504f87d0.1644497105.git.ritesh.list@gmail.com
> > Fixes: 4f98186848707f53 ("jbd2: refactor wait logic for transaction updates into a common function")
> > Cc: stable@kernel.org
> > Reported-and-tested-by: syzbot+afa2ca5171d93e44b348@syzkaller.appspotmail.com
> > Reviewed-by: Jan Kara <jack@suse.cz>
> > Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>
> > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > [backport to 4.9-4.19 in original jbd2_journal_commit_transaction()
> >  location before the refactor in
> >  4f9818684870 "jbd2: refactor wait logic for transaction updates into a
> >  common function"]
> > Signed-off-by: Samuel Mendoza-Jonas <samjonas@amazon.com>
> > Fixes: 1da177e4c3f41524
> > Cc: stable@kernel.org # 4.9.x - 4.19.x
> > ---
> > While marked for 5.17 stable, it looks like this fix also applies to the
> > original location in jbd2_journal_commit_transaction() before it was
> > refactored to use jbd2_journal_wait_updates(). This applies the same
> > change there.
> 
> Jan kindly pointed out this was a false alarm:
> https://lore.kernel.org/all/20220427111726.3wdyxbqoxs7skdzf@quack3.lan/
> 
> So the existing patch is fine and these can be ignored!

Thanks for the update, now all dropped from my queue.

greg k-h
