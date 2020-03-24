Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6FAC190CB6
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 12:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbgCXLrc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 07:47:32 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:35075 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727270AbgCXLrb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 07:47:31 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 8C9EB712;
        Tue, 24 Mar 2020 07:47:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 24 Mar 2020 07:47:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm3; bh=I
        Xm65KYZAxllVaPU5SpX440rZTHowCuyTMv9YYU3WX4=; b=cFCaubBvJMuOCgg2M
        zGpj4/5271lGmMw0UHkGL0h0FWGXfVe/or1KalJH6wgbKzmS52ua2kr5kBrpDqfs
        iRtlzfdWgFvtBNFC5GS0TCu4Jl9STdeMacd+vk9SUAO6S3or291o/DCyzePEDTp3
        mI6FsAguh6uLxTVpjhHWFhwUykDwHYa3A2AvwMCicZZnr4JXsQEhzxs/CK2rnzbM
        YDBSok5NcMCRTXANj1386RaATmNF0mh+gk0oQiridXbldCQLFlkYmaAJ3jPq+bOA
        H55zYcZN1mlFiMS494uCQ91JcEyzj59yqN7oL0oAW5SURC0iHkYFdTLvH2nEz1Ua
        gtwyQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=IXm65KYZAxllVaPU5SpX440rZTHowCuyTMv9YYU3W
        X4=; b=M2eJZfhgAQAYUILJWj1cdmpDXjSLGfqo+tuf3UKiL9UaaI9ar1aw7Swtf
        BcLQHmjURSfnnzVGAlELb2QJMJjYos7gzYLjh+rQwJTCu3ukW3V77yU1tNLO538e
        /T+SMFhZXtm6N0bO/zbzydoDCLRneZlZ9rYq4eWs9+CjdySIqEr4lbWuOD04Nu6b
        6QMt+9/LbOGssMitSSgkne62dDpGGSspQd847NbkVNp+3SRQsRajW2VD8OOJ7pgN
        f7A9xb+MTbKBhsazjUVQMbKblUvFa1y6AVif7XeZJW0QswTerKoKlenH+BLHwyNg
        Rzoj0N1EKPXS3Zc18M0F8FsojWKuA==
X-ME-Sender: <xms:UfN5XlR5X0Qg4WxD52Ijx0wG5vjFRD0cZj2dGVwvaVLyVpgbjy652A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehuddgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpehkvghrnhgvlh
    drohhrghdprghmrgiiohhnrgifshdrtghomhenucfkphepkeefrdekiedrkeelrddutdej
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvg
    hgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:UfN5XjAWPTYyD_LhMtjp9oqN842r5Mc3j6zQqPtFHfSUmCjnEYWWaw>
    <xmx:UfN5Xl1_3M-b3QsT49CFJby0jfUmOZpenbOuuSO3_gVQkqkvAG5FGA>
    <xmx:UfN5XhXSCroLwcfQH45itWYYt6K_qw4Lt2EvYWz8e_js64R0KP4etA>
    <xmx:UvN5Xj5zcglY6wMQlgWD21fA4IesADyS0HhNcUAUO1Kwrhln7PieJg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 796423280063;
        Tue, 24 Mar 2020 07:47:29 -0400 (EDT)
Date:   Tue, 24 Mar 2020 12:47:27 +0100
From:   Greg KH <greg@kroah.com>
To:     Veronika Kabatova <vkabatov@redhat.com>
Cc:     Memory Management <mm-qe@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        CKI Project <cki-project@redhat.com>,
        Jan Stancek <jstancek@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>
Subject: Re: =?utf-8?B?8J+SpSBQQU5JQ0tFRA==?= =?utf-8?Q?=3A?= Test
 report?for?kernel 5.5.12-rc1-8b841eb.cki (stable)
