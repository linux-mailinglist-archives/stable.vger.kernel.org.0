Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA18671416
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 07:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbjARG2a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 01:28:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbjARG0O (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 01:26:14 -0500
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567D759E54;
        Tue, 17 Jan 2023 22:15:44 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id D02E93200754;
        Wed, 18 Jan 2023 01:15:40 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 18 Jan 2023 01:15:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1674022540; x=1674108940; bh=TO/h+seJNV
        m05ESocJCN3sBSEDXTyJue366PaovnosU=; b=L12Sst7hILmrIGa7YMQHjxML+q
        b3iNKEYYO932Jov1SDdI1RltG12SRapSiXyLY7YJZv98mEc5p3f72ef0atNLO76P
        01HGt8yn9usYUTwsAti3eufTiQeLs+PJy0M0B8HQchL2ClY5UM4wWPsbZPDLYRLp
        cBiNfSw9D6H+lmkTWbxb8C+y7/8+lRMn4QXJlV4w+zVW6TU8IupsQoaK78zNJBl6
        RIIjFsGnXh9kzXHUiQPJIe2vNVfwenBesF83bI2T1ebiulXjbm5wGhWXTkUdGRA/
        VFzuKboIlb23ktdwpY7SjRD7OmD9aKDR+svSz5IysFOcjMFT8m9i8DS0uU1w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1674022540; x=1674108940; bh=TO/h+seJNVm05ESocJCN3sBSEDXT
        yJue366PaovnosU=; b=NccT6Rl2fq+081r7hEyhAv7tcmXShC7PwfT3k+onmMXc
        o06N6LCcYgbMx3gV0KGTBI5juFxdyESMGzApRKVnOEgHapBc5Eof7G9F9+F4ptuU
        lTZO7XzDDiugU0G5BOAK4MXB02D2EXjStJv69+pBaWTgyzNlMX1C2hdJZIl3XgEt
        bRxzaGWhlRhh33J07uKN+MNVVY8XuhwazHGORYca95dGZFeT7N1e/LPFnjpmGm8O
        ZQ+3ZJAGGMR61/AVjl/mwUG6sKzjlq/KfcZ9U1myZnd4fhqavwiJvTvR1ZcjHjh0
        niEojwmr9hndFcjP8oG2tDS06qCfL402X7C6Vhf3Iw==
X-ME-Sender: <xms:jI7HY3HabxRZ9qUvmR3hGmAip-Cu4nP0CSbmBSCVEPgtwcfLSMDjzg>
    <xme:jI7HY0WkA9h_OT5fl6YEC6XgSyw29t_wIzFL4WctnjAuDsTnGHEhJOKebw_fltnXK
    ySalCdQj761Aw>
X-ME-Received: <xmr:jI7HY5JHH3y-vYIJxfw6VDRCJVMsF5rttjlvJHwdQrEaWdDArlZGQPm7VcE4H8HnNxNFzmuJTQGfeymXhrAgq62U2Ws0BAWn45JKlg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedruddtjedgleeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvd
    evvdeljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:jI7HY1ERGs8iQH62f6Rt4-OOKe8redHBPl6fgNKzEnQMikqHYX5FYg>
    <xmx:jI7HY9Xplwoz2MRyQP90g1AqBpReKWVb8uZfn2HyVlFk6XPldt4fSA>
    <xmx:jI7HYwOKBsaKBsm8nQwg37iaQEMweiXFTX4QTiLmJscSyxm9bedOcA>
    <xmx:jI7HYzzCFZwpbzuxhrftNwYz9k5qXnEH2XYMjnm_B13qqmcdHjaovQ>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 18 Jan 2023 01:15:39 -0500 (EST)
Date:   Wed, 18 Jan 2023 07:15:38 +0100
From:   Greg KH <greg@kroah.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 5.15 00/10] ext4 fast-commit fixes for 5.15-stable
Message-ID: <Y8eOihLNlJuWCsp4@kroah.com>
References: <20230105071359.257952-1-ebiggers@kernel.org>
 <Y7a8B2+AjwxpmTfh@kroah.com>
 <Y8chUKeNaULEhM+V@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8chUKeNaULEhM+V@gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 17, 2023 at 10:29:36PM +0000, Eric Biggers wrote:
> Hi Greg,
> 
> On Thu, Jan 05, 2023 at 01:01:11PM +0100, Greg KH wrote:
> > On Wed, Jan 04, 2023 at 11:13:49PM -0800, Eric Biggers wrote:
> > > This series backports 6 commits with 'Cc stable' that had failed to be
> > > applied, and 4 related commits that made the backports much easier.
> > > Please apply this series to 5.15-stable.
> > > 
> > > I verified that this series does not cause any regressions with
> > > 'gce-xfstests -c ext4/fast_commit -g auto'.  There is one test failure
> > > both before and after (ext4/050).
> > 
> > All now queued up, thanks.
> > 
> > greg k-h
> 
> 
> It's too late to fix now, but the commits in 5.15-stable all use
> "Eric Biggers <ebiggers@kernel.org>" as the author instead of the From line in
> the patch itself.  For example, patch 1 became:
> 
> 	commit b0ed9a032e52a175683d18e2e2e8eec0f9ba1ff9
> 	Author: Eric Biggers <ebiggers@kernel.org>
> 	Date:   Wed Jan 4 23:13:50 2023 -0800
> 
> 	    ext4: remove unused enum EXT4_FC_COMMIT_FAILED
> 
> 	    From: Ritesh Harjani <riteshh@linux.ibm.com>
> 
> 	    commit c864ccd182d6ff2730a0f5b636c6b7c48f6f4f7f upstream.
> 
> For reference, the upstream commit is:
> 
> 	commit c864ccd182d6ff2730a0f5b636c6b7c48f6f4f7f
> 	Author: Ritesh Harjani <riteshh@linux.ibm.com>
> 	Date:   Sat Mar 12 11:09:46 2022 +0530
> 
> 	    ext4: remove unused enum EXT4_FC_COMMIT_FAILED
> 
> Do you know how this happened, and how it can be prevented in the future?  I
> think I sent everything out correctly, so I think this is something on your end.

Yes, this is on my end, sorry, my scripts mess this up when dealing with
mbox files and I missed having to edit the header "by hand" like I
normally do when it happens.

My fault,

greg k-h
