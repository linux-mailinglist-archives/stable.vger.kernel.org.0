Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAA963735DD
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 09:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbhEEHy5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 03:54:57 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:40637 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229741AbhEEHy5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 03:54:57 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id A9BDE170D;
        Wed,  5 May 2021 03:54:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 05 May 2021 03:54:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=tqjX2G6Zwz7EUAGtwKEhtdrTfdV
        eUGH2mRVc2RmleHM=; b=TSTj/MZKkwT0BIUHYcwlHBUJvwtdl9cTqA7t9MFMTWw
        ic/q/O76ATMOqo6cvu7JON69Hw+B8M31PJPKxKdvb2Z1IkbA3Wsqiqau2e6DIyTp
        NIrtttg2A+lEpDc7ApFbyefbaXkFBCWenh1QWmhwLkIvXASWjVKDVy9oHyfK+pGu
        wg3jyYn7kvF3nR26251bCCRN8sy5n2CO3pMnD23GER+lZ4tgrqvoEczLBoCRxmgC
        3wAwUWp51g2H3k2TO8jdnrCTb/4aBTENz+OFyEVeUZwCvUyeddsPHK/G3DpjFic8
        0Son+pqlqQiW19QbOl8LR5kgLl23CxswKWVZWiXCyZw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=tqjX2G
        6Zwz7EUAGtwKEhtdrTfdVeUGH2mRVc2RmleHM=; b=HXnyTvCcq1E8G4U0A3VEoU
        v5h749zUyo2Vz7OR3Ll+RBswgAHCFuQjQeaIVchCFcnb97X414Xl5PMfL+4irx3E
        9klF72pq2EXkyMBbKzyucvqPgbL6SS/GV0/cToxEL5dp8f8kBW3hM8RrGGPsmnqG
        ehWc0aZxKFWRVhhKTroZSX1JmNrMG4Y3ioHh5sh7M/eS7+pXkDHIqtKmjs0kUNFd
        uMfQS9gHhgg14jg4kj6na208crHae9p7moqXjF4posrAtlhmDq99DzP3KU4lZvhL
        Be3j2rD7YlaOD8Ahp5hu7T0enlamLdu0TBzSAMDubTSXkq7a7YB5AjIEBB4+Sizw
        ==
X-ME-Sender: <xms:F0-SYFiWCVTslhdmeIHXUI5RuNjTVpgg9lLIyQMEpiTy_7BpzvhTxg>
    <xme:F0-SYKAvPpbwNPZetb4m7gX0N3vMiCfJsP5ubBPohLNCn4KHLMKDWKWJhbzQol5Mi
    xDNUWqAp7aqQQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefjedguddvtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuhe
    ejgfffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:F0-SYFFfJHYiqGKnxiRysPsU3FbbBlTS_tdCkuBovZfXErxPUtKxeA>
    <xmx:F0-SYKTHrlx3eUKVgRtb98r3HSIpSIfmMR0dsYNwgY9W_khdPKxgvw>
    <xmx:F0-SYCwdPP3wBCWsZNXZgDWLakVDk8dLBdkRBbpZm_W2tyhRZ1QJiA>
    <xmx:GE-SYHqjkVIoX6V0D7jHIEHvPakyP6DTem8DPdeEe348TWvmRKFljQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed,  5 May 2021 03:53:59 -0400 (EDT)
Date:   Wed, 5 May 2021 09:53:57 +0200
From:   Greg KH <greg@kroah.com>
To:     Mark Pearson <markpearson@lenovo.com>
Cc:     stable@vger.kernel.org
Subject: Re: stable tree request - [PATCH] platform/x86: thinkpad_acpi:
 Correct thermal sensor allocation
Message-ID: <YJJPFfpsiMDhHBR2@kroah.com>
References: <ea996e9f-3727-fdb9-3c04-53898fa7655c@lenovo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea996e9f-3727-fdb9-3c04-53898fa7655c@lenovo.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 30, 2021 at 02:46:18PM -0400, Mark Pearson wrote:
> Hi maintainer,
> 
> I'm fairly new to contributing to the kernel and didn't know about the
> stable tree procedure so missed setting the CC:stable@vger.kernel.org in
> my patch submission; I'm following option 2 on the stable-kernel-rules
> guide.
> 
> Subject: [PATCH] platform/x86: thinkpad_acpi: Correct thermal sensor
> allocation
> 
> Upstream Commit ID: 6759e18e5cd8745a5dfc5726e4a3db5281ec1639
> 
> Reason: Some EC registers on Thinkpad machines were being incorrectly
> used as temperature sensors. One in particular was fooling thermald into
> thinking the system was hot when it wasn't, and keeping fans ramped up
> unnecessarily.
> 
> I've been requested by some distro's to get this fix into the stable
> tree to make it easier for them to then pull into their releases.
> If it's possible to add this to 5.11 and maybe 5.10 that would be
> appreciated.
> 
> Please let me know if you need anything or have any questions

Looks good, now queued up everywhere, thanks.

greg k-h
