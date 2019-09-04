Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4C26A78C2
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 04:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbfIDCd3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 22:33:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43936 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727065AbfIDCd3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 22:33:29 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 16A8419D335;
        Wed,  4 Sep 2019 02:33:29 +0000 (UTC)
Received: from localhost (dhcp-12-130.nay.redhat.com [10.66.12.130])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 57F785C207;
        Wed,  4 Sep 2019 02:33:26 +0000 (UTC)
Date:   Wed, 4 Sep 2019 10:33:24 +0800
From:   Murphy Zhou <xzhou@redhat.com>
To:     Rachel Sibley <rasibley@redhat.com>
Cc:     Greg KH <greg@kroah.com>, CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Xiong Zhou <xzhou@redhat.com>
Subject: Re: ? FAIL: Test report for kernel 5.2.11-c3915fe.cki (stable)
Message-ID: <20190904023324.favaf5hkb3bghhto@XZHOUW.usersys.redhat.com>
References: <cki.EDBAAD9BB8.PJ4CXK5IUR@redhat.com>
 <20190903062434.GD16647@kroah.com>
 <98810f6d-3bff-61be-f6dd-d24902d497e3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98810f6d-3bff-61be-f6dd-d24902d497e3@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Wed, 04 Sep 2019 02:33:29 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 03, 2019 at 03:39:57PM -0400, Rachel Sibley wrote:
> The aarch64 system failed to boot the CKI kernel due to an infra failure,
> the xfs generic/114 test
> could be an intermittent issue, I'll let Xiong confirm.

Yes. "bus error" is usually related to hardware platform. It's not news on
aarch64.

Xiong

> 
> https://artifacts.cki-project.org/pipelines/140026/logs/ppc64le_host_1_xfstests_xfs_resultoutputfile.log
> 
> -Rachel
> 
> On 9/3/19 2:24 AM, Greg KH wrote:
> > On Mon, Sep 02, 2019 at 10:38:46PM -0400, CKI Project wrote:
> > > Hello,
> > > 
> > > We ran automated tests on a recent commit from this kernel tree:
> > > 
> > >         Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > >              Commit: c3915fe1bf12 - Linux 5.2.11
> > Same git commit id fails one test run but passes another?  You all might
> > want to look into this...
> > 
> 
