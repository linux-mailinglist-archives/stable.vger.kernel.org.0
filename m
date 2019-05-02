Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F34DE11AD6
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 16:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbfEBOIn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 10:08:43 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:58707 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726197AbfEBOIn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 10:08:43 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 24E2725C5D;
        Thu,  2 May 2019 10:08:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 02 May 2019 10:08:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=doE0/kyX7mhN/RCLEiqG9eVwYSj
        IWgautFdLrxJvRUg=; b=K/qqtZKAzcoh4ph0Lg0pYQWKfvJVcLQE4YcUueWtO3b
        qA6iJXOnt0xiRyGHmkyklQ08XwLGdoN1tEZMjZvS1uSKo0LCR7hOnm5ioVEKvTb2
        PznYEb3P9XN2th0XWf41qydNWKKhTtAe40nKwlW056GFa1BVTT3kQe+ww6H50vU9
        v8Vg5VrVOi74klGJmg+1Q+2RHsV9BTA9TUJWT+flLp19g3goOobZCxXjN0mz5eJ9
        ptS7HO+yZz+uZ5bm/XYDP5Q+jeLd3sfkUeUSVp+uFzSqCc9ozghrauG0YDrpmoCb
        muzEuA4fyVRxA7eL783jF43h5XIa7gsfQFcvhxUgpcg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=doE0/k
        yX7mhN/RCLEiqG9eVwYSjIWgautFdLrxJvRUg=; b=WrgNLsqs0suhWog7Emt77d
        QWQy7Q0pRHRnWfwqfrHpeCev9TcQHJvzK7TSJkarD7KwxTf0lg2+ZX/9zO79Qt1V
        eoyRtlfQlg1vlvnzZ2tSxc8XmCGQPAHMNfphRd4cA8UHHSy7Lwu6Q8bSEEJKgsXD
        lD40tGMF/HgsyyluqV/SEjdfm1b499Fr4uJq3xZnoJ+CdaWB3pOzvmhs6YCSwdel
        YVIxD8PaZDn0u27lPg42DbuCUHpp/msxgfQI/MxdDW7gsRwuJh+TNmv/5uq2Eywy
        P6LGsSPWOQwrqAVCSGeYewLKWB2y6rHSiB1dMfKMRMZQBtpARKy08CWlC4PQh+CQ
        ==
X-ME-Sender: <xms:6fnKXHWdfYA_mIlrccYwDoFnthtf0EBWXv9G5qXjTQcHatkW3AmhAA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrieelgdejhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucffohhmrghinhepkhgvrhhnvghlrd
    horhhgnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhho
    mhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:6fnKXGiGskPKocI_AteXPb9sAN-xDCYsOsSPmf2W5C4x3w-0kRF2NQ>
    <xmx:6fnKXIf8kwE-6brfeWFWqBMv-A4bL_qOQvMph9HEDg34v2MnPAEGhQ>
    <xmx:6fnKXJcHDqTjAyKrMhV9Oy6Ln5WewaUXp4DSe2Sh-SF4H9dmcmByfA>
    <xmx:6vnKXJhI3bLBOmwxAqsuSe3dnlPoeL8QB1geZ6neENShTF7PhNJF_A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 217B0E4544;
        Thu,  2 May 2019 10:08:41 -0400 (EDT)
Date:   Thu, 2 May 2019 16:08:38 +0200
From:   Greg KH <greg@kroah.com>
To:     Major Hayden <major@redhat.com>
Cc:     Stable <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2OIEZBSUw=?= =?utf-8?Q?=3A?= Stable queue: queue-5.0
Message-ID: <20190502140838.GA13141@kroah.com>
References: <cki.9E62F0CA7D.Y9JIG3XX5K@redhat.com>
 <48c70101-155e-a9cf-54b0-b7fbfa12a7b5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48c70101-155e-a9cf-54b0-b7fbfa12a7b5@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 02, 2019 at 07:39:14AM -0500, Major Hayden wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA256
> 
> On 5/2/19 7:32 AM, CKI Project wrote:
> > We ran automated tests on a patchset that was proposed for merging into this
> > kernel tree. The patches were applied to:
> > 
> >        Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
> >             Commit: d5a2675b207d - Linux 5.0.11
> > 
> > The results of these automated tests are provided below.
> > 
> >     Overall result: FAILED (see details below)
> >              Merge: OK
> >            Compile: FAILED
> > 
> > We attempted to compile the kernel for multiple architectures, but the compile
> > failed on one or more architectures:
> > 
> >            aarch64: FAILED (see build-aarch64.log.xz attachment)
> >            ppc64le: FAILED (see build-ppc64le.log.xz attachment)
> >              s390x: FAILED (see build-s390x.log.xz attachment)
> >             x86_64: FAILED (see build-x86_64.log.xz attachment)
> 
> Here's the relevant error output from the builds:

My fault, I messed up the backport.  Your builds are faster than mine :)

Should now be fixed up, thanks.

greg k-h
