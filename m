Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68A09C49AB
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 10:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbfJBIiS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 04:38:18 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:57835 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726043AbfJBIiS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 04:38:18 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 0FB106A8;
        Wed,  2 Oct 2019 04:38:16 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 02 Oct 2019 04:38:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=M
        JOeQYKmPxytwLFGfjo+oxvewon/wQmgWT9GTQbsdsM=; b=PTszhciG6Np0ix/nb
        b62+ISam0hpGK6R8DGd8NU3Zyuzt6NzDwHmmGh9+r3x1SDeb5/zhwTSs7ZH2aOKb
        EnnBUlY1IxskOvdz8Sg4Tk7RHYMnPE3mqivhwysWE1BJcXy51VxzD+zAmDoKD21Z
        x43P7p8N/Um6B9ZeSfIkFCEgFSYNtoJi4JoD9akoqFfuKAlwiUXEUUTVCwqf5ME5
        SyUpSsXkXhB79Mg6WDFGQWsLh2tP+y5blpq1gEgBTLKCA1IAzZVGF3eRleMn+aQg
        z2p1vV0jwyV5Rh19pegaNE49SGP3tE4u6vUFUylwMoB9Z8/VKNHO5/6Zk/nYzheZ
        lKr8Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=MJOeQYKmPxytwLFGfjo+oxvewon/wQmgWT9GTQbsd
        sM=; b=e5k0LhH4aI2iX1Hzu6GbAB1RArw+9YD9T8lCzKpSZ7dcoj1XKje9yNSYx
        /eqdOiAxiYyAwQ8Wk9NhcMQvUST2Fw+lkUy2py8hiDC5ks6YFSZvyyYDQJ8g2ts7
        K70mVoSCewLUpHJUCn1RVYeWe4wIU+cnDMyI0jlqsdmlM1ffF4hH6gvBGGEsM5y9
        LNVgcIx53WlzGgar9dF+Ttf1NEoGBj8X1u5D8t1k0gmTO39Tt6yERdqnjirEj80T
        ZNAvkP/VSK9aGLPWfk00lO/BNVEEbbWIX10I4g1GuRknG1P+1cZ7ea78SrmSZP9j
        i3cRlUp0G1VQZ9gNLIKFly2zzTsTg==
X-ME-Sender: <xms:-GGUXQy4xMXY_B5VTxOhpfAB8xJ37vPrd19vVm4pQMJp1FTrg02OvQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeeigddtjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjfgesthekredttderjeenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpegtkhhiqdhprh
    hojhgvtghtrdhorhhgpdhkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrddu
    tdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenuc
    evlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:-GGUXR0BcfC-LSqMoDKpd2ZsauLHULPsOFQDzuQCrYOvSoA_YShPAA>
    <xmx:-GGUXYz1iKLgKBxbExAO-Kc6XDnTm4ae9SuaKqYiiOhCY_t2qvDNNQ>
    <xmx:-GGUXQEpsU3zjZ1CFVq6oKdPKU_yKkVkC_FDw7WMbMXuLG0V-dYnYw>
    <xmx:-GGUXbs3sphED_CG8bA61TXadV9HxeNgRjzm6fRnX8bmKzijF4Vxkw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 175B28005B;
        Wed,  2 Oct 2019 04:38:15 -0400 (EDT)
Date:   Wed, 2 Oct 2019 10:38:14 +0200
From:   Greg KH <greg@kroah.com>
To:     Jan Stancek <jstancek@redhat.com>
Cc:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>
Subject: Re: =?utf-8?B?4pyFIFBBU1M=?= =?utf-8?Q?=3A?= Test report for kernel
 5.3.3-9c30694.cki (stable)
Message-ID: <20191002083814.GC1687317@kroah.com>
References: <cki.ECF89BD220.LKQR1ETI6V@redhat.com>
 <872170480.3076676.1570004339611.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <872170480.3076676.1570004339611.JavaMail.zimbra@redhat.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 02, 2019 at 04:18:59AM -0400, Jan Stancek wrote:
> 
> 
> ----- Original Message -----
> > 
> > Hello,
> > 
> > We ran automated tests on a recent commit from this kernel tree:
> > 
> >        Kernel repo:
> >        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> >             Commit: 9c30694424ee - Linux 5.3.2
> > 
> > The results of these automated tests are provided below.
> > 
> >     Overall result: PASSED
> >              Merge: OK
> >            Compile: OK
> >              Tests: OK
> > 
> > All kernel binaries, config files, and logs are available for download here:
> > 
> >   https://artifacts.cki-project.org/pipelines/199450
> > 
> > Please reply to this email if you have any questions about the tests that we
> > ran or if you have any suggestions on how to make future tests more
> > effective.
> > 
> >         ,-.   ,-.
> >        ( C ) ( K )  Continuous
> >         `-',-.`-'   Kernel
> >           ( I )     Integration
> >            `-'
> > ______________________________________________________________________________
> > 
> > Compile testing
> > ---------------
> > 
> > We compiled the kernel for 3 architectures:
> > 
> >     aarch64:
> >       make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg
> > 
> >     ppc64le:
> >       make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg
> > 
> >     x86_64:
> >       make options: -j30 INSTALL_MOD_STRIP=1 targz-pkg
> > 
> > 
> > Hardware testing
> > ----------------
> > We booted each kernel and ran the following tests:
> > 
> >   aarch64:
> >       Host 1:
> >          ✅ Boot test
> >          ✅ Podman system integration test (as root)
> >          ✅ Podman system integration test (as user)
> >          ✅ Loopdev Sanity
> >          ✅ jvm test suite
> >          ✅ Memory function: memfd_create
> >          ✅ AMTU (Abstract Machine Test Utility)
> >          ✅ Ethernet drivers sanity
> >          ✅ Networking socket: fuzz
> >          ✅ Networking sctp-auth: sockopts test
> >          ✅ Networking: igmp conformance test
> >          ✅ Networking TCP: keepalive test
> >          ✅ Networking UDP: socket
> >          ✅ Networking tunnel: gre basic
> >          ✅ Networking tunnel: vxlan basic
> >          ✅ audit: audit testsuite test
> >          ✅ httpd: mod_ssl smoke sanity
> >          ✅ iotop: sanity
> >          ✅ tuned: tune-processes-through-perf
> >          ✅ Usex - version 1.9-29
> >          ✅ storage: SCSI VPD
> >          ✅ stress: stress-ng
> >          🚧 ✅ LTP lite
> >          🚧 ✅ CIFS Connectathon
> >          🚧 ✅ POSIX pjd-fstest suites
> >          🚧 ✅ Memory function: kaslr
> >          🚧 ✅ Networking bridge: sanity
> >          🚧 ✅ Networking MACsec: sanity
> >          🚧 ✅ Networking route: pmtu
> >          🚧 ✅ Networking tunnel: geneve basic test
> >          🚧 ✅ L2TP basic test
> >          🚧 ✅ Networking vnic: ipvlan/basic
> >          🚧 ✅ ALSA PCM loopback test
> >          🚧 ✅ ALSA Control (mixer) Userspace Element test
> >          🚧 ✅ trace: ftrace/tracer
> >          🚧 ✅ Networking route_func: local
> >          🚧 ✅ Networking route_func: forward
> >          🚧 ✅ Networking ipsec: basic netns transport
> >          🚧 ✅ Networking ipsec: basic netns tunnel
> > 
> >       Host 2:
> >          ✅ Boot test
> >          ✅ xfstests: ext4
> >          ✅ xfstests: xfs
> >          ✅ selinux-policy: serge-testsuite
> >          ✅ lvm thinp sanity
> >          ✅ storage: software RAID testing
> >          🚧 ✅ Storage blktests
> > 
> >   ppc64le:
> >       Host 1:
> >          ✅ Boot test
> >          ✅ Podman system integration test (as root)
> >          ✅ Podman system integration test (as user)
> >          ✅ Loopdev Sanity
> >          ✅ jvm test suite
> >          ✅ Memory function: memfd_create
> >          ✅ AMTU (Abstract Machine Test Utility)
> >          ✅ Ethernet drivers sanity
> >          ✅ Networking socket: fuzz
> >          ✅ Networking sctp-auth: sockopts test
> >          ✅ Networking TCP: keepalive test
> >          ✅ Networking UDP: socket
> >          ✅ Networking tunnel: gre basic
> >          ✅ Networking tunnel: vxlan basic
> >          ✅ audit: audit testsuite test
> >          ✅ httpd: mod_ssl smoke sanity
> >          ✅ iotop: sanity
> >          ✅ tuned: tune-processes-through-perf
> >          ✅ Usex - version 1.9-29
> >          🚧 ❌ LTP lite
> 
> ppc64le hit panic that appears to be fixed by:
>   41ba17f20ea8 ("powerpc/imc: Dont create debugfs files for cpu-less nodes")

Ok, now queued up, thanks!

greg k-h
