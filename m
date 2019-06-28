Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A46855A465
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 20:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbfF1SoN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 14:44:13 -0400
Received: from outgoing-stata.csail.mit.edu ([128.30.2.210]:48163 "EHLO
        outgoing-stata.csail.mit.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726497AbfF1SoN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jun 2019 14:44:13 -0400
Received: from [4.30.142.84] (helo=[127.0.1.1])
        by outgoing-stata.csail.mit.edu with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.82)
        (envelope-from <srivatsa@csail.mit.edu>)
        id 1hgvr0-000SzO-Pl; Fri, 28 Jun 2019 14:44:10 -0400
Subject: [4.9.y PATCH 0/2] Backported fixes for 4.9 stable tree
From:   "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     Gen Zhang <blackgod016574@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, akaher@vmware.com,
        srinidhir@vmware.com, bvikas@vmware.com, amakhalov@vmware.com,
        srivatsab@vmware.com, srivatsa@csail.mit.edu
Date:   Fri, 28 Jun 2019 11:44:08 -0700
Message-ID: <156174741166.35119.4146896758297334152.stgit@srivatsa-ubuntu>
User-Agent: StGit/0.18
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

This patchset includes a few backported fixes for the 4.9 stable tree.
I would appreciate if you could kindly consider including them in the
next release.

Thank you!

Regards,
Srivatsa

---

Gen Zhang (2):
      ip_sockglue: Fix missing-check bug in ip_ra_control()
      ipv6_sockglue: Fix a missing-check bug in ip6_ra_control()


 net/ipv4/ip_sockglue.c   |    2 ++
 net/ipv6/ipv6_sockglue.c |    2 ++
 2 files changed, 4 insertions(+)
