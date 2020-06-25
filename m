Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D946620A87C
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 01:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbgFYXAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 19:00:00 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:13662 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405113AbgFYXAA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jun 2020 19:00:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1593126000; x=1624662000;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=yB/B0gDKdM8YH7lR8AWprFhhp+K1oz4g/rmbpDnJzXk=;
  b=dDuNOe5q8Y2wDN5mxAhzC1HNvJB7M+6F75PeNBMipAOcnP58quSmprE0
   O54YF/nZoPuY9H+255M9gUbJLAoa6qYPYRJOowHSKcuYQPPbmz9zdjZCN
   phZ6llYSgpIYJwWj8GTI1cwMKbWFTUFVkb4/FPZEnfUWta4djeUEDftkU
   0=;
IronPort-SDR: /nzw1gNGH51KORcn4nEIKYCLi/JG+G7hdl2/zGQsnAWiAR2X7OehkFes13P99qzfXFujeRqjJh
 mxxb6g52ocWQ==
X-IronPort-AV: E=Sophos;i="5.75,280,1589241600"; 
   d="scan'208";a="38497353"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-17c49630.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 25 Jun 2020 22:59:59 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-17c49630.us-east-1.amazon.com (Postfix) with ESMTPS id 6402FA246C;
        Thu, 25 Jun 2020 22:59:58 +0000 (UTC)
Received: from EX13D32UWB003.ant.amazon.com (10.43.161.220) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 25 Jun 2020 22:59:57 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D32UWB003.ant.amazon.com (10.43.161.220) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 25 Jun 2020 22:59:57 +0000
Received: from dev-dsk-yishache-2a-0a3e7335.us-west-2.amazon.com
 (172.19.44.166) by mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2 via Frontend Transport; Thu, 25 Jun 2020 22:59:57
 +0000
From:   <yishache@amazon.com>
To:     <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>
Subject: Request for inclusion on linux-4.14.y and linux-5.4.y
Date:   Thu, 25 Jun 2020 22:59:34 +0000
Message-ID: <20200625225935.16844-1-yishache@amazon.com>
X-Mailer: git-send-email 2.16.6
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

Can you please consider including the following patch in the stable linux-4.14.y and stable linux-5.4.y branch?

This is to fix CVE-2020-12655

d0c7feaf87678371c2c09b3709400be416b2dc62(xfs: add agf freeblocks verify in xfs_agf_verify)

Thanks,
Yishan Chen
