Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4B1EEF5A5
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 07:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387658AbfKEGq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 01:46:59 -0500
Received: from wnew1-smtp.messagingengine.com ([64.147.123.26]:60489 "EHLO
        wnew1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387499AbfKEGq7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Nov 2019 01:46:59 -0500
X-Greylist: delayed 552 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Nov 2019 01:46:59 EST
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.west.internal (Postfix) with ESMTP id 0AEAE510;
        Tue,  5 Nov 2019 01:37:45 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 05 Nov 2019 01:37:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm2; bh=a
        mA4OfQY6jIOHWvNo9uopreXYqzH3tUXZCy7dRdBm+U=; b=NNSZVLp5Xqmw/xqTg
        neikrC7FssOd18JRIG16u23EVlJWVFXLN6UTCBW6Otujx3OLOipfCS4w4vmNh+Tf
        YoZFHZ64pB8/T81U+mCglgbT6SF+yXFjgh4IesARL8f7Mk5C5G4Ky8quMlul4AwH
        gPKkcP/GdzwoXRnPn6sVps1hQ8YjLDAlm5C7kfBz9GtFJdcE9rGDTjDQTcpzyp9q
        Zlac9bx81Q0iwMJc1HZXJhQCthwRcMsbAcXah3pmYqkYeVUGlsuj5q9UlXu/jMUm
        sW6Qc4+cEndsej5WEtZM1A350I7NZfnDjfEvo3GT470vV0DkqSeAYqUT/NBzd45x
        yKHzw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=amA4OfQY6jIOHWvNo9uopreXYqzH3tUXZCy7dRdBm
        +U=; b=ezD93bYKs5xpwBjkQfd/m4bc8ioeNZQJl8NRM09leBe5jz+lntJ7pqIEW
        PqoDKqY/SkoZNF/3SDOmFRyZobiqknabhy2bjkkwmGH3VyeYKgCPxv4jW9//rLz4
        YbXxRYU6eZd6ZwwtqGbgwSkLuvlejPLx6P0VjIhwLNXiZG2zCpfqvgAHfRTQjzFB
        zX3j1+SVoMnwCV0mf484ijfsiNevxJOjpGNNB0AYS0FvGkbO9kSY6pgY6/oOms2i
        hZfp8++1qfsNe3jFfcnAI4DXImme3h4UjlLU2+QZ9kIDZyMFKDoDtBr8YzIA4CZ3
        pB927JBAXLX2J18mRk8b07R22mOwQ==
X-ME-Sender: <xms:uRjBXXBu6PWlU7S8MHkM3GAKse7JrRCIrnxAxhnARaQAQlTzKGonzA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddugedgleekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    goufhprghmkfhpqdhouhhtucdlhedttddmnecujfgurhepfffhvffukfhfgggtugfgjggf
    sehtkeertddtreejnecuhfhrohhmpefirhgvghcumffjuceoghhrvghgsehkrhhorghhrd
    gtohhmqeenucffohhmrghinheptghkihdqphhrohhjvggtthdrohhrghdpkhgvrhhnvghl
    rdhorhhgnecukfhppeekgedrudegrddvtdegrdeinecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:uRjBXbGBs2GDvPVDJiLotLu2agcqRr0fPIpJX5RGpdAm7tzwQaEwdQ>
    <xmx:uRjBXZCsznswEJNJPj_dyJKrcwUDzdKK8Iqeyyv0Z5Urtc4yWSpHTg>
    <xmx:uRjBXbWtfaLAIOHv49OEl1muGm1bGilUycta8qC1rdYfyuk4uegVpA>
    <xmx:uRjBXTjK1MCJXV1XWCclONfsQinEMlxFInZww52d006FBSpTfXkynIZ3E00>
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        by mail.messagingengine.com (Postfix) with ESMTPA id EED18306005E;
        Tue,  5 Nov 2019 01:37:44 -0500 (EST)
Date:   Tue, 5 Nov 2019 07:37:43 +0100
From:   Greg KH <greg@kroah.com>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Stable queue: queue-5.3
Message-ID: <20191105063743.GA2581953@kroah.com>
References: <cki.A892DA5512.ND6HCOM1TZ@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cki.A892DA5512.ND6HCOM1TZ@redhat.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 05, 2019 at 01:14:35AM -0000, CKI Project wrote:
> 
> Hello,
> 
> We ran automated tests on a patchset that was proposed for merging into this
> kernel tree. The patches were applied to:
> 
>        Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>             Commit: 95180e47e77a - Linux 5.3.8
> 
> The results of these automated tests are provided below.
> 
>     Overall result: FAILED (see details below)
>              Merge: OK
>            Compile: OK
>              Tests: FAILED
> 
> All kernel binaries, config files, and logs are available for download here:
> 
>   https://artifacts.cki-project.org/pipelines/263687
> 
> One or more kernel tests failed:
> 
>     ppc64le:
>      ❌ Boot test
>      ❌ Boot test
> 
>     aarch64:
>      ❌ Boot test
>      ❌ Boot test
> 
>     x86_64:
>      ❌ Boot test
>      ❌ Boot test
>      ❌ Boot test
>      ❌ Boot test
>      ❌ Boot test
>      ❌ Boot test

Looks like something wrong on your end?
