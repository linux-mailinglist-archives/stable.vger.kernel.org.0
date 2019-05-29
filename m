Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE95A2E1E1
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 18:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbfE2QFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 12:05:33 -0400
Received: from esa4.hc3370-68.iphmx.com ([216.71.155.144]:19132 "EHLO
        esa4.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbfE2QFd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 May 2019 12:05:33 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 May 2019 12:05:33 EDT
Authentication-Results: esa4.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none; spf=None smtp.pra=ian.jackson@citrix.com; spf=Pass smtp.mailfrom=Ian.Jackson@citrix.com; spf=None smtp.helo=postmaster@MIAPEX02MSOL01.citrite.net
Received-SPF: None (esa4.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  ian.jackson@citrix.com) identity=pra; client-ip=23.29.105.83;
  receiver=esa4.hc3370-68.iphmx.com;
  envelope-from="Ian.Jackson@citrix.com";
  x-sender="ian.jackson@citrix.com";
  x-conformance=sidf_compatible
Received-SPF: Pass (esa4.hc3370-68.iphmx.com: domain of
  Ian.Jackson@citrix.com designates 23.29.105.83 as permitted
  sender) identity=mailfrom; client-ip=23.29.105.83;
  receiver=esa4.hc3370-68.iphmx.com;
  envelope-from="Ian.Jackson@citrix.com";
  x-sender="Ian.Jackson@citrix.com";
  x-conformance=sidf_compatible; x-record-type="v=spf1";
  x-record-text="v=spf1 ip4:209.167.231.154 ip4:178.63.86.133
  ip4:195.66.111.40/30 ip4:85.115.9.32/28 ip4:199.102.83.4
  ip4:192.28.146.160 ip4:192.28.146.107 ip4:216.52.6.88
  ip4:216.52.6.188 ip4:23.29.105.83 ip4:162.221.156.50 ~all"
Received-SPF: None (esa4.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@MIAPEX02MSOL01.citrite.net) identity=helo;
  client-ip=23.29.105.83; receiver=esa4.hc3370-68.iphmx.com;
  envelope-from="Ian.Jackson@citrix.com";
  x-sender="postmaster@MIAPEX02MSOL01.citrite.net";
  x-conformance=sidf_compatible
IronPort-SDR: 5pdDhn2IRXvLsl9msgPahckjg86RyVj0Ohwd0gjdGHHQpto6JkkbEU8CE9qn25xrtTXhJ9C7O/
 eZNuFd/JoLiMtpH+Fq1bcW3NSGOjoakU8PsuPge6AllMBhFR7Y0hKWMpzqz1crF49H5Tw5pDqn
 N/AsiXDBGBjm2WI8mJ2VPdtoXp6lPbiwaFACOPWT4WQlSrvTYoRtwK63x4fWDy4GnEOSjwuh+g
 LNAy1SJxQ8tL9PezNlO/Jr9LjvlUAWDaFV1NXp8MC4Dl4kaBrdupYgwhRUdAoZcqwSQTqWWIIN
 rM4=
X-SBRS: 2.7
X-MesageID: 1052140
X-Ironport-Server: esa4.hc3370-68.iphmx.com
X-Remote-IP: 23.29.105.83
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.60,527,1549947600"; 
   d="scan'208";a="1052140"
From:   Ian Jackson <ian.jackson@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <23790.44034.186393.25330@mariner.uk.xensource.com>
Date:   Wed, 29 May 2019 16:57:54 +0100
To:     <stable@vger.kernel.org>
CC:     Jan Beulich <JBeulich@suse.com>, Wei Liu <wei.liu2@citrix.com>,
        Lars Kurth <lars.kurth@citrix.com>,
        Paul Durrant <Paul.Durrant@citrix.com>,
        "Stefano Stabellini" <sstabellini@kernel.org>,
        xen-devel <xen-devel@lists.xenproject.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Juergen Gross <jgross@suse.com>
Subject: Linux 3.18 no longer boots under Xen, Xen CI dropping it
In-Reply-To: <5CE2B0DA0200007800230A08@prv1-mh.provo.novell.com>
References: <E1hSRQF-0006xk-BS@osstest.test-lab.xenproject.org>
        <23778.34168.78221.110803@mariner.uk.xensource.com>
        <20190520114147.GU2798@zion.uk.xensource.com>
        <5CE2B0DA0200007800230A08@prv1-mh.provo.novell.com>
X-Mailer: VM 8.2.0b under 24.5.1 (i686-pc-linux-gnu)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Linux 3.18 no longer boots under Xen.

This has been true for over half a year.  The Xen project CI has been
sending automatic mails including bisection reports (see below).
I emailed Xen kernel folks and got no takers for fixing this.

Unless this is fixed soon, or at least someone shows some inclination
to investigate this regression, I intend to drop all testing of this
"stable" branch.  It has rotted and no-one is fixing it.

> >> > *** Found and reproduced problem changeset ***
> >> > 
> >> >   Bug is in tree:  linux 
> > git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
> >> >   Bug introduced:  6b1ae527b1fdee86e81da0cb26ced75731c6c0fa
> >> >   Bug not present: ba6984fc0162f24a510ebc34e881b546b69c553b
> >> >   Last fail repro: http://logs.test-lab.xenproject.org/osstest/logs/136574/ 
> > 
> > It seems that there is something wrong with the IGB driver.

Additionally, Jan Beulich writes:
> Which in turn reminds me of a patch of mine that was backported
> (and spotted by an earlier bisection), and that I've suggested
> (twice already iirc) was either backported in error, or without some
> further necessary changes. Iirc the stable tree maintainer for that
> branch was Cc-ed back then, and if so I'd conclude he doesn't care.

Thanks,
Ian.
