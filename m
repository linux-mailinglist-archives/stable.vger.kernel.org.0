Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 162013EB3EB
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 12:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240092AbhHMKTx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 06:19:53 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:60591 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240027AbhHMKTH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 06:19:07 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 9141A3200954;
        Fri, 13 Aug 2021 06:18:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Fri, 13 Aug 2021 06:18:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=anzC8ZRMZSWdfChkQsS28eBhKJx
        SGQXXEm17xUZ0I3E=; b=xB2b3ycI0wM1n4F3ChcHdwCKPlVEEtNs6GBUpcQld33
        lCmcw7aI7Kjloc1GrQiJWiHISQOzfF2JT/mfcSVTUBaBkfvwtH9E8Fb2Bgtkhdvi
        sCmnm9VuIGMvpL2xnBzOjFsd0HOD4mngrVyRXzNfKR+5wfSn29B7vZDNolWSixKx
        cbPTprIV7xsmKNxQsWhtlBUML5ZZ65xWtlN6ShOCxQt5jyokAGZovMoTYjc1k/OT
        2/Z5Enh2O4bP2ojYkw3NWYHlevccL5UpuBtL0b0fxWr1vrd4HLneTpew37lIeFqV
        iXU7RfsOqfuz2S2/UakwlloI85fw0ZP4L6Pyy1r9LEA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=anzC8Z
        RMZSWdfChkQsS28eBhKJxSGQXXEm17xUZ0I3E=; b=JgLIbQwubmvXBaf+q79hmP
        v6dj2mgQsItPK5JkLPy1TVOFaic1O2o0CRd98SBzufvvkbgju+SFyvPnujdHW3PR
        evoFlKC/+ERcWVnq0pkMbXkVNVEFy1SfFyYKSPL4cAp3DWbYM4xa9AThV8ArFRak
        DU4U03PurZx9NS9ISEW/wBdmIlogGU8wLSdfZHGuYIwsjW+kXr47RpqJAu2fkCde
        sHphwp/NyoIqvsGR+CIv7u68ALfw2387DO/d4fkIwPf7sajr6SOn5al1aNxv69Fl
        qH5JIjtVDsD9qYYL0Qypbg771gW/PyVghs/ENqVx/VOWrXmc7qpD8tQrVLgfte/g
        ==
X-ME-Sender: <xms:_0YWYTfKbFn8ffNxZtVge09o63lPRrRPT60WqT6KXKwsbNZ1G6axVw>
    <xme:_0YWYZOfqTVXT9cbrdU2PPJNI-b0l7xmBWGvY0r0P-kQ63ALQzZUwrYKyKVfKL2Xc
    h5wmbFa7zfbtw>
X-ME-Received: <xmr:_0YWYchbe8ucy52cYT_5-38b_iqpJBRNsAw-YtiYGh9Hgb1vcXpt7Fg-eRitf-cOL2S3mfZK6LBevW4wWbCi3LsyBfPGnPQX>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrkeehgddviecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:_0YWYU8wP8np0aO2ukKyB1mUmrBzc0G1y7uUU2N20LhWXqpYUIWRcg>
    <xmx:_0YWYftPZrx0W5ltkLFaveNrhwqtawoHMU9w_oRJKD-8xse-FCgN3Q>
    <xmx:_0YWYTEstgnxFxTdJOqulxPc_GLXvzP1qEAoDA56NFQ4Mw1ADMc9kg>
    <xmx:AEcWYTgrjXp9oCYXkS1kFoCMB_zKoPgzEEmyPPBuyUauPqPuxOounA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Aug 2021 06:18:39 -0400 (EDT)
Date:   Fri, 13 Aug 2021 12:18:27 +0200
From:   Greg KH <greg@kroah.com>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/7] make btrfs/153 sucessful on 5.4.y
Message-ID: <YRZG81GsaIblr/II@kroah.com>
References: <cover.1628845854.git.anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1628845854.git.anand.jain@oracle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 13, 2021 at 05:55:23PM +0800, Anand Jain wrote:
> Patch 1-2 and 5 helps to fix the conflicts smoothly.
> Patch 3-4 and 6 fixes the regression as reported by the
>                 test case btrfs/153 and comes from the below patch-set
>                 (btrfs: qgroup: Fix the long-existing regression of btrfs/153)
> Patch 7 fixes lockdep Warning as in the commit log now reported by
> the test case btrfs/153 on 5.4.y

All queued up, thanks!

greg k-h
