Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D114C8A95
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 16:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727662AbfJBOI2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 10:08:28 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:37725 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726200AbfJBOI2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 10:08:28 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 0344B21FE9;
        Wed,  2 Oct 2019 10:08:27 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 02 Oct 2019 10:08:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=S
        4Y84XgwoSx4BWPKsd3lQggQKfTwq4swaYPybPi9ZwI=; b=U2BxenuNhxVPJKZp3
        34hV3r8FMY6NuLAUc+Bxt+bXem/SGqtwS1jZhXU2oYTL5y/SYU03SaK7i5KTZ9UW
        CNNjxym13fEUew5e16vMqemA67oE0gxtLP3X5GpkKRV7G0afcNrwQv/pSVADgrGC
        JdDspBQTWpLSmjx0Wib59Vsw+aZwTNmJdflyhWlE13NbtdweCZZK5QL2dsADKFxS
        aJ1Fi8L2VyyyVQWo824c5aOMBLQUagXaqU/9KLBcbstpNV0TzQhWAvc8D/z/uX2G
        ptt5IwuRD9gaBO+TfCeyRgkEsSsxYtuQGpp/cRseVPQRSKthOOOwCsUTMLWxAycS
        PMF0g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=S4Y84XgwoSx4BWPKsd3lQggQKfTwq4swaYPybPi9Z
        wI=; b=sXxjg+ID2B+3GGqGKkxfxQJ9uDYax6zFjEWCSJ5GVZGmpQnw7+JjePSFa
        YbzKeIaZCp1nGNDK/MSrq/+F5EAHh95As00ty/L/FH+Z8sggBO+xRUgOG7W75wQ5
        WoIxf5xPjNE+o6nERMDKvs19221JG37FXnrufiPd+59exR5TBWXr42GnbavCWbF3
        35xyRyAeMqinyYaFYjZg/Euz3bL8YZoqrviR5BDzW3EboPEZqtQy5P5qcPe4bInA
        5HiGnnOkt0fGJxNgwwbuA/ILn66FcqtDobjOeVy+1XrriHcRheQNlyhShtMBvHeX
        c8mduaM5t7YFvHLFUvLpoMzGcLOFw==
X-ME-Sender: <xms:Wq-UXWTe0cLYT5Uw8G3AX1v59Y22TC2yT6zcs-DFY_jdTnwpi6c59A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeeigdejfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjfgesthekredttderjeenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpehkvghrnhgvlh
    drohhrghdpghhithhlrggsrdgtohhmnecukfhppeekfedrkeeirdekledruddtjeenucfr
    rghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsth
    gvrhfuihiivgeptd
X-ME-Proxy: <xmx:Wq-UXWmJrAHhgrfo5zfPhMNbMvO5t41JvQr5tLrTwLQYGMfpedMRmw>
    <xmx:Wq-UXYUSms0n6dA0BWD5iw_89B1d7jrgUHTbApDp9a_WsZOwYnyShQ>
    <xmx:Wq-UXVwI7gMpRnHh7LaDqhdCSXMyvtbWzjJJn3HxAAxv80_Y9XlfBQ>
    <xmx:Wq-UXUUB18oCyHJdeS3WqNJLG3DPanG8hyCV28gtxfRqMdGdA0md6g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4C416D6005E;
        Wed,  2 Oct 2019 10:08:26 -0400 (EDT)
Date:   Wed, 2 Oct 2019 16:08:24 +0200
From:   Greg KH <greg@kroah.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Veronika Kabatova <vkabatov@redhat.com>,
        CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for
 kernel?5.4.0-rc1-643b3a0.cki (stable-next)
Message-ID: <20191002140824.GA1741376@kroah.com>
References: <cki.7E7289C905.6I9MGQOO2V@redhat.com>
 <20191002053202.GA1450924@kroah.com>
 <1062039737.2099822.1570016073892.JavaMail.zimbra@redhat.com>
 <20191002135627.GN17454@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191002135627.GN17454@sasha-vm>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 02, 2019 at 09:56:27AM -0400, Sasha Levin wrote:
> On Wed, Oct 02, 2019 at 07:34:33AM -0400, Veronika Kabatova wrote:
> > 
> > 
> > ----- Original Message -----
> > > From: "Greg KH" <greg@kroah.com>
> > > To: "CKI Project" <cki-project@redhat.com>
> > > Cc: "Linux Stable maillist" <stable@vger.kernel.org>
> > > Sent: Wednesday, October 2, 2019 7:32:02 AM
> > > Subject: Re: ❌ FAIL: Test report for kernel	5.4.0-rc1-643b3a0.cki (stable-next)
> > > 
> > > On Wed, Oct 02, 2019 at 12:27:24AM -0400, CKI Project wrote:
> > > >
> > > > Hello,
> > > >
> > > > We ran automated tests on a recent commit from this kernel tree:
> > > >
> > > >        Kernel repo:
> > > >        git://git.kernel.org/pub/scm/linux/kernel/git/sashal/linux-stable.git
> > > >             Commit: 643b3a097f86 - selftests: pidfd: Fix undefined
> > > >             reference to pthread_create()
> > > 
> > > That is 5.4-rc1?
> > > 
> > > Why are you sending those results to the stable list?
> > > 
> > > confused,
> > > 
> > 
> > Hi,
> > 
> > Sasha has requested to have stable-next tested and results sent to this list:
> > 
> > https://gitlab.com/cki-project/pipeline-data/commit/16e0c06addbe62c689782357673f69bb7dff4d9a
> 
> Greg, this is the stable-next thing we talked about at LPC; it's just a
> subset of linux-next of stable tagged commits to help us identify issues
> before it actually hits upstream.
> 
> I can drop the mails to stable@ if you'd like, but ideally it should
> only be one mail a day.

Ah, ok, I was thinking CKI was testing Linus's tree for some reason and
sending the results only to the stable list, which would be odd.  If
this is your stuff, and you get use out of it, that's fine with me, I'll
be quiet :)

thanks,

greg k-h
