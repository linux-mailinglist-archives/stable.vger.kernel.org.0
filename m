Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04F742E1E3
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 18:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbfE2QGE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 29 May 2019 12:06:04 -0400
Received: from prv1-mh.provo.novell.com ([137.65.248.33]:52868 "EHLO
        prv1-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbfE2QGE (ORCPT
        <rfc822;groupwise-stable@vger.kernel.org:6:1>);
        Wed, 29 May 2019 12:06:04 -0400
Received: from INET-PRV1-MTA by prv1-mh.provo.novell.com
        with Novell_GroupWise; Wed, 29 May 2019 10:06:03 -0600
Message-Id: <5CEEADE80200007800233811@prv1-mh.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 18.1.1 
Date:   Wed, 29 May 2019 10:06:00 -0600
From:   "Jan Beulich" <JBeulich@suse.com>
To:     "Ian Jackson" <ian.jackson@citrix.com>
Cc:     "Lars Kurth" <lars.kurth@citrix.com>,
        "Paul Durrant" <paul.durrant@citrix.com>,
        "Wei Liu" <wei.liu2@citrix.com>,
        "Stefano Stabellini" <sstabellini@kernel.org>,
        "xen-devel" <xen-devel@lists.xenproject.org>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "Juergen Gross" <jgross@suse.com>, <stable@vger.kernel.org>
Subject: Re: Linux 3.18 no longer boots under Xen, Xen CI dropping it
References: <E1hSRQF-0006xk-BS@osstest.test-lab.xenproject.org>
 <23778.34168.78221.110803@mariner.uk.xensource.com>
 <20190520114147.GU2798@zion.uk.xensource.com>
 <5CE2B0DA0200007800230A08@prv1-mh.provo.novell.com>
 <23790.44034.186393.25330@mariner.uk.xensource.com>
In-Reply-To: <23790.44034.186393.25330@mariner.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>>> On 29.05.19 at 17:57, <ian.jackson@citrix.com> wrote:
> Linux 3.18 no longer boots under Xen.
> 
> This has been true for over half a year.  The Xen project CI has been
> sending automatic mails including bisection reports (see below).
> I emailed Xen kernel folks and got no takers for fixing this.
> 
> Unless this is fixed soon, or at least someone shows some inclination
> to investigate this regression, I intend to drop all testing of this
> "stable" branch.  It has rotted and no-one is fixing it.

Afaics 3.18 has been marked EOL upstream.

Jan