Message-ID: <20200324114727.GA2333047@kroah.com>
References: <cki.936A32626F.M0L95JS69X@redhat.com>
 <20200324062213.GA1961100@kroah.com>
 <970614328.15180583.1585048327050.JavaMail.zimbra@redhat.com>
 <20200324111819.GA2234211@kroah.com>
 <1768018191.15186361.1585050272846.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1768018191.15186361.1585050272846.JavaMail.zimbra@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 24, 2020 at 07:44:32AM -0400, Veronika Kabatova wrote:
> 
> 
> ----- Original Message -----
> > From: "Greg KH" <greg@kroah.com>
> > To: "Veronika Kabatova" <vkabatov@redhat.com>
> > Cc: "Memory Management" <mm-qe@redhat.com>, "Ondrej Mosnacek" <omosnace@redhat.com>, "Linux Stable maillist"
> > <stable@vger.kernel.org>, "CKI Project" <cki-project@redhat.com>, "Jan Stancek" <jstancek@redhat.com>, "LTP Mailing
> > List" <ltp@lists.linux.it>
> > Sent: Tuesday, March 24, 2020 12:18:19 PM
> > Subject: Re: 💥 PANICKED: Test report	for?kernel 5.5.12-rc1-8b841eb.cki (stable)
> > 
> > On Tue, Mar 24, 2020 at 07:12:07AM -0400, Veronika Kabatova wrote:
> > > 
> > > 
> > > ----- Original Message -----
> > > > From: "Greg KH" <greg@kroah.com>
> > > > To: "CKI Project" <cki-project@redhat.com>
> > > > Cc: "Memory Management" <mm-qe@redhat.com>, "Ondrej Mosnacek"
> > > > <omosnace@redhat.com>, "Linux Stable maillist"
> > > > <stable@vger.kernel.org>, "Jan Stancek" <jstancek@redhat.com>, "LTP
> > > > Mailing List" <ltp@lists.linux.it>
> > > > Sent: Tuesday, March 24, 2020 7:22:13 AM
> > > > Subject: Re: 💥 PANICKED: Test report for	kernel 5.5.12-rc1-8b841eb.cki
> > > > (stable)
> > > > 
> > > > On Tue, Mar 24, 2020 at 05:42:38AM -0000, CKI Project wrote:
> > > > > 
> > > > > Hello,
> > > > > 
> > > > > We ran automated tests on a recent commit from this kernel tree:
> > > > > 
> > > > >        Kernel repo:
> > > > >        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > > > >             Commit: 8b841eb697e1 - Linux 5.5.12-rc1
> > > > > 
> > > > > The results of these automated tests are provided below.
> > > > > 
> > > > >     Overall result: FAILED (see details below)
> > > > >              Merge: OK
> > > > >            Compile: OK
> > > > >              Tests: PANICKED
> > > > > 
> > > > > All kernel binaries, config files, and logs are available for download
> > > > > here:
> > > > > 
> > > > >   https://cki-artifacts.s3.us-east-2.amazonaws.com/index.html?prefix=datawarehouse/2020/03/23/502039
> > > > > 
> > > > > One or more kernel tests failed:
> > > > > 
> > > > >     ppc64le:
> > > > >      💥 xfstests - ext4
> > > > > 
> > > > >     aarch64:
> > > > >      ❌ LTP
> > > > > 
> > > > >     x86_64:
> > > > >      💥 xfstests - ext4
> > > > 
> > > > Ok, it's time I start just blacklisting this report again, it's not
> > > > being helpful in any way :(
> > > > 
> > > > Remember, if something starts breaking, I need some way to find out what
> > > > caused it to break...
> > > > 
> > > 
> > > Hi Greg,
> > > 
> > > do you have any specific suggestions about what to include to help you out?
> > > The linked console logs contain call traces for the panics [0]. Is there
> > > anything else that would help you with debugging those? We're planning on
> > > releasing core dumps, would those be helpful?
> > 
> > Bisection to find the offending commit would be best.
> > 
> 
> This is going to be really tricky for hard to reproduce bugs but we'll do
> some research on it, thanks!

I got about 8 "failed" emails today, it doesn't sound like it is hard to
reproduce.

And if you can't reproduce it, why would you expect me to know what is
going on?  :)

thanks,

greg k-h
