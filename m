Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B522190C42
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 12:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgCXLSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 07:18:24 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:40633 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726524AbgCXLSY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 07:18:24 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id DEBCE478;
        Tue, 24 Mar 2020 07:18:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 24 Mar 2020 07:18:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm3; bh=b
        YpuqIL/AtkoWotmoAVC3A6mVQ1cLQ31lCsa2WiArr4=; b=mtZxASndeR07nUt2G
        qQFEmXhQDJXx/igyrlJJg+iF/QCIpC9EGGXpGINC6dEtn+eV0xWzpmN067pfV4g7
        fRaTR+3LasA2WtmyZlC99kWmVjk868mboKulm5hP4VNfEaCB68ufBeylAB1d1uXC
        re63oim93C8/qX7u9T5a0Iw7zruI4On2Ll18hoWShFED7Vu2FPf0zknLlLJFyp0J
        +sWWsujjc+KSYDhYfFIM2jAitFgEacv+y55XKR6LW9yogjutqfTlku+iyMqKF2ss
        f+V/bb8OEyvPm340zUHz2/Pe8ICUvIjK9ltz55Qre+1eItH+i9B3RNGK2Pc8Ab6v
        RpqEA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=bYpuqIL/AtkoWotmoAVC3A6mVQ1cLQ31lCsa2WiAr
        r4=; b=rKmCo4RgKckXzDhMBlEsZ6VZduDUdr7N+HjWFAmDJGfkTIDjMOka1YNqz
        3VIOAa46QK2uPz4HlA0brDmwl19cpyUlYzc11/s3KFIwuIGTEB1bfMXbZWlzyN6U
        QkNdCzR2nGQbs3pvdlwOXh/BQtV6AwnV3xJr5jdr8aX2Phgl9CSKhbC90WSb6xC1
        ceDFqRt1TN1Y2ZH7V7avhFKeXyWyGdcnHExuPL53Te+L8clQNm6TdgXHWKQOVkMg
        zgQsImrW6Io3tHkTsI+EIQ4o4Aa0FlfUYEm29W2zPrYHGYFqodbGbcySZewEkIaA
        0p7KebUmFzoqICLvi66j7oLFfRNEw==
X-ME-Sender: <xms:fex5Xjr5KLkzhMjc9W5w-G8T1MYuXki93HqkZArFCcPMzHnJCJhPbg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehtddgudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpehkvghrnhgvlh
    drohhrghdprghmrgiiohhnrgifshdrtghomhenucfkphepkeefrdekiedrkeelrddutdej
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvg
    hgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:fex5XiFIsQcfm-21Wye2laRPqVfHsXf2cjydaGlL2tUteboItrPO7A>
    <xmx:fex5Xrhw7oXqj5I3k9_-wfEss2E2R2t7Gabp62U8NDqt7tMgQXU7Ng>
    <xmx:fex5XkP6D5xbyQggZQrBd4qkm2j6phNsbYiCMbyFiDZ23U_SnKn0NA>
    <xmx:fux5Xru4qcW-OBt536bcKrFQDB-IN49UxvUr5BRvxmPaK8uQF9mU3w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8AF363280060;
        Tue, 24 Mar 2020 07:18:21 -0400 (EDT)
Date:   Tue, 24 Mar 2020 12:18:19 +0100
From:   Greg KH <greg@kroah.com>
To:     Veronika Kabatova <vkabatov@redhat.com>
Cc:     CKI Project <cki-project@redhat.com>,
        Memory Management <mm-qe@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Jan Stancek <jstancek@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>
Subject: Re: =?utf-8?B?8J+SpSBQQU5JQ0tFRA==?= =?utf-8?Q?=3A?= Test report
 for?kernel 5.5.12-rc1-8b841eb.cki (stable)
Message-ID: <20200324111819.GA2234211@kroah.com>
References: <cki.936A32626F.M0L95JS69X@redhat.com>
 <20200324062213.GA1961100@kroah.com>
 <970614328.15180583.1585048327050.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <970614328.15180583.1585048327050.JavaMail.zimbra@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 24, 2020 at 07:12:07AM -0400, Veronika Kabatova wrote:
> 
> 
> ----- Original Message -----
> > From: "Greg KH" <greg@kroah.com>
> > To: "CKI Project" <cki-project@redhat.com>
> > Cc: "Memory Management" <mm-qe@redhat.com>, "Ondrej Mosnacek" <omosnace@redhat.com>, "Linux Stable maillist"
> > <stable@vger.kernel.org>, "Jan Stancek" <jstancek@redhat.com>, "LTP Mailing List" <ltp@lists.linux.it>
> > Sent: Tuesday, March 24, 2020 7:22:13 AM
> > Subject: Re: 💥 PANICKED: Test report for	kernel 5.5.12-rc1-8b841eb.cki (stable)
> > 
> > On Tue, Mar 24, 2020 at 05:42:38AM -0000, CKI Project wrote:
> > > 
> > > Hello,
> > > 
> > > We ran automated tests on a recent commit from this kernel tree:
> > > 
> > >        Kernel repo:
> > >        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > >             Commit: 8b841eb697e1 - Linux 5.5.12-rc1
> > > 
> > > The results of these automated tests are provided below.
> > > 
> > >     Overall result: FAILED (see details below)
> > >              Merge: OK
> > >            Compile: OK
> > >              Tests: PANICKED
> > > 
> > > All kernel binaries, config files, and logs are available for download
> > > here:
> > > 
> > >   https://cki-artifacts.s3.us-east-2.amazonaws.com/index.html?prefix=datawarehouse/2020/03/23/502039
> > > 
> > > One or more kernel tests failed:
> > > 
> > >     ppc64le:
> > >      💥 xfstests - ext4
> > > 
> > >     aarch64:
> > >      ❌ LTP
> > > 
> > >     x86_64:
> > >      💥 xfstests - ext4
> > 
> > Ok, it's time I start just blacklisting this report again, it's not
> > being helpful in any way :(
> > 
> > Remember, if something starts breaking, I need some way to find out what
> > caused it to break...
> > 
> 
> Hi Greg,
> 
> do you have any specific suggestions about what to include to help you out?
> The linked console logs contain call traces for the panics [0]. Is there
> anything else that would help you with debugging those? We're planning on
> releasing core dumps, would those be helpful?

Bisection to find the offending commit would be best.

thanks,

greg k-h
