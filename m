Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFFCE10AD48
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 11:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbfK0KKU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 05:10:20 -0500
Received: from mail.avm.de ([212.42.244.94]:50690 "EHLO mail.avm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbfK0KKU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 05:10:20 -0500
X-Greylist: delayed 443 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Nov 2019 05:10:19 EST
Received: from mail-notes.avm.de (unknown [172.16.0.1])
        by mail.avm.de (Postfix) with ESMTP;
        Wed, 27 Nov 2019 11:02:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
        t=1574848973; bh=bM7HJclnHitbSVl2mny3UXzuCplra0Tu4NKTA1ja5z0=;
        h=From:To:Cc:Subject:Date:From;
        b=c0/QUa9dhOa2zDdNJps0fnC5N+Qm9LfqnZCGRk0wbPslcosCwMLE3eRB/5qBfVnx1
         mAvR70S1TJBxTNFEN0qgwb96R2rAz8aVhfIa9EELJ1dnyD5TI1HQExne4KXDDptKXs
         DVw4UMpHrRBR5hhvSpR8juoU+SJNwNSnDJ9fbReo=
Received: from buildd.avm.de. ([172.16.0.225])
          by mail-notes.avm.de (IBM Domino Release 10.0.1FP3)
          with ESMTP id 2019112711025287-4798 ;
          Wed, 27 Nov 2019 11:02:52 +0100 
From:   Nicolas Schier <n.schier@avm.de>
To:     stable@vger.kernel.org
Cc:     Nicolas Schier <n.schier@avm.de>,
        Guillaume Nault <g.nault@alphalink.fr>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 0/1] Missing l2tp patch in v4.9.y series
Date:   Wed, 27 Nov 2019 11:02:48 +0100
Message-Id: <cover.1574846983.git.n.schier@avm.de>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ANIS1/AVM(Release 10.0.1FP3|August 09, 2019) at
 27.11.2019 11:02:52,
        Serialize by Router on ANIS1/AVM(Release 10.0.1FP3|August 09, 2019) at
 27.11.2019 11:02:52,
        Serialize complete at 27.11.2019 11:02:52
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 8bit
X-purgate-ID: 149429::1574848973-000004EC-6E50139F/0/0
X-purgate-type: clean
X-purgate-size: 593
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate: clean
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

the following l2tp patch originates from v4.14 and has been backported
to 3.16.y and 4.13.y but it is missing in the 4.9.y branch
(accidentally?).  As it applies cleanly to 4.9.y and as I couldn't find
any mails discouraging the inclusion into 4.9, I am now asking for
inclusion into 4.9.y.

Kind regards,
Nicolas


Guillaume Nault (1):
  l2tp: don't use l2tp_tunnel_find() in l2tp_ip and l2tp_ip6

 net/l2tp/l2tp_ip.c  | 24 +++++++++---------------
 net/l2tp/l2tp_ip6.c | 24 +++++++++---------------
 2 files changed, 18 insertions(+), 30 deletions(-)

-- 
2.24.0

